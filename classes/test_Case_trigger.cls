@isTest
public class test_Case_trigger{
	
    public static testmethod void testSLACalculations_IsResolved(){ testSLACalculations('IsResolved'); }
    public static testmethod void testSLACalculations_PendingExternal(){ testSLACalculations('PendingExternal'); }
    public static testmethod void testSLACalculations_PendingInternal(){ testSLACalculations('PendingInternal'); }
    public static testmethod void testSLACalculations_PendingParts(){ testSLACalculations('PendingParts'); }
    public static testmethod void testSLACalculations_IsRestored(){ testSLACalculations('IsRestored'); }
    public static testmethod void testSLACalculations_Closed(){ testSLACalculations('Closed'); }
    
    public static void testSLACalculations(String newStatus){
        //create cases
        test_Utility.createCaseSLAStatuses();
        test_Utility.loadCountry();
        list<Case> cases = test_Utility.createCases(2,true);
        
        Test.startTest();
        
        Set<String> closedStatuses = new Set<String>();
        for (CaseStatus status:[Select MasterLabel From CaseStatus where IsClosed=true]) {
            closedStatuses.add(status.MasterLabel);
        }
        system.assertEquals(true,closedStatuses.contains('Closed'));
        User uOwner=test_Utility.createAdminUser();
        //change statuses to open
        for(case c:cases){
            c.Response_Communicated_to_Customer__c = system.now();
            c.ownerID=uOwner.ID;
            c.status = 'Open';
        }
        
        update cases;
        
        //verify status histories created
        list<Case_Status_History__c> histories = [SELECT Id, Previous_Status__c, Status__c, Closed_DateTime__c, Status_Changed__c FROM Case_Status_History__c WHERE Case__c in :cases];
        system.assertNotEquals(0,histories.size());
        for(Case_Status_History__c h : histories){
            system.assertEquals('New',h.Previous_Status__c);
            system.assertEquals('Open',h.Status__c);
            system.assertEquals(null,h.Closed_DateTime__c);
            system.assertNotEquals(null,h.Status_Changed__c);
        }
        
        //test.startTest();
            //change statuses
            for(case c:cases){
                c.status = newStatus;
                c.BusinessHoursId = null;
            }
            update cases;
/*
            for(case c:cases){
                c.status = 'PendingExternal';
            }
            update cases;
            
            for(case c:cases){
                c.status = 'PendingInternal';
            }
            update cases;
            
            for(case c:cases){
                c.status = 'PendingParts';
            }
            update cases;
    
            for(case c:cases){
                c.status = 'IsRestored';
            }
            update cases;
            for(case c:cases){
                c.status = 'Closed';
            }
            update cases;
*/
        test.stopTest();
        
        
        
    }
    
    @isTest
    static void testdefaultAddress(){
        test_Utility.loadCountry();
        Integer numOfRecords = 201;
        Account acc = new Account();
        acc.Name = 'Test Account';
        
        upsert acc;
        
        Address__c adr = TestDataFactory.createAddress(acc);
        upsert adr;
        
        RecordType rtype = [Select Id,Name from RecordType where Name = 'Service' and SobjectType='Case' LIMIT 1];
        
        
        List<Case> cases = new List<Case>();
        for(Integer i=0;i<numOfRecords;i++){
            Case c= new Case();
            c.RecordType = rtype;
            c.AccountId = acc.Id;
            
            cases.add(c);
        }
        
        Test.startTest();
        insert cases;
        Test.stopTest();
        
        //Validating the default address
        List<Case> updtCase =[Select Id,Record_Type__c,AccountId,address__c
                             from Case where Record_Type__c = 'Service' AND AccountId =: acc.Id AND address__c =:adr.Id];
        System.assertNotEquals(updtCase, null);
    
    }
    
    @isTest
    static void checkArticleAttached_test() {
        test_Utility.loadCountry();
        //create test data
        
        Id serviceId = [SELECT id FROM RecordType WHERE SobjectType = 'Case' AND Name = 'Service'][0].id;
        
        Account acc1 = new Account();
        acc1.Name = 'test account 1';
        acc1.Oracle_Last_Updated_Date_Time__c = datetime.now();
        insert acc1;
        
        Contact con = new Contact();
        con.LastName = 'conLastName';
        con.AccountId = acc1.id;
        con.Email = 'test12345@aol.com';
        insert con;
        
        Asset asset1 = new Asset();
        asset1.Name = 'test asset';
        asset1.AccountId = acc1.id;
        asset1.ContactId = con.id;
        insert asset1;
        
        Case case1 = new Case();
        case1.RecordTypeId = serviceId;
        case1.AccountId = acc1.id;
        case1.Type = 'Performance';
        case1.Product_Line__c = 'Stream';
        case1.ContactId = con.id;
        case1.Priority = '2-High';
        case1.Status = 'Open';
        case1.Response_Communicated_to_Customer__c = Date.today();
        //insert case1;
        
        Case case2 = new Case();
        case2.RecordTypeId = serviceId;
        case2.AccountId = acc1.id;
        case2.Type = 'Performance';
        case2.Product_Line__c = 'Stream';
        case2.ContactId = con.id;
        case2.Priority = '2-High';
        case2.Status = 'New';
        case2.Resolution__c = 'test resolution';
        case2.Resolution_Type__c = 'Code Change';
        case2.Status = 'New';
        //insert case2;
        insert new List<Case>{case1, case2};
            
        Case case3 = new Case();
        case3.RecordTypeId = serviceId;
        case3.AccountId = acc1.id;
        case3.Type = 'DOA';
        case3.Product_Line__c = 'Stream';
        case3.ContactId = con.id;
        case3.Priority = '2-High';
        case3.Status = 'Closed';
        case3.Resolution__c = 'test resolution';
        case3.Resolution_Type__c = 'Work Order';
        case3.AssetId = asset1.id;

        Test.startTest();
        try{
         case2.Status = 'Closed';
         case2.Resolution__c = 'test';
         case2.Resolution_Type__c = 'Work Order';
         update case2;
        } catch (Exception ex){
            System.debug('errorCase2::'+ex.getMessage());
        }
        try{
        insert case3;
        } catch (Exception ex){
            System.debug('errorCase3::'+ex.getMessage());
        }
        //add time entries
        Time_entry__c te = new Time_entry__c();
        te.case__c = case1.id;
        te.Date__c = system.today();
        te.Service_Rep__c = case1.OwnerId;
        te.Type__c = 'Communication';
        te.Time_Spent_Minutes__c = 10;
        insert te;
        case1.Resolution__c = 'test resolution';
        case1.Resolution_Type__c = 'Work Order';
        case1.Status = 'Closed';
        case1.AssetId = asset1.id;
        update case1;
        
        Test.stopTest();
        
        //requery
        Map<Id, Case> caseMap = new Map<Id, Case>([SELECT id, Status FROM Case]);
        
        //assertions
        //System.assertEquals(caseMap.get(case1.id).Status, 'Closed');
        //System.assertEquals(caseMap.get(case2.id).Status, 'New');
        //System.assertEquals(caseMap.get(case3.id).Status, 'Closed');
    }
    
    @isTest
    static void test_updateProductAlertEmail(){
        test_Utility.loadCountry();
        //create test data
        Id serviceId = [SELECT id FROM RecordType WHERE SobjectType = 'Case' AND Name = 'Service'][0].id;
        
        
        
        Account acc1 = new Account();
        acc1.Name = 'test account 1';
        acc1.Oracle_Last_Updated_Date_Time__c = datetime.now();
        insert acc1;
        
        Address__c add1 = new Address__c();
        add1.Name = 'test address 1';
        add1.Street_Address__c = '876 test1';
        add1.City__c = 'Chicago';
        add1.State__c = 'Illinois';
        //add1.Country__c = 'United States of America';
        add1.Country__c = 'US';
        add1.Zip_Code__c = '60646';
        add1.Account_Service__c = acc1.id;
        add1.Salesforce_Primary__c = true;
        add1.Bill_To__c = true;
        add1.Oracle_Last_Updated_Date_Time__c = Datetime.now();
        add1.Operating_Unit__c = 'US OU';
        add1.Region__c = 'NORTH AMERICA';
        add1.Sub_Region__c = 'US';
        insert add1;
        
        acc1.Billing_Address__c = add1.id;
        acc1.Shipping_Address__c = add1.id;
        update acc1;
        
        Contact con = new Contact();
        con.LastName = 'conLastName';
        con.AccountId = acc1.id;
        con.Email = 'test12345@aol.com';
        insert con;
        
        Asset asset1 = new Asset();
        asset1.Name = 'test asset';
        asset1.AccountId = acc1.id;
        asset1.ContactId = con.id;
        insert asset1;
        
        Case case1 = new Case();
        case1.RecordTypeId = serviceId;
        case1.AccountId = acc1.id;
        case1.Type = 'Performance';
        case1.Product_Line__c = 'Stream';
        case1.ContactId = con.id;
        case1.Priority = '2-High';
        case1.Status = 'Open';
        case1.Response_Communicated_to_Customer__c = Date.today();
        case1.Product_Line__c = 'Automation';
        case1.Product_Family__c = 'AI';
        insert case1;
        
        Case case2 = new Case();
        case2.RecordTypeId = serviceId;
        case2.AccountId = acc1.id;
        case2.Type = 'Performance';
        case2.Product_Line__c = 'Stream';
        case2.ContactId = con.id;
        case2.Priority = '2-High';
        case2.Status = 'Open';
        case2.Response_Communicated_to_Customer__c = Date.today();
        case2.Product_Line__c = 'Automation';
        case2.Product_Family__c = 'AI';
        
        Product_Alert_Email__c pa1 = new Product_Alert_Email__c();
        pa1.Name = 'test 1';
        pa1.Email__c = 'test1@aol.com';
        pa1.Product_Line__c = 'Automation';
        pa1.Product_Family__c = 'ADC';
        pa1.Region__c = 'NORTH AMERICA';
        pa1.Sub_Region__c = 'US';
        insert pa1;
        
        Product_Alert_Email__c pa2 = new Product_Alert_Email__c();
        pa2.Name = 'test 2';
        pa2.Email__c = 'test2@aol.com';
        pa2.Product_Line__c = 'Automation';
        pa2.Product_Family__c = 'AI';
        pa2.Region__c = 'NORTH AMERICA';
        pa2.Sub_Region__c = 'US';
        insert pa2;
        
        Test.startTest();
        case1.Product_Family__c = 'ADC';
        upsert new List<Case>{case1,case2};
        
        Test.stopTest();
        
        //requery
        Map<ID, Case> caseMap = new Map<Id, Case>([SELECT id, Product_Alert_Email__c FROM Case ]);
        
    }
}