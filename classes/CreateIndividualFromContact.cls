global class CreateIndividualFromContact implements Database.Batchable<sObject> {
    global Database.Querylocator start(Database.BatchableContext BC) {
       //Query to fetch contacts that don't have Individual created. You may modify the query to add custom fields  
       //Please add  "IsPersonAccount = false" condition to below query to exclude person accounts
       return Database.getQueryLocator('Select FirstName, LastName, Salutation, Email, Birthdate from Contact where IndividualId = NULL');
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> contactList) { 
        Map<Id, Individual> individualRecordsToCreate = new Map<Id, Individual>();
        for(Contact con : contactList) {
            individualRecordsToCreate.put(con.Id, new Individual(FirstName = con.FirstName, LastName = con.LastName, Salutation=con.Salutation, Email__c=con.Email, BirthDate=con.BirthDate, Contact_Id__c=con.Id));
        }
        insert individualRecordsToCreate.values();
        for(Contact con : contactList) {
            con.IndividualId = individualRecordsToCreate.get(con.Id).Id;
        }
        update contactList;
    }
    
    global void finish(Database.BatchableContext BC) {}
   
}