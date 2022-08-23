@IsTest(SeeAllData=false)
public with sharing class TestDataFactory {

    public static Account acc;
    public static Address__c address;
    public static List<Product2> products;
    public static Opportunity opp;
    public static Quote qt;
    public static Quote_Solutions__c parentSolution;
    public static List<Quote_Solutions__c> solutionsList;
    public static List<QuoteLineItem> quoteLineItems;
    
    public static SBQQ__Quote__c setupTestCPQQuote() {
        acc = TestDataFactory.createAccount();
        address = TestDataFactory.createAddress(acc);
        String pricebookId = Test.getStandardPricebookId();
        products = new List<Product2>{
            TestDataFactory.initProduct('Test product 1', 'FRINKSD', 'Hardware'),
            TestDataFactory.initProduct('Test product 2', 'FRINKSE', 'Hardware'),
            TestDataFactory.initProduct('Test product 3', 'FRINKSF', 'Hardware'),
            TestDataFactory.initProduct('Test product 4', 'FRINKSG', 'Hardware')
        };
        insert products;
        // should insert pricebook entries in standard pricebook
        List<PricebookEntry> pricebookEntries = [
            select Id, UnitPrice, Product2Id, Pricebook2Id 
            from PricebookEntry 
            where Product2Id IN :products and Pricebook2Id = :pricebookId and CurrencyIsoCode='USD'
        ];
        System.assert(pricebookEntries.size() == products.size());
        opp = TestDataFactory.createOpportunity(acc);
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>{
            new SBQQ__Quote__c(
                SBQQ__Account__c=acc.Id,
                SBQQ__Opportunity2__c=opp.Id
            ),
            new SBQQ__Quote__c(
                SBQQ__Account__c=acc.Id,
                SBQQ__Opportunity2__c=opp.Id
            )
        };
        insert quotes;
        return quotes.get(0);
    }
    
    public static SBQQ__Quote__c setupTestCPQQuote(Integer noOfQuotes) {
        acc = TestDataFactory.createAccount();
        address = TestDataFactory.createAddress(acc);
        String pricebookId = Test.getStandardPricebookId();
        products = new List<Product2>{
            TestDataFactory.initProduct('Test product 1', 'FRINKSD', 'Hardware'),
            TestDataFactory.initProduct('Test product 2', 'FRINKSE', 'Hardware'),
            TestDataFactory.initProduct('Test product 3', 'FRINKSF', 'Hardware'),
            TestDataFactory.initProduct('Test product 4', 'FRINKSG', 'Hardware')
        };
        insert products;
        // should insert pricebook entries in standard pricebook
        List<PricebookEntry> pricebookEntries = [
            select Id, UnitPrice, Product2Id, Pricebook2Id 
            from PricebookEntry 
            where Product2Id IN :products and Pricebook2Id = :pricebookId and CurrencyIsoCode='USD'
        ];
        System.assert(pricebookEntries.size() == products.size());
        opp = TestDataFactory.createOpportunity(acc);
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        for (Integer i=0; i<noOfQuotes; i++){
            quotes.add(new SBQQ__Quote__c(
                SBQQ__Account__c=acc.Id,
                SBQQ__Opportunity2__c=opp.Id
            ));
        }
        insert quotes;
        return quotes.get(0);
    }

    public static Quote setupTestQuote(Boolean addNMSProduct){
        acc = TestDataFactory.createAccount();
        address = TestDataFactory.createAddress(acc);
        String pricebookId = Test.getStandardPricebookId();
        products = new List<Product2>{
            TestDataFactory.initProduct('Test product 1', 'FRINKSD', 'Hardware'),
            TestDataFactory.initProduct('Test product 2', 'FRINKSE', 'Hardware'),
            TestDataFactory.initProduct('Test product 3', 'FRINKSF', 'Hardware'),
            TestDataFactory.initProduct('Test product 4', 'FRINKSG', 'Hardware')
        };
        insert products;
        Product2 prodWithNms = null;
        if(addNMSProduct == true) {
            prodWithNms = setupProductWithNMSProduct();
            products.add(prodWithNms);
        }
        // should insert pricebook entries in standard pricebook
        List<PricebookEntry> pricebookEntries = [
            select Id, UnitPrice, Product2Id, Pricebook2Id 
            from PricebookEntry 
            where Product2Id IN :products and Pricebook2Id = :pricebookId and IsActive = true and CurrencyIsoCode='USD'
        ];
        System.assert(pricebookEntries.size() == products.size());
        opp = TestDataFactory.createOpportunity(acc);
        qt = TestDataFactory.createQuote(pricebookId, opp, acc);
        opp.SyncedQuoteId = qt.Id;
        update opp;
        
        parentSolution = TestDataFactory.initQuoteSolution('Parent Solution', 1.0, qt.Id, null);
        insert parentSolution;
        
        solutionsList = new List<Quote_Solutions__c>();
        solutionsList.add(TestDataFactory.initQuoteSolution('Child Solution 1', 1.0, qt.Id, parentSolution.Id));
        solutionsList.add(TestDataFactory.initQuoteSolution('Child Solution 2', 2.0, qt.Id, parentSolution.Id));
        solutionsList.add(TestDataFactory.initQuoteSolution('Child Solution 3', 3.0, qt.Id, parentSolution.Id));
        solutionsList.add(TestDataFactory.initQuoteSolution('Child Solution 4', 4.0, qt.Id, parentSolution.Id));
        if(addNMSProduct == true) solutionsList.add(TestDataFactory.initQuoteSolution('Child Solution 5', 5.0, qt.Id, parentSolution.Id));
        insert solutionsList;
        System.assert(pricebookEntries.size() == solutionsList.size());
        
        quoteLineItems = new List<QuoteLineItem>();
        for(Integer i=0; i<pricebookEntries.size(); i++){
            Decimal quantity = (i + 1);
            Decimal unitPrice = (i + 1) * 10;
            quoteLineItems.add(TestDataFactory.initQuoteLineItem(qt.Id, pricebookEntries.get(i).Id, solutionsList.get(i).Id, quantity, unitPrice));
        }
        insert quoteLineItems;
        return qt;
    }

    public static Account createAccount(){
        List<RecordType> recordTypes = [
            select Id 
            from RecordType 
            where SObjectType='Account' and DeveloperName = 'Partners'
            limit 1
        ];
        System.assert(recordTypes.size() != 0);
        Account acc = new Account(
            Name='Test account',
            Status__c='Active',
            Partner_Product_Prices__c='US Domestic',
            RecordTypeId=recordTypes.get(0).Id
        );
        insert acc;
        return acc;
    }
    
    public static Address__c createAddress(Account acc){
        Country__c country = new Country__c(
            Name='United States of America',
            Country__c='United States of America',
            Global_Region__c='NORTH AMERICA',
            Region__c='US'
        );
        insert country;
        Address__c address = new Address__c(
            Account__c=acc.Id,
            Name='Test Address',
            Street_Address__c='15 Harrison Road',
            Country__c=country.Name,
            City__c='Somerville',
            Salesforce_Primary__c=true,
            State__c='Massachusetts',
            Zip_Code__c='60646'
        );
        insert address;
        return address;
    }

    public static Contact createContact(Account acc){
        Contact con = new Contact();
        con.FirstName = 'John';
        con.LastName = 'Smith';
        con.AccountId = acc.Id;
        con.Email = '';
        insert con;
        return con;
    }
    
    public static Product2 initProduct(String pName, String pCode, String pType){
        Product2 prod = new Product2(
            Name=pName,
            ProductCode=pCode,
            Product_Type__c=pType,
            Salesforce_Product_Type__c=pType,
            Quotable__c=true,
            IsActive=true
        );
        return prod;
    }

    public static Product2 createProduct(){
        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware');
        insert prod;
        return prod;
    }

    public static PriceBook2 createCustomPriceBook(){
        Pricebook2 pricebook = new Pricebook2(Name='SC SFDC Only Pricebook', isActive=true);
        insert pricebook;
        return pricebook;
    }

    public static PricebookEntry createPricebookEntry(PriceBook2 pricebook, Product2 product){
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id=pricebook.Id,
            Product2Id=product.Id,
            UnitPrice=12000,
            IsActive = true
        );
        insert pbe;
        return pbe;
    }

    public static Asset createAsset(Account acc, Contact con){
        Asset ast = new Asset(
            Name = 'Test Asset',
            Status = 'Purchased',
            AccountId = acc.Id,
            ContactId = con.Id,
            InstallDate = System.today(),
            UsageEndDate = System.today()
        );
        insert ast;
        return ast;
    }

    public static ServiceContract createServiceContract(Account acc, Pricebook2 customPB, Date startDate, Date endDate){
        ServiceContract sc = new ServiceContract();
        sc.Name = 'Test Contract-1';
        sc.AccountID = acc.Id;
        sc.Pricebook2Id = customPB.Id;
        sc.StartDate = startDate;
        sc.EndDate = endDate ;
        insert sc;
        return sc;
    }

    public static ContractLineItem createContractLineItem(PricebookEntry customPrice, ServiceContract sc, Asset ast){
        ContractLineItem cli = new ContractLineItem();
        cli.Quantity = 100;
        cli.PricebookEntryId = customPrice.Id;
        cli.ServiceContractId= sc.id;
        cli.AssetId = ast.id;
        cli.UnitPrice= 12;  
        insert cli;
        return cli;
    }

    public static Case createCaseWithRecordType(String recordTypeName, Account acc, Contact con, Asset ast){
        Case newCase = new Case();
        newCase.AccountId = acc.id;
        newCase.Type = 'Performance';
        newCase.Product_Line__c = 'Stream';
        newCase.AssetID = ast.Id;
        newCase.ContactId = con.id;
        newCase.recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND IsActive = true AND (DeveloperName =:recordTypeName) LIMIT 1].Id;
        insert newCase;
        return newCase ;
    }

    public static List<Entitlement> createEntitlement( Account acc){
        List<Entitlement> lstEntmnt = new  List<Entitlement>();
        lstEntmnt.add(new Entitlement(Name='Standard Service Entitlement', AccountId=acc.Id));
        lstEntmnt.add(new Entitlement(Name='Default Service Entitlement', AccountId=acc.Id));
        lstEntmnt.add(new Entitlement(Name='Care Service Entitlement', AccountId=acc.Id));
        lstEntmnt.add(new Entitlement(Name='Care+ Service Entitlement', AccountId=acc.Id));
        insert lstEntmnt;
        return lstEntmnt;
    }

    public static Opportunity createOpportunity(Account acc) {
        if(acc == null) acc= createAccount();
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            Amount = 100000,
            CloseDate = Date.today(),
            BSR_Value__c  = 0
        );
        insert opp;
        return opp;
    }
    
    public static Quote createQuote(String pricebookId, Opportunity opp, Account acc){
        Quote qt = new Quote(
            Name='Test Quote 1',
            Pricebook2Id=pricebookId,
            Effective__c=Date.today(),
            OpportunityId=opp.Id,
            Account_Lookup__c=acc.Id
        );
        insert qt;
        return qt;
    }
    
    public static Quote_Solutions__c initQuoteSolution(String solutionName, Decimal order, String quoteId, String parentSolutionId){
        Quote_Solutions__c qs = new Quote_Solutions__c(
            Name=solutionName,
            Order__c=order,
            Quote__c=quoteId,
            Parent_Solution__c=parentSolutionId
        );
        return qs;
    }
    
    public static QuoteLineItem initQuoteLineItem(String quoteId, String pbeId, String solId, Decimal quantity, Decimal unitPrice){
        QuoteLineItem qli = new QuoteLineItem(
            QuoteId=quoteId,
            PricebookEntryId=pbeId,
            Solution__c=solId,
            Quantity=quantity,
            UnitPrice=unitPrice
        );
        return qli;
    }
    
    public static Case createCase(Account a) {
        if (a == null) a = createAccount();
        Case c = new Case(
            Subject = 'Test Case',
            AccountId = a.Id
        );
        insert c;
        return c;
    }
    
    public static Product_Class__c initProductClass(String productLine){
        Product_Class__c productClass = new Product_Class__c(
            Name='Test',
            Product_Line__c=productLine
        );
        return productClass;
    }
    
    public static Product2 setupProductWithNMSProduct(){
        Product2 prod1 = initProduct('Test NMS Product', 'NSM-PR-1', 'Hardware');
        prod1.NMS_Proserv_Rate__c = 0.33;
        insert prod1;
        Product2 prod2 = initProduct('Test Product with NMS', 'FRINKSH', 'Hardware');
        prod2.NMS_Proserv__c = prod1.Id;
        insert prod2;
        return prod2;
    }
    
    public static Milestone1_Time__c setupMilestone1TimeWithCase() {
        acc = createAccount();
        Case ca = createCase(acc);
        Milestone1_Time__c msTime = new Milestone1_Time__c(
            Billable__c = true,
            Case__c = ca.Id,
            Category__c = 'Service',
            Charge_Code__c = 'Research',
            Date__c  = Date.today(),
            Description__c = 'Sample desc for test class',
            Hours__c = 4,
            Incurred_By__c = userinfo.getuserid(),
            Time_Type__c = 'PM'
        );
        insert msTime;
        return msTime;
    }
    
    public static Milestone1_Time__c setupMilestone1TimeWithOpp() {
        acc = createAccount();
        opp = createOpportunity(acc);
        Milestone1_Time__c msTime = new Milestone1_Time__c(
            Billable__c = true,
            Category__c = 'Service',
            Charge_Code__c = 'Research',
            Date__c  = Date.today(),
            Description__c = 'Sample desc for test class',
            Hours__c = 4,
            Incurred_By__c = userinfo.getuserid(),
            Opportunity__c = opp.Id,
            Time_Type__c = 'PM'
        );
        insert msTime;
        return msTime;
    }
    
    public static Time_Reporting__c setupTimeReporting(Id msTimeId){
        Time_Reporting__c timeReproting = new Time_Reporting__c(
            Name = 'Test Time',
            Billable__c = true,
            Category__c = 'Service',
            Charge_Code__c = 'Research',
            Date_Incurred__c  = Date.today(),
            Description__c = 'Sample desc for test class',
            Hours__c = 4,
            MS_Time4__c = msTimeId,
            Time_Id__c = ('TEST'+Math.random()).substring(0, 18),
            Incurred_By__c = userinfo.getuserid(),
            Opportunity__c = opp.Id,
            Time_Type__c = 'PM'
        );
        insert timeReproting;
        return timeReproting;
    }
    
    public static Time_Reporting__c setupTimeReportingMpm4Base(Id msTimeId){
        Time_Reporting__c timeReproting = new Time_Reporting__c(
            Name = 'Test Time',
            Billable__c = true,
            Category__c = 'Service',
            Charge_Code__c = 'Research',
            Date_Incurred__c  = Date.today(),
            Description__c = 'Sample desc for test class',
            Hours__c = 4,
            MPM4_Time__c = msTimeId,
            Time_Id__c = ('TEST' + Math.random()).substring(0, 18),
            Incurred_By__c = userinfo.getuserid(),
            Time_Type__c = 'PM'
        );
        insert timeReproting;
        return timeReproting;
    }
    
    public static MPM4_BASE__Milestone1_Time__c setupMPM4Time() {
        MPM4_BASE__Milestone1_Task__c task = setupMPM4Task();
        MPM4_BASE__Milestone1_Time__c mpmTime = new MPM4_BASE__Milestone1_Time__c(
            Billable__c = true,
            Category__c = 'Service',
            Charge_Code__c = 'Research',
            MPM4_BASE__Date__c  = Date.today(),
            MPM4_BASE__Description__c = 'Sample desc for test class',
            MPM4_BASE__Hours__c = 4,
            MPM4_BASE__Incurred_By__c = userinfo.getuserid(),
            Time_Type__c = 'PM',
            MPM4_BASE__Project_Task__c = task.Id
        );
        insert mpmTime;
        return mpmTime;
    }
    public static MPM4_BASE__Milestone1_Task__c setupMPM4Task() {
        MPM4_BASE__Milestone1_Milestone__c milestone = setupMPM4Milestone();
        MPM4_BASE__Milestone1_Task__c mpmTask = new MPM4_BASE__Milestone1_Task__c(
            Name = 'Test Task',
            MPM4_BASE__Project_Milestone__c = milestone.Id
        );
        insert mpmTask;
        return mpmTask;
    }
    public static MPM4_BASE__Milestone1_Project__c setupMPM4Project() {
        MPM4_BASE__Milestone1_Project__c mpmProject = new MPM4_BASE__Milestone1_Project__c(
            Name = 'Chatter Blow'+ ''+ Datetime.now().getTime()
        );
        insert mpmProject;
        return mpmProject;
    }
    public static MPM4_BASE__Milestone1_Milestone__c setupMPM4Milestone() {
        MPM4_BASE__Milestone1_Project__c project = setupMPM4Project();
        MPM4_BASE__Milestone1_Milestone__c mpmMilestone = new MPM4_BASE__Milestone1_Milestone__c(
            Name = 'Test Milestone',
            MPM4_BASE__Project__c = project.Id
        );
        insert mpmMilestone;
        return mpmMilestone;
    }
}