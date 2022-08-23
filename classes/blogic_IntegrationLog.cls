global without sharing class blogic_IntegrationLog implements Database.Batchable<sObject>{
	
    global static list<Integration_Log__c> insertLogs {get;set;}
    global static set<Id> currentIdSet {get;set;}
    
    global Database.queryLocator start(Database.BatchableContext bc){
        String query = '';
        if(test.isRunningTest()){
            query = 'Select id from Integration_Log__c limit 200';
        }
        else{
            query = 'SELECT Id FROM Integration_Log__c WHERE ((DeleteDate__c < TODAY AND (IsResolved__c = true or Requires_Attention__c = false)) OR (DeleteDate__c < LAST_N_DAYS:15)) LIMIT 50000';
        }
         return Database.getQueryLocator(query); 
      }
    
    global void execute(Database.BatchableContext BC, List<Integration_Log__c> scope){
        system.debug('==================================================');
        try{
            List<Database.DeleteResult> drs = database.delete(scope,false);
            system.debug('  cleanLogs deleteResult size: ' + drs.size());
            integer i = 0;
            for(Database.DeleteResult dr : drs){
                if(!dr.isSuccess()){
                    system.debug('******************************************************************');
                    system.debug('  Delete Integration Log Error');
                    system.debug('  ID: ' + scope[i].Id);
                    // Operation failed, so get all errors                
                    for(Database.Error err : dr.getErrors()) {   
                        System.debug('    Error Code: ' + err.getStatusCode());
                        System.debug('    Message: ' + err.getMessage());
                        System.debug('    Fields that affected this error: ' + err.getFields());
                    }
                    system.debug('******************************************************************');
                }
                i++;
            }
        } catch (exception e){
            system.debug('******************************************************************');
            system.debug('  Clean Log Exception: ' + e.getMessage());
            system.debug('  Clean Log Stack Trace: ' + e.getStackTraceString());
            system.debug('******************************************************************');
        } finally {
            system.debug('==================================================');
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
    //create an Integration Log of Category type error with requires Attention set to true
    global static void createErrorLog(string Action, string Message, string Detail){
        createErrorLog(Action, Message, Detail, Null, Null);
    }
    
    //create an Integration Log of Category type error with requires Attention set to true
    global static void createErrorLog(string Action, string Message, string Detail, 
                                      string ObjectAPI, string ObjectId){
        createLog('Error', null,
                  Action, Message, Detail,
                  ObjectAPI, ObjectId,
                  Null,Null,
                  Null,Null,
                 true);
    }
    
    //create an Integration Log of Category type Integration from SF to Oracle
    global static void createToOracleLog(string Action, string Message, string Detail, 
                                         string ObjectAPI, string ObjectId,
                                         string OracleID, string BatchID, boolean RequiresAttention){
        createLog('Integration', 'OutFromSF',
                  Action, Message, Detail,
                  ObjectAPI, ObjectId,
                  'Oracle',Null,
                  BatchId,Null,
                  RequiresAttention);
    }
    
    //create an Integration Log of Category type Integration from Oracle to SF
    global static void createFromOracleLog(string Action, string Message, string Detail, 
                                      	   string ObjectAPI, string ObjectId,
                                           string OracleId, string BatchID, boolean RequiresAttention){
        createLog('Integration', 'InToSF',
                  Action, Message, Detail,
                  ObjectAPI, ObjectId,
                  'Oracle',Null,
                  BatchId,Null,
                  RequiresAttention);
    }
    
    global static void createLog(string Category, string Direction, 
                                 string Action, string Message, string Detail, 
                                 string ObjectAPI, string ObjectId,
                                 string ExternalSystem, string ExternalId,
                                 string BatchId, integer DaysToKeep, 
                                 boolean RequiresAttention){       
        if(insertLogs==null)
            insertLogs = new List<Integration_Log__c>();
       
        try{
        	Integration_Log__c il = new Integration_Log__c();
        	il.Category__c = Category;
            il.Direction__c = Direction;
            
            il.Action__c = Action;
            if(String.isBlank(Message))
            	Message = 'No Message supplied';
        	il.Message__c = Message;
        	il.Detail__c = Detail;
                                     
        	il.Object_Api_Name__c = ObjectApi;
        	il.Object_Id__c = ObjectId;
                                     
            il.External_System__c = ExternalSystem;
            il.External_Id__c = ExternalId;
                                     
            il.Batch_Id__c = BatchId;
            if(DaysToKeep!=null)
            	il.Days_to_Keep__c = DaysToKeep;
            
            if(RequiresAttention==null)
                	RequiresAttention = false;
            il.Requires_Attention__c = RequiresAttention;
        	insertLogs.add(il);
        } catch (exception e){
            system.debug('******************************************************************');
            system.debug('  createLog error: ' + e.getMessage() );
            system.debug('  createLog stack: ' + e.getStackTraceString() );
            system.debug('******************************************************************');
        }
    }
    
    global static void doInsertLogs(){
        system.debug('==================================================');
        system.debug('  doInsertLogs InsertLogs Size: ' + insertLogs.size());
        system.debug('  insertLogs: ' + insertLogs);
        system.debug('==================================================');
        If(insertLogs!=null && insertLogs.size()>0){
            try{
                List<Database.SaveResult> srs = database.insert(insertLogs, false);
                integer i = 0;
                for(Database.SaveResult sr : srs){
                    if(!sr.isSuccess()){
                        system.debug('******************************************************************');
                        system.debug('  Create Integration Log Error');
                        system.debug('  Integration Log: ' + insertLogs[i]);
                        // Operation failed, so get all errors    
                        // we can't write errors here to the log object because that might cause recursion             
                        for(Database.Error err : sr.getErrors()) {   
                            System.debug('    Error Code: ' + err.getStatusCode());
                            System.debug('    Message: ' + err.getMessage());
                            System.debug('    Fields that affected this error: ' + err.getFields());
                        }
                        system.debug('******************************************************************');
                    }
                    i++;
                }
                insertLogs.clear();
            } catch (exception e){
                //we can't write errors here to the log object because that might cause recursion 
                system.debug('******************************************************************');
                system.debug('  Insert Log Exception: ' + e.getMessage());
                system.debug('  Insert Log Stack Trace: ' + e.getStackTraceString());
                system.debug('******************************************************************');
            }
        }
    }
}