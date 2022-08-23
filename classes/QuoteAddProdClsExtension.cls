public class QuoteAddProdClsExtension {
    public Quote theQuote {get;set;}
    public String searchString {get;set;}
    public quoteLineItem[] shoppingCart {get;set;}
    
    public priceBookEntry[] AvailableProducts {get;set;}
    public List<cPriceBookEntry> AvailableProducts2 {get;set;}    
    public Pricebook2 theBook {get;set;} 

    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    
    public Boolean overLimit {get;set;}
    public Boolean multipleCurrencies {get; set;}
    
    private Boolean forcePricebookSelection = false;
    
    private quoteLineItem[] forDeletion = new quoteLineItem[]{};
    
    Set<String> AccountProductLines = new Set<String>();

    //private set<string> partnerProdLines
    //opportunity_line_of_business
        
    public QuoteAddProdClsExtension(ApexPages.StandardController controller) {
        // Get information about the Quote being worked on
        theQuote = database.query('select Id, partner_name__c, partner_name__r.opportunity_line_of_business__c, Default_Price_Book__c, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Quote where Id = \'' + controller.getRecord().Id + '\' limit 1');
        
        if (theQuote.partner_name__r.opportunity_line_of_business__c != null && theQuote.partner_name__r.opportunity_line_of_business__c != '') {
             List<String> multiSelect = theQuote.partner_name__r.opportunity_line_of_business__c.split(';', 0);
            AccountProductLines.addAll(multiSelect);
        }
        // If products were previously selected need to put them in the "selected products" section to start with
        
        shoppingCart = [select Id,  Quantity, TotalPrice, UnitPrice, Description, PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.ProductCode, PriceBookEntry.Product2.Product_Line__c,PriceBookEntry.Product2.quotable__c, PriceBookEntry.PriceBook2Id from QuoteLineItem where QuoteId=:theQuote.Id];        

        // Check if Quote has a pricebook associated yet

        if(theQuote.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                //forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else{
            theBook = theQuote.Pricebook2;
        }        

        if(!forcePricebookSelection) {
            AvailableProducts2 = new List<cPriceBookEntry>();
            updateAvailableList();
        }    
    }

    public void updateAvailableList() {
        AvailableProducts2 = new List<cPriceBookEntry>();
        // We dynamically build a query string and exclude items already in the shopping cart
        String qString = 'select Id, Pricebook2Id, IsActive, Product2.ProductCode, Product2.Name, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice, Product2.Product_Line__c,Product2.quotable__c from PricebookEntry where IsActive=true and Product2.quotable__c =true and Pricebook2Id = \'' + theBook.Id + '\'';
        //if(multipleCurrencies)
            qstring += ' and CurrencyIsoCode = \'' + theQuote.get('currencyIsoCode') + '\'';
        
        // note that we are looking for the search string entered by the user in the name OR description
        // modify this to search other fields if desired
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\' or Product2.ProductCode like \'%' + searchString + '%\')';
        }
        
        Set<Id> selectedEntries = new Set<Id>();
        for(QuoteLineItem d:shoppingCart){
            selectedEntries.add(d.PricebookEntryId);
        }
        
        if(selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            qString+= extraFilter;
        }
        system.debug(AccountProductLines);
        if(AccountProductLines.isEmpty())   {
        } else {
            /*
            if(AccountProductLines.size()>0){
                String tempFilter = ' and product2.product_line__c in (';
                for(product2.product_line__c i : AccountProductLines){
                    tempFilter+= '\'' + (String)i + '\',';
                }
                String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
                extraFilter+= ')';
                
                qString+= extraFilter;
            }
            */
            String tempFilter = ' and product2.product_line__c IN :AccountProductLines';
            qString+= tempFilter;
        }      
        qString+= ' order by Product2.Name';
        qString+= ' limit 101';
        
        system.debug('RRR 1 qString:' +qString);        
        //AvailableProducts = database.query(qString);
        if(AccountProductLines.isEmpty())   {
        } else {
            List<PriceBookEntry> pbes = Database.query(qString);
            system.debug('RRR 2 pbes:' +pbes.size());   
             for(PriceBookEntry c: pbes) {
                 system.debug('RRR 3 c:' +c); 
                 AvailableProducts2.add(new cPriceBookEntry(c, false));
                 system.debug('RRR 3.1 AvailableProducts2.size:' +AvailableProducts2.size()); 
             }   
        } 
        // We only display up to 100 results... if there are more than we let the user know (see vf page)
        if(AvailableProducts2.size()==101){
            AvailableProducts2.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    public String getChosenCurrency(){
    
        //if(multipleCurrencies)
            return (String)theQuote.get('CurrencyIsoCode');
        //else
        //    return '';
    } 
    public void addToShoppingCart(){
    
        // This function runs when a user hits "select" button next to a product
        /*
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect){
                shoppingCart.add(new quoteLineItem(QuoteId=theQuote.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice));
                break;
            }
        }
        */
        try {
           // List<PriceBookEntry > selectedpbe = new List<PriceBookEntry>(); 
           system.debug('RRR 4 :'); 
            for(cPriceBookEntry cpbe: AvailableProducts2) {
                system.debug('RRR 5 cpbe.selected:' +cpbe.selected); 
                if(cpbe.selected == true) {
                    //System.debug('Update in3: ');
                    system.debug('RRR 6 theQuote.Id:' +theQuote.Id);
                    system.debug('RRR 7 cpbe.pbe:' +cpbe.pbe);
                    shoppingCart.add(new quoteLineItem(QuoteId=theQuote.Id, PriceBookEntry=cpbe.pbe, PriceBookEntryId=cpbe.pbe.Id, UnitPrice=cpbe.pbe.UnitPrice));
                    //selectedQuoteLineItems.add(cqli.qli);
                    cpbe.selected = false;
                }            
            }
        } catch(Exception ex){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,ex.getMessage())); 
        }        
        updateAvailableList();  
    }   
    public PageReference removeFromShoppingCart(){
    
        // This function runs when a user hits "remove" on an item in the "Selected Products" section
    
        Integer count = 0;
    
        for(quoteLineItem d : shoppingCart){
            if((String)d.PriceBookEntryId==toUnselect){
            
                if(d.Id!=null)
                    forDeletion.add(d);
            
                shoppingCart.remove(count);
                break;
            }
            count++;
        }
        
        updateAvailableList();
        
        return null;
    }  
    public PageReference onSave(){
    
        // If previously selected products are now removed, we need to delete them
        if(forDeletion.size()>0)
            delete(forDeletion);
    
        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
            if(shoppingCart.size()>0)
                upsert(shoppingCart);
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
           
        // After save return the user to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }    
    public PageReference onCancel(){
 
        // If user hits cancel we commit no changes and return them to the Opportunity   
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    public PageReference priceBookCheck(){
    
        // if the user needs to select a pricebook before we proceed we send them to standard pricebook selection screen
        if(forcePricebookSelection){        
            return changePricebook();
           return null;
        }
        else{
        
            //if there is only one active pricebook we go with it and save the opp
            if(theQuote.pricebook2Id != theBook.Id){
                try{
                    theQuote.Pricebook2Id = theBook.Id;
                    update(theQuote);
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                }
            }
            
            return null;
        }
    }         
    public PageReference changePricebook(){
    
        // This simply returns a PageReference to the standard Pricebook selection screen
        // Note that is uses retURL parameter to make sure the user is sent back after they choose
    
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theQuote.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theQuote.Id);
        
        return ref;
    } 

   public class cPriceBookEntry {
        public PriceBookEntry pbe {get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new cQuoteLine object we pass a QuoteLineItem that is set to the qlu property. We also set the selected value to false
        public cPriceBookEntry(PriceBookEntry c,Boolean selected) {
            pbe  = c;
            this.selected = selected;
        }
   }             
}