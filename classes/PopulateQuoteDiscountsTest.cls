@isTest(SeeAllData = true)
public class PopulateQuoteDiscountsTest {
    private testmethod static void discountTest1(){
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        test.startTest();
        Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
        insert testAccount;
        Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
        insert cty;
        Address__c testAddress = TestDataFactory.createAddress(testAccount);
        
        Pricebook2 pb = [select Id from Pricebook2 where isActive = true and Name='Canadian Domestic List Prices (CAD)'];
       
        Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.id,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
        insert testOpportunity;

        Quote testQuote = new Quote(Name = 'test QuoteOptional', Hardware_Discount__c=1.0,OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.id, Tier_Discount2__c = 20);  
        insert testQuote;
        
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Master Quote Solution', Order__c = 1.0, Quote__c = testQuote.id,Optional__c = true);
        insert qs1;
        
        List<String> productLineList = new List<String>();
        productLineList.add('DOH');
        productLineList.add('Signaling & Transcoding');
        
        productLineList.add('Professional Services');
        productLineList.add('Support');
        List<Product_Class__c> productClassList = new List<Product_Class__c>();

        for(String productLine : productLineList){
            Product_Class__c pClass = TestDataFactory.initProductClass(productLine);
            if(pClass != null){
                productClassList.add(pClass);
            }
        }
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
            QuoteLineItem item = QuoteLineMainTest.createQuoteLineItem(productClass,testQuote.Id,pb.id,10,100);
            if(item != null){
                quoteLineItemList.add(item);
            }
        }
        for(Product_Class__c productClass : productClassList){
            QuoteLineItem item = QuoteLineMainTest.createQuoteLineItem(productClass,testQuote.Id,pb.id,10,100, 'OEM', 'Hardware');
            if(item != null){
                quoteLineItemList.add(item);
            }
        }

        for(Product_Class__c productClass : productClassList){
            QuoteLineItem item = QuoteLineMainTest.createQuoteLineItem(productClass,testQuote.Id,pb.id,10,100, 'OEM', 'support');
            if(item != null){
                quoteLineItemList.add(item);
            }
        }

        for(Product_Class__c productClass : productClassList){
            QuoteLineItem item = QuoteLineMainTest.createQuoteLineItem(productClass,testQuote.Id,pb.id,10,100, 'OEM', 'service');
            if(item != null){
                quoteLineItemList.add(item);
            }
        }

        for(Product_Class__c productClass : productClassList){
            QuoteLineItem item = QuoteLineMainTest.createQuoteLineItem(productClass,testQuote.Id,pb.id,10,100, 'OEM', 'Software');
            if(item != null){
                quoteLineItemList.add(item);
            }
        }
        insert quoteLineItemList;
        PopulateQuoteDiscounts.populateDiscounts(new List<Id> {testQuote.Id});

        PageReference pageRef = Page.QuoteDiscountBatchStatus;
        Test.setCurrentPage(pageRef);
        Quote batchQuote = [SELECT id,Discount_Batch_Id__c FROM Quote WHERE id =:testQuote.id];
        pageRef.getParameters().put('Id', String.valueOf(batchQuote.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(batchQuote);
        QuoteBatchStatusExtension qbsExt = new QuoteBatchStatusExtension(sc);
        qbsExt.checkStatus();
        test.stopTest();
    }
    private testmethod static void discountTest2(){
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        test.startTest();
        Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
        insert testAccount;
        Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
        insert cty;
        Address__c testAddress = TestDataFactory.createAddress(testAccount);
        
        Pricebook2 pb = [select Id from Pricebook2 where isActive = true and Name='Canadian Domestic List Prices (CAD)'];
       
        Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.id,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
        insert testOpportunity;

        Quote testQuote = new Quote(Name = 'test QuoteOptional', Hardware_Discount__c=1.0,OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.id, Tier_Discount2__c = 20);  
        insert testQuote;
        
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Master Quote Solution', Order__c = 1.0, Quote__c = testQuote.id,Optional__c = true);
        insert qs1;
        
        List<String> productLineList = new List<String>();
        productLineList.add('DOH');
        productLineList.add('Signaling & Transcoding');
        
        productLineList.add('Professional Services');
        productLineList.add('Support');
        List<Product_Class__c> productClassList = new List<Product_Class__c>();

        for(String productLine : productLineList){
            Product_Class__c pClass = TestDataFactory.initProductClass(productLine);
            if(pClass != null){
                productClassList.add(pClass);
            }
        }
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
            QuoteLineItem item = QuoteLineMainTest.createQuoteLineItem(productClass,testQuote.Id,pb.id,10,100);
            if(item != null){
                quoteLineItemList.add(item);
            }
        }
        insert quoteLineItemList;
        QuoteDiscountBatch qdb = new QuoteDiscountBatch(new Set<Id> {testQuote.Id});
        Id batchId = Database.executeBatch(qdb, 10);

        PageReference pageRef = Page.QuoteDiscountBatchStatus;
        Test.setCurrentPage(pageRef);
        Quote batchQuote = [SELECT id,Discount_Batch_Id__c FROM Quote WHERE id =:testQuote.id];
        batchQuote.Discount_Batch_Id__c = batchId;
        update batchQuote;
        pageRef.getParameters().put('Id', String.valueOf(batchQuote.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(batchQuote);
        QuoteBatchStatusExtension qbsExt = new QuoteBatchStatusExtension(sc);
        qbsExt.checkStatus();
        test.stopTest();
    }
}