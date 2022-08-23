global class QuoteLineItemsPageController
{
    public Quote quote{get;set;}
    public Id quoteId{get;set;}
    public List<QuoteLineItemWrapper> qliList{get;set;}
    public List<QuoteSolutionWrapper> qsList{get;set;}
    public String defaultSolutionSet{get;set;}
    public List<String> selectedSolutionSets {get; set;}
    public Boolean adminProfile{get;set;}
    public Set<String> profileNames;
    public String copyToSolution{get;set;}
    public String moveToSolution{get;set;}
    public String VFPageId{get;set;}
    private User currentUser;
    public Boolean IsErrorOccurs {get; set;}
    public QuoteLineItemsPageController(ApexPages.StandardController con)
    {
        //intialize some variables
        selectedSolutionSets = new List<String>();
        quote = (Quote)con.getRecord();
        defaultSolutionSet = [SELECT Default_Solution__c FROm Quote WHERE Id = :quote.Id].Default_Solution__c;
        quoteId = quote.Id;
        setupQliWrappers();
        findAdminProfiles();
        //Get the page id of the VF Page
        ApexPage a = [SELECT Id, Name from ApexPage WHERE name = 'QuoteLineItemsPage'];
        system.debug('VF Page '+a);
        VFPageId = ((String)a.id).substring(0,15);

        this.currentUser = [select Quote_Line_Item_Settings__c from User where Id = :UserInfo.getUserId()];
        String stopRedirect = ApexPages.currentPage().getParameters().get('stopRedirect');
        if(stopRedirect == 'true') {
            Cookie c = new Cookie('do_redirect','true',null,0,false);
            ApexPages.currentPage().setCookies(new Cookie[]{c});
        }
    }
    public String getBaseURL()
    {
        String s = URL.getSalesforceBaseURL().toExternalForm()+'/_ui/sales/quote/SelectSearch?addTo='+quoteId+'&isdtp=vw';
        system.debug('BASE URL'+s);
        return s;
    }
    public void moveSolutionSet()
    {
        String str = ApexPages.CurrentPage().getParameters().get('strSerialVal');
        try
        {
            List<Quote_Solutions__c> solutions = (List<Quote_Solutions__c>)JSON.deserialize(str,List<Quote_Solutions__c>.class);
            update solutions;
            saveQLI();
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return;
        }
    }

    public void updateSolutionSets(){
        selectedSolutionSets = new List<String>();
    }

    public void renameSolutionSet() {
        String solutionSetId = Apexpages.currentPage().getParameters().get('solutionId');
        String solutionSetName = Apexpages.currentPage().getParameters().get('solutionNewName');
        Quote_Solutions__c qs = new Quote_Solutions__c();
        qs.Id = solutionSetId;
        qs.Name = solutionSetName;
        try {
            update qs;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return;
        }
        ApexPages.addMessage(new ApexPages.Message(
            ApexPages.Severity.INFO, 
            'Successfully renamed (Long names are truncated to 80 chars)'
        ));
    }

    public void onUpdateTotalPrice() {
        try {
            String strId = Apexpages.currentPage().getParameters().get('solutionId');
            if(String.isNotBlank(strId)) {
                Decimal newTotalPrice = Decimal.valueOf(Apexpages.currentPage().getParameters().get('newTotalPrice'));
                Quote_Solutions__c solution = [SELECT Id, Total_Price__c, (SELECT Id, Line_Discount__c, Subtotal, TotalPrice, Product2.Product_Type__c, Product2.NonDiscountable__c FROM Quote_Line_Items__r) FROM Quote_Solutions__c WHERE Id =: strId];
                Decimal nonDiscountableTotal = 0;
                for(QuoteLineItem qli : solution.Quote_Line_Items__r) {
                    if(qli.Product2.NonDiscountable__c == true) {
                        nonDiscountableTotal += qli.TotalPrice;
                    }
                }
                Decimal discountableTotal = solution.Total_Price__c - nonDiscountableTotal;
                newTotalPrice = newTotalPrice - nonDiscountableTotal;
                List<QuoteLineItem> qlis = new List<QuoteLineItem>();
                for(QuoteLineItem qli : solution.Quote_Line_Items__r) {
                    if(qli.Product2.NonDiscountable__c == false) {
                        qli.Line_Discount__c = ((qli.Subtotal - ((qli.TotalPrice / discountableTotal) * newTotalPrice)) / qli.Subtotal) * 100;
                        qlis.add(
                            new QuoteLineItem(
                                Id = qli.Id,
                                Line_Discount__c = qli.Line_Discount__c
                            )
                        );
                    }
                }
                update qlis;
                // refresh line items
                setupQliWrappers();
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Solution Id'));
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }

    public void onUpdateTotalMargin() {
        try {
            String strId = Apexpages.currentPage().getParameters().get('solutionId');
            if(String.isNotBlank(strId)) {
                // re-calcalute Line_Discount__c based on new total margin
                Decimal newTotalMargin = Decimal.valueOf(Apexpages.currentPage().getParameters().get('newTotalMargin'));
                List<QuoteLineItem> lineItems = [SELECT Id, UnitPrice, Quantity, Discount, Line_Discount__c, Extended_Cost__c, Margin__c FROM QuoteLineItem WHERE Solution__c =: strId AND Product2.NonDiscountable__c = false];
                for(QuoteLineItem qli : lineItems) {
                    Decimal deno = ((newTotalMargin * ((qli.UnitPrice * qli.Quantity * (1 - qli.Discount / 100)) - qli.Extended_Cost__c)) - (qli.Margin__c * qli.UnitPrice * qli.Quantity * (1 - qli.Discount / 100)));
                    Decimal newDiscount = 0;
                    if(deno != 0) {
                        newDiscount = ((newTotalMargin * ((qli.UnitPrice * qli.Quantity * (1 - qli.Discount / 100)) - qli.Extended_Cost__c)) - (qli.Margin__c * (1 - qli.Discount / 100) * ((qli.UnitPrice * qli.Quantity) - qli.Extended_Cost__c))) / deno;
                    } else {
                        newDiscount = ((newTotalMargin * ((qli.UnitPrice * qli.Quantity * (1 - qli.Discount / 100)) - qli.Extended_Cost__c)) - (qli.Margin__c * (1 - qli.Discount / 100) * ((qli.UnitPrice * qli.Quantity) - qli.Extended_Cost__c)));
                    }
                    if(qli.Discount == qli.Line_Discount__c) {
                        // there are no other discounts
                        qli.Line_Discount__c = newDiscount * 100;
                    } else if(qli.Discount > qli.Line_Discount__c) {
                        qli.Line_Discount__c = (newDiscount - ((qli.Discount - qli.Line_Discount__c) / 100) * 100);
                    } else {
                        System.debug('## --> should not log :( ');
                    }
                }
                update lineItems;
                // refresh line items
                setupQliWrappers();
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Solution Id'));
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }

    @RemoteAction
    global static String optionalSolutionSet(String solutionSetId, String quoteId)
    {

        //Set default solution set
        Quote q = new Quote(
            Id=quoteId,
            Default_Solution__c=solutionSetId
        );
        update q;

        Quote_Solutions__c qs = new Quote_Solutions__c();
        qs = [SELECT Optional__c,(SELECT Optional__c from Quote_Solutions__r) from Quote_Solutions__c
                                WHERE Id = :solutionSetId];
        Set<Id> qsIds = new Set<Id>();
        qsIds.add(qs.Id);
        qs.Optional__c = (!qs.Optional__c);
        //set children optional as well
        for(Quote_Solutions__c qsRelated : qs.Quote_Solutions__r){
            qsIds.add(qsRelated.Id);
            qsRelated.Optional__c = qs.Optional__c;
        }
        update qs;
        update qs.Quote_Solutions__r;
        //Update related QLIS with Optional
        List<QuoteLineItem> qliList = [SELECT Optional__c, Solution__r.Optional__c from QuoteLineItem WHERE Solution__c IN :qsIds];
        for(QuoteLineItem qli : qliList){
            qli.Optional__c = qli.Solution__r.Optional__c;
        }
        update qliList;
        return 'true';

    }
    
    @RemoteAction
    global static List<QuoteLineItem> getNonQuotableItems(String quoteId) {
        return [SELECT Id, Product2Id, 
            Product2.ProductCode, Product2.Quotable__c 
            FROM QuoteLineItem 
            WHERE QuoteId =: quoteId AND Product2.Quotable__c = false
        ];
    }
    
    @RemoteAction
    global static List<QuoteLineItem> getProductsWithLimSupply(String quoteId) {
        return [SELECT Id, Product2Id, 
            Product2.ProductCode, Product2.Product_Status__c 
            FROM QuoteLineItem 
            WHERE QuoteId =: quoteId AND Product2.Product_Status__c = 'LIM_SUPPLY'
        ];
    }

    @RemoteAction
    global static Map<String, String> getReplaceableProducts(String quoteId) {
        List<QuoteLineItem> qlis = [
            select Id, Product2Id, 
            Product2.ProductCode, Product2.Quotable__c,
            Product2.New_Product_Replace_By__c, 
            Product2.New_Product_Replace_By__r.ProductCode, 
            Product2.New_Product_Replace_By__r.Quotable__c
            from QuoteLineItem 
            where QuoteId =: quoteId
        ];
        Map<String, String> productsMap = new Map<String, String>();
        for(QuoteLineItem qli : qlis){
            if(String.isNotBlank(qli.Product2.New_Product_Replace_By__c)){
                productsMap.put(qli.Product2.ProductCode, qli.Product2.New_Product_Replace_By__r.ProductCode);
            }
        }
        return productsMap;
    }
    
    @RemoteAction
    global static String createSolutionSet(String quoteId)
    {
        Quote_Solutions__c qs = new Quote_Solutions__c();
        try
        {
            List<AggregateResult> maxQs = [SELECT MAX(Order__c) max from Quote_Solutions__c
            WHERE Quote__c = :quoteId AND Parent_Solution__c = null];
            Integer newOrderNum = 1;
            if(maxQs.size() > 0) //Creating a Solution set as the last in the order
                if((Decimal)maxQs.get(0).get('max') != null)
                    newOrderNum = ((Decimal)maxQs.get(0).get('max')).intValue()+1;
            qs.Quote__c = quoteId;
            qs.Name = 'New Solution Set';
            qs.Order__c = newOrderNum;
            qs.IsActive__c = true;
            qs.User__c = UserInfo.getUserId();
            insert qs;
        }
        catch(Exception e){
            qs.addError(e.getMessage());
        }
        return qs.Id;
    }

    @RemoteAction
    global static Map<String, Object> deleteSolutionSet(String quoteId, String solutionSetId, Boolean withChildren) {
        Map<String, Object> result = new Map<String, Object>();
        Quote_Solutions__c qs = new Quote_Solutions__c();
        qs.Id = solutionSetId;
        Savepoint sp = Database.setSavepoint();
        try {
            if(withChildren == true) {
                delete [select Id from QuoteLineItem where Solution__c = :solutionSetId];
                List<Quote_Solutions__c> childSolutionSets = [
                    select Id from Quote_Solutions__c 
                    where Parent_Solution__c = :solutionSetId
                ];
                // delete child solution sets as well, for now only two levels exist
                if(childSolutionSets.size() != 0) {
                    List<QuoteLineItem> childLineItems = [
                        select Id from QuoteLineItem 
                        where Solution__c IN :childSolutionSets
                    ];
                    delete childLineItems;
                    delete childSolutionSets;
                }
            }
            delete qs;
            createDefaultSolutionSet(quoteId);
            List<QuoteLineItem> qlis = [
                select QuoteId, PricebookEntryId, Product_Cost2__c, Part_Number2__c, UnitPrice, Unit_net_price__c, Extended_Cost__c, 
                TotalPrice, Margin__c, Long_Description__c, Product2.Name,Product2.Product_Line__c, Product2.Allow_Cost_Override__c,
                Product2.Salesforce_Product_Type__c, Part_Number__c, Product2Id,  Quantity, ListPrice, Line_Discount__c, Product2.NonDiscountable__c
                from QuoteLineItem
                where QuoteId = :quoteId order by QuoteSolutionOrder__c asc
            ];
            update qlis;
            result.put('success', true);
        } catch(Exception e) {
            result.put('success', false);
            result.put('error', toErrorMap(e));
            Database.rollback(sp);
        }
        return result;
    }

    private static void createDefaultSolutionSet(String quoteId){
        // create default solution set
        Quote currentQuote = [select Id, Quote_Version__c, (select Id from Quote_Solutions__r) from Quote where Id =: quoteId];
        if(currentQuote.Quote_Solutions__r.size() == 0) {
            // when last solution set is deleted create new default solution set
            Quote_Solutions__c defaultSolution = QuoteTriggerHelper.buildDefaultSolution(currentQuote.Id);
            insert defaultSolution;
            update new Quote(Id=currentQuote.Id, Default_Solution__c=defaultSolution.Id);
        }
    }

    @RemoteAction
    global static Map<String, Object> deleteAllQuoteSolutions(String quoteId){
        Map<String, Object> result = new Map<String, Object>();
        Savepoint sp = Database.setSavepoint();
        try {
            delete [select Id from QuoteLineItem where QuoteId = :quoteId];
            delete [select Id from Quote_Solutions__c where Quote__c = :quoteId];
            createDefaultSolutionSet(quoteId);
            String defaultSolutionId = [
                select Default_Solution__c 
                from Quote 
                where Id = :quoteId
            ].Default_Solution__c;
            result.put('success', true);
            result.put('defaultSolution', defaultSolutionId);
        } catch (Exception ex){
            result.put('success', false);
            result.put('error', ex.getMessage() + ' at ' + ex.getLineNumber());
            result.put('details', ex.getStackTraceString());
            Database.rollback(sp);
        }
        return result;
    }


    private static Map<String, String> toErrorMap(Exception ex) {
        Map<String, String> error = new Map<String, String>();
        error.put('message', ex.getMessage());
        error.put('line_number', String.valueOf(ex.getLineNumber()));
        error.put('details', ex.getStackTraceString());
        return error;
    }

    public void findAdminProfiles()
    {
        Id userId = userinfo.getProfileId();
        String userProfile = [SELECT Name FROM Profile WHERE Id = :userId].Name;
        List<Edit_QLI_Cost_Profiles__c> csList = Edit_QLI_Cost_Profiles__c.getAll().values();
        profileNames = new Set<String>();
        for(Edit_QLI_Cost_Profiles__c cs : csList)
        {
            profileNames.add(cs.Profiles__c);
        }
        system.debug('Admin Profile Names'+profileNames);
        if(profileNames.contains(userProfile))
        {
            adminProfile = true;
        }
        else
            adminProfile = false;
        system.debug('adminProfile is '+adminProfile);
    }
    public void massUpdateQLI()
    {
        system.debug('entering mass update');
        system.debug('adminProfile is '+adminProfile);
        String longDescription = Apexpages.currentPage().getParameters().get('longDescription');
        String customPartNumber = Apexpages.currentPage().getParameters().get('customPartNumber');
        String unitPrice = Apexpages.currentPage().getParameters().get('unitPrice');
        String productCost = Apexpages.currentPage().getParameters().get('productCost');
        String quantity = Apexpages.currentPage().getParameters().get('quantity');
        String lineDiscount = Apexpages.currentPage().getParameters().get('lineDiscount');
        system.debug('parameters'+longDescription+' '+customPartNumber+' '+unitPrice+' '+productCost+' '+quantity+' '+lineDiscount);
        List<QuoteLineItem> qliSaveList = new List<QuoteLineItem>();
        if(!Schema.sObjectType.QuoteLineItem.fields.Long_Description__c.isUpdateable()
        || !Schema.sObjectType.QuoteLineItem.fields.Part_Number2__c.isUpdateable() || !Schema.sObjectType.QuoteLineItem.fields.UnitPrice.isUpdateable() ||
        !Schema.sObjectType.QuoteLineItem.fields.Product_Cost2__c.isUpdateable() || !Schema.sObjectType.QuoteLineItem.fields.Quantity.isUpdateable() ||
        !Schema.sObjectType.QuoteLineItem.fields.Line_Discount__c.isUpdateable())
        {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Profile cannnot update these field'));
            return;
        }
        try
        {
            if(Approval.isLocked(quoteId) && !adminProfile ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot edit line item when quote is locked'));
                return;
            }
            for(QuoteLineItemWrapper qliw: qliList)
            {
                if(qliw.selected == true)
                {
                    if(longDescription != '')
                        qliw.q.Long_Description__c = longDescription;
                    if(customPartNumber != '')
                        qliw.q.Part_Number2__c = customPartNumber;
                    if(unitPrice != '')
                        qliw.q.UnitPrice = Decimal.valueOf(unitPrice);
                    if(productCost != '')
                    {
                        //If not adminProfile then only allow update to Product cost on BCD 999
                        if(adminProfile)
                            qliw.q.Product_Cost2__c = Decimal.valueOf(productCost);
                        else
                        {
                            if(qliw.q.Part_Number2__c.containsIgnoreCase('BCD'))
                                qliw.q.Product_Cost2__c = Decimal.valueOf(productCost);
                        }
                    }
                    if(quantity != '')
                        qliw.q.Quantity = Decimal.valueOf(quantity);
                    if(lineDiscount != '' && !qliw.q.Product2.NonDiscountable__c)
                        qliw.q.Line_Discount__c = Decimal.valueOf(lineDiscount);
                    qliSaveList.add(qliw.q);
                }
            }
            system.debug('Mass Update Save list '+qliSaveList);
            update qliSaveList;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return;
        }
        setupQliWrappers();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Succesfully mass updated'));

    }
    public void deleteQLI()
    {
        String s = Apexpages.currentPage().getParameters().get('selectedQli');
        system.debug('s String is '+s);
        List<String> selectedQLIs = (List<String>)JSON.deserialize(s,List<String>.class);
        system.debug('deserialized QLIs '+ selectedQLIs);
        List<QuoteLineItem> qliDeleteList = new List<QuoteLineItem>();
        for(String qliId : selectedQLIs)
        {
            QuoteLineItem temp = new QuoteLineItem();
            temp.Id = qliId;
            qliDeleteList.add(temp);
        }

        //try to delete list of Qlis
        try
        {
            delete qliDeleteList;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return;
        }
        setupQliWrappers();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Succesfully deleted'));
    }
    public void saveQLI()
    {
        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
        for(QuoteLineItemWrapper qliw : qliList)
        {
            qlis.add(qliw.q);
        }
        try
        {
            update qlis;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return;
        }
        setupQliWrappers();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Succesfully saved'));

    }
    
    public PageReference newQLI() {
        switchDefaultSolution();
        if(IsErrorOccurs == null || !IsErrorOccurs){
            String url = ApexPages.currentPage().getUrl();
            String uiTheme = UserInfo.getUiThemeDisplayed();
            if(!url.contains('&inline') && uiTheme != 'Theme4d') {
                // set cookie
                Cookie c = new Cookie('do_redirect','true',null,-1,false);
                ApexPages.currentPage().setCookies(new Cookie[]{c});
            }
            return doRedirect(false);
        }
        return null;
    }
    
    public PageReference doRedirect(Boolean redirect) {
        String url = '/_ui/sales/quote/SelectSearch?addTo='+quote.Id+'&cancelURL=/apex/QuoteLineItemsPage?id='+quote.Id;
        if (String.isBlank(this.currentUser.Quote_Line_Item_Settings__c) || !this.currentUser.Quote_Line_Item_Settings__c.contains('Do not preload part number search')) {
            url += '&PricebookEntrycol0=PRODUCT.CUSTOMER_PRODUCT_ID&PricebookEntryoper0=s';
            url += '&PricebookEntrycol1=00Ni000000DbiOe&PricebookEntryoper1=e&PricebookEntryfval1=true';
        }
        return new PageReference(url);
    }
    
    public Boolean getErrorsPresent(){
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        if(msgs.size() > 0)
            return true;
        return false;
    }

    public void moveQLI()
    {
        system.debug('selected solution set to move to '+moveToSolution);
        List<Quote_Solutions__c> solutions = [select Id, Optional__c from Quote_Solutions__c where Id = :moveToSolution];
        Quote_Solutions__c qs = null;
        if(solutions.size() != 0) qs = solutions.get(0);
        else return;
        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
        for(Integer i = 0; i < qliList.size(); i++)
        {
            QuoteLineItemWrapper qliw = qliList.get(i);
            if(qliw.selected == true)
            {
                qliw.q.Solution__c = moveToSolution;
                qliw.q.Optional__c = qs.Optional__c;
                qlis.add(qliw.q);
            }
        }
        try
        {
            system.debug('qlis to update '+qlis);
            update qlis;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return;
        }
        setupQliWrappers();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Succesfully moved QuoteLineItems'));
    }
    public void copyQLI()
    {
        system.debug('selected solution set to copy to '+copyToSolution);

        // get existing number of items in the solution so we append to the end later
        Integer solutionSize = [select Id from QuoteLineItem where Solution__c = :copyToSolution].size();
        Integer currentSolutionOrder = 0;

        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
        for(Integer i = 0; i < qliList.size(); i++)
        {
            QuoteLineItemWrapper qliw = qliList.get(i);
            if(qliw.selected == true)
            {
                QuoteLineItem newQLI = new QuoteLineItem();
                newQLI = qliw.q.clone(false,true);//create deep clone
                newQLI.Solution__c = copyToSolution;
                newQLI.QuoteSolutionOrder__c = currentSolutionOrder;
                system.debug('new qli created '+newQLI);
                qlis.add(newQLI);

                currentSolutionOrder++;
            }
        }
        try
        {
            system.debug('qlis to update '+qlis);
            insert qlis;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return;
        }
        setupQliWrappers();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Succesfully copied QuoteLineItems'));
    }

    public void reorderQli()
    {
        system.debug('old QLIS = ' + qliList);

        String str = ApexPages.CurrentPage().getParameters().get('strSerialVal');
        List<String> newIdOrder = str.split(',');
        //Update QLIs with Ordering #
        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
        for(Integer i = 0; i < newIdOrder.size(); i++)
        {
            QuoteLineItem qli = new QuoteLineItem();
            qli.Id = newIdOrder.get(i);
            qli.QuoteSolutionOrder__c = i;
            qlis.add(qli);
        }
        update qlis;
        setupQliWrappers();


        system.debug('new QLIS = ' + qliList);
    }
    
    public void updateDefaultSolution() {
        //we want to save the selected Solution Set as the default solution set
        try {
            selectedSolutionSets = (List<String>)JSON.deserialize(ApexPages.CurrentPage().getParameters().get('strSerialVal'),List<String>.class);
            String defaultSoln = selectedSolutionSets.get(0);
            setupQliWrappers();
            defaultSolutionSet = defaultSoln;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return;
        }
    }
    
    public void switchDefaultSolution(){
        try {
            String defaultSoln;
            List<Quote_Solutions__c> solutions = [SELECT Id, IsDefault__c FROM Quote_Solutions__c WHERE Quote__c = :quoteId];
            if(selectedSolutionSets.isEmpty() ){
                if(solutions.isEmpty()){
                    this.IsErrorOccurs = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No solution set exist in this quote. Please create new solution set'));
                    return;
                }else if( solutions.size() == 1){
                    defaultSoln = solutions[0].Id;
                }else{
                    this.IsErrorOccurs = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Default solution set missing. Please select any solution set to set it as default solution set'));
                    return;
                }
            }else{
                List<Quote_Solutions__c> solns = [
                    select Id 
                    from Quote_Solutions__c 
                    where Id IN : selectedSolutionSets
                ];
                // stale data
                if(selectedSolutionSets.size() != solns.size()) return;
                defaultSoln = selectedSolutionSets.get(0);
            }
            for(Quote_Solutions__c soln : solutions) {
                soln.IsDefault__c = soln.Id == defaultSoln;
            }
            update solutions;
            Quote q = new Quote(
                Id=quoteId,
                Default_Solution__c=defaultSoln
            );
            update q;
            this.IsErrorOccurs = false;
        } catch(Exception e) {
            this.IsErrorOccurs = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return;
        }
    }

    public List<String> getSelectedSolutionSets()
    {
        return selectedSolutionSets;
    }

    public void setSelectedSolutionSets(String s)
    {
        selectedSolutionSets = (List<String>)JSON.deserialize(s,List<String>.class);
        setupQliWrappers();
        updateDefaultSolution();
        system.debug('deserialized solution sets '+ selectedSolutionSets);
    }
    public PageReference actionFunction()
    {
        return null;
    }
    public void setupQliWrappers() {
        if((selectedSolutionSets == null || selectedSolutionSets.isEmpty()) 
           && String.isNotBlank(defaultSolutionSet)) {
            selectedSolutionSets = new List<String>{defaultSolutionSet};
        }
        //Set up Quote Line Items for display
        List<QuoteLineItem> qlis = [Select QuoteId, PricebookEntryId, Product_Cost2__c, Part_Number2__c, UnitPrice, Unit_net_price__c, Extended_Cost__c,
            TotalPrice, Margin__c, Long_Description__c, Product2.Name,Product2.Product_Line__c, Product2.Allow_Cost_Override__c,
            Product2.Salesforce_Product_Type__c, Part_Number__c, Product2Id,  Quantity, ListPrice, Line_Discount__c,
            Product2.NonDiscountable__c
            From QuoteLineItem
            WHERE Solution__c IN :selectedSolutionSets ORDER BY QuoteSolutionOrder__c ASC];

        qliList = new List<QuoteLineItemWrapper>();
        for(Integer i = 0; i < qlis.size(); i++) {
            if(qlis[i].Line_Discount__c != null) 
                qlis[i].Line_Discount__c = qlis[i].Line_Discount__c.setScale(2);
            qliList.add(new QuoteLineItemWrapper(qlis[i]));
        }
    }

    public List<SelectOption> getQuoteSolutions()
    {
        List<Quote_Solutions__c> qs = [SELECT Name, Parent_Solution__c,Quote__c from Quote_Solutions__c
                                        WHERE Quote__c = : quote.Id];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Select Solution Set'));
        for(Quote_Solutions__c q : qs)
        {
            options.add(new SelectOption(q.Id,q.name));
        }

        return options;
    }

    @RemoteAction
    global static Boolean findNumberQLIOnSolution(String solutionId) {
        try {
            List<QuoteLineItem> qlis = [SELECT Id from QuoteLineItem WHERE Solution__c = :solutionId];
            List<Quote_Solutions__c> childSolutionSets = [select Id from Quote_Solutions__c where Parent_Solution__c =: solutionId];
            Integer childCount = qlis.size()  + childSolutionSets.size();
            return childCount == 0;
        } catch(Exception e) {
            throw e;
        }
    }

    @RemoteAction
    global static String quoteSolutionsWithChildren(String quoteId) {
        List<Quote_Solutions__c> qsList = [
            SELECT Name, Total_Price__c, Total_Price_Parent__c, Total_List_Price__c, Total_List_Price_Parent__c, 
            Total_Discount_Amount__c, Optional__c,(SELECT id FROM Quote_Line_Items__r LIMIT 1), (SELECT Name, Total_List_Price__c, Total_Price__c, Total_Discount_Amount__c, Optional__c from Quote_Solutions__r ORDER BY Order__c ASC) 
            FROM Quote_Solutions__c WHERE Quote__c = :quoteId AND Parent_Solution__c = null Order BY Order__c ASC
        ];
        Set<Id> solutionIds = new Set<Id>();
        for(Quote_Solutions__c qs : qsList) {
            solutionIds.add(qs.Id);
            if(qs.Quote_Solutions__r != null) {
                for(Quote_Solutions__c childSolution : qs.Quote_Solutions__r) {
                    solutionIds.add(childSolution.Id);
                }
            }
        }
        List<QuoteLineItem> lineItems = [SELECT Id, TotalPrice, Extended_Cost__c, Margin__c, Solution__c, Solution__r.Parent_Solution__c FROM QuoteLineItem WHERE Solution__c IN :solutionIds];
        Map<String, Decimal> marginMap = new Map<String, Decimal>();
        Map<String, Decimal> parentMarginMap = new Map<String, Decimal>();
        Map<String, Decimal> numeratorsMap = new Map<String, Decimal>();
        Map<String, Decimal> denominatorsMap = new Map<String, Decimal>();
        for(Id solId : solutionIds) {
            Decimal nemo = 0, deno = 0;
            for(QuoteLineItem item : lineItems) {
                Decimal itemNemo = item.TotalPrice - item.Extended_Cost__c;
                Decimal itemDeno = item.TotalPrice;
                if(item.Solution__c == solId) {
                    nemo += itemNemo;
                    deno += itemDeno;
                }
                if(item.Solution__r.Parent_Solution__c == solId) {
                    if(numeratorsMap.get(solId) == null) {
                        numeratorsMap.put(solId, 0);
                        denominatorsMap.put(solId, 0);
                    }
                    numeratorsMap.put(solId, (numeratorsMap.get(solId) + itemNemo));
                    denominatorsMap.put(solId, (denominatorsMap.get(solId) + itemDeno));
                }
            }

            if(deno != 0) {
                Decimal temp = (nemo / deno) * 100;
                marginMap.put(solId, temp.setScale(2));
            } else {
                marginMap.put(solId, 0);
            }
            // override parent solution set margin
            if(numeratorsMap.containsKey(solId) && denominatorsMap.get(solId) != 0) {
                Decimal temp = (numeratorsMap.get(solId) / denominatorsMap.get(solId)) * 100;
                marginMap.put(solId, temp.setScale(2));
            }
        }

        JSONGenerator gen = JSON.createGenerator(false);
        if(qsList.size() > 0) {
            gen.writeStartArray();
            for(Quote_Solutions__c qs : qsList) {
                //Split between optional and normal
                if(qs.Optional__c == false) {
                    gen.writeStartObject();
                    gen.writeStringField('text',qs.Name);
                    gen.writeStringField('type','master');
                    gen.writeFieldName('a_attr');
                    gen.writeStartObject();
                    gen.writeStringField('style','font-size: 14px;');
                    if((!qs.Quote_Line_Items__r.isEmpty()) && (!qs.Quote_Solutions__r.isEmpty())){
                        gen.writeStringField('class','iconClass');
                    }
                    gen.writeEndObject();
                    // additional fields
                    gen.writeFieldName('data');

                    gen.writeStartObject();
                    Decimal temp = null;
                    if(qs.Quote_Solutions__r.size() > 0) {
                        // has child solution sets
                        temp = qs.Total_Price_Parent__c != null ? qs.Total_Price_Parent__c : 0;
                        temp = temp.setScale(2);
                        gen.writeStringField('total_price', String.valueOf(temp));
                        temp = qs.Total_List_Price_Parent__c != null ? qs.Total_List_Price_Parent__c : 0;
                        temp = temp.setScale(2);
                        gen.writeNumberField('total_list_price', temp);
                        gen.writeBooleanField('is_parent', true);
                    } else {
                        temp = qs.Total_Price__c != null ? qs.Total_Price__c : 0;
                        temp = temp.setScale(2);
                        gen.writeStringField('total_price', String.valueOf(temp));
                        temp = qs.Total_List_Price__c != null ? qs.Total_List_Price__c : 0;
                        temp = temp.setScale(2);
                        gen.writeNumberField('total_list_price', temp);
                        gen.writeBooleanField('is_parent', false);
                    }
                    temp = qs.Total_Discount_Amount__c != null ? qs.Total_Discount_Amount__c : 0;
                    temp = temp.setScale(2);
                    gen.writeNumberField('total_discount', temp);
                    gen.writeStringField('total_margin', String.valueOf(marginMap.get(qs.Id)));
                    gen.writeEndObject();

                    gen.writeStringField('id',qs.Id);
                    if(qs.Quote_Solutions__r.size() > 0) {
                        gen.writeFieldName('children');
                        gen.writeStartArray();
                        for(Quote_Solutions__c qsRelated : qs.Quote_Solutions__r) {
                            gen.writeStartObject();
                            gen.writeStringField('text',qsRelated.Name);
                            if(qsRelated.Optional__c) {
                                gen.writeStringField('type','optional');
                            } else {
                                gen.writeStringField('type','master');
                            }
                            gen.writeFieldName('a_attr');
                            gen.writeStartObject();
                            if(qsRelated.Optional__c) {
                                gen.writeStringField('data-color','red');
                            }
                            gen.writeEndObject();
                            // additional fields
                            gen.writeFieldName('data');
                            gen.writeStartObject();
                            temp = qsRelated.Total_Price__c != null ? qsRelated.Total_Price__c : 0.00;
                            temp = temp.setScale(2);
                            gen.writeStringField('total_price', String.valueOf(temp));
                            temp = qsRelated.Total_List_Price__c != null ? qsRelated.Total_List_Price__c : 0;
                            temp = temp.setScale(2);
                            gen.writeNumberField('total_list_price',temp);
                            temp = qsRelated.Total_Discount_Amount__c != null ? qsRelated.Total_Discount_Amount__c : 0.00;
                            temp = temp.setScale(2);
                            gen.writeNumberField('total_discount',temp);
                            gen.writeStringField('total_margin', String.valueOf(marginMap.get(qsRelated.Id)));
                            gen.writeBooleanField('is_parent', false);
                            gen.writeEndObject();
                            gen.writeStringField('id',qsRelated.Id);
                            gen.writeEndObject();
                        }
                        gen.writeEndArray();
                    }
                    gen.writeEndObject();
                } else {
                    gen.writeStartObject();
                    gen.writeStringField('text',qs.Name);
                    gen.writeStringField('type','optional');
                    gen.writeFieldName('a_attr');
                    gen.writeStartObject();
                    gen.writeStringField('data-color','red');
                    if((!qs.Quote_Line_Items__r.isEmpty()) && (!qs.Quote_Solutions__r.isEmpty())){
                        gen.writeStringField('class','iconClass');
                    }
                    gen.writeEndObject();
                    // additional fields
                    gen.writeFieldName('data');
                    gen.writeStartObject();
                    Decimal temp = null;
                    if(qs.Quote_Solutions__r.size() > 0) {
                        // has child solution sets
                        temp = qs.Total_Price_Parent__c != null ? qs.Total_Price_Parent__c : 0;
                        temp = temp.setScale(2);
                        gen.writeStringField('total_price', String.valueOf(temp));
                        temp = qs.Total_List_Price_Parent__c != null ? qs.Total_List_Price_Parent__c : 0;
                        temp = temp.setScale(2);
                        gen.writeNumberField('total_list_price',temp);
                        gen.writeBooleanField('is_parent', true);
                    } else {
                        temp = qs.Total_Price__c != null ? qs.Total_Price__c : 0;
                        temp = temp.setScale(2);
                        gen.writeStringField('total_price', String.valueOf(temp));
                        temp = qs.Total_List_Price__c != null ? qs.Total_List_Price__c : 0;
                        temp = temp.setScale(2);
                        gen.writeNumberField('total_list_price', temp);
                        gen.writeBooleanField('is_parent', false);
                    }
                    temp = qs.Total_Discount_Amount__c != null ? qs.Total_Discount_Amount__c : 0;
                    temp = temp.setScale(2);
                    gen.writeNumberField('total_discount',temp);
                    gen.writeStringField('total_margin', String.valueOf(marginMap.get(qs.Id)));
                    gen.writeEndObject();

                    gen.writeStringField('id',qs.Id);
                    if(qs.Quote_Solutions__r.size() > 0) {
                        gen.writeFieldName('children');
                        gen.writeStartArray();
                        for(Quote_Solutions__c qsRelated : qs.Quote_Solutions__r) {
                            gen.writeStartObject();
                            gen.writeStringField('text',qsRelated.Name);
                            if(qsRelated.Optional__c) {
                                gen.writeStringField('type','optional');
                            } else {
                                gen.writeStringField('type','master');
                            }
                            gen.writeFieldName('a_attr');
                            gen.writeStartObject();
                            if(qsRelated.Optional__c) {
                                gen.writeStringField('data-color','red');
                            }
                            gen.writeEndObject();
                            // additional fields
                            gen.writeFieldName('data');
                            gen.writeStartObject();
                            temp = qsRelated.Total_Price__c != null ? qsRelated.Total_Price__c : 0.00;
                            temp = temp.setScale(2);
                            gen.writeStringField('total_price', String.valueOf(temp));
                            temp = qsRelated.Total_List_Price__c != null ? qsRelated.Total_List_Price__c : 0;
                            temp = temp.setScale(2);
                            gen.writeNumberField('total_list_price',temp);
                            temp = qsRelated.Total_Discount_Amount__c != null ? qsRelated.Total_Discount_Amount__c : 0.00;
                            temp = temp.setScale(2);
                            gen.writeNumberField('total_discount',temp);
                            gen.writeStringField('total_margin', String.valueOf(marginMap.get(qsRelated.Id)));
                            gen.writeBooleanField('is_parent', false);
                            gen.writeEndObject();

                            gen.writeStringField('id',qsRelated.Id);
                            gen.writeEndObject();
                        }
                        gen.writeEndArray();
                    }
                    gen.writeEndObject();
                }
            }
            gen.writeEndArray();
        } else {
            return '';
        }
        return gen.getAsString();
    }
}