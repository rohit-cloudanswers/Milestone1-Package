/* 
    Author : Appshark
    Created On : 10th Dec 2014
    Decription: Used to create and Edit multiple Milestones and Tasks from one screen.
    
    Copied On : 19th Sept 2018 to act on Milestones PM+ objects by Passage Technology Development (John Zhao)
*/
public with sharing class MPM4_EditMilestonesAndTasksController {
    
    public String projectId {get;set;}
    List<MPM4_BASE__Milestone1_Milestone__c> lstMilestones {get;set;}
    Set<Id> setMilestoneIds = new Set<Id>();
    Map<Id, List<MPM4_BASE__Milestone1_Task__c>> mapMilestoneTasks {get;set;}
    public List<MilestoneWrapper> lstMWrapper {get;set;}
    public Integer milestoneIndex {get;set;}
    public Integer taskIndex {get;set;}
    public List<SelectOption> oracleTasks {get; set;}
    public Boolean oracleTaskRequired {get; set;}
    // resources who are exempt from the oracle project task required check
    public Map<Id, MPM4_BASE__Milestone1_Resource__c> exemptResources {get; set;}
    
    public MPM4_EditMilestonesAndTasksController (ApexPages.StandardController controller) {
        lstMWrapper = new List<MilestoneWrapper>();
        milestoneIndex = 0;
        projectId = ApexPages.currentPage().getParameters().get('Id');
        oracleTaskRequired = false;
        oracleTasks = new List<SelectOption>();
        Map<Id, List<SelectOption>> orOracleTasksMap = new Map<Id, List<SelectOption>>();
        
        lstMilestones = [
            select Id, Name, MPM4_BASE__Project__c, MPM4_BASE__Project__r.Name, MPM4_BASE__Parent_Milestone__c, MPM4_BASE__Predecessor_Milestone__c, MPM4_BASE__Description__c, MPM4_BASE__Kickoff__c, MPM4_BASE__Deadline__c, MPM4_BASE__Actual_Start_Date__c, MPM4_BASE__Actual_Finish_Date__c, 
            MPM4_BASE__Complete__c, MPM4_BASE__Hours_Budget__c, MPM4_BASE__Expense_Budget__c, MPM4_BASE__Total_Hours_Budget__c, MPM4_BASE__Total_Hours_Balance__c, MPM4_BASE__Total_Open_Tasks__c, MPM4_BASE__Total_Blocked_Tasks__c, MPM4_BASE__Total_Expense_Budget__c, 
            MPM4_BASE__Total_Expense_Balance__c, MPM4_BASE__Total_Complete_Tasks__c, MPM4_BASE__Total_Late_Tasks__c, MPM4_BASE__Total_Estimated_Hours__c, MPM4_BASE__Hours_Budget_from_Sub_Milestones__c, MPM4_BASE__Estimated_Hours_From_Sub_Milestones__c, 
            MPM4_BASE__Estimated_Hours_From_Tasks__c, MPM4_BASE__Total_Actual_Hours__c, MPM4_BASE__Actual_Hours_From_Tasks__c, MPM4_BASE__Actual_Hours_From_Sub_Milestones__c, MPM4_BASE__Total_Estimated_Expense__c, MPM4_BASE__Expense_Budget_from_Sub_Milestones__c, 
            MPM4_BASE__Estimated_Expense_From_Sub_Milestones__c, MPM4_BASE__Estimated_Expense_From_Tasks__c, MPM4_BASE__Total_Actual_Expense__c, MPM4_BASE__Actual_Expense_From_Tasks__c, MPM4_BASE__Actual_Expense_From_Sub_Milestones__c, MPM4_BASE__Open_Tasks_in_Tasks__c, 
            MPM4_BASE__Open_Tasks_in_Sub_Milestones__c, MPM4_BASE__Complete_Tasks_in_Tasks__c, MPM4_BASE__Complete_Tasks_in_Sub_Milestones__c, MPM4_BASE__Late_Tasks_in_Tasks_2__c, MPM4_BASE__Late_Tasks_in_Tasks__c, MPM4_BASE__Late_Tasks_in_Sub_Milestones__c, MPM4_BASE__Blocked_Tasks_in_Tasks__c, 
            MPM4_BASE__Blocked_Tasks_in_Sub_Milestones__c, MPM4_BASE__Project__r.Oracle_Project__c, Override_Oracle_Project__c
            from  MPM4_BASE__Milestone1_Milestone__c 
            where MPM4_BASE__Project__c = :projectId order by Name
        ];

        exemptResources = new Map<Id, MPM4_BASE__Milestone1_Resource__c>([
            select Id from MPM4_BASE__Milestone1_Resource__c
            where MPM4_BASE__User__r.Alias IN ('SBLBCDOR')
        ]);
        
        Map<Id, String> milestoneToOracleProject = new Map<Id, String>();
        Set<Id> overridenOracleProjectIds = new Set<Id>();
        if(lstMilestones != null && lstMilestones.size() > 0){
            for(MPM4_BASE__Milestone1_Milestone__c mStones :lstMilestones){
                setMilestoneIds.add(mStones.Id);
                if (mStones.Override_Oracle_Project__c != null) {
                    overridenOracleProjectIds.add(mStones.Override_Oracle_Project__c);
                    milestoneToOracleProject.put(mStones.Id, mStones.Override_Oracle_Project__c);
                    oracleTaskRequired = true;
                } else  if (mStones.MPM4_BASE__Project__r != null && mStones.MPM4_BASE__Project__r.Oracle_Project__c != null) {
                    milestoneToOracleProject.put(mStones.Id, mStones.MPM4_BASE__Project__r.Oracle_Project__c);
                    oracleTaskRequired = true;
                }
            }
        }
        
        List<Oracle_Project_Task__c> oracleProjectTasks = [
            select Id, Name, Oracle_Project__c
            from Oracle_Project_Task__c
            where Oracle_Project__c IN (select Oracle_Project__c from MPM4_BASE__Milestone1_Project__c where Id = :projectId)
        ];
        List<SelectOption> oracleProjectTaskOptions = new List<SelectOption>();
        for (Oracle_Project_Task__c projectTask : oracleProjectTasks) {
            oracleProjectTaskOptions.add(new SelectOption(
                projectTask.Id, projectTask.Name
            ));
        }
        oracleTasks = oracleProjectTaskOptions;
        
        // need extra query as "Semi join sub-selects are not allowed with the 'OR' operator"
        List<Oracle_Project_Task__c> orOracleProjectTasks = [
            select Id, Name, Oracle_Project__c
            from Oracle_Project_Task__c
            where Oracle_Project__c IN :overridenOracleProjectIds
        ];
        
        for (Oracle_Project_Task__c projectTask : orOracleProjectTasks) {
            if (overridenOracleProjectIds.contains(projectTask.Oracle_Project__c)) {
                if (!orOracleTasksMap.containsKey(projectTask.Oracle_Project__c)) {
                    orOracleTasksMap.put(projectTask.Oracle_Project__c, new List<SelectOption>());
                }
                orOracleTasksMap.get(projectTask.Oracle_Project__c).add(new SelectOption(
                    projectTask.Id, projectTask.Name
                ));
            }
        }
        
        List<MPM4_BASE__Milestone1_Task__c> lstTasks = [Select Id, Name, MPM4_BASE__Project__c, MPM4_BASE__Project_Milestone__c, MPM4_BASE__Project_Milestone__r.Name, MPM4_BASE__Predecessor_Task__c, MPM4_BASE__Description__c, MPM4_BASE__Priority__c, MPM4_BASE__Task_Stage__c, Type_of_Resource__c, Contractor_vendor_name__c, Oracle_Project_Task__c,
                                            Task_Type__c, MPM4_BASE__Resource__c, MPM4_BASE__Overall_Status__c, MPM4_BASE__Start_Date__c, MPM4_BASE__Due_Date__c, MPM4_BASE__Actual_Start_Date__c, MPM4_BASE__Actual_Finish_Date__c, MPM4_BASE__Complete__c, MPM4_BASE__Last_Email_Received__c, MPM4_BASE__Blocked__c, MPM4_BASE__Blocked_Reason__c, MPM4_BASE__Estimated_Hours__c,
                                            MPM4_BASE__Estimated_Expense__c, MPM4_BASE__Total_Hours__c, MPM4_BASE__Hours_Balance__c, MPM4_BASE__Total_Expense__c, MPM4_BASE__Expense_Balance__c from MPM4_BASE__Milestone1_Task__c where MPM4_BASE__Project_Milestone__c in :setMilestoneIds order by MPM4_BASE__Project_Milestone__r.Name, Name];
        
        /*if(lstMilestones != null && lstMilestones.size() > 0){
            for(MPM4_BASE__Milestone1_Milestone__c mStones :lstMilestones){
                if(lstTasks != null && lstTasks.size() > 0){
                    List<MPM4_BASE__Milestone1_Task__c> lstmTasks = new List<MPM4_BASE__Milestone1_Task__c>();
                    for(MPM4_BASE__Milestone1_Task__c mTask :lstTasks){
                        if(mStones.Id == mTask.MPM4_BASE__Project_Milestone__c){
                            lstmTasks.add(mTask);
                        }
                    }
                    mapMilestoneTasks.put(mStones.Id, lstmTasks);
                }
            }
        }*/
        if(lstMilestones != null && lstMilestones.size() > 0){
            Integer Count = 0;
            for(MPM4_BASE__Milestone1_Milestone__c mStones :lstMilestones){
                Integer TCount = 0;
                List<TaskWrapper> lstTWrapper = new List<TaskWrapper>();
                if(lstTasks != null && lstTasks.size() > 0){
                    for(MPM4_BASE__Milestone1_Task__c mTask :lstTasks){
                        if(mStones.Id == mTask.MPM4_BASE__Project_Milestone__c){
                            TCount++;
                            TaskWrapper tWrap = new TaskWrapper(TCount, mTask);
                            lstTWrapper.add(tWrap);
                        }
                    }
                }
                Count++;
                MilestoneWrapper mw = new MilestoneWrapper(Count, mStones, lstTWrapper);
                if (String.isNotBlank(mStones.Override_Oracle_Project__c)) {
                    mw.orOracleTasks = orOracleTasksMap.get(mStones.Override_Oracle_Project__c);
                } else {
                    mw.orOracleTasks = oracleProjectTaskOptions;
                }
                lstMWrapper.add(mw);
            }
        }
        
    }
    
    public void AddMilestone(){
        
        MilestoneWrapper newMWrap = new MilestoneWrapper(lstMWrapper.size() + 1, new MPM4_BASE__Milestone1_Milestone__c(
            MPM4_BASE__Project__c = projectId
        ), new List<TaskWrapper>());
        newMWrap.orOracleTasks = oracleTasks;
        lstMWrapper.add(newMWrap);
    }
    
    public void AddChildTask(){
        system.debug('**# Milestone index: '+milestoneIndex);
        if(lstMWrapper != null && lstMWrapper.size() > 0){
            for(MilestoneWrapper wrap :lstMWrapper){
                if(wrap.mIndex == milestoneIndex){
                    TaskWrapper newTWrap = new TaskWrapper(wrap.tWrapper.size() + 1, new MPM4_BASE__Milestone1_Task__c(
                        Task_Type__c='Billable'
                    ));
                    newTWrap.selectedOracleTask = '';
                    wrap.tWrapper.add(newTWrap);
                }
            }
        }
    }
    
    public void DelChildTask(){
        system.debug('**# Milestone index: '+milestoneIndex);
        system.debug('**# Task index: '+taskIndex);
        List<MPM4_BASE__Milestone1_Task__c> lstDelTask = new List<MPM4_BASE__Milestone1_Task__c>();
        if(lstMWrapper != null && lstMWrapper.size() > 0){
            for(MilestoneWrapper wrap :lstMWrapper){
                if(wrap.mIndex == milestoneIndex){
                    integer indx = 0;
                    for(TaskWrapper tskwrp :wrap.tWrapper){
                        if(tskwrp.tIndex == taskIndex && tskwrp.mTask.Id == null){
                            wrap.tWrapper.remove(indx);
                            break;
                        }else if(tskwrp.tIndex == taskIndex && tskwrp.mTask.Id != null){
                            wrap.tWrapper.remove(indx);
                            lstDelTask.add(tskwrp.mTask);
                            break;
                        }
                        indx++; 
                    }
                }
            }
            if(lstDelTask != null && lstDelTask.size() > 0){
                delete lstDelTask;
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no record to delete.'));
            return;
        }
    }
    
    public void DelMilestone(){
        system.debug('**# Milestone index: '+milestoneIndex);
        List<MPM4_BASE__Milestone1_Milestone__c> delMilestone = new List<MPM4_BASE__Milestone1_Milestone__c>();
        if(lstMWrapper != null && lstMWrapper.size() > 0){
            integer indx = 0;
            for(MilestoneWrapper wrap :lstMWrapper){
                if(wrap.mIndex == milestoneIndex && wrap.milestone.Id == null){
                    lstMWrapper.remove(indx);
                    break;
                }else if(wrap.mIndex == milestoneIndex && wrap.milestone.Id != null){
                    lstMWrapper.remove(indx);
                    delMilestone.add(wrap.milestone);
                    break;
                }
                indx++;
            }
            system.debug('**# Del Milestone: '+delMilestone);
            if(delMilestone != null && delMilestone.size() > 0)
                delete delMilestone;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no record to delete.'));
            return;
        }
    }
    
    public pageReference SaveRc(){
        pageReference pg;
        List<MPM4_BASE__Milestone1_Milestone__c> updateMilestones = new List<MPM4_BASE__Milestone1_Milestone__c>();
        List<MPM4_BASE__Milestone1_Task__c> upsertTasks = new List<MPM4_BASE__Milestone1_Task__c>();
        system.debug('**# Wrapper size: '+lstMWrapper.size());
        try{
            if(lstMWrapper != null && lstMWrapper.size() > 0){
                for(MilestoneWrapper wrap :lstMWrapper){
                    if(wrap.milestone.Id != null){
                        updateMilestones.add(wrap.milestone);
                        if(wrap.tWrapper != null && wrap.tWrapper.size() > 0){
                            for(TaskWrapper tskwrp :wrap.tWrapper){
                                if (oracleTaskRequired && String.isBlank(tskwrp.selectedOracleTask)) {
                                    if(!exemptResources.containsKey(tskwrp.mTask.MPM4_BASE__Resource__c)) {
                                        tskwrp.taskRequired = 'Oracle Project Task is required';
                                        throw new MissingOracleTaskException('Oracle Project Task is required');
                                    }
                                } else {
                                    tskwrp.mTask.Oracle_Project_Task__c = tskwrp.selectedOracleTask;
                                    tskwrp.taskRequired = null;
                                }
                                if(tskwrp.mTask.Id == null && tskwrp.mTask.Name != null){
                                    tskwrp.mTask.MPM4_BASE__Project_Milestone__c = wrap.milestone.Id;
                                    upsertTasks.add(tskwrp.mTask);
                                }else if(tskwrp.mTask.Name != null){
                                    upsertTasks.add(tskwrp.mTask);
                                }
                            }
                        }
                    }else if(wrap.milestone.Id == null && wrap.milestone.Name != null && wrap.milestone.name != ''){
                        wrap.milestone.MPM4_BASE__Project__c = projectId;
                        insert wrap.milestone;
                        if(wrap.tWrapper != null && wrap.tWrapper.size() > 0){
                            for(TaskWrapper tskwrp :wrap.tWrapper){
                                if (oracleTaskRequired && String.isBlank(tskwrp.selectedOracleTask)) {
                                    if(!exemptResources.containsKey(tskwrp.mTask.MPM4_BASE__Resource__c)) {
                                        tskwrp.taskRequired = 'Oracle Project Task is required';
                                        throw new MissingOracleTaskException('Oracle Project Task is required');
                                    }
                                } else {
                                    tskwrp.mTask.Oracle_Project_Task__c = tskwrp.selectedOracleTask;
                                    tskwrp.taskRequired = null;
                                }
                                if(tskwrp.mTask.Id == null && tskwrp.mTask.Name != null){
                                    tskwrp.mTask.MPM4_BASE__Project_Milestone__c = wrap.milestone.Id;
                                    upsertTasks.add(tskwrp.mTask);
                                }else if(tskwrp.mTask.Name != null){
                                    upsertTasks.add(tskwrp.mTask);
                                }
                            }
                        }
                    }
                }
                if(upsertTasks != null && upsertTasks.size() > 0)
                    upsert upsertTasks;
                if(updateMilestones != null && updateMilestones.size() >0)
                    update updateMilestones;
                system.debug('**# upsertTasks: '+upsertTasks);
                pg = new pageReference('/'+projectId);
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no record to save.'));
                return pg;
            }
        } catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            return pg;
        }
        return pg;
    }
    
    public PageReference Cancel(){
        PageReference pg = new PageReference('/'+projectId);
        return pg;
    }
    
    
    public class MilestoneWrapper{
        public integer mIndex {get;set;}
        public MPM4_BASE__Milestone1_Milestone__c milestone {get;set;}
        public List<SelectOption> orOracleTasks {get; set;}
        public List<TaskWrapper> tWrapper {get;set;}
        public MilestoneWrapper(integer mIndex, MPM4_BASE__Milestone1_Milestone__c milestone, List<TaskWrapper> tWrapper){
            this.mIndex = mIndex;
            this.milestone = milestone;
            this.tWrapper = tWrapper;
            this.orOracleTasks = new List<SelectOption>();
        }
    }
    
    public class TaskWrapper{
        public Integer tIndex {get;set;}
        public MPM4_BASE__Milestone1_Task__c mTask {get;set;}
        public String selectedOracleTask {get; set;}
        public String taskRequired {get; set;}
        public TaskWrapper(Integer tIndex, MPM4_BASE__Milestone1_Task__c mTask){
            this.tIndex = tIndex;
            this.mTask = mTask;
            this.selectedOracleTask = mTask.Oracle_Project_Task__c;
        }
    }
    
    public class MissingOracleTaskException extends Exception {}
}