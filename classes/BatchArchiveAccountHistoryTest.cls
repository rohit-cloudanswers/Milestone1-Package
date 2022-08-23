@isTest
public class BatchArchiveAccountHistoryTest {
	@isTest
    private static void archiveAccountTest(){
        Account ac = TestDataFactory.createAccount();
        // change owner so a history is generated
        ac.OwnerId = [
            select Id 
            from User 
            where IsActive = true 
            and Profile.Name = 'System Administrator' 
            order by LastModifiedDate desc 
            limit 1
        ][0].Id;
        update ac;
        AccountHistory objectHistory = new AccountHistory(
            AccountId = ac.Id, 
            Field = 'Site'
        );
        insert objectHistory;
        test.startTest();
        BatchArchiveAccountHistory accArchiveBatch = new BatchArchiveAccountHistory();
        Database.executeBatch(accArchiveBatch, 200);
        test.stopTest();
        List<Archive_Account_History__c> archAccountHistoryList = [SELECT Account__c, Field__c FROM Archive_Account_History__c];
        system.assertEquals('Site', archAccountHistoryList[0].Field__c , 'Field is incorrect');
        system.assertEquals(ac.Id, archAccountHistoryList[0].Account__c , 'Account id is incorrect');
        system.assertEquals(1, archAccountHistoryList.size(), 'Account History record is not returned');
    }
    @isTest
    private static void scheduleBatchTimeReportingTest() {
        String CRON_EXP = '0 0 0 3 9 ? *';
		Test.startTest();
		String jobId = System.schedule('BatchArchiveAccountHistory_TEST', CRON_EXP, new BatchArchiveAccountHistory());
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
      	System.assertEquals(CRON_EXP, ct.CronExpression);
      	System.assertEquals(0, ct.TimesTriggered);
		Test.stopTest();
    }
    @isTest
    private static void testErrorEmail () {
        BatchArchiveAccountHistory b = new BatchArchiveAccountHistory();
        b.upsertErrors = 'TESTING123!';
        b.finish(null);
        // TODO assert
    }
    @isTest
    private static void testNameLookup () {
        BatchArchiveAccountHistory x = new BatchArchiveAccountHistory();
        List<Archive_Account_History__c> histories = new List<Archive_Account_History__c>();
        histories.add(new Archive_Account_History__c(
        	Field__c = 'Owner',
            Old_Value__c = UserInfo.getUserId(),
            New_Value__c = UserInfo.getUserId()
        ));
        x.convertIdsToNames(histories);
		System.assertEquals(UserInfo.getUserName(), histories[0].Old_Value__c);
		System.assertEquals(UserInfo.getUserName(), histories[0].New_Value__c);
    }
}