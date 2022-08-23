@isTest(seeAllData = true)
private  class CustomQuoteLineItemEdit_CtrlTest {
  static testMethod void testcustomQuoteEdit(){
      //Setup Data
		        //create test data
        Account acc = new Account(Name='test account', Status__c='Active', Partner_Product_Prices__c='US Domestic', RecordTypeId=[SELECT id FROM RecordType where sobjectType='Account' AND Name='Channel Partner' limit 1].id);
        insert acc;
        
        Address__c add = new Address__c(Account__c = acc.id, Name='test Address', Street_Address__c ='124 test avenue', Country__c ='United States of America', City__c = 'Chicago', Salesforce_Primary__c = true, State__c = 'Illinois', Zip_Code__c ='60646');
        insert add;
        
        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE IsStandard=true AND IsActive=true limit 1][0];
        
        Product2 prod1 = new Product2(Name='test product 1', ProductCode='FRINKSD', Product_Type__c='Hardware');
        Product2 prod2 = new Product2(Name='test product 2', ProductCode='FRINKSE', Product_Type__c='Hardware');
        Product2 prod3 = new Product2(Name='test product 3', ProductCode='FRINKSF', Product_Type__c='Hardware');
        Product2 prod4 = new Product2(Name='test product 4', ProductCode='FRINKSG', Product_Type__c='Hardware');
        //insert new List<Product2>{prod1, prod2, prod3, prod4};
        
        PricebookEntry pbe1 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];//new PricebookEntry(UnitPrice=45.00, Product2Id = prod1.id, Pricebook2Id =pb.id, IsActive=true);
        //PricebookEntry pbe2 = new PricebookEntry(UnitPrice=55.00, Product2Id = prod2.id, Pricebook2Id =pb.id, IsActive=true);
        //PricebookEntry pbe3 = new PricebookEntry(UnitPrice=65.00, Product2Id = prod3.id, Pricebook2Id =pb.id, IsActive=true);
        //PricebookEntry pbe4 = new PricebookEntry(UnitPrice=75.00, Product2Id = prod4.id, Pricebook2Id =pb.id, IsActive=true);
        //insert new List<PricebookEntry>{pbe1, pbe2,pbe3,pbe4};
        
        Opportunity opp = new Opportunity(Name='test opp', AccountId=acc.id, closeDate = Date.today().addDays(30), stageName='03 - Upside - Solution Identified');
        insert opp;
        
        Quote q1 = new Quote(Name='test Quote 1', Pricebook2Id=pb.id, Effective__c = Date.today(), OpportunityId = opp.id, Account_Lookup__c=acc.id);
        insert q1;
      
      opp.SyncedQuoteId = q1.id;
        update opp;
        
        List<Quote_Solutions__c> solutionsList = new List<Quote_Solutions__c>();
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Master Test Quote Solution', Order__c = 1.0, Quote__c = q1.id);
        insert qs1;
      Quote_Solutions__c qs2 = new Quote_Solutions__c(Name='Quote Solution 1', Order__c = 1.0, Quote__c = q1.id, Parent_Solution__c = qs1.id);
        Quote_Solutions__c qs3 = new Quote_Solutions__c(Name='Quote Solution 2', Order__c = 2.0, Quote__c = q1.id, Parent_Solution__c = qs1.id);
        Quote_Solutions__c qs4 = new Quote_Solutions__c(Name='Quote Solution 3', Order__c = 3.0, Quote__c = q1.id, Parent_Solution__c = qs1.id);
        Quote_Solutions__c qs5 = new Quote_Solutions__c(Name='Master Optional Quote Solution 4', Order__c = 3.0, Quote__c = q1.id, Optional__c = true);

        insert new List<Quote_Solutions__c>{qs2,qs3,qs4,qs5};
        Quote_Solutions__c qs6 = new Quote_Solutions__c(Name='Quote Solution 5', Order__c = 3.0, Quote__c = q1.id, Optional__c = true, Parent_Solution__c = qs4.Id);
        insert qs6;
        
        solutionsList = new List<Quote_Solutions__c>{qs1,qs2,qs3,qs4};
        
        
        QuoteLineItem ql1 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs1.id, Quantity = 10, UnitPrice=55.00);
        QuoteLineItem ql2 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs1.id, Quantity = 10, UnitPrice=65.00);
        QuoteLineItem ql3 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs1.id, Quantity = 10, UnitPrice=75.00);
        QuoteLineItem ql4 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs1.id, Quantity = 10, UnitPrice=85.00);
        QuoteLineItem ql5 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs1.id, Quantity = 10, UnitPrice=95.00);
        QuoteLineItem ql6 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs1.id, Quantity = 10, UnitPrice=105.00);
        insert new List<QuoteLineItem>{ql1,ql2,ql3,ql4,ql5,ql6};
        Test.startTest();
      QuoteLineItem testQuoteItem = [select Id,QuoteId from QuoteLineItem limit 1];
      Quote testQuote = [select Id from Quote where Id =:testQuoteItem.QuoteId];
      PageReference myVfPage = Page.CustomQuoteLineItemEditAll;
      Test.setCurrentPage(myVfPage);
      ApexPAges.StandardController sc = new ApexPages.StandardController(testQuote);  
      CustomQuoteLineItemEdit_Ctrl cq = new CustomQuoteLineItemEdit_Ctrl(sc);
      cq.processRecs();
      cq.processLineItems();
      cq.processAutoLineItems();
      cq.updateList();
      cq.SaveRecs();
      Test.stopTest();
  }
}