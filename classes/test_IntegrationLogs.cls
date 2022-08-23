@isTest
global class test_IntegrationLogs {
    
    global static testMethod void testCreateOracleLogs(){
        test.startTest();
            for(integer i=0;i<5;i++){
                blogic_IntegrationLog.createFromOracleLog(null, null, null, null, null, null, null, null);
                blogic_IntegrationLog.createToOracleLog(null, null, null, null, null, null, null, null);
            }
        	blogic_IntegrationLog.doInsertLogs();
        test.stopTest();
        
        list<integration_log__c> ils = [SELECT Id FROM Integration_Log__c];
        system.assertEquals(10, ils.size());
    }
    
    global static testMethod void testCreateLogs(){
        test.startTest();
            for(integer i=0;i<201;i++){
                blogic_IntegrationLog.createErrorLog('ActionTest',Null,'DetailTest');
            }
        	blogic_IntegrationLog.doInsertLogs();
        test.stopTest();
        
        list<integration_log__c> ils = [SELECT Id FROM Integration_Log__c];
        system.assertEquals(201, ils.size());
    }
	
	global static testMethod void testCreateLogErrors(){
        test.startTest();
            for(integer i=0;i<201;i++){
                string message = '';
                for(integer a = 0;a<=i;a++){
                    message += 'aa';
                }
                blogic_IntegrationLog.createErrorLog('ActionTest',message,'DetailTest');
            }
        	blogic_IntegrationLog.doInsertLogs();
        test.stopTest();
        //only 127 of the inserts should have succeeded due to field size constraints on the message field
        list<integration_log__c> ils = [SELECT Id FROM Integration_Log__c];
        system.assertEquals(127, ils.size());
    }    

}