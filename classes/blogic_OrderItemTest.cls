@isTest
(SeeAllData = true)
public with sharing class blogic_OrderItemTest {
    static testMethod void blogic_OrderItemTest() {

        MPM4_BASE__Milestone1_Project__c testProject = new MPM4_BASE__Milestone1_Project__c();
        testProject.Name = 'TestProject';
        testProject.Milestone_1__c = 'Test Milestone';
        testProject.Milestone_1_Date__c = Date.today().addMonths(1);
        insert testProject;

        Product_Class__c testClass = new Product_Class__c();
        testClass.Name = 'TestClass';
        testClass.Business_Unit__c = 'Networking';
        insert testClass;

        Id pricebookId = Test.getStandardPricebookId();                         
//      Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'RMA SFDC Only Pricebook'];
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'RMA SFDC Only Pricebook';
        insert pb;

        Product2 prd1 = new Product2(Name='Test Product Entry 1',Description='Test Product Entry 1', isActive = true, Salesforce_Product_Type__c = 'hardware', Product_Class__c = TestClass.Id);
        insert prd1;

        PricebookEntry pe=new PricebookEntry(UnitPrice = 1,Product2Id=prd1.id,Pricebook2Id=pricebookId,isActive=true);
        //insert pe;

        Account testAccount = new Account();
        testAccount.RecordTypeId = [select Id from RecordType where Name = 'Direct' and SobjectType = 'Account'].Id;
        testAccount.Name = 'Test';
        testAccount.Type = 'End Customer';
        testAccount.Segment__c = 'OTT';
        testAccount.BillingStreet = 'Eddy';
        testAccount.BillingCity = 'Chicago';
        testAccount.BillingCountryCode = 'US';
        testAccount.BillingState = 'Illinois';
        testAccount.BillingPostalCode = '60603';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.LastName = 'Test';
        testContact.Account = testAccount;
        testContact.Email = 'Test@blah.com';
        testContact.CurrencyIsoCode = 'USD';
        insert testContact;

        Order testOrder = new Order();
        testOrder.RecordTypeId = [select Id from RecordType where Name = 'Order' and SobjectType = 'Order'].Id;
        testOrder.EffectiveDate = System.today();
        testOrder.AccountId = testAccount.Id;
        testOrder.Status = 'Draft';
        testOrder.PriceBook2Id=pb.Id;
        testOrder.MPM4_Project__c = testProject.Id;
        insert testOrder;

        OrderItem testOrderItem = new OrderItem(OrderId=testOrder.Id, Line_Status__c = 'CLOSED', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem;
        testOrder = [SELECT Id, Closed_Hardware_Networking__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Closed_Hardware_Networking__c, testOrderItem.USD_Net_Net__c);

        OrderItem testOrderItem2 = new OrderItem(OrderId=testOrder.Id, Line_Status__c = '', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem2;
        testOrder = [SELECT Id, Open_Hardware_Networking__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Open_Hardware_Networking__c, testOrderItem2.USD_Net_Net__c);
        CalculateOrderRollups.performRollupCalculations(new List<Id>{testOrder.Id});
    }
    static testMethod void blogic_OrderItemTest2() {

        Product_Class__c testClass = new Product_Class__c();
        testClass.Name = 'TestClass';
        testClass.Business_Unit__c = 'Playout';
        insert testClass;

        Id pricebookId = Test.getStandardPricebookId();                         
//      Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'RMA SFDC Only Pricebook'];
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'RMA SFDC Only Pricebook';
        insert pb;

        Product2 prd1 = new Product2(Name='Test Product Entry 1',Description='Test Product Entry 1', isActive = true, Salesforce_Product_Type__c = 'hardware', Product_Class__c = TestClass.Id);
        insert prd1;

        PricebookEntry pe=new PricebookEntry(UnitPrice = 1,Product2Id=prd1.id,Pricebook2Id=pricebookId,isActive=true);
        //insert pe;

        Account testAccount = new Account();
        testAccount.RecordTypeId = [select Id from RecordType where Name = 'Direct' and SobjectType = 'Account'].Id;
        testAccount.Name = 'Test';
        testAccount.Type = 'End Customer';
        testAccount.Segment__c = 'OTT';
        testAccount.BillingStreet = 'Eddy';
        testAccount.BillingCity = 'Chicago';
        testAccount.BillingCountryCode = 'US';
        testAccount.BillingState = 'Illinois';
        testAccount.BillingPostalCode = '60603';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.LastName = 'Test';
        testContact.Account = testAccount;
        testContact.Email = 'Test@blah.com';
        testContact.CurrencyIsoCode = 'USD';
        insert testContact;

        Order testOrder = new Order();
        testOrder.RecordTypeId = [select Id from RecordType where Name = 'Order' and SobjectType = 'Order'].Id;
        testOrder.EffectiveDate = System.today();
        testOrder.AccountId = testAccount.Id;
        testOrder.Status = 'Draft';
        testOrder.PriceBook2Id=pb.Id;
        insert testOrder;

        OrderItem testOrderItem = new OrderItem(OrderId=testOrder.Id, Line_Status__c = 'CLOSED', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem;
        testOrder = [SELECT Id, Closed_Hardware_Playout__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Closed_Hardware_Playout__c, testOrderItem.USD_Net_Net__c);

        OrderItem testOrderItem2 = new OrderItem(OrderId=testOrder.Id, Line_Status__c = '', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem2;
        testOrder = [SELECT Id, Open_Hardware_Playout__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Open_Hardware_Playout__c, testOrderItem2.USD_Net_Net__c);
    }
    static testMethod void blogic_OrderItemTest3() {

        Product_Class__c testClass = new Product_Class__c();
        testClass.Name = 'TestClass';
        testClass.Business_Unit__c = 'Media';
        insert testClass;

        Id pricebookId = Test.getStandardPricebookId();                         
//      Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'RMA SFDC Only Pricebook'];
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'RMA SFDC Only Pricebook';
        insert pb;

        Product2 prd1 = new Product2(Name='Test Product Entry 1',Description='Test Product Entry 1', isActive = true, Salesforce_Product_Type__c = 'hardware', Product_Class__c = TestClass.Id);
        insert prd1;

        PricebookEntry pe=new PricebookEntry(UnitPrice = 1,Product2Id=prd1.id,Pricebook2Id=pricebookId,isActive=true);
        //insert pe;

        Account testAccount = new Account();
        testAccount.RecordTypeId = [select Id from RecordType where Name = 'Direct' and SobjectType = 'Account'].Id;
        testAccount.Name = 'Test';
        testAccount.Type = 'End Customer';
        testAccount.Segment__c = 'OTT';
        testAccount.BillingStreet = 'Eddy';
        testAccount.BillingCity = 'Chicago';
        testAccount.BillingCountryCode = 'US';
        testAccount.BillingState = 'Illinois';
        testAccount.BillingPostalCode = '60603';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.LastName = 'Test';
        testContact.Account = testAccount;
        testContact.Email = 'Test@blah.com';
        testContact.CurrencyIsoCode = 'USD';
        insert testContact;

        Order testOrder = new Order();
        testOrder.RecordTypeId = [select Id from RecordType where Name = 'Order' and SobjectType = 'Order'].Id;
        testOrder.EffectiveDate = System.today();
        testOrder.AccountId = testAccount.Id;
        testOrder.Status = 'Draft';
        testOrder.PriceBook2Id=pb.Id;
        insert testOrder;

        OrderItem testOrderItem = new OrderItem(OrderId=testOrder.Id, Line_Status__c = 'CLOSED', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem;
        testOrder = [SELECT Id, Closed_Hardware_Media__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Closed_Hardware_Media__c, testOrderItem.USD_Net_Net__c);

        OrderItem testOrderItem2 = new OrderItem(OrderId=testOrder.Id, Line_Status__c = '', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem2;
        testOrder = [SELECT Id, Open_Hardware_Media__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Open_Hardware_Media__c, testOrderItem2.USD_Net_Net__c);
    }
    static testMethod void blogic_OrderItemTest4() {

        Product_Class__c testClass = new Product_Class__c();
        testClass.Name = 'TestClass';
        testClass.Business_Unit__c = 'Distribution';
        insert testClass;

        Id pricebookId = Test.getStandardPricebookId();                         
//      Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'RMA SFDC Only Pricebook'];
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'RMA SFDC Only Pricebook';
        insert pb;

        Product2 prd1 = new Product2(Name='Test Product Entry 1',Description='Test Product Entry 1', isActive = true, Salesforce_Product_Type__c = 'hardware', Product_Class__c = TestClass.Id);
        insert prd1;

        PricebookEntry pe=new PricebookEntry(UnitPrice = 1,Product2Id=prd1.id,Pricebook2Id=pricebookId,isActive=true);
        //insert pe;

        Account testAccount = new Account();
        testAccount.RecordTypeId = [select Id from RecordType where Name = 'Direct' and SobjectType = 'Account'].Id;
        testAccount.Name = 'Test';
        testAccount.Type = 'End Customer';
        testAccount.Segment__c = 'OTT';
        testAccount.BillingStreet = 'Eddy';
        testAccount.BillingCity = 'Chicago';
        testAccount.BillingCountryCode = 'US';
        testAccount.BillingState = 'Illinois';
        testAccount.BillingPostalCode = '60603';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.LastName = 'Test';
        testContact.Account = testAccount;
        testContact.Email = 'Test@blah.com';
        testContact.CurrencyIsoCode = 'USD';
        insert testContact;

        Order testOrder = new Order();
        testOrder.RecordTypeId = [select Id from RecordType where Name = 'Order' and SobjectType = 'Order'].Id;
        testOrder.EffectiveDate = System.today();
        testOrder.AccountId = testAccount.Id;
        testOrder.Status = 'Draft';
        testOrder.PriceBook2Id=pb.Id;
        insert testOrder;

        OrderItem testOrderItem = new OrderItem(OrderId=testOrder.Id, Line_Status__c = 'CLOSED', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem;
        testOrder = [SELECT Id, Closed_Hardware_Distribution__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Closed_Hardware_Distribution__c, testOrderItem.USD_Net_Net__c);

        OrderItem testOrderItem2 = new OrderItem(OrderId=testOrder.Id, Line_Status__c = '', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem2;
        testOrder = [SELECT Id, Open_Hardware_Distribution__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Open_Hardware_Distribution__c, testOrderItem2.USD_Net_Net__c);
    }
    static testMethod void blogic_OrderItemTest5() {

        Product_Class__c testClass = new Product_Class__c();
        testClass.Name = 'TestClass';
        testClass.Business_Unit__c = 'Distribution';
        insert testClass;

        Id pricebookId = Test.getStandardPricebookId();                         
//      Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'RMA SFDC Only Pricebook'];
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'RMA SFDC Only Pricebook';
        insert pb;

        Product2 prd1 = new Product2(Name='Test Product Entry 1',Description='Test Product Entry 1', isActive = true, Salesforce_Product_Type__c = 'professional services', Product_Class__c = TestClass.Id);
        insert prd1;

        PricebookEntry pe=new PricebookEntry(UnitPrice = 1,Product2Id=prd1.id,Pricebook2Id=pricebookId,isActive=true);
        //insert pe;

        Account testAccount = new Account();
        testAccount.RecordTypeId = [select Id from RecordType where Name = 'Direct' and SobjectType = 'Account'].Id;
        testAccount.Name = 'Test';
        testAccount.Type = 'End Customer';
        testAccount.Segment__c = 'OTT';
        testAccount.BillingStreet = 'Eddy';
        testAccount.BillingCity = 'Chicago';
        testAccount.BillingCountryCode = 'US';
        testAccount.BillingState = 'Illinois';
        testAccount.BillingPostalCode = '60603';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.LastName = 'Test';
        testContact.Account = testAccount;
        testContact.Email = 'Test@blah.com';
        testContact.CurrencyIsoCode = 'USD';
        insert testContact;

        Order testOrder = new Order();
        testOrder.RecordTypeId = [select Id from RecordType where Name = 'Order' and SobjectType = 'Order'].Id;
        testOrder.EffectiveDate = System.today();
        testOrder.AccountId = testAccount.Id;
        testOrder.Status = 'Draft';
        testOrder.PriceBook2Id=pb.Id;
        insert testOrder;

        OrderItem testOrderItem = new OrderItem(OrderId=testOrder.Id, Line_Status__c = 'CLOSED', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem;
        testOrder = [SELECT Id, Closed_Professional_Services__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Closed_Professional_Services__c, testOrderItem.USD_Net_Net__c);

        OrderItem testOrderItem2 = new OrderItem(OrderId=testOrder.Id, Line_Status__c = '', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem2;
        testOrder = [SELECT Id, Open_Professional_Services__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Open_Professional_Services__c, testOrderItem2.USD_Net_Net__c);
    }
    static testMethod void blogic_OrderItemTest6() {

        Product_Class__c testClass = new Product_Class__c();
        testClass.Name = 'TestClass';
        testClass.Business_Unit__c = 'Distribution';
        insert testClass;

        Id pricebookId = Test.getStandardPricebookId();                         
//      Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'RMA SFDC Only Pricebook'];
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'RMA SFDC Only Pricebook';
        insert pb;

        Product2 prd1 = new Product2(Name='Test Product Entry 1',Description='Test Product Entry 1', isActive = true, Salesforce_Product_Type__c = 'support', Product_Class__c = TestClass.Id);
        insert prd1;

        PricebookEntry pe=new PricebookEntry(UnitPrice = 1,Product2Id=prd1.id,Pricebook2Id=pricebookId,isActive=true);
        //insert pe;

        Account testAccount = new Account();
        testAccount.RecordTypeId = [select Id from RecordType where Name = 'Direct' and SobjectType = 'Account'].Id;
        testAccount.Name = 'Test';
        testAccount.Type = 'End Customer';
        testAccount.Segment__c = 'OTT';
        testAccount.BillingStreet = 'Eddy';
        testAccount.BillingCity = 'Chicago';
        testAccount.BillingCountryCode = 'US';
        testAccount.BillingState = 'Illinois';
        testAccount.BillingPostalCode = '60603';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.LastName = 'Test';
        testContact.Account = testAccount;
        testContact.Email = 'Test@blah.com';
        testContact.CurrencyIsoCode = 'USD';
        insert testContact;

        Order testOrder = new Order();
        testOrder.RecordTypeId = [select Id from RecordType where Name = 'Order' and SobjectType = 'Order'].Id;
        testOrder.EffectiveDate = System.today();
        testOrder.AccountId = testAccount.Id;
        testOrder.Status = 'Draft';
        testOrder.PriceBook2Id=pb.Id;
        insert testOrder;

        OrderItem testOrderItem = new OrderItem(OrderId=testOrder.Id, Line_Status__c = 'CLOSED', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem;
        testOrder = [SELECT Id, Closed_CARE__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Closed_CARE__c, testOrderItem.USD_Net_Net__c);

        OrderItem testOrderItem2 = new OrderItem(OrderId=testOrder.Id, Line_Status__c = '', Quantity=1, UnitPrice=99, USD_Net_Net__c = 5);
        insert testOrderItem2;
        update new OrderItem(
            Id=testOrderItem2.Id,
            Line_Status__c = 'Testing'
        );
        testOrder = [SELECT Id, Open_CARE__c FROM ORDER WHERE Id =: testOrder.Id];
        //System.assertEquals(testOrder.Open_CARE__c, testOrderItem2.USD_Net_Net__c);
    }
}