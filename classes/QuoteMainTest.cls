/*
 Modification History : Appshark || 26th Dec 2014 || ISSUE 10: Defect on Indirect Quote with Tier Discount
                        Replaced Tier_Discount__c field with Tier_Discount2__c in all areas. 
*/
@isTest(seealldata=true)
public with sharing class QuoteMainTest {

 static testMethod void testOnBeforeInsertDataManipulation(){
    /*test.startTest();
    Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
    insert testAccount;
    Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
    insert cty;
    Address__c testAddress = new Address__c(Account__c = testAccount.Id, Active__c = true, Street_Address__c='test Street Address',Salesforce_Primary__c=true, State__c= 'California' , Country__c = 'United States of America');
    insert testAddress;      
   
    Pricebook2 pb =  new Pricebook2(isActive = true, Name='Canadian Domestic List Prices (CAD)', Currency_Code__c='CAD');
    insert pb;

    Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.ID,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
    insert testOpportunity;
    test.stopTest();
    Quote testQuote = new Quote(Name = 'test Quote', OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.ID,Additional_DIscount__c = 10, Tier_Discount2__c = 20 );   
    insert testQuote;
    
    List<String> productTypeList = new List<String>();
    productTypeList.add('Software');
    //productTypeList.add('Hardware');
    //productTypeList.add('Professional Services');
    //productTypeList.add('Support');
    //productTypeList.add('OEM');
    List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
    
    for(String productType : productTypeList){
        QuoteLineItem item = createQuoteLineItem(productType,testQuote.Id,pb.Id,10,100);
        if(item != null){
            quoteLineItemList.add(item);
        }
    }
    QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
    QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = true;  
    insert quoteLineItemList;   
    Double total = 0;
    //Double extCost = 0;
    testOpportunity = [select Billing_Address__c,Shipping_Address__c from Opportunity where Id=:testOpportunity.Id];
    testQuote = [select Id,TotalPrice,Total_Extended_Cost__c, Margin__c,Service_Discount__c,Support_Discount__c,OEM_Discount__c,Tier_Discount2__c,Additional_DIscount__c,Software_Discount__c,Hardware_Discount__c,NEW_Grand_Total__c,Account_Lookup__r.Id,Account_Lookup__c,Billing_Address__r.Id,Billing_Address__c,Shipping_Address__r.Id,Shipping_Address__c from Quote where Id=:testQuote.Id];
    system.assertEquals(testQuote.Additional_DIscount__c,10);
    for(QuoteLineItem item : [select Id,TotalPrice,Extended_Cost__c,Line_Discount__c,Discount,Product_type__c,Product_Line__c from QuoteLineItem where QuoteId=:testQuote.Id]){
        if(item.Product_Type__c == 'Software'){
            system.assertEquals(item.Line_Discount__c,testQuote.Software_Discount__c);
        }
        else if (item.Product_Type__c == 'Hardware'){
            system.assertEquals(item.Line_Discount__c,testQuote.Hardware_Discount__c);
        }
        else if (item.Product_Type__c == 'Professional Services'){
            system.assertEquals(item.Line_Discount__c,testQuote.Service_Discount__c);
        }
        else if (item.Product_Type__c == 'Support'){
            system.assertEquals(item.Line_Discount__c,testQuote.Support_Discount__c);
        }
        else if (item.Product_Type__c == 'OEM'){
            system.assertEquals(item.Line_Discount__c,testQuote.OEM_Discount__c);
        }
        total = total + item.TotalPrice;
        //extCost = extCost + item.Extended_Cost__c;        
    }
    
    
    testQuote.Software_Discount__c = 15;
    testQuote.Hardware_Discount__c = 20;
    testQuote.Support_Discount__c = 25;
    testQuote.OEM_Discount__c = 30;
    testQuote.Service_Discount__c = 35;
    testQuote.Professional_Service_Requested__c = true;
    testQuote.submit_to_ps__c = true;
    testQuote.Additional_DIscount__c = 25;
    QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
    QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = true;     
    update testQuote;
    for(QuoteLineItem item : [select Id,TotalPrice,Line_Discount__c,Discount,Product_type__c,Product_Line__c from QuoteLineItem where QuoteId=:testQuote.Id]){
        if(item.Product_Type__c == 'Software'){
            system.assertEquals(item.Line_Discount__c,15);
        }
        else if (item.Product_Type__c == 'Hardware'){
            system.assertEquals(item.Line_Discount__c,20);
        }
        else if (item.Product_Type__c == 'Professional Services'){
            system.assertEquals(item.Line_Discount__c,35);
        }
        else if (item.Product_Type__c == 'Support'){
            system.assertEquals(item.Line_Discount__c,25);
        }
        else if (item.Product_Type__c == 'OEM'){
            system.assertEquals(item.Line_Discount__c,30);
        }
       // system.assertEquals(item.Discount, item.Line_Discount__c + testQuote.Additional_DIscount__c);
    }
    testQuote.submit_to_ps__c = false;
    QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
    QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = true;     
    update testQuote;
    testQuote.submit_to_ps__c = true;
    QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
    QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = true; 
    update testQuote;
    Pricebook2 pb1 = [select Id from Pricebook2 where isActive = true Limit 1];
    testQuote.Default_Price_Book__c = pb1.Id;
    try{
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = true; 
        update testQuote;
        system.assert(false);
    } catch(DMLException ex){
        
    }*/
 }

 static testMethod void testQuoteUpdate() {
    test.startTest();
    Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
    insert testAccount;
    Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
    insert cty;
    Address__c testAddress = TestDataFactory.createAddress(testAccount);
    
    Pricebook2 pb = [select Id from Pricebook2 where isActive = true and Name='Canadian Domestic List Prices (CAD)'];
    Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.ID,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
    insert testOpportunity;
    test.stopTest();
    
    Pricebook2 pb1 = [select Id from Pricebook2 where isActive = true Limit 1];
    Quote testQuote = new Quote(Name = 'test Quote', OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.ID,Additional_DIscount__c = 10,Hardware_Discount__c=50);  
    testQuote.Support_Type__c = 'Care Plus'; 
    insert testQuote;

    List<String> productTypeList = new List<String>();
    productTypeList.add('Software');
    //productTypeList.add('Hardware');
    //productTypeList.add('Professional Services');
    //productTypeList.add('Support');
    //productTypeList.add('OEM');
    List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
    
    for(String productType : productTypeList){
        QuoteLineItem item = createQuoteLineItem(productType,testQuote.Id,pb.Id,10,100);
        if(item != null){
            quoteLineItemList.add(item);
        }
    }
    QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
    QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = true;  
    insert quoteLineItemList; 


    testQuote.Default_Price_Book__c = pb1.Id;
    testQuote.Hardware_Discount__c = 2;
    testQuote.Software_Discount__c= 2;
    testQuote.Service_Discount__c= 2;
    testQuote.Support_Discount__c= 2;
    testQuote.Managed_Services_Discount__c = 2;
    testQuote.OEM_Discount__c= 2;
    testQuote.OEM_Hardware_Discount__c= 2;
    testQuote.OEM_Software_Discount__c= 2;
    testQuote.OEM_Professional_Services_Discount__c= 2;
    testQuote.OEM_Managed_Services_Discount__c = 2;
    testQuote.OEM_Support_Discount__c= 2;
    testQuote.Support_Type__c = 'Care';
    update testQuote;
    system.assert(true);
    Map<Id,Quote> quoteMap = new Map<Id,Quote>();
    quoteMap.put(testQuote.Id,testQuote);
    //QuoteTriggerHelper.processSupportProduct(quoteMap.values(),quoteMap);
    QuoteTriggerHelper.insertDefaultSolution(quoteMap.values());
 }
 
 public  static QuoteLineItem createQuoteLineItem(String productType,Id quoteId , Id priceBookId, Integer quantity , Integer unitPrice){
    Product2 product = new Product2();
    product.Product_Cost__c = unitPrice ;
    product.Name = 'test';
    product.Salesforce_Product_Type__c = productType;
    product.IsActive = true;
    product.CurrencyIsoCode  ='CAD';
    insert product;
    PricebookEntry pbe = new PricebookEntry();
    pbe.product2id = product.Id;
    pbe.pricebook2id = priceBookId;
    pbe.UnitPrice = unitPrice;
    pbe.IsActive = true;
    pbe.CurrencyIsoCode = 'CAD';
    insert pbe;
    system.debug('*****pbe*****'+pbe);
    QuoteLineItem item = new quotelineitem(); 
    item.pricebookentryid = pbe.id; 
    item.quantity = quantity; 
    item.unitprice = unitPrice;
    item.QuoteId = quoteId;
    return item;
 }


 /*
  private static testMethod void updateQuotePartnerUser(){
            
        UserRole r = [Select Id from UserRole limit 1];
        Account portalAccount1 = new Account(
            Name = 'TestAccount'
        );
        Database.insert(portalAccount1);
      
        //Create contact for the account, which will enable partner portal for account
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'Amit',
            AccountId = portalAccount1.Id,
            Email = 'test@test.com'
        );
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Partner User' Limit 1];
        
        Database.insert(contact1); 

        User user1 =new User(
            Username = 'test12345test@test.com',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            UserRole = r,
            LastName = 'Kumar',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1);            
    system.runAs(user1){
        test.startTest();
        Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
        insert testAccount;     
        
        Pricebook2 pb = [select Id from Pricebook2 where isActive = true and Name='Canadian Domestic List Prices (CAD)'];
        RecordType RecType = [Select Id From RecordType  Where SobjectType = 'Opportunity' and DeveloperName = 'Indirect_Sales'];
        Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.ID,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing',RecordTypeId=RecType.Id,partner_Name__c = testAccount.Id);
        insert testOpportunity;
        test.stopTest();
        Quote testQuote = new Quote(Name = 'test Quote', OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.ID,Additional_DIscount__c = 10);   
        insert testQuote; 
    } 
  }
  */
  static testMethod void testQuoteClone(){
    test.startTest();
    Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
    insert testAccount;
    Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
    insert cty;
    Address__c testAddress = TestDataFactory.createAddress(testAccount);
    
    Pricebook2 pb = [select Id from Pricebook2 where isActive = true and Name='Canadian Domestic List Prices (CAD)'];
    Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.ID,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
    insert testOpportunity;
    test.stopTest();
    Quote testQuote = new Quote(Name = 'test Quote', OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.ID,Additional_DIscount__c = 10);   
    insert testQuote;
    
    List<String> productTypeList = new List<String>();
    productTypeList.add('Software');
    productTypeList.add('Hardware');
    productTypeList.add('Professional Services');
    productTypeList.add('Managed Services');
    productTypeList.add('Support');
    productTypeList.add('OEM');
    List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
    
    for(String productType : productTypeList){
        QuoteLineItem item = createQuoteLineItem(productType,testQuote.Id,pb.Id,10,100);
        if(item != null){
            quoteLineItemList.add(item);
        }
    }
    QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
    //QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = true;
    insert quoteLineItemList;   
    quoteCloneHelper.processClone(testQuote.Id);
    OpportunityConvert_WS.updateQuote(testQuote.Id);
    OpportunityConvert_WS.updateQuoteStatus(testQuote.Id);
    OpportunityConvert_WS.isPartnerUser();
    String profileId = [Select id from profile where name ='Partner User' limit 1].Id;
    user u = [SELECT ID FROM User Where Alias = 'SBLBCDOR' LIMIT 1];
    //Etherios add new user with this profile instead of query
    Account portalAccount1 = new Account(
        Name = 'TestAccount',
        ownerId = u.Id
    );
    Database.insert(portalAccount1);
    
    Contact contact1 = new Contact(
        Salutation='Mr.',
        FirstName = 'Test',
        Lastname = 'Amit',
        AccountId = portalAccount1.Id,
        Email = 'test@test.com'
    );
    insert contact1;
    
    
    String uRole = [SELECT Id, PortalType FROM UserRole WHERE PortalRole != null AND PortalType='Partner' AND developerName = 'TestPartnerAccountPartnerExecutive' LIMIT 1].Id;
    User user1 =new User(
    Username = 'test12345testQuoteTestImagineProd'+Integer.valueOf(math.rint(math.random()*1000000))+'@test.comm',
    ProfileId = profileId,
    ContactId = contact1.Id,
    Alias = 'ttz87y',
    Email = 'tzzz12345@test.com',
    EmailEncodingKey = 'UTF-8',
    LastName = 'Kumar',
    CommunityNickname = 'tzzz125',
    TimeZoneSidKey = 'America/Los_Angeles',
    LocaleSidKey = 'en_US',
    LanguageLocaleKey = 'en_US',
    UserRoleId = urole,
    isactive = true
    );
      system.runAs(u){
          //Database.insert(user1);            
      }
    user1 = [SELECT ID FROM User WHERE Alias = 'jadam' LIMIT 1];
    OpportunityConvert_WS.getLoggedInUserAccount(user1.Id);
 }
 
 static testMethod void testOppConvertToDirect(){
    Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
    insert testAccount;
    Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
    Map<String,Schema.RecordTypeInfo> rtM = d.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rt =  rtM.get('Trials');
    String recTypeId =  rt.getRecordTypeId();
    Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',recordtypeId=recTypeId,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
    insert testOpportunity;
    OpportunityConvert_WS.convertToDirectOpty(testOpportunity.Id);
 }
 static testMethod void testOppConvertToInDirect(){
    Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
    insert testAccount;
    Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
    Map<String,Schema.RecordTypeInfo> rtM = d.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rt =  rtM.get('Trials');
    String recTypeId =  rt.getRecordTypeId();
    Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',recordtypeId=recTypeId,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
    insert testOpportunity;
    OpportunityConvert_WS.convertToIndirectOpty(testOpportunity.Id);
 }
 public static QuoteLineItem createQuoteLineItem(Product_class__c productClass,Id quoteId , Id priceBookId, Integer quantity , Integer unitPrice,String type, String subType){
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        QuoteLineItemTriggerManager.ALLOWPRODUCTUPDATE = false;
        Product2 product = new Product2();
        product.Product_Cost__c = 50 ;
        product.Name = 'test';
        product.NonDiscountable__c =  false;
        product.Product_Type__c = type;
        product.Salesforce_Product_Type__c = subType;
        product.Product_Class__c = productClass.Id;
        product.IsActive = true;
        product.CurrencyIsoCode = 'CAD';
        insert product;
        PricebookEntry pbe = new PricebookEntry();
        pbe.product2id = product.Id;
        pbe.pricebook2id = priceBookId;
        pbe.UnitPrice = unitPrice;
        pbe.IsActive = true;
        pbe.CurrencyIsoCode = 'CAD';
        insert pbe;
        QuoteLineItem item = new quotelineitem(); 
        item.pricebookentryid = pbe.id; 
        item.quantity = quantity; 
        item.unitprice = unitPrice;
        item.QuoteId = quoteId;
        item.Line_Discount__c = null;
        return item;
    }      
 /*static testMethod void testAccountHierachy(){
    Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
    insert testAccount;
    Test.SetCurrentPageReference(new PageReference('Page.AccountHierarchyPage'));
    Apexpages.currentPage().getParameters().put('id',testAccount.Id);
    AccountStructure obj = new AccountStructure();
    obj.formatObjectStructure(testAccount.Id);
 }*/
}