@isTest
public class CPQGroupHierarchyCtrlTests {

    @TestSetup
    static void setupTestData() {
        TestDataFactory.setupTestCPQQuote();
        insertQuoteLines();
    }
    
    static SBQQ__Quote__c insertQuoteLines() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
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
        return qt;
    }
    
    @isTest
    static void shouldGetGroupHierarchy() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        Test.startTest();
        Map<String, Object> allData = CPQGroupHierarchyCtrl.getGroupHierarchy(qt.Id);
        System.assert(!allData.isEmpty());
        List<Map<String, Object>> data = CPQGroupHierarchyCtrl.getQuoteLineGroups(qt.Id);
        System.assert(!data.isEmpty());
        Test.stopTest();
    }
    
    @isTest
    static void shouldHandleMove() {
        CPQQuoteLineGroupHelper.hasRun = true;
        CPQQuoteLineHelper.hasRun = true;
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        List<SBQQ__QuoteLineGroup__c> lineGroups = [
            select Id, Name from SBQQ__QuoteLineGroup__c 
            where Name IN ('Hardware', 'Software') and SBQQ__Quote__c = :qt.Id
        ];
        SBQQ__QuoteLineGroup__c softwareGroup, hardwareGroup;
        for (SBQQ__QuoteLineGroup__c lineGroup : lineGroups) {
            if (lineGroup.Name == 'Software') {
                softwareGroup = lineGroup;
            } else {
                hardwareGroup = lineGroup;
            }
        }
        Test.startTest();
        Map<String, Object> result = CPQGroupHierarchyCtrl.validateMove(hardwareGroup.Id, new List<String>{softwareGroup.Id}, new List<String>());
        System.assert((Boolean) result.get('status'));
        result = CPQGroupHierarchyCtrl.handleMove(hardwareGroup.Id, new List<String>{softwareGroup.Id}, new List<String>());
        System.assert((Boolean) result.get('status'));
        Test.stopTest();
    }
    
    @isTest
    static void shouldHandleCopy() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        List<SBQQ__QuoteLineGroup__c> lineGroups = [
            select Id, Name, (select Id from SBQQ__LineItems__r) from SBQQ__QuoteLineGroup__c 
            where Name IN ('Hardware', 'Software') and SBQQ__Quote__c = :qt.Id
        ];
        SBQQ__QuoteLineGroup__c softwareGroup, hardwareGroup;
        for (SBQQ__QuoteLineGroup__c lineGroup : lineGroups) {
            if (lineGroup.Name == 'Software') {
                softwareGroup = lineGroup;
            } else {
                hardwareGroup = lineGroup;
            }
        }
        Test.startTest();
        Map<String, Object> result = CPQGroupHierarchyCtrl.handleCopy(hardwareGroup.Id, new List<String>(), new List<String>{softwareGroup.SBQQ__LineItems__r.get(0).Id});
        System.assert((Boolean) result.get('status'));
        Test.stopTest();
    }
    
    @isTest
    static void shouldReorderLineGroups() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        Test.startTest();
        CPQGroupHierarchyCtrl.reorderLineGroups(qt.Id);
        Test.stopTest();
    }
    
    @isTest
    static void shouldChangeOptional() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        SBQQ__QuoteLineGroup__c lineGroup = [select Id from SBQQ__QuoteLineGroup__c where SBQQ__Quote__c = :qt.Id and Name = 'Hardware I'];
        Test.startTest();
        CPQGroupHierarchyCtrl.reorderLineGroups(qt.Id);
        Map<String, Object> result = CPQGroupHierarchyCtrl.changeOptional(qt.Id, lineGroup.Id, true);
        System.assert((Boolean) result.get('status'));
        Test.stopTest();
    }
    
    @isTest
    static void shouldDeleteAll() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        Test.startTest();
        Map<String, Object> res = CPQGroupHierarchyCtrl.deleteAll(qt.Id);
        Boolean status = (Boolean) res.get('status');
        System.assert(status);
        Test.stopTest();
    }
    
    @isTest
    static void shouldCheckCalculateStatus() {
        Test.startTest();
        CPQGroupHierarchyCtrl.isRecalculating();
        Test.stopTest();
    }
    
    @isTest
    static void shouldMassEditQuantity() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        Map<Id, SBQQ__QuoteLine__c> quoteLinesMap = new Map<Id, SBQQ__QuoteLine__c>([select Id from SBQQ__QuoteLine__c where SBQQ__Quote__c = :qt.Id]);
        Test.startTest();
        Map<String, Object> result = CPQGroupHierarchyCtrl.processMassEdit(new List<Id>(quoteLinesMap.keySet()), 'mass_edit_quantity', 2);
        Test.stopTest();
    }
    
    @isTest
    static void shouldMassEditDiscount() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        Map<Id, SBQQ__QuoteLine__c> quoteLinesMap = new Map<Id, SBQQ__QuoteLine__c>([select Id from SBQQ__QuoteLine__c where SBQQ__Quote__c = :qt.Id]);
        Test.startTest();
        Map<String, Object> result = CPQGroupHierarchyCtrl.processMassEdit(new List<Id>(quoteLinesMap.keySet()), 'mass_edit_discount', 0.02);
        Test.stopTest();
    }
    
    @isTest
    static void shouldCalculateDiscountFromMargin() {
        Test.startTest();
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        qt.Hardware_Margin__c = 30;
        update qt;
        Test.stopTest();
    }
    
    @isTest
    static void shouldCalculateMarginFromDiscount() {
        Test.startTest();
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        qt.Hardware_Discount__c = 10;
        update qt;
        Test.stopTest();
    }
    
    @isTest
    static void shouldEitherUpdateMarginOrDiscount() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        qt.Hardware_Discount__c = 10;
        qt.Hardware_Margin__c = 10;
        Test.startTest();
        try {
        	Database.SaveResult sr = Database.update(qt);
        } catch (Exception ex) {}
        Test.stopTest();
    }
    
    @isTest
    static void shouldMassUpdateMargin() {
        SBQQ__Quote__c qt = [select Id from SBQQ__Quote__c limit 1];
        List<SBQQ__QuoteLine__c> quoteLines = [select Id from SBQQ__QuoteLine__c where SBQQ__Quote__c = :qt.Id];
        List<Id> lineIds = new List<Id>();
        for (SBQQ__QuoteLine__c quoteLine : quoteLines) {
            lineIds.add(quoteLine.Id);
        }
        Test.startTest();
        try {
            Map<String, Object> res = CPQGroupHierarchyCtrl.massUpdateMargin(lineIds, 0.5);
        } catch (Exception ex) {}
        Test.stopTest();
    }
}