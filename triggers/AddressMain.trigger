trigger AddressMain on Address__c (before update,after insert, after update, before insert) {
    if(trigger.isUpdate && trigger.isAfter){
        AddressTriggerHelper.updateAccountOnAddressCreation(trigger.newMap);
    }
    if(trigger.isInsert && trigger.isAfter){
        AddressTriggerHelper.updateAccountOnAddressCreation(trigger.newMap);
    }
    if(trigger.isUpdate && trigger.isBefore){
        blogic_Address.matchAccount(trigger.new);
        blogic_Address.setSalesforcePrimary(trigger.new);
        AddressTriggerHelper.validateAtleastOnePrimary(trigger.newMap, trigger.OldMap);
        AddressTriggerHelper.addRegionAndSubRegion(trigger.new);
        blogic_address.setParentAccount(trigger.new);
    }
    if(trigger.isInsert && trigger.isBefore){
        blogic_Address.matchAccount(trigger.new);
        blogic_Address.setSalesforcePrimary(trigger.new);
        AddressTriggerHelper.addRegionAndSubRegion(trigger.new);
        blogic_address.setParentAccount(trigger.new);
    }
}