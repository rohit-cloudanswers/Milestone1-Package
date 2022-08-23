global class BatchArchiveAccountHistory implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    public String upsertErrors;
    public Datetime asOf;
    public Integer batchSize = 200;
    
    /** 
     * @description Schedulable interface entrypoint
     */
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, this.batchSize);
    }
    
    /**
     * @description query for records which are not yet in the time reporting table or are out of date
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if (this.asOf == null) {
            asOf = Datetime.now().addHours(-24);
        }
        return Database.getQueryLocator([
            SELECT AccountId, CreatedById, CreatedBy.Name, CreatedDate, DataType,
            Field, Id, IsDeleted, NewValue, OldValue
            FROM AccountHistory
            WHERE CreatedDate >= :this.asOf
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<AccountHistory> accHistoryList) {
        List<Archive_Account_History__c> customHistories = new List<Archive_Account_History__c>();
        for(AccountHistory ach : accHistoryList) {
            Archive_Account_History__c h = new Archive_Account_History__c();
            h.Account__c = ach.AccountId;
            h.Account_History_Id__c = ach.Id;
            h.Created_Date__c = ach.CreatedDate;
            h.Field__c = ach.Field;
            h.New_Value__c = (String)ach.NewValue;
            h.Old_Value__c = (String)ach.OldValue;
            h.User__c = ach.CreatedBy.Name;
            customHistories.add(h);
        }
        
        convertIdsToNames(customHistories);
        
        handleErrors(Database.upsert(customHistories, Archive_Account_History__c.fields.Account_History_Id__c, false), customHistories);

    }
    
    @TestVisible
    private void convertIdsToNames (List<Archive_Account_History__c> histories) {
        Set<Id> userIds = new Set<Id>();
        for (Archive_Account_History__c h : histories) {
        	if (String.valueOf(h.Field__c).equalsIgnoreCase('Owner')) {
                if (String.isNotBlank(h.New_Value__c))
                    try {
	                    userIds.add(Id.valueOf(h.New_Value__c));
                    } catch (Exception e) {
                        // ignore
                    }
                if (String.isNotBlank(h.Old_Value__c)) 
                    try {
	                    userIds.add(Id.valueOf(h.Old_Value__c));
                    } catch (Exception e) {
                        // ignore
                    }
            }
        }
        
        Map<Id, User> users = new Map<Id, User>([
            select Id, Username 
            from User 
            where Id in :userIds
        ]);
        
        for (Archive_Account_History__c h : histories) {
            if (String.valueOf(h.Field__c).equalsIgnoreCase('Owner')) {
                if (String.isNotBlank(h.New_Value__c)) 
                    try {
                        h.New_Value__c = users.get(Id.valueOf(h.New_Value__c)).Username;
                    } catch (Exception e) {
                        // ignore 
                    }
				if (String.isNotBlank(h.Old_Value__c)) 
                    try {
                        h.Old_Value__c = users.get(Id.valueOf(h.Old_Value__c)).Username;
                    } catch (Exception e) {
                        // ignore 
                    }
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
		// don't email if no errors
        if(String.isBlank(upsertErrors)) {
			return;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
        List<String> toAddresses = new List<String>();
        toAddresses.add([select Email from User where Id = :UserInfo.getUserId()].Email);
        mail.setToAddresses(toAddresses);
        mail.setSubject('[BatchArchiveAccountHistory] Errors');
        String body = 'Errors:\n\n' + upsertErrors;
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    /**
     * @description finds errors in dml results and appends them to an error email body
     * @param dmlResultList the resulting list of objects to process
     * @param records the records that were sent to the dml call
     */
    private void handleErrors (List<Object> dmlResultList, List<SObject> records) {
        System.assertEquals(dmlResultList.size(), records.size(), 'different counts on records and dml results');
        for (Integer i=0; i < dmlResultList.size(); i++) {
            SObject sobj = records[i];
            List<Database.Error> errors = new List<Database.Error>();
            Database.UpsertResult ur = dmlResultList[i] instanceOf Database.UpsertResult ? (Database.UpsertResult)dmlResultList[i] : null;
            if (ur != null) errors.addAll(ur.getErrors());
            Database.DeleteResult dr = dmlResultList[i] instanceOf Database.DeleteResult ? (Database.DeleteResult)dmlResultList[i] : null;
            if (dr != null) errors.addAll(dr.getErrors());
            for(Database.Error e : errors) {
                upsertErrors += '[' + sobj.Id + '] ' + e + '\n';
                // upsertErrors += sobj + '\n';
            }
        }
    }
    
}