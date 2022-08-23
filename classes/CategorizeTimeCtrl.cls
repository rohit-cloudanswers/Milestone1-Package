public class CategorizeTimeCtrl {
    
    private String recId;

    public CategorizeTimeCtrl() {
        // do nothing
    }
    
    public CategorizeTimeCtrl(ApexPages.StandardController stdCon) {
        this.recId = stdCon.getId();
    }
    
    public PageReference startTimeCategorization() {
        AggregateResult ar = [
            select count(Id) EntryCount__c 
            from MPM4_BASE__Milestone1_Time__c 
            where MPM4_BASE__Project_Task__c = :recId
        ];
        Decimal entryCount = (Decimal) ar.get('EntryCount__c');
        if (entryCount > 8000) {
            CategorizeTaskTimeBatch obj = new CategorizeTaskTimeBatch(new Set<Id>{recId});
            Database.executeBatch(obj, 2000);
        } else {
            CategorizeTimeBatch obj = new CategorizeTimeBatch(recId);
        	Database.executeBatch(obj, 1);
        }
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your request has been submitted.');
        ApexPages.addMessage(msg);
        return null;
    }
}