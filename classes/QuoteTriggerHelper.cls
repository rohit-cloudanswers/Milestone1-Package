/*
    Modification History : Added by appshark for seperating support and proffesional Service change logic
    Date                 : 6th Nov-2014
    Modification History : commented some condtions to fix User story : Issue 10 
    Date                 : 12th Nov-2014
    Modification History : Appshark || 26th Dec 2014 || ISSUE 10: Defect on Indirect Quote with Tier Discount
                           replaced Tier_Discount__c field with Tier_Discount2__c in all areas. 
    
*/
public with sharing class QuoteTriggerHelper {
    public static void OnBeforeInsertDataManipulations(List<Quote> triggerNew){
        System.debug('Query Limit at the start:' + Limits.getQueries());
        list<Id> oppIds = new list<Id>();       
        map<String,Integer> mapOppIdVsQcount = new map<String,Integer>();
        map<String,list<Quote>> mapOppIdVsQList = new map<String,list<Quote>>();
        map<String,String> pbIdVsOppId = new map<String,String>();
        
        for(Quote eachQ : triggerNew){
            resetDiscounts(eachQ);
            oppIds.add(eachQ.OpportunityId);
        }
        
        // Appshark || 29th Dec 2014 || ISSUE 10: Defect on Indirect Quote with Tier Discount
        map<Id, Opportunity> mapOpportunity = new map<Id, Opportunity>([select Id, Partner_Name__r.Base_Discount__c from Opportunity where Id IN :oppIds And Partner_Name__c != null]); 
        //---
        
        list<Quote> qList = [Select id,Default_Price_Book__c,opportunityId from Quote where opportunityId in:oppIds order by lastModifiedDate asc];
        for(Quote eachQuote : qList){
            if(!mapOppIdVsQList.containsKey(eachQuote.opportunityId)){
                mapOppIdVsQList.put(eachQuote.opportunityId,new list<Quote>());
                list<Quote> qL = new list<Quote>();
                qL = mapOppIdVsQList.get(eachQuote.opportunityId);
                qL.add(eachQuote);
                mapOppIdVsQList.put(eachQuote.opportunityId,qL);
            }
            else{
                list<Quote> qL = new list<Quote>();
                qL = mapOppIdVsQList.get(eachQuote.opportunityId);
                qL.add(eachQuote);
                mapOppIdVsQList.put(eachQuote.opportunityId,qL);
            }
        }
        Map<Id,Opportunity> oList = new Map<Id,Opportunity>([select id,accountId,Billing_Address__c,Billing_Address__r.Id,Shipping_Address__c,Shipping_Address__r.Id from Opportunity where id in:oppIds]);        
        
        for(Quote eachQ : triggerNew){
             // Appshark || 29th Dec 2014 || ISSUE 10: Defect on Indirect Quote with Tier Discount
             if(( eachQ.Tier_Discount2__c == null || eachQ.Tier_Discount2__c == 0 ) && mapOpportunity.containsKey(eachQ.OpportunityId) )
                eachQ.Tier_Discount2__c = mapOpportunity.get(eachQ.OpportunityId).Partner_Name__r.Base_Discount__c;
             //--
            if(eachQ.Account_Lookup__c == null)
            {
                if(oList.get(eachQ.OpportunityId).accountId != null)
                {
                    eachQ.Account_Lookup__c = oList.get(eachQ.OpportunityId).accountId;
                }
            }
            if(eachQ.Billing_Address__c == null)
            {
                if(oList.get(eachQ.OpportunityId).Billing_Address__c != null)
                {                   
                    eachQ.Billing_Address__c = oList.get(eachQ.OpportunityId).Billing_Address__c;
                }
            }
            if(eachQ.Shipping_Address__c == null)
            {
                if(oList.get(eachQ.OpportunityId).Shipping_Address__c != null)
                {
                    eachQ.Shipping_Address__c = oList.get(eachQ.OpportunityId).Shipping_Address__c;
                }
            }
            if(mapOppIdVsQList.containsKey(eachQ.OpportunityId)){
                if(eachQ.Default_Price_Book__c != null && mapOppIdVsQList.get(eachQ.OpportunityId)[0].Default_Price_Book__c != null){
                    if(eachQ.Default_Price_Book__c != mapOppIdVsQList.get(eachQ.OpportunityId)[0].Default_Price_Book__c){
                        eachQ.addError('Default Pricebook should be same as the pricebook of the first quote.');
                    }
                    else{
                         pbIdVsOppId.put(eachQ.Default_Price_Book__c,eachQ.OpportunityId);
                    }
                }
            }
            else{
                 pbIdVsOppId.put(eachQ.Default_Price_Book__c,eachQ.OpportunityId);
            }
              
            if(eachQ.Default_Price_Book__c != null){
                eachQ.Pricebook2Id = eachQ.Default_Price_Book__c;
            }
            else if(Quote_PriceBook_Default__c.getInstance(userInfo.getUserId()).PriceBookId__c != null){
                eachQ.Pricebook2Id  = Quote_PriceBook_Default__c.getInstance(userInfo.getUserId()).PriceBookId__c;
            }
            else if(Quote_PriceBook_Default__c.getInstance(userInfo.getProfileId()).PriceBookId__c != null){
                eachQ.Pricebook2Id = Quote_PriceBook_Default__c.getInstance(userInfo.getProfileId()).PriceBookId__c;
            }
            
           /* else{
                eachQ.Default_Price_Book__c = mapOppIdVsQList.get(eachQ.OpportunityId)[0].Default_Price_Book__c;
            }*/
        }
        processOpportunityISO(pbIdVsOppId);
    }
    public static void processOpportunityISO(Map<String,String> pbIdVsOppId){
            if(pbIdVsOppId.size()>0){
                map<Id,Opportunity> oppMap = new map<Id,Opportunity>([Select id,CurrencyIsoCode from Opportunity where id in:pbIdVsOppId.values()]);
                map<Id,Pricebook2> pbMap = new map<Id,Pricebook2>([Select id,Currency_Code__c from Pricebook2 where id in:pbIdVsOppId.keySet()]);
                system.debug('-----pbIdVsOppId-------'+pbIdVsOppId);
                for(Pricebook2 each : pbMap.values()){
                     system.debug('-----each-------'+each);
                     system.debug('-----oppMap.get(pbIdVsOppId.get(each.Id))-------'+oppMap.get(pbIdVsOppId.get(each.Id)));
                    oppMap.get(pbIdVsOppId.get(each.Id)).CurrencyIsoCode = each.Currency_Code__c;
            }
            update oppMap.values();
        }
    }

    public static void resetDiscounts(Quote q){
        if(q.Additional_DIscount__c > 100) q.Additional_DIscount__c = 100;
        if(q.Hardware_Discount__c > 100) q.Hardware_Discount__c = 100;
        if(q.Software_Discount__c > 100) q.Software_Discount__c = 100;
        if(q.Service_Discount__c > 100) q.Service_Discount__c = 100;
        if(q.Support_Discount__c > 100) q.Support_Discount__c = 100;
        if(q.Managed_Services_Discount__c > 100) q.Managed_Services_Discount__c = 100;
        if(q.OEM_Hardware_Discount__c > 100) q.OEM_Hardware_Discount__c = 100;
        if(q.OEM_Software_Discount__c > 100) q.OEM_Software_Discount__c = 100;
        if(q.OEM_Professional_Services_Discount__c > 100) q.OEM_Professional_Services_Discount__c = 100;
        if(q.OEM_Support_Discount__c > 100) q.OEM_Support_Discount__c = 100;
        if(q.OEM_Managed_Services_Discount__c > 100) q.OEM_Managed_Services_Discount__c = 100;
    }

    public static void onBeforeUpdateDataManipulation(list<Quote> triggerNew,map<id,Quote> triggerOldMap){
        list<quoteLineItem> qList = new list<quoteLineItem>();
        list<String> qIds = new list<String>();
        list<String> oppIds = new list<String>();
        set<String> existingQids = new set<String>();
        map<String,list<Quote>> mapOppIdVsQList = new map<String,list<Quote>>();
        map<String,String> pbIdVsOppId = new map<String,String>();
        for(Quote each : triggerNew){
            resetDiscounts(each);
            if(each.Total_Extended_Cost__c == null)
            {
                each.Total_Extended_Cost__c = 0;
            }
            if(each.NEW_Grand_Total__c != 0 && each.NEW_Grand_Total__c != null)
            {
                //Etherios - this field should be deleted, its a formula field that just references TotalPrice
                each.Margin__c = ((each.NEW_Grand_Total__c - each.Total_Extended_Cost__c)/each.NEW_Grand_Total__c)*100;
            }
            else
            {
                each.Margin__c = 0;
            }
            qIds.add(each.Id);
            oppIds.add(each.OpportunityId);
        }
        
        // Appshark || 29th Dec 2014 || ISSUE 10: Defect on Indirect Quote with Tier Discount
        map<Id, Opportunity> mapOpportunity = new map<Id, Opportunity>([select Id, Partner_Name__r.Base_Discount__c from Opportunity where Id IN :oppIds And Partner_Name__c != null]); 
        //---
        
        list<Quote> quoteList = [Select id,Default_Price_Book__c,opportunityId from Quote where opportunityId in:oppIds order by lastModifiedDate asc];
        for(Quote eachQuote : quoteList){
            if(!mapOppIdVsQList.containsKey(eachQuote.opportunityId)){
                mapOppIdVsQList.put(eachQuote.opportunityId,new list<Quote>());
                list<Quote> qL = new list<Quote>();
                qL = mapOppIdVsQList.get(eachQuote.opportunityId);
                qL.add(eachQuote);
                mapOppIdVsQList.put(eachQuote.opportunityId,qL);
            }
            else{
                list<Quote> qL = new list<Quote>();
                qL = mapOppIdVsQList.get(eachQuote.opportunityId);
                qL.add(eachQuote);
                mapOppIdVsQList.put(eachQuote.opportunityId,qL);
            }
        }
        qList = [Select id,QuoteId from quoteLineItem where QuoteId in:qIds];
        for(quoteLineItem eachQLT : qList){
            existingQids.add(eachQLT.QuoteId);
        }
        for(Quote each : triggerNew)
        {
            // Appshark || 29th Dec 2014 || ISSUE 10: Defect on Indirect Quote with Tier Discount
             if(( each.Tier_Discount2__c == null || each.Tier_Discount2__c == 0 ) && mapOpportunity.containsKey(each.OpportunityId) )
                each.Tier_Discount2__c = mapOpportunity.get(each.OpportunityId).Partner_Name__r.Base_Discount__c;
             //--
            
            if (each.Default_Price_Book__c != triggerOldMap.get(each.id).Default_Price_Book__c){
                if(existingQids.contains(each.Id) || mapOppIdVsQList.get(each.OpportunityId).size()>1)
                    each.addError('Cannot update the default price book on the quote which has line items associated or if there are other quotes on this opportunity.');
                else{
                    if(each.Default_Price_Book__c != null)
                        each.Pricebook2Id = each.Default_Price_Book__c;
                    else if(Quote_PriceBook_Default__c.getInstance(userInfo.getUserId()).PriceBookId__c != null){
                        each.Pricebook2Id  = Quote_PriceBook_Default__c.getInstance(userInfo.getUserId()).PriceBookId__c;
                    }
                    else if(Quote_PriceBook_Default__c.getInstance(userInfo.getProfileId()).PriceBookId__c != null){
                        each.Pricebook2Id = Quote_PriceBook_Default__c.getInstance(userInfo.getProfileId()).PriceBookId__c;
                     }
                     pbIdVsOppId.put(each.Pricebook2Id,each.OpportunityId);
                }
            }
        } 
        //processOpportunityISO(pbIdVsOppId);
    }
    
    public static void OnAfterUpdateDataManipulations(Map<Id,Quote> triggerNewMap,Map<Id,Quote> triggerOldMap){
        Set<Id> quoteIds = new Set<Id>();
        for(Id qId : triggerNewMap.keySet()){
            Quote newQuote = triggerNewMap.get(qId);
            Quote oldQuote = triggerOldMap.get(qId);
            if(newQuote.Hardware_Discount__c != oldQuote.Hardware_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.Software_Discount__c != oldQuote.Software_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.Service_Discount__c != oldQuote.Service_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.Support_Discount__c != oldQuote.Support_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.Managed_Services_Discount__c != oldQuote.Managed_Services_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.Tier_Discount2__c != oldQuote.Tier_Discount2__c){
                quoteIds.add(qId);
            }
            if(newQuote.Additional_Discount__c != oldQuote.Additional_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.OEM_Hardware_Discount__c != oldQuote.OEM_Hardware_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.OEM_Software_Discount__c != oldQuote.OEM_Software_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.OEM_Professional_Services_Discount__c != oldQuote.OEM_Professional_Services_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.OEM_Support_Discount__c != oldQuote.OEM_Support_Discount__c){
                quoteIds.add(qId);
            }
            if(newQuote.OEM_Managed_Services_Discount__c != oldQuote.OEM_Managed_Services_Discount__c){
                quoteIds.add(qId);
            }
        }

        List<QuoteLineItem> updatedQuoteLineItems = new List<QuoteLineItem>();
        for(QuoteLineItem ql : [select Id, QuoteId, Discount, Line_Discount__c, Updated_At__c, Parent_Product_Type__c, Product_Type__c, Product_Cost2__c, Support_Product__c, Professional_Service_Product__c, Solution__c, Product2.NonDiscountable__c, Support_Discountable__c from QuoteLineItem where QuoteId in:quoteIds]){
            Boolean lineDiscountUpdated = false;
            Quote newQuote = triggerNewMap.get(ql.QuoteId);
            Quote oldQuote = triggerOldMap.get(ql.QuoteId);
            
            String qliProductType = ql.Product_Type__c;
            if(qliProductType != null) qliProductType = qliProductType.trim();

            if(ql.Product2.NonDiscountable__c == false) {
                if('OEM'.equals(ql.Product_Type__c)) {
                    ql.Line_Discount__c = newQuote.OEM_Discount__c; 
                } else {
                    if('Hardware'.equals(qliProductType)) {
                        if('OEM'.equals(ql.Parent_Product_Type__c)){
                            if(newQuote.OEM_Hardware_Discount__c != oldQuote.OEM_Hardware_Discount__c) {
                                ql.Line_Discount__c = newQuote.OEM_Hardware_Discount__c;
                                lineDiscountUpdated = true;
                            }
                        } else if(newQuote.Hardware_Discount__c != oldQuote.Hardware_Discount__c){
                            ql.Line_Discount__c = newQuote.Hardware_Discount__c;
                            lineDiscountUpdated = true;
                        }
                    }
                    if('Software'.equals(qliProductType)) {
                        if('OEM'.equals(ql.Parent_Product_Type__c)){
                            if(newQuote.OEM_Software_Discount__c != oldQuote.OEM_Software_Discount__c) {
                                ql.Line_Discount__c = newQuote.OEM_Software_Discount__c;
                                lineDiscountUpdated = true;
                            }
                        } else if(newQuote.Software_Discount__c != oldQuote.Software_Discount__c){
                            ql.Line_Discount__c = newQuote.Software_Discount__c;
                            lineDiscountUpdated = true;
                        }
                    }
                    if('Professional Services'.equals(qliProductType)) {
                        if('OEM'.equals(ql.Parent_Product_Type__c)){
                            if(newQuote.OEM_Professional_Services_Discount__c != oldQuote.OEM_Professional_Services_Discount__c){
                                ql.Line_Discount__c = newQuote.OEM_Professional_Services_Discount__c;
                                lineDiscountUpdated = true;
                            }
                        } else if(newQuote.Service_Discount__c != oldQuote.Service_Discount__c){
                            ql.Line_Discount__c = newQuote.Service_Discount__c;
                            lineDiscountUpdated = true;
                        }
                    }
                    if('Managed Services'.equals(qliProductType)) {
                        if('OEM'.equals(ql.Parent_Product_Type__c)){
                            if(newQuote.OEM_Managed_Services_Discount__c != oldQuote.OEM_Managed_Services_Discount__c){
                                ql.Line_Discount__c = newQuote.OEM_Managed_Services_Discount__c;
                                lineDiscountUpdated = true;
                            }
                        } else if(newQuote.Managed_Services_Discount__c != oldQuote.Managed_Services_Discount__c){
                            ql.Line_Discount__c = newQuote.Managed_Services_Discount__c;
                            lineDiscountUpdated = true;
                        }
                    }
                    if('Support'.equals(qliProductType)){
                        if('OEM'.equals(ql.Parent_Product_Type__c)){
                            if(newQuote.OEM_Support_Discount__c != oldQuote.OEM_Support_Discount__c){
                                ql.Line_Discount__c = newQuote.OEM_Support_Discount__c;
                                lineDiscountUpdated = true;
                            }
                        } else if(newQuote.Support_Discount__c != oldQuote.Support_Discount__c){
                            ql.Line_Discount__c = newQuote.Support_Discount__c;
                            if(ql.Support_Discountable__c == true) {
                                ql.SLA_Discount__c = newQuote.Support_Discount__c;
                                Decimal slaListPrice = ql.Annual_SLA_List_Price__c == null ? 0 : ql.Annual_SLA_List_Price__c;
                                ql.Annual_SLA_Net_Price__c = ql.SLA_Discount__c != null ? (slaListPrice - slaListPrice * (ql.SLA_Discount__c / 100)) : slaListPrice;
                            }
                            lineDiscountUpdated = true;
                        }
                    }
                }

                if(lineDiscountUpdated  || (newQuote.Tier_Discount2__c != oldQuote.Tier_Discount2__c ) || (newQuote.Additional_Discount__c != oldQuote.Additional_Discount__c)) {
                    ql.Discount = ql.Line_Discount__c == null ? 0 : ql.Line_Discount__c;
                    if(newQuote.Tier_Discount2__c != null){ 
                        if(ql.Professional_Service_Product__c == false && ql.Support_Product__c == false)
                            ql.Discount = ql.Discount + newQuote.Tier_Discount2__c; 
                    }
                    if(newQuote.Additional_DIscount__c != null){ 
                        ql.Discount = ql.Discount + newQuote.Additional_DIscount__c; 
                    }
                    if(ql.Discount > 100){
                        ql.Discount = 100;
                    }
                    ql.Updated_At__c = 'QuoteTrigger';
                    updatedQuoteLineItems.add(ql);
                }
            }
        }
        if(!updatedQuoteLineItems.isEmpty()){
            Database.update(updatedQuoteLineItems);
        }
        QuoteLineTriggerHelper.adjustRollupFields(updatedQuoteLineItems);
    }
    
    public static void createTasksonQuote(Map<Id,Quote> triggerNewMap,Map<Id,Quote> triggerOldMap){  
        System.debug('Query Limit at the start of createTasksonQuote:' + Limits.getQueries());
        List<Task> tasksToBeInserted = new List<Task>();
        Set<Id> validQuoteIds = new Set<Id>();
        Map<Id,String> quoteRegionsMap = new Map<Id,String>();
        Map<Id,String> quoteCountryMap = new Map<Id,String>();
        Map<Id,String> quoteAccountMap = new Map<Id,String>();
        Set<Id> quoteIds = new Set<Id>();
        Set<Id> accIds  = new Set<Id>();
        Set<Id> taskRelatedQuotes = new Set<Id>();
        for(Quote q:triggerNewMap.values())
        {
            Quote oldQuote = null;
            if(triggerOldMap != null){
                oldQuote = triggerOldMap.get(q.Id);
            }
            if((oldQuote == null || 
                oldQuote.Professional_Service_Requested__c != q.Professional_Service_Requested__c || 
                oldQuote.submit_to_ps__c != q.submit_to_ps__c || q.Status != oldQuote.status) &&
                (q.Professional_Service_Requested__c && q.submit_to_ps__c))
            {
                system.debug('I reached here');
                quoteIds.add(q.Id);
                quoteRegionsMap.put(q.Id,q.Ship_To_Region__c);
                quoteCountryMap.put(q.Id,q.Shipping_Country__c);
                system.debug('Accoount Id'+q.AccountId);
                accIds.add(q.AccountId);
            }
        }
        system.debug(accIds);
        for(Account acc: [select Id,Name from Account where Id IN: accIds])
        {
            quoteAccountMap.put(acc.Id,acc.Name);
        }
        system.debug('display quote Ids'+quoteIds);        
        if(quoteIds.isEmpty()){
            return;
        }
        if(!test.isRunningTest())
        {
            for (QuoteLineItem ql : [Select QuoteId,Product_Group__c From QuoteLineItem Where QuoteId in: quoteIds and Product_Group__c like 'Professional Services%' ]) {
                system.debug('Product_Group__c='+ql.Product_Group__c);
                validQuoteIds.add(ql.QuoteId);
            }
        }else
        {
            for (QuoteLineItem ql : [Select QuoteId,Product_Group__c From QuoteLineItem Where QuoteId in: quoteIds and Product_Type__c = 'Professional Services' ]) {
                system.debug('Product_Group__c='+ql.Product_Group__c);
                validQuoteIds.add(ql.QuoteId);
            }
        }        
        if(validQuoteIds.isEmpty()){
            return;
        }
        Map<Id,List<Task>> quoteToTaskMap = new Map<Id,List<Task>>();
        for (Task t : [Select Subject,WhatId,OwnerId,Region__c,PS_Activity_Type__c From Task Where WhatId in: validQuoteIds]) {
            if(!quoteToTaskMap.containsKey(t.WhatId)){
                quoteToTaskMap.put(t.WhatId,new List<Task>());
            }
            quoteToTaskMap.get(t.WhatId).add(t);
        }
        system.debug('task map'+quoteToTaskMap);
        Map<Id,Set<Id>> quoteIdToUserIdMap = getUsersinGroup(quoteRegionsMap);
        for(Id qId:quoteIdToUserIdMap.keySet())
        {
            for (Id uid:quoteIdToUserIdMap.get(qId))
            {
                Boolean projectTaskExist = false;
                Boolean serviceTaskExist = false;
                if(quoteToTaskMap.containsKey(qId))
                {
                    for(Task t: quoteToTaskMap.get(qId)){
                        system.debug('task values'+t.PS_Activity_Type__c+t.OwnerId+t.Region__c);
                        if(t.PS_Activity_Type__c=='ServiceValidation' && t.OwnerId == uid && t.Region__c == quoteRegionsMap.get(qId) ){
                            serviceTaskExist = true;
                        }
                        if(t.PS_Activity_Type__c=='Project' && t.OwnerId == uid && t.Region__c == quoteRegionsMap.get(qId) ){
                            projectTaskExist = true;
                        }
                    }
                }
                system.debug('task status'+serviceTaskExist+projectTaskExist);
                if(!serviceTaskExist && validQuoteIds.contains(qId)){
                    Task t = new Task(Subject = 'Service Validation by '+quoteCountryMap.get(qId), OwnerId = uid,Region__c=quoteRegionsMap.get(qId),PS_Activity_Type__c='ServiceValidation',WhatId = qId,ActivityDate = Date.valueOf(System.now()) + 1);
                    tasksToBeInserted.add(t);
                }
                if(triggerNewMap.get(qId).Status == 'Approved' && !projectTaskExist && validQuoteIds.contains(qId)){
                    String accName = 'Account';
                    if(quoteAccountMap.containsKey(triggerNewMap.get(qId).AccountId))
                    {
                        accName = quoteAccountMap.get(triggerNewMap.get(qId).AccountId);
                    }                   
                    Task t = new Task(Subject = 'Create Project For '+accName+' & '+quoteCountryMap.get(qId), OwnerId = uid,WhatId = qId,Region__c=quoteRegionsMap.get(qId),PS_Activity_Type__c='Project',ActivityDate = Date.valueOf(System.now()) +7);
                    tasksToBeInserted.add(t);           
                }                
            }
            boolean sowTaskExist = false;
            if(quoteToTaskMap.containsKey(qId))
            {
                for(Task t: quoteToTaskMap.get(qId)){
                    if(t.PS_Activity_Type__c=='SOW' && t.OwnerId == triggerNewMap.get(qId).CreatedById && t.Region__c == quoteRegionsMap.get(qId) ){
                        sowTaskExist = true;
                    }
                }
            }
            if(!sowTaskExist && validQuoteIds.contains(qId)){
                for (Id uid:quoteIdToUserIdMap.get(qId))//Etherios added
                {
                    Task t = new Task(Subject = 'Create SOW For Customer in '+quoteCountryMap.get(qId), OwnerId = uid,PS_Activity_Type__c='SOW',Region__c=quoteRegionsMap.get(qId),WhatId = qId,ActivityDate = Date.valueOf(System.now()) +7);
                    system.debug('tasks to be inserted create SOW '+t);
                    tasksToBeInserted.add(t);
                }   
            }
        } 
        insert tasksToBeInserted;
        System.debug('Query Limit at the end of createTasksonQuote:' + Limits.getQueries());
    }
    
    public static Map<Id,Set<Id>> getUsersinGroup(Map<Id,String> quoteRegionsMap){
        Map<Id,Set<Id>> quoteIdToUserIdMap = new Map<Id,Set<Id>>();    
        Map<Id,Id> groupIdToQuoteMap = new Map<Id,Id>();    
        for(Group g : [select Id,Name,DeveloperName from Group where Name like '%Professional%']){
            system.debug('regions'+quoteRegionsMap);
            for(Id quoteId : quoteRegionsMap.keySet()){
                 String region = quoteRegionsMap.get(quoteId);
                 system.debug('name and region'+g.Name+g.DeveloperName+region);
                 if(region!=null && region!='' && g.Name.startsWith(region)){
                    groupIdToQuoteMap.put(g.Id,quoteId);
                    break;
                 }
            }
        }
        String userType = Schema.SObjectType.User.getKeyPrefix();
        for(GroupMember m : [Select Id, UserOrGroupId,GroupId From GroupMember Where GroupId IN: groupIdToQuoteMap.keySet()])
        {
            if(!((String)m.UserOrGroupId).startsWith(userType)){
                continue;
            }
            Id quoteId = groupIdToQuoteMap.get(m.GroupId);
            if(!quoteIdToUserIdMap.containsKey(quoteId)){
                quoteIdToUserIdMap.put(quoteId,new Set<Id>());
            }
            quoteIdToUserIdMap.get(quoteId).add(m.UserOrGroupId);
        }        
        return quoteIdToUserIdMap;    
    }
      
    public static void processSupportProduct(list<Quote> triggerNew,map<Id,Quote> triggerOldMap){
        system.debug('ENTERING QUOTE PROCESS SUPPORT '+triggerNew);
        map<String,String> qIds = new map<String,String>();
        list<String> profQids = new list<String>();
        map<String,String> qIdsNew = new map<String,String>();
        list<String> profQidsNew = new list<String>();
        set<QuoteLineItem> tobeDeletedQitems = new set<QuoteLineItem>();
        list<QuoteLineItem> tobeDeletedQitemsList = new list<QuoteLineItem>();
        list<QuoteLineItem> qlItemsSupport = new list<QuoteLineItem>();
        list<QuoteLineItem> qlItemsprof = new list<QuoteLineItem>();
        //Etherios -- WTF is this, not bulkified
        String quoteId = trigger.new[0].Id;
        Boolean supportChanged = false;
        Boolean psChanged = false;
        if(triggeroldMap.get(triggerNew[0].Id).Support_Type__c != triggerNew[0].Support_Type__c)
        supportChanged = true;
        if(triggeroldMap.get(triggerNew[0].Id).Professional_Service_Requested__c != triggerNew[0].Professional_Service_Requested__c)
        psChanged = true;
        if(supportChanged || psChanged){
            qlItemsSupport = [Select id,Support_Product__c,Professional_Service_Product__c, Product_Cost2__c, Part_Number2__c,Solution__c from QuoteLineItem where quoteId=:quoteId and (Support_Product__c = true or Professional_Service_Product__c = true)];
            
            //added by appshark for seperating support and proffesional change logic
            list<QuoteLineItem> lstSupportProd = new list<QuoteLineItem>();
            list<QuoteLineItem> lstProffProd = new list<QuoteLineItem>();
            if( !qlItemsSupport.isEmpty() ){
                for( QuoteLineItem objQL : qlItemsSupport ){
                    if(objQL.Support_Product__c == true)
                        lstSupportProd.add(objQL);
                    else if(objQL.Professional_Service_Product__c == true)
                        lstProffProd.add(objQL);
                }
            }
            /* CloudAnswers 2016-10-14: do not delete products when changing type because manually calculated in some cases and don't want to delete those */
            /*
            if( supportChanged && !lstSupportProd.isEmpty() )
                delete lstSupportProd;
            if( psChanged && !lstProffProd.isEmpty() )
                delete lstProffProd;
            */
            
            qlItemsSupport = new list<QuoteLineItem>();
            qlItemsSupport = [Select id,Quote_CurrencyCode__c,quote.pricebook2id,UnitPrice,Quantity,PricebookEntryId,Support_Product__c,TotalPrice,Product_Line__c,Product_Type__c, Product_Cost2__c, Part_Number2__c, Solution_Optional__c, Solution__c,
                                        Support_Type_Text__c,Professional_Service_Requested__c,quoteId, Professional_Service_Product__c from QuoteLineItem where quoteId=:quoteId  and Support_Product__c = false];
            for(QuoteLineItem each: qlItemsSupport){
                each.Support_Type_Text__c = triggerNew[0].Support_Type__c;
                each.Professional_Service_Requested__c = triggerNew[0].Professional_Service_Requested__c;
            }
            update qlItemsSupport;
            //Etherios update here separate qli list into normal and optional
            List<QuoteLineItem> qliNormal = new List<QuoteLineItem>();
            List<QuoteLineItem> qliOptional = new List<QuoteLineItem>();
            for(QuoteLineItem qli : qlItemsSupport)
            {
                if(qli.Solution_Optional__c)
                    qliOptional.add(qli);
                else
                    qliNormal.add(qli);
            }
            //system.debug('---qlItemsSupport----'+qlItemsSupport.size());
            //system.debug('---qlItemsSupport----'+qlItemsSupport);
            //added by appshark for seperating support and proffesional change logic
            //Etherios update here separate qli list into normal and optional
            if( supportChanged ) 
            {
                QuoteLineTriggerHelper.insertSupportProduct(qliNormal,null,'fromHelper');
                QuoteLineTriggerHelper.insertSupportProductOptional(qliOptional,null, 'fromHelper');
            }
            if( psChanged )
            {
                QuoteLineTriggerHelper.insertProfServiceProduct(qliNormal,null,'fromHelper');
                QuoteLineTriggerHelper.insertProfServiceProductOptional(qliOptional,null, 'fromHelper');
            }
            //Etherios added, should requery after this
            qlItemsSupport = [Select id,Quote_CurrencyCode__c,quote.pricebook2id,UnitPrice,Quantity,PricebookEntryId,Support_Product__c,TotalPrice,Product_Line__c,Product_Type__c, Product_Cost2__c, Part_Number2__c, Solution_Optional__c, Solution__c,
                                Support_Type_Text__c,Professional_Service_Requested__c,quoteId from QuoteLineItem where quoteId=:quoteId];
            
            QuoteLineTriggerHelper.adjustRollupFields(qlItemsSupport);
        }
    }

    public static void onBeforeDataValidations(List<Quote> triggerNew){
        if(isPartnerUser())
        {
            Map<String,List<String>> pricebookNameMap = new Map<String,List<String>>();
            for(Pricebook2 pb:[SELECT Name,Pricebook_List_Values__c,Type__c FROM Pricebook2 where Type__c = 'Sales'])
            {
                if(!pricebookNameMap.containsKey(pb.Pricebook_List_Values__c))
                {
                    pricebookNameMap.put(pb.Pricebook_List_Values__c,new List<String>());
                }
                pricebookNameMap.get(pb.Pricebook_List_Values__c).add(pb.Name);
            }
            Map<Id,Account> accountMap = new Map<Id,Account>([select Id,Partner_Product_Prices__c from Account where IsPartner = true]);
            Map<Id,Pricebook2> pbMap = new Map<Id,Pricebook2>([SELECT Name,Pricebook_List_Values__c,Type__c FROM Pricebook2 where Type__c = 'Sales']);          
            for(Quote eachQ:triggerNew)
            {
                if(eachQ.Default_Price_Book__c != null)
                {
                    Set<String> selectedValues = new Set<String>();
                    Account acc = accountMap.get(eachQ.Partner_Name__c);
                    Pricebook2 selectedPb = pbMap.get(eachQ.Default_Price_Book__c);                 
                    //system.debug('account prices'+acc.Partner_Product_Prices__c);
                    if(acc != null){
                        if(acc.Partner_Product_Prices__c != null && acc.Partner_Product_Prices__c != '')
                        {
                            //split picklist into list
                            List<String> multiSelect = acc.Partner_Product_Prices__c.split(';', 0);
                            selectedValues.addAll(multiSelect);
                        }
                    }
                    system.debug(selectedValues);
                    if(selectedValues.isEmpty())
                    {
                        eachQ.Default_Price_Book__c.addError('The account associated does not have any pricebook for partners. Please associate a pricebook on the account');
                    }
                    else if(!selectedValues.contains(selectedPb.Pricebook_List_Values__c))
                    {
                        String pricebookNames = '';
                        for(String str:selectedValues)
                        {
                            for(String st:pricebookNameMap.get(str))
                            {
                                pricebookNames = pricebookNames + st + ' , ';
                            }
                        }
                        pricebookNames.removeEnd(','); 
                        eachQ.Default_Price_Book__c.addError('The selected pricebook is not available as per your partner agreement with Imagine Communications. Please use one of these available price books: '+pricebookNames);
                    }               
                }
            }
        }
    }
    
    public static Boolean isPartnerUser(){
        Id userId = UserInfo.getUserId();
        User u = [select Id,IsPortalEnabled from User where Id =:userId];
        return u.IsPortalEnabled;
    }
    public static void insertDefaultSolution(list<Quote> triggerNew){
        system.debug('Entering Default Solution Set create for Quote');
        list<Quote_Solutions__c> solList = new list<Quote_Solutions__c>();
        list<String> qIds = new list<String>();
        for(Quote eachQt : triggerNew){
            if(eachQt.Quote_Version__c <= 1){
                Quote_Solutions__c sol = new Quote_Solutions__c();
                sol.name = 'Default Solution Set';
                sol.Quote__c = eachQt.Id;
                sol.IsDefault__c = true;
                sol.isActive__c = true;
                solList.add(buildDefaultSolution(eachQt.Id));
                qIds.add(eachQt.Id);
            }
        }
        insert solList;
        updateQuoteDefaultSolution(qIds);
    }
    
    public static Quote_Solutions__c buildDefaultSolution(String quoteId){
        Quote_Solutions__c solution = new Quote_Solutions__c();
        solution.name = 'Default Solution Set';
        solution.Quote__c = quoteId;
        solution.IsDefault__c = true;
        solution.IsActive__c = true;
        return solution;
    }
    
    public static void updateQuoteDefaultSolution(list<String> qIds){
        system.debug('UPDATE QUOTE FUTURE');
        map<String,String> qtIdVsSolId = new map<String,String>();
        list<Quote_Solutions__c> qtSolList = [Select id,Quote__c from Quote_Solutions__c where Quote__c in:qIds and IsDefault__c = true];
        list<Quote> triggerNew = [Select id,Default_Solution__c from Quote where id in:qIds];
        for(Quote_Solutions__c eachQt : qtSolList){
            qtIdVsSolId.put(eachQt.Quote__c,eachQt.id);
        }
        for(Quote qt : triggerNew){
            qt.Default_Solution__c = qtIdVsSolId.get(qt.Id);
        } 
        update triggerNew;
    }   
}