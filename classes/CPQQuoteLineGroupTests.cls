@IsTest
public class CPQQuoteLineGroupTests {

    @TestSetup
    static void setupTestData() {
        TestDataFactory.setupTestCPQQuote();
    }
    
    @isTest
    static void shouldUpdateParentGroups() {
        List<SBQQ__Quote__c> quotes = [select Id, SBQQ__Account__c,SBQQ__Opportunity2__c from SBQQ__Quote__c limit 2];
        System.assert(!quotes.isEmpty());
        List<Product2> products = [select Id from Product2 where ProductCode IN ('FRINKSD', 'FRINKSE')];
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        quoteLines.add(new SBQQ__QuoteLine__c(
            SBQQ__Quote__c=quotes.get(0).Id,
            Import_Parent_Group_Name__c='Hardware',
            Import_Group_Name__c='Hardware I',
            SBQQ__Product__c=products.get(0).Id,
            SBQQ__Quantity__c=1
        ));
        quoteLines.add(new SBQQ__QuoteLine__c(
            SBQQ__Quote__c=quotes.get(0).Id,
            Import_Group_Name__c='Software',
            SBQQ__Product__c=products.get(1).Id,
            SBQQ__Quantity__c=1
        ));
        Test.startTest();
        insert quoteLines;
        List<SBQQ__QuoteLineGroup__c> groups = [
            select Id, Name, SBQQ__Quote__c, Parent_Group__c, Is_Parent_Group__c 
            from SBQQ__QuoteLineGroup__c 
            where SBQQ__Quote__c = :quotes.get(0).Id
        ];
        System.assert(groups.size() == 3);
        
        // create new quote
        List<SBQQ__QuoteLineGroup__c> clonedGroups = new List<SBQQ__QuoteLineGroup__c>();
        for (SBQQ__QuoteLineGroup__c lineGroup : groups) {
            SBQQ__QuoteLineGroup__c clonedGroup = lineGroup.clone(false, true);
            clonedGroup.SBQQ__Quote__c = quotes.get(1).Id;
            clonedGroups.add(clonedGroup);
        }
        CPQQuoteLineGroupHelper.hasRun = false;
        insert clonedGroups;
        Test.stopTest();
    }
}