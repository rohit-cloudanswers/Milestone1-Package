@isTest
global class test_Utility{
    
    global static void loadCountry(){
        Country__c co = new Country__c();
        co.Country__c = 'US';
        co.Name = 'United States of America';
        co.ISO_Name__c = co.Name;
        co.Country_Code_2__c = 'US';
        co.Country_Code_3__c = 'USA';
        co.Global_Region__c = 'USA';
        co.Region__c = 'USA';
        insert co;
        
    }
    global static Lead createTestLead()
    {
        Lead ld = new Lead();
        ld.FirstName='Test0101';
        ld.LastName='Lead0101';
        ld.Status='New';
        ld.email='test0101lead0101@test.com';
        ld.Company='TestCompany';
        ld.Country='United States of America';
        insert ld;
        return ld;
    }
    global static list<case> createCases(integer num, boolean doInsert){
         
        Account a = new Account();
        a.Name = 'Test';
        a.Oracle_Last_Updated_Date_Time__c = system.now();             
        insert a;
        
        list<case> cases = new list<case>();
        for(integer i = 0; i < num; i++){
            Case c = new Case();  
            c.AccountId = a.id;
            cases.add(c);
        }
        
        if(doInsert && cases.size()>0)
            insert cases;
            
        return cases;
    }
   global static User createAdminUser()
   {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'testUser', Email='adminimagine3291@imaginecommunications.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='adminimagine3291@imaginecommunications.com');
        insert u;
        return u;

   }
    global static void createCaseSLAStatuses(){
        list<Case_Status__c> statuses = new list<Case_Status__c>();
        Case_Status__c css1 = new Case_Status__c();
            css1.Name = 'IsResolved';
            css1.IsResolved__c = true;
            css1.Stops_SLA_Clock__c = true;
            statuses.add(css1);
        Case_Status__c css2 = new Case_Status__c();
            css2.Name = 'IsRestored';
            css2.IsRestored__c = true;
            css2.Stops_SLA_Clock__c = true;
            statuses.add(css2);
        Case_Status__c css3 = new Case_Status__c();
            css3.Name = 'PendingExternal';
            css3.PendingExternalResponse__c = true;
            css3.Stops_SLA_Clock__c = true;
            statuses.add(css3);
        Case_Status__c css4 = new Case_Status__c();
            css4.Name = 'PendingInternal';
            css4.PendingInternalResponse__c = true;
            statuses.add(css4);
        Case_Status__c css5 = new Case_Status__c();
            css5.Name = 'PendingParts';
            css5.PendingPartsOrder__c = true;
            statuses.add(css5);
        insert statuses;
    }
    
    
    
}