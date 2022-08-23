/*
    Date                 : 6th Nov-2014
    Modification History : Added by appshark to store additional and support/provisional discount on 6th Nov-2014
                           Added by appshark to populate default discount from Quote based on product type when Line Discount is empty on 7th Nov-2014
                           
    Date                 : 12th Nov-2014
    Modification History : Appshark added tierDisc to fix User story : Issue 10     
    
    Modification History : Appshark || 26th Dec 2014 || ISSUE 10: Defect on Indirect Quote with Tier Discount
                           Replaced Tier_Discount__c field with Tier_Discount2__c in all areas.

    Date         : 23 May, 2016
    Modification History : CloudAnswers
             : When there's only one QuoteLineItem and its moved or removed, update rollup fields on Quote Solution in that case as well.
    Date         : 23 May, 2017
    Modification History : CloudAnswers
             :  W-002785:-quote approval fields cleanup

*/
public without sharing class QuoteLineTriggerHelper {

  public static Boolean hasRun = false;
  public static Set<Id> quotesToCleanOfQLIS {get; set;}
  
  public static void cleanQuotesofQLIs(List<QuoteLineItem> newObjs){
    if(quotesToCleanOfQLIS != null && !quotesToCleanOfQLIS.isEmpty()){
      List<Id> toDelete = new List<Id>();
      for(QuoteLineItem qli : newObjs){
        if(quotesToCleanOfQLIS.contains(qli.quoteID)){
          toDelete.add(qli.Id);
        }
      }
      if(!toDelete.isEmpty()){
        Database.delete(toDelete);
        quotesToCleanOfQLIS = null;
      }
    }
  }

  public static void checkBlankSolution(List<QuoteLineItem> qli){
    for(QuoteLineItem q:qli){
      if(q.Solution__c == null){
        q.addError('Solution should not be null');
      }
    }
  }

  private static Map<Id, Product2> getProductsMap(List<QuoteLineItem> lineItems) {
    Set<String> keys = new Set<String>();
    for(QuoteLineItem qli : lineItems) {
      keys.add(qli.Product2Id);
    }
    return new Map<Id, Product2>([SELECT Id, NonDiscountable__c FROM Product2 WHERE Id IN :keys]);
  }
    
  public static void OnBeforeInsertDataManipulations(List<QuoteLineItem> triggerNew){
    System.debug('ENTERING BEFORE INSERT DATA MANIPULATIONS');
    //On insert, if line discount is null, get the quote discount based on the type and add it on line discount, updated at = quote.
    List<Id> quoteIds = new List<Id>();
    List<QuoteLineItem> lineItemsWithoutDiscount = new List<QuoteLineItem>();
    for(QuoteLineItem ql : triggerNew){
      quoteIds.add(ql.QuoteId);
    }
    // query quotes
    Map<Id, Quote> quoteMap = new Map<Id,Quote>([
      select Id, OEM_Hardware_Discount__c, OEM_Professional_Services_Discount__c, 
      OEM_Support_Discount__c, OEM_Software_Discount__c, OEM_Discount__c, 
      Hardware_Discount__c, Software_Discount__c, Service_Discount__c, 
      Support_Discount__c, Tier_Discount2__c, Additional_DIscount__c, 
      Managed_Services_Discount__c, OEM_Managed_Services_Discount__c 
      from Quote 
      where Id in :quoteIds 
    ]);
    // query products
    Map<Id, Product2> productsMap = getProductsMap(triggerNew);
    // apply discounts
    applyDiscountsByType(quoteMap, triggerNew, productsMap, true);
  }
    
  public static void OnBeforeUpdateDataManipulations(Map<Id,QuoteLineItem> triggerNewMap, Map<Id,QuoteLineItem> triggerOldMap){
    System.debug('ENTERING BEFORE UPDATE DATA MANIPULATIONS');
    System.debug('Trigger new before entering ' + triggerNewMap);
    List<Id> quoteIds = new List<Id>();
    List<QuoteLineItem> quoteLineItemsUpdated = new List<QuoteLineItem>();
    for(Id qlID : triggerNewMap.keySet()){
      QuoteLineItem newQuoteLineItem = triggerNewMap.get(qlID);
      QuoteLineItem oldQuoteLineItem = triggerOldMap.get(qlID);
      if(newQuoteLineItem.Product_Line__c != oldQuoteLineItem.Product_Line__c){
        newQuoteLineItem.Product_Line_Text__c = newQuoteLineItem.Product_Line__c;
      }
      quoteIds.add(newQuoteLineItem.QuoteId);
      if(!'QuoteTrigger'.equals(newQuoteLineItem.Updated_At__c)){
        newQuoteLineItem.Updated_At__c = 'QuoteLineItem';
        quoteLineItemsUpdated.add(newQuoteLineItem);
      } else if('QuoteTrigger'.equals(newQuoteLineItem.Updated_At__c)){
        newQuoteLineItem.Updated_At__c = 'Quote';
      }
    }
    Map<Id,Quote> quoteMap = new Map<Id,Quote>([select Id,Additional_DIscount__c,Tier_Discount2__c,Hardware_Discount__c,OEM_Hardware_Discount__c,OEM_Professional_Services_Discount__c,OEM_Support_Discount__c,OEM_Software_Discount__c,OEM_Discount__c,Service_Discount__c,Support_Discount__c,Software_Discount__c, Managed_Services_Discount__c, OEM_Managed_Services_Discount__c from Quote where Id in: quoteIds]);
    Map<Id, Product2> productsMap = getProductsMap(triggerNewMap.values());
    applyDiscountsByType(quoteMap, triggerNewMap.values(), productsMap, false);
  }

  private static void applyDiscountsByType(Map<Id, Quote> quotesMap, List<QuoteLineItem> lineItems, Map<Id, Product2> productsMap, Boolean isInsert){
    for(QuoteLineItem ql : lineItems){
      Quote q = quotesMap.get(ql.QuoteId);
      if(ql.Product_Line__c != null){
        ql.Product_Line_Text__c = ql.Product_Line__c;
      }
      if(ql.Solution_Optional__c == true)
        ql.Optional__c = true;
      else if(ql.Solution_Optional__c == false)
        ql.Optional__c = false;

      if((ql.Reset_Discounts__c == true && isInsert ) || !isInsert){
        Boolean discountable = productsMap.get(ql.Product2Id) != null && productsMap.get(ql.Product2Id).NonDiscountable__c == false;
        if(discountable && ql.Line_Discount__c == null){
          if(ql.Product_Type__c == 'OEM'){
            ql.Line_Discount__c = q.OEM_Discount__c;
          } else if(ql.Product_Type__c == 'Hardware'){
            if(ql.Parent_Product_Type__c == 'OEM'){
              ql.Line_Discount__c = q.OEM_Hardware_Discount__c;
            } else{
              ql.Line_Discount__c = q.Hardware_Discount__c;
            }
          } else if(ql.Product_Type__c=='Professional Services' ){
            if(ql.Parent_Product_Type__c == 'OEM'){
              ql.Line_Discount__c = q.OEM_Professional_Services_Discount__c;
            } else{
              ql.Line_Discount__c = q.Service_Discount__c;
            }
          } else if(ql.Product_Type__c == 'Support'){
            if(ql.Parent_Product_Type__c == 'OEM'){
              ql.Line_Discount__c = q.OEM_Support_Discount__c;
            } else{
              ql.Line_Discount__c = q.Support_Discount__c;
            }
          } else if(ql.Product_Type__c == 'Software'){
            if(ql.Parent_Product_Type__c == 'OEM'){
              ql.Line_Discount__c = q.OEM_Software_Discount__c;
            } else{
              ql.Line_Discount__c = q.Software_Discount__c;
            }
          } else if(ql.Product_Type__c == 'Managed Services'){
            if(ql.Parent_Product_Type__c == 'OEM'){
              ql.Line_Discount__c = q.OEM_Managed_Services_Discount__c;
            } else {
              ql.Line_Discount__c = q.Managed_Services_Discount__c;
            }
          }
        }
        // set discount
        ql.Discount = ql.Line_Discount__c == null ? 0 : ql.Line_Discount__c;
        // apply tier discount
        if(discountable && q.Tier_Discount2__c != null){ 
          // do not apply to support and professional service products
          if(ql.Product_Type__c != 'Support' && ql.Product_Type__c != 'Professional Services')
            ql.Discount = ql.Discount + q.Tier_Discount2__c; 
        }
        // apply additional discount
        if(discountable && q.Additional_DIscount__c != null){ 
          ql.Discount = ql.Discount + q.Additional_DIscount__c; 
        }
        // check discount
        if(ql.Line_Discount__c != null){
          ql.Updated_At__c = 'QuoteLineItem';
        }
      }
      if(ql.Discount > 100){
        ql.Discount = 100 ;
      }
    }
  }

  public static void clearDiscountsWhereNotAllowed (List<QuoteLineItem> triggerNew) {
    Map<Id, Product2> productsMap = getProductsMap(triggerNew);
    for(QuoteLineItem ql : triggerNew){
      Boolean discountable = productsMap.get(ql.Product2Id) != null && productsMap.get(ql.Product2Id).NonDiscountable__c == false;
      if (discountable != true && ql.Line_Discount__c != null && ql.Line_Discount__c > 0) {
        ql.Line_Discount__c = null;
      }  
    }
  }
    
  public static void updateQLIOrdering(List<QuoteLineItem> triggerNew){
    System.debug('ENTERING UPDATE QLI ORDERING');
    Set<Id> solutionSetIds = new Set<Id>();
    Map<Id, List<QuoteLineItem>> solutionToQLIs = new Map<Id,List<QuoteLineItem>>();
    for(QuoteLineItem qli : triggerNew){
      if(qli.Solution__c != null) {
        solutionSetIds.add(qli.Solution__c);
        if(solutionToQLIs.get(qli.Solution__c) == null){
          List<QuoteLineItem> temp = new List<QuoteLineItem>();
          temp.add(qli);
          solutionToQLIs.put(qli.Solution__c,temp);
        }else {
          solutionToQLIs.get(qli.Solution__c).add(qli);
        }
      }
    }
    List<AggregateResult> maxQs = [
      select MAX(QuoteSolutionOrder__c) max, Solution__c 
      from QuoteLineItem 
      where Solution__c IN :solutionSetIds GROUP BY Solution__c
    ];
    Map<Id, Integer> quoteSolutionToMaxOrder = new Map<Id, Integer>();
    for(AggregateResult ar : maxQs){
      if(ar.get('Solution__c') != null && ar.get('max') != null)
        quoteSolutionToMaxOrder.put((Id)ar.get('Solution__c'), ((Decimal)ar.get('max')).intValue());
    }
        
    for(Id solutionId : solutionToQLIs.keyset()){
      Integer newOrderNum = 0;
      if(quoteSolutionToMaxOrder.containsKey(solutionId)){
        if(quoteSolutionToMaxOrder.get(solutionId) > 0)
          newOrderNum = quoteSolutionToMaxOrder.get(solutionId)+1;

        for(Integer i = 0; i < solutionToQLIs.get(solutionId).size(); i++){
          solutionToQlis.get(solutionId).get(i).QuoteSolutionOrder__c = newOrderNum +i;
        }
      }
    }
  }

  public static void updateSolutionSets(list<QuoteLineItem> triggerNew){
    System.debug('ENTERING UPDATE SOLUTION SETS');
    list<String> solIds = new list<String>();
    list<String> qIds = new list<String>();
    map<String,String> solSetVsQuoteId = new map<String,String>();
    for(QuoteLineItem each : triggerNew){
      if(each.Solution__c != null)
        solIds.add(each.Solution__c);
      else
        qIds.add(each.QuoteId);
    }

    list<Quote_Solutions__c> solList = [Select id,Quote__c from Quote_Solutions__c where id in:solIds];
    map<Id,Quote> qMap = new map<Id,Quote>([Select id,Default_Solution__c from Quote where id in:qIds]);
    for(Quote_Solutions__c eachSol : solList){
      solSetVsQuoteId.put(eachSol.Id,eachSol.Quote__c);
    }

    for(QuoteLineItem each : triggerNew){
      if(each.QuoteId != solSetVsQuoteId.get(each.Solution__c) && each.Solution__c != null)
        each.Solution__c.addError('Solution does not belong to the current quote,please select a solution which belong to this quote.');
      else if(each.Solution__c == null)
        each.Solution__c =  qMap.get(each.quoteId).Default_Solution__c;
    }
  }
    
  private static Set<String> PRODUCT_LINE_TEXT_LIST = new Set<String>{
    'DOH',
    'MAM',
    'Automation',
    'Servers & Storage',
    'Editing & Graphics',
    'Integrated Playout',
    'Master Control',
    'Routers',
    'Signaling & Transcoding',
    'Command & Control',
    'Test & Measurement',
    'Professional Services',
    'Support'
  };

  private static Map<String,RollupSummaryWrapper> DEFAULT_MAP = new Map<String,RollupSummaryWrapper>();
  private static RollupSummaryWrapper DEFAULT_WRAPPER = new RollupSummaryWrapper(0,0,0);
  static {
    for(String productLineText : PRODUCT_LINE_TEXT_LIST){
      DEFAULT_MAP.put(productLineText,DEFAULT_WRAPPER);
    }
  }

    public static void addProductLineText(list<QuoteLineItem> triggerNew) {
        List<Id> quoteIds = new List<Id>();
        for(QuoteLineItem ql : triggerNew ){
          quoteIds.add(ql.quoteid);
        }

        map<Id,Quote> qMap = new map<Id,Quote>([Select id,Default_Solution__c from Quote where id in:quoteIds]);
         List<QuoteLineItem> updatedItems = new List<QuoteLineItem>();
         for(QuoteLineItem ql : [
            select Id, Product_Line__c, Product_Line_Text__c,quoteId,
            Business_Unit__c, Business_Unit_Copy__c, Solution__c,
            Net_List_Price_Currency__c, Net_List_Price_Currency_Support__c,
            Net_List_Price_Currency_PS__c, Net_List_Price_Currency_Software__c,
            Net_List_Price_Currency_Hardware__c, Professional_Service_Product__c,
            Solution_Optional__c, Solution_Optional_Copy__c,
            Product_Type__c, Product_Type_copy__c, Support_Product__c
            from QuoteLineItem 
            where Id in: triggerNew
          ]){
              ql.Product_Line_Text__c = ql.Product_Line__c;
              ql.Business_Unit_Copy__c = ql.Business_Unit__c;
              ql.Solution_Optional_Copy__c = ql.Solution_Optional__c;
              ql.Product_Type_copy__c = ql.Product_Type__c;
              if(ql.Solution__c == null){
                ql.Solution__c =  qMap.get(ql.quoteId).Default_Solution__c;
              }
              if(ql.Product_Type__c == 'Support') {
                ql.Net_List_Price_Currency_Support__c = ql.Net_List_Price_Currency__c;
                ql.Support_Product__c = true;
              } else if(ql.Product_Type__c == 'Professional Services'){
                ql.Net_List_Price_Currency_PS__c = ql.Net_List_Price_Currency__c;
                ql.Professional_Service_Product__c = true;
              } else if(ql.Product_Type__c == 'Software'){
                ql.Net_List_Price_Currency_Software__c = ql.Net_List_Price_Currency__c;
              } else if(ql.Product_Type__c == 'Hardware'){
                ql.Net_List_Price_Currency_Hardware__c = ql.Net_List_Price_Currency__c;
              } else if(ql.Product_Type__c == 'Managed Services'){
                ql.Net_List_Price_Currency_MS__c = ql.Net_List_Price_Currency__c;
              }
              updatedItems.add(ql);
         }
         if(!updatedItems.isEmpty()){
            hasRun = true;
            update updatedItems;
         }
    }
    /*
    * Etherios need to adjust this so the Total Cost does not include Optoinal Service Set Items,
        Etherios added totals to solution sets as well
    */
    public static void adjustRollupFields(list<QuoteLineItem> triggerNew){
      List<CurrencyType> currencyTypeList = [SELECT ISoCode, ConversionRate FROM CurrencyType];
      Map<String, Decimal> currencyMap = new Map<String,Decimal>();
      for(CurrencyType c : currencyTypeList) {
        currencyMap.put(c.IsoCode, c.ConversionRate);
      }
      //Etherios calculation for solution set
      Set<Id> quoteIds = new Set<Id>();
      Set<Id> solutionIds = new Set<Id>();
      Map<Id,Decimal> solutionToTotal = new Map<Id,Decimal>();
      Map<Id,Decimal> solutionToListTotal = new Map<Id,Decimal>();
      Map<Id,Decimal> solutionToTotalExtNet = new Map<Id,Decimal>();
      Map<Id,Decimal> solutionToTotalExtList = new Map<Id,Decimal>();
        
      for(QuoteLineItem qli : triggerNew) {
        quoteIds.add(qli.QuoteId);
        solutionIds.add(qli.Solution__c);
      }
      // create parent child map
      List<Quote_Solutions__c> quoteSolutions = [
        select Id, Parent_Solution__c 
        from Quote_Solutions__c 
        where Parent_Solution__c != null and Quote__c IN :quoteIds
      ];
      Map<String, String> childParentMap = new Map<String, String>();
      Map<Id,Decimal> parentSolutionToTotal = new Map<Id,Decimal>();
      Map<Id,Decimal> parentSolutionToListTotal = new Map<Id,Decimal>();
      Map<Id,Decimal> parentSolutionToTotalExtNet = new Map<Id,Decimal>();
      Map<Id,Decimal> parentSolutionToTotalExtList = new Map<Id,Decimal>();
      for(Quote_Solutions__c quoteSolution : quoteSolutions) {
        if(quoteSolution.Parent_Solution__c != null) {
          childParentMap.put(quoteSolution.Id, quoteSolution.Parent_Solution__c);
        }
      }

      Map<Id, Quote_Solutions__c> qsMap = new Map<Id,Quote_Solutions__c>([
        SELECT Id, Quote_Currency__c 
        FROM Quote_Solutions__c 
        WHERE Quote__c IN :quoteIds
      ]);

      for(AggregateResult ar : [SELECT Solution__c, SUM(TotalPrice) priceSum, SUM(Subtotal) listSum, SUM(Total_Extended_Net_Price__c) totExtNet, sum(Total_Extended_List_Price__c) totExtlist 
                                  FROM QuoteLineItem WHERE QuoteId IN :quoteIds group By Solution__c]){
        if((Id)ar.get('Solution__c')!= null){
          solutionToTotal.put((Id)ar.get('Solution__c'),(Decimal)ar.get('priceSum'));
          solutionToListTotal.put((Id)ar.get('Solution__c'),(Decimal)ar.get('listSum'));
          solutionToTotalExtList.put((Id)ar.get('Solution__c'),(Decimal)ar.get('totExtlist'));
          solutionToTotalExtNet.put((Id)ar.get('Solution__c'),(Decimal)ar.get('totExtNet'));
        }
      }

      // sum up values for parent solution sets
      for(Id solutionId : solutionToTotal.keySet()) {
        String parentSolutionId = childParentMap.get(solutionId);
        if(parentSolutionId != null) {
          // parent total price
          Decimal temp = parentSolutionToTotal.get(parentSolutionId);
          temp = temp == null ? solutionToTotal.get(solutionId) : (temp + solutionToTotal.get(solutionId));
          parentSolutionToTotal.put(parentSolutionId, temp);
          // parent total list price
          temp = parentSolutionToListTotal.get(parentSolutionId);
          temp = temp == null ? solutionToListTotal.get(solutionId) : (temp + solutionToListTotal.get(solutionId));
          parentSolutionToListTotal.put(parentSolutionId, temp);
          // parent total extended net price
          temp = parentSolutionToTotalExtNet.get(parentSolutionId);
          temp = temp == null ? solutionToTotalExtNet.get(solutionId) : (temp + solutionToTotalExtNet.get(solutionId));
          parentSolutionToTotalExtNet.put(parentSolutionId, temp);
          // parent total extended list price
          temp = parentSolutionToTotalExtList.get(parentSolutionId);
          temp = temp == null ? solutionToTotalExtList.get(solutionId) : (temp + solutionToTotalExtList.get(solutionId));
          parentSolutionToTotalExtList.put(parentSolutionId, temp);
        }
      }

      Map<Id, Quote_Solutions__c> solutionsToUpdateMap = new Map<Id, Quote_Solutions__c>();
      for(Id solutionId : solutionIds){
        if(String.isBlank(solutionId)) continue;
        // got valid solution id
        if(solutionToTotal.containsKey(solutionId)) {
          Quote_Solutions__c qs = new Quote_Solutions__c();
          qs.Id = solutionId;
          Decimal conversionRate = 1;
          if(qsMap != null && qsMap.containsKey(solutionId))
              conversionRate = currencyMap.get(qsMap.get(solutionId).Quote_Currency__c);
          qs.Total_Price__c = solutionToTotal.get(solutionId) * conversionRate;
          qs.Total_Extended_List_Price__c = solutionToTotalExtList.get(solutionId) * conversionRate;
          qs.Total_Extended_Net_Price__c = solutionToTotalExtNet.get(solutionId) * conversionRate;
          qs.Total_List_Price__c = solutionToListTotal.get(solutionId) * conversionRate;
          solutionsToUpdateMap.put(qs.Id, qs);
        } else {
          /* CloudAnswers: on removing the last QuoteLineItem from Quote, 
            the rollup fields on Quote Solution weren't updating, 
            so added this else block */
          Quote_Solutions__c qs = initQuoteSolution(solutionId);
          solutionsToUpdateMap.put(qs.Id, qs);
          if(childParentMap.containsKey(solutionId)){
            Id parentSolutionId = childParentMap.get(solutionId);
            solutionsToUpdateMap.put(parentSolutionId, initQuoteSolution(parentSolutionId));
          }
        }
      }
      // parent solution sets
      for(Id parentSolutionId : parentSolutionToTotal.keySet()) {
        Quote_Solutions__c qs = new Quote_Solutions__c();
        qs.Id = parentSolutionId;
        Decimal conversionRate = 1;
        if(qsMap != null && qsMap.containsKey(qs.Id))
            conversionRate = currencyMap.get(qsMap.get(qs.Id).Quote_Currency__c);
        qs.Total_Price_Parent__c = parentSolutionToTotal.get(qs.Id) * conversionRate;
        qs.Total_Price__c = null;
        qs.Total_List_Price_Parent__c = parentSolutionToListTotal.get(qs.Id) * conversionRate;
        qs.Total_List_Price__c = null;
        qs.Total_Extended_Net_Price_Parent__c = parentSolutionToTotalExtNet.get(qs.Id) * conversionRate;
        qs.Total_Extended_Net_Price__c = null;
        qs.Total_Extended_List_Price_Parent__c = parentSolutionToTotalExtList.get(qs.Id) * conversionRate;
        qs.Total_Extended_List_Price__c = null;
        solutionsToUpdateMap.put(qs.Id, qs);
      }

      if(solutionsToUpdateMap.size() > 0) update solutionsToUpdateMap.values();
      
      Map<Id,Map<String,RollupSummaryWrapper>> quoteUpdatesMap = new Map<Id,Map<String,RollupSummaryWrapper>>();
      for(QuoteLineItem ql : triggerNew ){
        if(!quoteUpdatesMap.containsKey(ql.QuoteId)){
          Map<String,RollupSummaryWrapper> newMap = new Map<String,RollupSummaryWrapper>();
          newMap.putAll(DEFAULT_MAP);
          quoteUpdatesMap.put(ql.QuoteId, newMap);
        }
      }

      Map<Id,Double> extMap = new Map<Id,Double>();
      Map<Id,Decimal> totalMap = new Map<Id,Decimal>();
      Map<Id,Decimal> listTotalMap = new Map<Id,Decimal>();
      Map<Id,Decimal> totalExtNetMap = new Map<Id,Decimal>();
      Map<Id,Decimal> TotalExtListMap = new Map<Id,Decimal>();
      //Etherios added here to exclude Optional QLI from the Query as we don't want optional QLIS to affect the total cost, added ADD clause
      for(AggregateResult q : [
        SELECT Product_Line_Text__c,QuoteId,sum(TotalPrice) total,sum(Subtotal) sub,sum(Extended_Cost__c) ext 
        FROM QuoteLineItem 
        where QuoteId IN: QuoteIds AND Optional__c = false group by QuoteId,Product_Line_Text__c]){

          RollupSummaryWrapper wrapper = new RollupSummaryWrapper((Double)q.get('total'),(Double)q.get('sub'),(Double)q.get('ext'));  
          Id quoteId = (Id)q.get('QuoteId');
          quoteUpdatesMap.get((Id)q.get('QuoteId')).put((String)q.get('Product_Line_Text__c'),wrapper);
      }
      
      for(AggregateResult q : [SELECT QuoteId,SUM(TotalPrice) total,SUM(Extended_Cost__c) ext, SUM(Subtotal) listTotal,
                               SUM(Total_Extended_Net_Price__c) totExtNet, sum(Total_Extended_List_Price__c) totExtlist
                                FROM QuoteLineItem
                                WHERE QuoteId IN :QuoteIDs
                                AND SOlution_Optional__c = false
                                GROUP BY QuoteId])
      {
          system.debug('ADJUST ROLLUP Aggregate Result for totals '+q);
          Id quoteId = (Id)q.get('QuoteId');
          if(!listTotalMap.containsKey(quoteId))
          {
            listTotalMap.put(quoteId,0);
          }
          listTotalMap.put(quoteId, listTotalMap.get(quoteId) + (Double)q.get('listTotal'));
          if(!extMap.containsKey(quoteId))
          {
            extMap.put(quoteId,0);
          }
          extMap.put(quoteId,extMap.get(quoteId) + (Double)q.get('ext'));
          if(!totalMap.containsKey(quoteId)){
            totalMap.put(quoteId,0);
          }
          totalMap.put(quoteId,totalMap.get(quoteId) + (Double)q.get('total'));
          if(!totalExtNetMap.containsKey(quoteId)){
            totalExtNetMap.put(quoteId,0);
          }
          totalExtNetMap.put(quoteId,totalExtNetMap.get(quoteId) + (Double)q.get('totExtNet'));
          if(!totalExtListMap.containsKey(quoteId)){
            totalExtListMap.put(quoteId,0);
          }
          totalExtListMap.put(quoteId,totalExtListMap.get(quoteId) + (Double)q.get('totExtlist'));
              
      }
      
      List<Quote> quotesToBeUpdated = new List<Quote>();
          
      for(Quote q : [select Id,
              Automation_Max_Margin__c, CurrencyISOCode,
              Command_Control_Max_Margin__c,
              DOH_Max_Margin__c,
              Editing_Graphics_Max_Margin__c,
              Integrated_Playout_Max_Margin__c,
              MAM_Max_Margin__c,
              Master_Control_Max_Margin__c,
              Routers_Max_Margin__c,
              Servers_Storage_Max_Margin__c,
              Service_Rate_Max_Margin__c,
              Signaling_Transcoding_Max_Margin__c,
              Support_Max_Margin__c,Total_Price__c, Sub_Total__c,
              Test_Measurement_Max_Margin__c,Total_Extended_Cost__c,Margin__c,NEW_Grand_Total__c,Sub_Total_Extended_Price__c  from Quote where Id in: quoteIds]){
          Boolean updated = false;
          
          Decimal newExtCost = 0;
          Decimal quoteConversionRate = currencyMap.get(q.CurrencyISOCode);
          decimal newTotExtList = 0;
          Decimal newTotExtNet = 0;
          
          if(totalExtListMap.containsKey(q.Id))
            newTotExtNet = totalExtListMap.get(q.Id);    
          if(q.Sub_Total_Extended_Price__c != newTotExtNet)
          {
            q.Sub_Total_Extended_Price__c = newTotExtNet * quoteConversionRate;
            system.debug('ADJUST ROLLUP Quote Sub Total Extended Net Cost'+q.Total_Extended_cost__C);
            updated = true;
          }
                  
          if(extMap.containsKey(q.Id))
            newExtCost = extMap.get(q.Id);    
          if(q.Total_Extended_Cost__c != newExtCost)
          {
            q.Total_Extended_Cost__c = newExtCost * quoteConversionRate;
            system.debug('ADJUST ROLLUP Quote Total Extended Cost'+q.Total_Extended_cost__C);
            updated = true;
          }
                  
          Decimal newTotalPrice = 0;
          if(totalMap.containsKey(q.Id))
            newTotalPrice = totalMap.get(q.Id);
         
          if(q.Total_Price__c != newTotalPrice)
          {
            q.Total_Price__c = newTotalPrice * quoteConversionRate;
            system.debug('ADJUST ROLLUP Quote Total Price'+q.Total_Price__c);
            updated = true;
          }
          Decimal newListTotal = 0;
          if(listTotalMap.containsKey(q.Id))
            newListTotal = listTotalMap.get(q.Id);
          if(q.Sub_Total__c != newListTotal)
          {
            q.Sub_Total__c = newListTotal * quoteConversionRate;
            system.debug('ADJUST ROLLUP Quote Total List Price'+q.Sub_Total__c);
            updated = true;
          }
          
          if(quoteUpdatesMap.containsKey(q.Id))
          {
            for(String productLineText : quoteUpdatesMap.get(q.Id).keySet()){
              //System.debug('22222ProductLineText: ' + productLineText);
              RollupSummaryWrapper summaryWrapper = quoteUpdatesMap.get(q.Id).get(productLineText);
              System.debug('Wrapper: ' + summaryWrapper.totalPrice + ',' + summaryWrapper.discountPrice + ',' + summaryWrapper.margin);
              if('DOH'.equals(productLineText) ){
                
                if(q.DOH_Max_Margin__c != summaryWrapper.margin){
                  q.DOH_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('MAM'.equals(productLineText) ){
                if(q.MAM_Max_Margin__c != summaryWrapper.margin){
                  q.MAM_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Automation'.equals(productLineText) ){
                if(q.Automation_Max_Margin__c != summaryWrapper.margin){
                  q.Automation_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Servers & Storage'.equals(productLineText) ){
                if(q.Servers_Storage_Max_Margin__c != summaryWrapper.margin){
                  q.Servers_Storage_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Editing & Graphics'.equals(productLineText) ){
                if(q.Editing_Graphics_Max_Margin__c != summaryWrapper.margin){
                  q.Editing_Graphics_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Integrated Playout'.equals(productLineText) ){
                if(q.Integrated_Playout_Max_Margin__c != summaryWrapper.margin){
                  q.Integrated_Playout_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Master Control'.equals(productLineText) ){
                if(q.Master_Control_Max_Margin__c != summaryWrapper.margin){
                  q.Master_Control_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Routers'.equals(productLineText) ){
                if(q.Routers_Max_Margin__c != summaryWrapper.margin){
                  q.Routers_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Signaling & Transcoding'.equals(productLineText) ){
                if(q.Signaling_Transcoding_Max_Margin__c != summaryWrapper.margin){
                  q.Signaling_Transcoding_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }            
              if('Command & Control'.equals(productLineText) ){
                if(q.Command_Control_Max_Margin__c != summaryWrapper.margin){
                  q.Command_Control_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Test & Measurement'.equals(productLineText) ){
                if(q.Test_Measurement_Max_Margin__c != summaryWrapper.margin){
                  q.Test_Measurement_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Professional Services'.equals(productLineText) ){
                if(q.Service_Rate_Max_Margin__c != summaryWrapper.margin){
                  q.Service_Rate_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
              if('Support'.equals(productLineText) ){
                if(q.Support_Max_Margin__c != summaryWrapper.margin){
                  q.Support_Max_Margin__c = summaryWrapper.margin;
                  updated = true;
                }
              }
          }          
        }
        if(updated){
          quotesToBeUpdated.add(q);

        }
      }
      if(!quotesToBeUpdated.isEmpty()){
        
        //This is commentted because we created Margin2__c formula filed by appshark on 14th Nov-2014 
        /*
        set<Id> setQuoteId = new set<Id>();
        for( Quote q : quotesToBeUpdated ){
            setQuoteId.add(q.Id);
        }
        list<QuoteLineItem> lstQL = [select id,TotalPrice,QuoteId from QuoteLineItem where QuoteId in : setQuoteId];
        map<Id,Decimal> mapQuoteTotal = new map<Id,Decimal>();
        for( QuoteLineItem objQL : lstQL){
            decimal tot = 0;
            if( mapQuoteTotal.get(objQL.QuoteId)!=null )
                tot = mapQuoteTotal.get(objQL.QuoteId);
            tot+=objQL.TotalPrice;
            mapQuoteTotal.put(objQL.QuoteId,tot);
        }
        for( Quote q : quotesToBeUpdated){
            decimal newGrandTotal =  (mapQuoteTotal.get(q.Id)!=null)? mapQuoteTotal.get(q.Id) : 0;
            if(newGrandTotal ==0 )
                q.Margin__c = 0.00;
            else if( q.Total_Extended_Cost__c != null )
                q.Margin__c = ((newGrandTotal - q.Total_Extended_Cost__c)/newGrandTotal)*100;
            else 
                q.Margin__c = ((newGrandTotal)/newGrandTotal)*100;
        }*/
        update quotesToBeUpdated;
      }
    }

    public static Quote_Solutions__c initQuoteSolution(Id solutionId){
      Quote_Solutions__c qs = new Quote_Solutions__c();
      qs.Id = solutionId;
      qs.Total_Price__c = null;
      qs.Total_Price_Parent__c = null;
      qs.Total_List_Price__c = null;
      qs.Total_List_Price_Parent__c = null;
      qs.Total_Extended_List_Price__c = null;
      qs.Total_Extended_List_Price_Parent__c = null;
      qs.Total_Extended_Net_Price__c = null;
      qs.Total_Extended_Net_Price_Parent__c = null;
      return qs;
    }
    
    public class RollupSummaryWrapper {
      public Double totalPrice;
      public Double margin;
      public Double discountPrice;
      public RollupSummaryWrapper(Double totalPrice, Double discountPrice, Double margin){
        if(discountPrice != null && discountPrice!=0)
        {
            this.discountPrice = (1 - (totalPrice/discountPrice))*100;
        }
        else if(discountPrice == null){
            this.discountPrice =0;
        }
        if(totalPrice!=0)
        {
            this.margin = (1 - (margin/totalPrice))*100;
        }else
        {
            this.margin = 0;
        }
        this.totalPrice = totalPrice;
      }
    }
    //Etherios investigate can this just be a formula field?
    public static void updtSupportType(list<QuoteLineItem> triggerNew){
        list<String> quoteIds = new list<String>();
        for(QuoteLineItem each : triggerNew){
            quoteIds.add(each.quoteId);
        }
        map<Id,Quote> qMap = new map<Id,Quote>([Select id,Support_Type__c,Professional_Service_Requested__c from Quote where id in:quoteIds]);
        for(QuoteLineItem each : triggerNew){
            if(qMap.get(each.quoteId).Support_Type__c != null)
            each.Support_Type_Text__c = qMap.get(each.quoteId).Support_Type__c;
            if(qMap.get(each.quoteId).Professional_Service_Requested__c != null)
            each.Professional_Service_Requested__c = qMap.get(each.quoteId).Professional_Service_Requested__c;
        }
    }
    
    public static void insertSupportProduct(list<QuoteLineItem> triggerNew, Map<Id,QuoteLineItem> triggerOldMap, String source){
              system.debug('ENTERING INSERT SUPPORT NORMAL ');
      list<String> pLine = new list<String>();
      list<String> pType = new list<String>();
      list<String> sType = new list<String>();
      set<String> prodIds = new set<String>();
      list<String> quoteIds = new list<String>();
      set<QuoteLineItem> tempList = new set<QuoteLineItem>();
      list<Service_Line_Matrix__c> matrixList = new list<Service_Line_Matrix__c>();
      list<QuoteLineItem> toBeInsertedQItems = new list<QuoteLineItem>();
      map<String,Service_Line_Matrix__c> compStringToSupportProd = new map<String,Service_Line_Matrix__c>();
      map<String,Decimal> qIdVsProd = new map<String,Decimal>();
      map<String,String> prodIdVsISO = new map<String,String>();
      //Added by Etherios to track add Cost % from the Service Line Matrix
      Map<Id,Decimal> prodToCost = new Map<Id,Decimal>();
      //Added by Etherios to track QLI to Solution Set, QLI to all solution sets with QLI computed Id string, Id string is (prod type + prod line + support type)
      Map<String,List<Id>> prodToQlis = new Map<String,List<Id>>();
      //etherios added qutoeId to quote Map
      Map<Id,Product2> pMap = new Map<Id,Product2>();
      
      system.debug('-------triggerNew-------'+triggerNew);
      system.debug('-------triggerOldMap-------'+triggerOldMap);
      for(QuoteLineItem each : triggerNew){
        //system.debug('$$$$$$$$$$$'+each);
        if(each.Support_Type_Text__c != null && each.Support_Type_Text__c != '' && each.Professional_Service_Product__c == false && each.Support_Product__c == false){
          pLine.add(each.Product_Line__c);
          pType.add(each.Product_Type__c);
          sType.add(each.Support_Type_Text__c);
          quoteIds.add(each.QuoteId);
        }
      }
      map<Id,Quote> qMap = new map<Id,Quote>([Select id,Support_Type__c,Professional_Service_Requested__c from Quote where id in:quoteIds]);
      if(quoteIds.size()>0){
          system.debug('----quoteIds-----'+quoteIds);
          map<Id,QuoteLineItem> qlItems = new map<Id,QuoteLineItem>([Select id,Quote_CurrencyCode__c,UnitPrice,Quantity,quote.Default_Solution__c, Product_Cost2__c,Part_Number2__c, Solution__c, Solution_Optional__c, 
                                                                                                            quote.pricebook2id,PricebookEntryId,Support_Product__c,TotalPrice,Product_Line__c,
                                                                                                            Product_Type__c,Professional_Service_Product__c,Support_Type_Text__c,quoteId,
                                                                                                            Line_Discount__c,Long_Description__c,pricebookentry.Product2Id,Quote.Id,Quote.Additional_DIscount__c,Quote.Support_Discount__c,Quote.Service_Discount__c,Quote.Tier_Discount2__c
                                                                                                            from QuoteLineItem where quoteId in:quoteIds AND Solution_Optional__c = false]);
          system.debug('******qlItems******'+qlItems);
          map<Id,Quote> qIdVsDefSol = new map<Id,Quote>([Select id,Default_Solution__c from quote  where id in:quoteIds]);
          String prodIdFromQuote = '';
          if(qlItems.size()==0){
            String pbeId = triggerNew[0].PricebookEntryId;
            prodIdFromQuote = [Select pricebook2id from pricebookEntry where id=:pbeId limit 1].pricebook2id;
          }
          else{
            prodIdFromQuote = qlItems.values()[0].quote.pricebook2id;
          }
          
          
          //if(source != 'fromDel')
         // if(source == 'fromTrigger')
         //tempList.addAll(triggerNew);
          //if(source == 'fromTrigger' || source == 'fromDel')
          tempList.addAll(qlItems.values());
          
          //Etherios added - need to prune this tempList for Quote Line Items in which Solution_Optional__c = false
          /*
          for(QuoteLineItem temp : tempList)
          {
            if(temp.Solution_Optional__c == true)
                tempList.remove(temp);
          }
          */
          //Etherios need to prune templsit of trigger items in which the QLI Unit Price, LineDiscount, or Quantity has changed
          if(triggeroldmap != null && triggeroldMap.size() != 0 && tempList != null) //Always process on insert quote line item
          {
              for(QuoteLineItem temp : tempList)
              {
                if(!((temp.UnitPrice != null && triggerOldMap.get(temp.Id) != null && temp.UnitPrice != triggerOldMap.get(temp.Id).UnitPrice) ||
                ((temp.Line_Discount__c !=null && triggerOldMap.get(temp.Id) != null && temp.Line_Discount__c != triggerOldMap.get(temp.Id).Line_Discount__c)) ||
                ((temp.Quantity !=null && triggerOldMap.get(temp.Id) != null && temp.Quantity != triggerOldMap.get(temp.Id).Quantity))
                 ))
                {   
                    tempList.remove(temp);
                }
              }
          }
          
          
          
          system.debug('*********tempList*******'+tempList);
          
          //added by appshark to store additional and support/provisional discount
           map<String,QuoteLineItem> mapQuoteToDiscoutInfo = new map<String,QuoteLineItem>();
           for(QuoteLineItem eachRec : tempList){
            mapQuoteToDiscoutInfo.put(eachRec.Quote.Id,eachRec);
            //system.debug('---eachRec.UnitPrice----'+eachRec.UnitPrice);
            //system.debug('----eachRec1---'+eachRec.Support_Product__c+'------'+eachRec.Professional_Service_Product__c);
           }
           system.debug('----11111------'+pType+'------'+pLine+'-----'+sType);
          matrixList = [Select Percent_of_Line_Total_Product_Line__c,Product_Line__c,Product_Type__c,Professional_Service_Product__c, Cost_Percent__c,
                                Support_Product__c,Support_Type__c from Service_Line_Matrix__c  where Product_Line__c in:pLine 
                                and Product_Type__c in:pType and Support_Type__c in:sType];
          system.debug('*******matrixList*********'+matrixList);
          if(matrixList.size()>0){
              for(Service_Line_Matrix__c eachRec : matrixList){
                //mapping cost percentage
                prodToCost.put(eachRec.Support_Product__c, eachRec.Cost_Percent__c);
                compStringToSupportProd.put(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type__c,eachRec);
              }
              for(QuoteLineItem eachRec : tempList){
                if(eachRec.Support_Type_Text__c != null && eachRec.Support_Type_Text__c != '' && eachRec.Support_Product__c == false && eachRec.Professional_Service_Product__c ==false){
                    system.debug('----eachRec---'+eachRec.Support_Product__c+'------'+eachRec.Professional_Service_Product__c);
                  if(compStringToSupportProd.containsKey(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type_Text__c)){
                    String prodId = compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type_Text__c).Support_Product__c;
                    //Etherios added prod to list of qlis
                    if(prodToQlis.containsKey(prodId))
                        prodToQlis.get(prodId).add(eachRec.Id);
                    else
                    {
                        List<Id> tempIdList = new List<Id>();
                        tempIdList.add(eachRec.Id);
                        prodToQlis.put(prodId,tempIdList);                      
                    }
                    Decimal disc = compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type_Text__c).Percent_of_Line_Total_Product_Line__c;
                     system.debug('*******disc*********'+disc);
                    prodIdVsISO.put(prodId,eachRec.Quote_CurrencyCode__c);
                    prodIds.add(prodId);
                    //Etherios added, get cost % from serivce line matrix and put in map as well as disc null checks below, addded etting cost percentage up top
                   // if(compStringToSupportProd.containsKey(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type__c))
                    //  prodToCost.put(prodId,compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c).Cost_Percent__c);
                    if(!qIdVsProd.containsKey(eachRec.QuoteId+'~'+prodId)){
                           // system.debug('----eachRec.UnitPrice------'+eachRec.UnitPrice);
                            //system.debug('----eachRec.Quantity------'+eachRec.Quantity);
                        if(disc==null){
                            disc = 0;
                        }
                        
                        if(eachRec!=null && eachRec.QuoteId!=null && eachRec.UnitPrice!=null && eachRec.Quantity!=null){
                            qIdVsProd.put(eachRec.QuoteId+'~'+prodId,(eachRec.UnitPrice*eachRec.Quantity*disc)/100);
                        }
                    }
                    else{
                        try{
                            Decimal tAmount = qIdVsProd.get(eachRec.QuoteId+'~'+prodId);
                            //system.debug('*******tAmount*********'+tAmount);
                            qIdVsProd.put(eachRec.QuoteId+'~'+prodId,tAmount+((eachRec.UnitPrice*eachRec.Quantity*disc)/100));
                        } catch (exception e){}
                    }
                  }
                }
              }
              //Etherios -- Create product map
              pMap = new Map<Id,Product2>([SELECT Product_Type__c, Product_Line__c from Product2 WHERE Id IN :prodIds]);
              
                system.debug('Product to Cost Percentage'+prodToCost);
              
               system.debug('*******qIdVsProd*********'+qIdVsProd);
              list<Pricebookentry> pbeList = new list<Pricebookentry>();
              map<String,pricebookentry> pbVsPbe = new map<String,pricebookentry>();
              list<QuoteLineItem> toBeDeletedQitems = new list<QuoteLineItem>();
              pbeList = [SELECT Id, Name,Pricebook2Id, Pricebook2.isStandard, Product2Id, CurrencyIsoCode from pricebookentry where product2Id in:prodIds and Pricebook2Id =:prodIdFromQuote and isActive = true ];
              if(pbeList.size()==0){
                  for(String eachProd : prodIds){
                        pricebookentry pbe = new pricebookentry();
                        pbe.product2Id = eachProd;
                        pbe.Pricebook2Id = prodIdFromQuote;
                        //pbe.UseStandardPrice = true;
                        pbe.UnitPrice = 1;
                        pbe.CurrencyIsoCode = prodIdVsISO.get(eachProd);
                        pbe.IsActive = true;
                        pbeList.add(pbe);
                  }
                  system.debug('-------pbeList-----'+pbeList);
                  insert pbeList;
              }
              system.debug('-------pbeList-----'+pbeList);
              for(pricebookentry each : pbeList){
                pbVsPbe.put(each.Product2Id,each);
              }
              system.debug('-------pbVsPbe-----'+pbVsPbe);
              for(QuoteLineItem each : qlItems.values()){
                for(String eachQuote : qIdVsProd.keySet()){
                    if(pbVsPbe.ContainsKey(eachQuote.split('~')[1]))
                    if(each.QuoteId == eachQuote.split('~')[0] && each.PricebookEntryId == pbVsPbe.get(eachQuote.split('~')[1]).Id && each.Support_Product__c){
                        //For any QLI in trigger new that are optional only delete teh support and PS products of any related support and service products that are optional as well
                        /*if(each.Solution_Optional__c)
                        {
                            for(QuoteLineItem qli : triggerNew)
                            {
                                if(qli.Solution_Optional__c)
                                {
                                    if(qli.Product_Line__c == each.Product_Line__c && qli.Product_Type__c == each.Product_Type__c && qli.Support_Type_Text__c == each.Support_Type_Text__c)
                                        toBeDeletedQitems.add(each);
                                }
                            }
                        }
                        else*/
                        toBeDeletedQitems.add(each);
                    }
                }
              }
              for(String each : qIdVsProd.keySet()){
                QuoteLineItem ql = new QuoteLineItem();
                ql.QuoteId = each.split('~')[0];
                String pbeId='';
                Id Product2Id;
                system.debug('-------each.split()[1] -----'+each.split('~')[1]);
                system.debug('-------prodIdVsISO.get(each.split()[1])-----'+prodIdVsISO);
                for(pricebookentry eachPBE : pbeList){
                    system.debug('-------eachPBE.Product2Id -----'+eachPBE.Product2Id);
                     system.debug('-------eachPBE.CurrencyIsoCode-----'+eachPBE.CurrencyIsoCode);
                    if(eachPBE.Product2Id == each.split('~')[1] && eachPBE.CurrencyIsoCode == prodIdVsISO.get(each.split('~')[1])){
                        pbeId = eachPBE.Id;
                        Product2Id = eachPBE.Product2Id;
                        //Set Cost Percent here if Prod is found
                        system.debug('PRODUCT COST PERCENTAGE set '+prodToCost.get(each.split('~')[1]));
                        ql.Cost_Percent__c = prodToCost.get(each.split('~')[1]);
                    }
                }
                if(pbeId != ''){
                    //Etherios changed to null and before trigger will assign to highest order solution instead, changed back
                    ql.Solution__c = qIdVsDefSol.get(each.split('~')[0]).Default_Solution__c;
                    ql.PricebookEntryId = pbeId;
                    ql.UnitPrice = qIdVsProd.get(each);
                    ql.Quantity = 1;
                    ql.Support_Product__c = true;
                    ql.Professional_Service_Product__c = false;
                    
                    //Begin code added by appshark to add Quantity, Line Discount, Long Description, Discount
                    system.debug('-------Product2Id-----'+Product2Id);
                    QuoteLineItem objQL = mapQuoteToDiscoutInfo.get(each.split('~')[0]);
                    decimal addiotnalDisc = (objQL.Quote.Additional_DIscount__c!=null)? objQL.Quote.Additional_DIscount__c : 0;
                    decimal supportDisc = (objQL.Quote.Support_Discount__c!=null)? objQL.Quote.Support_Discount__c : 0;
                    //Etherios added Tier discounts do not apply to support and professional service products
                    //decimal tierDisc = (objQL.Quote.Tier_Discount2__c!=null)? objQL.Quote.Tier_Discount2__c : 0;
                    
                    ql.discount = addiotnalDisc;
                    if( supportDisc!=null  )
                        ql.Line_Discount__c = supportDisc;
                    
                    //Etherios added Boolean deleted found.  This means that the new Support/PS product added is replacing one deleted
                    //If not found then case is Quote is going from no support to care or care +
                    Boolean found = false;
                    system.debug('TO BE DELETED QLIS '+toBeDeletedQitems);
                    system.debug('QL CURRENTLY ON '+ql);
                    for( QuoteLineItem qlDel : toBeDeletedQitems ){ 
                        system.debug(qlDel.Id+'************'+qlDel.pricebookentry.Product2Id+'<------->'+Product2Id); 
                        if( Product2Id!=null && Product2Id == qlDel.pricebookentry.Product2Id ){
                            found = true;
                            system.debug('****** QL DEL *******'+qlDel);
                            ql.Quantity = qlDel.Quantity;
                            ql.Line_Discount__c = (qlDel.Line_Discount__c!=null)?qlDel.Line_Discount__c:ql.Line_Discount__c; // overrides the Line discount copied from Quote if manually provided
                            ql.Long_Description__c = qlDel.Long_Description__c;
                            //Etherios needs to add here, override ProductCost2,Part number 2, Unit Price as well
                            ql.Part_Number2__c = qlDel.Part_Number2__c;
                            //Etherios added, Business case is need to override product cost IF the support item is part of trigger new(is changed)
                            //ql.UnitPrice = qlDel.UnitPrice;
                            //ql.Product_Cost2__c = qlDel.Product_Cost2__c;
                            ql.Solution__c = qlDel.Solution__c;
                        }
                    }
                    system.debug('PROD TO QLI MAP '+prodToQlis);
                    //Etherios added if triggerOld is null(coming from Quote update) then get Solution Set from QLI origination
                    //If this is replacing one then don't need to do this, we can just Solution to what it was before
                    if(triggerOldMap == null && found == false)
                    {
                        Id tempQLIId = prodToQlis.get(Product2Id).remove(0);
                        ql.Solution__c = qlItems.get(tempQLIId).Solution__c;
                    }
                    system.debug('QL Solution Set '+ql.Solution__c);
                    system.debug('-------ql.Line_Discount__c--2---'+ql.Line_Discount__c);
                    // Modification History: Appshark added tierDisc to fix User story : Issue 10
                    //Etherios added Tier discounts do not apply to support and professional service products
                    //ql.discount = ql.discount + ql.Line_Discount__c + tierDisc;
                    ql.discount = ql.discount + ql.Line_Discount__c;
                    if(ql.Discount > 100){
                      ql.Discount = 100 ;
                    }
                    //End code
                    
                    toBeInsertedQItems.add(ql);
                }
              }
              system.debug('-------toBeDeletedQitems-----'+toBeDeletedQitems);
              if(toBeDeletedQitems.size()>0)
              delete toBeDeletedQitems;
              QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = false;
              system.debug('-------tobeInsertedQitems-----'+tobeInsertedQItems);
              if(toBeInsertedQItems.size()>0)
              insert toBeInsertedQItems;
          }
      }
    }

    
    
    public static void insertProfServiceProduct(list<QuoteLineItem> triggerNew, Map<Id,QuoteLineItem> triggerOldMap, String source){
              system.debug('ENTERING INSERT PS NORMAL');
     list<String> pLine = new list<String>();
      list<String> pType = new list<String>();
      set<String> prodIds = new set<String>();
      list<String> quoteIds = new list<String>();
      list<QuoteLineItem> tempList = new list<QuoteLineItem>();
      list<Service_Line_Matrix__c> matrixList = new list<Service_Line_Matrix__c>();
      list<QuoteLineItem> toBeInsertedQItems = new list<QuoteLineItem>();
      map<String,Service_Line_Matrix__c> compStringToSupportProd = new map<String,Service_Line_Matrix__c>();
      map<String,Decimal> qIdVsProd = new map<String,Decimal>();
      map<String,String> prodIdVsISO = new map<String,String>();
      //Added by Etherios to track add Cost % from the Service Line Matrix
      Map<Id,Decimal> prodToCost = new Map<Id,Decimal>();
      //added by appshark
      map<String,QuoteLineItem> qIdVsQLI = new map<String,QuoteLineItem>(); //long description
      //Added by Etherios to track QLI to Solution Set, QLI to all solution sets with QLI computed Id string, Id string is (prod type + prod line + support type)
      Map<String,List<Id>> prodToQlis = new Map<String,List<Id>>();
      Map<Id,Product2> pMap = new Map<Id,Product2>();
      
      //system.debug('%%%%%%%%%%%%%'+triggerNew);
      for(QuoteLineItem each : triggerNew){
        if(each.Professional_Service_Requested__c && each.Professional_Service_Product__c == false && each.Support_Product__c == false){
          pLine.add(each.Product_Line__c);
          pType.add(each.Product_Type__c);
          quoteIds.add(each.quoteId);
        }
      }
      //etherios added qutoeId to quote Map
      map<Id,Quote> qMap = new map<Id,Quote>([Select id,Support_Type__c,Professional_Service_Requested__c from Quote where id in:quoteIds]);
      if(quoteIds.size()>0){
              //system.debug('----pLine-------'+pLine+'$$$$$$$'+pType);
              map<Id,QuoteLineItem> qlItems = new map<Id,QuoteLineItem>([Select id,Quote_CurrencyCode__c,UnitPrice,Quantity,quote.Default_Solution__c,quote.pricebook2id, Product_Cost2__c, Part_Number2__c, Solution__c, Solution_Optional__c,
                                                                                                                PricebookEntryId,Support_Product__c,Professional_Service_Product__c,TotalPrice,Product_Line__c,
                                                                                                                Product_Type__c,Professional_Service_Requested__c,Support_Type_Text__c,quoteId,
                                                                                                                Line_Discount__c,Long_Description__c,pricebookentry.Product2Id,Quote.Id,Quote.Additional_DIscount__c,Quote.Support_Discount__c,Quote.Service_Discount__c,Quote.Tier_Discount2__c 
                                                                                                                from QuoteLineItem where quoteId in:quoteIds AND Solution_Optional__c = false]);
              map<Id,Quote> qIdVsDefSol = new map<Id,Quote>([Select id,Default_Solution__c,Default_Price_Book__c from quote  where id in:quoteIds]);
              String prodIdFromQuote = '';
              String defPriceBook = qIdVsDefSol.values()[0].Default_Price_Book__c;
              if(qlItems.size()==0){
                String pbeId = triggerNew[0].PricebookEntryId;
                prodIdFromQuote = [Select pricebook2id from pricebookEntry where id=:pbeId limit 1].pricebook2id;
              }
              else{
                prodIdFromQuote = qlItems.values()[0].quote.pricebook2id;
              }
              
              
              
               if(source == 'fromTrigger')
              tempList.addAll(triggerNew);
              //if(source == 'fromTrigger' || source == 'fromDel')
              tempList.addAll(qlItems.values());
              
              //Etherios added - need to prune this tempList for Quote Line Items in which Solution_Optional__c = false
              /*
              for(Integer i = 0; i < tempList.size(); i++)
              {
                QuoteLineItem temp = tempList.get(i);
                if(temp.Solution_Optional__c == true)
                    tempList.remove(i);
              }
              */
              
             //Etherios need to prune templsit of trigger items in which the QLI Unit Price, LineDiscount, or Quantity has changed
              if(triggeroldmap != null && triggeroldMap.size() != 0 && tempList != null) //Always process on insert quote line item
              {
                  for(Integer i = 0; i < tempList.size(); i ++)
                  {
                    QuoteLineItem temp = tempList.get(i);
                    if(!((temp.UnitPrice != null && triggerOldMap.get(temp.Id) != null && temp.UnitPrice != triggerOldMap.get(temp.Id).UnitPrice) ||
                    ((temp.Line_Discount__c !=null && triggerOldMap.get(temp.Id) != null && temp.Line_Discount__c != triggerOldMap.get(temp.Id).Line_Discount__c)) ||
                    ((temp.Quantity !=null && triggerOldMap.get(temp.Id) != null && temp.Quantity != triggerOldMap.get(temp.Id).Quantity))
                     ))
                    {   
                        tempList.remove(i);
                    }
                  }
              }
              
              system.debug('-------tempList-----'+tempList);
              
              //added by appshark to store additional and support/provisional discount
               map<String,QuoteLineItem> mapQuoteToDiscoutInfo = new map<String,QuoteLineItem>();
               for(QuoteLineItem eachRec : tempList){
                    mapQuoteToDiscoutInfo.put(eachRec.Quote.Id,eachRec);
               }
              matrixList = [Select Cost_Percent__c, Percent_of_Line_Total_Product_Line__c,Product_Line__c,Product_Type__c,Professional_Service_Product__c,Support_Product__c,Support_Type__c 
                            from Service_Line_Matrix__c 
                          where Product_Line__c in:pLine and Product_Type__c in:pType];
             if(matrixList.size()>0){
              for(Service_Line_Matrix__c eachRec : matrixList){
                compStringToSupportProd.put(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c,eachRec);
              }
              for(QuoteLineItem eachRec : tempList){
                if(eachRec.Professional_Service_Requested__c && eachRec.Support_Product__c == false && !eachRec.Professional_Service_Product__c){
                  if(compStringToSupportProd.containsKey(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c)){
                    String prodId = compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c).Professional_Service_Product__c;
                    //Etherios added prod to list of qlis
                    if(prodToQlis.containsKey(prodId))
                        prodToQlis.get(prodId).add(eachRec.Id);
                    else
                    {
                        List<Id> tempIdList = new List<Id>();
                        tempIdList.add(eachRec.Id);
                        prodToQlis.put(prodId,tempIdList);                      
                    }
                    Decimal disc = compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c).Percent_of_Line_Total_Product_Line__c;
                    prodIdVsISO.put(prodId,eachRec.Quote_CurrencyCode__c);
                    prodIds.add(prodId);
                    //Etherios added, get cost % from serivce line matrix and put in map as well as disc null check below
                    if(compStringToSupportProd.containsKey(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c))
                        prodToCost.put(prodId,compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c).Cost_Percent__c);
                    if(!qIdVsProd.containsKey(eachRec.QuoteId+'~'+prodId))
                    {
                        if(disc != null)
                            qIdVsProd.put(eachRec.QuoteId+'~'+prodId,(eachRec.UnitPrice*eachRec.Quantity*disc)/100);
                    }
                    else{
                        if(disc != null)
                        {
                          Decimal tAmount = qIdVsProd.get(eachRec.QuoteId+'~'+prodId);
                          qIdVsProd.put(eachRec.QuoteId+'~'+prodId,tAmount+((eachRec.UnitPrice*eachRec.Quantity*disc)/100));
                        }
                    }
                    qIdVsQLI.put(eachRec.QuoteId+'~'+prodId,eachRec);
                  }
                }
              }
  
              //Etherios -- Create product map
              pMap = new Map<Id,Product2>([SELECT Product_Type__c, Product_Line__c from Product2 WHERE Id IN :prodIds]);
              
              system.debug('-------qIdVsProd-----'+qIdVsProd);
              list<Pricebookentry> pbeList = new list<Pricebookentry>();
              map<String,Decimal> prodVsUnitPrice = new map<String,Decimal>();
              map<String,pricebookentry> pbVsPbe = new map<String,pricebookentry>();
              list<QuoteLineItem> toBeDeletedQitems = new list<QuoteLineItem>();
              pbeList = [SELECT Id, Name, pricebook2id,Pricebook2.isStandard,UnitPrice, Product2Id, CurrencyIsoCode from pricebookentry where product2Id in:prodIds and Pricebook2Id =:prodIdFromQuote and isActive = true and CurrencyIsoCode in:prodIdVsISO.values()];
              if(pbeList.size()==0){
                  for(String eachProd : prodIds){
                      if(eachProd!=null){
                        pricebookentry pbe = new pricebookentry();
                        pbe.product2Id = eachProd;
                        pbe.Pricebook2Id = prodIdFromQuote;
                        //pbe.UseStandardPrice = true;
                        pbe.UnitPrice = 1;
                        pbe.CurrencyIsoCode = prodIdVsISO.get(eachProd);
                        pbe.IsActive = true;
                        pbeList.add(pbe);
                      }
                  }
                  system.debug('-------pbeList-----'+pbeList);
                  insert pbeList;
              }
              system.debug('-------pbeList123-----'+pbeList);
              for(pricebookentry each : pbeList){
                pbVsPbe.put(each.Product2Id,each);
                prodVsUnitPrice.put(each.Product2Id+'~'+each.priceBook2id,each.UnitPrice);
              }
              for(QuoteLineItem each : qlItems.values()){
                for(String eachQuote : qIdVsProd.keySet()){
                    if(each.QuoteId == eachQuote.split('~')[0] && each.PricebookEntryId == pbVsPbe.get(eachQuote.split('~')[1]).Id && each.Professional_Service_Product__c){
                        //For any QLI in trigger new that are optional only delete teh support and PS products of any related support and service products that are optional as well
                        /*if(each.Solution_Optional__c)
                        {
                            for(QuoteLineItem qli : triggerNew)
                            {
                                if(qli.Solution_Optional__c)
                                {
                                    if(qli.Product_Line__c == each.Product_Line__c && qli.Product_Type__c == each.Product_Type__c && qli.Support_Type_Text__c == each.Support_Type_Text__c)
                                        toBeDeletedQitems.add(each);
                                }
                            }
                        }
                        else*/
                        toBeDeletedQitems.add(each);
                    }
                }
              }
              for(String each : qIdVsProd.keySet()){
                QuoteLineItem ql = new QuoteLineItem();
                ql.QuoteId = each.split('~')[0];
                String pbeId='';
                String pId='';
                Id Product2Id;
                for(pricebookentry eachPBE : pbeList){
                    if(eachPBE.Product2Id == each.split('~')[1] && eachPBE.CurrencyIsoCode == prodIdVsISO.get(each.split('~')[1])){
                        pbeId = eachPBE.Id;
                        pId = eachPBE.Product2Id;
                        Product2Id = eachPBE.Product2Id;
                        //Set Cost Percent here if Prod is found
                        ql.Cost_Percent__c = prodToCost.get(each.split('~')[1]);
                    }
                }
                if(pbeId != ''){
                    //Etherios changed to null and before trigger will assign to highest order solution instead, changed back to default
                    ql.Solution__c = qIdVsDefSol.get(each.split('~')[0]).Default_Solution__c;
                    //system.debug('######'+pbeId);
                    ql.PricebookEntryId = pbeId;
                    ql.UnitPrice = prodVsUnitPrice.get(pId+'~'+defPriceBook);
                    ql.Quantity = 1;
                    ql.Professional_Service_Product__c = true;
                    ql.Support_Product__c = false;
                    
                    //Begin code by appshark to add Quantity, Line Discount, Long Description, Discount
                    QuoteLineItem objQL = mapQuoteToDiscoutInfo.get(each.split('~')[0]);
                    decimal addiotnalDisc = (objQL.Quote.Additional_DIscount__c!=null)? objQL.Quote.Additional_DIscount__c : 0;
                    decimal proffDisc = (objQL.Quote.Service_Discount__c!=null)? objQL.Quote.Service_Discount__c : 0;
                    //Etherios added Tier discounts do not apply to support and professional service products
                    //decimal tierDisc = (objQL.Quote.Tier_Discount2__c!=null)? objQL.Quote.Tier_Discount2__c : 0;
                    
                    system.debug('-------objQL.Product_Type__c-----'+objQL.Product_Type__c);
                    ql.discount = addiotnalDisc;
                    ql.Line_Discount__c = proffDisc;
                    
                    
                   // system.debug('-------ql.discount-----'+ql.discount);
                   //Etherios added Boolean deleted found.  This means that the new Support/PS product added is replacing one deleted
                    //If not found then case is Quote is going from no support to care or care +
                    Boolean found = false;
                    for( QuoteLineItem qlDel : toBeDeletedQitems ){
                      //  system.debug(qlDel.pricebookentry.Product2Id+'<------->'+Product2Id); 
                        if( Product2Id!=null && Product2Id == qlDel.pricebookentry.Product2Id ){
                            found = true;
                            ql.Quantity = qlDel.Quantity;
                            ql.Line_Discount__c = (qlDel.Line_Discount__c!=null)?qlDel.Line_Discount__c:ql.Line_Discount__c; // overrides the Line discount copied from Quote if manually provided
                            ql.Long_Description__c = qlDel.Long_Description__c;
                            //Etherios needs to add here, override ProductCost2,Part number 2, Unit Price as well
                            ql.Part_Number2__c = (qlDel.Part_Number2__c != null)?qlDel.Part_Number2__c : ql.Part_Number2__c;
                            //ql.UnitPrice = (qlDel.UnitPrice != null)?qlDel.UnitPrice : ql.UnitPrice;
                            //ql.Product_Cost2__c = (qlDel.Product_Cost2__c != null)?qlDel.Product_Cost2__c : ql.Product_Cost2__c;
                            ql.Solution__c = (qlDel.Solution__c != null)?qlDel.Solution__c : ql.Solution__c;
                        }
                    }
                    
                    system.debug('PROD TO QLI MAP '+prodToQlis);
                    //Etherios added if triggerOld is null(coming from Quote update) then get Solution Set from QLI origination
                    //If this is replacing one then don't need to do this, we can just Solution to what it was before
                    if(triggerOldMap == null && found == false)
                    {
                        Id tempQLIId = prodToQlis.get(Product2Id).remove(0);
                        ql.Solution__c = qlItems.get(tempQLIId).Solution__c;
                    }
                    system.debug('QL Solution Set '+ql.Solution__c);
                    
                    // Modification History: Appshark added tierDisc to fix User story : Issue 10
                    //Etherios added Tier discounts do not apply to support and professional service products
                    //ql.discount = ql.discount + ql.Line_Discount__c + tierDisc;
                    ql.discount = ql.discount + ql.Line_Discount__c;
                    //End code
                    
                    toBeInsertedQItems.add(ql);
                }
                if(ql.Discount > 100){
                  ql.Discount = 100 ;
                }
              }
              system.debug('-------toBeDeletedQitems-----'+toBeDeletedQitems);
              if(toBeDeletedQitems.size()>0)
              delete toBeDeletedQitems;
              QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = false;
              system.debug('-------toBeInsertedQitems-----'+toBeInsertedQitems);
              if(toBeInsertedQItems.size()>0)
              insert toBeInsertedQItems;
            }
        }
    }
    
    public static void insertSupportProductOptional(list<QuoteLineItem> triggerNew, Map<Id,QuoteLineItem> triggerOldMap, String source){
              system.debug('ENTERING INSERT SUPPORT Optional ');
      list<String> pLine = new list<String>();
      list<String> pType = new list<String>();
      list<String> sType = new list<String>();
      set<String> prodIds = new set<String>();
      list<String> quoteIds = new list<String>();
      set<QuoteLineItem> tempList = new set<QuoteLineItem>();
      list<Service_Line_Matrix__c> matrixList = new list<Service_Line_Matrix__c>();
      list<QuoteLineItem> toBeInsertedQItems = new list<QuoteLineItem>();
      map<String,Service_Line_Matrix__c> compStringToSupportProd = new map<String,Service_Line_Matrix__c>();
      map<String,Decimal> qIdVsProd = new map<String,Decimal>();
      map<String,String> prodIdVsISO = new map<String,String>();
      //Added by Etherios to track add Cost % from the Service Line Matrix
      Map<Id,Decimal> prodToCost = new Map<Id,Decimal>();
      //Added by Etherios to track QLI to Solution Set, QLI to all solution sets with QLI computed Id string, Id string is (prod type + prod line + support type)
      Map<String,List<Id>> prodToQlis = new Map<String,List<Id>>();
      //etherios added qutoeId to quote Map
      Map<Id,Product2> pMap = new Map<Id,Product2>();
      
      system.debug('-------triggerNew-------'+triggerNew);
      system.debug('-------triggerOldMap-------'+triggerOldMap);
      for(QuoteLineItem each : triggerNew){
        //system.debug('$$$$$$$$$$$'+each);
        if(each.Support_Type_Text__c != null && each.Support_Type_Text__c != '' && each.Professional_Service_Product__c == false && each.Support_Product__c == false){
          pLine.add(each.Product_Line__c);
          pType.add(each.Product_Type__c);
          sType.add(each.Support_Type_Text__c);
          quoteIds.add(each.QuoteId);
        }
      }
      map<Id,Quote> qMap = new map<Id,Quote>([Select id,Support_Type__c,Professional_Service_Requested__c from Quote where id in:quoteIds]);
      if(quoteIds.size()>0){
          system.debug('----quoteIds-----'+quoteIds);
          map<Id,QuoteLineItem> qlItems = new map<Id,QuoteLineItem>([Select id,Quote_CurrencyCode__c,UnitPrice,Quantity,quote.Default_Solution__c, Product_Cost2__c,Part_Number2__c, Solution__c, Solution_Optional__c, 
                                                                                                            quote.pricebook2id,PricebookEntryId,Support_Product__c,TotalPrice,Product_Line__c,
                                                                                                            Product_Type__c,Professional_Service_Product__c,Support_Type_Text__c,quoteId,
                                                                                                            Line_Discount__c,Long_Description__c,pricebookentry.Product2Id,Quote.Id,Quote.Additional_DIscount__c,Quote.Support_Discount__c,Quote.Service_Discount__c,Quote.Tier_Discount2__c
                                                                                                            from QuoteLineItem where quoteId in:quoteIds AND Solution_Optional__c = true]);
          system.debug('******qlItems******'+qlItems);
          map<Id,Quote> qIdVsDefSol = new map<Id,Quote>([Select id,Default_Solution__c from quote  where id in:quoteIds]);
          String prodIdFromQuote = '';
          if(qlItems.size()==0){
            String pbeId = triggerNew[0].PricebookEntryId;
            prodIdFromQuote = [Select pricebook2id from pricebookEntry where id=:pbeId limit 1].pricebook2id;
          }
          else{
            prodIdFromQuote = qlItems.values()[0].quote.pricebook2id;
          }
          
          
          //if(source != 'fromDel')
         // if(source == 'fromTrigger')
         //tempList.addAll(triggerNew);
          //if(source == 'fromTrigger' || source == 'fromDel')
          tempList.addAll(qlItems.values());
          
          //Etherios added - need to prune this tempList for Quote Line Items in which Solution_Optional__c = false
          /*
          for(QuoteLineItem temp : tempList)
          {
            if(temp.Solution_Optional__c == true)
                tempList.remove(temp);
          }
          */
          //Etherios need to prune templsit of trigger items in which the QLI Unit Price, LineDiscount, or Quantity has changed
          if(triggeroldmap != null && triggeroldMap.size() != 0 && tempList != null) //Always process on insert quote line item
          {
              for(QuoteLineItem temp : tempList)
              {
                if(!((temp.UnitPrice != null && triggerOldMap.get(temp.Id) != null && temp.UnitPrice != triggerOldMap.get(temp.Id).UnitPrice) ||
                ((temp.Line_Discount__c !=null && triggerOldMap.get(temp.Id) != null && temp.Line_Discount__c != triggerOldMap.get(temp.Id).Line_Discount__c)) ||
                ((temp.Quantity !=null && triggerOldMap.get(temp.Id) != null && temp.Quantity != triggerOldMap.get(temp.Id).Quantity))
                 ))
                {   
                    tempList.remove(temp);
                }
              }
          }
          
          
          
          system.debug('*********tempList*******'+tempList);
          
          //added by appshark to store additional and support/provisional discount
           map<String,QuoteLineItem> mapQuoteToDiscoutInfo = new map<String,QuoteLineItem>();
           for(QuoteLineItem eachRec : tempList){
            mapQuoteToDiscoutInfo.put(eachRec.Quote.Id,eachRec);
            //system.debug('---eachRec.UnitPrice----'+eachRec.UnitPrice);
            //system.debug('----eachRec1---'+eachRec.Support_Product__c+'------'+eachRec.Professional_Service_Product__c);
           }
           system.debug('----11111------'+pType+'------'+pLine+'-----'+sType);
          matrixList = [Select Percent_of_Line_Total_Product_Line__c,Product_Line__c,Product_Type__c,Professional_Service_Product__c, Cost_Percent__c,
                                Support_Product__c,Support_Type__c from Service_Line_Matrix__c  where Product_Line__c in:pLine 
                                and Product_Type__c in:pType and Support_Type__c in:sType];
          system.debug('*******matrixList*********'+matrixList);
          if(matrixList.size()>0){
              for(Service_Line_Matrix__c eachRec : matrixList){
                //mapping cost percentage
                prodToCost.put(eachRec.Support_Product__c, eachRec.Cost_Percent__c);
                compStringToSupportProd.put(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type__c,eachRec);
              }
              for(QuoteLineItem eachRec : tempList){
                if(eachRec.Support_Type_Text__c != null && eachRec.Support_Type_Text__c != '' && eachRec.Support_Product__c == false && eachRec.Professional_Service_Product__c ==false){
                    system.debug('----eachRec---'+eachRec.Support_Product__c+'------'+eachRec.Professional_Service_Product__c);
                  if(compStringToSupportProd.containsKey(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type_Text__c)){
                    String prodId = compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type_Text__c).Support_Product__c;
                    //Etherios added prod to list of qlis
                    if(prodToQlis.containsKey(prodId))
                        prodToQlis.get(prodId).add(eachRec.Id);
                    else
                    {
                        List<Id> tempIdList = new List<Id>();
                        tempIdList.add(eachRec.Id);
                        prodToQlis.put(prodId,tempIdList);                      
                    }
                    Decimal disc = compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type_Text__c).Percent_of_Line_Total_Product_Line__c;
                     system.debug('*******disc*********'+disc);
                    prodIdVsISO.put(prodId,eachRec.Quote_CurrencyCode__c);
                    prodIds.add(prodId);
                    //Etherios added, get cost % from serivce line matrix and put in map as well as disc null checks below, addded etting cost percentage up top
                   // if(compStringToSupportProd.containsKey(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c+'~'+eachRec.Support_Type__c))
                    //  prodToCost.put(prodId,compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c).Cost_Percent__c);
                    if(!qIdVsProd.containsKey(eachRec.QuoteId+'~'+prodId)){
                           // system.debug('----eachRec.UnitPrice------'+eachRec.UnitPrice);
                            //system.debug('----eachRec.Quantity------'+eachRec.Quantity);
                            
                        if(eachRec!=null && eachRec.QuoteId!=null && eachRec.UnitPrice!=null && eachRec.Quantity!=null && disc!=null){
                            qIdVsProd.put(eachRec.QuoteId+'~'+prodId,(eachRec.UnitPrice*eachRec.Quantity*disc)/100);
                        }
                    }
                    else{
                            Decimal tAmount = qIdVsProd.get(eachRec.QuoteId+'~'+prodId);
                            //system.debug('*******tAmount*********'+tAmount);
                            if(eachRec!=null && eachRec.QuoteId!=null && eachRec.UnitPrice!=null && eachRec.Quantity!=null && disc != null){
                                qIdVsProd.put(eachRec.QuoteId+'~'+prodId,tAmount+((eachRec.UnitPrice*eachRec.Quantity*disc)/100));
                            }
                    }
                  }
                }
              }
              //Etherios -- Create product map
              pMap = new Map<Id,Product2>([SELECT Product_Type__c, Product_Line__c from Product2 WHERE Id IN :prodIds]);
              
                system.debug('Product to Cost Percentage'+prodToCost);
              
               system.debug('*******qIdVsProd*********'+qIdVsProd);
              list<Pricebookentry> pbeList = new list<Pricebookentry>();
              map<String,pricebookentry> pbVsPbe = new map<String,pricebookentry>();
              list<QuoteLineItem> toBeDeletedQitems = new list<QuoteLineItem>();
              pbeList = [SELECT Id, Name,Pricebook2Id, Pricebook2.isStandard, Product2Id, CurrencyIsoCode from pricebookentry where product2Id in:prodIds and Pricebook2Id =:prodIdFromQuote and isActive = true ];
              if(pbeList.size()==0){
                  for(String eachProd : prodIds){
                        pricebookentry pbe = new pricebookentry();
                        pbe.product2Id = eachProd;
                        pbe.Pricebook2Id = prodIdFromQuote;
                        //pbe.UseStandardPrice = true;
                        pbe.UnitPrice = 1;
                        pbe.CurrencyIsoCode = prodIdVsISO.get(eachProd);
                        pbe.IsActive = true;
                        pbeList.add(pbe);
                  }
                  system.debug('-------pbeList-----'+pbeList);
                  insert pbeList;
              }
              system.debug('-------pbeList-----'+pbeList);
              for(pricebookentry each : pbeList){
                pbVsPbe.put(each.Product2Id,each);
              }
              system.debug('-------pbVsPbe-----'+pbVsPbe);
              for(QuoteLineItem each : qlItems.values()){
                for(String eachQuote : qIdVsProd.keySet()){
                    if(pbVsPbe.ContainsKey(eachQuote.split('~')[1]))
                    if(each.QuoteId == eachQuote.split('~')[0] && each.PricebookEntryId == pbVsPbe.get(eachQuote.split('~')[1]).Id && each.Support_Product__c){
                        //For any QLI in trigger new that are optional only delete teh support and PS products of any related support and service products that are optional as well
                        /*if(each.Solution_Optional__c)
                        {
                            for(QuoteLineItem qli : triggerNew)
                            {
                                if(qli.Solution_Optional__c)
                                {
                                    if(qli.Product_Line__c == each.Product_Line__c && qli.Product_Type__c == each.Product_Type__c && qli.Support_Type_Text__c == each.Support_Type_Text__c)
                                        toBeDeletedQitems.add(each);
                                }
                            }
                        }
                        else*/
                        toBeDeletedQitems.add(each);
                    }
                }
              }
              for(String each : qIdVsProd.keySet()){
                QuoteLineItem ql = new QuoteLineItem();
                ql.QuoteId = each.split('~')[0];
                String pbeId='';
                Id Product2Id;
                system.debug('-------each.split()[1] -----'+each.split('~')[1]);
                system.debug('-------prodIdVsISO.get(each.split()[1])-----'+prodIdVsISO);
                for(pricebookentry eachPBE : pbeList){
                    system.debug('-------eachPBE.Product2Id -----'+eachPBE.Product2Id);
                     system.debug('-------eachPBE.CurrencyIsoCode-----'+eachPBE.CurrencyIsoCode);
                    if(eachPBE.Product2Id == each.split('~')[1] && eachPBE.CurrencyIsoCode == prodIdVsISO.get(each.split('~')[1])){
                        pbeId = eachPBE.Id;
                        Product2Id = eachPBE.Product2Id;
                        //Set Cost Percent here if Prod is found
                        system.debug('PRODUCT COST PERCENTAGE set '+prodToCost.get(each.split('~')[1]));
                        ql.Cost_Percent__c = prodToCost.get(each.split('~')[1]);
                    }
                }
                if(pbeId != ''){
                    //Etherios changed to null and before trigger will assign to highest order solution instead, changed back
                    ql.Solution__c = qIdVsDefSol.get(each.split('~')[0]).Default_Solution__c;
                    ql.PricebookEntryId = pbeId;
                    ql.UnitPrice = qIdVsProd.get(each);
                    ql.Quantity = 1;
                    ql.Support_Product__c = true;
                    ql.Professional_Service_Product__c = false;
                    
                    //Begin code added by appshark to add Quantity, Line Discount, Long Description, Discount
                    system.debug('-------Product2Id-----'+Product2Id);
                    QuoteLineItem objQL = mapQuoteToDiscoutInfo.get(each.split('~')[0]);
                    decimal addiotnalDisc = (objQL.Quote.Additional_DIscount__c!=null)? objQL.Quote.Additional_DIscount__c : 0;
                    decimal supportDisc = (objQL.Quote.Support_Discount__c!=null)? objQL.Quote.Support_Discount__c : 0;
                    //Etherios added Tier discounts do not apply to support and professional service products
                    //decimal tierDisc = (objQL.Quote.Tier_Discount2__c!=null)? objQL.Quote.Tier_Discount2__c : 0;
                    
                    system.debug('-------objQL.Product_Type__c-----'+objQL.Product_Type__c);
                    ql.discount = addiotnalDisc;
                    if( supportDisc!=null  )
                        ql.Line_Discount__c = supportDisc;
                    
                    system.debug('-------ql.discount-----'+ql.discount);
                    system.debug('-------ql.Line_Discount__c--1---'+ql.Line_Discount__c);
                    //Etherios added Boolean deleted found.  This means that the new Support/PS product added is replacing one deleted
                    //If not found then case is Quote is going from no support to care or care +
                    Boolean found = false;
                    for( QuoteLineItem qlDel : toBeDeletedQitems ){ 
                        system.debug(qlDel.Id+'************'+qlDel.pricebookentry.Product2Id+'<------->'+Product2Id); 
                        if( Product2Id!=null && Product2Id == qlDel.pricebookentry.Product2Id ){
                            found = true;
                            system.debug('****** QL DEL *******'+qlDel);
                            ql.Quantity = qlDel.Quantity;
                            ql.Line_Discount__c = (qlDel.Line_Discount__c!=null)?qlDel.Line_Discount__c:ql.Line_Discount__c; // overrides the Line discount copied from Quote if manually provided
                            ql.Long_Description__c = qlDel.Long_Description__c;
                            //Etherios needs to add here, override ProductCost2,Part number 2, Unit Price as well
                            ql.Part_Number2__c = qlDel.Part_Number2__c;
                            //Etherios added, Business case is need to override product cost IF the support item is part of trigger new(is changed)
                            //ql.UnitPrice = qlDel.UnitPrice;
                            //ql.Product_Cost2__c = qlDel.Product_Cost2__c;
                            ql.Solution__c = qlDel.Solution__c;
                        }
                    }
                    system.debug('PROD TO QLI MAP '+prodToQlis);
                    //Etherios added if triggerOld is null(coming from Quote update) then get Solution Set from QLI origination
                    //If this is replacing one then don't need to do this, we can just Solution to what it was before
                    if(triggerOldMap == null && found == false)
                    {
                        Id tempQLIId = prodToQlis.get(Product2Id).remove(0);
                        ql.Solution__c = qlItems.get(tempQLIId).Solution__c;
                    }
                    system.debug('QL Solution Set '+ql.Solution__c);
                    system.debug('-------ql.Line_Discount__c--2---'+ql.Line_Discount__c);
                    // Modification History: Appshark added tierDisc to fix User story : Issue 10
                    //Etherios added Tier discounts do not apply to support and professional service products
                    //ql.discount = ql.discount + ql.Line_Discount__c + tierDisc;
                    ql.discount = ql.discount + ql.Line_Discount__c;
                    //End code
                    if(ql.Discount > 100){
                      ql.Discount = 100 ;
                    }
                    toBeInsertedQItems.add(ql);
                }
              }
              system.debug('-------toBeDeletedQitems-----'+toBeDeletedQitems);
              if(toBeDeletedQitems.size()>0)
              delete toBeDeletedQitems;
              QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = false;
              system.debug('-------tobeInsertedQitems-----'+tobeInsertedQItems);
              if(toBeInsertedQItems.size()>0)
              insert toBeInsertedQItems;
          }
      }
    }
    
    public static void insertProfServiceProductOptional(list<QuoteLineItem> triggerNew, Map<Id,QuoteLineItem> triggerOldMap, String source){
              system.debug('ENTERING INSERT PS OPTIONAL');
     list<String> pLine = new list<String>();
      list<String> pType = new list<String>();
      set<String> prodIds = new set<String>();
      list<String> quoteIds = new list<String>();
      list<QuoteLineItem> tempList = new list<QuoteLineItem>();
      list<Service_Line_Matrix__c> matrixList = new list<Service_Line_Matrix__c>();
      list<QuoteLineItem> toBeInsertedQItems = new list<QuoteLineItem>();
      map<String,Service_Line_Matrix__c> compStringToSupportProd = new map<String,Service_Line_Matrix__c>();
      map<String,Decimal> qIdVsProd = new map<String,Decimal>();
      map<String,String> prodIdVsISO = new map<String,String>();
      //Added by Etherios to track add Cost % from the Service Line Matrix
      Map<Id,Decimal> prodToCost = new Map<Id,Decimal>();
      //added by appshark
      map<String,QuoteLineItem> qIdVsQLI = new map<String,QuoteLineItem>(); //long description
      //Added by Etherios to track QLI to Solution Set, QLI to all solution sets with QLI computed Id string, Id string is (prod type + prod line + support type)
      Map<String,List<Id>> prodToQlis = new Map<String,List<Id>>();
      Map<Id,Product2> pMap = new Map<Id,Product2>();
      
      //system.debug('%%%%%%%%%%%%%'+triggerNew);
      for(QuoteLineItem each : triggerNew){
        if(each.Professional_Service_Requested__c && each.Professional_Service_Product__c == false && each.Support_Product__c == false){
          pLine.add(each.Product_Line__c);
          pType.add(each.Product_Type__c);
          quoteIds.add(each.quoteId);
        }
      }
      //etherios added qutoeId to quote Map
      map<Id,Quote> qMap = new map<Id,Quote>([Select id,Support_Type__c,Professional_Service_Requested__c from Quote where id in:quoteIds]);
      if(quoteIds.size()>0){
              //system.debug('----pLine-------'+pLine+'$$$$$$$'+pType);
              map<Id,QuoteLineItem> qlItems = new map<Id,QuoteLineItem>([Select id,Quote_CurrencyCode__c,UnitPrice,Quantity,quote.Default_Solution__c,quote.pricebook2id, Product_Cost2__c, Part_Number2__c, Solution__c, Solution_Optional__c,
                                                                                                                PricebookEntryId,Support_Product__c,Professional_Service_Product__c,TotalPrice,Product_Line__c,
                                                                                                                Product_Type__c,Professional_Service_Requested__c,Support_Type_Text__c,quoteId,
                                                                                                                Line_Discount__c,Long_Description__c,pricebookentry.Product2Id,Quote.Id,Quote.Additional_DIscount__c,Quote.Support_Discount__c,Quote.Service_Discount__c,Quote.Tier_Discount2__c 
                                                                                                                from QuoteLineItem where quoteId in:quoteIds AND Solution_Optional__c = true]);
              map<Id,Quote> qIdVsDefSol = new map<Id,Quote>([Select id,Default_Solution__c,Default_Price_Book__c from quote  where id in:quoteIds]);
              String prodIdFromQuote = '';
              String defPriceBook = qIdVsDefSol.values()[0].Default_Price_Book__c;
              if(qlItems.size()==0){
                String pbeId = triggerNew[0].PricebookEntryId;
                prodIdFromQuote = [Select pricebook2id from pricebookEntry where id=:pbeId limit 1].pricebook2id;
              }
              else{
                prodIdFromQuote = qlItems.values()[0].quote.pricebook2id;
              }
              
              
              
               if(source == 'fromTrigger')
              tempList.addAll(triggerNew);
              //if(source == 'fromTrigger' || source == 'fromDel')
              tempList.addAll(qlItems.values());
              
              //Etherios added - need to prune this tempList for Quote Line Items in which Solution_Optional__c = false
              /*
              for(Integer i = 0; i < tempList.size(); i++)
              {
                QuoteLineItem temp = tempList.get(i);
                if(temp.Solution_Optional__c == true)
                    tempList.remove(i);
              }
              */
              
             //Etherios need to prune templsit of trigger items in which the QLI Unit Price, LineDiscount, or Quantity has changed
              if(triggeroldmap != null && triggeroldMap.size() != 0 && tempList != null) //Always process on insert quote line item
              {
                  for(Integer i = 0; i < tempList.size(); i ++)
                  {
                    QuoteLineItem temp = tempList.get(i);
                    if(!((temp.UnitPrice != null && triggerOldMap.get(temp.Id) != null && temp.UnitPrice != triggerOldMap.get(temp.Id).UnitPrice) ||
                    ((temp.Line_Discount__c !=null && triggerOldMap.get(temp.Id) != null && temp.Line_Discount__c != triggerOldMap.get(temp.Id).Line_Discount__c)) ||
                    ((temp.Quantity !=null && triggerOldMap.get(temp.Id) != null && temp.Quantity != triggerOldMap.get(temp.Id).Quantity))
                     ))
                    {   
                        tempList.remove(i);
                    }
                  }
              }
              
              system.debug('-------tempList-----'+tempList);
              
              //added by appshark to store additional and support/provisional discount
               map<String,QuoteLineItem> mapQuoteToDiscoutInfo = new map<String,QuoteLineItem>();
               for(QuoteLineItem eachRec : tempList){
                    mapQuoteToDiscoutInfo.put(eachRec.Quote.Id,eachRec);
               }
              matrixList = [Select Cost_Percent__c, Percent_of_Line_Total_Product_Line__c,Product_Line__c,Product_Type__c,Professional_Service_Product__c,Support_Product__c,Support_Type__c 
                            from Service_Line_Matrix__c 
                          where Product_Line__c in:pLine and Product_Type__c in:pType];
             if(matrixList.size()>0){
              for(Service_Line_Matrix__c eachRec : matrixList){
                compStringToSupportProd.put(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c,eachRec);
              }
              for(QuoteLineItem eachRec : tempList){
                if(eachRec.Professional_Service_Requested__c && eachRec.Support_Product__c == false && !eachRec.Professional_Service_Product__c){
                  if(compStringToSupportProd.containsKey(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c)){
                    String prodId = compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c).Professional_Service_Product__c;
                    //Etherios added prod to list of qlis
                    if(prodToQlis.containsKey(prodId))
                        prodToQlis.get(prodId).add(eachRec.Id);
                    else
                    {
                        List<Id> tempIdList = new List<Id>();
                        tempIdList.add(eachRec.Id);
                        prodToQlis.put(prodId,tempIdList);                      
                    }
                    Decimal disc = compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c).Percent_of_Line_Total_Product_Line__c;
                    prodIdVsISO.put(prodId,eachRec.Quote_CurrencyCode__c);
                    prodIds.add(prodId);
                    //Etherios added, get cost % from serivce line matrix and put in map as well as disc null check below
                    if(compStringToSupportProd.containsKey(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c))
                        prodToCost.put(prodId,compStringToSupportProd.get(eachRec.Product_Line__c+'~'+eachRec.Product_Type__c).Cost_Percent__c);
                    if(!qIdVsProd.containsKey(eachRec.QuoteId+'~'+prodId))
                    {
                        if(disc != null)
                            if(eachRec!=null && eachRec.QuoteId!=null && eachRec.UnitPrice!=null && eachRec.Quantity!=null){
                            qIdVsProd.put(eachRec.QuoteId+'~'+prodId,(eachRec.UnitPrice*eachRec.Quantity*disc)/100);
                            }
                    }
                    else{
                        if(disc != null)
                        {
                          Decimal tAmount = qIdVsProd.get(eachRec.QuoteId+'~'+prodId);
                            if(eachRec!=null && eachRec.QuoteId!=null && eachRec.UnitPrice!=null && eachRec.Quantity!=null && tamount!=null){
                          qIdVsProd.put(eachRec.QuoteId+'~'+prodId,tAmount+((eachRec.UnitPrice*eachRec.Quantity*disc)/100));
                            }
                        }
                    }
                    qIdVsQLI.put(eachRec.QuoteId+'~'+prodId,eachRec);
                  }
                }
              }
  
              //Etherios -- Create product map
              pMap = new Map<Id,Product2>([SELECT Product_Type__c, Product_Line__c from Product2 WHERE Id IN :prodIds]);
              
              system.debug('-------qIdVsProd-----'+qIdVsProd);
              list<Pricebookentry> pbeList = new list<Pricebookentry>();
              map<String,Decimal> prodVsUnitPrice = new map<String,Decimal>();
              map<String,pricebookentry> pbVsPbe = new map<String,pricebookentry>();
              list<QuoteLineItem> toBeDeletedQitems = new list<QuoteLineItem>();
              pbeList = [SELECT Id, Name, pricebook2id,Pricebook2.isStandard,UnitPrice, Product2Id, CurrencyIsoCode from pricebookentry where product2Id in:prodIds and Pricebook2Id =:prodIdFromQuote and isActive = true and CurrencyIsoCode in:prodIdVsISO.values()];
              if(pbeList.size()==0){
                  for(String eachProd : prodIds){
                      
                    pricebookentry pbe = new pricebookentry();
                    pbe.product2Id = eachProd;
                    pbe.Pricebook2Id = prodIdFromQuote;
                    //pbe.UseStandardPrice = true;
                    pbe.UnitPrice = 1;
                    pbe.CurrencyIsoCode = prodIdVsISO.get(eachProd);
                    pbe.IsActive = true;
                      if(eachProd!=null){
                            pbeList.add(pbe);
                      }
                  }
                  system.debug('-------pbeList-----'+pbeList);
                  insert pbeList;
              }
              system.debug('-------pbeList123-----'+pbeList);
              for(pricebookentry each : pbeList){
                pbVsPbe.put(each.Product2Id,each);
                prodVsUnitPrice.put(each.Product2Id+'~'+each.priceBook2id,each.UnitPrice);
              }
              for(QuoteLineItem each : qlItems.values()){
                for(String eachQuote : qIdVsProd.keySet()){
                    if(each.QuoteId == eachQuote.split('~')[0] && each.PricebookEntryId == pbVsPbe.get(eachQuote.split('~')[1]).Id && each.Professional_Service_Product__c){
                        //For any QLI in trigger new that are optional only delete teh support and PS products of any related support and service products that are optional as well
                        /*if(each.Solution_Optional__c)
                        {
                            for(QuoteLineItem qli : triggerNew)
                            {
                                if(qli.Solution_Optional__c)
                                {
                                    if(qli.Product_Line__c == each.Product_Line__c && qli.Product_Type__c == each.Product_Type__c && qli.Support_Type_Text__c == each.Support_Type_Text__c)
                                        toBeDeletedQitems.add(each);
                                }
                            }
                        }
                        else*/
                        toBeDeletedQitems.add(each);
                    }
                }
              }
              for(String each : qIdVsProd.keySet()){
                QuoteLineItem ql = new QuoteLineItem();
                ql.QuoteId = each.split('~')[0];
                String pbeId='';
                String pId='';
                Id Product2Id;
                for(pricebookentry eachPBE : pbeList){
                    if(eachPBE.Product2Id == each.split('~')[1] && eachPBE.CurrencyIsoCode == prodIdVsISO.get(each.split('~')[1])){
                        pbeId = eachPBE.Id;
                        pId = eachPBE.Product2Id;
                        Product2Id = eachPBE.Product2Id;
                        //Set Cost Percent here if Prod is found
                        ql.Cost_Percent__c = prodToCost.get(each.split('~')[1]);
                    }
                }
                if(pbeId != ''){
                    //Etherios changed to null and before trigger will assign to highest order solution instead, changed back to default
                    ql.Solution__c = qIdVsDefSol.get(each.split('~')[0]).Default_Solution__c;
                    //system.debug('######'+pbeId);
                    ql.PricebookEntryId = pbeId;
                    ql.UnitPrice = prodVsUnitPrice.get(pId+'~'+defPriceBook);
                    ql.Quantity = 1;
                    ql.Professional_Service_Product__c = true;
                    ql.Support_Product__c = false;
                    
                    //Begin code by appshark to add Quantity, Line Discount, Long Description, Discount
                    QuoteLineItem objQL = mapQuoteToDiscoutInfo.get(each.split('~')[0]);
                    decimal addiotnalDisc = (objQL.Quote.Additional_DIscount__c!=null)? objQL.Quote.Additional_DIscount__c : 0;
                    decimal proffDisc = (objQL.Quote.Service_Discount__c!=null)? objQL.Quote.Service_Discount__c : 0;
                    //Etherios added Tier discounts do not apply to support and professional service products
                    //decimal tierDisc = (objQL.Quote.Tier_Discount2__c!=null)? objQL.Quote.Tier_Discount2__c : 0;
                    
                    system.debug('-------objQL.Product_Type__c-----'+objQL.Product_Type__c);
                    ql.discount = addiotnalDisc;
                    ql.Line_Discount__c = proffDisc;
                    
                    
                   // system.debug('-------ql.discount-----'+ql.discount);
                   //Etherios added Boolean deleted found.  This means that the new Support/PS product added is replacing one deleted
                    //If not found then case is Quote is going from no support to care or care +
                    Boolean found = false;
                    for( QuoteLineItem qlDel : toBeDeletedQitems ){
                      //  system.debug(qlDel.pricebookentry.Product2Id+'<------->'+Product2Id); 
                        if( Product2Id!=null && Product2Id == qlDel.pricebookentry.Product2Id ){
                            found = true;
                            ql.Quantity = qlDel.Quantity;
                            ql.Line_Discount__c = (qlDel.Line_Discount__c!=null)?qlDel.Line_Discount__c:ql.Line_Discount__c; // overrides the Line discount copied from Quote if manually provided
                            ql.Long_Description__c = qlDel.Long_Description__c;
                            //Etherios needs to add here, override ProductCost2,Part number 2, Unit Price as well
                            ql.Part_Number2__c = (qlDel.Part_Number2__c != null)?qlDel.Part_Number2__c : ql.Part_Number2__c;
                            //ql.UnitPrice = (qlDel.UnitPrice != null)?qlDel.UnitPrice : ql.UnitPrice;
                            //ql.Product_Cost2__c = (qlDel.Product_Cost2__c != null)?qlDel.Product_Cost2__c : ql.Product_Cost2__c;
                            ql.Solution__c = (qlDel.Solution__c != null)?qlDel.Solution__c : ql.Solution__c;
                        }
                    }
                    
                    system.debug('PROD TO QLI MAP '+prodToQlis);
                    //Etherios added if triggerOld is null(coming from Quote update) then get Solution Set from QLI origination
                    //If this is replacing one then don't need to do this, we can just Solution to what it was before
                    if(triggerOldMap == null && found == false)
                    {
                        Id tempQLIId = prodToQlis.get(Product2Id).remove(0);
                        ql.Solution__c = qlItems.get(tempQLIId).Solution__c;
                    }
                    system.debug('QL Solution Set '+ql.Solution__c);
                    
                    // Modification History: Appshark added tierDisc to fix User story : Issue 10
                    //Etherios added Tier discounts do not apply to support and professional service products
                    //ql.discount = ql.discount + ql.Line_Discount__c + tierDisc;
                    ql.discount = ql.discount + ql.Line_Discount__c;
                    //End code
                    if(ql.Discount > 100){
                      ql.Discount = 100 ;
                    }
                    toBeInsertedQItems.add(ql);
                }
              }
              system.debug('-------toBeDeletedQitems-----'+toBeDeletedQitems);
              if(toBeDeletedQitems.size()>0)
              delete toBeDeletedQitems;
              QuoteLineItemTriggerManager.ALLOWQUOTELINEUPDATE = false;
              system.debug('-------toBeInsertedQitems-----'+toBeInsertedQitems);
              if(toBeInsertedQItems.size()>0)
              insert toBeInsertedQItems;
            }
        }
    }

    public static void clearSLAFields(List<QuoteLineItem> toDelete){
      Set<Id> deleteIds = new Set<Id>();
      List<QuoteLineItem> qlis = [
        select Id, Support_QLI__c
        from QuoteLineItem
        where Support_QLI__c IN : toDelete
      ];
      for(QuoteLineItem qli : qlis){
        qli.SLA_List_Price__c = 0;
        qli.SLA_Rate__c = 0;
        qli.Annual_SLA_List_Price__c = 0;
        qli.Annual_SLA_Net_Price__c = 0;
        qli.SLA_Discount__c = 0;
        qli.Selected_SLA_Type__c = null;
      }
      update qlis;
    }

    public static void afterUpdateHandleSupportLineDiscountChange(List<QuoteLineItem> oldItems, Map<Id, QuoteLineItem> newItemsMap){
      Set<Id> recIds = new Set<Id>();
      for(QuoteLineItem oldQli : oldItems){
        QuoteLineItem newQli = newItemsMap.get(oldQli.Id);
        if( !String.isBlank(newQli.Product_Type__c) && newQli.Product_Type__c.equals('Support') && oldQli.Line_Discount__c != newQli.Line_Discount__c){
          recIds.add(newQli.Id);
        }
      }
      List<QuoteLineItem> qlis = [
        select Id, Support_QLI__c, SLA_Discount__c, Annual_SLA_Net_Price__c, Annual_SLA_List_Price__c
        from QuoteLineItem
        where Support_QLI__c IN :recIds
      ];
      List<QuoteLineItem> toUpdate = new List<QuoteLineItem>();
      for(QuoteLineItem qli : qlis){
        QuoteLineItem supportQli = newItemsMap.get(qli.Support_QLI__c);
        if(supportQli != null){
          qli.SLA_Discount__c = supportQli.Line_Discount__c;
          qli.Annual_SLA_Net_Price__c = qli.SLA_Discount__c != null ? (qli.Annual_SLA_List_Price__c - (qli.Annual_SLA_List_Price__c * (qli.SLA_Discount__c / 100))) : qli.Annual_SLA_List_Price__c;
          toUpdate.add(qli);
        }
      }
      update toUpdate;
    }
}