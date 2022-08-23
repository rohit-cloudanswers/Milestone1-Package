public class PopulateQuoteDiscounts {
	public static Boolean IS_BATCH_EXECUTED = false;
	
	@InvocableMethod(label='Populate Quote discounts' description='Populate Quote discounts')
	public static void populateDiscounts(List<ID> ids) {
		System.debug('@@@ids:'+ids);
		if(!PopulateQuoteDiscounts.IS_BATCH_EXECUTED){
			Set<Id> setOfQuoteIds = new set<Id>();
			setOfQuoteIds.addAll(ids);
			System.debug('@@@size of list:'+setOfQuoteIds.size());
			if(setOfQuoteIds.size() > 10){
				QuoteDiscountBatch qdBatch = new QuoteDiscountBatch(setOfQuoteIds);
		  		if(!System.isFuture() && !System.isBatch()) Database.executeBatch(qdBatch, 5);
			}else{
				QuoteDiscountBatch.updateQuotes(setOfQuoteIds,'');
			}
		}
	}

}