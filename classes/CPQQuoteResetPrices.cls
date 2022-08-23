public class CPQQuoteResetPrices {

    @InvocableMethod(label='Reset CPQ Quote Prices' description='Resets the list price on quote lines to pricebook')
    public static void resetQuoteLinePrices(List<Id> quoteIds) {
        // don't query support package and related bundle items
        List<SBQQ__QuoteLine__c> quoteLines = [
            select Id, SBQQ__ListPrice__c, SBQQ__PricebookEntryId__c, Product_Cost__c, SBQQ__Product__r.Product_Cost__c
            from SBQQ__QuoteLine__c
            where SBQQ__Quote__c in :quoteIds and (NOT SBQQ__Product__r.ProductCode like 'Support Package %') 
            	and (NOT SBQQ__RequiredBy__r.SBQQ__Product__r.ProductCode like 'Support Package %')
        ];
        Set<Id> pricebookEntryIds = new Set<Id>();
        for (SBQQ__QuoteLine__c quoteLine : quoteLines) {
            if (String.isNotBlank(quoteLine.SBQQ__PricebookEntryId__c)) {
                pricebookEntryIds.add(quoteLine.SBQQ__PricebookEntryId__c);
            }
        }
        Map<Id, PricebookEntry> entriesMap = new Map<Id, PricebookEntry>([
            select Id, UnitPrice
            from PricebookEntry
            where Id in :pricebookEntryIds
        ]);
        List<SBQQ__QuoteLine__c> quoteLinesToUpdate = new List<SBQQ__QuoteLine__c>();
        for (SBQQ__QuoteLine__c quoteLine : quoteLines) {
            PricebookEntry entry = entriesMap.get(quoteLine.SBQQ__PricebookEntryId__c);
            Boolean hasUpdate = false;
            if (entry != null && entry.UnitPrice > 0 && entry.UnitPrice != quoteLine.SBQQ__ListPrice__c) {
                quoteLine.SBQQ__ListPrice__c = entry.UnitPrice;
                hasUpdate = true;
            }
            if (quoteLine.SBQQ__Product__r.Product_Cost__c != null && quoteLine.SBQQ__Product__r.Product_Cost__c != 0 && quoteLine.Product_Cost__c != quoteLine.SBQQ__Product__r.Product_Cost__c) {
                quoteLine.Product_Cost__c = quoteLine.SBQQ__Product__r.Product_Cost__c;
                hasUpdate = true;
            }
            if (hasUpdate) quoteLinesToUpdate.add(quoteLine);
        }
        update quoteLinesToUpdate;
    }
}