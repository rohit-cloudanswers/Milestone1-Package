@isTest
global class test_IntegrationLogsClean {
    
    global static testMethod void testCleanLogs(){
        
        //create logs that would persist for 30 days
        for(integer i=0;i<100;i++){
            blogic_IntegrationLog.createErrorLog('ActionTest','MessageTest','DetailTest');
        }
        blogic_IntegrationLog.doInsertLogs();
        //create logs that should be deleted
        for(integer i=0;i<250;i++){
            blogic_integrationLog.createLog('Category', 'Direction', 'Action', 'Message', 
                                            'Detail', 'ObjectAPI', 'ObjectId', 'ExternalSystem', 
                                            'ExternalId', 'BatchId', -2, false);
        }
        test.startTest();
        schedule_IntegrationLog.startbatch();
        test.stopTest();

        list<Integration_Log__c> ilds = [SELECT Id FROM Integration_Log__c 
                                         WHERE DeleteDate__c < TODAY 
                                         AND (IsResolved__c = true or Requires_Attention__c = false)];
        system.assertEquals(0, ilds.size());

        
        
    }
    
    
}