@isTest(SeeAllData=false)
public class CategorizeTimeBatchTests {

    @testSetup
    static void setupTestData() {
        MPM4_BASE__Milestone1_Project__c project = new MPM4_BASE__Milestone1_Project__c(
            Name='Test Project',
            MPM4_BASE__Actual_Start_Date__c=Date.today(),
            Milestone_1__c='Test Milestone',
            Milestone_1_Date__c=Date.today().addDays(7),
            Rev_Rec_Reason__c='None'
        );
        insert project;
        MPM4_BASE__Milestone1_Milestone__c milestone = new MPM4_BASE__Milestone1_Milestone__c(
            Name='Test Milestone',
            MPM4_BASE__Project__c=project.Id            
        );
        insert milestone;
        
        MPM4_BASE__Milestone1_Resource__c res = new MPM4_BASE__Milestone1_Resource__c(MPM4_BASE__user__c = UserInfo.getUserId());
        insert res;
        
        List<MPM4_BASE__Milestone1_Task__c> milestoneTasks = new List<MPM4_BASE__Milestone1_Task__c>();
        milestoneTasks.add(new MPM4_BASE__Milestone1_Task__c(
            Name='Test Task 1',
            MPM4_BASE__Resource__c=res.Id,
            MPM4_BASE__Project_Milestone__c=milestone.Id,
            MPM4_BASE__Estimated_Hours__c=40
        ));
        milestoneTasks.add(new MPM4_BASE__Milestone1_Task__c(
            Name='Test Task 2',
            MPM4_BASE__Resource__c=res.Id,
            MPM4_BASE__Project_Milestone__c=milestone.Id
        ));
        milestoneTasks.add(new MPM4_BASE__Milestone1_Task__c(
            Name='Test Task 3',
            MPM4_BASE__Resource__c=res.Id,
            MPM4_BASE__Project_Milestone__c=milestone.Id,
            MPM4_BASE__Estimated_Hours__c=0
        ));
        insert milestoneTasks;
        
        List<MPM4_BASE__Milestone1_Time__c> timeEntries = new List<MPM4_BASE__Milestone1_Time__c>();
        for (MPM4_BASE__Milestone1_Task__c milestoneTask : milestoneTasks) {
            Date startDate = Date.today().addDays(-10);
            for (Integer i=0; i<10; i++) {
                timeEntries.add(new MPM4_BASE__Milestone1_Time__c(
                    MPM4_BASE__Date__c=startDate,
                    MPM4_BASE__Hours__c=6,
                    MPM4_BASE__Incurred_By__c=UserInfo.getUserId(),
                    MPM4_BASE__Description__c='TE-' + i,
                    MPM4_BASE__Project_Task__c=milestoneTask.Id
                ));
                startDate = startDate.addDays(1);
            }
        }
        insert timeEntries;
    }
    
    @isTest
    static void integrationTest() {
        Test.startTest();
        CategorizeTimeBatch.run();
        Test.stopTest();
    }
    
    @isTest
    static void testTaskTime() {
        Test.startTest();
        MPM4_BASE__Milestone1_Task__c tk = [select Id from MPM4_BASE__Milestone1_Task__c limit 1];
        CategorizeTaskTimeBatch obj = new CategorizeTaskTimeBatch(new Set<Id>{tk.Id});
        Database.executeBatch(obj, 10);
        Test.stopTest();
    }
    
    @isTest
    static void shouldStartTimeCategorization() {
        MPM4_BASE__Milestone1_Task__c tk = [select Id from MPM4_BASE__Milestone1_Task__c limit 1];
        Test.startTest();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(tk);
        CategorizeTimeCtrl ctrl = new CategorizeTimeCtrl(stdCon);
        ctrl.startTimeCategorization();
        Test.stopTest();
    }
    
    @isTest
    static void shouldTestErrorEmails() {
        Test.startTest();
        CategorizeTimeBatch obj = new CategorizeTimeBatch();
        obj.errors.add('This is an error');
        Database.executeBatch(obj, 1);
        Test.stopTest();
    }
    
    @isTest
    static void shouldRunTaskTimeBatch() {
        Test.startTest();
        CategorizeTaskTimeBatch.run();
        Test.stopTest();
    }
}