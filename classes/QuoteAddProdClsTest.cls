@isTest(seeAllData = true)
private  class QuoteAddProdClsTest {
  static testMethod void testQuoteAddProdCls(){
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
      Test.startTest();
      Quote testQuote = [select Id from Quote limit 1];
      PageReference myVfPage = Page.QuoteAddProdExtension;
      Test.setCurrentPage(myVfPage);
      ApexPAges.StandardController sc = new ApexPages.StandardController(testQuote);  
      QuoteAddProdClsExtension cq = new QuoteAddProdClsExtension(sc);
      cq.updateAvailableList();
      cq.getChosenCurrency();      
      cq.addToShoppingCart();
      cq.removeFromShoppingCart();
      cq.onSave();
      cq.onCancel();
      cq.priceBookCheck();
      cq.changePricebook();
      Test.stopTest();
  }
}