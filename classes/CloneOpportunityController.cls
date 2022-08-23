public class CloneOpportunityController {
    
    public Opportunity opp {get; set;}
    public List<QuoteWrapper> wrappers {get; set;}
    public String pricebook2Id {get; set;}
    private Map<String, CurrencyType> currencyMap;
    public String addressId {get; set;}
    public List<SelectOption> addressOptions {get; set;}
    public String accountId {get; set;}
    public String selectedAccount {get; set;}

    public CloneOpportunityController(ApexPages.StandardController sc) {
        List<String> oppFields = CopyReviseQuoteController.getSObjectFields(Opportunity.SObjectType);
        String query = 'SELECT ' + String.join(oppFields, ',') + ' FROM Opportunity WHERE Id = \'' + sc.getId() + '\'';
        opp = (Opportunity) Database.query(query);
        setupAddressOptions();
        pricebook2Id = opp.Pricebook2Id;
        List<String> quoteFields = CopyReviseQuoteController.getSObjectFields(Quote.SObjectType);
        query = 'SELECT ' + String.join(quoteFields, ',') + ', Pricebook2.Name, Pricebook2.Pricebook_Region__c, RecordType.DeveloperName, Partner_Name__r.Base_Discount__c FROM Quote WHERE OpportunityId = \'' + opp.Id + '\'';
        List<Quote> quoteList = (List<Quote>) Database.query(query);
        wrappers = new List<QuoteWrapper>();
        if(quoteList.size() > 0) {
            for(Quote q : quoteList) {
                if(String.isBlank(pricebook2Id)){
                    pricebook2Id = q.Pricebook2Id;
                }
                wrappers.add(
                    new QuoteWrapper(q, false)
                );
            }
        }
        currencyMap = new Map<String, CurrencyType>();
        for(CurrencyType ctype : [SELECT IsoCode, ConversionRate, IsCorporate FROM CurrencyType]) {
            currencyMap.put(ctype.IsoCode, ctype);
        }
    }
    
    public void setupAddressOptions() {
        String accId = null, primaryAddressId = null;
        if(String.isBlank(accountId)) {
            accId = opp.AccountId;
        } else {
            accId = accountId;
        }
        List<Address__c> addresses = [
            SELECT Id, Name, Salesforce_Primary__c  
            FROM Address__c
            WHERE Account__c = :accId and Active__c = true
        ];
        addressOptions = new List<SelectOption>();
        addressOptions.add(new SelectOption('', '--Select--'));
        for(Address__c addr : addresses) {
            addressOptions.add(new SelectOption(addr.Id, addr.Name));
            if(addr.Salesforce_Primary__c) {
                primaryAddressId = addr.Id;
            }
        }
        
        if(opp.AccountId == accId) {
            // default to previous address or primary address for account
            if(String.isNotBlank(opp.Billing_Address__c)) addressId = opp.Billing_Address__c;
            else if(String.isNotBlank(opp.Shipping_Address__c)) addressId = opp.Shipping_Address__c;
            else addressId = primaryAddressId;
        }
    }
    
    public Boolean getErrorsPresent(){
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        if(msgs.size() > 0)
            return true;
        return false;
    }
    
    @RemoteAction
    public static List<Account> findAccounts(String name){
        String nameLike;
        if(String.isNotBlank(name)) {
            nameLike = '%' + name + '%';
        }
        String query = 'SELECT Id, Name FROM Account';
        if(String.isNotBlank(name)) {
            query += ' WHERE Name like :nameLike';
        }
        query += ' limit 100';
        return Database.query(query);
    }
    
    public List<SelectOption> getPricebookOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--', '-- Select --'));
        List<Pricebook2> pricebooks = [SELECT Id, Name FROM Pricebook2 ORDER BY Name];
        for(Pricebook2 pb : pricebooks) {
            options.add(new SelectOption(pb.Id, pb.Name));
        }
        return options;
    }
    
    public class QuoteWrapper {
        public Quote q {get; set;}
        public Boolean selected {get; set;}
        public Boolean resetQuote {get; set;}
        public Boolean syncQuote {get; set;}
        
        public QuoteWrapper(Quote q, Boolean selected) {
            this.q = q;
            this.selected = selected;
            this.resetQuote = false;
            this.syncQuote = false;
        }
    }
    
    public PageReference cloneOpportunityFull() {
        return cloneOpportunity(false);
    }
    
    public PageReference cloneOpportunityPartial() {
        return cloneOpportunity(true);
    }
    
    private PageReference cloneOpportunity(Boolean partialAllowed) {
        Savepoint sp = Database.setSavepoint();
        try {
            if(String.isBlank(pricebook2Id) || pricebook2Id == '--None--') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No Pricebook selected'));
                return null;
            }
            if(String.isNotBlank(accountId) && opp.AccountId != accountId && String.isBlank(addressId)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You\'ve opted to change the Account, please select Address from new account.'));
                return null;
            }
            String pricebookRegion = null;
            Map<String, Quote> clonedQuotes = new Map<String, Quote>();
            for(QuoteWrapper qw : wrappers) {
                if(qw.selected) {
                    pricebookRegion = qw.q.Pricebook2.Pricebook_Region__c;
                    Quote clonedQuote = qw.q.clone(false, true);
                    // reset quote data
                    if(qw.resetQuote){
                        //Refresh tier discount from partner
                        String rtName = qw.q.RecordType.DeveloperName;
                        if(rtName.contains('Indirect') && String.isNotBlank(qw.q.Partner_Name__c) && qw.q.Partner_Name__r.Base_Discount__c != null){
                            clonedQuote.Tier_Discount2__c = qw.q.Partner_Name__r.Base_Discount__c;
                        }
                        resetQuoteFields(clonedQuote);
                    }

                    clonedQuote.Parent_Quote__c = qw.q.Id;
                    if(clonedQuote.Status == 'Approved') clonedQuote.Status = 'Draft';
                    clonedQuotes.put(qw.q.Id, clonedQuote);
                }
            }
            Set<String> quoteIds = clonedQuotes.keySet();
            List<String> solutionFields = CopyReviseQuoteController.getSObjectFields(Quote_Solutions__c.SObjectType);
            String query = 'SELECT ' + String.join(solutionFields, ',') + ' FROM Quote_Solutions__c WHERE Quote__c IN :quoteIds';
            List<Quote_Solutions__c> solutions = Database.query(query);
            
            Set<String> solutionIds = new Set<String>();
            Map<Quote_Solutions__c, Quote_Solutions__c> clonedSolutions = new Map<Quote_Solutions__c, Quote_Solutions__c>();
            for(Quote_Solutions__c sol : solutions) {
                Quote_Solutions__c clonedSol = sol.clone(false, true);
                clonedSol.Coned_From__c = sol.Id;
                clonedSol.Parent_Solution__c = null;
                solutionIds.add(sol.Id);
                clonedSolutions.put(sol, clonedSol);
            }
            
            List<String> lineFields = CopyReviseQuoteController.getSObjectFields(QuoteLineItem.SObjectType);
            query = 'SELECT ' + String.join(lineFields, ',') + ', Product2.ProductCode, Product2.Part_No__c, Product2.Product_Cost__c FROM QuoteLineItem WHERE Solution__c IN :solutionIds';
            List<QuoteLineItem> lineItems = Database.query(query);
            
            Set<String> productIds = new Set<String>();
            Map<QuoteLineItem, QuoteLineItem> clonedLineItems = new Map<QuoteLineItem, QuoteLineItem>();
            for(QuoteLineItem lineItem : lineItems) {
                productIds.add(lineItem.Product2Id);
                QuoteLineItem clonedLineItem = lineItem.clone(false, true);
                clonedLineItem.Solution__c = null;
                for(QuoteWrapper qw : wrappers) {
                    if(lineItem.QuoteId == qw.q.Id){
                        clonedLineItem.Reset_Discounts__c = qw.resetQuote;
                        if(qw.resetQuote) {
                            clonedLineItem.Line_Discount__c = 0;
                            clonedLineItem.Discount = 0;
                            //all discounts are wiped, in case of indrect we just take tier discount
                            if(qw.q.Tier_Discount2__c != null) {
                                clonedLineItem.Discount = qw.q.Tier_Discount2__c;
                            }
                        }
                    }
                }
                clonedLineItems.put(lineItem, clonedLineItem);
            }
            
            if(clonedQuotes.size() > 0) {
                // clone opportunity
                Opportunity newOpp = opp.clone(false, true);
                newOpp.Name = newOpp.Name + ' [Reprice]';
                newOpp.SyncedQuoteId = null;
                newOpp.OneDrive_Folder_Id__c = null;
                newOpp.Cloned_From__c = opp.Id;
                Pricebook2 pb = null;
                if(pricebook2Id != null && pricebook2Id != '--None--') {
                    newOpp.Pricebook2Id = pricebook2Id;
                    pb = [SELECT Id, CurrencyIsoCode, Currency_Code__c FROM Pricebook2 WHERE Id =: pricebook2Id];
                }
                String currencyCode = String.isBlank(pb.Currency_Code__c) ? pb.CurrencyIsoCode : pb.Currency_Code__c;
                if(addressId != null && addressId != '--None--') {
                    newOpp.Billing_Address__c = addressId;
                    newOpp.Shipping_Address__c = addressId;
                }
                newOpp.Exclude_from_Forecast__c = false;
                newOpp.CurrencyIsoCode = currencyCode;
                // address change
                if(String.isNotBlank(accountId) && newOpp.AccountId != accountId) {
                    newOpp.AccountId = accountId;
                    newOpp.Billing_Address__c = addressId;
                    newOpp.Shipping_Address__c = addressId;
                }
                // set stage to Prospecting
                List<OpportunityStage> stages = [
                    select MasterLabel, DefaultProbability 
                    from OpportunityStage 
                    where IsActive = true and IsClosed = false 
                    order by DefaultProbability asc
                ];
                if(!stages.isEmpty()) {
                    newOpp.StageName = stages.get(0).MasterLabel;
                    newOpp.Probability = stages.get(0).DefaultProbability;
                }

                // check the number of quotes to be cloned
                if(clonedQuotes.size() == 1) {
                    for(String quoteId : clonedQuotes.keySet()) {
                        clonedQuotes.get(quoteId).Quote_Version__c = 1;
                        clonedQuotes.get(quoteId).CurrencyIsoCode = currencyCode;
                    }
                }
                insert newOpp;
                // clone Quotes
                for(Quote q : clonedQuotes.values()) {
                    q.OpportunityId = newOpp.Id;
                    q.Pricebook2Id = newOpp.Pricebook2Id;
                    q.Default_Price_Book__c = newOpp.Pricebook2Id;
                    q.Default_Solution__c = null;
                    q.CurrencyIsoCode = currencyCode;
                    if(q.Account_Lookup__c != newOpp.AccountId){
                        q.Account_Lookup__c = newOpp.AccountId;
                        q.Billing_Address__c = newOpp.Billing_Address__c;
                        q.Shipping_Address__c = newOpp.Shipping_Address__c;
                        Map<String, Object> accMap = (Map<String, Object>) JSON.deserializeUntyped(selectedAccount);
                        // find account name
                        String name = (String) accMap.get('text');
                        if(name != null) {
                            q.BillingName = name;
                            q.ShippingName = name;
                        }
                    }
                }
                CopyReviseQuoteController.ALLOW_DEFAULT_SOLUTION = false;
                insert clonedQuotes.values();
                // set synced quote id
                for(QuoteWrapper qw : wrappers){
                    if(qw.syncQuote == true){
                        newOpp.SyncedQuoteId = clonedQuotes.get(qw.q.Id).Id;
                        break;
                    }
                }
                update newOpp;

                CopyReviseQuoteController.ALLOW_DEFAULT_SOLUTION = true;
                for(String quoteId : quoteIds) {
                    for(Quote_Solutions__c sol : clonedSolutions.keySet()) {
                        if(sol.Quote__c == quoteId) {
                            System.assert(clonedQuotes.get(quoteId).Id != null);
                            clonedSolutions.get(sol).Quote__c = clonedQuotes.get(quoteId).Id;
                        }
                    }
                }
                insert clonedSolutions.values();
                for(Quote_Solutions__c sol : clonedSolutions.keySet()) {
                    Quote_Solutions__c clonedSol = clonedSolutions.get(sol);
                    clonedSol.Quote__c = clonedQuotes.get(sol.Quote__c).Id;
                    if(sol.Parent_Solution__c != null) {
                        for(Quote_Solutions__c parSol : clonedSolutions.keySet()) {
                            if(parSol.Id == sol.Parent_Solution__c) {
                                clonedSol.Parent_Solution__c = clonedSolutions.get(parSol).Id;
                                break;
                            }
                        }
                    }
                }
                update clonedSolutions.values();
                // clone QuoteLineItems
                List<PricebookEntry> pricebookEntries = [
                    SELECT Id, Pricebook2Id, Product2Id, Product2.NonDiscountable__c, Product2.ProductCode, Product2.Product_Cost__c,
                    IsActive, UnitPrice, CurrencyIsoCode, Product2.Quotable__c, Pricebook2.Pricebook_Region__c
                    FROM PricebookEntry 
                    WHERE Pricebook2Id = :pb.Id AND CurrencyIsoCode = :currencyCode AND Product2Id IN :productIds
                ];
                Map<String, PricebookEntry> productEntryMap = new Map<String, PricebookEntry>();
                for(PricebookEntry entry : pricebookEntries) {
                    if(!productEntryMap.containsKey(entry.Product2Id)) {
                        productEntryMap.put(entry.Product2Id, entry);
                    }
                }
                
                List<String> missingProducts = new List<String>();
                List<String> nonQuotable = new List<String>();
                Set<QuoteLineItem> qlisWithMissingProducts = new Set<QuoteLineItem>();
                for(Quote_Solutions__c sol : clonedSolutions.keySet()) {
                    for(Quote q : clonedQuotes.values()) {
                        Quote_Solutions__c clonedSol = clonedSolutions.get(sol);
                        if(q.Id == clonedSol.Quote__c && clonedSol.IsDefault__c == true) q.Default_Solution__c = clonedSol.Id;
                    }
                    for(QuoteLineItem lineItem : clonedLineItems.keySet()) {
                        if(lineItem.Solution__c == sol.Id) {
                            QuoteLineItem clonedItem = clonedLineItems.get(lineItem);
                            System.assert(clonedSolutions.get(sol).Id != null);
                            clonedItem.Solution__c = clonedSolutions.get(sol).Id;
                            clonedItem.QuoteId = clonedSolutions.get(sol).Quote__c;
                            clonedItem.Cloned_From__c = lineItem.Id;
                            String productId = clonedItem.Product2Id;                            
                            PricebookEntry entry = productEntryMap.get(productId);
                            if(entry == null || entry.IsActive == false) {
                                missingProducts.add(lineItem.Product2.ProductCode);
                                qlisWithMissingProducts.add(lineItem);
                                continue;
                            } else if (entry.Product2.Quotable__c == false) {
                                nonQuotable.add(lineItem.Product2.ProductCode);
                                qlisWithMissingProducts.add(lineItem);
                                continue;
                            } else {
                                clonedItem.PricebookEntryId = entry.Id;
                                if(entry.Product2.NonDiscountable__c == true) {
                                    clonedItem.Discount = null;
                                    clonedItem.Line_Discount__c = null;
                                }
                            }

                            Decimal fromRate = findConversionRate(pricebookRegion, currencyMap, opp.CurrencyIsoCode);
                            Decimal toRate = findConversionRate(entry.Pricebook2.Pricebook_Region__c, currencyMap, entry.CurrencyIsoCode);
                            // unit price calculation
                            if(lineItem.ListPrice == 0 || ((lineItem.Product2.Part_No__c.startsWithIgnoreCase('ps-') || lineItem.Product2.Part_No__c.startsWithIgnoreCase('ps -')) 
                                && lineItem.Product2.Part_No__c.endsWithIgnoreCase('-te'))) {
                                // do currency conversion
                                clonedItem.UnitPrice = convertAmount(lineItem.UnitPrice, fromRate, toRate);
                            } else {
                                clonedItem.UnitPrice = entry.UnitPrice;
                            }
                            // product cost calculation
                            if(opp.CurrencyIsoCode == 'USD') {
                                fromRate = currencyMap.get(opp.CurrencyIsoCode).ConversionRate;
                            }
                            if(entry.CurrencyIsoCode == 'USD') {
                                toRate = currencyMap.get(entry.CurrencyIsoCode).ConversionRate;
                            }
                            Decimal productCost = (lineItem.Product_Cost2__c == null ? 0 : lineItem.Product_Cost2__c) / fromRate;
                            productCost = productCost.setScale(2);
                            if(lineItem.Product2.Product_Cost__c == 0 || lineItem.Product2.Product_Cost__c == null || 
                               ((lineItem.Product2.Part_No__c.startsWithIgnoreCase('ps-') || lineItem.Product2.Part_No__c.startsWithIgnoreCase('ps -')) && 
                                lineItem.Product2.Part_No__c.endsWithIgnoreCase('-te'))) {
                                clonedItem.Product_Cost2__c = convertAmount(lineItem.Product_Cost2__c, fromRate, toRate);
                            } else {
                                if(productCost != lineItem.Product2.Product_Cost__c) {
                                    clonedItem.Product_Cost2__c = lineItem.Product2.Product_Cost__c * toRate;
                                    clonedItem.Product_Cost2__c = clonedItem.Product_Cost2__c.setScale(2);
                                } else {
                                    clonedItem.Product_Cost2__c = convertAmount(lineItem.Product_Cost2__c, fromRate, toRate);
                                }
                            }
                            if(pb != null) clonedItem.Cloned_From__c = lineItem.Id;
                        }
                    }
                }
                if(missingProducts.size() > 0 && !partialAllowed) {
                    String str = String.join(missingProducts, ',');
                    String message = 'Quote line items with following products will be discarded as: ';
                    message += '<ul>';
                    if(missingProducts.size() != 0) message += '<li>' + String.join(missingProducts, ', ') + ' are either missing or inactive</li>';
                    if(nonQuotable.size() != 0) message += '<li>' + String.join(nonQuotable, ', ') + ' are non-quotable</li>';
                    message += '</ul>Press Clone button again to ignore these products and create the quotes without them included.';
                    throw new CloneOpportunityException(message);
                } else {
                    for(QuoteLineItem qli : qlisWithMissingProducts) {
                        clonedLineItems.remove(qli);
                    }
                }
                // update Imagine quote numbers
                List<Quote> clonedQuoteList = clonedQuotes.values();
                Map<Id, Quote> quotesMap = new Map<Id, Quote>([
                    select Id, QuoteNumber, Quote_Version__c, Parent_Quote__r.QuoteNumber, 
                    Parent_Quote__r.Imagine_Quote_Number__c, 
                    Parent_Quote__r.Quote_Version__c, Parent_Quote__r.CreatedDate
                    from Quote 
                    where Id IN :clonedQuoteList order by Parent_Quote__r.Quote_Version__c asc
                ]);
                for(Quote clonedQuote : clonedQuotes.values()){
                    Quote queriedQuote = quotesMap.get(clonedQuote.Id);
                    if(queriedQuote != null){
                        resetQuoteVersions(quotesMap, queriedQuote);
                        clonedQuote.Quote_Version__c = queriedQuote.Quote_Version__c;
                        if(clonedQuote.Quote_Version__c == 1) {
                            clonedQuote.Imagine_Quote_Number__c = 'IC-' + queriedQuote.QuoteNumber + '-V1';
                        } else {
                            String quoteNumber = getQuoteNumber(queriedQuote.Parent_Quote__r.Imagine_Quote_Number__c);
                            if(quoteNumber.equals(String.valueOf(queriedQuote.Parent_Quote__r.QuoteNumber))) {
                                clonedQuote.Imagine_Quote_Number__c = 'IC-' + queriedQuote.QuoteNumber + '-V' + clonedQuote.Quote_Version__c;
                            } else {
                                quoteNumber = getQuoteNumber(clonedQuote.Imagine_Quote_Number__c);
                                for(Quote q : quotesMap.values()) {
                                    if(quoteNumber.equals(String.valueOf(q.Parent_Quote__r.QuoteNumber))) {
                                        quoteNumber = q.QuoteNumber;
                                    }
                                }
                                clonedQuote.Imagine_Quote_Number__c = 'IC-' + quoteNumber + '-V' + clonedQuote.Quote_Version__c;
                            }
                        }
                    }
                }
                update clonedQuotes.values();
                insert clonedLineItems.values();
                QuoteLineTriggerHelper.adjustRollupFields(clonedLineItems.values());
                update clonedLineItems.values();
                return new PageReference('/' + newOpp.Id);
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Quote selected for clone.'));
                return null;
            }
        } catch (CloneOpportunityException ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ex.getMessage()));
            Database.rollback(sp);
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
            return null;
        }
    }
    
    public static Decimal findConversionRate(String pricebookRegion, Map<String, CurrencyType> currencyMap, String isoCode) {
        Decimal temp = 1.00;
        if(isoCode == 'USD' && String.isNotBlank(pricebookRegion)) {
            Misc_Rates__c rate = Misc_Rates__c.getValues(pricebookRegion);
            if(rate != null) {
                temp = rate.Conversion_Rate__c;
            }
        } else {
            temp = currencyMap.get(isoCode) == null ? 1.00 : currencyMap.get(isoCode).ConversionRate;
        }
        return temp;
    }
    
    public static Decimal convertAmount(Decimal amount, Decimal fromRate, Decimal toRate) {
        if(amount == null) amount = 0;
        Decimal temp = (amount / fromRate) * toRate;
        return temp.setScale(2);
    }
    
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/' + opp.Id);
        return pageRef;
    }

    private String getQuoteNumber(String oldNumber) {
        String[] broken = oldNumber.split('-');
        if(broken.size() > 1) {
            return broken[1];
        }
        return null;

    }

    private void resetQuoteVersions(Map<Id, Quote> quotes, Quote queriedQuote) {
        String parentQuoteNumber = getQuoteNumber(queriedQuote.Parent_Quote__r.Imagine_Quote_Number__c);
        Map<Decimal, Quote> quoteRevisions = new Map<Decimal, Quote>();
        for(Id quoteId : quotes.keySet()) {
            Quote q = quotes.get(quoteId);
            if(q.Parent_Quote__r.Imagine_Quote_Number__c.indexOf(parentQuoteNumber) != -1) {
                quoteRevisions.put(q.Quote_Version__c, q);
            }
        }
        List<Decimal> revisions = new List<Decimal>(quoteRevisions.keySet());
        revisions.sort();
        Decimal revisionNumber = 1;
        for(Decimal revision : revisions) {
            quoteRevisions.get(revision).Quote_Version__c = revisionNumber;
            revisionNumber++;
        }
    }

    public static void resetQuoteFields(Quote newQuote) {
        newQuote.Sub_total__c = 0;
        newQuote.Total_Price__c = 0;
        newQuote.Hardware_Discount__c = 0;
        newQuote.Software_Discount__c = 0;
        newQuote.Service_Discount__c = 0;
        newQuote.Support_Discount__c = 0;
        newQuote.OEM_Hardware_Discount__c = 0;
        newQuote.OEM_Software_Discount__c = 0;
        newQuote.OEM_Professional_Services_Discount__c = 0;
        newQuote.OEM_Support_Discount__c = 0;
        newQuote.Additional_Discount__c = 0;
        
        newQuote.Routers_Max_Discount__c = 0;
        newQuote.Servers_Storage_Max_Discount__c    = 0;   
        newQuote.Ad_Agency_Max_Discount__c = 0;
        newQuote.Additional_DIscount__c = 0;
        newQuote.Ad_Sales_Max_Discount__c = 0;
        
        newQuote.Analytics_Max_Discount__c = 0;
        newQuote.Automation_Max_Discount__c    = 0;   
        newQuote.Command_Control_Max_Discount__c = 0;
        newQuote.DOH_Max_Discount__c = 0;
        newQuote.Editing_Graphics_Max_Discount__c = 0;
        
        newQuote.Hardware_Discount__c = 0;
        newQuote.Integrated_Playout_Max_Discount__c      = 0; 
        newQuote.MAM_Max_Discount__c = 0;
        newQuote.Master_Control_Max_Discount__c = 0;
        
        newQuote.Service_Discount__c = 0;
        newQuote.Program_Scheduling_Max_Discount__c = 0;
        newQuote.Service_Rate_Max_Discount__c = 0;
        newQuote.Signaling_Transcoding_Max_Discount__c = 0;
        newQuote.Software_Discount__c = 0;
        
        newQuote.Support_Max_Discount__c = 0;
        newQuote.Support_Discount__c = 0;
        newQuote.Test_Measurement_Max_Discount__c = 0;
        newQuote.Traffic_Billing_Max_Discount__c = 0;
        newQuote.Tier_Discount2__c  = 0;
    }

    public void setSelectedQuote(){
        String quoteId = ApexPages.currentPage().getParameters().get('quoteId');
        for(QuoteWrapper qw : wrappers){
            if(qw.q.Id == quoteId){
                qw.selected = !qw.selected;
                break;
            }
        }
    }

    public void setResetQuote(){
        String quoteId = ApexPages.currentPage().getParameters().get('quoteId');
        for(QuoteWrapper qw : wrappers){
            if(qw.q.Id == quoteId){
                qw.resetQuote = !qw.resetQuote;
                break;
            }
        }
    }

    public void setSyncQuote(){
        String quoteId = ApexPages.currentPage().getParameters().get('quoteId');
        for(QuoteWrapper qw : wrappers){
            if(qw.q.Id == quoteId && qw.syncQuote == false){
                qw.syncQuote = true;
            } else {
                qw.syncQuote = false;
            }
        }
    }

    public class CloneOpportunityException extends Exception {}
}