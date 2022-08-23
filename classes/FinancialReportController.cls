public with sharing class FinancialReportController {
    
    @TestVisible
    private static final String REPORT_ID = System.Label.Financial_Report_Id;

    @AuraEnabled
    public static String getReportData(String recordId, String isoCode){
        if(String.isBlank(recordId)) throw new InvalidInputException('Invalid Quote ID, please check');
        if(String.isBlank(isoCode)) isoCode = 'USD';
        String result = null;
        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(REPORT_ID);
        Reports.ReportMetadata data = describe.getReportMetadata();
        List<Reports.ReportFilter> reportFilters = data.getReportFilters();
        String quoteNumber = [select QuoteNumber from Quote where Id =: recordId].QuoteNumber;
        for(Reports.ReportFilter filter : reportFilters){
            if(filter.getColumn() == 'QUOTE_NUMBER'){
                filter.setValue(quoteNumber);
            }
        }
        data.setReportFilters(reportFilters);
        data.setCurrencyCode(isoCode);
        String jsonStr = Test.isRunningTest() ? '{}' : JSON.serialize(Reports.ReportManager.runReport(REPORT_ID, data));
        return jsonStr;
    }
    
    @AuraEnabled
    public static String getCurrencies(){
        String result = null;
        List<CurrencyWrapper> currencies = new List<CurrencyWrapper>();
        for(CurrencyType ct : [select IsoCode, IsCorporate from CurrencyType]){
            currencies.add(new CurrencyWrapper(ct.IsoCode, ct.IsoCode, ct.IsCorporate));
        }
        Map<String, Object> resultMap = new Map<String, Object>();
        resultMap.put('currencies', currencies);
        resultMap.put('user_default', UserInfo.getDefaultCurrency());
        result = JSON.serialize(resultMap);
        return result;
    }
    
    public class CurrencyWrapper {
        public String label;
        public String value;
        public Boolean isCorporate;
        
        public CurrencyWrapper(String label, String value, Boolean isCorporate){
            this.label = label;
            this.value = value;
            this.isCorporate = isCorporate;
		}
    }
    
    public class InvalidInputException extends Exception {}
}