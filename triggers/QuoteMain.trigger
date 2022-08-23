trigger QuoteMain on Quote (before insert, before update,after update,after insert) {
     system.debug('QUOTE TRIGGER INVOCATION '+ ' BEFORE '+trigger.isBefore+' AFTER '+trigger.isAfter+' INSERT '+trigger.isInsert+' UPDATE '+trigger.isUpdate);
     if(QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS){
          QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = false;
          QuoteLineItemTriggerManager.ALLOWSUPPORTPRODENTRY = false;
        if(trigger.isInsert && trigger.isBefore){
            QuoteTriggerHelper.onBeforeDataValidations(trigger.new);
            QuoteTriggerHelper.OnBeforeInsertDataManipulations(trigger.new);
        }
        if(trigger.isUpdate && trigger.isBefore){
            QuoteTriggerHelper.onBeforeDataValidations(trigger.new);        
            QuoteTriggerHelper.onBeforeUpdateDataManipulation(trigger.new,trigger.oldMap);
        }
        if(trigger.isUpdate && trigger.isAfter){
            QuoteTriggerHelper.OnAfterUpdateDataManipulations(trigger.newMap, trigger.oldMap);
            QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = false;
            QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = false;
            QuoteLineItemTriggerManager.ALLOWSUPPORTPRODENTRY = false;
            QuoteTriggerHelper.processSupportProduct(trigger.new, trigger.oldMap);
            QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = false;
        }
        if(trigger.isInsert && trigger.isAfter){
            if(CopyReviseQuoteController.ALLOW_DEFAULT_SOLUTION)
	            QuoteTriggerHelper.insertDefaultSolution(trigger.new);
            QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = false;
        }
        //if(QuoteTriggerHelper.isPartnerUser())
     }
      if(trigger.isUpdate && trigger.isAfter){
          QuoteTriggerHelper.createTasksonQuote(trigger.newMap,trigger.oldMap);
      }
      if(trigger.isInsert && trigger.isAfter){
          
          //remove qlis from brand new quotes
          //if .Parent_Quote__c is populated then this is being revised or cloned and do not remove qlis
          QuoteLineTriggerHelper.quotesToCleanOfQLIS = new set<id>();
          for(Quote q : trigger.new){
              if(q.Parent_Quote__c==null && !Test.isRunningTest()){
                  QuoteLineTriggerHelper.quotesToCleanOfQLIS.add(q.Id);
              }
          }
          
          QuoteTriggerHelper.createTasksonQuote(trigger.newMap,null);
      }
}