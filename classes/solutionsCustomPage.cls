public with sharing class solutionsCustomPage {
	public list<String> solIds {get;set;}
	public map<String,String> solIdsVsMap {get;set;}
	
	public solutionsCustomPage(ApexPages.StandardController std){
		solIds = new list<String>();
		solIdsVsMap = new map<String,String>();
		String qId = std.getId();
		list<quoteLineItem> qlItem = new list<quoteLineItem>();
		set<String> oList = new set<String>(); 
		qlItem = [Select id,Solution__c,Solution__r.name from QuoteLineItem where QuoteId =:qId];
		for(quoteLineItem eachQ : qlItem){
			oList.add(eachQ.Solution__c);
			solIdsVsMap.put(eachQ.Solution__c,eachQ.Solution__r.name);
		}
		for(String eachString : oList){
			solIds.add(eachString);
		}
	}
}