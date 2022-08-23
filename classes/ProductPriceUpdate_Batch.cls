Global class ProductPriceUpdate_Batch implements Database.Batchable<Sobject>{
      global Database.queryLocator start(Database.BatchableContext bc){
        String query = '';
        if(test.isRunningTest()){
            query = 'Select id,PriceBook2Id,Product2Id,UnitPrice from PricebookEntry where IsActive = true limit 200';
        }
        else{
            query = 'Select id,PriceBook2Id,Product2Id,UnitPrice from PricebookEntry where IsActive = true';
        }
         return Database.getQueryLocator(query); 
      }
      global void execute(Database.BatchableContext bc, List<Sobject> scope) {
         Set<Id> productId = new Set<Id>();
         Set<Id> priceBId = new Set<Id>();
         map<Id,List<Id>> pbVsProd = new map<Id,List<Id>>();
         map<Id,Id> prodVsPbe = new map<Id,Id>();
         map<Id,PricebookEntry> triggernewMap = new map<Id,PricebookEntry>();
         for(PricebookEntry each : (List<PricebookEntry>)scope){
             triggernewMap.put(each.Id,each);
             productId.add(each.Product2Id);
             priceBId.add(each.PriceBook2Id);
             prodVsPbe.put(each.Product2Id,each.Id);
             if(!pbVsProd.containsKey(each.PriceBook2Id)) {
                pbVsProd.put(each.PriceBook2Id,new List<Id> ());
             }
             pbVsProd.get(each.PriceBook2Id).add(each.Product2Id);
         }
          list<priceBook2> pbList = [Select id,name,Oracle_Id__c from priceBook2 where id in:priceBId and IsActive = true];
            map<Id,Product2> prodList = new map<Id,Product2>([Select id,name,Asia_US__c,Australia_Domestic__c,Can_Dom__c,China_Domestic_US__c,
                                                    Euro__c,MESA_US__c,US_Int_l_EA__c,US_Domestic__c,UK_Dom__c, CALA_List_Price__c from Product2 where id in:productId and IsActive = true]);
            Map<Id,Product2> updatedProducts = new Map<Id,Product2>();
            for(priceBook2 eachPb : pbList){
                for(Id prodId : pbVsProd.get(eachPb.Id)) {
                    Product2 prod = prodList.get(prodId);
                    PricebookEntry pbe = triggernewMap.get(prodVsPbe.get(prodId));
                    boolean updated = false;
                    if(prod == null) {
                        continue;
                    }
                    //Australian Domestic List Prices (AUD)
                    if(eachPb.Oracle_Id__c == '12072') {
                        updated = true;
                        prod.Australia_Domestic__c = pbe.UnitPrice;
                    }
                    //China Domestic List Prices (USD)
                    else if(eachPb.Oracle_Id__c == '12074') {
                        updated = true;
                        prod.China_Domestic_US__c = pbe.UnitPrice;
                    }
                    //US$ International List Prices (EMEA, USD)
                    else if(eachPb.Oracle_Id__c == '12078'){
                        updated = true;
                        prod.US_Int_l_EA__c = pbe.UnitPrice;
                    }
                    //UK List Prices (GBP)
                    else if(eachPb.Oracle_Id__c == '12076') {
                        updated = true;
                        prod.UK_Dom__c = pbe.UnitPrice;
                    }
                    //Asia US$ Int'l List Prices (USD)
                    else if(eachPb.Oracle_Id__c == '12071') {
                        updated = true;
                        prod.Asia_US__c = pbe.UnitPrice;
                    }
                    //Canadian Domestic List Prices (CAD)
                    else if(eachPb.Oracle_Id__c == '12073') {
                        updated = true;
                        prod.Can_Dom__c = pbe.UnitPrice;
                    }
                    //US Domestic List Prices
                    else if(eachPb.Oracle_Id__c == '12077') {
                        updated = true;
                        prod.US_Domestic__c = pbe.UnitPrice;
                    }
                    //Euro List Prices (EUR)
                    else if(eachPb.Oracle_Id__c == '12075') {
                        updated = true;
                        prod.Euro__c = pbe.UnitPrice;
                    }
                    // CALA List Prices
                    else if(eachPb.Oracle_Id__c == '184027') {
                        updated = true;
                        prod.CALA_List_Price__c = pbe.UnitPrice;
                    }
                    //Standard Price Book
                    else if(eachPb.Name == 'Standard Price Book') {
                        updated = true;
                        prod.MESA_US__c = pbe.UnitPrice;
                    }
                    if(updated) {
                        updatedProducts.put(prod.Id,prod);
                    }
                }
            }
            if(!updatedProducts.isEmpty())
            {
                System.debug('Updating..' + updatedProducts);
                QuoteLineItemTriggerManager.ALLOWPRODUCTUPDATE = false;
                Database.update(updatedProducts.values());
                QuoteLineItemTriggerManager.ALLOWPRODUCTUPDATE = true;
            }
      }
     global void finish(Database.BatchableContext bc){
     }
}