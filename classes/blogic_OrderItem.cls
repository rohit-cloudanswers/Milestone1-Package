public without sharing class blogic_OrderItem {
    public static Set<String> DISTRIBUTION_VALUES = new Set<String>{'Distribution', 'DIST'};
    public static Set<String> PS_VALUES = new Set<String>{'Professional Services', 'Professional Service', 'Service', 'Training'};
    public static Set<String> PRODUCT_VALUES = new Set<String>{'Hardware', 'Software', 'Product'};
    
    //ensure that a pricebookentry is created for all incoming orderItems
    public static void addDummyPriceBookEntry(List<OrderItem> newOrderItems){
        List<Pricebook2> pbs = [
            select Id from Pricebook2
            where Name = 'RMA SFDC Only Pricebook'
            order by Createddate desc limit 1
        ];
        if (pbs.size() > 0) {
            Map<String, Product2> productsMap = new Map<String, Product2>();
            Map<String, Order> oracleOrderIds = new Map<String, Order>();
            
            for(OrderItem oi : newOrderItems){
                if(oi.PricebookEntryId == null){
                    productsMap.put(oi.Oracle_Product_Id__c, null);
                    oracleOrderIds.put(oi.Oracle_Order_Header_ID__c, null);
                }
            }
            
            List<Order> orders = [
                select Id, Pricebook2Id, Oracle_Order_Header_Id__c 
                from Order 
                where Oracle_Order_Header_Id__c in :oracleOrderIds.keySet() 
                    and Oracle_Order_Header_Id__c != null
            ];
            
            List<Order> toUpdate = new List<Order>();
            for(Order odr : orders) {
                oracleOrderIds.put(odr.Oracle_Order_Header_Id__c, odr);
                // make sure the pricebook on all orders is the RMA SFDC ONLY Pricebook
                if(odr.Pricebook2Id != pbs[0].Id) {
                    odr.Pricebook2Id = pbs[0].Id;
                    toUpdate.add(odr);
                }
            }
            
            List<Product2> ps = [
                select Id, Oracle_Cloud_Id__c 
                from Product2 
                where Oracle_Cloud_Id__c  in :productsMap.keySet()
            ];
            for(Product2 p : ps){
                productsMap.put(p.Oracle_Cloud_Id__c, p);
            }
            
            Map<String, PricebookEntry> newPbes = new Map<String, PricebookEntry>();
            Set<String> failedLineItems = new Set<String>();
            for(OrderItem oi : newOrderItems){
                // link correct OrderId
                if (oracleOrderIds.containsKey(oi.Oracle_Order_Header_Id__c) && oracleOrderIds.get(oi.Oracle_Order_Header_Id__c) != null) {
                    oi.OrderId = oracleOrderIds.get(oi.Oracle_Order_Header_Id__c).Id;
                } else {
                    System.debug('@@ no matching order found');
                }
                if(oi.PricebookEntryId == null){
                    try{
                        if(productsMap.containsKey(oi.Oracle_Product_Id__c) && productsMap.get(oi.Oracle_Product_Id__c) != null){
                            PricebookEntry pbe = new PricebookEntry();
                            pbe.Pricebook2Id = pbs[0].Id;
                            pbe.CurrencyIsoCode = 'USD';
                            pbe.IsActive = True;
                            pbe.Product2Id = productsMap.get(oi.Oracle_Product_Id__c).Id;
                            pbe.UnitPrice = 0;
                            pbe.Oracle_Cloud_Id__c = oi.Oracle_Product_Id__c;
                            newPBEs.put(pbe.Oracle_Cloud_Id__c, pbe);
                        } else {
                            oi.addError('No Product found for Oracle Product Id: ' + oi.Oracle_Product_Id__c);
                            failedLineItems.add(oi.Oracle_Order_Line_ID__c);
                        }
                    } catch(Exception ex){
                        oi.addError('Error creating dummy pricebook entry. Line Id: ' + oi.Oracle_Order_Line_ID__c + ', ProductId: ' + oi.Oracle_Product_Id__c + ' e=' + ex);
                        failedLineItems.add(oi.Oracle_Order_Line_ID__c);
                    }
                }
            } 
            if(newPBEs.size() > 0){
                if(toUpdate.size() > 0){
                    upsert toUpdate;
                }
                List<Database.SaveResult> srs = Database.insert(newPBEs.values(), false);
                //check the results we need to capture errors where the pricebookentry already exists and then use that entry
                Set<string> existingProds = new Set<String>();
                Integer i = 0;
                for(Database.SaveResult sr : srs){
                    if(!sr.isSuccess()){
                        for(Database.Error e : sr.getErrors()){
                            if(e.getMessage().contains('This price definition already exists in this price book')){
                                existingProds.add(newPBEs.values()[i].Oracle_Cloud_Id__c);
                            }
                        }
                    }
                    i++;
                }
                List<PriceBookEntry> existingPBEs = [SELECT ID, Product2Id, Oracle_Cloud_Id__c FROM PricebookEntry WHERE Pricebook2Id = :pbs[0].id AND Oracle_Cloud_Id__c in :existingProds LIMIT 50000];
                Map<String, Id> expbIds = new Map<String, Id>();                
                for(PricebookEntry pbe : existingPBEs){
                    expbIds.put(pbe.Oracle_Cloud_Id__c, pbe.Id);
                }
                for(OrderItem oi : newOrderItems){
                    if(expbIds.containsKey(oi.Oracle_Product_Id__c)){
                        oi.PricebookEntryId = expbIds.get(oi.Oracle_Product_Id__c);
                    } else {
                        if(!failedLineItems.contains(oi.Oracle_Order_Line_ID__c))
                            oi.PricebookEntryId = newPBEs.get(oi.Oracle_Product_Id__c).Id;
                    }
                    oi.UnitPrice = 0;
                }
            }
        } else {
            for(OrderItem oi : newOrderItems){
                oi.addError('No valid Priceboook set up.  RMA SFDC Only Pricebook must exist.');
            }
        }
    }
    
    public static void doRollupCalculations(Map<Id, OrderItem> orderItemsMap){
        Set<Id> ordersToUpdate = new Set<Id>();
        for(OrderItem temp : orderItemsMap.values()){
            ordersToUpdate.add(temp.OrderId);
        }
        // only query orders for order items in scope
        Map<Id, Order> ordersMap = new Map<Id, Order>([
            select Id, Name, MPM4_Project__c, Total_Order_Value_USD__c, Open_CARE__c, 
            Open_Professional_Services__c, Open_Hardware_Distribution__c, 
            Open_Hardware_Networking__c, Open_Hardware_Media__c, Open_Hardware_Playout__c, 
            Closed_CARE__c, Closed_Hardware_Playout__c, Closed_Hardware_Networking__c, 
            Closed_Hardware_Media__c, Closed_Hardware_Distribution__c, Closed_Professional_Services__c  
            from Order 
            where Id in :ordersToUpdate and MPM4_Project__c != 'a2o0Z000000wrXzQAI'
        ]);
        // query all line items for the orders in scope
        List<OrderItem> newOrderItems = [
            select Id, OrderId, USD_Net_Net__c, List_Price2__c, Line_Status__c, 
            Delivery_Status__c, Business_Unit__c, Product_Type__c, List_Price__c
            from OrderItem where pricebookentry.Product2.Exclude_from_Project_Cost_Roll_up__c = FALSE and Line_Status__c NOT IN ('CANCELLED','CANCELED') and OrderId in :ordersMap.keySet()
        ];
        // reset order totals before counting totals 
        for (Id orderId : ordersMap.keySet()) {
            Order odr = ordersMap.get(orderId);
            resetOrderRollups(odr);
        }

        // count order totals using order lines
        for (OrderItem tempOrderItem : newOrderItems) {
            Id orderId = tempOrderItem.OrderId;
            if (tempOrderItem.Line_Status__c == 'CLOSED') {
                if (tempOrderItem.Product_Type__c != NULL && ((tempOrderItem.Product_Type__c).toLowerCase().trim() == 'hardware' || (tempOrderItem.Product_Type__c).toLowerCase().trim() == 'software' || (tempOrderItem.Product_Type__c).toLowerCase().trim() == 'product')) {
                    if (tempOrderItem.USD_Net_Net__c != NULL && tempOrderItem.Business_Unit__c != NULL) {
                        System.debug(tempOrderItem.USD_Net_Net__c);
                        if (tempOrderItem.Business_Unit__c.toLowerCase().trim() == 'playout') {
                            ordersMap.get(orderId).Closed_Hardware_Playout__c += tempOrderItem.USD_Net_Net__c;
                        }
                        if (tempOrderItem.Business_Unit__c.toLowerCase().trim() == 'media') {
                            ordersMap.get(orderId).Closed_Hardware_Media__c += tempOrderItem.USD_Net_Net__c;
                        }
                        if (tempOrderItem.Business_Unit__c.toLowerCase().trim() == 'networking') {
                            ordersMap.get(orderId).Closed_Hardware_Networking__c += tempOrderItem.USD_Net_Net__c;
                        }
                        if (DISTRIBUTION_VALUES.contains(tempOrderItem.Business_Unit__c)) {
                            ordersMap.get(orderId).Closed_Hardware_Distribution__c += tempOrderItem.USD_Net_Net__c;
                        }
                    }
                }
                if(tempOrderItem.Product_Type__c != NULL && PS_VALUES.contains(tempOrderItem.Product_Type__c) &&
                    tempOrderItem.USD_Net_Net__c != NULL) {
                    ordersMap.get(orderId).Closed_Professional_Services__c += tempOrderItem.USD_Net_Net__c;
                }
                if(tempOrderItem.Product_Type__c != NULL && (tempOrderItem.Product_Type__c).toLowerCase().trim() == 'support'
                    && tempOrderItem.USD_Net_Net__c != NULL) {
                    ordersMap.get(orderId).Closed_CARE__c += tempOrderItem.USD_Net_Net__c;
                }
            } else {
                if (tempOrderItem.Product_Type__c != NULL && ((tempOrderItem.Product_Type__c).toLowerCase().trim() == 'hardware' || (tempOrderItem.Product_Type__c).toLowerCase().trim() == 'software' || (tempOrderItem.Product_Type__c).toLowerCase().trim() == 'product')) {
                    if (tempOrderItem.USD_Net_Net__c != NULL && tempOrderItem.Business_Unit__c != NULL) {
                        System.debug(tempOrderItem.USD_Net_Net__c);
                        if (tempOrderItem.Business_Unit__c.toLowerCase().trim() == 'playout') {
                            ordersMap.get(orderId).Open_Hardware_Playout__c += tempOrderItem.USD_Net_Net__c;
                        }
                        if (tempOrderItem.Business_Unit__c.toLowerCase().trim() == 'media') {
                            ordersMap.get(orderId).Open_Hardware_Media__c += tempOrderItem.USD_Net_Net__c;
                        }
                        if (tempOrderItem.Business_Unit__c.toLowerCase().trim() == 'networking') {
                            ordersMap.get(orderId).Open_Hardware_Networking__c += tempOrderItem.USD_Net_Net__c;
                        }
                        if (DISTRIBUTION_VALUES.contains(tempOrderItem.Business_Unit__c)) {
                            ordersMap.get(orderId).Open_Hardware_Distribution__c += tempOrderItem.USD_Net_Net__c;
                        }
                    }
                }
                if(tempOrderItem.Product_Type__c != NULL && PS_VALUES.contains(tempOrderItem.Product_Type__c) &&
                    tempOrderItem.USD_Net_Net__c != NULL) {
                    ordersMap.get(orderId).Open_Professional_Services__c += tempOrderItem.USD_Net_Net__c;
                }
                if(tempOrderItem.Product_Type__c != NULL && (tempOrderItem.Product_Type__c).toLowerCase().trim() == 'support'
                    && tempOrderItem.USD_Net_Net__c != NULL) {
                    ordersMap.get(orderId).Open_CARE__c += tempOrderItem.USD_Net_Net__c;
                }
            }
        }

        System.debug(ordersMap);
        // Order trigger is taking care of rolling up Order totals to project
        update ordersMap.values();
    }

    private static void resetOrderRollups(Order odr) {
        odr.Open_CARE__c = 0;
        odr.Open_Professional_Services__c = 0;
        odr.Open_Hardware_Distribution__c = 0;
        odr.Open_Hardware_Networking__c = 0;
        odr.Open_Hardware_Media__c = 0;
        odr.Open_Hardware_Playout__c = 0;
        odr.Closed_CARE__c = 0;
        odr.Closed_Hardware_Playout__c = 0;
        odr.Closed_Hardware_Networking__c = 0;
        odr.Closed_Hardware_Media__c = 0;
        odr.Closed_Hardware_Distribution__c = 0;
        odr.Closed_Professional_Services__c = 0;
    }
}