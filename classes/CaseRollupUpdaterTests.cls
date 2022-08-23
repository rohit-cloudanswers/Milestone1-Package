@IsTest
public class CaseRollupUpdaterTests {
    @IsTest
    static void testSchedule(){
        Case testCase = new Case(
            Subject='Testing Case'
        );
        insert testCase;
        
        insert new Milestone1_Time__c(
            Case__c = testCase.Id,
            Hours__c = 1.5
        );
        
        Test.StartTest();
        String jobId = System.schedule('Test Scheduler', '0 0 23 * * ?', new CaseRollupUpdater());

        //Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
}