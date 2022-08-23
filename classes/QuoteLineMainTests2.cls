/*
Modification History : Appshark || 26th Dec 2014 || ISSUE 10: Defect on Indirect Quote with Tier Discount
                       Replaced Tier_Discount__c field with Tier_Discount2__c in all areas. 
*/
@isTest(seeAllData = true)
public with sharing class QuoteLineMainTests2 {

    static testMethod void testQLIUpdate(){
        
        QuoteLineItem[] qlis = [select id from QuoteLineItem where PricebookEntry.IsActive = true and Product2.IsActive = true limit 1];
        QuoteLineItem qli;
        if(!qlis.isEmpty()) {
            qli = qlis[0];
        }
        system.assert(qli != null);

        qli.Quantity = 50;
        update qli;
    }

    static testMethod void testSolutionOptional(){
        
        QuoteLineItem[] qlis = [select id from QuoteLineItem where PricebookEntry.IsActive = true and Product2.IsActive = true and Solution_Optional__c = true and Quote.Software_Discount__c != null limit 1];
        QuoteLineItem qli;
        if(!qlis.isEmpty()) {
            qli = qlis[0];
        }
        system.assert(qli != null);

        QuoteLineItem newQLI = qli.clone();
        newQLI.Quantity = 1;
        newQLI.UnitPrice = 50.0;
        insert newQLI;
    }

    static testMethod void testSolutionNotOptional(){
        
        QuoteLineItem[] qlis = [select id from QuoteLineItem where PricebookEntry.IsActive = true and Product2.IsActive = true and Solution_Optional__c = false and Quote.Software_Discount__c != null limit 1];
        QuoteLineItem qli;
        if(!qlis.isEmpty()) {
            qli = qlis[0];
        }
        system.assert(qli != null);

        QuoteLineItem newQLI = qli.clone();
        newQLI.Quantity = 1;
        newQLI.UnitPrice = 50.0;
        insert newQLI;
    }

    public static Product_Class__c createProductClass(String productLine){
        Product_Class__c pClass = new Product_Class__c();
        pClass.Name = 'test';
        pClass.Product_Line__c = productLine;
        return pClass;
    }
 
    public  static QuoteLineItem createQuoteLineItem(Product_class__c productClass,Id quoteId , Id priceBookId, Integer quantity , Integer unitPrice){
        QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
        Product2 product = new Product2();
        product.Product_Cost__c = 50 ;
        product.Name = 'test';
        product.Salesforce_Product_Type__c = 'Hardware';
        product.Product_Class__c = productClass.Id;
        product.IsActive = true;
        product.CurrencyIsoCode = 'CAD';
        insert product;
        PricebookEntry pbe = new PricebookEntry();
        pbe.product2id = product.Id;
        pbe.pricebook2id = priceBookId;
        pbe.UnitPrice = unitPrice;
        pbe.IsActive = true;
        pbe.CurrencyIsoCode = 'CAD';
        insert pbe;
        QuoteLineItem item = new quotelineitem(); 
        item.pricebookentryid = pbe.id; 
        item.quantity = quantity; 
        item.unitprice = unitPrice;
        item.QuoteId = quoteId;
        return item;
    }
}