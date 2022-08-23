/*
	Modification History : Appshark || 24th Dec 2014 || User Story : Issue with Pricing not showing up on the Partner Portal Price Book
*/
trigger PriceHitoryMain on Prices_History__c (after insert, after update) {
    list<String> productId = new list<String>();
    map<String,String> priceBId = new map<String,String>();
    map<String,String> pbVsProd = new map<String,String>();
    list<PricebookEntry> toBeAddedPEnt = new list<PricebookEntry>();
    map<String,PricebookEntry> pMap = new map<String,PricebookEntry>();
    for(Prices_History__c each : trigger.new){
        productId.add(each.Product__c);
        priceBId.put(each.Price_Book__c,each.Id);
        pbVsProd.put(each.Price_Book__c,each.Product__c);
    }
    list<PricebookEntry> pEnt = new list<PricebookEntry>();
    pEnt = [select  Pricebook2Id, Product2Id, UnitPrice from PricebookEntry where Product2Id in: productId and Pricebook2Id in: priceBId.keySet()];// and Pricebook2Id in: priceBId​];
    for(PricebookEntry each : pEnt){
        pMap.put(each.Product2Id+'~'+each.Pricebook2Id,each);
    }
    for(Prices_History__c each : trigger.new){
        if(pMap.containsKey(each.Product__c+'~'+each.Price_Book__c)){
            if(each.Price__c != null)
                pMap.get(each.Product__c+'~'+each.Price_Book__c).UnitPrice = each.Price__c;
        }
        else{
            PricebookEntry pe = new PricebookEntry();
            pe.pricebook2id = each.Price_Book__c;
            pe.Product2Id = each.Product__c;
            pe.UnitPrice = each.Price__c;
            pe.UseStandardPrice = false;
            pe.CurrencyISOCode = each.CurrencyISOCode;
            toBeAddedPEnt.add(pe);
        }
    }
    update pMap.values();
    insert toBeAddedPEnt;
    list<priceBook2> pbList = [Select id,name from priceBook2 where id in:priceBId.keySet()];
    map<Id,Product2> prodList = new map<Id,Product2>([Select id,name,Asia_US__c,Australia_Domestic__c,Can_Dom__c,China_Domestic_US__c,
    										Euro__c,MESA_US__c,US_Int_l_EA__c,US_Domestic__c,UK_Dom__c from Product2 where id in:productId]);
    list<Product2> prod2List = new list<Product2>();
    for(priceBook2 eachPb : pbList){
    	product2 prod = prodList.get(pbVsProd.get(eachPb.Id));
    	if(eachPb.name == 'Australian Domestic List Prices (AUD)')
    	prod.Australia_Domestic__c = trigger.newMap.get(priceBId.get(eachPb.Id)).Price__c;
    	if(eachPb.name == 'China Domestic List Prices (USD)')
    	prod.China_Domestic_US__c = trigger.newMap.get(priceBId.get(eachPb.Id)).Price__c;
    	if(eachPb.name == 'US$ International List Prices (EMEA, USD)')
    	prod.US_Int_l_EA__c = trigger.newMap.get(priceBId.get(eachPb.Id)).Price__c;
    	if(eachPb.name == 'UK List Prices (GBP)')
    	prod.UK_Dom__c = trigger.newMap.get(priceBId.get(eachPb.Id)).Price__c;
    	if(eachPb.name.contains('Asia US$ Int'))
    	prod.Asia_US__c = trigger.newMap.get(priceBId.get(eachPb.Id)).Price__c;
    	if(eachPb.name == 'Canadian Domestic List Prices (CAD)')
    	prod.Can_Dom__c = trigger.newMap.get(priceBId.get(eachPb.Id)).Price__c;
    	if(eachPb.name == 'Euro List Prices (EUR)')
    	prod.Euro__c = trigger.newMap.get(priceBId.get(eachPb.Id)).Price__c;
    	if(eachPb.name == 'Euro List Prices (EUR)')
    	prod.Euro__c = trigger.newMap.get(priceBId.get(eachPb.Id)).Price__c;
    	//Added by Appshark || 24th Dec 2014 || User Story : Issue with Pricing not showing up on the Partner Portal Price Book
    	if(eachPb.name == 'US Domestic List Prices (USD)')
    		prod.US_Domestic__c = trigger.newMap.get(priceBId.get(eachPb.Id)).Price__c;
    	prod2List.add(prod);
    }
    
    if( !prod2List.isEmpty() )
		update prod2List;
}