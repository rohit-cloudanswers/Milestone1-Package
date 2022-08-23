@isTest
public class EditMilestonesAndTasksControllerTEST {

static testmethod void testEditMilestonesAndTasksController()
{
    RecordType MSRecType = [select Id from RecordType where SobjectType = 'Milestone1_Milestone__c' and Name = 'Standard Milestone'];
    RecordType TaskRecType = [select Id from RecordType where SobjectType = 'Milestone1_Task__c' and Name = 'Standard Task'];
    
    Milestone1_Project__c testProject = new Milestone1_Project__c();
    testProject.Name = 'Test Project1';
    Insert testProject;
  
    Milestone1_Milestone__c testMilestone = new Milestone1_Milestone__c();
    testMilestone.Project__c = testProject.id;
    testMilestone.RecordTypeId = MSRecType.Id;    
    testMilestone.Name = 'Test Milestone';    
    insert testMilestone;

    Milestone1_Task__c testMilestoneTask = new Milestone1_Task__c();    
    testMilestoneTask.Project_Milestone__c = testMilestone.id;
    testMilestoneTask.Name = 'Test Task';
    testMilestoneTask.RecordTypeId = TaskRecType.Id;
    insert testMilestoneTask;    

    // Add parameters to page URL
    ApexPages.currentPage().getParameters().put('Id', testProject.Id);
    
    ApexPages.StandardController sc = new ApexPages.StandardController(testProject);
    
    EditMilestonesAndTasksController controller = new EditMilestonesAndTasksController(sc);
    //controller.projectId = testProject.Id;

    Milestone1_Milestone__c testMilestone1 = new Milestone1_Milestone__c();
    testMilestone1.Project__c = testProject.id;
    testMilestone1.RecordTypeId = MSRecType.Id;    
    testMilestone1.Name = 'Test Milestone1';
        
    Milestone1_Task__c testMilestoneTask1 = new Milestone1_Task__c();    
    testMilestoneTask1.Project_Milestone__c = testMilestone1.id;
    testMilestoneTask1.Name = 'Test Task1';
    testMilestoneTask1.RecordTypeId = TaskRecType.Id; 

    EditMilestonesAndTasksController.TaskWrapper TW = new EditMilestonesAndTasksController.TaskWrapper(1,testMilestoneTask1);
    list<EditMilestonesAndTasksController.TaskWrapper> TW1 = new list<EditMilestonesAndTasksController.TaskWrapper>();    
    TW1.add(TW);
    EditMilestonesAndTasksController.MilestoneWrapper MW = new EditMilestonesAndTasksController.MilestoneWrapper(2,testMilestone1,TW1);

    controller.milestoneIndex = 1;
    Controller.AddMilestone();
    
    controller.taskIndex = 1;
    Controller.AddChildTask();

    controller.lstMWrapper.add(MW);
    
    controller.taskIndex = 1;
    controller.milestoneIndex = 1;
    
    controller.DelChildTask();
    
    controller.DelMilestone();

    EditMilestonesAndTasksController.TaskWrapper TW2 = new EditMilestonesAndTasksController.TaskWrapper(1,testMilestoneTask1);
    list<EditMilestonesAndTasksController.TaskWrapper> TW3 = new list<EditMilestonesAndTasksController.TaskWrapper>();
    TW3.add(TW2);    
    EditMilestonesAndTasksController.MilestoneWrapper MW1 = new EditMilestonesAndTasksController.MilestoneWrapper(2,testMilestone1,TW3);
    controller.milestoneIndex = 1;
    Controller.AddMilestone();
    
    controller.taskIndex = 1;
    Controller.AddChildTask();
    controller.lstMWrapper.add(MW1);    
    controller.SaveRc();
}
}