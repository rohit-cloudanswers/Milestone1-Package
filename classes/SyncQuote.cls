public class SyncQuote {

	public Quote theQuote {get;set;}
	public SyncQuote(ApexPages.StandardController controller) {
		if(!Test.isRunningTest())
		{
			controller.addFields(new List<String>{'OpportunityId'});
		}
		theQuote = (Quote) controller.getRecord();
	}

    public Pagereference autoSync() {

    	Opportunity opp = [Select Id, SyncedQuoteId from Opportunity where Id = :theQuote.OpportunityId limit 1];
        opp.SyncedQuoteId = theQuote.Id;
        try {
            if(Test.isRunningTest() && SyncQuoteTests.testException){
            	throw new customException('INVALID_CROSS_REFERENCE_KEY');
        	}
            update opp;
        } catch (Exception e) {
            if (e.getMessage().contains('INVALID_CROSS_REFERENCE_KEY')) {
                for(Quote q: [select id,name,Imagine_Quote_Number_Link__c,OpportunityId from Quote where OpportunityId=:theQuote.OpportunityId and Id != :theQuote.Id]) {
                    if(Approval.isLocked(q.Id)) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,String.format(Label.Quote_Approval_Error_Message,new List<String> {q.Imagine_Quote_Number_Link__c})));
                        return null;
                    }
                }
            }
            // throw the exception if we couldn't figure it out
            throw e;
        }

        try {
	        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
	        req.setObjectId(theQuote.Id);
	        Approval.process(req);
	    } catch(Exception e) {
	    	// This would happen if there is no valid process.  Do nothing
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'The quote is now syncing but no approval process was found to enter, please contact your administrator with this information if you think this is an error: ' + e));
            return null;
	    }

        return new PageReference('/' + theQuote.Id);
    }
    
    public class customException extends Exception {}
}