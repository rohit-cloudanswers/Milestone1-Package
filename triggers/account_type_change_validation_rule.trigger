trigger account_type_change_validation_rule on Account (before update) {    
   map<String,Account> accsIds = new map<String,Account>();
   list<Asset> assetRecords = new list<Asset>();

/*    
    //Added for Service Cloud implementation
    if(trigger.isAfter && trigger.isUpdate){
        blogic_Account.setTopLevelParent(trigger.oldMap,trigger.newMap);
    }
*/	
   /*
   for(Account accs  : trigger.new){
        if(accs.Status__c == 'PROSPECT'){
            accsIds.put(accs.id,accs);
        }
    }
    
    if(accsIds.size()>0){
        assetRecords = [SELECT Status,AccountID FROM Asset WHERE AccountID IN :accsIds.keySet() and Status!='Returned'];
    }
    
    for(Asset assetRecord : assetRecords)
    {
        if(accsIds.containsKey(assetRecord.AccountID))
        {
            accsIds.remove(assetRecord.AccountID);
        }
    }
    
    for(Account acc : accsIds.values())
    {
        acc.Type.addError('The Account Type cannot be updated until an asset is associated to the account');
    }
    */
}