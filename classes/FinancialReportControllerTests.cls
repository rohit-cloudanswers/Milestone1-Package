@IsTest(SeeAllData=false)
public class FinancialReportControllerTests {
    
    @TestSetup
    public static void setupTestData(){
        Account acc = TestDataFactory.createAccount();
        Contact con = TestDataFactory.createContact(acc);
        Opportunity opp = TestDataFactory.createOpportunity(acc);
        Quote q = new Quote(
            Name='Test Quote',
            OpportunityId=opp.Id
        );
        insert q;
    }

    @isTest
    public static void shouldGetReportData(){
        Quote q = [select Id from Quote limit 1];
        Test.startTest();
        String jsonStr = FinancialReportController.getReportData(q.Id, 'USD');
        Test.stopTest();
        System.assert(String.isNotBlank(jsonStr));
    }
    
    @isTest
    public static void shouldGetCurrencies(){
        Test.startTest();
        String jsonStr = FinancialReportController.getCurrencies();
        Test.stopTest();
        System.assert(String.isNotBlank(jsonStr));
    }
}