trigger ProductOptionTrigger on SBQQ__ProductOption__c (before insert) {

    if (Trigger.isBefore && Trigger.isInsert) {
        ProductOptionTriggerHelper.preventDuplicateOptions(Trigger.new);
    }
}