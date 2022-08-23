public without sharing class CopyReviseQuoteController {
    
    public static Boolean ALLOW_DEFAULT_SOLUTION = true;
    
    public Quote newQuote{get;set;}
    public Quote sourceQuote{get;set;}
    public Opportunity op{get;set;}
    public String typeObject{get;set;}
    public Boolean isQuote{get;set;}
    public Boolean resetQuote{get;set;}
    public Boolean ranOnce;
    public String rtName;
    public List<QuoteLineItem> lineItems {get; private set;}
    @TestVisible
    public Boolean needConfirm {public get; private set;}
    public String quoteNumber {get; set;}
    public String imagineQuoteNumber {get; set;}
    public String oppName {get; set;}
    public String quoteName {get; set;}
    public String accountName {get; set;}
    public List<QuoteWrapper> wrappers {get; set;}
    public Boolean resetCosts {get; set;}
    public Boolean resetPrices {get; set;}
    public Id recordId {get; set;}
   
    public CopyReviseQuoteController() {
        ranOnce = false;
        this.resetCosts = false;
        this.resetPrices = false;
        recordId = ApexPages.currentPage().getParameters().get('id');
        typeObject = ApexPages.currentPage().getParameters().get('type');
        isQuote = typeObject == 'Quote';
        try {
            if(typeObject == 'Opportunity') {
                op = [SELECT Id, Partner_Name__c, RecordTypeId, AccountId from Opportunity WHERE Id = :recordId];
            } else if(typeObject == 'Quote') {
                sourceQuote = [SELECT Id, Partner_Name__c,Default_Price_Book__c,Pricebook2Id from Quote WHERE Id = :recordId];
                queryLineItems(sourceQuote.Id);
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Id')); 
        }
        resetQuote = true;
        newQuote = new Quote();
        if(typeObject == 'Opportunity') {
            //initialize recordtype map
            Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosById();
            rtName = rtMap.get(op.RecordTypeId).getName();
            if(rtName.contains('Indirect'))
                newQuote.Partner_Name__c = op.Partner_Name__c;
        }
        if(typeObject == 'Quote') {
            newQuote.Parent_Quote__c = sourceQuote.Id;
            newQuote.Partner_Name__c = sourceQuote.Partner_Name__c;
            newQuote.Default_Price_Book__c = sourceQuote.Default_Price_Book__c;
            resetQuote = false;
        }
        wrappers = new List<QuoteWrapper>();
    }
    
    private void queryLineItems(Id quoteId) {
        lineItems = [
            SELECT Id, LineNumber, Product2Id, Product2.Description, Product2.ProductCode, 
            Product2.Part_No__c, Product2.Quotable__c, PricebookEntry.IsActive FROM QuoteLineItem 
            WHERE QuoteId =: quoteId
        ];
    }
    
    public void copyFromQuote(){
        String quoteId = ApexPages.currentPage().getParameters().get('quoteId');
        if(newQuote.Parent_Quote__c == quoteId) {
            newQuote.Parent_Quote__c = null;
        } else {
            newQuote.Parent_Quote__c = quoteId;
        }
        for(QuoteWrapper qw : wrappers) {
            qw.selected = (qw.q.Id == quoteId);
        }
    }
    
    public void searchQuotes(){
        String query = 'SELECT Id, Name, Account.Name, Opportunity.Name, QuoteNumber, Imagine_Quote_Number__c, Status, ExpirationDate FROM Quote';
        String quoteNumberLike = '%' + quoteNumber + '%';
        String imagineQuoteNumberLike = '%' + imagineQuoteNumber + '%';
        String oppNameLike = '%' + oppName + '%';
        String quoteNameLike = '%' + quoteName + '%';
        String accountLike = '%' + accountName + '%';
        String quoteNumberFilter = ' (QuoteNumber like :quoteNumberLike) ';
        String imagineQuoteFilter = ' (Imagine_Quote_Number__c  like :imagineQuoteNumberLike) ';
        String oppNameFilter = ' (Opportunity.Name like :oppNameLike) ';
        String quoteNameFilter = ' (Name like :quoteNameLike) ';
        String accountNameFilter = ' (Account.Name like :accountLike) ';
        String filter = '';
        String resultLimit = '100';
        if(String.isNotBlank(quoteNumber) ) {
            filter += ' where ' + quoteNumberFilter;
            resultLimit = '1000';
        }
        if(String.isNotBlank(imagineQuoteNumber)) {
            filter += (filter != '' ? ' and ' : ' where ') + imagineQuoteFilter;
            resultLimit = '1000';
        }
        if(String.isNotBlank(oppName)) {
            filter += (filter != '' ? ' and ' : ' where ') + oppNameFilter;
            resultLimit = '1000';
        }
        if(String.isNotBlank(quoteName)) {
            filter += (filter != '' ? ' and ' : ' where ') + quoteNameFilter;
            resultLimit = '1000';
        }
        if(String.isNotBlank(accountName)) {
            filter += (filter != '' ? ' and ' : ' where ') + accountNameFilter;
            resultLimit = '1000';
        }
        List<Quote> matchingQuotes = Database.query(query + filter + ' limit ' + resultLimit);
        wrappers = new List<QuoteWrapper>();
        for(Quote qt : matchingQuotes) {
            wrappers.add(new QuoteWrapper(qt, false));
        }
        needConfirm = false;
        ApexPages.getMessages().clear();
        newQuote.Parent_Quote__c = null;
    }
    
    /********************************************************
    ********************PAGE ACTIONS*************************
    ********************************************************/
    public PageReference cancel() {
        return new PageReference('/' + sourceQuote.Id);
    }
    
     public PageReference back() {
        return new PageReference('/' + recordId);
    }
    
    private String buildMessage() {
        needConfirm = false;
        String message = '';
        List<String> nonQuotable = new List<String>();
        List<String> inactive = new List<String>();
        for(QuoteLineItem qli : lineItems) {
            if(qli.Product2.Quotable__c == false) {
                needConfirm = true;
                nonQuotable.add(qli.Product2.Part_No__c);
            }
            if(qli.PricebookEntry.IsActive == false) {
                needConfirm = true;
                inactive.add(qli.Product2.Part_No__c);
            }
        }
        if(needConfirm == true) {
            message = 'Quote line items with following products will be discarded as: ';
            message += '<ul>';
            if(nonQuotable.size() != 0) message += '<li>' + String.join(nonQuotable, ', ') + ' are non-quotable</li>';
            if(inactive.size() != 0) message += '<li>' + String.join(inactive, ', ') + ' are inactive</li>';
            message += '</ul>';
        }
        return message;
    }
    
    public PageReference revise(){
        String message = buildMessage();
        if(needConfirm == true) {
            // need user to confirm
            message += 'Please confirm to revise quote.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, message));
            return null;
        } else {
            return confirmRevise();
        }
    }
    
    public PageReference confirmRevise() {
        //initialize the variables
        List<Quote_Solutions__c> quoteSolutionList = new List<Quote_Solutions__c>();
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        Map<Id, Quote_Solutions__c> id2OldQuoteSolMap = new Map<Id, Quote_Solutions__c>();
        Quote_Solutions__c tempQuoteSol = null;
        QuoteLineItem tempQuoteLI;
        Map<Id, QuoteLineItem> id2OldQuoteLIMap = new Map<Id, QuoteLineItem>();
        Map<Id, Quote_Solutions__c> clonedId2QuoteSolMap = new Map<id, Quote_Solutions__c>();
        Map<Id, QuoteLineItem> cloneId2QuoteLIMap = new Map<Id, QuoteLineItem>();
        String query = 'SELECT '+String.join(getSObjectFields(Quote_Solutions__c.getsobjecttype()) ,', ')+
                        ', (SELECT ' + String.join(getSObjectFields(QuoteLineItem.getsobjecttype()) ,', ') +', Product2.ProductCode, Product2.Part_No__c, Product2.Product_Cost__c, PricebookEntry.Product2Id,Product2.Nondiscountable__c FROM Quote_Line_Items__r WHERE Product2.Quotable__c = true AND PricebookEntry.IsActive = true)'+
                        ' FROM Quote_Solutions__c' +
                        ' WHERE Quote__c = \'' + newQuote.Parent_Quote__c + '\'';
        
        sourceQuote = (Quote)Database.query('SELECT ' + String.join(getSObjectFields(Quote.sobjecttype) ,', ')+ ', Pricebook2.Name, Pricebook2.Pricebook_Region__c FROM Quote WHERE id= \'' + newQuote.Parent_Quote__c + '\' limit 1')[0];
        
        Id parentQuoteId = newQuote.Parent_Quote__c;
        Id partnerAccId = newQuote.Partner_Name__c;
        Id pricebookId = newQuote.Default_Price_Book__c;
        
        newQuote = sourceQuote.clone(false,true);
        newQuote.Effective__c = Date.today();
        newQuote.ExpirationDate = Date.today().addDays(30);
        newQuote.status = 'Draft';
        newQuote.Parent_Quote__c = parentQuoteId;
        newQuote.Partner_Name__c = partnerAccId;
        newQuote.Default_Solution__c = null;

        //newQuote.Default_Price_Book__c = pricebookId;

        String imagineQuoteNumber = getImagineQuoteNumber(sourceQuote.Imagine_Quote_Number__c);
        Decimal versionMax = 1;

        if(imagineQuoteNumber != null) {
            for(Quote q : Database.query('SELECT Imagine_Quote_Number__c, Quote_Version__c from Quote where OpportunityId = \'' + sourceQuote.OpportunityId + '\' AND Imagine_Quote_Number__c LIKE \'%-' + imagineQuoteNumber + '-%\'')) {
                system.debug(q);
                versionMax = q.Quote_Version__c > versionMax ? q.Quote_Version__c : versionMax;
            }
        }

        if(newQuote.Quote_Version__c == null)
            newQuote.Quote_Version__c = 0;
        else
            newQuote.Quote_Version__c = versionMax + 1;

        //Set Imagine Quote number to same as before
        newQuote.Imagine_Quote_Number__c = imagineQuoteNumber == null ? sourceQuote.Imagine_Quote_Number__c : 'IC-' + imagineQuoteNumber + '-V' + String.valueOf(newQuote.Quote_Version__c);

        Savepoint sp = Database.setSavepoint();
        try {
            insert newQuote;
        }catch (Exception ex){
            return rollbackAndAddError(sp, ex.getMessage());
        }
        
        List<Quote_Solutions__c> queriedList = (List<Quote_Solutions__c>)Database.query(query);
        Boolean updateQuote = false;
        for(Quote_Solutions__c quoteSol : queriedList){
            id2OldQuoteSolMap.put(quoteSol.Id, quoteSol);
            tempQuoteSol = quoteSol.clone();
            tempQuoteSol.Quote__c = newQuote.Id;
            tempQuoteSol.coned_From__c = quoteSol.Id;
            tempQuoteSol.Account__c = partnerAccId;
            tempQuoteSol.Name = quoteSol.Name;
            tempQuoteSol.Parent_Solution__c = null;
            clonedId2QuoteSolMap.put(quoteSol.Id, tempQuoteSol);
        }
        try {
            insert clonedId2QuoteSolMap.values();            
            for(String key : clonedId2QuoteSolMap.keySet()){
                Quote_Solutions__c clonedQuoteSol = clonedId2QuoteSolMap.get(key);
                Quote_Solutions__c clonedFrom = id2OldQuoteSolMap.get(clonedQuoteSol.Coned_From__c);
                if(clonedFrom.Parent_Solution__c != null && clonedId2QuoteSolMap.containsKey(clonedFrom.Parent_Solution__c)){
                    clonedQuoteSol.Parent_Solution__c = clonedId2QuoteSolMap.get(clonedFrom.Parent_Solution__c).Id;
                }
                if(clonedQuoteSol.IsDefault__c == true) {
                    newQuote.Default_Solution__c = clonedQuoteSol.Id;
                    updateQuote = true;
                }
            }
            update clonedId2QuoteSolMap.values();
        } catch(Exception ex){
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;
        }
        // update quote
        if(updateQuote == true) {
            try {
                update newQuote;
            } catch(Exception ex) {
                return rollbackAndAddError(sp, ex.getMessage());
            }
        }
        // revise line items       
        Set<Id> productIds = new Set<Id>();
        for(Quote_Solutions__c quote : queriedList){
            for(QuoteLineItem ql : quote.Quote_Line_Items__r){
                tempQuoteLI = ql.clone();
                
                //set the fields to map to new quote and set cloned from field
                tempQuoteLI.Cloned_From__c = ql.Id;
                tempQuoteLI.QuoteId = newQuote.Id;
                tempQuoteLI.Solution__c = clonedId2QuoteSolMap.get(quote.Id).Id;
                
                //Set reset
                tempQuoteLI.Reset_Discounts__c = resetQuote;
                productIds.add(tempQuoteLI.PricebookEntry.Product2Id);

                //reset qli price if product is non-discountable
                if(tempQuoteLI.Product2.Nondiscountable__c == true){
                    tempQuoteLI.Discount = 0;
                    tempQuoteLI.Line_Discount__c = 0;
                }
                //add quote line item so it can be inserted
                quoteLineItems.add(tempQuoteLI);
            }
        }
        if(resetCosts == true || resetPrices == true) {
            try {
                String currencyCode = sourceQuote.CurrencyIsoCode;
                String pricebookRegion = sourceQuote.Pricebook2.Pricebook_Region__c;
                // setup currency map
                Map<String, CurrencyType> currencyMap = new Map<String, CurrencyType>();
                for(CurrencyType ctype : [SELECT IsoCode, ConversionRate, IsCorporate FROM CurrencyType]) {
                    currencyMap.put(ctype.IsoCode, ctype);
                }
                // setup pricebook entries
                List<PricebookEntry> pricebookEntries = [
                    SELECT Id, Pricebook2Id, Product2Id, Product2.NonDiscountable__c, Product2.ProductCode, Product2.Product_Cost__c,
                    IsActive, UnitPrice, CurrencyIsoCode, Product2.Quotable__c, Pricebook2.Pricebook_Region__c
                    FROM PricebookEntry 
                    WHERE Pricebook2Id = :pricebookId AND CurrencyIsoCode = :currencyCode AND Product2Id IN :productIds
                ];
                Map<String, PricebookEntry> productEntryMap = new Map<String, PricebookEntry>();
                for(PricebookEntry entry : pricebookEntries) {
                    if(!productEntryMap.containsKey(entry.Product2Id)) {
                        productEntryMap.put(entry.Product2Id, entry);
                    }
                }

                for(QuoteLineItem qli : quoteLineItems) {
                    String productId = qli.Product2Id;                            
                    PricebookEntry entry = productEntryMap.get(productId);
                    if(entry == null || entry.IsActive == false) {
                        // entry not found
                        continue;
                    }

                    Decimal fromRate = CloneOpportunityController.findConversionRate(pricebookRegion, currencyMap, currencyCode);
                    Decimal toRate = CloneOpportunityController.findConversionRate(entry.Pricebook2.Pricebook_Region__c, currencyMap, entry.CurrencyIsoCode);
                    if(resetPrices == true) {
                        // unit price calculation
                        if(qli.ListPrice == 0 || ((qli.Product2.Part_No__c.startsWithIgnoreCase('ps-') || qli.Product2.Part_No__c.startsWithIgnoreCase('ps -')) 
                            && qli.Product2.Part_No__c.endsWithIgnoreCase('-te'))) {
                            // do currency conversion
                            qli.UnitPrice = CloneOpportunityController.convertAmount(qli.UnitPrice, fromRate, toRate);                                
                        } else {
                            qli.UnitPrice = entry.UnitPrice;
                        }
                    }
                    if(resetCosts == true) {
                        // product cost calculation
                        if(currencyCode == 'USD') {
                            fromRate = currencyMap.get(currencyCode).ConversionRate;
                        }
                        if(entry.CurrencyIsoCode == 'USD') {
                            toRate = currencyMap.get(entry.CurrencyIsoCode).ConversionRate;
                        }
                        Decimal productCost = (qli.Product_Cost2__c == null ? 0 : qli.Product_Cost2__c) / fromRate;
                        productCost = productCost.setScale(2);
                        if(qli.Product2.Product_Cost__c == 0 || qli.Product2.Product_Cost__c == null || 
                           ((qli.Product2.Part_No__c.startsWithIgnoreCase('ps-') || qli.Product2.Part_No__c.startsWithIgnoreCase('ps -')) && 
                            qli.Product2.Part_No__c.endsWithIgnoreCase('-te'))) {
                            qli.Product_Cost2__c = CloneOpportunityController.convertAmount(qli.Product_Cost2__c, fromRate, toRate);
                        } else {
                            if(productCost != qli.Product2.Product_Cost__c) {
                                qli.Product_Cost2__c = qli.Product2.Product_Cost__c * toRate;
                                qli.Product_Cost2__c = qli.Product_Cost2__c.setScale(2);
                            } else {
                                qli.Product_Cost2__c = CloneOpportunityController.convertAmount(qli.Product_Cost2__c, fromRate, toRate);
                            }
                        }
                    }
                }
            } catch(Exception ex) {
                return rollbackAndAddError(sp, ex.getMessage());
            }
        }
        
        try {
            //added code to allow partial success
            Database.SaveResult[] results = Database.insert(quoteLineItems, false);
            for(Database.SaveResult sr : results) {
                if(sr.isSuccess()) continue;
                for(Database.Error err : sr.getErrors()) {
                    String error = 'The following error has occurred: ';
                    error += err.getStatusCode() + ': ' + err.getMessage() + '\n';
                    List<String> fields = err.getFields();
                    if(fields != null && !fields.isEmpty()) error += ' Here are the fields that caused this error: ' + String.join(fields, ',');
                    throw new ReviseQuoteException(error);
                }
            }
        } catch(Exception ex){
            return rollbackAndAddError(sp, ex.getMessage());
        }

        try {
            // update rollups
            QuoteLineTriggerHelper.adjustRollupFields(quoteLineItems);
            // update quote line items
            database.update(quoteLineItems);
        } catch(Exception ex) {
            return rollbackAndAddError(sp, ex.getMessage());
        }

        //Do Synching of Quote if previous quote is synching
        if(sourceQuote.IsSyncing) {
            Opportunity temp = new Opportunity();
            temp.Id = newQuote.OpportunityId;
            temp.SyncedQuoteId = newQuote.Id;
            try {
                update temp;
            } catch(Exception ex) {
                return rollbackAndAddError(sp, ex.getMessage());
            }
        }
        
        return new PageReference('/'+newQuote.id);
    }
    
    public PageReference copy() {
        queryLineItems(newQuote.Parent_Quote__c);
        String message = buildMessage();
        if(needConfirm == true) {
            message += 'Please confirm to copy from selected quote.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, message));
            String url = ApexPages.currentPage().getUrl();
            url += '&type=' + typeObject;
            PageReference pr = new PageReference(url);
            pr.getParameters().put('type', 'Opportunity');
            return pr;
        } else {
            return confirmCopy();
        }
    }
    
    public PageReference confirmCopy() {
        try {
            //initialize the variables
            Id parentQuoteId = newQuote.Parent_Quote__c;
            List<Quote_Solutions__c> quoteSolutionList = new List<Quote_Solutions__c>();
            List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
            Map<Id, Quote_Solutions__c> id2OldQuoteSolMap = new Map<Id, Quote_Solutions__c>();
            Quote_Solutions__c tempQuoteSol;
            QuoteLineItem tempQuoteLI;
            Map<Id, QuoteLineItem> id2OldQuoteLIMap = new Map<Id, QuoteLineItem>();
            Map<Id, Quote_Solutions__c> clonedId2QuoteSolMap = new Map<id, Quote_Solutions__c>();
            Map<Id, QuoteLineItem> cloneId2QuoteLIMap = new Map<Id, QuoteLineItem>();
            String query = 'SELECT '+String.join(getSObjectFields(Quote_Solutions__c.getsobjecttype()) ,', ')+
                            ', (SELECT ' + String.join(getSObjectFields(QuoteLineItem.getsobjecttype()) ,', ') + ',PricebookEntry.Product2Id,PricebookEntry.Product2.Name,Product2.Nondiscountable__c FROM Quote_Line_Items__r WHERE Product2.Quotable__c = true AND PricebookEntry.IsActive = true)'+
                            ' FROM Quote_Solutions__c' +
                            ' WHERE Quote__c = \'' + parentQuoteId + '\'';
            
            sourceQuote = (Quote)Database.query('SELECT ' + String.join(getSObjectFields(Quote.sobjecttype) ,', ')+ ' FROM Quote WHERE id= \'' + parentQuoteId + '\' limit 1')[0];
            
            Id partnerAccId = newQuote.Partner_Name__c;
            //Don't need to do this, use same Pricebook as copied Quote
            /*
            Map<Id,Id> productToPBE = new Map<Id,Id>();
            for(PricebookEntry pbe : [SELECT Product2Id from PricebookEntry WHERE Pricebook2Id = :pricebookId])
            {
                productToPBE.put(pbe.Product2Id,pbe.Id);
            }
            */
            
            newQuote = sourceQuote.clone();
            newquote.status = 'Draft';
            newQuote.Parent_Quote__c = parentQuoteId;
            newQuote.Partner_Name__c = partnerAccId;
            //Null out Imagine Quote Number to give new Quote Number
            newQuote.Imagine_Quote_Number__c = null;
            newQuote.Default_Solution__c = null;
            //newQuote.Default_Price_Book__c = pricebookId;
            newQuote.OpportunityId = op.id;
            
            Account newAccount = [SELECT Id, Name, Billing_Address__c, Shipping_Address__c FROM Account WHERE Id = :op.AccountId];
            newQuote.Opportunity_Account__c = newaccount.Id;
            newQuote.BillingName = newAccount.Name;
            newQuote.ShippingName = newAccount.Name;

            newQuote.Quote_Version__c = 1.0;
            
            if(resetQuote)
            {   
                //Refresh tier discount from partner
               // if(rtName.contains('Indirect'))
               // {
               //     Account partnerAccount = [SELECT Base_Discount__c from Account WHERE Id = :partnerAccId];
               //     if(partnerAccount != null && partnerAccount.Base_Discount__c != null)
               //         newQuote.Tier_Discount2__c = partnerAccount.Base_Discount__c;
              //  }
                
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
            Savepoint sp = Database.setSavepoint();
            try {
                ALLOW_DEFAULT_SOLUTION = false;
                system.debug('quote to be inserted ' +newQuote);
                insert newQuote;
            }catch (Exception ex){
                return rollbackAndAddError(sp, ex.getMessage());
            }
            //try to update billing and shipping addresses
    
            //sp = Database.setSavepoint();
    
            newQuote.Billing_Address__c = newAccount.Billing_Address__c;
            newQuote.Shipping_Address__c = newAccount.Shipping_Address__c;
            ALLOW_DEFAULT_SOLUTION = true;
    
            system.debug('NewId: ' + newQuote.Id);
            //blogic_Quote.updateBillShipAddresses(newQuote.Id);
            Boolean updateQuote = false;
            List<Quote_Solutions__c> queriedList = (List<Quote_Solutions__c>)Database.query(query);
            for(Quote_Solutions__c quoteSoln : queriedList){
                id2OldQuoteSolMap.put(quoteSoln.Id, quoteSoln);
                tempQuoteSol = quoteSoln.clone(false, true);
                tempQuoteSol.Quote__c = newQuote.Id;
                tempQuoteSol.coned_From__c = quoteSoln.Id;
                tempQuoteSol.Account__c = partnerAccId;
                tempQuoteSol.Name = quoteSoln.Name;
                tempQuoteSol.Parent_Solution__c = null;
                clonedId2QuoteSolMap.put(quoteSoln.Id, tempQuoteSol);
            }

            try {
                insert clonedId2QuoteSolMap.values();            
                for(String key : clonedId2QuoteSolMap.keySet()){
                    Quote_Solutions__c clonedQuoteSol = clonedId2QuoteSolMap.get(key);
                    Quote_Solutions__c clonedFrom = id2OldQuoteSolMap.get(clonedQuoteSol.Coned_From__c);
                    if(clonedFrom.Parent_Solution__c != null && clonedId2QuoteSolMap.containsKey(clonedFrom.Parent_Solution__c)){
                        clonedQuoteSol.Parent_Solution__c = clonedId2QuoteSolMap.get(clonedFrom.Parent_Solution__c).Id;
                    }
                    if(clonedQuoteSol.IsDefault__c == true) {
                        newQuote.Default_Solution__c = clonedQuoteSol.Id;
                        updateQuote = true;
                    }
                }
                update clonedId2QuoteSolMap.values();
            } catch(Exception ex){
                return rollbackAndAddError(sp, ex.getMessage());
            }
            // update quote
            if(updateQuote == true) {
                try {
                    update newQuote;
                } catch(Exception ex) {
                    return rollbackAndAddError(sp, ex.getMessage());
                }
            }

            Boolean error = false;
            for(Quote_Solutions__c quote : queriedList){
                for(QuoteLineItem ql : quote.Quote_Line_Items__r){
                    tempQuoteLI = ql.clone();
                    System.debug('qliName::'+tempQuoteLI.Part_Number__c);
                    
                    //set the fields to map to new quote and set cloned from field
                    tempQuoteLI.Cloned_From__c = ql.id;
                    tempQuoteLI.QuoteId = newQuote.id;
                    tempQuoteLI.Solution__c = clonedId2QuoteSolMap.get(quote.Id).id;

                    
                    //Set flags to false for revise
                    //set reset flags and if true set line discount to false
                    if(resetQuote || tempQuoteLI.Product2.Nondiscountable__c )
                    {
                        tempQuoteLI.Line_Discount__c = 0;
                        tempQuoteLI.Discount = 0;
                        //tempQuoteLI.UnitPrice = 0;
                        //all discounts are wiped, in case of indrect we just take tier discount
                        if(sourceQuote.Tier_Discount2__c != null)
                            tempQuoteLI.Discount = sourceQuote.Tier_Discount2__c;
                    }
                    tempQuoteLI.Reset_Discounts__c = resetQuote;
                    //add quote line item so it can be inserted
                    quoteLineItems.add(tempQuoteLI);
                }
            }
            if(error && !ranOnce)
            {
                return null;
                ranOnce = true;
            }
            try {
                insert quoteLineItems;
                QuoteLineTriggerHelper.adjustRollupFields(quoteLineItems);
            } catch(Exception ex){
                System.debug('line::'+ex.getLineNumber());
                System.debug('error::'+ex.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
                return null;
            }
            
            return new PageReference('/'+newQuote.id);
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;
        }
    }
    
    private PageReference rollbackAndAddError(Savepoint sp, String msg){
        Database.rollback(sp);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
        return null;
    }
    
    /********************************************************
    ********************HELPER ACTIONS*************************
    ********************************************************/
    
    public static List<String> getSObjectFields(Schema.SObjectType objectType) {
        // Check for object type 
        if (objectType == null) { return null; }
        
        // Get field map
        Map<String, SObjectField> fieldMap = objectType.getDescribe().fields.getMap();        
       
        List<String> fieldList = new List<String>();
        for (String f : fieldMap.keySet()) {
           // DescribeFieldResult field = fieldMap.get(f).getDescribe();
           //if(f != 'svmxc__latitude__c')
                fieldList.add(f); 
        }
        
        //return the list of fields
        return fieldList;
    }

    private String getImagineQuoteNumber(String oldNumber) {
        String[] broken = oldNumber.split('-');
        if(broken.size() > 1) {
            return broken[1];
        }
        return null;

    }
    
    public class QuoteWrapper {
        public Quote q {get; set;}
        public Boolean selected {get; set;}
        
        public QuoteWrapper(Quote q, Boolean selected) {
            this.q = q;
            this.selected = selected;
        }
    }

    public class ReviseQuoteException extends Exception {}
}