@IsTest(SeeAllData=true)
public class MyCareProductsControllerTests {
    
    private static Quote q1;
    
    private static void setupTestQuote(String supportType, Boolean setupSpecialRate) {
        QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = true;
        Account acc = new Account(Name='Test Account', Status__c='Active', Partner_Product_Prices__c='US Domestic', RecordTypeId=[SELECT id FROM RecordType where SObjectType='Account' AND Name='Channel Partner' LIMIT 1].Id);
        insert acc;
        Address__c address = new Address__c(Account__c = acc.id, Name='test Address', Street_Address__c ='124 test avenue', Country__c ='United States of America', City__c = 'Chicago', Salesforce_Primary__c = true, State__c = 'Illinois', Zip_Code__c ='60646', Region__c='NORTH AMERICA', Sub_Region__c='US');
        insert address;
        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE IsStandard=true AND CurrencyISOCode = 'USD' AND IsActive=true limit 1][0];
        Product_Class__c pc = new Product_Class__c();
        pc.Product_Line__c = 'Automation';
        pc.Business_Unit__c = 'Networking';
        insert pc;
        
        Product2 sp1 = new Product2(Name='support product 1', Support_Rate__c = 7, ProductCode='FRINKS1', Product_Type__c='Support', Salesforce_Product_Type__c = 'Hardware', Product_Class__c = pc.Id, Quotable__c=true, IsActive=true);
        Product2 sp2 = new Product2(Name='support product 2', Support_Rate__c = 12, ProductCode='FRINKS1', Product_Type__c='Support', Salesforce_Product_Type__c = 'Hardware', Product_Class__c = pc.Id, Quotable__c=true, IsActive=true);
        Product2 sp3 = new Product2(Name='support product 3', Support_Rate__c = 15, ProductCode='FRINKS1', Product_Type__c='Support', Salesforce_Product_Type__c = 'Hardware', Product_Class__c = pc.Id, Quotable__c=true, IsActive=true);
        insert new List<Product2>{sp1, sp2, sp3};
            
        List<Special_Support_Rate__c> specialRates = new List<Special_Support_Rate__c>(); 
        if(setupSpecialRate == true) {
            specialRates.addAll(new List<Special_Support_Rate__c>{
                new Special_Support_Rate__c(
                    Name='Care Special Rate',
                    Support_Rate__c=20,
                    Account_Bill_To_Region__c='NORTH AMERICA',
                    Account_Bill_To_Sub_Region__c='US',
                    Product2__c=sp1.Id
                ),
                new Special_Support_Rate__c(
                    Name='MyCare Special Rate',
                    Support_Rate__c=22,
                    Account_Bill_To_Region__c='NORTH AMERICA',
                    Account_Bill_To_Sub_Region__c='US',
                    Product2__c=sp2.Id
                ),
                new Special_Support_Rate__c(
                    Name='MyCareUniversal Special Rate',
                    Support_Rate__c=24,
                    Account_Bill_To_Region__c='NORTH AMERICA',
                    Account_Bill_To_Sub_Region__c='US',
                    Product2__c=sp3.Id
                )
            });
            insert specialRates;
        }
        
        Product2 prod1 = new Product2(
            Name='hardware product 1',
            ProductCode='FRINKSD',
            Product_Type__c='Hardware',
            Salesforce_Product_Type__c = 'Hardware',
            Product_Class__c = pc.Id,
            Support_Product_MyCare__c = sp1.Id,
            Support_Product_MyCarePlus__c = sp2.Id,
            Support_Product_MyCareUniversal__c = sp3.Id,
            Quotable__c=true,
            IsActive=true
        );
        insert new List<Product2>{prod1};

        String[] productIds = new String[]{prod1.id, sp1.id, sp2.id, sp3.id};

        PricebookEntry pbe1;
        PricebookEntry pbesp1;
        PricebookEntry pbesp2;
        PricebookEntry pbesp3;

        for(PricebookEntry pbe : [SELECT Id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id IN :productIds AND Pricebook2Id =:pb.id AND IsActive=true AND CurrencyIsoCode='USD']) {
            if(pbe.Product2Id == prod1.Id) {
                pbe1 = pbe;
            }
            if(pbe.Product2Id == sp1.Id) {
                pbesp1 = pbe;
            }
            if(pbe.Product2Id == sp2.Id) {
                pbesp2 = pbe;
            }
            if(pbe.Product2Id == sp3.Id) {
                pbesp3 = pbe;
            }
        }
            
        System.assert(pbe1 != null);
        System.assert(pbesp1 != null);
        System.assert(pbesp2 != null);
        System.assert(pbesp3 != null);
        
        Opportunity opp = new Opportunity(Name='test opp', AccountId=acc.id, closeDate = Date.today().addDays(30), stageName='03 - Upside - Solution Identified', CurrencyISOCode = 'USD');
        insert opp;
        
        q1 = new Quote(Name='test Quote 1', Pricebook2Id=pb.id, Effective__c = Date.today(), OpportunityId = opp.id, Account_Lookup__c=acc.id, Default_Price_book__c = pb.Id, Support_Type__c = supportType, Billing_Address__c=address.Id);
        insert q1;
        
        opp.SyncedQuoteId = q1.Id;
        update opp;
        
        Quote_Solutions__c qs1 = new Quote_Solutions__c(Name='Hardware', Order__c = 1.0, Quote__c = q1.Id, Optional__c = false);
        insert qs1;
        
        QuoteLineItem ql1 = new QuoteLineItem(PricebookEntryId= pbe1.id, QuoteId=q1.Id, Solution__c = qs1.id, Quantity = 10, UnitPrice=55.00, Support_Type_Text__c = supportType, Professional_Service_Requested__c = false,Professional_Service_Product__c = false,Support_Product__c = false);
        insert new List<QuoteLineItem>{ql1};
    }

    @IsTest
    public static void testCareSupport() {
        setupTestQuote('Care', false);            
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', q1.Id);
        MyCareProductsController con = new MyCareProductsController();
        con.addSupportProducts();
        con.cancel();
        con.addSupportProducts();
        
        List<QuoteLineItem> supportItems = [SELECT Id FROM QuoteLineItem WHERE QuoteId =: q1.Id AND Solution__r.Name = 'Support'];
        System.assert(supportItems.size() == 1);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testCareSpecialSupport() {
        setupTestQuote('Care', true);            
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', q1.Id);
        MyCareProductsController con = new MyCareProductsController();
        con.addSupportProducts();
        con.cancel();
        con.addSupportProducts();
        
        List<QuoteLineItem> supportItems = [SELECT Id FROM QuoteLineItem WHERE QuoteId =: q1.Id AND Solution__r.Name = 'Support'];
        System.assert(supportItems.size() == 1);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testCarePlusSupport() {
        setupTestQuote('Care Plus', false);            
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', q1.Id);
        MyCareProductsController con = new MyCareProductsController();
        con.addSupportProducts();
        con.cancel();
        
        List<QuoteLineItem> supportItems = [SELECT Id FROM QuoteLineItem WHERE QuoteId =: q1.Id AND Solution__r.Name = 'Support'];
        System.assert(supportItems.size() == 1);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testCarePlusSpecialSupport() {
        setupTestQuote('Care Plus', true);            
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', q1.Id);
        MyCareProductsController con = new MyCareProductsController();
        con.addSupportProducts();
        con.cancel();
        
        List<QuoteLineItem> supportItems = [SELECT Id FROM QuoteLineItem WHERE QuoteId =: q1.Id AND Solution__r.Name = 'Support'];
        System.assertEquals(1, supportItems.size(), 'support lines expected 1 support solution set: ' + [select Id, Solution__r.Name from QuoteLineItem WHERE QuoteId =: q1.Id]);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testCarePlusUniversalSupport() {
        setupTestQuote('MyCare+U', false);
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', q1.Id);
        MyCareProductsController con = new MyCareProductsController();
        con.addSupportProducts();
        con.cancel();
        
        List<QuoteLineItem> supportItems = [SELECT Id FROM QuoteLineItem WHERE QuoteId =: q1.Id AND Solution__r.Name = 'Support'];
        System.assert(supportItems.size() == 1);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testCarePlusUniversalSpecialSupport() {
        setupTestQuote('MyCare+U', true);
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', q1.Id);
        MyCareProductsController con = new MyCareProductsController();
        con.addSupportProducts();
        con.cancel();
        
        List<QuoteLineItem> supportItems = [SELECT Id FROM QuoteLineItem WHERE QuoteId =: q1.Id AND Solution__r.Name = 'Support'];
        System.assert(supportItems.size() == 1);
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testNoQuote() {
        setupTestQuote('Care', false);
        Test.startTest();
        
        MyCareProductsController con = new MyCareProductsController();
        con.addSupportProducts();
        con.cancel();
        
        List<QuoteLineItem> supportItems = [SELECT Id FROM QuoteLineItem WHERE QuoteId =: q1.Id AND Solution__r.Name = 'Support'];
        System.assert(supportItems.size() == 0);
        
        Test.stopTest();
    }
    
    @isTest
    static void shouldGetPricebookEntry(){
        setupTestQuote('Care', false);
        Test.startTest();
        
        List<QuoteLineItem> qlis = [
            select Id, Product2Id, Product2.Support_Product_MyCare__c, 
            Product2.Support_Product_MyCare__r.Default_Support_Quantity__c, 
            Product2.Support_Product_MyCarePlus__c, Product2.Support_Product_MyCareUniversal__c 
            from QuoteLineItem where QuoteId = :q1.Id
        ];
        System.assert(qlis.size() != 0);
        Set<Id> supportIds = new Set<Id>();
        QuoteLineItem qli = qlis.get(0);
        supportIds.add(qli.Product2.Support_Product_MyCare__c);
        supportIds.add(qli.Product2.Support_Product_MyCarePlus__c);
        supportIds.add(qli.Product2.Support_Product_MyCareUniversal__c);
        
        List<PricebookEntry> entries = [
            select Id, Product2Id, CurrencyIsoCode, UnitPrice  
            from PricebookEntry 
            where Pricebook2Id = :q1.Pricebook2Id 
                and Product2Id in :supportIds
        ];
        System.assert(entries.size() != 0);
        
        ApexPages.currentPage().getParameters().put('id', q1.Id);
        MyCareProductsController con = new MyCareProductsController();
        PricebookEntry entry = con.getPricebookEntry(entries, qli.Product2.Support_Product_MyCare__c);
        System.assert(entry != null);
        Decimal quantity = con.getSupportQuantity(qli.Product2.Support_Product_MyCare__r);
        
        Test.stopTest();
    }
}