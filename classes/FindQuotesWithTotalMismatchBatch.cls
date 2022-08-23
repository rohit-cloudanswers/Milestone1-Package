global class FindQuotesWithTotalMismatchBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    @TestVisible
    private Map<String, SolutionWrapper> mismatchingQuotes;
    
    public FindQuotesWithTotalMismatchBatch(){
        this.mismatchingQuotes = new Map<String, SolutionWrapper>();
    }

    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'select Id from Quote';
        if(Test.isRunningTest()) query += ' limit 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        List<QuoteLineItem> qlis = [
            select QuoteId, Quote.Name, Quote.OpportunityId, Quote.Opportunity.Name, Solution__c, Solution__r.Name,
            Solution__r.Total_Price__c, Solution__r.Total_List_Price__c, Solution__r.Total_Extended_Net_Price__c, 
            Solution__r.Total_Extended_List_Price__c, TotalPrice, Subtotal, Total_Extended_Net_Price__c, 
            Total_Extended_List_Price__c 
            from QuoteLineItem 
            where QuoteId IN :scope
        ];
        Map<String, SolutionWrapper> quoteSolutionMap = new Map<String, SolutionWrapper>();
        for(QuoteLineItem qli : qlis){
            String key = qli.QuoteId + '-' + qli.Solution__c;
            SolutionWrapper solWrapper = null;
            if(!quoteSolutionMap.containsKey(key)){
                solWrapper = new SolutionWrapper();
                solWrapper.quote = qli.Quote;
                solWrapper.quoteSolution = qli.Solution__r;
                quoteSolutionMap.put(key, solWrapper);
            } else {
                solWrapper = quoteSolutionMap.get(key);
            }
            // sum the values
            solWrapper.sumTotalPrice += qli.TotalPrice;
            solWrapper.sumTotalListPrice += qli.Subtotal;
            solWrapper.sumTotalExtNetPrice += qli.Total_Extended_Net_Price__c;
            solWrapper.sumTotalExtListPrice += qli.Total_Extended_List_Price__c;
        }
        for(String key : quoteSolutionMap.keySet()){
            SolutionWrapper solWrapper = quoteSolutionMap.get(key);
            if(solWrapper.quoteSolution.Total_List_Price__c == null) continue;
            if(Math.abs(Math.abs(solWrapper.sumTotalListPrice.intValue()) - Math.abs(solWrapper.quoteSolution.Total_List_Price__c.intValue())) > 1){
                mismatchingQuotes.put(key, solWrapper);
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        if(mismatchingQuotes.size() > 0) sendEmail();
    }
    
    @TestVisible
    private void sendEmail(){
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        String htmlBody = '<div>Hi there,<br /><br /><h4>Following Quote Solutions have mismatching totals:</h4><table>';
        htmlBody += '<thead><tr><th>Opportunity</th><th>Quote</th><th>Quote Solution</th><th>Total List Price</th><th>Sum of Subtotal(QLIs)</th></tr></thead><tbody>';
        for(String key : mismatchingQuotes.keySet()) {
            SolutionWrapper solWrapper = mismatchingQuotes.get(key);
            htmlBody += '<tr>';
            htmlBody += '<td><a href="'+baseUrl+'/'+solWrapper.quote.Opportunity.Id+'">'+ solWrapper.quote.Opportunity.Name +'</a></td>';
            htmlBody += '<td><a href="'+baseUrl+'/'+solWrapper.quote.Id+'">'+ solWrapper.quote.Name +'</a></td>';
            htmlBody += '<td><a href="'+baseUrl+'/'+solWrapper.quoteSolution.Id+'">'+ solWrapper.quoteSolution.Name +'</a></td>';
            htmlBody += '<td>'+ solWrapper.quoteSolution.Total_List_Price__c +'</td>';
            htmlBody += '<td>'+ solWrapper.sumTotalListPrice +'</td>';
            htmlBody += '</tr>';
        }
        htmlBody += '</tbody></table><br />Regards</div>';
        
        List<String> toAddresses = new List<String>();
        toAddresses.add('jagmohan@cloudanswers.com');

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(toAddresses);
        
        email.setSubject('Quote Solutions with Total Mismatch');
        email.setHtmlBody(htmlBody);
        emails.add(email);
        if(!emails.isEmpty() && !Test.isRunningTest()) Messaging.sendEmail(emails);
    }
    
    public static void run(){
        FindQuotesWithTotalMismatchBatch batch = new FindQuotesWithTotalMismatchBatch();
        Database.executeBatch(batch, Test.isRunningTest() ? 1 : 200);
    }
    
    public class SolutionWrapper {
        public Quote quote;
        public Quote_Solutions__c quoteSolution;
        public Decimal sumTotalPrice;
        public Decimal sumTotalListPrice;
        public Decimal sumTotalExtNetPrice;
        public Decimal sumTotalExtListPrice;
        
        public SolutionWrapper(){
            this.sumTotalPrice = 0;
            this.sumTotalListPrice = 0;
            this.sumTotalExtNetPrice = 0;
            this.sumTotalExtListPrice = 0;
        }
    }
}