public class BundleProductCostBatch extends BatchErrorAlert implements Database.Batchable<AggregateResult>, Schedulable, Database.Stateful {

    public List<AggregateResult> start(Database.BatchableContext bc) {
        String query = 'select SBQQ__ConfiguredSKU__c from SBQQ__ProductOption__c'
            + ' where SBQQ__ConfiguredSKU__c != null'
            + ' group by SBQQ__ConfiguredSKU__c';
        return Database.query(query);
    }
    
    public void execute(Database.BatchableContext bc, List<AggregateResult> scope) {
        Map<Id, Product2> bundleParents = new Map<Id, Product2>();
        for (AggregateResult res : scope) {
            String bundleId = (String) res.get('SBQQ__ConfiguredSKU__c');
            bundleParents.put(bundleId, null);
        }
        List<SBQQ__ProductOption__c> bundleOptions = [
            select Id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c, SBQQ__Quantity__c, 
            SBQQ__OptionalSKU__r.Product_Cost__c
            from SBQQ__ProductOption__c
            where SBQQ__ConfiguredSKU__c IN :bundleParents.keySet()
        ];
        
        for (SBQQ__ProductOption__c sObj : bundleOptions) {
            Id bundleId = (Id) sObj.SBQQ__ConfiguredSKU__c;
            if (bundleParents.containsKey(bundleId)) {
                Product2 bundleProduct = bundleParents.get(bundleId);
                Decimal productCost = sObj.SBQQ__OptionalSKU__r.Product_Cost__c;
                Decimal quantity = sObj.SBQQ__Quantity__c;
                if (productCost == null) productCost = 0;
                if (quantity == null) quantity = 1;
                if (bundleProduct == null) {
                    bundleProduct = new Product2(
                        Id = bundleId,
                        Product_Cost__c = productCost * quantity
                    );
                } else {
                	bundleProduct.Product_Cost__c += (productCost * quantity);
                }
                bundleParents.put(bundleId, bundleProduct);
            }
        }
        if (!bundleParents.isEmpty()) collectErrors(Database.update(bundleParents.values()));
    }
    
    public void finish(Database.BatchableContext bc) {
        addToAddress('imaginecommunications@cambridgecloudpartners.com');
        addCcAddress(UserInfo.getUserEmail());
        sendErrorEmails();
    }
    
    public void execute(SchedulableContext sc) {
        BundleProductCostBatch.run();
    }
    
    public static void run() {
        BundleProductCostBatch obj = new BundleProductCostBatch();
        Database.executeBatch(obj, 20);
    }
}