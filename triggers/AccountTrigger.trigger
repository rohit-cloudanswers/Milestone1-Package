trigger AccountTrigger on Account (after update, before update, before insert) {

    if(triggerFlags.accountTopLevelTriggerInProgress) return;
    if(trigger.isBefore){
        if(trigger.isUpdate){
            blogic_Account.syncronizeAccountTopLevel(trigger.new);
            blogic_Account.acnt_type_change_validation_rule(trigger.new); 
        }
        if(trigger.isInsert){
            blogic_Account.syncronizeAccountTopLevel(trigger.new);
        }
    }
    if(trigger.isAfter){
        if(trigger.isUpdate){
            triggerFlags.accountTopLevelTriggerInProgress=true;
            blogic_Account.updateAccountTopLevelDescendants(trigger.old,trigger.newmap);
            triggerFlags.accountTopLevelTriggerInProgress=false;            
        }
        blogic_Account.updateAddressesWithTopLevel(trigger.newmap);
    }
}