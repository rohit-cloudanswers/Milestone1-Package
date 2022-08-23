trigger CPQQuoteLineGroupTrigger on SBQQ__QuoteLineGroup__c (before insert, after insert) {

    if (Trigger.isBefore) {
        if (Trigger.isInsert && !CPQQuoteLineGroupHelper.hasRun) {
            // save reference to old parent group
            CPQQuoteLineGroupHelper.saveReferenceToOldParentGroup(Trigger.new);
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            Map<Id, String> parentGroupNames = CPQQuoteLineGroupHelper.getParentGroupNamesMap(Trigger.new);
            Map<Id, Map<String, SBQQ__QuoteLineGroup__c>> currentParentGroupsMap = CPQQuoteLineGroupHelper.getCurrentParentGroupsByQuote(Trigger.new);
            update CPQQuoteLineGroupHelper.linkParentGroups(Trigger.new, parentGroupNames, currentParentGroupsMap);
        }
    }
}