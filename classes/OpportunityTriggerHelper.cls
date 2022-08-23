public without sharing class OpportunityTriggerHelper {
    
    public static void OnAfterUpdateDataManipulations(Map<Id,Opportunity> triggerNewMap , Map<Id,Opportunity> triggerOldMap){
        createNoteOnDescriptionUpdates(triggerNewMap,triggerOldMap);
    }
    
    public static void OnAfterInsertDataManipulations(Map<Id,Opportunity> triggerNewMap , Map<Id,Opportunity> triggerOldMap){
        createNoteOnDescriptionUpdates(triggerNewMap,triggerOldMap);
        list<String> opIds = new list<String>();
        for(String eachOpp : triggerNewMap.keySet()){
            opIds.add(eachOpp);
        }
        //Etherios changed this to do this in before trigger
    }

    public static void populateQuoteAddress(List<Opportunity> triggerNewList, Map<Id,Opportunity> triggerOldMap) {
        List<Opportunity> changedOps = new List<Opportunity>();
        //Updatet when Account changes
        for(Opportunity eachOpp : triggerNewList){
            if(triggerOldMap == null || eachOpp.AccountId != triggerOldMap.get(eachOpp.Id).AccountId) {
                changedOps.add(eachOpp);
            }
        }
        if(changedOps.size() != 0) {
            // update Address_Lookup__c for related Quotes
            List<Quote> quotes = [
                SELECT Id, Account_Lookup__c, Billing_Address__c, 
                Shipping_Address__c, OpportunityId 
                FROM Quote 
                WHERE OpportunityId IN :changedOps limit 30
            ];
            for(Quote q : quotes) {
                for(Opportunity opp : changedOps) {
                    if(q.OpportunityId == opp.Id) {
                        q.Account_Lookup__c = opp.AccountId;
                        q.Billing_Address__c = opp.Billing_Address__c;
                        q.Shipping_Address__c = opp.Shipping_Address__c;
                    }
                }
            }
            if(quotes.size() != 0) update quotes;
        }
    }
    
    public static void populateOptyAddress(List<Opportunity> triggerNewList, Map<Id,Opportunity> triggerOldMap){
        list<String> accIds = new list<String>();
        map<String,String> accIdVsAddressMap = new map<String,String>();
        Set<Id> opIds = new Set<Id>();
        List<Opportunity> changedOps = new List<Opportunity>();
        //Updatet when Account changes
        for(Opportunity eachOpp : triggerNewList){
            if(triggerOldMap == null || eachOpp.AccountId != triggerOldMap.get(eachOpp.Id).AccountId){
                accIds.add(eachOpp.accountId);
                opIds.add(eachOpp.Id);
                changedOps.add(eachOpp);
            }
        }
        if(changedOps.size() != 0){
            list<Account> accList = [Select id,Billing_Address__c,Shipping_Address__c from Account where id in:accIds];
            for(Account eachAcc : accList){
                accIdVsAddressMap.put(eachAcc.Id,eachAcc.Billing_Address__c+'~'+eachAcc.Shipping_Address__c);
            }
            //Etherios added, Only update Opportunities in which there are no quotes, 3/10 always update
            //Map<Id,Opportunity> opMap = new Map<Id,Opportunity>([SELECT (SELECT Id from Quotes)FROM Opportunity WHERE Id IN :opIds]);
            for(Opportunity eachOpp : changedOps){
                try{
                    String bAddress = '';
                    String sAddress = '';                
                    if(eachOpp.Billing_Address__c == null){
                        if(!accIdVsAddressMap.isEmpty()){
                            bAddress = accIdVsAddressMap.get(eachOpp.accountId).split('~',0)[0];
                        }
                        if(bAddress != null && bAddress!='' && bAddress != 'null')
                            eachOpp.Billing_Address__c = bAddress;
                    }
                    if(eachOpp.Shipping_Address__c == null){
                        if(!accIdVsAddressMap.isEmpty()){
                            sAddress = accIdVsAddressMap.get(eachOpp.accountId).split('~',0)[1];
                        }
                        if(sAddress != null && sAddress != '' && sAddress != 'null'){
                            eachOpp.Shipping_Address__c = sAddress;
                        }
                    }
                    if(eachOpp.Billing_Address__c == null && eachOpp.Shipping_Address__c!=null){
                        eachOpp.Billing_Address__c = eachOpp.Shipping_Address__c;
                    }
                    if(eachOpp.Billing_Address__c != null && eachOpp.Shipping_Address__c==null){
                        eachOpp.Shipping_Address__c = eachOpp.Billing_Address__c;
                    }
                } catch (exception e) {
                    system.debug('OPP Trigger ERROR: ' + e.getMessage() + e.getStackTraceString());
                }
            }
        }
    }
        
    private static void createNoteOnDescriptionUpdates(Map<Id,Opportunity> triggerNewMap , Map<Id,Opportunity> triggerOldMap){
        List<Note> lstNote = new List<Note>();
        for(Opportunity oppty:triggerNewMap.values()){
            Opportunity oldOppty = new Opportunity();
            if(triggerOldMap != null && triggerOldMap.containsKey(oppty.Id)){
                oldOppty = triggerOldMap.get(oppty.Id);
            }
            if(oppty.Description != null && !oppty.Description.equals(oldOppty.Description)){
                Note note = new Note();
                note.Body = oppty.Description;
                note.ParentId = oppty.Id;
                if(oppty.Name.length() > 80){
                    note.Title = oppty.Name.substring(0, 79);
                } else {
                    note.Title = oppty.Name;
                }
                note.IsPrivate = true;
                lstNote.add(note);
            }
       }
       if(lstNote.size()>0) insert lstNote;
    }
    
    //Method to insert share records on the Opportunity based on the partner account field.
    public static void createSharing(list<Opportunity> triggerNew,map<Id,Opportunity> triggerNewMap){
        Boolean isPartner = false;
        list<OpportunityShare> oppShareList = new list<OpportunityShare>();
        if(Quote_LineItem_Bulkedit__c.getInstance(userInfo.getProfileId()).hasAccess__c == false)
        isPartner = true;
        if(isPartner){
            map<String,String> oppMap = new map<String,String>();
            for(Opportunity each : triggerNewMap.values()){
                    oppMap.put(each.Partner_Name__c,each.Id);
            }
            system.debug('******oppMap********'+oppMap);
            map<Id,Account> partAccList = new map<Id,Account>([Select id,OwnerId,Harris_RSM__c from Account where id in:oppMap.keySet()]);
            list<AccountTeamMember> atmList = new list<AccountTeamMember>();
            atmList = [Select id,AccountId,UserId from AccountTeamMember where accountId in:partAccList.keySet()];
            for(String eachAcc :  partAccList.keySet()){
                oppShareList.add(buildOpportunityShare(oppMap.get(eachAcc), partAccList.get(eachAcc).Harris_RSM__c, 'Edit'));
            }
            for(AccountTeamMember atm : atmList){
                oppShareList.add(buildOpportunityShare(oppMap.get(atm.AccountId), atm.UserId, 'Edit'));
            }
            insert oppShareList;
        }
        else{
            map<String,String> AccVsOpp = new map<String,String>();
            map<String,List<Contact>> accVsContList = new map<String,list<Contact>>();
            map<String,String> contVsUid = new map<String,String>();
            for(Opportunity each : triggerNewMap.values()){
                if(each.recordType.name == 'Indirect Sales')
                AccVsOpp.put(each.Partner_Name__c,each.Id);
            }
            list<Contact> contList = new list<Contact>();
            contList = [Select id,accountId from Contact where accountId in:AccVsOpp.keySet()];
            for(Contact eachCont : contList){
                if(!accVsContList.containsKey(eachCont.accountId)){
                    accVsContList.put(eachCont.accountId,new list<Contact>());
                    accVsContList.get(eachCont.accountId).add(eachCont);
                }
                else
                accVsContList.get(eachCont.accountId).add(eachCont);
            }
            list<User> uList = new list<User>();
            uList = [Select id,contactId from user where contactId in:contList];
            for(User eachUser : uList){
                contVsUid.put(eachUser.contactId,eachUser.Id);
            }
            for(String eachAcc :AccVsOpp.keySet()){
                for(Contact eachCont : accVsContList.get(eachAcc)){
                    oppShareList.add(buildOpportunityShare(AccVsOpp.get(eachAcc), contVsUid.get(eachCont.Id), 'Edit'));
                }
            }
            insert oppShareList;
        }
    }
    
    @TestVisible
    private static OpportunityShare buildOpportunityShare(Id oppId, Id ugId, String accessLevel){
        OpportunityShare oppShare = new OpportunityShare(
            OpportunityId=oppId,
            UserOrGroupId=ugId,
            OpportunityAccessLevel=accessLevel
        );
        return oppShare;
    }
    
    public static void deleteOpporunityProducts(List<Opportunity> opps, Map<Id, Opportunity> oppsMap) {
        // filter opp ids to delete opp line items
        Set<Id> oppIds = new Set<Id>();
        for(Opportunity oldOpp : opps) {
            if(oldOpp.SyncedQuoteId != null) {
                Opportunity newOpp = oppsMap.get(oldOpp.Id);
                if(newOpp != null && newOpp.SyncedQuoteId == null) {
                    oppIds.add(newOpp.Id);
                }
            }
        }
        if(oppIds.size() != 0) delete [select Id from OpportunityLineItem where OpportunityId IN :oppIds];
    }
    
    public static void createOpportunityContactRole(Map<Id, Opportunity> oppsMap){
        List<OpportunityContactRole> contactRoles = new List<OpportunityContactRole>();
        for(String key : oppsMap.keySet()){
            Opportunity opp = oppsMap.get(key);
            if(String.isNotBlank(opp.Created_From__c)){
                String[] parts = opp.Created_From__c.split(':');
                if(parts.size() == 3 && parts[0] == 'Contact' && parts[1] == 'CustomLEX') {
                    contactRoles.add(
                        new OpportunityContactRole(
                            OpportunityId = opp.Id,
                            ContactId = parts[2],
                            IsPrimary = true
                        )
                    );
                }
            }
        }
        if(contactRoles.size() != 0) insert contactRoles;
    }
}