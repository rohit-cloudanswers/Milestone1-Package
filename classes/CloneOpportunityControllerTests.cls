@IsTest(SeeAllData=true)
public class CloneOpportunityControllerTests {
    
    @IsTest
    static void shouldCloneOpportunity() {
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
        opp.Shipping_Address__c = add1.Id;
        insert opp;
        
        Quote q1 = new Quote(Name='test Quote 1', Pricebook2Id=pb.id, Effective__c = Date.today(), OpportunityId = opp.id, Account_Lookup__c=acc.id, Default_Price_book__c = pb.Id);
        q1.Billing_Address__c = add1.Id;
        q1.Shipping_Address__c = add1.Id;
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
        
        Test.startTest();
        
        List<QuoteLineItem> lineItems = [SELECT Id From QuoteLineItem WHERE QuoteId =: q1.Id];
        System.assert(lineItems.size() > 0);
        
        QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = true;
        
        Integer beforeClone = [SELECT Count() FROM Opportunity where CreatedDate = TODAY];
        
        List<Account> accs = CloneOpportunityController.findAccounts('test');
        System.assert(accs.size() != 0);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        CloneOpportunityController con = new CloneOpportunityController(sc);
        System.assert(con.addressId == opp.Billing_Address__c);
        con.getPricebookOptions();
        con.pricebook2Id = pb.Id;
        con.addressId = add2.Id;
        String quoteId = null;
        for(CloneOpportunityController.QuoteWrapper w : con.wrappers) {
            quoteId = w.q.Id;
            w.selected = true;
        }
        ApexPages.currentPage().getParameters().put('quoteId', quoteId);
        con.setSelectedQuote();
        con.setSelectedQuote();
        con.setResetQuote();
        con.setSyncQuote();
        con.cloneOpportunityPartial();
        con.cancel();
        con.getErrorsPresent();
        
        Integer afterClone = [SELECT Count() FROM Opportunity where CreatedDate = TODAY];
        
        System.assertEquals(beforeClone + 1, afterClone);
        
        Test.stopTest();
    }
    
    
    @IsTest
    static void shouldTestConversion(){
        QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = true;
        Account acc = new Account(Name='Test Account', Status__c='Active', Partner_Product_Prices__c='US Domestic', RecordTypeId=[SELECT id FROM RecordType where sobjectType='Account' AND Name='Channel Partner' limit 1].id);
        insert acc;
        
        
        Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
        insert cty;
        Address__c add = TestDataFactory.createAddress(acc);
        
        Pricebook2 pb1 = new Pricebook2(Name='Custom Pricebook 1', CurrencyIsoCode='USD', Currency_Code__c='USD', IsActive=true, Pricebook_Region__c='USD Asia');
        Pricebook2 pb2 = new Pricebook2(Name='Custom Pricebook 2', CurrencyIsoCode='USD', Currency_Code__c='USD', IsActive=true, Pricebook_Region__c='USD China');
        insert new List<Pricebook2>{pb1, pb2};
        
        Product_Class__c pc = new Product_Class__c();
        pc.Product_Line__c = 'Automation';
        pc.Business_Unit__c = 'Networking';
        insert pc;
        
        Product2 prod1 = new Product2(Name='Test Product 1', ProductCode='FRINKSD', Product_Type__c='Hardware', Salesforce_Product_Type__c = 'Hardware', Product_Class__c = pc.Id, Quotable__c=true, Product_Cost__c=100);
        Product2 prod2 = new Product2(Name='Test Product 2', ProductCode='PS-TEST-TE', Product_Type__c='Software', Salesforce_Product_Type__c = 'Software', Product_Class__c = pc.Id, Quotable__c=true, Product_Cost__c=200);
        insert new List<Product2>{prod1, prod2};
        
        PricebookEntry pbe11 = new PricebookEntry(
            Product2Id=prod1.Id,
            Pricebook2Id=pb1.Id,
            UseStandardPrice=false,
            UnitPrice=0,
            IsActive=true,
            CurrencyIsoCode='USD'
        );
        PricebookEntry pbe12 = new PricebookEntry(
            Product2Id=prod2.Id,
            Pricebook2Id=pb1.Id,
            UseStandardPrice=false,
            UnitPrice=0,
            IsActive=true,
            CurrencyIsoCode='USD'
        );
        insert new List<PricebookEntry>{pbe11,pbe12};
            
        PricebookEntry pbe21 = new PricebookEntry(
            Product2Id=prod1.Id,
            Pricebook2Id=pb2.Id,
            UseStandardPrice=false,
            UnitPrice=112,
            IsActive=true,
            CurrencyIsoCode='USD'
        );
        PricebookEntry pbe22 = new PricebookEntry(
            Product2Id=prod2.Id,
            Pricebook2Id=pb2.Id,
            UseStandardPrice=false,
            UnitPrice=224,
            IsActive=true,
            CurrencyIsoCode='USD'
        );
        insert new List<PricebookEntry>{pbe21,pbe22};
        
        Opportunity opp = new Opportunity(Name='test opp', AccountId=acc.id, closeDate = Date.today().addDays(30), stageName='03 - Upside - Solution Identified', CurrencyISOCode = 'USD');
        insert opp;
        
        Quote q1 = new Quote(Name='Test Quote 1', Pricebook2Id=pb1.Id, Effective__c = Date.today(), OpportunityId = opp.id, Account_Lookup__c=acc.id, Default_Price_book__c = pb1.Id);
        insert q1;
        
        opp.SyncedQuoteId = q1.Id;
        update opp;
         
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Solution Set', Order__c = 1.0, Quote__c = q1.Id, Optional__c = false, IsDefault__c=true);
        insert new List<Quote_Solutions__c>{qs1};
        
        QuoteLineItem ql11 = new QuoteLineItem(PricebookEntryId= pbe11.Id, QuoteId=q1.Id, Solution__c = qs1.id, Quantity = 1, UnitPrice=100.00, Support_Type_Text__c = 'Care', Professional_Service_Requested__c = false,Professional_Service_Product__c = false,Support_Product__c = false);
        QuoteLineItem ql12 = new QuoteLineItem(PricebookEntryId= pbe12.Id, QuoteId=q1.Id, Solution__c = qs1.id, Quantity = 1, UnitPrice=200.00, Support_Type_Text__c = 'Care',Professional_Service_Requested__c = true,Professional_Service_Product__c = false,Support_Product__c = false, Product_Cost2__c=100);
        insert new List<QuoteLineItem>{ql11, ql12};
        Test.startTest();
        
        List<QuoteLineItem> lineItems = [SELECT Id From QuoteLineItem WHERE QuoteId =: q1.Id];
        System.assert(lineItems.size() > 0);
        QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = true;
        Integer beforeClone = [SELECT Count() FROM Opportunity where CreatedDate = TODAY];
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        CloneOpportunityController con = new CloneOpportunityController(sc);
        con.pricebook2Id = pb2.Id;
        for(CloneOpportunityController.QuoteWrapper w : con.wrappers) {
            w.selected = true;
            w.resetQuote = true;
        }
        PageReference pageRef = con.cloneOpportunityFull();

        Integer afterClone = [SELECT Count() FROM Opportunity where CreatedDate = TODAY];
        System.assertEquals(beforeClone + 1, afterClone);
        con.getErrorsPresent();
        CloneOpportunityController.findAccounts('Test Account');
        con.getPricebookOptions();
        String oppId = pageRef.getUrl().substring(1);
        Opportunity clonedOpp = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        Quote clonedQuote = [SELECT Id FROM Quote WHERE OpportunityId = :clonedOpp.Id LIMIT 1];
        QuoteLineItem qli1 = [SELECT Id, UnitPrice, ListPrice, Product_Cost__c FROM QuoteLineItem WHERE QuoteId = :clonedQuote.Id AND PricebookEntry.Product2Id = :prod1.Id];
        QuoteLineItem qli2 = [SELECT Id, UnitPrice, ListPrice, Product_Cost__c FROM QuoteLineItem WHERE QuoteId = :clonedQuote.Id AND PricebookEntry.Product2Id = :prod2.Id];

        System.assert(107.14 == qli1.UnitPrice);
        System.assert(100.00 == qli1.Product_Cost__c);
        System.assert(100.00 == qli2.Product_Cost__c);
        Test.stopTest();
    }
}