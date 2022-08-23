@isTest
private class CopyQuoteControllerTests {
    
    private static Account acc;
    private static Opportunity opp;
    private static Quote q1;
    
    private static void setupForCopy() {
        //create test data
        acc = new Account(Name='test account', Status__c='Active', Partner_Product_Prices__c='US Domestic', RecordTypeId=[SELECT id FROM RecordType where sobjectType='Account' AND Name='Channel Partner' limit 1].id);
        insert acc;
        
        Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
        insert cty;
        Address__c add = TestDataFactory.createAddress(acc);
        
        
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
        
        opp = new Opportunity(Name='test opp', AccountId=acc.id, closeDate = Date.today().addDays(30), stageName='03 - Upside - Solution Identified');
        insert opp;
        
        q1 = new Quote(Name='test Quote 1', Pricebook2Id=pb.id, Effective__c = Date.today(), OpportunityId = opp.id, Account_Lookup__c=acc.id);
        insert q1;
        
        opp.SyncedQuoteId = q1.id;
        update opp;
        
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Master Quote Solution', Order__c = 1.0, Quote__c = q1.id, IsDefault__c=true);
        insert qs1;
         
        Quote_Solutions__c qs2 = new Quote_Solutions__c(Name='Quote Solution 1', Order__c = 1.0, Quote__c = q1.id, Parent_Solution__c = qs1.id);
        Quote_Solutions__c qs3 = new Quote_Solutions__c(Name='Quote Solution 2', Order__c = 2.0, Quote__c = q1.id, Parent_Solution__c = qs1.id);
        Quote_Solutions__c qs4 = new Quote_Solutions__c(Name='Quote Solution 3', Order__c = 3.0, Quote__c = q1.id, Parent_Solution__c = qs1.id);
        insert new List<Quote_Solutions__c>{qs2,qs3,qs4};
        
        QuoteLineItem ql1 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs2.id, Quantity = 10, UnitPrice=55.00);
        QuoteLineItem ql2 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs2.id, Quantity = 10, UnitPrice=65.00);
        QuoteLineItem ql3 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs3.id, Quantity = 10, UnitPrice=75.00);
        QuoteLineItem ql4 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs3.id, Quantity = 10, UnitPrice=85.00);
        QuoteLineItem ql5 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs4.id, Quantity = 10, UnitPrice=95.00);
        QuoteLineItem ql6 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs4.id, Quantity = 10, UnitPrice=105.00);
        insert new List<QuoteLineItem>{ql1,ql2,ql3,ql4,ql5,ql6};
    }
    
    @IsTest(SeeAllData=true)
    static void shouldSearchQuotes(){
        setupForCopy();
        
        Test.startTest();
        CopyReviseQuoteController con = new CopyReviseQuoteController();
        con.quoteNumber = q1.QuoteNumber;
        con.quoteName = 'test Quote 1';
        con.accountName = 'test';
        con.oppName = 'test opp';
        con.searchQuotes();
        Test.stopTest();
        System.assert(con.wrappers != null && con.wrappers.size() > 0);
    }
    
    @IsTest(SeeAllData=true)
    static void shouldConfirmCopy() {
        setupForCopy();
        
        Test.startTest();
        PageReference pr = Page.CopyReviseQuote;
        pr.getParameters().put('id',opp.Id);
        pr.getParameters().put('type','Opportunity');
        Test.setCurrentPageReference(pr);
        CopyReviseQuoteController con = new CopyReviseQuoteController();
        con.newQuote.Parent_Quote__c = q1.id;
        con.newQuote.Partner_Name__c = acc.id;
        con.needConfirm = true;
        con.copy();
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void shouldCopyFromQuote(){
        setupForCopy();
        
        Test.startTest();
        PageReference pr = Page.CopyReviseQuote;
        pr.getParameters().put('quoteId', q1.Id);
        Test.setCurrentPageReference(pr);
        CopyReviseQuoteController con = new CopyReviseQuoteController();
        con.copyFromQuote();
        Test.stopTest();
        System.assert(con.newQuote != null);
    }
    
    @isTest(seealldata=true)
    static void copyQuoteTest() {
        setupForCopy();
        
        Test.startTest();
        PageReference pr = Page.CopyReviseQuote;
        pr.getParameters().put('id',opp.Id);
        pr.getParameters().put('type','Opportunity');
        Test.setCurrentPageReference(pr);
        CopyReviseQuoteController con = new CopyReviseQuoteController();
        
        con.newQuote.Parent_Quote__c = q1.id;
        con.newQuote.Partner_Name__c = acc.id;
        con.needConfirm = true;
        con.confirmCopy();
        Test.stopTest();
        
        //requery
        
        List<Quote> newQuote = [SELECT id, Default_Solution__c FROM Quote WHERE Id !=:q1.id AND Partner_Name__c = :acc.id];
        System.assertNotEquals(q1.id, newQuote[0].id);
        List<Quote_Solutions__c> newQSol = [SELECT id, IsDefault__c FROM Quote_Solutions__c WHERE Quote__c =:newQuote[0].id];
        List<QuoteLineItem> quoteItems = [SELECT id FROM QuoteLineItem WHERE QuoteId =:newQuote[0].id];
        
        //assertions
        SYstem.assertEquals(1, newQuote.size());
        SYstem.assertEquals(5, newQSol.size()); //trigger creates the fifth one, it is created when wuote is created
        // has a default solution
        Quote_Solutions__c quoteSoln;
        for(Quote_Solutions__c soln : newQSol) {
            if(soln.IsDefault__c == true){
                quoteSoln = soln;
            }
        }
        System.assert(quoteSoln != null);
        System.assertEquals(newQuote[0].Default_Solution__c, quoteSoln.Id);
    }
    
    private static void setupForRevise() {
        //create test data
        acc = new Account(Name='test account', Status__c='Active', Partner_Product_Prices__c='US Domestic', RecordTypeId=[SELECT id FROM RecordType where sobjectType='Account' AND Name='Channel Partner' limit 1].id);
        insert acc;
        
        Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
        insert cty;
        Address__c add = TestDataFactory.createAddress(acc);
        
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
        
        opp = new Opportunity(Name='test opp', AccountId=acc.id, closeDate = Date.today().addDays(30), stageName='03 - Upside - Solution Identified');
        insert opp;
        
        q1 = new Quote(Name='test Quote 1', Pricebook2Id=pb.id, Effective__c = Date.today(), OpportunityId = opp.id, Account_Lookup__c=acc.id, Quote_Version__c = 0, Default_Price_Book__c=pb.Id);
        insert q1;

        opp.SyncedQuoteId = q1.id;
        update opp;
        
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Master Quote Solution', Order__c = 1.0, Quote__c = q1.id, IsDefault__c=true);
        insert qs1;
         
        Quote_Solutions__c qs2 = new Quote_Solutions__c(Name='Quote Solution 1', Order__c = 1.0, Quote__c = q1.id, Parent_Solution__c = qs1.id);
        Quote_Solutions__c qs3 = new Quote_Solutions__c(Name='Quote Solution 2', Order__c = 2.0, Quote__c = q1.id, Parent_Solution__c = qs1.id);
        Quote_Solutions__c qs4 = new Quote_Solutions__c(Name='Quote Solution 3', Order__c = 3.0, Quote__c = q1.id, Parent_Solution__c = qs1.id);
        insert new List<Quote_Solutions__c>{qs2,qs3,qs4};
        
        QuoteLineItem ql1 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs2.id, Quantity = 10, UnitPrice=55.00);
        QuoteLineItem ql2 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs2.id, Quantity = 10, UnitPrice=65.00);
        QuoteLineItem ql3 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs3.id, Quantity = 10, UnitPrice=75.00);
        QuoteLineItem ql4 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs3.id, Quantity = 10, UnitPrice=85.00);
        QuoteLineItem ql5 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs4.id, Quantity = 10, UnitPrice=95.00);
        QuoteLineItem ql6 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs4.id, Quantity = 10, UnitPrice=105.00);
        insert new List<QuoteLineItem>{ql1,ql2,ql3,ql4,ql5,ql6};
    }
    
    @isTest(SeeAllData=true)
    static void shouldConfirmRevise() {
        setupForRevise();
        
        Test.startTest();
        PageReference pr = Page.CopyReviseQuote;
        pr.getParameters().put('id',q1.Id);
        pr.getParameters().put('type','Quote');
        Test.setCurrentPageReference(pr);
        CopyReviseQuoteController con = new CopyReviseQuoteController();
        con.newQuote.Partner_Name__c = acc.id;
        con.revise();
        con.cancel();
        Test.stopTest();
    }
    
    @isTest(seealldata=true)
    static void reviseQuoteTest() {
        setupForRevise();
        
        Test.startTest();
        PageReference pr = Page.CopyReviseQuote;
        pr.getParameters().put('id',q1.Id);
        pr.getParameters().put('type','Quote');
        Test.setCurrentPageReference(pr);
        CopyReviseQuoteController con = new CopyReviseQuoteController();
        con.newQuote.Partner_Name__c = acc.id;
        con.resetCosts = true;
        con.resetPrices = true;
        con.confirmRevise();
        Test.stopTest();
        
        //requery
        
        List<Quote> newQuote = [SELECT id, Quote_Version__c FROM Quote WHERE Id !=:q1.id AND Partner_Name__c = :acc.id];
        System.assertNotEquals(q1.id, newQuote[0].id);
        List<Quote_Solutions__c> newQSol = [SELECT id FROM Quote_Solutions__c WHERE Quote__c =:newQuote[0].id];
        List<QuoteLineItem> quoteItems = [SELECT id FROM QuoteLineItem WHERE QuoteId =:newQuote[0].id];
        
        //assertions
        SYstem.assertEquals(1, newQuote.size());
        SYstem.assertEquals(5, newQSol.size()); //trigger creates the fifth one, it is created when wuote is created
        //SYstem.assertEquals(6, quoteItems.size());
        //system.assert(newQuote[0].Quote_Version__c == q1.Quote_Version__c+1);
    }
}