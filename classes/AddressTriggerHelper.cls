public without sharing class AddressTriggerHelper {
    public static set<Id> addressIdsInUse {
        get{
            if(addressIdsInUse==null)
                addressIdsInUse = new Set<Id>();
            return addressIdsInUse;
        }
        set;}
    
    public static void updateAccountOnAddressCreation(Map<Id,Address__c> triggerNewMap){
        system.debug('inside on after update');
        List<Account> accountList = new List<Account>();
        Map<Id,Id> accountIdMap = new Map<Id,Id>();
        
        for(Address__c addressRecord:triggerNewMap.values())
        {
            if(!addressIdsInUse.contains(addressRecord.Id) && (addressRecord.Account__c != null || addressRecord.Account_Service__c != null))
            {
                if(addressRecord.Account__c != null)
                    accountIdMap.put(addressRecord.Account__c,addressRecord.Id);
                if(addressRecord.Account_Service__c != null)
                    accountIdMap.put(addressRecord.Account_Service__c,addressRecord.Id);
            }

        }
        
        accountList = [select Id,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,Billing_Address__c,ShippingStreet,
                       ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,Shipping_Address__c from Account where Id IN :accountIdMap.keySet()];
        List<Id> accountIds = new List<Id>();
        for(Account acc:accountList)
        {
            if(acc.Billing_Address__c != null && !addressIdsInUse.contains(acc.Billing_Address__c)){
                accountIds.add(acc.Billing_Address__c);
            }
        }
        
        Map<Id,Address__c> oldAddressMap = new Map<Id,Address__c>([select Id,Salesforce_Primary__c,primary__c from Address__c where id in: accountIds]);
        Map<Id, Account> accountsToBeUpdated = new Map<Id, Account>();
        Map<Id, Address__c> addressToBeUpdated = new Map<Id, Address__c>();
        
        List<State__c> states = [SELECT Country__r.name,country__r.Country_Code_2__c, Name,State_Code__c FROM State__c];
        set<String> stateLabels = new Set<String>();
        map<String, String> countryCodeStateCode = new map<String,String>();
        map<String, String> countryNameStateCode = new map<String,String>();
        
        for(state__c s : states){
            stateLabels.add(s.Name);
            countryCodeStateCode.put(s.country__r.Country_Code_2__c+s.State_Code__c,s.Name);
            countryNameStateCode.put(s.country__r.Name+s.State_Code__c,s.Name);
        }
        for(Account acc:accountList){
            Address__c currentAddress = triggerNewMap.get(accountIdMap.get(acc.Id));
            String stateName = currentAddress.State__c;
            Address__c oldAddress = oldAddressMap.containsKey(acc.Billing_Address__c)?oldAddressMap.get(acc.Billing_Address__c): null;
            system.debug('In use count: ' + addressIdsInUse.size());
            system.debug('Current Address: ' + currentaddress);
            system.debug('Old Address: ' +oldAddress);
            if(!addressIdsInUse.contains(currentAddress.Id) && (oldAddress==null || !addressIdsInUse.contains(oldaddress.Id))){
                system.debug('current address' +currentAddress + '  old add '+oldAddress);
                if((oldAddress != null && oldAddress.primary__c) || !currentAddress.Salesforce_Primary__c){
                    continue;
                }
                if(oldAddress != null && oldAddress.Id != currentAddress.Id){
                    oldAddress.Salesforce_Primary__c = false;
                    addressToBeUpdated.put(oldaddress.Id, oldAddress);
                }
                if(oldAddress == null || (oldAddress.id != currentAddress.Id && currentAddress.Salesforce_Primary__c == true)){
                    if(oldAddress!=null){
                        oldAddress.Salesforce_Primary__c = false;
                        addressToBeUpdated.put(oldaddress.Id, oldAddress);
                    }
                    acc.Billing_Address__c = currentAddress.Id;
                    acc.BillingStreet = currentAddress.Street_Address__c; 
                    acc.BillingCity = currentAddress.City__c;
                    
                    system.debug('Country: ' + currentAddress.Country__c);
                    
                    //lookup state value
                    if(stateLabels.contains(stateName)){
                        acc.BillingState = stateName;
                        acc.ShippingState = stateName;
                    } else {
                        String tempKey = currentAddress.Country__c + stateName;
                        if(countryCodeStateCode.containsKey(tempKey)){
                            acc.BillingState = countryCodeStateCode.get(tempKey);
                            acc.ShippingState = countryCodeStateCode.get(tempKey);
                        } else if(countryNameStateCode.containsKey(tempKey)){
                            acc.BillingState = countryNameStateCode.get(tempKey);
                            acc.ShippingState = countryNameStateCode.get(tempKey);
                        } else{
                            acc.BillingState = null;
                            acc.ShippingState = null;
                        }
                    }
                    acc.BillingCountry = currentAddress.Country__c;
                    acc.BillingPostalCode = currentAddress.Zip_Code__c;
                    acc.Shipping_Address__c = currentAddress.Id;
                    acc.ShippingStreet = currentAddress.Street_Address__c; 
                    acc.ShippingCity = currentAddress.City__c;
                    acc.ShippingCountry = currentAddress.Country__c;
                    acc.ShippingPostalCode = currentAddress.Zip_Code__c;
                    accountsToBeUpdated.put(acc.id, acc);
                }
            }
        }
           
        List<database.SaveResult> srs = database.update(accountsToBeUpdated.values(),false);
        list<account> accountsToRetry = new List<account>();
        integer i = 0;
        for(database.SaveResult sr : srs){ 
            if(!sr.IsSuccess()){
                //add error to the address from the update list
                Address__c add = triggernewmap.get(accountIdMap.get(accountsToBeUpdated.values()[i].Id));
                String c = add.Country__c;
                String s = add.State__c;
                String message = 'Invalid data. Check Country and/or State. The Name value in the Country object must match the values in State and Country Picklists.';
                message += ' Country: ' + c + ', State: ' + s + ', Id: ' + add.Id;
                boolean addError = true;
                for(database.Error e : sr.getErrors()){
                    if(e.getMessage().contains('DupeBlocker')){
                        addError = false;
                        accountsToRetry.add(accountsToBeUpdated.values()[i]);
                    }
                }
                if(addError){
                    system.debug(message);
                    add.addError(message);
                }
            }
            i++;
        }
        if(accountsToRetry.size()>0){
            update accountsToRetry;
        }
        List<database.SaveResult> asrs = database.update(addressToBeUpdated.values(),false);
        i=0;
        for(database.SaveResult sr : srs){ 
            if(!sr.IsSuccess()){
                system.debug(sr.getErrors());
            }
            i++;
        }
    }
    
    public static void addRegionAndSubRegion(List<Address__c> triggerNew){
        List<String> countryNameList = new List<String>();
        system.debug('triggerNew'+triggerNew);
        for(Address__c newAddress : triggerNew){
            countryNameList.add(newAddress.Country__c);
        }
        system.debug('countryNameList'+countryNameList);
        Map<String,Country__c> countryNameMap = new Map<String,Country__c>();
        Map<String,Country__c> countryCode2Map = new Map<String,Country__c>();
        for(Country__c c :[select Id, Name, Country__c,Region__c,Global_Region__c, Country_Code_2__c,Country_Code_3__c 
                           from Country__c where Name in: countryNameList OR Country_Code_2__c in :countryNameList]){
            countryNameMap.put(c.Name, c);
            countryCode2Map.put(c.Country_Code_2__c, c);
        }
        system.debug('countryNameMap'+countryNameMap);
        for(Address__c curAddress: triggerNew){
            system.debug('Old Country: '+curAddress.Country__c);
            Country__c  country = null;
            if(countryNameMap.containsKey(curAddress.country__c)){       
              country = countryNameMap.get(curAddress.Country__c);
            } else if(countryCode2Map.containsKey(curAddress.country__c)){
              country = countryCode2Map.get(curAddress.Country__c);
            }
            system.debug('country'+country);
            if(country!=null)
            {   
                system.debug('New Country: ' + country.Name);
                curAddress.Country_LK__c = country.Id;
                curAddress.country__c = country.Name;
                curAddress.Sub_Region__c = country.Region__c;
                curAddress.Region__c = country.Global_Region__c;
            } else {
                curAddress.addError('Invalid country: ' + curaddress.Country__c);
            }
        }       
    }
    
    public static void validateAtleastOnePrimary(Map<Id,Address__c> triggerNewMap, Map<Id, Address__c> triggerOldMap){
        if(userinfo.getLastName().toLowerCase().trim()!='interface' && userinfo.getLastName().toLowerCase().trim()!='stephensX' ){
            Map<Id,String> accountsToCheck = new Map<Id,String>();
            Set<Id> addressesAtIssue = new Set<Id>();
            if(addressIdsInUse==null)
                    addressIdsInUse = new Set<Id>();
            List<Address__c> addsToModify = new List<Address__c>();
            //check to see if the address being modified was the salesforce primary
            for(Address__c a : triggerOldMap.values()){
                if(!addressIdsInUse.contains(a.Id) && a.salesforce_primary__c == true){
                    if(triggerNewMap==null){
                        //this is a delete operation
                        //we will get other addresses for this account to be sure there is another salesforce primary
                        if(a.Account_Service__c!=null){
                            accountsToCheck.put(a.Account_Service__c,'checkForPrimary');
                            addressesAtIssue.add(a.Id);
                            system.debug('Address being deleted');
                        }
                    } else if(triggerNewMap.get(a.Id).Salesforce_primary__c == false) {
                        //this is change of salesforce primary from true to false
                        //we will get other addresses for this account to be sure there is another salesforce primary
                        if(triggerNewMap.get(a.Id).account_service__c!=null){
                            accountsToCheck.put(triggerNewMap.get(a.Id).account_service__c,'checkForPrimary');
                            addressesAtIssue.add(a.Id);
                            system.debug('Address going from true to false');
                        }
                    }
                } else if(!addressIdsInUse.contains(a.Id)){
                    if(triggerNewMap!=null && triggernewMap.get(a.Id).Salesforce_Primary__c == true){
                        //this is change of salesforce primary from false to true
                        //we will get other addresses for this account and set salesforce primary to false 
                        if(triggerNewMap.get(a.Id).account_service__c!=null){
                            accountsToCheck.put(triggerNewMap.get(a.Id).account_service__c,'removeOtherPrimaries');
                            addressesAtIssue.add(a.Id);
                            system.debug('Address going from false to true');
                        }
                    }                   
                }
            }//end initial for loop
            
            if(accountsToCheck.size()>0){
                List<Address__c> otherAdds = [SELECT Id, Primary__c, Account_Service__c, Salesforce_Primary__c 
                                              FROM Address__c 
                                              WHERE Account_Service__c in:accountsToCheck.keyset() 
                                                AND (Salesforce_Primary__c=true)
                                                AND Id NOT in :addressesAtIssue
                                                AND Id NOT in :addressIdsInUse
                                             ];
                
                Map<Id,Set<Address__c>> accountsWithPrimaries = new Map<Id,Set<Address__c>>();
                for(Address__c a : otheradds){
                    if(!accountsWithPrimaries.containsKey(a.Account_Service__c))
                            accountsWithPrimaries.put(a.Account_Service__c,new Set<Address__c>());
                    accountsWithPrimaries.get(a.Account_Service__c).add(a);
                }
                if(triggerNewMap==null){
                    //is delete
                    for(Id i : addressesAtIssue){
                        Address__c a = triggerOldMap.get(i);
                        if(!accountsWithPrimaries.containsKey(a.Account_Service__c)){
                            //the account on this address does not have another salesforce primary
                            String message = 'There needs to be atleast one primary address record associated to the account.';
                            message += 'Please mark another address record as the Salesforce primary before you delete this record.';
                            a.addError(message);
                            addressIdsInUse.add(a.Id);
                        }
                    }
                } else {
                    for(Id i : addressesAtIssue){
                        Address__c a = triggerNewMap.get(i);
                        if(accountsToCheck.get(a.Account_Service__c)=='checkForPrimary'){
                            if(!accountsWithPrimaries.containsKey(a.Account_Service__c)){
                                //the account on this address does not have another salesforce primary
                                String message = 'There needs to be atleast one primary address record associated to the account.';
                                message += 'Please mark another address record as the Salesforce primary before you update this record.';
                                a.addError(message);
                                addressIdsInUse.add(a.Id);
                            }
                        } else {
                            if(accountsWithPrimaries.containsKey(a.Account_Service__c)){ 
                                for(address__c ma : accountsWithPrimaries.get(a.Account_Service__c)){
                                    ma.salesforce_primary__c = false;
                                    if(!addressIdsInUse.contains(ma.Id))
                                        addsToModify.add(ma);
                                    addressIdsInUse.add(ma.Id);
                                }
                            }
                        }
                    } //addressesAtIssue loop
                } //triggerNewMapNull check 
            } //accountstocheck size check
            
            if(addsToModify.size()>0){
                List<database.SaveResult> srs = database.update(addsToModify,true);
                integer i = 0;
                for(database.SaveResult sr : srs){
                    if(!sr.IsSuccess()){
                        String message = 'Error changing the Salesforce Primary flag on Address record: ' + addsToModify[i].Id;
                        addsToModify[i].addError(message);
                    }
                    i++;
                }
            }
            
            /* commented out volo code because it makes no sense
            Map<Id,Set<Id>> accountIdMap = new Map<Id,Set<Id>>();
            for(Address__c addressRecord:triggerNewMap.values())
            {
                if(addressRecord.Account__c != null && !addressRecord.Primary__c )
                {
                    if(!accountIdMap.containsKey(addressRecord.Account__c)){
                        accountIdMap.put(addressRecord.Account__c,new Set<Id>());
                    }
                    accountIdMap.get(addressRecord.Account__c).add(addressRecord.Id);
                }
            }
            for(Address__c addressRecord : [select Account__c,Id from Address__c where Account__c IN :accountIdMap.keySet() and (Salesforce_Primary__c = true or Primary__c = true)]){
               accountIdMap.get(addressRecord.Account__c).add(addressRecord.Id);
            }
            for(Address__c addressRecord : triggerNewMap.values())
            {
                if(addressRecord.Primary__c || addressRecord.Salesforce_Primary__c){
                    continue;
                }
                accountIdMap.get(addressRecord.Account__c).remove(addressRecord.Id);
                Integer count = accountIdMap.get(addressRecord.Account__c).size();            
                if(count == 0){
                    addressRecord.addError('There needs to be atleast one primary address record associated to the account. Please add another address record as primary before you update this record.');        
                }
            }
            */
        }
    }
}