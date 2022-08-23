public with sharing class NewQuoteController {

    @AuraEnabled
    public static Map<String, Object> getDefaultValues(String oppId){
        Map<String, Object> defaultValues = new Map<String, Object>();
        // get field mapping from custom setting
        Map<String, Quote_Defaults__c> qdMap = Quote_Defaults__c.getAll();
        List<String> oppFields = new List<String>();
        for(String key : qdMap.keySet()){
            Quote_Defaults__c qd = qdMap.get(key);
            if(qd.Is_Opportunity_Field__c == true) {
                oppFields.add(qd.Value_Source__c);
            } else {
                defaultValues.put(key, qd.Value_Source__c);
            }
        }
        String query = 'select RecordType.Name, ' + String.join(oppFields, ',');
        query += ' from Opportunity where Id =: oppId';
        Opportunity opp = (Opportunity) Database.query(query);
        for(String key : qdMap.keySet()){
            Quote_Defaults__c qd = qdMap.get(key);
            if(qd.Is_Opportunity_Field__c == true) {
                defaultValues.put(key, opp.get(qd.Value_Source__c));
            }
        }
        if(opp.RecordType.Name == 'Direct Sales') {
            defaultValues.put('RecordTypeId', '012i0000000xkOsAAI');
        } else if(opp.RecordType.Name == 'Indirect Sales'){
            defaultValues.put('RecordTypeId', '012i0000000xkOtAAI');
        } else if(opp.RecordType.Name == 'Trials'){
            defaultValues.put('RecordTypeId', '012i0000000xkOsAAI');
        }
        // populate Contact, Email and Phone with primary contact role
        List<OpportunityContactRole> contactRoles = [
            select ContactId, Contact.Name, Contact.Email, Contact.Phone, Contact.Fax
            from OpportunityContactRole 
            where OpportunityId = :oppId and IsPrimary = true
        ];
        if(contactRoles.size() != 0) {
            OpportunityContactRole contactRole = contactRoles.get(0);
            defaultValues.put('ContactId', contactRole.ContactId);
            defaultValues.put('Email', contactRole.Contact.Email);
            defaultValues.put('Phone', contactRole.Contact.Phone);
            defaultValues.put('Fax', contactRole.Contact.Fax);
        }
        defaultValues.put('OpportunityId', oppId);
        return defaultValues;
    }
}