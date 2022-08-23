/*---------------------------------------------------------------------------------------------------------------
 Class           : Products_StandardPrice_Helper
 Developed By    : Suraj Aluru
 CreateDate      : June 03, 2014.
 Description     : This helper class is called from Product_StandardPrice_AI after insert trigger to create
                   a standard pricebook entry on create.    
 
 *** Please add your comments below for change tracking ***
   Added processPriceBookEntry by Venkata Maddali on 07/08/2014 .              
-----------------------------------------------------------------------------------------------------------*/
public with sharing class Products_StandardPrice_Helper {
    public void insertStdPrice(List<Product2> products){
       List<PriceBookEntry> pbe = new List<PriceBookEntry>();
        Id pbId = null;
        if(Test.isRunningTest()){
            pbId = Test.getStandardPricebookId();
        } else {
            pbId = [select Id from Pricebook2 where isStandard = true].Id;
        }
       for(Product2 p:products){
           if(true){
               PriceBookEntry pbeInsert = new PriceBookEntry();
               pbeInsert.Product2ID = p.id;
               pbeInsert.PriceBook2ID = pbId;
               pbeInsert.UnitPrice = 1;
               pbeInsert.CurrencyIsoCode = 'USD';
               pbeInsert.IsActive = true;
               pbe.add(pbeInsert);

               PriceBookEntry pbeInsert1 = new PriceBookEntry();
               pbeInsert1.Product2ID = p.id;
               pbeInsert1.PriceBook2ID = pbId;
               pbeInsert1.UnitPrice = 1;
               pbeInsert1.CurrencyIsoCode = 'AUD';
               pbeInsert1.IsActive = true;
               pbe.add(pbeInsert1);
               
               PriceBookEntry pbeInsert2 = new PriceBookEntry();
               pbeInsert2.Product2ID = p.id;
               pbeInsert2.PriceBook2ID = pbId;
               pbeInsert2.UnitPrice = 1;
               pbeInsert2.CurrencyIsoCode = 'CAD';
               pbeInsert2.IsActive = true;
               pbe.add(pbeInsert2);
               
               PriceBookEntry pbeInsert3 = new PriceBookEntry();
               pbeInsert3.Product2ID = p.id;
               pbeInsert3.PriceBook2ID = pbId;
               pbeInsert3.UnitPrice = 1;
               pbeInsert3.CurrencyIsoCode = 'GBP';
               pbeInsert3.IsActive = true;
               pbe.add(pbeInsert3);
               
               PriceBookEntry pbeInsert4 = new PriceBookEntry();
               pbeInsert4.Product2ID = p.id;
               pbeInsert4.PriceBook2ID = pbId;
               pbeInsert4.UnitPrice = 1;
               pbeInsert4.CurrencyIsoCode = 'EUR';
               pbeInsert4.IsActive = true;
               pbe.add(pbeInsert4);
               
               PriceBookEntry pbeInsert5 = new PriceBookEntry();
               pbeInsert5.Product2ID = p.id;
               pbeInsert5.PriceBook2ID = pbId;
               pbeInsert5.UnitPrice = 1;
               pbeInsert5.CurrencyIsoCode = 'INR';
               pbeInsert5.IsActive = true;
               pbe.add(pbeInsert5);
               
               PriceBookEntry pbeInsert6 = new PriceBookEntry();
               pbeInsert6.Product2ID = p.id;
               pbeInsert6.PriceBook2ID = pbId;
               pbeInsert6.UnitPrice = 1;
               pbeInsert6.CurrencyIsoCode = 'HKD';
               pbeInsert6.IsActive = true;
               pbe.add(pbeInsert6);
               
               PriceBookEntry pbeInsert7 = new PriceBookEntry();
               pbeInsert7.Product2ID = p.id;
               pbeInsert7.PriceBook2ID = pbId;
               pbeInsert7.UnitPrice = 1;
               pbeInsert7.CurrencyIsoCode = 'SGD';
               pbeInsert7.IsActive = true;
               pbe.add(pbeInsert7);
           }
       }
       insert pbe;
   }
   public static void processPriceBookEntry(List<Product2> triggerNew,map<id,Product2> triggerNewMap){
     list<String> prodIds = new list<String>();
     list<PriceBookEntry> pbeList = new list<PriceBookEntry>();
     map<String,String> pbeIdVsPbId = new map<String,String>();
     map<String,String> pbeIdVsPrId = new map<String,String>();
     for(Product2 eachProd : triggerNew){
        prodIds.add(eachProd.Id);
     }
     pbeList = [Select id,IsActive,Product2Id,Pricebook2Id from PriceBookEntry where Product2Id in:prodIds];
     if(pbeList.size()>0){
        for(PriceBookEntry each : pbeList){
            pbeIdVsPbId.put(each.Id,each.Pricebook2Id);
            pbeIdVsPrId.put(each.Id,each.Product2Id);
        }
        map<Id,Pricebook2> pbMap = new map<Id,Pricebook2>([Select isActive from Pricebook2 where id in:pbeIdVsPbId.values() and isActive=true]);
        for(PriceBookEntry each : pbeList){
            system.debug('----------'+triggerNewMap.get(each.Product2Id).IsActive+'-----------'+ triggerNewMap.get(each.Product2Id).Quotable__c);
            if(triggerNewMap.get(each.Product2Id).IsActive && triggerNewMap.get(each.Product2Id).Quotable__c && pbMap.containsKey(each.Pricebook2Id))
            each.isActive = true;
            else
            each.isActive = false;
        }
        update pbeList;
     }
   }
}