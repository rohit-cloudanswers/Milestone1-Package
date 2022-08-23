global class CaseTimeBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'select Id from Case where LastModifiedDate < yesterday and Total_Time_Entered__c = null ';
        if(Test.isRunningTest()) query += ' order by CreatedDate desc limit 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        /*Set<Id> caseIds = new Set<Id>();
        for(Case c : scope) {
            caseIds.add(c.Id);
        }
        List<AggregateResult> results = [
            select sum(Hours__c) totalTime, Case__c from Milestone1_Time2__c 
            where Case__c != null AND Case__c IN :caseIds
            group by Case__c
        ];
        List<Case> toUpdate = new List<Case>();
        for(AggregateResult result : results) {
            toUpdate.add(new Case(
                Id=(Id)result.get('Case__c'),
                Total_Time_Entered__c=(Decimal)result.get('totalTime')
            ));
        }
        if(toUpdate.size() != 0) Database.update(toUpdate, false);*/
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
}