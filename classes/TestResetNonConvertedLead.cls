@isTest
private class TestResetNonConvertedLead {
	// Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    @testSetup
    static void generateTestRecords()
    {
    	test_Utility.createTestLead();
    }
	@isTest static void allowConversionLead() {
		Lead l=[select id,name,Allow_Conversion__c from Lead limit 1 ];
		l.Allow_Conversion__c=true;
		update l;
		Test.startTest();
		String JobID= System.schedule('ResetNonConvertedLead', CRON_EXP, new ResetNonConvertedLead());
		Test.stopTest();

		Lead leadAfterJob=[ select id,name,Allow_Conversion__c from Lead where id=:l.id];
		System.assertEquals(leadAfterJob.Allow_Conversion__c,false);
	}
	
}