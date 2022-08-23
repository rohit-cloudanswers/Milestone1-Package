global class blogic_Account {

    
    public static void syncronizeAccountTopLevel(list<Account> newAccounts){
        //Synconize Account's top level field with value in new parent
        //This is to be executed BEFORE insert/update
        set<id> newParentAccountIds = new set<id>();
        map<id,id> accIds = new map<Id,Id>();
        for(Account a : newAccounts){
            system.debug('***Account parentid: '+a.parentid);
            newParentAccountIds.add(a.parentid);
        }
        map<id,Account> parentAccounts = new map<id,Account>([Select id, parentid, Top_Level_Parent_Account__c from Account where id in :newParentAccountIds]);
    
        for(Account a : newAccounts){
            Id pId = null;
            if(parentAccounts != null && parentAccounts.get(a.parentid) != null && parentAccounts.get(a.parentid).parentid==null){
                //parent account is TOP Account
                pId = a.parentid;
            }else if(parentAccounts != null && parentAccounts.get(a.parentid) != null){
                pId = parentAccounts.get(a.parentid).Top_Level_Parent_Account__c;
            }
            a.Top_Level_Parent_Account__c = pId;
        }
        
       
        
    }
    
    public static void updateAddressesWithTopLevel(map<Id, Account> newAccounts){
         //get associated addresses and update those
        list<address__c> updAdds = [SELECT Id, Name,Account_Service__c, Parent_Account__c FROM Address__c WHERE Account_Service__c in :newAccounts.keyset()];
        List<Address__c> toUpdate = new List<Address__c>();
        for(Address__c a : updAdds){
            if(a.Account_Service__c != null && newAccounts.containsKey(a.Account_Service__c)) {
                String parentAcc = null;
                if(newAccounts.get(a.Account_Service__c).Top_Level_Parent_Account__c != null) {
                    parentAcc = newAccounts.get(a.Account_Service__c).Top_Level_Parent_Account__c;
                } else {
                    parentAcc = a.Account_Service__c;
                }
                if(parentAcc != null && a.Parent_Account__c != parentAcc) {
                    a.Parent_Account__c = parentAcc;
                    toUpdate.add(a);
                }
            }
        }
        if(toUpdate.size() != 0) update toUpdate;
    }
    
    public static void updateAccountTopLevelDescendants(list<Account> oldAccounts,map<id,Account> newAccounts){
        
        list<Account> accountsWithUpdate = new list<Account>();
        set<id> oldTopLevelIds = new set<id>();
        for(Account a : oldAccounts){
            if(a.parentid!=newAccounts.get(a.id).parentid){
                oldTopLevelIds.add(a.Top_Level_Parent_Account__c);
                accountsWithUpdate.add(newAccounts.get(a.id));
            }
        }
        
        list<Account> accountsForUpdate = new list<Account>();
        list<Account> allTopLevelDescendants = [Select id, name, parentid, Top_Level_Parent_Account__c from Account where Top_Level_Parent_Account__c in :oldTopLevelIds LIMIT 25000];
        for(Account a : accountsWithUpdate){
            system.debug('***Getting Children for: '+a.name);
            list<Account> descendants=getChildren(a.id,allTopLevelDescendants);
            system.debug('***Number of decendants:' + descendants.size());
            for(Account descendant : descendants){
                system.debug('Updating Child: '+descendant.name+'With new Top Account:'+a.Top_level_Parent_Account__c);
                descendant.Top_Level_Parent_Account__c=a.Top_Level_Parent_Account__c;
                accountsForUpdate.add(descendant);
            }
        }
        update accountsforUpdate;
    }
    
    public static list<Account> getChildren(ID parentID, list<Account> accounts){
        list<Account> children = new list<Account>();
        for(Account a : accounts){
            if(a.parentid==parentid){
                system.debug('***Child Name: ' + a.name);
                children.addAll(getChildren(a.id,accounts));
            }
        }
        for(Account a : accounts){
            if(a.parentid==parentid){
                children.add(a);
            }
        }
        return children;
    }
    
   public static void acnt_type_change_validation_rule(List<Account> accountsList){
        map<String,Account> accsIds = new map<String,Account>();
        list<Asset> assetRecords = new list<Asset>();
        
        //for(Account accs  : trigger.new){
        for(Account accs  : accountsList){
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
    } 
}