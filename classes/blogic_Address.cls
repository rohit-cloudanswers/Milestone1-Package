public class blogic_Address {
    //utility to copy the masterdetail account to the account lookup
    //included to accommodate legacy volo code
    public static void matchAccount(List<Address__c> newAdds){
        for(Address__c a : newAdds){
            if(a.Account_Service__c!=null){
                a.Account__c = a.Account_Service__c;
            } else {
                if(a.account__c!=null){
                    a.Account_Service__c = a.Account__c;
                }
            }
        }
    }
    
    public static void setSalesforcePrimary(List<Address__c> newAdds){
        set<Id> accountIds = new Set<Id>();
        for(Address__c a : newAdds){
            if(a.Account__c!=null)
                accountIds.add(a.Account__c);
            if(a.Account_Service__c!=null)
                accountIds.add(a.Account_Service__c);
        }
        //get existing adds
        List<Address__c> oldAdds = [SELECT Id, Salesforce_Primary__c, Account_Service__c, Account__c FROM Address__c 
                                    WHERE Salesforce_Primary__c = true AND (Account_Service__c in:accountIds OR Account__c in:accountIds)];
        set<Id> accountsWithPrimary = new Set<Id>();
        for(Address__c a : oldadds){
            if(a.Account__c!=null)
                accountsWithPrimary.add(a.Account__c);
            if(a.Account_Service__c!=null)
                accountsWithPrimary.add(a.Account_Service__c);
        }
        for(Address__c a : newAdds){
            if(!accountsWithPrimary.contains(a.Account__c) && !accountsWithPrimary.contains(a.Account_Service__c) && a.Primary__c == true){
                a.Salesforce_Primary__c = true;
            }
        }
    }
    
    public static void setParentAccount(List<Address__c> newAdds){
        set<Id> AccIds = new Set<Id>();
        for(Address__c a : newAdds){
            if(a.Account_Service__c!=null)
                AccIds.add(a.Account_Service__c);
        }
        map<Id,account> accounts = new Map<Id,Account>([SELECT ID, Name, Top_Level_Parent_Account__c FROM Account WHERE Id in :AccIds]);
        for(Address__c a : newAdds){
            if(a.Account_Service__c!=null && accounts.containsKey(a.Account_Service__c))
                if(accounts.get(a.Account_Service__c).Top_Level_Parent_Account__c != null){
                    a.Parent_Account__c = accounts.get(a.Account_Service__c).Top_Level_Parent_Account__c;
                } else {
                    a.Parent_Account__c = a.Account_Service__c;
                }
        }
        
    }
}