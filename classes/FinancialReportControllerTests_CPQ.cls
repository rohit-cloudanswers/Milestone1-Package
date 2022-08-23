@IsTest(SeeAllData=false)
public class FinancialReportControllerTests_CPQ {
    
    @TestSetup
    public static void setupTestData(){
        Account acc = TestDataFactory.createAccount();
        Contact con = TestDataFactory.createContact(acc);
        Opportunity opp = TestDataFactory.createOpportunity(acc);
        SBQQ__Quote__c q = new SBQQ__Quote__c(
            SBQQ__Opportunity2__c=opp.Id
        );
        insert q;
    }

    @isTest
    public static void shouldGetReportData(){
        SBQQ__Quote__c q = [select Id from SBQQ__Quote__c limit 1];
        Test.startTest();
        String jsonStr = FinancialReportController_CPQ.getReportData(q.Id, 'USD');
        Test.stopTest();
        System.assert(String.isNotBlank(jsonStr));
    }
    
    @isTest
    public static void shouldGetCurrencies(){
        Test.startTest();
        String jsonStr = FinancialReportController_CPQ.getCurrencies();
        Test.stopTest();
        System.assert(String.isNotBlank(jsonStr));
    }
}