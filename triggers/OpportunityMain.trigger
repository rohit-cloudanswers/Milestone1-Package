trigger OpportunityMain on Opportunity (before insert , before update , after insert , after update) {
	if(trigger.IsInsert && trigger.isBefore)
	{
		OpportunityTriggerHelper.populateOptyAddress(trigger.new, null);
	}
	if(trigger.isUpdate && trigger.isBefore)
	{
		OpportunityTriggerHelper.populateOptyAddress(trigger.new, trigger.oldMap);
	}
    if(trigger.isInsert && trigger.isAfter){
        OpportunityTriggerHelper.OnAfterInsertDataManipulations(trigger.newMap,trigger.oldMap);
        OpportunityTriggerHelper.createSharing(trigger.new,trigger.newMap);
        // insert Opportunity contact role in case of LEX
        OpportunityTriggerHelper.createOpportunityContactRole(Trigger.newMap);
    }
    if(trigger.isUpdate && trigger.isAfter){
        OpportunityTriggerHelper.OnAfterUpdateDataManipulations(trigger.newMap,trigger.oldMap);
        OpportunityTriggerHelper.populateQuoteAddress(trigger.new, trigger.oldMap);
        OpportunityTriggerHelper.deleteOpporunityProducts(Trigger.old, Trigger.newMap);
    }
}