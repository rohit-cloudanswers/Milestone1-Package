global class BatchTimeReportingMSTime implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
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
        // TODO switch to formula to detect what field changes are important
        // Id NOT IN (select MS_Time2__c from Time_Reporting__c)
         return Database.getQueryLocator([
            SELECT Id, Name, Billable__c, Case__c, Category__c, Charge_Code__c, Date__c, 
            Description__c, Hours__c, Incurred_By__c, Opportunity__c, Time_Type__c,
            Case__r.Project__c
            FROM Milestone1_Time__c
            WHERE LastModifiedDate >= :asOf
            OR SystemModstamp >= :asOf
            
        ]);
        
    }
    
    /**
     * @description upsert a copy of the record into time reporting
     */
    global void execute(Database.BatchableContext bc, List<Milestone1_Time__c> msTimeList) {
      List<Time_Reporting__c> timeReportingList = new List<Time_Reporting__c>();
        for(Milestone1_Time__c mst : msTimeList) {
            Time_Reporting__c timeReporting = new Time_Reporting__c();
            timeReporting.MS_Time4__c = mst.Id;
            timeReporting.Time_Id__c = mst.Id;
            timeReporting.Name = mst.Name;
            timeReporting.Billable__c = mst.Billable__c;
            timeReporting.Category__c = mst.Category__c;
            timeReporting.Charge_Code__c = mst.Charge_Code__c;
            timeReporting.Date_Incurred__c = mst.Date__c;
            timeReporting.Description__c = mst.Description__c;
            timeReporting.Hours__c = mst.Hours__c;
            timeReporting.Incurred_By__c = mst.Incurred_By__c;
            timeReporting.Time_Type__c = mst.Time_Type__c;
            if(mst.Case__c != NULL) {
                timeReporting.Case__c = mst.Case__c;
                timeReporting.Time_Source__c = 'Case';
                // copy project (new obj) from case if populated
                if (mst.Case__r.Project__c != null)
                    timeReporting.Project__c = mst.Case__r.Project__c;
            } 
            if(mst.Opportunity__c != NULL) {
                timeReporting.Opportunity__c = mst.Opportunity__c;
                timeReporting.Time_Source__c = 'Opportunity';
            }
            timeReportingList.add(timeReporting);
        }
        Database.UpsertResult[] srList = Database.upsert(timeReportingList, Time_Reporting__c.Fields.Time_Id__c, false);
        handleErrors(srList, timeReportingList);
    }
    
    global void finish(Database.BatchableContext bc){
        
        deleteOrphaned();
        
        // don't email if no errors
        if(String.isBlank(upsertErrors)) {
            return;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
        String[] toAddresses = new String[] {'jsullivan+imagine@cloudanswers.com'};
        // TODO add person who scheduled the batch?
        mail.setToAddresses(toAddresses);
        mail.setSubject('MSTime to Time Reporting Errors');
        String body = 'Errors:\n\n' + upsertErrors;
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    /**
     * @description deleted records once linked to this object 
     */
     private void deleteOrphaned () {   
        String idLike = Milestone1_Time__c.sobjecttype.getDescribe().getKeyPrefix() + '%';
        List<Time_Reporting__c> toDelete = [
            select Id 
            from Time_Reporting__c
            where Time_Id__c like :idLike
            and MS_Time4__c not in (select Id from Milestone1_Time__c)
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