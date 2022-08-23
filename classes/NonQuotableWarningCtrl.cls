public with sharing class NonQuotableWarningCtrl {

    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getNonQuotableProducts(String quoteId) {
        return [
            select Id, SBQQ__Product__c, SBQQ__Product__r.ProductCode, 
            SBQQ__Product__r.Name, SBQQ__Product__r.Description 
            from SBQQ__QuoteLine__c
            where SBQQ__Quote__c = :quoteId
            	and SBQQ__Product__r.Quotable__c = false
        ];
    }
    
    @AuraEnabled
    public static Map<String, Object> deleteNonQuotableProducts(String quoteId) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            delete getNonQuotableProducts(quoteId);
            result.put('success', true);
        } catch (Exception ex) {
            result.put('success', false);
            result.put('message', ex.getMessage());
        }
        return result;
    }
    
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getProductsWithLongLeadTime(String quoteId) {
        return [
            select Id, SBQQ__Product__r.ProductCode, SBQQ__Product__r.Name, 
            SBQQ__Product__r.Description, SBQQ__Product__r.Lead_Time__c
            from SBQQ__QuoteLine__c 
            where SBQQ__Product__r.Lead_Time__c > 5 and SBQQ__Quote__c = :quoteId
        ];
    }
    
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getProductsWithLimitedSupply(String quoteId) {
        return [
            select Id, SBQQ__Product__r.ProductCode, SBQQ__Product__r.Name, 
            SBQQ__Product__r.Description
            from SBQQ__QuoteLine__c 
            where SBQQ__Product__r.Product_Status__c IN ('LIM_SUPPLY', 'Limited Supply') and SBQQ__Quote__c = :quoteId
        ];
    }
}