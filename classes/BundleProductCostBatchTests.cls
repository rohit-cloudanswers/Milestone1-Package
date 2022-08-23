@IsTest(SeeAllData=false)
public class BundleProductCostBatchTests {

    @TestSetup
    static void setupTestData() {
        Product2 bundleParent = TestDataFactory.initProduct('Bundle Parent', 'FRINKSC', 'Hardware');
        insert bundleParent;
        List<Product2> products = new List<Product2>{
            TestDataFactory.initProduct('Test product 1', 'FRINKSD', 'Hardware'),
            TestDataFactory.initProduct('Test product 2', 'FRINKSE', 'Hardware'),
            TestDataFactory.initProduct('Test product 3', 'FRINKSF', 'Hardware'),
            TestDataFactory.initProduct('Test product 4', 'FRINKSG', 'Hardware')
        };
		// add product cost
		for (Integer i=1; i <= products.size(); i++) {
			Product2 prod = products.get(i - 1);
            prod.Product_Cost__c = i * 100;
            prod.SBQQ__PriceEditable__c = true;
        }
        insert products;
        
        List<SBQQ__ProductOption__c> bundleOptions = new List<SBQQ__ProductOption__c>();
        for (Integer i=0; i < products.size(); i++) {
            Product2 prod = products.get(i);
            SBQQ__ProductOption__c option = new SBQQ__ProductOption__c(
                SBQQ__ConfiguredSKU__c = bundleParent.Id,
                SBQQ__OptionalSKU__c = prod.Id,
                SBQQ__Number__c = (i + 1),
                SBQQ__Quantity__c = 2,
                SBQQ__Required__c = true,
                SBQQ__Type__c = 'Component'
            );
            bundleOptions.add(option);
        }
        insert bundleOptions;
    }
    
    @isTest
    static void shouldUpdateBundleProductCost() {
		Product2 bundleParent = [
            select Id, Product_Cost__c from Product2
            where Name = 'Bundle Parent'
        ];
        System.assert(bundleParent.Product_Cost__c == null);
        Test.startTest();
        BundleProductCostBatch.run();
        Test.stopTest();
        bundleParent = [
            select Id, Product_Cost__c from Product2
            where Name = 'Bundle Parent'
        ];
        System.assert(bundleParent.Product_Cost__c == 2000);
    }
}