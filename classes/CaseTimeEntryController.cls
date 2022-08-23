public class CaseTimeEntryController {
    
    public Milestone1_Time__c timeEntry {get; set;}
    public Integer minutes {get; set;}
    private Id caseId; 

    public CaseTimeEntryController(ApexPages.StandardController stdCon) {
        caseId = stdCon.getId();
        init();
    }
     
    private void init() {
        timeEntry = new Milestone1_Time__c();
        timeEntry.Case__c = caseId;
        timeEntry.Date__c = Date.today();
        timeEntry.Incurred_By__c = UserInfo.getUserId();
        timeEntry.Billable__c = true;
        timeEntry.Time_Type__c = '';
        timeEntry.Hours__c = 0;
        minutes = 0;
    }
    
    public void save(){
        if((timeEntry.Hours__c == null || timeEntry.Hours__c == 0) && 
          (minutes == null || minutes == 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'Please enter hours or minutes'));
        } else {
            if(timeEntry.Hours__c == null) {
                timeEntry.Hours__c = 0;
            }
            if(minutes != null) timeEntry.Hours__c += (minutes / 60.0);
            insert timeEntry;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Time entry saved successfully.'));
            init();
        }
    }
    
    public void cancel(){
        init();
    } 
}