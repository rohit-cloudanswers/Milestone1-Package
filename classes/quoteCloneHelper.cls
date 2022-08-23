/*
	 Modification History : Appshark || 29th Dec 2014 || ISSUE with PS Activites when cloning Quote 
	 						Tranfering parent Quote activities to cloned Quote
*/
global without sharing class quoteCloneHelper {
    webservice static string processClone(String parentId){
    	String oppId = [Select opportunityId from quote where id=:parentId limit 1].opportunityId;
    	system.debug('---oppId------'+oppId);
    	Decimal versionStamp = [Select Quote_Version__c from Quote where OpportunityId =:oppId order by createdDate desc limit 1].Quote_Version__c;
    	if(versionStamp == null)versionStamp = 0.0;
       // Integer versionStamp = [select count() from quote where Parent_Quote__c=:parentId];
        versionStamp++;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objectSchema= schemaMap.get('Quote');
        Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
        Set<String> fields = new Set<String>{'id', 'opportunityid'};
        for(String fieldName: fieldMap.keySet()) {
            if(fieldMap.get(fieldName).getDescribe().isUpdateable() && fieldMap.get(fieldName).getDescribe().isAccessible()){
                fields.add(fieldMap.get(fieldName).getDescribe().getName().toLowerCase());
            }
        }
        String query = 'select ' + String.join(new List<String>(fields), ',');
        query+=' From quote where id='+'\''+parentId+'\'';
        system.debug('------query-----'+query);
        Sobject q = database.query(query);
        Sobject cloneObj = objectSchema.newSObject();
        cloneObj = q.clone(false,false,false,false);
        cloneObj.put('Parent_Quote__c',parentId);
        cloneObj.put('Quote_Version__c',versionStamp);
        cloneObj.put('Default_Solution__c',null);
        cloneObj.put('Status','Draft');
        cloneObj.put('Submit_to_ps__c',false);
        try{
            system.debug('-----cloneObj-------'+cloneObj);
            QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = false;
            QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = false;
            insert cloneObj;
            list<Quote> newQuote = [Select id,QuoteNumber,name,Default_Solution__c from Quote where id=:cloneObj.Id];
            list<QuoteLineItem> qtLineItems = [Select id,Solution__c from quoteLineItem where QuoteId =:parentId];
            map<String,String> qtVsSolsId = new map<String,String>();
            for(QuoteLineItem each : qtLineItems){
                qtVsSolsId.put(each.id,each.Solution__c);
            }
            insertDefaultSolution(newQuote,qtVsSolsId,parentId);
            
            // Appshark || 29th Dec 2014 || Tranfering parent Quote activities to cloned Quote 
            Task[] lstTasks = [Select Id, WhatId From Task Where WhatId = :parentId AND Status != 'Completed'];
            if( !lstTasks.isEmpty() )
            {
				for (Task objTask : lstTasks) {
            		objTask.WhatId = cloneObj.Id;
            	}
            	update lstTasks;
            }
            //---
            
            //processRelatedList(parentId,cloneObj.Id);
            return cloneObj.Id;
        }catch(exception e){
            return 'Error Code :'+string.valueOf(e.getMessage());
        }
    }
    public static void insertDefaultSolution(list<Quote> triggerNew,map<String,String> mapping,String parentId){
        list<Quote_Solutions__c> solList = new list<Quote_Solutions__c>();
        list<String> qIds = new list<String>();
        for(Quote eachQt : triggerNew){
            Quote_Solutions__c sol = new Quote_Solutions__c();
            sol.name = eachQt.QuoteNumber+'-'+eachQt.name;
            sol.Quote__c = eachQt.Id;
            sol.IsDefault__c = true;
            sol.isActive__c = true;
            solList.add(sol);
            qIds.add(eachQt.Id);
        }
        insert solList;
        updateQuoteDefaultSolution(qIds[0],solList[0].Id,mapping,parentId);
    } 
    @future
    public static void updateQuoteDefaultSolution(String qIds,String solId,map<String,String> mapping,String parentId){
        map<String,String> qtIdVsSolId = new map<String,String>();
        list<Quote_Solutions__c> qtSolList = [Select id,Quote__c from Quote_Solutions__c where Quote__c =:qIds and IsDefault__c = true];
        list<Quote> triggerNew = [Select id,Default_Solution__c from Quote where id =:qIds];
        for(Quote_Solutions__c eachQt : qtSolList){
            qtIdVsSolId.put(eachQt.Quote__c,eachQt.id);
        }
        for(Quote qt : triggerNew){
            qt.Default_Solution__c = qtIdVsSolId.get(qt.Id);
        } 
        update triggerNew;
        list<Quote_Solutions__c> oldSols = [Select id,name,Parent_Solution__c,Coned_From__c,Quote__r.QuoteNumber,Quote__r.Default_Solution__c from Quote_Solutions__c where Quote__c =:parentId];
        list<Quote_Solutions__c> clonedSolutions = new list<Quote_Solutions__c>();
        map<String,String> oldSolVsNewSol = new map<String,String>();
        for(integer i=0;i<oldSols.size();i++){
            Quote_Solutions__c sol = new Quote_Solutions__c();
            sol.name = oldSols[i].Quote__r.QuoteNumber+'-'+oldSols[i].name;
            sol.Parent_Solution__c = solId ;
            sol.Quote__c = qIds;
            sol.Coned_From__c = oldSols[i].Id;
            clonedSolutions.add(sol);
        }
        insert clonedSolutions;
        for(Quote_Solutions__c each : [select id,Coned_From__c from Quote_Solutions__c where Quote__c =:qIds]){
            oldSolVsNewSol.put(each.Coned_From__c,each.id);
        }
        processRelatedList(parentId,qIds,mapping,oldSolVsNewSol);
    }

    public static void processRelatedList(String qId, String newQId, Map<String, String> mapping, Map<String, String> oldSolVsNewSol){
        Map<String, Schema.SObjectField> fieldMap = QuoteLineItem.sObjectType.getDescribe().fields.getMap();
        String query = 'select ';
        Set<String> fields = new Set<String>();
        fields.add('Id');
        fields.add('PricebookEntryId');
        for(String fieldName: fieldMap.keySet()) {
            DescribeFieldResult fieldResult = fieldMap.get(fieldName).getDescribe();
            if(fieldResult.isAccessible() && fieldResult.isUpdateable()){
                fields.add(fieldResult.getName());
            }
        } 
        query += String.join(new List<String>(fields), ',');
        query +=' from QuoteLineItem where QuoteId = '+ '\'' + qId + '\'';
        List<SObject> quoteLineItems = Database.query(query);
        List<SObject> newQuoteLineItems = new List<SObject>();
        for(SObject qli : quoteLineItems){
            SObject sObj = qli.clone(false, false);
            String solId = oldSolVsNewSol.get(mapping.get(qli.Id));
            sObj.put('Solution__c', solId);
            sObj.put('QuoteId', newQId);
            newQuoteLineItems.add(sObj);
        }
        insert newQuoteLineItems;
    }
}