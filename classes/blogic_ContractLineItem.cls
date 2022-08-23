public class blogic_ContractLineItem {
    
    //ensure that a pricebookentry is created for all incoming contractLineItems
    public static void addDummyPriceBookEntry(List<ContractLineItem> newContractLineItems){
        String pricebookName = Test.isRunningTest() ? Test_blogic_ContractLineItem.TEST_PRICEBOOK : 'SC SFDC Only Pricebook';
        List<Pricebook2> pbs = [
            SELECT Id FROM Pricebook2 
            WHERE Name = :pricebookName
            ORDER BY Createddate DESC LIMIT 1
        ];
        if (!pbs.isEmpty()) {
            Map<String, Product2> productIds = new Map<String, Product2>();
            Map<String, ServiceContract> contractsMap = new Map<String, ServiceContract>();
            
            for(ContractLineItem cli : newContractLineItems){
                if (cli.PricebookEntryId == null) {
                    productIds.put(cli.Oracle_Product_Id__c, null);
                    contractsMap.put(cli.Oracle_Contract_Header_Id__c, null);
                }
            }

            List<ServiceContract> updateContracts = [
                SELECT Id, Pricebook2Id, Oracle_Cloud_ID__c 
                FROM ServiceContract 
                WHERE Oracle_Cloud_Id__c in :contractsMap.keySet()
            ];
            
            for (ServiceContract c : updateContracts) {
                contractsMap.put(c.Oracle_Cloud_Id__c, c);
                c.pricebook2Id = pbs[0].Id;
            }

            List<Product2> ps = [
                SELECT Id, Oracle_Cloud_Id__c 
                FROM Product2 
                WHERE Oracle_Cloud_Id__c in :productIds.keySet()
            ];
            for (Product2 p : ps) {
                productIds.put(p.Oracle_Cloud_Id__c, p);
            }

            Map<String, PriceBookEntry> newPbes = new Map<String, PriceBookEntry>();
            Set<Id> includedPBE = new Set<Id>();
            for (ContractLineItem cli : newContractLineItems) {
                if (contractsMap.containsKey(cli.Oracle_Contract_Header_Id__c) && contractsMap.get(cli.Oracle_Contract_Header_Id__c) != null) {
                    cli.ServiceContractId = contractsMap.get(cli.Oracle_Contract_Header_Id__c).Id;
                } else {
                    System.debug('@@ no matching contract found');
                }
                System.debug('cli: ' + cli);
                if (cli.PricebookEntryId == null && cli.Oracle_Product_Id__c != null && productIds.containsKey(cli.Oracle_Product_Id__c)) {
                    PricebookEntry pbe = new PricebookEntry();
                    pbe.Pricebook2Id = pbs[0].Id;
                    pbe.CurrencyIsoCode = 'USD';
                    pbe.IsActive = true;
                    pbe.Product2Id = productIds.get(cli.Oracle_Product_Id__c).Id;
                    pbe.UnitPrice = 0;
                    pbe.Oracle_Cloud_Id__c = cli.Oracle_Product_Id__c;
                    newPBEs.put(pbe.Oracle_Cloud_Id__c, pbe);
                } else {
                    if (cli.PricebookEntryId == null) {
                        cli.addError('No Product found for Oracle Product Id: ' + cli.Oracle_Product_Id__c);
                    } else {
                        includedPBE.add(cli.PricebookEntryId);
                    }
                }
            } 
            if (includedPBE.size() > 0) {
                activateEntries(includedPBE);
            }
            if (newPBEs.size()>0) {
                if (updateContracts.size()>0) {
                    upsert updateContracts;
                }
                List<Database.SaveResult> srs = Database.insert(newPBEs.values(), false);
                //check the results we need to capture errors where the pricebookentry already exists and then use that entry
                Set<string> existingProds = new Set<String>();
                Integer i = 0;
                for (Database.SaveResult sr : srs) {
                    if (!sr.isSuccess()) {
                        for (Database.Error e : sr.getErrors()) {
                            if (e.getMessage().contains('This price definition already exists in this price book')) {
                                existingProds.add(newPBEs.values()[i].Oracle_Cloud_Id__c);
                            }
                        }
                    }
                    i++;
                }
                List<PricebookEntry> existingPBEs = [SELECT Id, Product2Id, Oracle_Cloud_Id__c, IsActive FROM PricebookEntry WHERE Pricebook2Id = :pbs[0].id AND Oracle_Cloud_Id__c IN :existingProds LIMIT 50000];
                Map<String,Id> expbIds = new Map<String,Id>();
                if(existingPBEs.size()>0){
                    Map<Id, PricebookEntry> toActivate = new Map<Id, PricebookEntry>();
                    for(PricebookEntry pbe : existingPBEs){
                        expbIds.put(pbe.Oracle_Cloud_Id__c, pbe.Id);
                        if (!pbe.IsActive) toActivate.put(pbe.Id, new PricebookEntry(Id=pbe.Id, IsActive=true));
                    }
                    if (!toActivate.isEmpty()) Database.update(toActivate.values(), false);
                }
                    
                for(ContractLineItem cli : newContractLineItems){
                    if(cli.PricebookEntryId==null){
                        if(expbIds.containsKey(cli.Oracle_Product_Id__c)){
                            system.debug('expbids: ' + expbIds.get(cli.Oracle_Product_Id__c));
                            cli.PricebookEntryId = expbIds.get(cli.Oracle_Product_Id__c);
                        } else {
                            system.debug('newPBE: ' + newPBEs.get(cli.Oracle_Product_Id__c));
                            cli.PricebookEntryId = newPBEs.get(cli.Oracle_Product_Id__c).Id;
                        }
                        
                        if(cli.UnitPrice==null) cli.UnitPrice = 0;

                        if (cli.PricebookEntryId==null) {
                            system.debug('not created ' + cli);
                            cli.addError('PricebookEntry not created');
                        }
                    }
                }
            }
        } else {
            for(ContractLineItem cli : newContractLineItems){
                cli.addError('No valid Priceboook set up.  SC SFDC Only Pricebook must exist.');
            }
        }
    }
    
    public static void activateEntries(Set<Id> includedPBE) {
        List<PricebookEntry> ipbes = [
            SELECT Id, IsActive 
            FROM PriceBookEntry 
            WHERE Id in :includedPBE AND IsActive = false
        ];
        if (!ipbes.isEmpty()) {
            for (PricebookEntry p : ipbes) {
                p.IsActive = true;
            }
            update ipbes;
        }
    }
}