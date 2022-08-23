@IsTest
public class QuoteLineItemsPageControllerTest {
    
    @isTest
    static void shouldDeleteAllSolutionSets(){
        Quote qt = TestDataFactory.setupTestQuote(false);
        List<Quote_Solutions__c> testQuoteSolutions = [select Id from Quote_Solutions__c where Quote__c = :qt.Id];
        List<QuoteLineItem> testQLIs = [select Id from QuoteLineItem where QuoteId = :qt.Id];
        System.assert(testQuoteSolutions.size() != 0);
        System.assert(testQLIs.size() != 0);
        Test.startTest();
        QuoteLineItemsPageController.deleteAllQuoteSolutions(qt.Id);
        Test.stopTest();
        testQuoteSolutions = [select Id from Quote_Solutions__c where Quote__c = :qt.Id];
        testQLIs = [select Id from QuoteLineItem where QuoteId = :qt.Id];
        System.assert(testQuoteSolutions.size() == 1); // default solution
        System.assert(testQLIs.size() == 0);
    }

    @IsTest(SeeAllData=true)
    public static void testAllMethods(){
        Account acc = new Account(Name='test account', Status__c='Active', Partner_Product_Prices__c='US Domestic', RecordTypeId=[SELECT id FROM RecordType where sobjectType='Account' AND Name='Channel Partner' limit 1].id);
        insert acc;
        Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
        insert cty;
        Address__c add = new Address__c(Account__c = acc.id, Name='test Address', Street_Address__c ='124 test avenue', Country__c ='United States of America', City__c = 'Chicago', Salesforce_Primary__c = true, State__c = 'Illinois', Zip_Code__c ='60646');
        insert add;
        
        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE IsStandard=true AND IsActive=true limit 1][0];
        
        Product2 prod1 = new Product2(Name='test product 1', ProductCode='FRINKSD', Product_Type__c='Hardware', Quotable__c=true, IsActive=true);
        Product2 prod2 = new Product2(Name='test product 2', ProductCode='FRINKSE', Product_Type__c='Hardware', Quotable__c=true, IsActive=true);
        Product2 prod3 = new Product2(Name='test product 3', ProductCode='FRINKSF', Product_Type__c='Hardware', Quotable__c=true, IsActive=true);
        Product2 prod4 = new Product2(Name='test product 4', ProductCode='FRINKSG', Product_Type__c='Hardware', Quotable__c=true, IsActive=true);
        insert new List<Product2>{prod1, prod2, prod3, prod4};
        update prod1;
            
        PricebookEntry pbe1 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod1.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
        PricebookEntry pbe2 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod2.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
        PricebookEntry pbe3 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod3.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
        PricebookEntry pbe4 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod4.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
        
        System.assert(pbe1 != null);
        System.assert(pbe2 != null);
        System.assert(pbe3 != null);
        System.assert(pbe4 != null);
        
        Opportunity opp = new Opportunity(Name='test opp', AccountId=acc.id, closeDate = Date.today().addDays(30), stageName='03 - Upside - Solution Identified', BSR_Value__c  = 0);
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
        Quote_Solutions__c qs5 = new Quote_Solutions__c(Name='Master Optional Quote Solution 4', Order__c = 2.0, Quote__c = q1.id, Optional__c = true);

        insert new List<Quote_Solutions__c>{qs2,qs3,qs4,qs5};
        Quote_Solutions__c qs6 = new Quote_Solutions__c(Name='Quote Solution 5', Order__c = 3.0, Quote__c = q1.id, Optional__c = true, Parent_Solution__c = qs5.Id);
        insert qs6;
        Quote_Solutions__c qs7 = new Quote_Solutions__c(Name='Parent Solution Set C', Order__c = 3.0, Quote__c = q1.id, Optional__c = false);
        insert qs7;
        
        solutionsList = new List<Quote_Solutions__c>{qs1,qs2,qs3,qs4,qs5,qs6,qs7};
        
        
        QuoteLineItem ql1 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs2.id, Quantity = 10, UnitPrice=55.00);
        QuoteLineItem ql2 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs2.id, Quantity = 10, UnitPrice=65.00);
        QuoteLineItem ql3 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs3.id, Quantity = 10, UnitPrice=75.00);
        QuoteLineItem ql4 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs3.id, Quantity = 10, UnitPrice=85.00);
        QuoteLineItem ql5 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs4.id, Quantity = 10, UnitPrice=95.00);
        QuoteLineItem ql6 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs6.id, Quantity = 10, UnitPrice=105.00);
        insert new List<QuoteLineItem>{ql1,ql2,ql3,ql4,ql5,ql6};
        //End setup
        Test.startTest();
        // find non-quotable products
        List<QuoteLineItem> nonQuotable = QuoteLineItemsPageController.getNonQuotableItems(q1.Id);
        List<QuoteLineItem> limQuotable = QuoteLineItemsPageController.getProductsWithLimSupply(q1.Id);
        QuoteLineItemsPageController con = new QuoteLineItemsPageController(new ApexPages.StandardController(q1));
        //Create solution set
        QuoteLineItemsPageController.createSolutionSet(q1.Id);
        // update total margin
        List<QuoteLineItem> lineItems = [SELECT Id, Margin__c FROM QuoteLineItem WHERE Solution__c =: qs2.Id AND (Product2.NonDiscountable__c = false OR (Product2.Product_Type__c != 'Professional Services' AND Product2.Product_Type__c != 'Support'))];
        Decimal newTotalMargin = 0;
        Integer count = 0;
        for(QuoteLineItem qli : lineItems) {
            newTotalMargin += qli.Margin__c;
            count++;
        }
        if(count > 0) {
            newTotalMargin = newTotalMargin / count;
            newTotalMargin = newTotalMargin - 0.01;

            PageReference pr = Page.QuoteLineItemsPage;
            pr.getParameters().put('solutionId',qs2.Id);
            pr.getParameters().put('newTotalMargin', String.valueOf(newTotalMargin));
            Test.setCurrentPageReference(pr);
            con.onUpdateTotalMargin();
        }
        //move solution sets
        Quote_Solutions__c temp = solutionsList[1];
        solutionsList[1] = solutionsList[2];
        solutionsList[2] = temp;
        String s = JSON.serialize(solutionsList);
        PageReference pr = Page.QuoteLineItemsPage;
        pr.getParameters().put('strSerialVal',s);
        Test.setCurrentPageReference(pr);
        con.moveSolutionSet();
        //rename solution set
         pr = Page.QuoteLineItemsPage;
        pr.getParameters().put('solutionId',solutionsList[0].Id);
        pr.getParameters().put('solutionNewName','new Name');
        Test.setCurrentPageReference(pr);
        con.renameSolutionSet();
        Quote_Solutions__c qsTest = [SELECT name from Quote_Solutions__c WHERE Id = :solutionsList[0].Id];
        system.assert(qsTest.name == 'new Name');
        //make optional
        QuoteLineItemsPageController.optionalSolutionSet(solutionsList[6].Id,q1.id);        
        qsTest = [SELECT name, Optional__c from Quote_Solutions__c WHERE Id = :solutionsList[6].Id];
        system.assert(qsTest.Optional__c == true);
        //delete solution set
        QuoteLineItemsPageController.deleteSolutionSet(q1.Id, solutionsList[6].Id, true);
        List<Quote_Solutions__c >qsTestList = [SELECT name, Optional__c from Quote_Solutions__c WHERE Id = :solutionsList[6].Id];
        system.assert(qsTestList.size() == 0);
        //delete qli
        List<Id> idList = new List<Id>();
        idList.add(ql5.Id);
        s = JSON.serialize(idList);
        pr = Page.QuoteLineItemsPage;
        pr.getParameters().put('selectedQli',s);
        Test.setCurrentPageReference(pr);
        con.deleteQLI();
        List<QuoteLineItem> qliList = [SELECT Id from QuoteLineItem WHERE Id IN :idList];
        system.assert(qliList.size() == 0);
        //mass update
        con.setSelectedSolutionSets(JSON.serialize(new List<String>{qs2.Id}));
        con.setupQliWrappers();
        con.getBaseURL();
        pr = Page.QuoteLineItemsPage;
        pr.getParameters().put('longDescription','test');
        pr.getParameters().put('customPartNumber','test');
        pr.getParameters().put('unitPrice','1');
        pr.getParameters().put('productCost','1');
        pr.getParameters().put('quantity','2');
        pr.getParameters().put('lineDiscount','.2');
        Test.setCurrentPageReference(pr);
        for(QuoteLineItemWrapper i : con.qliList)
        {
            i.selected = true;
        }
        con.massUpdateQLI();
        //saveQlis
        if(con.qliList.size()>0){
            con.qliList[0].q.Quantity = 11;
            con.saveQLI();
            con.newQLI();
        }
        
        //move QLI
        con.moveToSolution = qs3.Id;
        if(con.qliList.size()>0){
            con.qliList[0].selected = true;
            con.moveQLI();
        }
        List<QuoteLineItem> qliTestList = [SELECT Solution__c from QuoteLineItem WHERE Solution__c = :qs3.Id];
        //system.assert(qsTestList.size() > 0);
        //copy qli
        if(con.qliList.size()>0){
            for(QuoteLineItemWrapper qlw : con.qliList) {
                qlw.selected = true;
            }
            con.copyToSolution = qs3.Id;
            con.copyQLI();
        }
        qliTestList = [SELECT Solution__c from QuoteLineItem WHERE Solution__C = :qs3.Id];
        //system.assert(qsTestList.size() > 0);
        //reorderQli
        con.setSelectedSolutionSets(JSON.serialize(new List<String>{qs2.Id}));
        List<Id> qliIds = new List<Id>();
        if(con.qliList.size()>0){
            for(QuoteLineItemWrapper qlw : con.qliList) {
                qliIds.add(qlw.q.Id);
            }
            s = JSON.serialize(qliIds);
        }
        pr = Page.QuoteLineItemsPage;
        pr.getParameters().put('strSerialVal',s);
        Test.setCurrentPageReference(pr);
        //con.reorderQli();
        //get Quote Solutions
        con.getQuoteSolutions();
        con.updateDefaultSolution();
        //find # qli on solution
        system.assert(QuoteLineItemsPageController.findNumberQLIOnSolution(qs4.Id) == true);

        Test.stopTest();   
    }
    
    @IsTest(SeeAllData=true)
    static void shouldTestOnUpdateTotalPrice(){
        Account acc = new Account(Name='test account', Status__c='Active', Partner_Product_Prices__c='US Domestic', RecordTypeId=[SELECT id FROM RecordType where sobjectType='Account' AND Name='Channel Partner' limit 1].id);
        insert acc;
        Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
        insert cty;
        Address__c add = new Address__c(Account__c = acc.id, Name='test Address', Street_Address__c ='124 test avenue', Country__c ='United States of America', City__c = 'Chicago', Salesforce_Primary__c = true, State__c = 'Illinois', Zip_Code__c ='60646');
        insert add;
        
        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE IsStandard=true AND IsActive=true limit 1][0];
        
        Product2 prod1 = new Product2(Name='test product 1', ProductCode='FRINKSD', Product_Type__c='Hardware', Quotable__c=true, IsActive=true);
        Product2 prod2 = new Product2(Name='test product 2', ProductCode='FRINKSE', Product_Type__c='Hardware', Quotable__c=true, IsActive=true);
        Product2 prod3 = new Product2(Name='test product 3', ProductCode='FRINKSF', Product_Type__c='Hardware', Quotable__c=true, IsActive=true);
        Product2 prod4 = new Product2(Name='test product 4', ProductCode='FRINKSG', Product_Type__c='Hardware', Quotable__c=true, IsActive=true);
        insert new List<Product2>{prod1, prod2, prod3, prod4};
        update prod1;
            
        PricebookEntry pbe1 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod1.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
        PricebookEntry pbe2 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod2.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
        PricebookEntry pbe3 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod3.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
        PricebookEntry pbe4 = [SELECT id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id=:prod4.id AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD' limit 1];
        
        System.assert(pbe1 != null);
        System.assert(pbe2 != null);
        System.assert(pbe3 != null);
        System.assert(pbe4 != null);
        
        Opportunity opp = new Opportunity(Name='test opp', AccountId=acc.id, closeDate = Date.today().addDays(30), stageName='03 - Upside - Solution Identified', BSR_Value__c  = 0);
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
        Quote_Solutions__c qs5 = new Quote_Solutions__c(Name='Master Optional Quote Solution 4', Order__c = 2.0, Quote__c = q1.id, Optional__c = true);

        insert new List<Quote_Solutions__c>{qs2,qs3,qs4,qs5};
        Quote_Solutions__c qs6 = new Quote_Solutions__c(Name='Quote Solution 5', Order__c = 3.0, Quote__c = q1.id, Optional__c = true, Parent_Solution__c = qs5.Id);
        insert qs6;
        Quote_Solutions__c qs7 = new Quote_Solutions__c(Name='Parent Solution Set C', Order__c = 3.0, Quote__c = q1.id, Optional__c = false);
        insert qs7;
        
        solutionsList = new List<Quote_Solutions__c>{qs1,qs2,qs3,qs4,qs5,qs6,qs7};
        
        
        QuoteLineItem ql1 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs2.id, Quantity = 10, UnitPrice=55.00);
        QuoteLineItem ql2 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs2.id, Quantity = 10, UnitPrice=65.00);
        QuoteLineItem ql3 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs3.id, Quantity = 10, UnitPrice=75.00);
        QuoteLineItem ql4 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs3.id, Quantity = 10, UnitPrice=85.00);
        QuoteLineItem ql5 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs4.id, Quantity = 10, UnitPrice=95.00);
        QuoteLineItem ql6 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.id, Solution__c = qs6.id, Quantity = 10, UnitPrice=105.00);
        insert new List<QuoteLineItem>{ql1,ql2,ql3,ql4,ql5,ql6};
        //End setup
        Test.startTest();
        QuoteLineItemsPageController con = new QuoteLineItemsPageController(new ApexPages.StandardController(q1));
        //test quote solutions serialize
        QuoteLineItemsPageController.quoteSolutionsWithChildren(q1.Id);
        // update total price
        PageReference pr = Page.QuoteLineItemsPage;
        pr.getParameters().put('solutionId',qs2.Id);
        pr.getParameters().put('newTotalPrice','4000');
        Test.setCurrentPageReference(pr);
        con.onUpdateTotalPrice();
        Test.stopTest();
    }
}