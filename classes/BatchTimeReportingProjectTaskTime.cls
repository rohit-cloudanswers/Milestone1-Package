global class BatchTimeReportingProjectTaskTime implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    public String upsertErrors = '';
    public Integer batchSize = 200;
    public Datetime asOf = Datetime.now().addHours(-24);
    
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
        // TODO Id not in (select MPM4_Time__c from Time_Reporting__c)
        return Database.getQueryLocator([
            SELECT Id, Name, Billable__c, Category__c, Charge_Code__c, MPM4_BASE__Date__c,
            MPM4_BASE__Description__c, MPM4_BASE__Hours__c, MPM4_BASE__Incurred_By__c, Time_Type__c,
            MPM4_BASE__Project_Task__c, MPM4_BASE__Project_Task__r.MPM4_BASE__Project_Milestone__c,
            MPM4_BASE__Project_Task__r.MPM4_BASE__Project_Lookup__c
            FROM MPM4_BASE__Milestone1_Time__c 
            WHERE LastModifiedDate >= :asOf
	        OR SystemModstamp >= :asOf
        ]);
    }
    
    /**
     * @description upsert a copy of the record into time reporting
     */
    global void execute(Database.BatchableContext bc, List<MPM4_BASE__Milestone1_Time__c> mpmTimeList) {
        List<Time_Reporting__c> toUpsert = new List<Time_Reporting__c>();
        for(MPM4_BASE__Milestone1_Time__c mst : mpmTimeList) {
            Time_Reporting__c timeReporting = new Time_Reporting__c();
            timeReporting.MPM4_Time__c = mst.Id;
            timeReporting.Time_Id__c = mst.Id;
            timeReporting.Name = mst.Name;
            timeReporting.Billable__c = mst.Billable__c;
            timeReporting.Category__c = mst.Category__c;
            timeReporting.Charge_Code__c = mst.Charge_Code__c;
            timeReporting.Date_Incurred__c = mst.MPM4_BASE__Date__c;
            timeReporting.Description__c = mst.MPM4_BASE__Description__c;
            timeReporting.Hours__c = mst.MPM4_BASE__Hours__c;
            timeReporting.Incurred_By__c = mst.MPM4_BASE__Incurred_By__c;
            timeReporting.Time_Type__c = mst.Time_Type__c;
            timeReporting.MS_Task__c = mst.MPM4_BASE__Project_Task__c;
            timeReporting.Milestone__c = mst.MPM4_BASE__Project_Task__r.MPM4_BASE__Project_Milestone__c;
            timeReporting.Project__c = mst.MPM4_BASE__Project_Task__r.MPM4_BASE__Project_Lookup__c;
            if (timeReporting.Project__c != null) timeReporting.Time_Source__c = 'Project';
            toUpsert.add(timeReporting);
        }
        handleErrors(Database.upsert(toUpsert, Time_Reporting__c.Fields.Time_Id__c, false), toUpsert);
        
        deleteOrphaned();
    }
    
    /**
     * @description send email with errors if any occurred
     */
    global void finish(Database.BatchableContext bc){
        
        deleteOrphaned();
        
        if(String.isBlank(upsertErrors)) return;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
        String[] toAddresses = new String[] {'jsullivan+imagine@cloudanswers.com'};
        // TODO add person who scheduled the batch?
        mail.setToAddresses(toAddresses);
        mail.setSubject('[BatchTimeReportingProjectTaskTime] Errors');
        String body = 'Errors:\n\n' + upsertErrors;
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		System.assert(!Test.isRunningTest(), this.upsertErrors);
    }
    
    /**
     * @description deleted records once linked to this object 
     */
    private void deleteOrphaned () {
        String idLike = MPM4_BASE__Milestone1_Time__c.sobjecttype.getDescribe().getKeyPrefix() + '%';
        List<Time_Reporting__c> toDelete = [
            select Id 
            from Time_Reporting__c
            where Time_Id__c like :idLike
            and MPM4_Time__c not in (select Id from MPM4_BASE__Milestone1_Time__c)
            limit :this.batchSize
        ];
        handleErrors(Database.delete(toDelete, false), toDelete);
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