/*---------------------------------------------------------------------------------------------------------------
 Trigger         : Product_StandardPrice_AI
 Developed By    : Suraj Aluru
 CreateDate      : June 03, 2014.
 Description     : This after insert Trigger calls helper Products_StandardPrice_Helper class   
                   to create a standard pricebook entry on create.  
 
 *** Please add your comments below for change tracking ***
                     
-----------------------------------------------------------------------------------------------------------*/
trigger Product_StandardPrice_AI on Product2 (after insert,after update) {
    Products_StandardPrice_Helper helper = new Products_StandardPrice_Helper();
    if (Label.Product_AI == 'true') {
        if(Trigger.isAfter && Trigger.isInsert){
            helper.insertStdPrice(Trigger.new);
        }
        if(QuoteLineItemTriggerManager.ALLOWPRODUCTUPDATE){
            if(trigger.isAfter && Trigger.isUpdate){
                Products_StandardPrice_Helper.processPriceBookEntry(trigger.new,trigger.newMap);
            }
        }
    }
}