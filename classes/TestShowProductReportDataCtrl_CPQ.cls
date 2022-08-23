@isTest(seeAllData='true')
public class TestShowProductReportDataCtrl_CPQ{
    @isTest
    public static void testReportData_CPQ(){
        SBQQ__Quote__c q = [SELECT id, Name FROM SBQQ__Quote__c WHERE SBQQ__NetAmount__c > 0 LIMIT 1];
        Test.startTest();
        ShowProductReportDataCtrl_CPQ showProductReportCtrl_CPQ = new ShowProductReportDataCtrl_CPQ();
        showProductReportCtrl_CPQ.quoteid = q.Name;
        showProductReportCtrl_CPQ.getBusinessUnitData();
        Test.stopTest();
    }
}