@isTest
public class BatchTimeReportingTest {
    @isTest
    private static void timeReportingMsTimeTest(){
        TestDataFactory.setupMilestone1TimeWithCase();
        Milestone1_Time__c msTimeUpdate = TestDataFactory.setupMilestone1TimeWithOpp();
        Milestone1_Time__c msTime = TestDataFactory.setupMilestone1TimeWithOpp();
        system.debug('opp Id ' + msTimeUpdate.Id + ' opp ' + msTime.Id);
        TestDataFactory.setupTimeReporting(msTime.Id);
        Time_Reporting__c trToDelete = TestDataFactory.setupTimeReporting(NULL);
        Test.startTest();
        new BatchTimeReportingMSTime().execute(null);
        Test.stopTest();
        Time_Reporting__c tr = [SELECT MS_Time4__c, Billable__c, Time_Source__c FROM Time_Reporting__c WHERE MS_Time4__c =: msTimeUpdate.Id];
        Time_Reporting__c trDelete = [SELECT MS_Time4__c, Billable__c FROM Time_Reporting__c WHERE Id =: trToDelete.Id];
        system.assertEquals(msTimeUpdate.Id, tr.MS_Time4__c, 'Time reporting record not created');
        system.assertEquals(msTimeUpdate.Billable__c, tr.Billable__c, 'Time reporting billable value is not correct');
        system.assertEquals('Opportunity', tr.Time_Source__c, 'Time reporting Time_Source__c value is not correct');
        // System.assertEquals(1, [select Id from Time_Reporting__c].size());
    }
    
    @isTest
    private static void BatchTimeReportingProjectTaskTime_integrationTest(){
        
        // first run should create 1 record
        MPM4_BASE__Milestone1_Time__c t = TestDataFactory.setupMPM4Time();
        
        // this should be deleted
        Time_Reporting__c toDelete = new Time_Reporting__c(Time_Id__c = String.valueOf(t.Id).substring(0,10) + '00001');
        insert toDelete;
        
        Test.startTest();
        new BatchTimeReportingProjectTaskTime().execute(null);
        Test.stopTest();
        System.assertEquals(1, [select Id from Time_Reporting__c].size());
    }
}