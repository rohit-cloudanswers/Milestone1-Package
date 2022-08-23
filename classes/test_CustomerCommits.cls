@isTest
public class test_CustomerCommits {
    
    public static testmethod void testCommits(){
        
        Account a = TestDataFactory.createAccount();
        Opportunity o = TestDataFactory.createOpportunity(a);
		
        // TODO move to TestDataFactory
        Customer_Commitments__c cc = new Customer_Commitments__c();
        cc.Opportunity__c = o.Id;
        insert cc;
		
        Test.startTest();
        
        cc.Jira_Sync__c = true;
        update cc;
        
        Test.stopTest();
        
        // TODO assert something
    }
    
}