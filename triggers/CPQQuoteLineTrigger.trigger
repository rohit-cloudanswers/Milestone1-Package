trigger CPQQuoteLineTrigger on SBQQ__QuoteLine__c (before insert, before update) {

    CPQQuoteLineHelper triggerHelper = new CPQQuoteLineHelper();
    if(Trigger.isBefore && Trigger.isInsert) {
        triggerHelper.populateQuoteLineGroups(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        triggerHelper.syncOptionalStatusWithGroup(Trigger.oldMap, Trigger.newMap);
    }
}