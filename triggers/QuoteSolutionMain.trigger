trigger QuoteSolutionMain on Quote_Solutions__c (before insert) {
	 if(QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS){
		if(trigger.isInsert && trigger.isBefore){
			/* Etherios commented out since were moving away from putting things under the Default solution set
			list<String> qIds = new list<String>();
			for(Quote_Solutions__c eachRec : trigger.new){
				if(eachRec.Parent_Solution__c == null && !eachRec.IsDefault__c){
					qIds.add(eachRec.Quote__c);
				}
			}
			map<Id,Quote> quoteMap = new map<Id,Quote>([Select id,Default_Solution__c from Quote where id in:qIds]);
			for(Quote_Solutions__c eachRec : trigger.new){
				if(eachRec.Parent_Solution__c == null){
					if(quoteMap.ContainsKey(eachRec.Quote__c))
					eachRec.Parent_Solution__c = quoteMap.get(eachRec.Quote__c).Default_Solution__c;
				}
			}
			*/
		}
	}
}