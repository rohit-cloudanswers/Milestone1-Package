global with sharing class LightningLookupCtrl {

    @AuraEnabled
    global static Contact getContactById(String recordId) {
        List<Contact> records = [
            select Id, Name, FirstName, LastName, Email
            from Contact 
            where Id = :recordId
        ];
        return records.get(0);
    }
    
    @AuraEnabled
    global static List<Contact> getContacts(String parentFieldApi, String parentFieldValue, String searchTerm) {
        String query = 'select Id, Name, FirstName, LastName, Email from Contact where Active__c = true ';
        if(String.isNotBlank(searchTerm)) {
            searchTerm = '%' + searchTerm + '%';
		    query += ' and Name like :searchTerm';
        }
        if (String.isNotBlank(parentFieldApi) && String.isNotBlank(parentFieldValue)) {
            query += (' and ' + parentFieldApi + ' = \'' + parentFieldValue + '\'');
        }
        query += ' order by Name asc';
        return Database.query(query);
    }
}