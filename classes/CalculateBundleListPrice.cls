public class CalculateBundleListPrice {
    @InvocableMethod(label='Update bundle list prices' description='rollup bundle list prices for a true list price')
    public static void calculateBundleListPrice(List<Id> quotes) {
        System.debug(quotes);
        List<SBQQ__QuoteLine__c> qlis = [
            select Bundle_List_Price_via_Options__c, SBQQ__ListPrice__c, SBQQ__RequiredBy__c, SBQQ__Bundle__c, SBQQ__Quantity__c
            from SBQQ__QuoteLine__c
            where SBQQ__Quote__c in :quotes
        ];
        List<SBQQ__QuoteLine__c> toUpdate = new List<SBQQ__QuoteLine__c>();
        for (SBQQ__QuoteLine__c qli : qlis) {
            if (qli.SBQQ__Bundle__c) {
                System.debug('bundle found: ' + qli);
                Decimal total = 0;
                for (SBQQ__QuoteLine__c qli2 : qlis) {
                    if (qli2.SBQQ__RequiredBy__c == qli.Id) total = total + qli2.SBQQ__ListPrice__c * qli2.SBQQ__Quantity__c;
                }
                // if the bundle is ordered with qty 2, all required items will be doubled, so we need to take that out of the list price
                total = total / qli.SBQQ__Quantity__c;
                qli.Bundle_List_Price_via_Options__c = total;
                toUpdate.add(qli);
            }
        }
        System.debug('toUpdate: ' + toUpdate);
        update toUpdate;
    }
}