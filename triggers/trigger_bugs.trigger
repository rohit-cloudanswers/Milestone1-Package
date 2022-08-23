trigger trigger_bugs on Bug__c (before update, after insert, after update) {
    if (Trigger.isUpdate && Trigger.isBefore){
        blogic_Bug.updateDevComment(trigger.oldMap,trigger.newMap);
    }
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        // the JCFS interface apparently operates on the entirity of Trigger.new
        // so we don't use the loop to send specific records, we just use to to detect if a send should be performed
        try {
            for (Integer i=0; i < Trigger.new.size(); i++) {
                Bug__c b = Trigger.new[i];
                Bug__c b_old = Trigger.old == null ? new Bug__c() : Trigger.old[i];
                if (b.Jira_Sync__c == true && b.Jira_Sync__c != b_old.Jira_Sync__c) {
                    // trigger creation of new jira instance  
                    JCFS.API.createJiraIssue(b.Jira_Project_ID__c, b.Jira_Issue_Type_ID__c);
                } else if (b.Jira_Sync__c == true) {
                    // or if jira sync is enabled, always push?
                    JCFS.API.pushUpdatesToJira();
                }
            }
        } catch (Exception e) {
            // System.debug('IGNORING EXCEPTION: ' + e);
        }
    }
}