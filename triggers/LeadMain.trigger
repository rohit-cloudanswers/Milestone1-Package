trigger LeadMain on Lead (after insert, after update) {
    if(trigger.isUpdate && trigger.isAfter){
        LeadTriggerHelper.OnAfterUpdateDataManipulations(trigger.newMap,trigger.oldMap);
    }
    if(trigger.isInsert && trigger.isAfter){
        LeadTriggerHelper.OnAfterInsertDataManipulations(trigger.newMap);
    }
}