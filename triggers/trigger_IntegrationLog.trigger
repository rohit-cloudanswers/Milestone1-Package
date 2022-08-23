trigger trigger_IntegrationLog on Integration_Log__c (after insert) {
    if(trigger.isInsert && trigger.isAfter){
        //this process has been removed and will be placed into a batch operation.
         
        //get the logs to delete
        //blogic_IntegrationLog.getLogsToClean(trigger.newMap);
        
        //perform any necessary logic
        
        //clean the logs
        //blogic_IntegrationLog.cleanLogs();
    }
}