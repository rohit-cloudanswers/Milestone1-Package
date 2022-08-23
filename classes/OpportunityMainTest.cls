@isTest
private class OpportunityMainTest {
  static testMethod void descriptionToNotes() {
      test.startTest();
      List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name = 'Direct'];
      Account testAccount = new Account(Name = 'test Account',Status__c ='Active',RecordTypeId = rtypes.get(0).Id);
      insert testAccount;
      Contact con = new Contact(FirstName='John',LastName='Smith',Email='john.smith@ccp.io',AccountId=testAccount.Id);
      insert con;
      Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity', AccountId=testAccount.Id,StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing',Created_From__c='Contact:CustomLEX:'+con.Id);
      insert testOpportunity;
      List<Note> checkNote = [select Id,Body from Note where ParentId=:testOpportunity.Id];
     // System.assertEquals(checkNote.size(),1);
      Product_Breakout__c testBreakout = new Product_Breakout__c(Line_of_Business__c = 'Media: Ad Sales', Opportunity__c = testOpportunity.Id, Product_Group__c = 'ADC', Product_Breakout_Amount__c = 2314);
      insert testBreakout;
      testOpportunity.Description = 'check now';
      update testOpportunity;
      List<Note> checkNoteNow = [select Id,Body from Note where ParentId=:testOpportunity.Id];
      //System.assertEquals(checkNoteNow.size(),2);      
      //System.assertEquals(checkNoteNow.get(1).Body==testOpportunity.Description,true);
      test.stopTest();
   }
   
   static testMethod void opportunityUpdateValidation() {
      test.startTest();
      List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name = 'Direct'];      
      Account testAccount = new Account(Name = 'TestAccount', Status__c ='Active',RecordTypeId = rtypes.get(0).Id);
      insert testAccount;
      Opportunity testOppty = new Opportunity(Name = 'TestOppty',AccountId=testAccount.Id, CloseDate = System.today()+30,StageName='01 - Prospect - Not Qualified');
      insert testOppty;
      try
      {
          testOppty.Probability = 15;
          update testOppty;
      }
      catch(DmlException e){
      } 
      test.stopTest();
   }
    
    @IsTest(SeeAllData=true)
   static void shouldDeleteOpportunityProductsOnUnsync() {
      QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = true;
      Account acc = new Account(Name='test account', Status__c='Active', Partner_Product_Prices__c='US Domestic', RecordTypeId=[SELECT id FROM RecordType where sobjectType='Account' AND Name='Channel Partner' limit 1].id);
      insert acc;
      Address__c add1 = new Address__c(Account__c = acc.id, Name='test Address 1', Street_Address__c ='745 test avenue', Country__c ='United States of America', City__c = 'Boston', Salesforce_Primary__c = true, State__c = 'Massachusetts', Zip_Code__c ='02144', Bill_To__c=true,Ship_To__c=true);
      Address__c add2 = new Address__c(Account__c = acc.id, Name='test Address 2', Street_Address__c ='15 test road', Country__c ='United States of America', City__c = 'Boston', Salesforce_Primary__c = false, State__c = 'Massachusetts', Zip_Code__c ='02111', Bill_To__c=true,Ship_To__c=true);
      insert new List<Address__c>{add1, add2};
      
      Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE IsStandard=true AND CurrencyISOCode = 'USD' AND IsActive=true limit 1][0];
      Product_Class__c pc = new Product_Class__c();
      pc.Product_Line__c = 'Automation';
      pc.Business_Unit__c = 'Networking';
      insert pc;
      
      Product2 prod1 = new Product2(Name='test product 1', ProductCode='FRINKSD', Product_Type__c='Hardware', Salesforce_Product_Type__c = 'Hardware', Product_Class__c = pc.Id, Quotable__c=true);
      Product2 prod2 = new Product2(Name='test product 2', ProductCode='FRINKSE', Product_Type__c='OEM',Salesforce_Product_Type__c = 'Hardware', Product_Class__c = pc.Id, Quotable__c=true);
      Product2 prod3 = new Product2(Name='test product 3', ProductCode='FRINKSF', Product_Type__c='Professional Services',Salesforce_Product_Type__c = 'Hardware', Product_Class__c = pc.Id, Quotable__c=false);
      Product2 prod4 = new Product2(Name='test product 4', ProductCode='FRINKSG', Product_Type__c='Support',Salesforce_Product_Type__c = 'Hardware', Product_Class__c = pc.Id, Quotable__c=true);
      Product2 prod5 = new Product2(Name='test product 5', ProductCode='PS-TEST-TE', Product_Type__c='Software',Salesforce_Product_Type__c = 'Hardware', Product_Class__c = pc.Id, Quotable__c=true);
      Product2 prod6 = new Product2(Name='support product 1', ProductCode='SUP', Product_Type__c = 'Support', Salesforce_Product_Type__c = 'Support', Product_Class__c = pc.Id, Quotable__c=true);
      insert new List<Product2>{prod1, prod2, prod3, prod4, prod5, prod6};
      
      PricebookEntry pbe1 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod1.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
      PricebookEntry pbe2 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod2.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
      PricebookEntry pbe3 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod3.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
      PricebookEntry pbe4 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod4.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
      PricebookEntry pbe5 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod5.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
      PricebookEntry pbe6 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod6.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
      
      System.assert(pbe1 != null);
      System.assert(pbe2 != null);
      System.assert(pbe3 != null);
      System.assert(pbe4 != null);
      System.assert(pbe5 != null);
      System.assert(pbe6 != null);
      
      Service_Line_Matrix__c objSLM = new Service_Line_Matrix__c();
      objSLM.Product_Class__c = pc.Id;
      objSLM.Product_Type__c = 'Hardware';
      objSLM.CurrencyIsoCode = 'USD';
      objSLM.Support_Product__c = prod6.Id;
      objSLM.Support_Type__c = 'Care';
      insert objSLM;
      
      Opportunity opp = new Opportunity(Name='test opp', AccountId=acc.id, closeDate = Date.today().addDays(30), stageName='03 - Upside - Solution Identified', CurrencyISOCode = 'USD');
      opp.Billing_Address__c = add1.Id;
      opp.Shipping_Address__c = add2.Id;
      insert opp;
      
      Quote q1 = new Quote(Name='test Quote 1', Pricebook2Id=pb.id, Effective__c = Date.today(), OpportunityId = opp.id, Account_Lookup__c=acc.id, Default_Price_book__c = pb.Id);
      q1.Billing_Address__c = add1.Id;
      q1.Shipping_Address__c = add2.Id;
      insert q1;
      
      opp.SyncedQuoteId = q1.Id;
      update opp;
      
      Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Master Quote Solution', Order__c = 1.0, Quote__c = q1.Id, Optional__c = false, IsDefault__c = true);
      insert qs1;
       
      Quote_Solutions__c qs2 = new Quote_Solutions__c(Name='Quote Solution 1', Order__c = 1.0, Quote__c = q1.Id, Parent_Solution__c = qs1.Id, Optional__c = false);
      Quote_Solutions__c qs3 = new Quote_Solutions__c(Name='Quote Solution 2', Order__c = 2.0, Quote__c = q1.Id, Parent_Solution__c = qs1.Id, Optional__c = false);
      Quote_Solutions__c qs4 = new Quote_Solutions__c(Name='Quote Solution 3', Order__c = 3.0, Quote__c = q1.Id, Parent_Solution__c = qs1.Id, Optional__c = false);
      insert new List<Quote_Solutions__c>{qs2,qs3,qs4};
      
      QuoteLineItem ql1 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.Id, Solution__c = qs2.id, Quantity = 10, UnitPrice=55.00, Support_Type_Text__c = 'Care', Professional_Service_Requested__c = false,Professional_Service_Product__c = false,Support_Product__c = false);
      QuoteLineItem ql2 = new QuoteLineItem(PricebookEntryId= pbe2.id, QuoteId=q1.Id, Solution__c = qs2.id, Quantity = 10, UnitPrice=65.00,Support_Type_Text__c = 'Care',Professional_Service_Requested__c = true,Professional_Service_Product__c = false,Support_Product__c = false);
      QuoteLineItem ql3 = new QuoteLineItem(PricebookEntryId= pbe3.id, QuoteId=q1.Id, Solution__c = qs3.id, Quantity = 10, UnitPrice=75.00,Support_Type_Text__c = 'Care', Professional_Service_Requested__c = false,Professional_Service_Product__c = false,Support_Product__c = false);
      QuoteLineItem ql4 = new QuoteLineItem(PricebookEntryId= pbe4.id, QuoteId=q1.Id, Solution__c = qs3.id, Quantity = 10, UnitPrice=85.00,Support_Type_Text__c = 'Care',Professional_Service_Requested__c = true,Professional_Service_Product__c = false,Support_Product__c = false);
      QuoteLineItem ql5 = new QuoteLineItem(PricebookEntryId= pbe5.id, QuoteId=q1.Id, Solution__c = qs4.id, Quantity = 10, UnitPrice=95.00,Support_Type_Text__c = 'Care');
      QuoteLineItem ql6 = new QuoteLineItem(PricebookEntryId= pbe6.id, QuoteId=q1.Id, Solution__c = qs4.id, Quantity = 10, UnitPrice=95.00,Support_Type_Text__c = 'Care');
      insert new List<QuoteLineItem>{ql1,ql2,ql3,ql4,ql5,ql6};

      List<OpportunityLineItem> oppLineItems = [select Id from OpportunityLineItem where OpportunityId = :opp.Id];
      System.assert(oppLineItems.size() != 0);
      
      Test.startTest();
      
      opp.SyncedQuoteId = null;
      update opp;
      
      Test.stopTest();

      oppLineItems = [select Id from OpportunityLineItem where OpportunityId = :opp.Id];
      System.assert(oppLineItems.size() == 0);
   }
    
    @isTest
    static void shouldBuildOpportunityShare(){
        OpportunityShare oppShare = OpportunityTriggerHelper.buildOpportunityShare('006000000000000', '005000000000000', 'Edit');
        System.assert(oppShare != null);
    }
}