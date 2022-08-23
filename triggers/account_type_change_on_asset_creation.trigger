trigger account_type_change_on_asset_creation on Asset (after insert, after update) {
    List<Id> accsIds = new List<Id>();
    list<Account> accRecords = new list<Account>();
    for(Asset assetRecord  : trigger.new){
        if(assetRecord.Status != 'Returned' ){
            accsIds.add(assetRecord.AccountID);
        }
    }
    
    if(accsIds.size()>0){
        accRecords = [SELECT Status__c,Type FROM Account WHERE ID IN :accsIds and Type =: 'Prospect'];
    }
    
    for(Account acc: accRecords)
    {
        acc.Type = 'End User';
        acc.Status__c = 'Active';
    }
    update accRecords;                   
}