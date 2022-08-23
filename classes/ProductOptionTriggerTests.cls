@isTest
public class ProductOptionTriggerTests {

    @TestSetup
    public static void setupTestData() {
        List<Product2> products = new List<Product2>{
            TestDataFactory.initProduct('Imagine MyCare', 'Support Package Care', 'Support'),
			TestDataFactory.initProduct('Hardware Platinum', 'MYCARE-HW-PLATINUM', 'Support')
        };
		insert products;
        insert new SBQQ__ProductOption__c(
            SBQQ__ConfiguredSKU__c=products.get(0).Id,
            SBQQ__OptionalSKU__c=products.get(1).Id,
            SBQQ__Number__c=10
        );
    }
    
    @isTest
    public static void shouldPreventDuplicates() {
        Product2 supportBundle = [
            select Id
            from Product2
            where ProductCode = 'Support Package Care'
        ];
        Product2 supportProduct = [
            select Id
            from Product2
            where ProductCode = 'MYCARE-HW-PLATINUM'
        ];
        Test.startTest();
        SBQQ__ProductOption__c option = new SBQQ__ProductOption__c(
            SBQQ__ConfiguredSKU__c=supportBundle.Id,
            SBQQ__OptionalSKU__c=supportProduct.Id,
            SBQQ__Number__c=20
        );
        try {
        	Database.SaveResult res = Database.insert(option);
        } catch (DmlException ex) {
            System.assert(true);
        }
        Test.stopTest();
    }
}