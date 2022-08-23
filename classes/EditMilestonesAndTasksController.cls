/* 
    Author : Appshark
    Created On : 10th Dec 2014
    Decription: Used to create and Edit multiple Milestones and Tasks from one screen.
*/
public with sharing class EditMilestonesAndTasksController {
    
    public String projectId {get;set;}
    List<Milestone1_Milestone__c> lstMilestones {get;set;}
    Set<Id> setMilestoneIds = new Set<Id>();
    Map<Id, List<Milestone1_Task__c>> mapMilestoneTasks {get;set;}
    public List<MilestoneWrapper> lstMWrapper {get;set;}
    public Integer milestoneIndex {get;set;}
    public Integer taskIndex {get;set;}
    
    public EditMilestonesAndTasksController(ApexPages.StandardController controller) {
        lstMWrapper = new List<MilestoneWrapper>();
        milestoneIndex = 0;
        projectId = ApexPages.currentPage().getParameters().get('Id');
        
        lstMilestones = [Select Id, Name, Project__c, Project__r.Name, Parent_Milestone__c, Predecessor_Milestone__c, Description__c, Kickoff__c, Deadline__c, Actual_Start_Date__c, Actual_End_Date__c, 
                        Complete__c, Hours_Budget__c, Expense_Budget__c, Total_Hours_Budget__c, Total_Hours_Balance__c, Total_Open_Tasks__c, Total_Blocked_Tasks__c, Total_Expense_Budget__c, 
                        Total_Expense_Balance__c, Total_Complete_Tasks__c, Total_Late_Tasks__c, Total_Estimated_Hours__c, Hours_Budget_from_Sub_Milestones__c, Estimated_Hours_From_Sub_Milestones__c, 
                        Estimated_Hours_From_Tasks__c, Total_Actual_Hours__c, Actual_Hours_From_Tasks__c, Actual_Hours_From_Sub_Milestones__c, Total_Estimated_Expense__c, Expense_Budget_from_Sub_Milestones__c, 
                        Estimated_Expense_From_Sub_Milestones__c, Estimated_Expense_From_Tasks__c, Total_Actual_Expense__c, Actual_Expense_From_Tasks__c, Actual_Expense_From_Sub_Milestones__c, Open_Tasks_in_Tasks__c, 
                        Open_Tasks_in_Sub_Milestones__c, Complete_Tasks_in_Tasks__c, Complete_Tasks_in_Sub_Milestones__c, Late_Tasks_in_Tasks_2__c, Late_Tasks_in_Tasks__c, Late_Tasks_in_Sub_Milestones__c, Blocked_Tasks_in_Tasks__c, 
                        Blocked_Tasks_in_Sub_Milestones__c from  Milestone1_Milestone__c where Project__c = :projectId order by Name];
        
        if(lstMilestones != null && lstMilestones.size() > 0){
            for(Milestone1_Milestone__c mStones :lstMilestones){
                setMilestoneIds.add(mStones.Id);
            }
        }
        
        List<Milestone1_Task__c> lstTasks = [Select Id, Name, Project__c, Project_Milestone__c, Project_Milestone__r.Name, Predecessor_Task__c, Description__c, Priority__c, Task_Stage__c, Type_of_Resource__c, Contractor_vendor_name__c, 
                                            Task_Type__c, Assigned_To__c, Overall_Status__c, Start_Date__c, Due_Date__c, Actual_Start_Date__c, Actual_End_Date__c, Complete__c, Last_Email_Received__c, Blocked__c, Blocked_Reason__c, Estimated_Hours__c,
                                            Estimated_Expense__c, Total_Hours__c, Hours_Balance__c, Total_Expense__c, Expense_Balance__c from Milestone1_Task__c where Project_Milestone__c in :setMilestoneIds order by Project_Milestone__r.Name, Name];
        
        /*if(lstMilestones != null && lstMilestones.size() > 0){
            for(Milestone1_Milestone__c mStones :lstMilestones){
                if(lstTasks != null && lstTasks.size() > 0){
                    List<Milestone1_Task__c> lstmTasks = new List<Milestone1_Task__c>();
                    for(Milestone1_Task__c mTask :lstTasks){
                        if(mStones.Id == mTask.Project_Milestone__c){
                            lstmTasks.add(mTask);
                        }
                    }
                    mapMilestoneTasks.put(mStones.Id, lstmTasks);
                }
            }
        }*/
        if(lstMilestones != null && lstMilestones.size() > 0){
            Integer Count = 0;
            for(Milestone1_Milestone__c mStones :lstMilestones){
                Integer TCount = 0;
                List<TaskWrapper> lstTWrapper = new List<TaskWrapper>();
                if(lstTasks != null && lstTasks.size() > 0){
                    for(Milestone1_Task__c mTask :lstTasks){
                        if(mStones.Id == mTask.Project_Milestone__c){
                            TCount++;
                            TaskWrapper tWrap = new TaskWrapper(TCount, mTask);
                            lstTWrapper.add(tWrap);
                        }
                    }
                }
                Count++;
                lstMWrapper.add(new MilestoneWrapper(Count, mStones, lstTWrapper));
            }
        }
        
    }
    
    public void AddMilestone(){
        
        MilestoneWrapper newMWrap = new MilestoneWrapper(lstMWrapper.size() + 1, new Milestone1_Milestone__c(),new List<TaskWrapper>());
        lstMWrapper.add(newMWrap);
    }
    
    public void AddChildTask(){
        system.debug('**# Milestone index: '+milestoneIndex);
        if(lstMWrapper != null && lstMWrapper.size() > 0){
            for(MilestoneWrapper wrap :lstMWrapper){
                if(wrap.mIndex == milestoneIndex){
                    TaskWrapper newTWrap = new TaskWrapper(wrap.tWrapper.size() + 1, new Milestone1_Task__c());
                    wrap.tWrapper.add(newTWrap);
                }
            }
        }
    }
    
    public void DelChildTask(){
        system.debug('**# Milestone index: '+milestoneIndex);
        system.debug('**# Task index: '+taskIndex);
        List<Milestone1_Task__c> lstDelTask = new List<Milestone1_Task__c>();
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
        List<Milestone1_Milestone__c> delMilestone = new List<Milestone1_Milestone__c>();
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
        List<Milestone1_Milestone__c> updateMilestones = new List<Milestone1_Milestone__c>();
        List<Milestone1_Task__c> upsertTasks = new List<Milestone1_Task__c>();
        system.debug('**# Wrapper size: '+lstMWrapper.size());
        try{
            if(lstMWrapper != null && lstMWrapper.size() > 0){
                for(MilestoneWrapper wrap :lstMWrapper){
                    if(wrap.milestone.Id != null){
                        updateMilestones.add(wrap.milestone);
                        if(wrap.tWrapper != null && wrap.tWrapper.size() > 0){
                            for(TaskWrapper tskwrp :wrap.tWrapper){
                                if(tskwrp.mTask.Id == null && tskwrp.mTask.Name != null){
                                    tskwrp.mTask.Project_Milestone__c = wrap.milestone.Id;
                                    upsertTasks.add(tskwrp.mTask);
                                }else if(tskwrp.mTask.Name != null){
                                    upsertTasks.add(tskwrp.mTask);
                                }
                            }
                        }
                    }else if(wrap.milestone.Id == null && wrap.milestone.Name != null && wrap.milestone.name != ''){
                        wrap.milestone.Project__c = projectId;
                        insert wrap.milestone;
                        if(wrap.tWrapper != null && wrap.tWrapper.size() > 0){
                            for(TaskWrapper tskwrp :wrap.tWrapper){
                                if(tskwrp.mTask.Id == null && tskwrp.mTask.Name != null){
                                    tskwrp.mTask.Project_Milestone__c = wrap.milestone.Id;
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
        }Catch(Exception ex){
            if(!ex.getMessage().contains('CUSTOM_VALIDATION')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
                return pg;
            }
        }
        return pg;
    }
    
    public PageReference Cancel(){
        PageReference pg = new PageReference('/'+projectId);
        return pg;
    }
    
    
    public class MilestoneWrapper{
        public integer mIndex {get;set;}
        public Milestone1_Milestone__c milestone {get;set;}
        public List<TaskWrapper> tWrapper {get;set;}
        public MilestoneWrapper(integer mIndex, Milestone1_Milestone__c milestone, List<TaskWrapper> tWrapper){
            this.mIndex = mIndex;
            this.milestone = milestone;
            this.tWrapper = tWrapper;
        }
    }
    
    public class TaskWrapper{
        public Integer tIndex {get;set;}
        public Milestone1_Task__c mTask {get;set;}
        public TaskWrapper(Integer tIndex, Milestone1_Task__c mTask){
            this.tIndex = tIndex;
            this.mTask = mTask;
        }
    }
    
}