trigger RHX_SBQQ_Quote on SBQQ__Quote__c (after delete, after insert, after undelete, after update, before update, before delete) {
    
    if(Trigger.isAfter || (Trigger.isBefore && Trigger.isDelete)) {
        Type rollClass = System.Type.forName('rh2', 'ParentUtil');
        if(rollClass != null) {
            rh2.ParentUtil pu = (rh2.ParentUtil) rollClass.newInstance();
            if (Trigger.isAfter && !CPQQuoteHelper.hasRHRun) {
                CPQQuoteHelper.hasRHRun = true;
                pu.performTriggerRollups(trigger.oldMap, trigger.newMap, new String[]{'SBQQ__Quote__c'}, null);
            }
        }
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        // mark new quote as Primary if the Source quote is Primary and Source as non primary 
        Map<Id, SBQQ__Quote__c> clonedQuotes = new Map<Id, SBQQ__Quote__c>();
        for (SBQQ__Quote__c qt : Trigger.new) {
            if (qt.SBQQ__Source__c != null) {
                clonedQuotes.put(qt.SBQQ__Source__c, qt);
            } 
        }
        if (!clonedQuotes.keySet().isEmpty()) {
            // query source quotes
            Map<Id, SBQQ__Quote__c> sourceQuotes = new Map<Id, SBQQ__Quote__c>([
                select Id, SBQQ__Primary__c, SBQQ__Opportunity2__c, SBQQ__Opportunity2__r.SBQQ__PrimaryQuote__c from SBQQ__Quote__c where Id IN :clonedQuotes.keySet()
            ]);
            Map<Id, SBQQ__Quote__c> toPrimary = new Map<Id, SBQQ__Quote__c>();
            Map<Id, Opportunity> toUpdate = new Map<Id, Opportunity>();
            for (Id sourceId : clonedQuotes.keySet()) {
                SBQQ__Quote__c sourceQuote = sourceQuotes.get(sourceId);
                SBQQ__Quote__c clonedQuote = clonedQuotes.get(sourceId);
                if (sourceQuote != null && sourceQuote.SBQQ__Primary__c && 
                    sourceQuote.SBQQ__Opportunity2__c == clonedQuote.SBQQ__Opportunity2__c && 
                    sourceQuote.SBQQ__Opportunity2__r.SBQQ__PrimaryQuote__c == sourceQuote.Id) {
                    // TODO check approval status of source before making cloned the primary
                    CPQQuoteHelper.addOppToUpdate(toUpdate, sourceQuote.SBQQ__Opportunity2__c, clonedQuote.Id);
                    CPQQuoteHelper.addQuoteToUpdate(toPrimary, clonedQuote.Id);
                }
            }
            if(!toUpdate.isEmpty()) {
                Database.update(toPrimary.values(), false);
                Database.update(toUpdate.values(), false);
            }
        }
    }
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        // Handle Header Level Margin Updates
        Map<Id, Set<String>> quoteMarginUpdates = CPQQuoteHelper.getMarginFields(Trigger.oldMap, Trigger.newMap);
        Map<Id, Set<String>> quoteDiscountUpdates = CPQQuoteHelper.getDiscountFields(Trigger.oldMap, Trigger.newMap);
        if (quoteMarginUpdates.size() == 1 && quoteDiscountUpdates.size() == 1) {
            for (String key : quoteMarginUpdates.keySet()) {
                if (quoteDiscountUpdates.containsKey(key) && Trigger.newMap.containsKey(key)) {
                    Trigger.newMap.get(key).addError('Please update either header level discount or margin.');
                }
            }
        } else {
            CPQQuoteHelper.applyMarginByProductType(quoteMarginUpdates, Trigger.newMap);
            CPQQuoteHelper.applyDiscountByProductType(quoteDiscountUpdates, quoteMarginUpdates, Trigger.newMap);
        }
    }
}