global with sharing class TimeSheetController {
 
    @RemoteAction
    global static Map<String, List<SObject>> getUserTasks(){
        Map<String, List<SObject>> data = new Map<String, List<SObject>>();
        List<SObject> tasks = new List<SObject>();
        Set<Id> projectIds = new Set<Id>();
        
        Set<Id> taskIds = new Set<Id>();
        for (MPM4_BASE__Milestone1_Task_Resource__c taskResource : [
            select MPM4_BASE__Task__c from MPM4_BASE__Milestone1_Task_Resource__c 
            where MPM4_BASE__Resource__r.MPM4_BASE__User__c = :UserInfo.getUserId()
            and MPM4_BASE__Task__r.MPM4_BASE__Complete__c = false
            and MPM4_BASE__Task__r.MPM4_BASE__Project_Milestone__r.MPM4_BASE__Complete__c = false 
            and MPM4_BASE__Task__r.MPM4_BASE__Project_Milestone__r.MPM4_BASE__Project__r.Project_Stage__c != 'Complete' 
            and MPM4_BASE__Task__r.MPM4_BASE__Project_Milestone__r.MPM4_BASE__Project__r.Project_Stage__c != 'Cancelled'
          ]) {
            taskIds.add(taskResource.MPM4_BASE__Task__c);
        }
        
        for(MPM4_BASE__Milestone1_Task__c t : [select Id, Name, 
                                               MPM4_BASE__Project_Milestone__c, MPM4_BASE__Project_Milestone__r.MPM4_BASE__Project__c
                                               from MPM4_BASE__Milestone1_Task__c 
                                               where (MPM4_BASE__Assigned_To__c = :UserInfo.getUserId() 
                                                      or MPM4_BASE__Resource__r.MPM4_BASE__User__c = :UserInfo.getUserId()
                                                      or Id IN :taskIds
                                                      or MPM4_BASE__Project_Milestone__r.MPM4_BASE__Project__r.Name = 'Admin Project') 
                                               and MPM4_BASE__Complete__c = false
                                               and MPM4_BASE__Project_Milestone__r.MPM4_BASE__Complete__c = false 
                                               and MPM4_BASE__Project_Milestone__r.MPM4_BASE__Project__r.Project_Stage__c != 'Complete' 
                                               and MPM4_BASE__Project_Milestone__r.MPM4_BASE__Project__r.Project_Stage__c != 'Cancelled' ]){
                                                   tasks.add(
                                                       new MPM4_BASE__Milestone1_Task__c(
                                                           Id=t.Id,
                                                           Name=t.Name,
                                                           MPM4_BASE__Project_Milestone__c=t.MPM4_BASE__Project_Milestone__c
                                                       ) 
                                                   );
                                                   projectIds.add(t.MPM4_BASE__Project_Milestone__r.MPM4_BASE__Project__c);
                                               }
        List<MPM4_BASE__Milestone1_Project__c> projects = [
            select Id, Name, Project_Number__c, (select Id, Name from MPM4_BASE__Project_Milestones__r where MPM4_BASE__Complete__c = false) 
            from MPM4_BASE__Milestone1_Project__c 
            where Id IN :projectIds
        ];
        data.put('tasks', tasks);
        data.put('projects', projects);
        return data;
    }
    
    @RemoteAction
    global static Boolean isOpportunityTimeAllowed(){
        Boolean result = false;
        DescribeFieldResult dfr = MPM4_BASE__Milestone1_Time__c.Opportunity__c.getDescribe();
        result = dfr.isCreateable();
        return result; 
    }
    
    @RemoteAction
    global static Map<String, List<OptionWrapper>> getPicklistOptions(){
        Map<String, List<OptionWrapper>> fieldOptions = new Map<String, List<OptionWrapper>>();
        Schema.DescribeFieldResult dfr = MPM4_BASE__Milestone1_Time__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = dfr.getPicklistValues();
        List<OptionWrapper> options = new List<OptionWrapper>();
        for(Schema.PicklistEntry entry : ple) {
            OptionWrapper wrapper = new OptionWrapper();
            wrapper.label = entry.getLabel();
            wrapper.value = entry.getValue();
            options.add(wrapper);
        }
        fieldOptions.put('Category__c', options);
        // second field
        dfr = MPM4_BASE__Milestone1_Time__c.Time_Type__c.getDescribe();
        ple = dfr.getPicklistValues();
        options = new List<OptionWrapper>();
        for(Schema.PicklistEntry entry : ple) {
            OptionWrapper wrapper = new OptionWrapper();
            wrapper.label = entry.getLabel();
            wrapper.value = entry.getValue();
            options.add(wrapper);
        }
        fieldOptions.put('Time_Type__c', options);
        return fieldOptions;
    }
    
    global class OptionWrapper {
        public String label;
        public String value;
    }
}