trigger QuoteLineMain on QuoteLineItem(before insert, before update, before delete, after insert, after update, after delete, after undelete){

    List<QuoteLineItem> triggerNewOptional = new List<QuoteLineItem>();
    List<QuoteLineItem> triggerNewNormal = new List<QuoteLineItem>();
    Map<Id,QuoteLineItem> triggerOldMapOptional = new Map<Id,QuoteLineItem>();
    Map<Id,QuoteLineItem> triggerOldMapNormal = new Map<Id,QuoteLineItem>();
    if(Trigger.new != null){
        for(QuoteLineItem qli : Trigger.new){
            if(qli.Solution_Optional__c == true){
                triggerNewOptional.add(qli);
                if(Trigger.oldMap != null && Trigger.oldMap.containsKey(qli.Id))
                    triggerOldMapOptional.put(qli.Id, Trigger.oldMap.get(qli.Id));
            } else{
                triggerNewNormal.add(qli);
                if(Trigger.oldMap != null && Trigger.oldMap.containsKey(qli.Id))
                    triggerOldMapNormal.put(qli.Id, Trigger.oldMap.get(qli.Id));
            }
        }
    }

    System.debug('@@ QuoteLineMain::ALLOWTRIGGERPROCESS => ' + QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS);
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            QuoteLineTriggerHelper.OnBeforeInsertDataManipulations(Trigger.new);
            QuoteLineItemTriggerManager.INITIALINSERT = true;
            if(QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS){
                QuoteLineTriggerHelper.updtSupportType(Trigger.new);
                QuoteLineTriggerHelper.updateSolutionSets(Trigger.new);
                QuoteLineTriggerHelper.updateQLIOrdering(Trigger.new);
                QuoteLineTriggerHelper.clearDiscountsWhereNotAllowed(Trigger.new);
            }
        } else if(Trigger.isUpdate){
            if(QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS){
                if(!QuoteLineItemTriggerManager.INITIALINSERT) {
                    QuoteLineTriggerHelper.OnBeforeUpdateDataManipulations(Trigger.newMap, Trigger.oldMap);
                }
                QuoteLineTriggerHelper.updateSolutionSets(Trigger.new);
                QuoteLineTriggerHelper.clearDiscountsWhereNotAllowed(Trigger.new);
            }
        } else if(Trigger.isDelete){
            if(QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS){
                QuoteLineTriggerHelper.clearSLAFields(Trigger.old);
            }
        }
    }
    
    System.debug('@@ In QuoteLineMain::ALLOWQUOTELINEUPDATE => ' + QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE);
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            if(QuoteLineItemTriggerManager.ALLOWSUPPORTPRODENTRY){
                if(triggerNewNormal.size() > 0){
                    QuoteLineTriggerHelper.insertSupportProduct(triggerNewNormal,triggerOldMapNormal, 'fromTrigger');
                    QuoteLineTriggerHelper.insertProfServiceProduct(triggerNewNormal,triggerOldMapNormal, 'fromTrigger');
                }
                if(triggerNewOptional.size() > 0){
                    QuoteLineTriggerHelper.insertSupportProductOptional(triggerNewOptional,triggerOldMapOptional, 'fromTrigger');
                    QuoteLineTriggerHelper.insertProfServiceProductOptional(triggerNewOptional,triggerOldMapOptional, 'fromTrigger');
                }
            }
            QuoteLineTriggerHelper.addProductLineText(trigger.new);
            QuoteLineTriggerHelper.adjustRollupFields(trigger.new);
            QuoteLineTriggerHelper.cleanQuotesofQLIs(trigger.new);
        } else if(Trigger.isUpdate){
            QuoteLineTriggerHelper.checkBlankSolution(trigger.new);
            if(QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE){
                if(triggerNewNormal.size() > 0){
                    QuoteLineTriggerHelper.insertSupportProduct(triggerNewNormal,triggerOldMapNormal, 'fromHelper');
                    QuoteLineTriggerHelper.insertProfServiceProduct(triggerNewNormal,triggerOldMapNormal, 'fromHelper');
                }
                if(triggerNewOptional.size() > 0){
                    QuoteLineTriggerHelper.insertSupportProductOptional(triggerNewOptional,triggerOldMapOptional, 'fromHelper');
                    QuoteLineTriggerHelper.insertProfServiceProductOptional(triggerNewOptional,triggerOldMapOptional, 'fromHelper');
                }
                QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = false;
            }
            
            if(!QuoteLineItemTriggerManager.INITIALINSERT && !QuoteLineTriggerHelper.hasRun){
                QuoteLineTriggerHelper.addProductLineText(Trigger.new);
                QuoteLineTriggerHelper.adjustRollupFields(Trigger.new);
                // Adjust rollups for old solution if solution set changed
                QuoteLineItem[] solutionChangedQLIs = new QuoteLineItem[]{};
                for(Id qliId : Trigger.newMap.keySet()) {
                    QuoteLineItem oldQLI = Trigger.oldMap.get(qliId);
                    if(oldQLI.Solution__c != Trigger.newMap.get(qliId).Solution__c) {
                        solutionChangedQLIs.add(oldQLI);
                    }
                }
                if(!solutionChangedQLIs.isEmpty()) {
                    QuoteLineTriggerHelper.adjustRollupFields(solutionChangedQLIs);
                }
            }
            // update at the end
            QuoteLineTriggerHelper.afterUpdateHandleSupportLineDiscountChange(Trigger.old, Trigger.newMap);
        } else if(Trigger.isDelete){
            QuoteLineTriggerHelper.adjustRollupFields(Trigger.old);
            QuoteLineItemTriggerManager2.adjustRollupCount++;
        } else if(Trigger.isUndelete){
            QuoteLineTriggerHelper.adjustRollupFields(Trigger.new);
        }
    }
    QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = false;
}