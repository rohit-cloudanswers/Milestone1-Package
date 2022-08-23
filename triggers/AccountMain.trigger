trigger AccountMain on Account (before insert, before update) {
    if(trigger.isInsert && trigger.isBefore){
        AccountTriggerHelper.OnBeforeInsertDataManipulations(trigger.new);
    }
    if(trigger.isUpdate && trigger.isBefore){
        AccountTriggerHelper.OnBeforeUpdateDataManipulations(trigger.new);
    } 
}