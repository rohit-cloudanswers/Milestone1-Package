/*
    Modificatoin history : Appshark || 7th Nov 1014 || User Story - Changing Quanity on PS and Care products || added line 106
*/
public with sharing class CustomQuoteLineItemEdit_Ctrl {
        //private list<quoteLineItemwrapper> wrapList;
        public QuoteLineItem newSol{get;set;}
        private String quoteId;
        public Boolean isEditable {get;set;}
        public list<quoteLineItemwrapper> WrapList {get;set;}
        
        public CustomQuoteLineItemEdit_Ctrl(apexpages.standardcontroller std){
            isEditable = true;
            quoteId = std.getId();
            wrapList = new list<quoteLineItemwrapper>();
            newSol =  new QuoteLineItem();
            newSol = [Select id,Solution__c,UnitPrice,Line_Discount__c,quantity,Long_Description__c from QuoteLineItem where quoteId =:quoteId limit 1];
            newSol.Solution__c = null;
            newSol.UnitPrice = null;
            newSol.Line_Discount__c = null;
            newSol.quantity = null;
            newSol.Long_Description__c = null;
            isEditable = Quote_LineItem_Bulkedit__c.getInstance(userInfo.getProfileId()).hasAccess__c;
            WrapList = new list<quoteLineItemwrapper>();
            processRecs();
        }
        
        /*public List<quoteLineItemwrapper> getWrapList(){
            list<QuoteLineItem> qlItemList = [Select Id, IsDeleted, LineNumber, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                    SystemModstamp, QuoteId, PricebookEntryId,PricebookEntry.name, Quantity, UnitPrice, Line_Discount__c, Discount, Description, ServiceDate, 
                                    SortOrder, ListPrice, Subtotal, TotalPrice,Long_Description__c,Solution__c,Solution__r.name from QuoteLineItem where QuoteId =:quoteId];
            wrapList.clear();
            for(QuoteLineItem each : qlItemList){
                quoteLineItemwrapper ql = new quoteLineItemwrapper(each,false);
                wrapList.add(ql);
            }
            return wrapList;
        }*/
        public void processRecs(){
            list<QuoteLineItem> qlItemList = [Select Id, IsDeleted, LineNumber, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                    SystemModstamp, QuoteId, PricebookEntryId,PricebookEntry.name, Quantity, UnitPrice, Line_Discount__c, Discount, Description, ServiceDate, 
                                    SortOrder, ListPrice, Subtotal, TotalPrice,Long_Description__c,Solution__c,Solution__r.name from QuoteLineItem where QuoteId =:quoteId and Professional_Service_Product__c = false and Support_Product__c = false];
            wrapList.clear();
            for(QuoteLineItem each : qlItemList){
                quoteLineItemwrapper ql = new quoteLineItemwrapper(each,false);
                wrapList.add(ql);
            }
        }
        public void processLineItems(){
            list<QuoteLineItem> qlItemList = [Select Id, IsDeleted, LineNumber, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                    SystemModstamp, QuoteId, PricebookEntryId,PricebookEntry.name, Quantity, UnitPrice, Line_Discount__c, Discount, Description, ServiceDate, 
                                    SortOrder, ListPrice, Subtotal, TotalPrice,Long_Description__c,Solution__c,Solution__r.name from QuoteLineItem where QuoteId =:quoteId and Professional_Service_Product__c = false and Support_Product__c = false];
            wrapList.clear();
            for(QuoteLineItem each : qlItemList){
                quoteLineItemwrapper ql = new quoteLineItemwrapper(each,false);
                wrapList.add(ql);
            }
        }
        public void processAutoLineItems(){
            list<QuoteLineItem> qlItemList = [Select Id, Professional_Service_Product__c ,Support_Product__c,IsDeleted, LineNumber, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                    SystemModstamp, QuoteId, PricebookEntryId,PricebookEntry.name, Quantity, UnitPrice, Line_Discount__c, Discount, Description, ServiceDate, 
                                    SortOrder, ListPrice, Subtotal, TotalPrice,Long_Description__c,Solution__c,Solution__r.name from QuoteLineItem where QuoteId =:quoteId and (Professional_Service_Product__c = true or Support_Product__c = true)];
            wrapList.clear();
            for(QuoteLineItem each : qlItemList){
                quoteLineItemwrapper ql = new quoteLineItemwrapper(each,false);
                wrapList.add(ql);
            }
        }
        public void updateList(){
            list<QuoteLineItem> qList = new list<QuoteLineItem>();
            for(quoteLineItemwrapper each:wrapList){
                if(each.isSelected){
                    if(newSol.Solution__c != null)
                    each.q.Solution__c = newSol.Solution__c;
                    if(newSol.UnitPrice != null)
                    each.q.UnitPrice = newSol.UnitPrice;
                    if(newSol.Line_Discount__c != null)
                    each.q.Line_Discount__c = newSol.Line_Discount__c;
                    if(newSol.quantity != null)
                    each.q.quantity = newSol.quantity;
                    if(newSol.Long_Description__c != null)
                    each.q.Long_Description__c = newSol.Long_Description__c;
                    qList.add(each.q);
                }
            }
            try{
                update qList;
                //Begin code by Appshark to fix : User Story - Changing Quanity on PS and Care products
                 if(qList[0].Professional_Service_Product__c == false && qList[0].Support_Product__c == false)
                    processRecs();//Added Appshark to fix : User Story - Changing Quanity on PS and Care products
                else
                    processAutoLineItems();
                    
                // End code
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.confirm,'Update successfull.'));
            }
            catch(exception e){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,e.getMessage()));
            }
        }
        public void SaveRecs(){
            list<QuoteLineItem> qList = new list<QuoteLineItem>();
            for(quoteLineItemwrapper each:wrapList){
                qList.add(each.q);
            }
            try{
                //QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = false;
                update qList;
                if(qList[0].Professional_Service_Product__c == false && qList[0].Support_Product__c == false)
                    processRecs();//Added Appshark to fix : User Story - Changing Quanity on PS and Care products
                else
                    processAutoLineItems();
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.confirm,'Update successfull.'));
            }
            catch(exception e){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,e.getMessage()));
            }
        }
        public class quoteLineItemwrapper{
            public QuoteLineItem q {get;set;}
            public Boolean isSelected {get;set;}
            public quoteLineItemwrapper(QuoteLineItem q,Boolean isSelected){
                this.q = q;
                this.isSelected = isSelected;
            }
        }
}