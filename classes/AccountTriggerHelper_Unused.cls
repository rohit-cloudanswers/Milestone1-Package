public with sharing class AccountTriggerHelper_Unused {
    
    public static void OnBeforeInsertDataManipulations(List<Account> newAccounts){
        addOwnerIdtoAccount(newAccounts);
    }
    
    public static void OnBeforeUpdateDataManipulations(List<Account> newAccounts){
        addOwnerIdtoAccount(newAccounts);
    }
    
    private static void addOwnerIdtoAccount(List<Account> newAccounts){
        List<Id> recordTypeIdList = new List<Id>();
        for(Account newAcct : newAccounts){
            recordTypeIdList.add(newAcct.RecordTypeId);
        }
        Map<Id,RecordType> recTypeMap = new Map<Id,RecordType>([select Id,name from RecordType where SobjectType = 'Account' and Id =: recordTypeIdList]);
        List<Lead> leadList = new List<Lead>();
        Map<String,Account> accountNameMap = new Map<String,Account>();
        for(Account newAcct : newAccounts){
            Lead newLead = new Lead();
            RecordType recType = recTypeMap.get(newAcct.RecordTypeId);
            String rectypename = String.ValueOf(recType.name);
            newLead.Assgn_Account_RecType__c = rectypename; 
            newLead.Assgn_Account_Name__c  =  newAcct.name;
            accountNameMap.put(newAcct.name,newAcct);
            if(newAcct.type != null) {
                 newLead.Assgn_Account_Type__c = newAcct.type;
            }
            else{
                newLead.Assgn_Account_Type__c = null;
            }
            if(newAcct.Region_Channel_Partner__c != null && newAcct.Region_Channel_Partner__c != '') {
                 newLead.Assgn_Account_Region__c = newAcct.Region_Channel_Partner__c;
            }
            else {
                newLead.Assgn_Account_Region__c =  null;
            }
            if(newAcct.Sub_Region__c != null ) {
                 newLead.Assgn_Account_SubRegion__c = newAcct.Sub_Region__c;
            }
            else {
                newLead.Assgn_Account_SubRegion__c =  '';
            }
            if(newAcct.BillingCountry != null ) {
                 newLead.Assgn_Account_BillCtry__c = newAcct.BillingCountry;
            }
            else {
                newLead.Assgn_Account_BillCtry__c =  '';
            }
            if(newAcct.BillingState != null ) {
                 newLead.Assgn_Account_BillState__c = newAcct.BillingState;
            }
            else {
                newLead.Assgn_Account_BillState__c =  '';
            }
            if(newAcct.ShippingState != null ) {
                 newLead.Assgn_Account_ShipState__c = newAcct.ShippingState;
            }
            else {
                newLead.Assgn_Account_ShipState__c =  '';
            }
            if(newAcct.BillingPostalCode != null ) {
                 newLead.Assgn_Account_BillZip__c = newAcct.BillingPostalCode;
            }
            else {
                newLead.Assgn_Account_BillZip__c =  '';
            }
            if(newAcct.ShippingPostalCode != null ) {
                 newLead.Assgn_Account_ShipZip__c = newAcct.ShippingPostalCode;
            }
            else {
                newLead.Assgn_Account_ShipZip__c =  '';
            }
            if(newAcct.Sic != null ) {
                 newLead.Assgn_Account_Sic__c = newAcct.Sic;
            }
            else {
                newLead.Assgn_Account_Sic__c =  '';
            }
            newLead.company = 'bdfdfsssss';
            newLead.lastName = 'test123';
            newLead.status = 'New';
            newLead.City = 'whatever12';
            newLead.Country = 'United States of America';
            newLead.State = 'Texas';
            newLead.Street = 'sdkjhaskdjhasd';
            newLead.PostalCode = 'ddsfffdfdpostal'; 
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.assignmentRuleId= '01Qe0000000DIOV'; //Account Assign Rule(Indirect)DONOTDEL
            newLead.setOptions(dmo);
            leadList.add(newLead);
        }
        Savepoint sp = Database.setSavepoint();
        //if(!test.isRunningTest()){
            insert leadList;  
            List<Id> leadIds = new List<Id>();
            for(Lead newLead : leadList){  
                leadIds.add(newLead.Id);
            }
            for(Lead newLead : [select id,Assgn_Account_Name__c, owner.name, owner.id  from lead where lead.id in: leadIds]){
                String owner = newLead.owner.name;
                if (newLead.owner.id != null)
                { 
                    accountNameMap.get(newLead.Assgn_Account_Name__c).ownerid = newLead.owner.id;
                }
            }
            Database.rollback(sp);
        //}
    }
}