global without sharing class blogic_Order {

    private static Id workOrderHeaderRecordTypeId = [SELECT id FROM RecordType WHERE Name ='Work Order Header' AND SobjectType='Order' limit 1].id;
    private static Id workOrderRequestRecordTypeId = [SELECT id FROM RecordType WHERE Name ='Work Order Request' AND SobjectType='Order' limit 1].id;
    private static Id psOrderRecordTypeId = [SELECT id FROM RecordType WHERE Name ='Order' AND SobjectType='Order' limit 1].id;
    public static void populateAddress(List<Order> newList, Map<Id, Order> oldMap){
        System.debug('Inside populateAddress...');
        system.debug('Number of orders is: '+newList.size());
        Set<Id> accIds = new Set<Id>();
        List<Integer> locationOrders = new List<Integer>();
        Map<Id, List<Address__c>> accId2AddressMap = new Map<Id, List<Address__c>>();
        Boolean isShipped;
        Boolean isBilled;
        
        //loop through and find the orders that meet the criteria and store the accound ids and location of the order
        for(Integer i = 0; i < newList.size(); i++){
            if(newList[i].recordTypeId != psOrderRecordTypeId){
                if(oldMap == null){
                    if(newList[i].AccountId != null){
                        accIds.add(newList[i].AccountId);
                        locationOrders.add(i);
                        
                    }
                } else {
                    if(newList[i].RecordTypeId == workOrderHeaderRecordTypeId && oldMap.get(newList[i].id).RecordTypeId == workOrderRequestRecordTypeId){//) || (newList[i].Operating_Unit__c != oldMap.get(newList[i].id).Operating_Unit__c) 
                        accIds.add(newList[i].AccountId);
                        locationOrders.add(i);
                    }
                }
            }
        }
        System.debug('accIds::'+accIds);
        
        if(accIds.size() > 0){
            //query for the address and map the account id to the address
            for(Address__c a : [SELECT id, Bill_To__c, Ship_To__c, Account_Service__c, Active__c, Operating_Unit__c 
                                FROM Address__c
                                WHERE Active__c = true AND Oracle_Last_Updated_Date_Time__c != null AND Salesforce_Primary__c = true AND Account_Service__c IN:accIds AND 
                                (Bill_To__c = true OR Ship_To__c = true)]){
                if(accId2AddressMap.containsKey(a.Account_Service__c)){
                    accId2AddressMap.get(a.Account_Service__c).add(a);
                } else {
                    accId2AddressMap.put(a.Account_Service__c, new List<Address__c> {a});
                }
            }
            System.debug('accId2AddressMap::'+accId2AddressMap);
            
            if(accId2AddressMap.keyset().size() > 0){
                for(Integer i : locationOrders){
                    isBilled = false;
                    isShipped = false;
                    for(Address__c address : accId2AddressMap.get(newList[i].AccountId)){
                        if(address.Operating_Unit__c == newList[i].Operating_Unit__c || oldMap != null){//true if update or operating unit are equal
                            if(address.Bill_To__c && !isBilled){
                                newList[i].Bill_To_Account__c = address.Account_Service__c;
                                newList[i].Bill_To_Address__c = address.id;
                                isBilled = true;
                            }
                            if(address.Ship_To__c && !isShipped){
                                newList[i].Ship_To_Account__c = address.Account_Service__c;
                                newList[i].Ship_To_Address__c = address.id;
                                isShipped = true;
                            }
                        }
                    }
                }
            }
        }
        /*
        Map<Id,Case> caseMap = new Map<Id,Case>([Select Id,caseNumber,accountId,Priority
                                                     from Case where Id IN : ordercaseIds.values()]);
        system.debug('caseMap is : '+caseMap);
        
        if(caseMap == null){
            return;
        }
        List<Id> accountList = new List<Id>();
        RecordType rType = [Select Id,name from RecordType where name ='Work Order Header' LIMIT 1];
        
        Map<String,String> supplyPriority = new Map<String,String>();
        supplyPriority.put('1-Critical', 'Urgent');
        supplyPriority.put('2-High', 'High');
        supplyPriority.put('3-Medium', 'Medium');
        supplyPriority.put('4-Low', 'Low');
        
        for(Order o : orders.values()){
            o.EffectiveDate = system.now().date();
            o.AccountId = caseMap.get(ordercaseIds.get(o.Id)).AccountId;
            o.Supply_Priority__c = supplyPriority.get(caseMap.get(ordercaseIds.get(o.Id)).Priority);
            
            system.debug('o.Case__r.accountId is : '+caseMap.get(ordercaseIds.get(o.Id)).accountId);
          //  if(o.RecordType == rType){
                accountList.add(caseMap.get(ordercaseIds.get(o.Id)).accountId);
            //}
        }
        
        if(accountList == null){
            return;
        }
        //For getting the BillTo Address
        Map<Id,Address__c> accPrimAddress = new Map<Id,Address__c>();
        accPrimAddress = getPrimaryAddress(accountList,'Bill_To');
        
        for(Order o: orders.values()){
            if(accPrimAddress != null && accPrimAddress.containsKey(caseMap.get(ordercaseIds.get(o.Id)).AccountId)){
                Address__c adr = accPrimAddress.get(o.AccountId);
                
                o.Bill_To_Account__c = adr.Account_Service__c;
                if(adr.Active__c == true && o.Operating_Unit__c == adr.Operating_Unit__c && adr.Oracle_Last_Updated_Date_Time__c != null){
                    o.Bill_To_Address__c = adr.Id;
                }
            }
        }
        //For getting the ShipTo Address
        Map<Id,Address__c> accPrimAddressShip = new Map<Id,Address__c>();
        accPrimAddressShip = getPrimaryAddress(accountList,'Ship_To');
        
        for(Order o: orders.values()){
            if(accPrimAddressShip != null && accPrimAddressShip.containsKey(caseMap.get(ordercaseIds.get(o.Id)).AccountId)){
                Address__c adr = accPrimAddressShip.get(o.AccountId);
                
               o.Ship_To_Account__c = adr.Account_Service__c;
                if(adr.Active__c == true && o.Operating_Unit__c == adr.Operating_Unit__c && adr.Oracle_Last_Updated_Date_Time__c != null){
                    o.Ship_To_Address__c = adr.Id; 
                }
            }
        }
        system.debug('The updated order is : '+orders);
           */      
    }
    /*
    public static Map<Id,Address__c> getPrimaryAddress(List<Id> accIdList,String toAddress){
        Map<Id,Address__c> accAddrMap = new Map<Id,Address__c>();
        List<Address__c> addrList = new List<Address__c>();
        
        String whereClause; 
        
        if(toAddress =='Bill_To'){
           whereClause =' AND Bill_To__c = true LIMIT 1';
        }else{
           whereClause =' AND Ship_To__c = true LIMIT 1';
        }
        String query ='Select Id,name,Account_Service__c,Active__c,Operating_Unit__c,Oracle_Last_Updated_Date_Time__c ';
            query = query + ' from Address__c where Account_Service__c IN (\''+ String.join(accIdList,'\',\'') +'\') '+
                +' AND Salesforce_Primary__c = true';
            query = query + whereClause;
        
        system.debug('query is : '+query);
       addrList = Database.query(query);
        
        for(Address__c a: addrList){
            //Creating a map of <AccountId,Address__c>
            accAddrMap.put(a.Account_Service__c, a);
        }
        system.debug('accAddrMap is : '+accAddrMap);
      return accAddrMap;
    }*/
    
    //before update, if the record type changes from WOrk Order Request to Work Order Header then bring over the case priority to the work order
    public static void populateSupplyPriority(Map<Id, Order> oldMap, List<Order> newList){
        //debug
        System.debug('Entering populateSupplyPriority ----- blogic_Order ------');
        System.debug('Looking at number of records::'+newList.size());
        
        //initialize variables
        Map<Id, Case> id2CaseMap = new Map<Id, Case>();
        List<Integer> locationIds = new List<Integer>();
        
        //make the map for the priorities
        Map<String,String> supplyPriority = new Map<String,String>();
        supplyPriority.put('1-Critical', 'Urgent');
        supplyPriority.put('2-High', 'High');
        supplyPriority.put('3-Medium', 'Medium');
        supplyPriority.put('4-Low', 'Low');
        
        //loop through the list and find when the record types changes
        for(Integer i = 0; i <newList.size(); i++){
            if(newList[i].RecordTypeId == workOrderHeaderRecordTypeId && oldMap.get(newList[i].id).RecordTypeId == workOrderRequestRecordTypeId && newList[i].Case__c != null){
                id2CaseMap.put(newList[i].Case__c, null);
                locationIds.add(i);
            }
        }
        
        if(id2CaseMap.keyset().size() > 0){
            id2CaseMap = new Map<Id, Case>([SELECT id, Priority FROM Case WHERE Id IN:id2CaseMap.keyset()]);
            
            //loop through the records that met the criteria and update the priority
            for(Integer i : locationIds){
                newList[i].Supply_Priority__c = supplyPriority.get(id2CaseMap.get(newList[i].Case__c).Priority);
            }
        }
    }
    
    public static void populateOracleOrderNumber(Map<Id,Order> newOrders, Map<Id,Order> oldOrders){
        if(newOrders == null){
            return;
        }

        Map<Id,Set<String>> caseOrderNumbers = new Map<Id,Set<String>>();
        
        for(Order o : newOrders.values()){
            //only get the cases related to orders where the oracle ordernumber has changed
            if(o.recordTypeId != psOrderRecordTypeId && String.isNotBlank(o.Oracle_Order_Number__c) && 
               (oldOrders==null || o.Oracle_Order_Number__c != oldOrders.get(o.Id).Oracle_Order_Number__c)){
                   if(!caseOrderNumbers.containsKey(o.Case__c))
                       caseOrderNumbers.put(o.Case__c, new set<String>());
                   caseOrderNumbers.get(o.Case__c).add(o.Oracle_Order_Number__c);
               }
        }
        
        Map<Id,Order> allOrders = new Map<Id,Order>([SELECT Id,Oracle_Order_Number__c,case__c 
                                                     FROM Order 
                                                     WHERE case__c IN : caseOrderNumbers.keySet() 
                                                        AND Oracle_Order_Number__c != null
                                                        AND Id NOT in :newOrders.keySet()]);
        
        for(Order o : allOrders.values()){
            if(string.isNotBlank(o.Oracle_Order_Number__c))
                caseOrderNumbers.get(o.Case__c).add(o.Oracle_Order_Number__c);
        }
        
        List<Case> updatedCases = [SELECT Id, OracleOrderNumbers__c FROM Case WHERE Id in :caseOrderNumbers.keySet()];
        if(updatedCases.size()>0){
            for(Case c : updatedCases){
                String concat = '';
                for(String s : caseOrderNumbers.get(c.Id)){
                    concat += ' | ' + s;
                }
                c.OracleOrderNumbers__c = concat.removeStart('|');
                system.debug('on: ' + c.OracleOrderNumbers__c);
            }
            update updatedCases;
        }
        
    }
    
    public static void ensureProjectRollups(Map<Id,Order> newOrders, map<id,Order> oldOrders){
        Set<Id> projectIds = new Set<Id>();
        if (newOrders == null) {
            //this is a delete
            for(Order thisOrder : oldOrders.values()){
                If(thisOrder.MPM4_Project__c!=null)
                    projectIds.add(thisOrder.MPM4_Project__c);
            }
        } else {
            if (oldOrders == null) {
                //this is an undelete
                for(Order thisOrder : newOrders.values()){
                    if (thisOrder.MPM4_Project__c != null)
                        projectIds.add(thisOrder.MPM4_Project__c);
                }
            } else {
                //this is an update
                for(Id thisOrderId : newOrders.keySet()){
                    //check to see if we need to add the order
                    if(newOrders.get(thisOrderId).MPM4_Project__c != oldOrders.get(thisOrderId).MPM4_Project__c){
                        if(newOrders.get(thisOrderId).MPM4_Project__c != null)
                            projectIds.add(newOrders.get(thisOrderId).MPM4_Project__c);
                        if(oldOrders.get(thisOrderId).MPM4_Project__c != null)
                            projectIds.add(oldOrders.get(thisOrderId).MPM4_Project__c);
                    } else {
                        // when same, at least add project id from one map
                        projectIds.add(newOrders.get(thisOrderId).MPM4_Project__c);
                    }
                }
            }
        }
        System.debug('projs ' + projectIds.size());
        if(projectIds.size()>0){
            Map<Id, MPM4_BASE__Milestone1_Project__c> projectMap = new Map<Id, MPM4_BASE__Milestone1_Project__c>([
                select Id, Name, Open_CARE__c, Open_Professional_Services__c, Open_Hardware_Distribution__c, Open_Hardware_Networking__c, Open_Hardware_Media__c, Open_Hardware_Playout__c, 
                Closed_CARE__c, Closed_Hardware_Playout__c, Closed_Hardware_Networking__c, Closed_Hardware_Media__c, Closed_Hardware_Distribution__c, Closed_Professional_Services__c 
                from MPM4_BASE__Milestone1_Project__c 
                where Id IN: projectIds
            ]);
            
            List<Order> listoforders = [
                select Id, Name, MPM4_Project__c, Open_CARE__c, Open_Professional_Services__c, 
                Open_Hardware_Distribution__c, Open_Hardware_Networking__c, Open_Hardware_Media__c, Open_Hardware_Playout__c, 
                Closed_CARE__c, Closed_Hardware_Playout__c, Closed_Hardware_Networking__c, Closed_Hardware_Media__c, 
                Closed_Hardware_Distribution__c, Closed_Professional_Services__c 
                from Order 
                where MPM4_Project__c IN: projectIds and MPM4_Project__c != null
            ];
    
            for(Id tempId : projectMap.keySet()){
                MPM4_BASE__Milestone1_Project__c proj = projectMap.get(tempId);
                resetProjectRollups(proj);
                for(Order tempOrder : listoforders){
                    if(tempOrder.MPM4_Project__c == tempId){
                        if(tempOrder.Closed_Professional_Services__c != NULL){
                            proj.Closed_Professional_Services__c += tempOrder.Closed_Professional_Services__c; 
                        }
                        if(tempOrder.Closed_Hardware_Distribution__c != NULL){
                            proj.Closed_Hardware_Distribution__c += tempOrder.Closed_Hardware_Distribution__c;
                        }
                        if(tempOrder.Closed_Hardware_Networking__c != NULL){
                            proj.Closed_Hardware_Networking__c += tempOrder.Closed_Hardware_Networking__c; 
                        }
                        if(tempOrder.Closed_Hardware_Playout__c != NULL){
                            proj.Closed_Hardware_Playout__c += tempOrder.Closed_Hardware_Playout__c; 
                        }
                        if(tempOrder.Closed_Hardware_Media__c != NULL){
                            proj.Closed_Hardware_Media__c += tempOrder.Closed_Hardware_Media__c; 
                        }
                        if(tempOrder.Closed_CARE__c != NULL){
                            proj.Closed_CARE__c += tempOrder.Closed_CARE__c; 
                        }
                        if(tempOrder.Open_Hardware_Playout__c != NULL){
                            proj.Open_Hardware_Playout__c += tempOrder.Open_Hardware_Playout__c; 
                        }
                        if(tempOrder.Open_Hardware_Networking__c != NULL){
                            proj.Open_Hardware_Networking__c += tempOrder.Open_Hardware_Networking__c; 
                        }
                        if(tempOrder.Open_Hardware_Distribution__c != NULL){
                            proj.Open_Hardware_Distribution__c += tempOrder.Open_Hardware_Distribution__c; 
                        }
                        if(tempOrder.Open_Hardware_Media__c != NULL){
                            proj.Open_Hardware_Media__c += tempOrder.Open_Hardware_Media__c; 
                        }
                        if(tempOrder.Open_Professional_Services__c != NULL){
                            proj.Open_Professional_Services__c += tempOrder.Open_Professional_Services__c; 
                        }
                        if(tempOrder.Open_CARE__c != NULL){
                            proj.Open_CARE__c += tempOrder.Open_CARE__c; 
                        }
                    }
                }
            }
            update projectMap.values();
        }
    }
    
    public static void resetProjectRollups(MPM4_BASE__Milestone1_Project__c proj) {
        proj.Open_CARE__c = 0;
        proj.Open_Professional_Services__c = 0;
        proj.Open_Hardware_Distribution__c = 0;
        proj.Open_Hardware_Networking__c = 0;
        proj.Open_Hardware_Media__c = 0;
        proj.Open_Hardware_Playout__c = 0;
        proj.Closed_CARE__c = 0;
        proj.Closed_Hardware_Playout__c = 0;
        proj.Closed_Hardware_Networking__c = 0;
        proj.Closed_Hardware_Media__c = 0;
        proj.Closed_Hardware_Distribution__c = 0;
        proj.Closed_Professional_Services__c = 0;
    }
}