public class QuoteBatchStatusExtension {

	private Quote currentQuote;

	public QuoteBatchStatusExtension(ApexPages.StandardController controller){
		if(!Test.isRunningTest()){
			controller.addFields(new List<String> {'Discount_Batch_Id__c'});
		}
		currentQuote = (Quote) controller.getRecord();
	}

	public void checkStatus(){
		try{
			List<AsyncApexJob> a ;
			if(!String.isBlank(currentQuote.Discount_Batch_Id__c)){
				Id batchId = ID.valueOf( currentQuote.Discount_Batch_Id__c );
				a = [Select Id, Status from AsyncApexJob where Id = :batchId];
			}
			if((a != null ) && (a.size() > 0)){
				if( a[0].Status == 'Completed') ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Discounts are summarized'));
				else if(a[0].status == 'Failed') ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error occurred, please contact your administrator'));	
				else ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Discount summarization is in progress.'));	
			} else {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Discounts are summarized or no line item added.'));
			}
		} catch(Exception ex) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error when summarizing discounts, please contact your administrator.'));
		}	
	}
}