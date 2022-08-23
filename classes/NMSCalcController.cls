public with sharing class NMSCalcController {
    
    public String quoteId {get; set;}
    public Boolean processing {get; set;}
    public static final String NMS_SOLUTION_SET = 'NMS Professional Services';
    
    public NMSCalcController(){
        quoteId = ApexPages.currentPage().getParameters().get('id');
        processing = true;
    }
    
    public PageReference calculateNMSServ(){
        PageReference pageRef = null;
        Savepoint sp = Database.setSavepoint();
        try {
            if(String.isNotBlank(quoteId)){
                // get NMS solution set
                Quote_Solutions__c nmsSolutionSet = getNMSSolutionSet(quoteId);
                Quote q = [select Id, Pricebook2Id from Quote where Id = :quoteId];
                List<QuoteLineItem> qliList = [
                    select Id, Quantity, Subtotal, Product2Id, Product2.NMS_Proserv__c, 
                    Product2.NMS_Proserv__r.NMS_Proserv_Rate__c, Product2.ProductCode, Solution_Optional__c
                    from QuoteLineItem 
                    where QuoteId =: quoteId and Solution__c != :nmsSolutionSet.Id and Product_Type__c != 'Support' 
                    order by Solution__r.Parent_Order__c asc, Solution__r.Order__c asc
                ];

                Map<String, List<QuoteLineItem>> nmsToQliMap = new Map<String, List<QuoteLineItem>>();
                for(QuoteLineItem qli : qliList){
                    if(qli.Product2.NMS_Proserv__c != null && Product2.NMS_Proserv__r.NMS_Proserv_Rate__c != null){
                        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
                        if(!nmsToQliMap.containsKey(qli.Product2.NMS_Proserv__c)) {
                            nmsToQliMap.put(qli.Product2.NMS_Proserv__c, qlis);
                        } else {
                            qlis = nmsToQliMap.get(qli.Product2.NMS_Proserv__c);
                        }
                        qlis.add(qli);
                    }
                }

                if(nmsToQliMap.size() != 0){
                    // fetch existing NMS quote line items
                    List<QuoteLineItem> nmsQlis = [
                        select Id, UnitPrice, Quantity, Line_Discount__c, 
                        QuoteId, Solution__c, Product2Id, PricebookEntryId 
                        from QuoteLineItem
                        where QuoteId = :quoteId and Solution__c = :nmsSolutionSet.Id and Product2Id in :nmsToQliMap.keySet()
                    ];
                    List<PricebookEntry> entries = [
                        select Id, Product2Id, CurrencyIsoCode, UnitPrice, Pricebook2Id   
                        from PricebookEntry 
                        where Pricebook2Id = :q.Pricebook2Id 
                        and Product2.Quotable__c = true 
                        and Product2Id in :nmsToQliMap.keySet()
                    ];
                    Map<String, QuoteLineItem> nmsQliMap = new Map<String, QuoteLineItem>();
                    for(QuoteLineItem qli : nmsQlis) {
                        nmsQliMap.put(qli.Product2Id, qli);
                    }

                    Integer quoteSolutionOrder = 1;
                    List<QuoteLineItem> toUpsert = new List<QuoteLineItem>();
                    for(String nmsProdId : nmsToQliMap.keySet()){
                        QuoteLineItem nmsQli = nmsQliMap.get(nmsProdId);
                        if(nmsQli == null){
                            nmsQli = new QuoteLineItem(
                                UnitPrice = 0,
                                Quantity = 1,
                                Line_Discount__c = 0,
                                QuoteId = quoteId,
                                Product2Id = nmsProdId,
                                Solution__c = nmsSolutionSet.Id,
                                QuoteSolutionOrder__c = quoteSolutionOrder
                            );
                        } else {
                            nmsQli.Quantity = 1;
                            nmsQli.UnitPrice = 0;
                            nmsQli.QuoteSolutionOrder__c = quoteSolutionOrder;
                        }
                        quoteSolutionOrder++;

                        List<QuoteLineItem> qlis = nmsToQliMap.get(nmsProdId);
                        for(QuoteLineItem qli : qlis){
                            Decimal serviceRate = qli.Product2.NMS_Proserv__r.NMS_Proserv_Rate__c;
                            Decimal tempValue = qli.Subtotal * (serviceRate / 100);
                            nmsQli.UnitPrice += tempValue.setScale(2);
                        }
                        toUpsert.add(nmsQli);
                    }
                    // tie pricebook entries
                    List<String> noEntries = new List<String>();
                    for(QuoteLineItem nmsQli : toUpsert) {
                        Boolean found = false;
                        for(PricebookEntry entry : entries) {
                            if(nmsQli.Product2Id == entry.Product2Id) {
                                if(nmsQli.PricebookEntryId == null)
                                    nmsQli.PricebookEntryId = entry.Id;
                                found = true;
                                break;
                            }
                        }
                        if(found == false) {
                            noEntries.add(nmsQli.Product2Id);
                        }
                    }
                    if(noEntries.size() == 0) {
                        if(toUpsert.size() != 0){
                            upsert toUpsert;
                        } else {
                            cleanupSolutionSet(quoteId, nmsSolutionSet.Id);
                        }
                    } else {
                        cleanupSolutionSet(quoteId, nmsSolutionSet.Id);
                        processing = false;
                        throw new NMSProServException('No Pricebook Entry found for following NMS Service products: ' + String.join(noEntries, ', '));
                    }
                } else {
                    cleanupSolutionSet(quoteId, nmsSolutionSet.Id);
                }
                pageRef = new PageReference('/' + quoteId);
            } else {
                processing = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a valid Quote.'));
            }
        } catch(Exception ex){
            processing = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() + ' at ' + ex.getLineNumber()));
            System.debug('@@ ' + ex.getMessage() + ' at ' + ex.getLineNumber());
            Database.rollback(sp);
        }
        return pageRef;
    }
    
    public Quote_Solutions__c getNMSSolutionSet(String quoteId){
        List<Quote_Solutions__c> solutionSets = [
            SELECT Id, Name
            FROM Quote_Solutions__c 
            WHERE Name = :NMS_SOLUTION_SET AND Quote__c =: quoteId
        ];
        if(solutionSets.size() != 0) {
            return solutionSets.get(0);
        } else {
            // set the order to be the last top level solution set when generated
            Decimal order = 1;
            for (Quote_Solutions__c qs : [select Order__c from Quote_Solutions__c where Quote__c = :quoteId and Parent_Solution__c = null order by Order__c desc limit 1]) {
                if (qs.Order__c != null && qs.Order__c > order) order = qs.Order__c;
            }
            order += 1; // increment past the biggest one

            Quote_Solutions__c nmsSolutionSet = new Quote_Solutions__c(
                Name = NMS_SOLUTION_SET,
                Quote__c = quoteId,
                Order__c = order
            );
            insert nmsSolutionSet;
            return nmsSolutionSet;
        }
    }

    private void cleanupSolutionSet(String quoetId, String solutionSetId){
        // delete support items
        List<QuoteLineItem> itemsToDelete = [
            select Id 
            from QuoteLineItem
            where Solution__c =: solutionSetId 
                or (QuoteId =: quoteId and Solution__c = null)
        ];
        delete itemsToDelete;
        // delete solution set
        delete new Quote_Solutions__c(Id=solutionSetId);
    }

    public PageReference cancel() {
        return new PageReference('/' + quoteId);
    }

    public class NMSProServException extends Exception {}
}