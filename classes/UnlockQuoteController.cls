public class UnlockQuoteController {
	
    class MyException extends Exception {}
    
    ApexPages.StandardController sc;

    public UnlockQuoteController(ApexPages.StandardController sc){
        this.sc = sc;
    }
    
    public PageReference toggleSync(){
        try {
            // otherwise if someone loads the page, it'll try to update all quotes without sync'd quotes
            if (sc.getId() == null) throw new MyException('No quote id provided');

            List<Opportunity> oppList = [select Id, SyncedQuoteId from Opportunity where SyncedQuoteId =: sc.getId()];
            Quote q = [select Id, OpportunityId from Quote where Id =: sc.getId()];
            if(oppList.size() == 0){
                oppList.add(new Opportunity(
                    Id=q.OpportunityId,
                    SyncedQuoteId=q.Id
                ));
            } else {
                for(Opportunity opp : oppList){
                    opp.SyncedQuoteId = null;
                }
            }
            update oppList;
            return sc.view();
        } catch(Exception ex){
            addError('Error: ' + ex.getMessage());
            return null;
        }
    }
    
    public void addError(String error){
        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, error);
        ApexPages.addMessage(errorMessage);
    }
}