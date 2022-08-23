@IsTest(SeeAllData=false)
public class NewQuoteControllerTests {
    
    @TestSetup
    static void shouldSetupTestData(){
        Account acc = TestDataFactory.createAccount();
        /* Process builder (Create Individual Record on Contact Create) issue in production*/
        Individual indRecord = new Individual();
        indRecord.LastName= 'Test';
        insert indRecord;

        Contact con = new Contact();
        con.LastName = 'conLastName';
        con.AccountId = acc.id;
        con.IndividualId = indRecord.Id;
        con.Email = 'test12345@aol.com';
        insert con;
       
        Opportunity opp = TestDataFactory.createOpportunity(acc);
        OpportunityContactRole ocr = new OpportunityContactRole(
            OpportunityId=opp.Id,
            ContactId=con.Id,
            IsPrimary=true
        );
        insert ocr;
        Quote_Defaults__c qd = new Quote_Defaults__c(
            Name='Name',
            Value_Source__c='Name',
            Is_Opportunity_Field__c=true
        );
        insert qd;
        qd = new Quote_Defaults__c(
            Name='Support_Type__c',
            Value_Source__c='None',
            Is_Opportunity_Field__c=false
        );
        insert qd;
    }
    
    @IsTest
    static void shouldLoadDefaults(){
        Opportunity opp = [select Id from Opportunity limit 1];
        System.assert(opp != null);
        Map<String, Object> quoteDefaults = NewQuoteController.getDefaultValues(opp.Id);
        System.assert(quoteDefaults.size() != 0);
    }
}