@isTest
public class CPQQuoteHelperTests {

    @isTest
    static void shouldAddOppToUpdate() {
        Map<Id, Opportunity> toUpdate = new Map<Id, Opportunity>();
        CPQQuoteHelper.addOppToUpdate(toUpdate, '006000000000000', 'a4f000000000000');
        System.assert(toUpdate.size() == 1);
    }
    
    @isTest
    static void shouldAddQuoteToUpdate() {
        Map<Id, SBQQ__Quote__c> toUpdate = new Map<Id, SBQQ__Quote__c>();
        CPQQuoteHelper.addQuoteToUpdate(toUpdate, 'a4f000000000000');
        System.assert(toUpdate.size() == 1);
    }
    
    @isTest
    static void shouldCalculateTotalDiscounts() {
        TestDataFactory.setupTestCPQQuote();
        SBQQ__Quote__c qt = [select Id, SBQQ__CustomerDiscount__c from SBQQ__Quote__c limit 1];
        List<Product2> products = [select Id from Product2 where ProductCode IN ('FRINKSD', 'FRINKSE')];
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        quoteLines.add(new SBQQ__QuoteLine__c(
            SBQQ__Quote__c=qt.Id,
            Import_Parent_Group_Name__c='Hardware',
            Import_Group_Name__c='Hardware I',
            SBQQ__Product__c=products.get(0).Id,
            SBQQ__Quantity__c=1
        ));
        quoteLines.add(new SBQQ__QuoteLine__c(
            SBQQ__Quote__c=qt.Id,
            Import_Group_Name__c='Software',
            SBQQ__Product__c=products.get(1).Id,
            SBQQ__Quantity__c=1
        ));
        insert quoteLines;
        Test.startTest();
        qt.Hardware_Discount__c = 10;
        update qt;
        qt.Hardware_Margin__c = 10;
        qt.OEM_Hardware_Margin__c = 10;
        qt.Software_Margin__c = 10;
        qt.OEM_Software_Margin__c = 10;
        qt.Professional_Services_Margin__c = 10;
        qt.OEM_Professional_Services_Margin__c = 10;
        qt.Managed_Services_Margin__c = 10;
        qt.OEM_Managed_Services_Margin__c = 10;
        qt.Support_Margin_Input__c = 10;
        qt.OEM_Support_Margin__c =10;
        Map<String, Decimal> typeTotalsMap = new Map<String, Decimal>{
            'Hardware_TotalLP' => 100,
			'Hardware_TotalPC' => 20,
			'OEMHardware_TotalLP' => 100,
			'OEMHardware_TotalPC' => 20,
			'Software_TotalLP' => 100,
			'Software_TotalPC' => 20,
			'OEMSoftware_TotalLP' => 100,
			'OEMSoftware_TotalPC' => 20,
			'PS_TotalLP' => 100,
			'PS_TotalPC' => 20,
			'OEMPS_TotalLP' => 100,
			'OEMPS_TotalPC' => 20,
			'MS_TotalLP' => 100,
			'MS_TotalPC' => 20,
			'OEMMS_TotalLP' => 100,
			'OEMMS_TotalPC' => 20,
			'Support_TotalLP' => 100,
			'Support_TotalPC' => 20,
			'OEMSupport_TotalLP' => 100,
			'OEMSupport_TotalPC' => 20
        };
		Set<String> fields = new Set<String>{
			'Hardware_Margin__c',
			'OEM_Hardware_Margin__c',
			'Software_Margin__c',
			'OEM_Software_Margin__c',
			'Professional_Services_Margin__c',
			'OEM_Professional_Services_Margin__c',
			'Managed_Services_Margin__c',
			'OEM_Managed_Services_Margin__c',
			'Support_Margin_Input__c',
			'OEM_Support_Margin__c'
		};
		CPQQuoteHelper.calculateTotalDiscounts(qt, fields, typeTotalsMap);
        Test.stopTest();
    }
    
    @isTest
    static void shouldCalculateTotalMargins() {
        TestDataFactory.setupTestCPQQuote();
        Test.startTest();
        SBQQ__Quote__c qt = [select Id, SBQQ__CustomerDiscount__c from SBQQ__Quote__c limit 1];
        qt.Hardware_Discount__c = 10;
        qt.OEM_Hardware_Discount__c = 10;
        qt.Software_Discount__c = 10;
        qt.OEM_Software_Discount__c = 10;
        qt.Professional_Services_Discount__c = 10;
        qt.OEM_Professional_Services_Discount__c = 10;
        qt.Managed_Services_Discount__c = 10;
        qt.OEM_Managed_Services_Discount__c = 10;
        qt.Support_Discount__c = 10;
        qt.OEM_Support_Discount__c =10;
        Map<String, Decimal> typeTotalsMap = new Map<String, Decimal>{
            'Hardware_TotalLP' => 100,
			'Hardware_TotalPC' => 20,
			'OEMHardware_TotalLP' => 100,
			'OEMHardware_TotalPC' => 20,
			'Software_TotalLP' => 100,
			'Software_TotalPC' => 20,
			'OEMSoftware_TotalLP' => 100,
			'OEMSoftware_TotalPC' => 20,
			'PS_TotalLP' => 100,
			'PS_TotalPC' => 20,
			'OEMPS_TotalLP' => 100,
			'OEMPS_TotalPC' => 20,
			'MS_TotalLP' => 100,
			'MS_TotalPC' => 20,
			'OEMMS_TotalLP' => 100,
			'OEMMS_TotalPC' => 20,
			'Support_TotalLP' => 100,
			'Support_TotalPC' => 20,
			'OEMSupport_TotalLP' => 100,
			'OEMSupport_TotalPC' => 20
        };
		Set<String> fields = new Set<String>{
			'Hardware_Discount__c',
			'OEM_Hardware_Discount__c',
			'Software_Discount__c',
			'OEM_Software_Discount__c',
			'Professional_Services_Discount__c',
			'OEM_Professional_Services_Discount__c',
			'Managed_Services_Discount__c',
			'OEM_Managed_Services_Discount__c',
			'Support_Discount__c',
			'OEM_Support_Discount__c'
		};
		CPQQuoteHelper.calculateTotalMargins(qt, fields, typeTotalsMap);
        Test.stopTest();
    }
}