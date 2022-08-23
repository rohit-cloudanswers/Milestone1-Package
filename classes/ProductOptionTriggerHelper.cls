public class ProductOptionTriggerHelper {

    public static void preventDuplicateOptions(List<SBQQ__ProductOption__c> options) {
        Map<Id, List<SBQQ__ProductOption__c>> newOptions = new Map<Id, List<SBQQ__ProductOption__c>>();
        for (SBQQ__ProductOption__c option : options) {
            if (option.SBQQ__ConfiguredSKU__c != null) {
                if (!newOptions.containsKey(option.SBQQ__ConfiguredSKU__c)) {
                    newOptions.put(option.SBQQ__ConfiguredSKU__c, new List<SBQQ__ProductOption__c>());
                }
                newOptions.get(option.SBQQ__ConfiguredSKU__c).add(option);
            }
        }
        List<SBQQ__ProductOption__c> productOptions = [
            select Id, SBQQ__OptionalSKU__c, SBQQ__OptionalSKU__r.ProductCode, SBQQ__ConfiguredSKU__c, SBQQ__ConfiguredSKU__r.Name
            from SBQQ__ProductOption__c
            where SBQQ__ConfiguredSKU__c IN :DescribeUtil.getSupportPackages()
        ];
        for (Id bundleId : newOptions.keySet()) {
            for (SBQQ__ProductOption__c option : newOptions.get(bundleId)) {
                for (SBQQ__ProductOption__c existingOption : productOptions) {
                    if (option.SBQQ__ConfiguredSKU__c == bundleId && existingOption.SBQQ__OptionalSKU__c == option.SBQQ__OptionalSKU__c) {
                        option.addError(existingOption.SBQQ__OptionalSKU__r.ProductCode + ' is already listed as an option for ' + existingOption.SBQQ__ConfiguredSKU__r.Name);
                    }
                }
            }
        }
    }
}