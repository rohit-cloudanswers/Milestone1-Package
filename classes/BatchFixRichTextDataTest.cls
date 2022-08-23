@isTest
public class BatchFixRichTextDataTest {
    @testSetup  static void generatedata() {
        Account testAccount = new Account(Name = 'test Account', Type = 'Prospect');
        insert testAccount;
        Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
        insert cty;
        Address__c testAddress = TestDataFactory.createAddress(testAccount);

        Id pb = Test.getStandardPricebookId();
        Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity', Pricebook2Id = pb, AccountId = testAccount.Id, StageName = 'Prospecting', CloseDate = Date.today() + 30, Description = 'testing');
        insert testOpportunity;

        Quote testQuote = new Quote(Name = 'test Quote', OpportunityId = testOpportunity.Id, Default_Price_Book__c = pb, Additional_DIscount__c = 10, Hardware_Discount__c = 50);
        testQuote.Support_Type__c = 'Care Plus';
        insert testQuote;
    }
    static testMethod void testQuote() {
        Test.startTest();
        Database.executeBatch(new BatchFixRichTextData(), 100);
        Test.stopTest();
    }
}