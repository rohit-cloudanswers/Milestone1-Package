@IsTest
private class LeadConvertControllerTest {

	@testSetup static void  populateLead(){
		Lead lead=new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Inquiry',City = 'Houston',State='Texas',Country='United States of America',Street='7200 Almeda Rd',PostalCode = '98432');
    	insert lead;
	}

	@IsTest static void testAllowConvert(){ 
		Test.startTest();      
    	Lead leadBefore = [SELECT id FROM Lead];
    	LeadConvertController.updateLeadBeforeConvert(String.valueOf(leadBefore.id));
    	Lead leadAfter = [SELECT id, Allow_Conversion__c FROM Lead where id=:leadBefore.id];
    	system.assertEquals(leadAfter.Allow_Conversion__c, true);
    	Test.stopTest();
	}
}