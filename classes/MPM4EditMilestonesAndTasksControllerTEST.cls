@isTest
public class MPM4EditMilestonesAndTasksControllerTEST {
    static testmethod void testMPM4_EditMilestonesAndTasksController()
    {
        RecordType MSRecType = [select Id from RecordType where SobjectType = 'MPM4_BASE__Milestone1_Milestone__c' and Name = 'Standard Milestone'];
        RecordType TaskRecType = [select Id from RecordType where SobjectType = 'MPM4_BASE__Milestone1_Task__c' and Name = 'Standard Task'];
        
        MPM4_BASE__Milestone1_Project__c testProject = new MPM4_BASE__Milestone1_Project__c();
        testProject.Name = 'Test Project1';
        Insert testProject;
        
        MPM4_BASE__Milestone1_Milestone__c testMilestone = new MPM4_BASE__Milestone1_Milestone__c();
        testMilestone.MPM4_BASE__Project__c = testProject.id;
        testMilestone.RecordTypeId = MSRecType.Id;    
        testMilestone.Name = 'Test Milestone';    
        insert testMilestone;
        
        MPM4_BASE__Milestone1_Task__c testMilestoneTask = new MPM4_BASE__Milestone1_Task__c();    
        testMilestoneTask.MPM4_BASE__Project_Milestone__c = testMilestone.id;
        testMilestoneTask.Name = 'Test Task';
        testMilestoneTask.RecordTypeId = TaskRecType.Id;
        insert testMilestoneTask;    
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Id', testProject.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testProject);
        
        MPM4_EditMilestonesAndTasksController controller = new MPM4_EditMilestonesAndTasksController(sc);
        //controller.projectId = testProject.Id;
        
        MPM4_BASE__Milestone1_Milestone__c testMilestone1 = new MPM4_BASE__Milestone1_Milestone__c();
        testMilestone1.MPM4_BASE__Project__c = testProject.id;
        testMilestone1.RecordTypeId = MSRecType.Id;    
        testMilestone1.Name = 'Test Milestone1';
        
        MPM4_BASE__Milestone1_Task__c testMilestoneTask1 = new MPM4_BASE__Milestone1_Task__c();    
        testMilestoneTask1.MPM4_BASE__Project_Milestone__c = testMilestone1.id;
        testMilestoneTask1.Name = 'Test Task1';
        testMilestoneTask1.RecordTypeId = TaskRecType.Id;
        
        MPM4_EditMilestonesAndTasksController.TaskWrapper TW = new MPM4_EditMilestonesAndTasksController.TaskWrapper(1,testMilestoneTask1);
        list<MPM4_EditMilestonesAndTasksController.TaskWrapper> TW1 = new list<MPM4_EditMilestonesAndTasksController.TaskWrapper>();    
        TW1.add(TW);
        MPM4_EditMilestonesAndTasksController.MilestoneWrapper MW = new MPM4_EditMilestonesAndTasksController.MilestoneWrapper(2,testMilestone1,TW1);
        
        controller.milestoneIndex = 1;
        Controller.AddMilestone();
        
        controller.taskIndex = 1;
        Controller.AddChildTask();
        
        controller.lstMWrapper.add(MW);
        
        controller.taskIndex = 1;
        controller.milestoneIndex = 1;
        
        controller.DelChildTask();
        
        controller.DelMilestone();
        
        MPM4_EditMilestonesAndTasksController.TaskWrapper TW2 = new MPM4_EditMilestonesAndTasksController.TaskWrapper(1,testMilestoneTask1);
        list<MPM4_EditMilestonesAndTasksController.TaskWrapper> TW3 = new list<MPM4_EditMilestonesAndTasksController.TaskWrapper>();
        TW3.add(TW2);    
        MPM4_EditMilestonesAndTasksController.MilestoneWrapper MW1 = new MPM4_EditMilestonesAndTasksController.MilestoneWrapper(2,testMilestone1,TW3);
        controller.milestoneIndex = 1;
        Controller.AddMilestone();
        
        controller.taskIndex = 1;
        Controller.AddChildTask();
        controller.lstMWrapper.add(MW1);    
        controller.SaveRc();
    }
}