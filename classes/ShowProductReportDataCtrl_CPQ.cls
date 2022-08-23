public without sharing class ShowProductReportDataCtrl_CPQ {
    public String quoteId {get;set;}
	public String exportCurrency {get; set;}    
    
    public ReturnData getBusinessUnitData(){
        ReturnData rtd = new ReturnData();
        try {
            rtd.data = new Map<String,List<String>>();
            rtd.columnOrder = new List<String>();
            String currencyCode = 'USD';
            Map<String,List<String>> businessUnitData = new Map<String,List<String>>();
            List<String> grandTotalData = new List<String>();
            // Get the report ID
            List <Report> reportList = [SELECT Id,DeveloperName FROM Report where DeveloperName = 'CPQ_Quote_Business_Line_Final'];
            if( !String.isBlank(quoteId)){
                if (String.isBlank(exportCurrency)) {
                    List<SBQQ__Quote__c> q = [SELECT CurrencyIsoCode FROM SBQQ__Quote__c where Name=:quoteId LIMIT 1];
                    if( !q.isEmpty() && (q[0].CurrencyIsoCode != null)){
                        currencyCode =  q[0].CurrencyIsoCode;
                    }
                } else {
                    currencyCode = exportCurrency;
                }
            }
            System.assert(!reportList.isEmpty(), 'report not found');
            if(!reportList.isEmpty()){
                String reportId = (String)reportList.get(0).get('Id');
                // Get the report metadata
                Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
                Reports.ReportMetadata reportMd = describe.getReportMetadata();
                List<Reports.GroupingInfo> groupingDownList = reportMd.getGroupingsDown();
                //get a string array of the field names
                List<String> fieldNames = reportMd.getDetailColumns();                      
                
                reportMd.setCurrencyCode(currencyCode);
                List<Reports.ReportFilter> filters =reportMd.getReportFilters();
                // Override filter and run report
                if( !filters.isEmpty()){
                    Reports.ReportFilter filter = filters[0];
                    filter.setValue(quoteId);
                    
                    Reports.ReportResults results = Reports.ReportManager.runReport(reportId, reportMd);
                    rtd.allJSON = JSON.serialize(results);
                    Reports.ReportMetadata repMeta = results.getReportMetadata();
                    
                    rtd.columns = new Map<String, List<DataWrapper>>();
                    for(Reports.GroupingValue gv: results.getGroupingsAcross().getGroupings()){
                        rtd.columnOrder.add(gv.getLabel());
                        if(gv.getGroupings().isEmpty()){
                            rtd.columns.put(gv.getLabel(), new List<DataWrapper>{
                                new DataWrapper(gv.getKey(), gv.getLabel())
                            });
                        } else {
                            for(Reports.GroupingValue gvLevel1 : gv.getGroupings()){
                                List<DataWrapper> lstDW = new List<DataWrapper>();
                                if(rtd.columns.containsKey(gv.getLabel())){
                                    lstDW = rtd.columns.get(gv.getLabel());
                                }
                                lstDW.add(new DataWrapper(gvLevel1.getKey(), gvLevel1.getLabel()));
                                rtd.columns.put(gv.getLabel(), lstDW );
                            }
                        }
                    }
                    rtd.columnOrder.add('');
                    rtd.columns.put('', new List<DataWrapper>{ new DataWrapper('T','Grand Total')});
                    
                    Map<String, Reports.ReportFact> fm = results.getFactMap();
                    for(String rfkey : fm.keyset()){
                        List<String> dlist = new List<String>();
                        for(Reports.SummaryValue sv : fm.get(rfkey).getAggregates()){
                            dlist.add(addCurrencySymbolToAmount(sv.getLabel()));
                        }
                        rtd.data.put(rfkey, dlist);
                    }
                    
                    //get the extended metadata
                    Reports.ReportExtendedMetadata reportExtendedMetadata = results.getReportExtendedMetadata();
                    Reports.Dimension dim = results.getGroupingsDown();
                    if(dim != null){
                        rtd.rows = new List<DataWrapper>();
                        for(Reports.GroupingValue gv : dim.getGroupings()) {
                            String keyValue = gv.getLabel();
                            rtd.rows.add(new DataWrapper(gv.getKey(), gv.getLabel()));
                            List<String> data = new List<String>();
                            // Construct a fact map key, using the grouping key value
                            String factMapKey = gv.getKey() + '!T';
                            // Get the fact map from the report results
                            Reports.ReportFactWithSummaries factDetails =(Reports.ReportFactWithSummaries)results.getFactMap().get(factMapKey);
                            if(factDetails != null){
                                List<Reports.SummaryValue> sumValues = factDetails.getAggregates();
                                if(!sumValues.isEmpty()){
                                    for(Reports.SummaryValue sumValueData: factDetails.getAggregates()){
                                        data.add(addCurrencySymbolToAmount(sumValueData.getLabel()));
                                    }
                                    businessUnitData.put(keyValue, data);
                                }
                            }
                        }
                        rtd.rows.add(new DataWrapper('T', 'Grand Total'));
                    }
                    
                    List<DataWrapper> aggregateInfo = new List<DataWrapper>();
                    Map<String, Reports.AggregateColumn> aggregateColumns = reportExtendedMetadata.getAggregateColumnInfo();
                    for(String columnKey : reportMd.getAggregates()) {
                        Reports.AggregateColumn agrColumn = aggregateColumns.get(columnKey);
                        aggregateInfo.add(new DataWrapper(columnKey, agrColumn.getLabel()));
                    }
                    rtd.aggregateInfo = aggregateInfo;
                }
            }
            rtd.hasError = false;
        } catch (Exception ex) {
            rtd.hasError = true;
            rtd.errorMessage = ex.getMessage();
        }
        return rtd;
    }
    
    public String addCurrencySymbolToAmount(String amount){
        return amount.replace('USD ','$').replace('CAD ','$').replace('AUD ','$').replace('GBP ','£').replace('EUR ','€').replace('INR ','₹');
    }
    
    public class DataWrapper{
        public String key {get;set;}
        public String label {get;set;}
        public DataWrapper(String key, String label){
            this.key = key;
            this.label = label;
        }
    }
    
    public class ReturnData {
        public Boolean hasError {get; set;}
        public String errorMessage {get; set;}
        public List<String> columnOrder {get;set;}
        public Map<String, List<DataWrapper>> columns {get;set;}
        public List<DataWrapper> rows {get;set;}
        public Map<String,List<String>> data {get;set;}
        public String allJSON {get; set;}
        public List<DataWrapper> aggregateInfo {get; set;}
    }
    
}