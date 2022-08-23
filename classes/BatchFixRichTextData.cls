global class BatchFixRichTextData implements Database.Batchable < Sobject > {

    global Database.queryLocator start(Database.BatchableContext bc) {
        String query = 'select id,Customer_Notes__c, Cover_Sheet_Comments__c from quote';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List < Sobject > scope) {
        List < Quote > lstQuotes = new List < Quote > ();
        for (Quote q: (List < Quote > ) scope) {
            if (String.isNotBlank(q.Cover_Sheet_Comments__c) || String.isNotBlank(q.Customer_Notes__c)) {
                if (String.isNotBlank(q.Cover_Sheet_Comments__c) && q.Cover_Sheet_Comments__c.contains('\n')) {
                    q.Cover_Sheet_Comments__c = q.Cover_Sheet_Comments__c.replaceAll('\n', '<br/>');
                }
                if (String.isNotBlank(q.Customer_Notes__c) && q.Customer_Notes__c.contains('\n')) {
                    q.Customer_Notes__c = q.Customer_Notes__c.replaceAll('\n', '<br/>');
                }
                lstQuotes.add(q);
            }
        }
        if (lstQuotes.size() > 0) {
            Database.update(lstQuotes, false);
        }
    }

    global void finish(Database.BatchableContext bc) {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =: BC.getJobId()
        ];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { a.CreatedBy.Email };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Quotes Rich Text data conversion ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
            ' batches with ' + a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}