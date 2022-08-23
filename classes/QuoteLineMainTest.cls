/*
Modification History : Appshark || 26th Dec 2014 || ISSUE 10: Defect on Indirect Quote with Tier Discount
                       Replaced Tier_Discount__c field with Tier_Discount2__c in all areas. 
*/
@isTest
public with sharing class QuoteLineMainTest {
    
    @isTest
    static void shouldUpdateTotalsOnUndelete(){
        Quote qt = TestDataFactory.setupTestQuote(false);
        qt = queryQuoteTotals(qt.Id);
        System.assert(qt.Subtotal != 0);
        System.assert(qt.TotalPrice != 0);
        Test.startTest();
        QuoteLineItemsPageController.deleteAllQuoteSolutions(qt.Id);
        // totals on qoute should be 0
        Quote tempQuote = queryQuoteTotals(qt.Id);
        System.assert(tempQuote.Subtotal == 0);
        System.assert(tempQuote.TotalPrice == 0);
        // undelete records
        undelete TestDataFactory.parentSolution;
        undelete TestDataFactory.solutionsList;
        undelete TestDataFactory.quoteLineItems;
        // totals should revert to original values
        Test.stopTest();
        tempQuote = queryQuoteTotals(qt.Id);
        System.assert(qt.Subtotal == tempQuote.Subtotal);
        System.assert(qt.TotalPrice == tempQuote.TotalPrice);
    }
    
    private static Quote queryQuoteTotals(Id quoteId){
        return [
            select Id, Subtotal, TotalPrice, Total_Price__c, Sub_total__c, 
            Total_Extended_Cost__c, MarginPercent__c 
            from Quote where Id = :quoteId
        ];
    }
    
    @isTest
    static void testExceptionsBatchStatus(){
        Quote qt = TestDataFactory.setupTestQuote(false);
        qt.Discount_Batch_Id__c = 'someinvalidid';
        update qt;
        PageReference pageRef = Page.QuoteDiscountBatchStatus;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(qt);
        QuoteBatchStatusExtension qbsExt = new QuoteBatchStatusExtension(sc);
        qbsExt.checkStatus();
    }

    @isTest(SeeAllData=true)
    static void testNoBatchExist(){
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        test.startTest();
        Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
        insert testAccount;
        TestDataFactory.createAddress(testAccount);
        
        Pricebook2 pb = [select Id from Pricebook2 where isActive = true and Name='Canadian Domestic List Prices (CAD)'];
        
        Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.id,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
        insert testOpportunity;
    
        Quote testQuote = new Quote(Name = 'test Quote', Hardware_Discount__c=1.0,OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.id, Tier_Discount2__c = 20);  
        insert testQuote;
        
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Master Quote Solution', Order__c = 1.0, Quote__c = testQuote.id,Optional__c = false);
        insert qs1;
        
        List<Product_Class__c> productClassList = new List<Product_Class__c>();
        productClassList.add(TestDataFactory.initProductClass('DOH'));
        productClassList.add(TestDataFactory.initProductClass('Signaling & Transcoding'));
        productClassList.add(TestDataFactory.initProductClass('Professional Services'));
        productClassList.add(TestDataFactory.initProductClass('Support'));
        insert productClassList;
        
        Product2 prod3 = new Product2(Name='test product 3',NonDiscountable__c =  false, ProductCode='FRINKSF', Product_Type__c='Professional Services',Salesforce_Product_Type__c = 'Hardware', Product_Class__c = productClassList[0].Id);
        Product2 prod6 = new Product2(Name='support product 1',NonDiscountable__c =  false, ProductCode='SUP', Product_Type__c = 'Support', Salesforce_Product_Type__c = 'Support', Product_Class__c = productClassList[0].Id   );
        insert prod3;
        insert prod6;
        
        Service_Line_Matrix__c sl = new Service_Line_Matrix__c();
        sl.Product_Class__c = productClassList[0].Id;
        sl.Product_Type__c = 'Hardware';
        sl.Professional_Service_Product__c = prod3.Id;
        sl.Support_Product__c = prod6.Id;
        sl.Support_Type__c = 'Care';
        sl.Percent_of_Line_Total_Product_Line__c = 11;
        insert sl;
        
        List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
        
        for(Product_Class__c productClass : productClassList){
            QuoteLineItem item = createQuoteLineItem(productClass,testQuote.Id,pb.id,10,100);
            if(item != null){
                quoteLineItemList.add(item);
            }
        }
        insert quoteLineItemList;
        set<id> deleteQuoteLine = new set<id>();
        deleteQuoteLine.add(quoteLineItemList[0].id);
        QuoteLineTriggerHelper.quotesToCleanOfQLIS = deleteQuoteLine;
        QuoteLineTriggerHelper.cleanQuotesofQLIs(quoteLineItemList);
        QuoteLineItemTriggerManager.ALLOWSUPPORTPRODENTRY = true;
        test.stopTest();

        PageReference pageRef = Page.QuoteDiscountBatchStatus;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        QuoteBatchStatusExtension qbsExt = new QuoteBatchStatusExtension(sc);
        qbsExt.checkStatus();
    
    }

    @isTest(SeeAllData=true)
    static void testDataManipulation(){
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        test.startTest();
        Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
        insert testAccount;
        TestDataFactory.createAddress(testAccount);
        
        Pricebook2 pb = [select Id from Pricebook2 where isActive = true and Name='Canadian Domestic List Prices (CAD)'];
        
        Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.id,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
        insert testOpportunity;
    
        Quote testQuote = new Quote(Name = 'test Quote', Hardware_Discount__c=1.0,OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.id, Tier_Discount2__c = 20);  
        insert testQuote;
        
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Master Quote Solution', Order__c = 1.0, Quote__c = testQuote.id,Optional__c = false);
        insert qs1;
        
        List<Product_Class__c> productClassList = new List<Product_Class__c>();
        productClassList.add(TestDataFactory.initProductClass('DOH'));
        productClassList.add(TestDataFactory.initProductClass('Signaling & Transcoding'));
        productClassList.add(TestDataFactory.initProductClass('Professional Services'));
        productClassList.add(TestDataFactory.initProductClass('Support'));
        insert productClassList;
        
        Product2 prod3 = new Product2(Name='test product 3',NonDiscountable__c =  false, ProductCode='FRINKSF', Product_Type__c='Professional Services',Salesforce_Product_Type__c = 'Hardware', Product_Class__c = productClassList[0].Id);
        Product2 prod6 = new Product2(Name='support product 1',NonDiscountable__c =  false, ProductCode='SUP', Product_Type__c = 'Support', Salesforce_Product_Type__c = 'Support', Product_Class__c = productClassList[0].Id   );
        insert prod3;
        insert prod6;
        
        Service_Line_Matrix__c sl = new Service_Line_Matrix__c();
        sl.Product_Class__c = productClassList[0].Id;
        sl.Product_Type__c = 'Hardware';
        sl.Professional_Service_Product__c = prod3.Id;
        sl.Support_Product__c = prod6.Id;
        sl.Support_Type__c = 'Care';
        sl.Percent_of_Line_Total_Product_Line__c = 11;
        insert sl;
        
        List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
        
        for(Product_Class__c productClass : productClassList){
            QuoteLineItem item = createQuoteLineItem(productClass,testQuote.Id,pb.id,10,100);
            if(item != null){
                quoteLineItemList.add(item);
            }
        }
        insert quoteLineItemList;
        set<id> deleteQuoteLine = new set<id>();
        deleteQuoteLine.add(quoteLineItemList[0].id);
        QuoteLineTriggerHelper.quotesToCleanOfQLIS = deleteQuoteLine;
        QuoteLineTriggerHelper.cleanQuotesofQLIs(quoteLineItemList);
        QuoteLineItemTriggerManager.ALLOWSUPPORTPRODENTRY = true;
        test.stopTest();
    
        QuoteLineItem qliUpdate = quoteLineItemList[0];
        qliUpdate.Solution__c = qs1.id;
        qliUpdate.Support_Type_Text__c = 'Care';
        qliUpdate.Professional_Service_Product__c = false;
        qliUpdate.Support_Product__c = false;
        qliUpdate.Professional_Service_Requested__c = true;
        qliUpdate.Line_Discount__c = null;
        
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        QuoteLineItemTriggerManager.INITIALINSERT =  false;
        QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = true;
        update qliUpdate;
    }
    
    @isTest(SeeAllData=true)
    static void testDataManipulation2(){
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        test.startTest();
        Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
        insert testAccount;
        Address__c testAddress = TestDataFactory.createAddress(testAccount);
        
        Pricebook2 pb = [select Id from Pricebook2 where isActive = true and Name='Canadian Domestic List Prices (CAD)'];
       
        Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.id,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
        insert testOpportunity;
    
        Quote testQuote = new Quote(Name = 'test QuoteOptional', Hardware_Discount__c=1.0,OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.id, Tier_Discount2__c = 20);  
        insert testQuote;
        
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Master Quote Solution', Order__c = 1.0, Quote__c = testQuote.id,Optional__c = true);
        insert qs1;
        
        List<Product_Class__c> productClassList = new List<Product_Class__c>();
        productClassList.add(TestDataFactory.initProductClass('DOH'));
        productClassList.add(TestDataFactory.initProductClass('Signaling & Transcoding'));
        productClassList.add(TestDataFactory.initProductClass('Professional Services'));
        productClassList.add(TestDataFactory.initProductClass('Support'));
        insert productClassList;
        
        List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
        
        Product2 prod3 = new Product2(Name='test product 3', NonDiscountable__c =  false,ProductCode='FRINKSF', Product_Type__c='Professional Services',Salesforce_Product_Type__c = 'Hardware', Product_Class__c = productClassList[0].Id);
        Product2 prod6 = new Product2(Name='support product 1',NonDiscountable__c =  false, ProductCode='SUP', Product_Type__c = 'Support', Salesforce_Product_Type__c = 'Support', Product_Class__c = productClassList[0].Id   );
        insert prod3;
        insert prod6;
        
        Service_Line_Matrix__c sl = new Service_Line_Matrix__c();
        sl.Product_Class__c = productClassList[0].Id;
        sl.Product_Type__c = 'Hardware';
        sl.Professional_Service_Product__c = prod3.Id;
        sl.Support_Product__c = prod6.Id;
        sl.Support_Type__c = 'Care';
        sl.Percent_of_Line_Total_Product_Line__c = 11;
        insert sl;
        
        
        for(Product_Class__c productClass : productClassList){
            QuoteLineItem item = createQuoteLineItem(productClass,testQuote.Id,pb.id,10,100);
            if(item != null){
                quoteLineItemList.add(item);
            }
        }
        insert quoteLineItemList;
        set<id> deleteQuoteLine = new set<id>();
        deleteQuoteLine.add(quoteLineItemList[0].id);
        QuoteLineTriggerHelper.quotesToCleanOfQLIS = deleteQuoteLine;
        QuoteLineTriggerHelper.cleanQuotesofQLIs(quoteLineItemList);
        QuoteLineItemTriggerManager.ALLOWSUPPORTPRODENTRY = true;
        test.stopTest();
    
       // QuoteLineItem qliUpdate = [SELECT Id from QuoteLineItem where id limit 1];
        QuoteLineItem qliUpdate = quoteLineItemList[0];
        qliUpdate.Solution__c = qs1.id;
        qliUpdate.Support_Type_Text__c = 'Care';
        qliUpdate.Professional_Service_Product__c = false;
        qliUpdate.Support_Product__c = false;
        qliUpdate.Professional_Service_Requested__c = true;
        qliUpdate.Line_Discount__c = null;
        
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        QuoteLineItemTriggerManager.INITIALINSERT =  false;
        QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = true;
        update qliUpdate;
    
        PageReference pageRef = Page.QuoteDiscountBatchStatus;
        Test.setCurrentPage(pageRef);
        Quote batchQuote = [SELECT id,Discount_Batch_Id__c FROM Quote WHERE id =:testQuote.id];
        pageRef.getParameters().put('Id', String.valueOf(batchQuote.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(batchQuote);
        QuoteBatchStatusExtension qbsExt = new QuoteBatchStatusExtension(sc);
        qbsExt.checkStatus();
    }
    
    public static QuoteLineItem createQuoteLineItem(Product_class__c productClass,Id quoteId , Id priceBookId, Integer quantity , Integer unitPrice){
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        QuoteLineItemTriggerManager.ALLOWPRODUCTUPDATE = false;
        Product2 product = new Product2();
        product.Product_Cost__c = 50 ;
        product.Name = 'test';
        product.NonDiscountable__c =  false;
        product.Salesforce_Product_Type__c = 'Hardware';
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
}