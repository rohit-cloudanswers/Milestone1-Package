global with sharing class ApprovalProcessReminder implements Database.Batchable<sObject>, Database.Stateful, System.Schedulable {
    
    // if set to true, will not send to end users, 
    // will send to person who scheduled the job
    // so they can see what emails are being sent
    global Boolean debug = false;
    
    @TestVisible
    private List<Exception> errors = new List<Exception>();
    
    // do not change this between versions or it can't deschedule
    static final String JOB_NAME = 'Approval Process Reminder Job (Custom)';

    global Set<Id> allActorIds {get; set;}
    global Map<Id,List<ProcessInstanceWorkItem>> allPIWI {get; set;}
    
    global ApprovalProcessReminder(Set<Id> allActorIds){
        this.allActorIds = allActorIds;
        this.allPIWI = new Map<Id,List<ProcessInstanceWorkItem>>();
    }
    
    global ApprovalProcessReminder(){
         this.allPIWI = new Map<Id,List<ProcessInstanceWorkItem>>();
    }

    // batchable interface methods
    global Database.QueryLocator start(Database.BatchableContext BC){
        if (allActorIds != null && !allActorIds.isEmpty()) {
            return Database.getQueryLocator([
                select Id, Name, FirstName, Email, ManagerId
                from User
                where Id in :allActorIds
            ]);
        }
        return Database.getQueryLocator([
            select Id, Name, FirstName, Email, ManagerId
            from User

            // don't email inactive users since they probably have inactive email accounts too
            where IsActive = true

            // currently only doing this for internal users
            // maybe in the future we can extend this to community users
            // but definitely it should remind community users by default
            and UserType = 'Standard'
            
            // will support in later version, just want it as turn key as possible to start
            //and Receive_Daily_Approval_Reminders__c in (true, :(!Test.isRunningTest()))
        ]);
    }

    /*
    // can't remove global reference 
    global void execute(Database.BatchableContext BC, List<sObject> actors){
        System.assert(false, 'deprecated method');
    }
    */

    global void execute(Database.BatchableContext BC, List<User> users) {
        
        // reserve capacity for number of users
        try {
            Messaging.reserveSingleEmailCapacity(users.size());
        } catch (Exception e) {
            errors.add(e);
        }

        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();

        for(sObject u : users){
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setSaveAsActivity(false);
            
            // for dev testing
            if (this.debug == true) {
                msg.setToAddresses(new List<String>{UserInfo.getUserEmail()});
                msg.setCcAddresses(new List<String>{UserInfo.getUserEmail()});
            } else {
                msg.setTargetObjectId(u.Id);
                try {
                    for (User manager : [select Email from User where Id = :(Id)u.get('ManagerId') and Approval_Process_Manager_CC__c = true]) {
                        msg.setCcAddresses(new List<String> {manager.Email});
                    }
                } catch (Exception e) {
                    // don't stop if we can't cc the manager
                }
            }
            
            // include date in subject or they will thread in the user's inbox and they'll ignore it
            // TODO send email in destination user's locale
            msg.setSubject('Pending Approvals Reminders for ' + Datetime.now().format('EEEEEEEE, MMM d, yyyy'));

            Set<Id> actorIds = getActorIds(u.Id);
            ProcessInstanceWorkitem[] piwis = [
                select Id, ActorId, ElapsedTimeInDays,
                    Actor.FirstName, Actor.Email,
                    ProcessInstance.TargetObject.Id,
                    ProcessInstance.TargetObject.Name,
                    ProcessInstance.CreatedDate,
                    ProcessInstance.ElapsedTimeInDays
                from ProcessInstanceWorkitem 
                where ProcessInstance.Status not in ('Approved', 'Completed')
                and ProcessInstance.ProcessDefinition.Name != 'KBWorkflow'
                and ActorId in :actorids
            ];
            sbaa__Approval__c[] advancedApprovals = [
                select Id, Name, CreatedDate, Quote__r.Name, sbaa__Opportunity__r.Name, Opportunity_Name__c from sbaa__Approval__c 
                where sbaa__AssignedTo__c in :actorIds
                and sbaa__Status__c = 'Requested'
                order by CreatedDate asc
            ];

            // don't send empty emails
            if (piwis.isEmpty() && advancedApprovals.isEmpty()) continue;

            msg.setHtmlBody('Hi ' + u.get('Name') + ',\n\n' + emailBody(piwis, advancedApprovals));
            
            lstMsgs.add(msg);
        }

        if (!lstMsgs.isEmpty()){
            try {
                Messaging.sendEmail(lstMsgs);
            } catch (Exception e) {
                errors.add(e);
            }
        }
    }

    global void finish(Database.BatchableContext BC){
        if (!errors.isEmpty()) {
            Messaging.reserveSingleEmailCapacity(1);
            // tell the admin about any errors that happened
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            // include date in subject or they will thread in the user's inbox and they'll ignore it
            // TODO send email in destination user's locale
            msg.setSubject('Pending Approvals Reminders for ' + Datetime.now().format('EEEEEEEE, MMM d, yyyy'));
            msg.setTargetObjectId(UserInfo.getUserId());
            String emailBody = 'Errors during approval process reminder:<br/><br/><ul>';
            for (Exception e : this.errors) {
                emailBody += '<li>' + e + '</li>';
            }
            emailBody += '</ul>';
            emailBody += '<br/><br/>This email is sent to the admin if any errors occur when sending approval reminders.';
            emailBody += '<br/><br/>Difficult in figuring out the problem?  Send us an email: help@cloudanswers.com';
            msg.setHtmlBody(emailBody);
            msg.setSaveAsActivity(false);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{msg});
        }
    }
    
    // schedulable interface methods
    global void execute(SchedulableContext SC) {
        runBatch();
    }

    // helper methods

    /**
     * Gets all queue memberships for a user so we can find ALL approvals they can approve
     * it's recursive because groups can be within groups (not common but happens)
     * @return unique list of actor ids: user id, ...group ids)
     */
    @TestVisible
    private static Set<Id> getActorIds(Id userId) {
        System.assert(String.isNotBlank(userId), 'user id is required');
        Set<Id> result = new Set<Id>{userId};
        for (Integer i=0; i<9; i++) {
            Boolean done = true;
            for (GroupMember gm : [
                select Id, GroupId 
                from GroupMember 
                where UserOrGroupId in :result
            ]) {
                done = false;
                result.add(gm.GroupId);
            }
            if (done) break;
        }
        return result;
    }

    @TestVisible
    private Set<Id> getUsers(Id actorId ){
        Set<Id> userIds = new Set<Id>();
        if(actorId != null){
            if(actorId.getSobjectType() == User.getSobjectType() ){
               userIds.add( actorId ) ;
            }else{
                Set<Id> qIds = new Set<Id>{actorId};
                while(true){
                    Set<Id> newQIds = new Set<Id>();
                    for(GroupMember queueUser : [SELECT UserOrGroupId 
                        FROM GroupMember 
                        WHERE GroupId IN :qIds ]){
                        if(queueUser.UserOrGroupId.getSobjectType() == Group.getSobjectType() ){
                            newQIds.add(queueUser.UserOrGroupId);
                        }else if(queueUser.UserOrGroupId.getSobjectType() == User.getSobjectType()){
                             userIds.add(queueUser.UserOrGroupId);
                        }
                    }
                    if(newQIds.size()<=0){
                        break;
                    }else{
                        qIds = new Set<Id>(newQIds);
                    }
                }
            }
        }
        Map<Id,User> activeUsers = new Map<Id,User>([select Id 
            from User 
            where IsActive = true
            and UserType = 'Standard'
            and Id in :userIds]);
        return activeUsers.keySet();
    }

    public static void schedule () {
        ApprovalProcessReminder m = new ApprovalProcessReminder();
        String sch = '0 0 0 * * ?';
        String jobID = system.schedule(JOB_NAME, sch, m);
    }

    public static void deschedule () {
        for (CronTrigger ct : [SELECT CronJobDetail.Name FROM CronTrigger where CronJobDetail.Name = :JOB_NAME]) {
            System.abortJob(ct.Id);
        }
    }
    
    public static void runBatch () {
        Database.executeBatch(new ApprovalProcessReminder(), 10);
    }

    public static void runBatch (Set<Id> actorIds) {
        Database.executeBatch(new ApprovalProcessReminder(actorIds), 10);
    }

    public static Boolean getIsScheduled () {
        return ![SELECT CronJobDetail.Name FROM CronTrigger where CronJobDetail.Name = :JOB_NAME].isEmpty();
    }
    
    public static Boolean getIsRunning () {
        return ![SELECT Id from AsyncApexJob where ApexClass.Name = :JOB_NAME and JobType = 'BatchApex' and Status in ('Holding', 'Queued', 'Preparing', 'Processing')].isEmpty();
    }
    
    @TestVisible
    private static String emailBody (ProcessInstanceWorkItem[] piwis, sbaa__Approval__c[] advancedApprovals) {
        String email = '<p>You have approvals waiting, just click the link to open them:</p><ul>';
        Boolean hasItem = false;
        for (sbaa__Approval__c aa : advancedApprovals) {
            Integer daysOld = aa.CreatedDate == null ? 0 : aa.CreatedDate.date().daysBetween(Date.today());
            String timeWaiting = daysOld >= 1 ? (daysOld + ' days') : 'new!';
            email += '<li><a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + '/lightning/n/AXIA_AdvancedApprovals1' + '">' + aa.Name + ' / ' + aa.Quote__r.Name + ' / ' + aa.Opportunity_Name__c + '</a> (' + timeWaiting + ')</li>';
            hasItem = true;
        }
        for (ProcessInstanceWorkitem piwi : piwis) {
            String timeWaiting = piwi.ElapsedTimeInDays > 0.6 ? 
                (Math.round(piwi.ElapsedTimeInDays) + ' days') :
                'new!';
            email += '<li><a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + piwi.ProcessInstance.TargetObject.Id + '">' + piwi.ProcessInstance.TargetObject.Name + '</a> (' + timeWaiting + ')</li>';
            hasItem = true;
        }
        email += '</ul>';
        // add our footer for the free beta package
        // email += '<br/><br/><br/><a href="https://www.cloudanswers.com?utm_source=ApprovalProcessReminderEmail">Sent from the free CloudAnswers.com Approval Process Reminders App</a>';
        return hasItem ? email : '';
    }

}