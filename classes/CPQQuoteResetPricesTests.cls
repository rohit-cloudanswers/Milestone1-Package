@isTest(SeeAllData=false)
public class CPQQuoteResetPricesTests {

    @TestSetup
    static void setupTestData() {
        TestDataFactory.setupTestCPQQuote();
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        System.assert(qt != null);
        List<SBQQ__QuoteLineGroup__c> groups = [
            select Id 
            from SBQQ__QuoteLineGroup__c 
            where SBQQ__Quote__c = :qt.Id
        ];
        System.assert(groups.isEmpty());
        List<Product2> products = [select Id from Product2 where ProductCode IN ('FRINKSD', 'FRINKSE')];
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        quoteLines.add(new SBQQ__QuoteLine__c(
            SBQQ__Quote__c=qt.Id,
            Import_Parent_Group_Name__c='Hardware',
            Import_Group_Name__c='Hardware I',
            SBQQ__Product__c=products.get(0).Id,
            SBQQ__Quantity__c=1
        ));
        quoteLines.add(new SBQQ__QuoteLine__c(
            SBQQ__Quote__c=qt.Id,
            Import_Group_Name__c='Software',
            SBQQ__Product__c=products.get(1).Id,
            SBQQ__Quantity__c=1
        ));
        insert quoteLines;
    }
    
    @isTest
    public static void shouldResetPrices() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        Test.startTest();
        CPQQuoteResetPrices.resetQuoteLinePrices(new List<Id>{qt.Id});
        Test.stopTest();
    }
}