@IsTest(SeeAllData=true)
public class Test_blogic_ContractLineItem {
    
    public static final String TEST_PRICEBOOK = 'SC SFDC Only Pricebook';

    /*@TestSetup
    static void setupTestData() {
        Product_Class__c prodClass = new Product_Class__c();
        prodClass.Name = 'TestClass';
        prodClass.Business_Unit__c = 'Networking';
        insert prodClass;
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = TEST_PRICEBOOK;
        pb.IsActive = true;
        insert pb;
        
        Product2 prod = new Product2(
            Name='Test Fusion Product',
            Description='Test Fusion Product',
            IsActive = true,
            Product_Type__c='Hardware',
            Salesforce_Product_Type__c='Hardware',
            Product_Class__c = prodClass.Id,
            Oracle_Cloud_Id__c='P123456789'
        );
        insert prod;
        
        Account acc = TestDataFactory.createAccount();
        TestDataFactory.createAddress(acc);
    }*/
    
    @isTest
    static void shouldCreatePricebookEntries() {
        Pricebook2 pb = [select Id from Pricebook2 where Name = :TEST_PRICEBOOK order by CreatedDate desc limit 1];
        Account acc = TestDataFactory.createAccount();
        Contact con = TestDataFactory.createContact(acc);
        TestDataFactory.createAddress(acc);
        Address__c add = [
            select Id, Account__c 
            from Address__c 
            where Account__c != null 
            and Oracle_Address_Id__c != null and active__c = true limit 1
        ];
        
        
        Product_Class__c prodClass = new Product_Class__c();
        prodClass.Name = 'TestClass';
        prodClass.Business_Unit__c = 'Networking';
        insert prodClass;
        
        Product2 prod = new Product2(
            Name='Test Fusion Product',
            Description='Test Fusion Product',
            IsActive = true,
            Product_Type__c='Hardware',
            Salesforce_Product_Type__c='Hardware',
            Product_Class__c = prodClass.Id,
            Oracle_Cloud_Id__c='P123456789'
        );
        insert prod;
        
        Test.startTest();
        
        Asset ast = TestDataFactory.createAsset(acc, con);
        
        ServiceContract sc = new ServiceContract();
        sc.Name = 'Test Fusion SC';
        sc.AccountId = add.Account__c;
        sc.Service_Level__c = 'Standard';
        sc.End_Customer_Account__c = add.Account__c;
        sc.Bill_To_Account__c = add.Account__c;
        sc.Ship_To_Account__c = add.Account__c;
        sc.Bill_To_Address__c = add.Id;
        sc.Ship_To_Address__c = add.Id;
        sc.Oracle_Cloud_Id__c = 'SC123456789';
        System.debug('@@ starting with: ' + pb.Id);
        sc.Pricebook2Id = pb.Id;
        sc.Price_Book__c = pb.Id;
        insert sc;
        
        ContractLineItem cli = new ContractLineItem();
        cli.ServiceContractId = sc.Id;
        cli.Oracle_Product_Id__c = prod.Oracle_Cloud_Id__c;
        cli.Quantity = 1;
        cli.AssetId = ast.Id;
        cli.Oracle_Contract_Header_Id__c = sc.Oracle_Cloud_Id__c;
        insert cli;
        
        Map<Id, PricebookEntry> entries = new Map<Id, PricebookEntry>([
            select Id from PricebookEntry 
            where Pricebook2Id = :pb.Id 
            limit 1000
        ]);
        blogic_ContractLineItem.activateEntries(entries.keySet());
        
        Test.stopTest();       
    }
}