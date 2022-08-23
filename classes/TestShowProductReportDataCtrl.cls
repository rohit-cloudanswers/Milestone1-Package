@isTest(seeAllData='true')
public class TestShowProductReportDataCtrl{
    @isTest
    public static void testReportData(){
        Quote q = [SELECT id, QuoteNumber FROM quote LIMIT 1];
        Test.startTest();
        ShowProductReportDataCtrl showProductReportCtrl = new ShowProductReportDataCtrl();
        showProductReportCtrl.quoteid = q.QuoteNumber;
        showProductReportCtrl.getBusinessUnitData();
        Test.stopTest();
    }
}