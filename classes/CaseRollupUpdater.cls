global class CaseRollupUpdater implements Database.Batchable<SObject>, Schedulable {
    
    global String iteratorQuery = 
        'select Id, Total_Time_Entered__c, Total_Hours_Incurred__c '+
        'from Case where LastModifiedDate >= last_n_days:7';
    
   	global String aggregateQuery = 
        'select Case__c Id, '+
        'sum(Hours__c) Total_Time_Entered__c, '+
        'sum(Hours__c) Total_Hours_Incurred__c  '+
        'from Milestone1_Time__c where Case__c in :scopeIds group by Case__c';
    
    global Set<String> destinationFields = new Set<String>{'Total_Time_Entered__c', 'Total_Hours_Incurred__c'};
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(iteratorQuery);
	}
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Map<Id, sObject> scopeMap = new Map<Id, sObject>(scope);
        Set<Id> scopeIds = scopeMap.keySet();
        Map<Id, sObject> toUpdate = new Map<Id, sObject>();
        for (AggregateResult ar : Database.query(aggregateQuery)) {
            System.debug('AggregateResult: ' + ar);
            sObject c = scopeMap.get((String)ar.get('Id'));
            for (String f : destinationFields) {
                Decimal aggregateValue = (Decimal)ar.get(f);
                if ((Decimal)c.get(f) != aggregateValue) {
                    c.put(f, aggregateValue);
                    toUpdate.put(c.Id, c);
                }
            }
        }
        update toUpdate.values();
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
    public static void run (Integer daysBackToProcess) {
        CaseRollupUpdater b = new CaseRollupUpdater();
        b.iteratorQuery = b.iteratorQuery.replace('last_n_days:7', 'last_n_days:' + daysBackToProcess);
		Database.executeBatch(b, 50);
    }
	
    public static void run () {
		run(7);
    }
    
    global void execute(SchedulableContext sc) {
        CaseRollupUpdater.run();
    }
}