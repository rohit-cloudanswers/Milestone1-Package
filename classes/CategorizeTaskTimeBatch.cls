public class CategorizeTaskTimeBatch extends BatchErrorAlert implements Database.Batchable<sObject>, Schedulable, Database.Stateful {

    private Set<Id> taskIds;
    private Map<Id, Decimal> taskHoursBalance;

    public CategorizeTaskTimeBatch() {
        taskIds = new Set<Id>();
        this.taskHoursBalance = new Map<Id, Decimal>();
    }

    public CategorizeTaskTimeBatch(Set<Id> taskIds) {
        this();
        this.taskIds = taskIds;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'select Id, MPM4_BASE__Hours__c, Billable_Hours__c, Overrun_Hrs__c,'
            + ' MPM4_BASE__Date__c, Billable__c, MPM4_BASE__Project_Task__c,'
            + ' MPM4_BASE__Project_Task__r.MPM4_BASE__Estimated_Hours__c'
            + ' from MPM4_BASE__Milestone1_Time__c'
            + ' where MPM4_BASE__Project_Task__c IN :taskIds'
            + ' and MPM4_BASE__Hours__c != null'
            + ' order by MPM4_BASE__Project_Task__c, MPM4_BASE__Date__c asc';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<MPM4_BASE__Milestone1_Time__c> toUpdate = new List<MPM4_BASE__Milestone1_Time__c>();
        for (MPM4_BASE__Milestone1_Time__c timeEntry : (List<MPM4_BASE__Milestone1_Time__c>) scope) {
            String taskId = timeEntry.MPM4_BASE__Project_Task__c;
            if (!taskHoursBalance.containsKey(taskId)) {
                taskHoursBalance.put(taskId, timeEntry.MPM4_BASE__Project_Task__r.MPM4_BASE__Estimated_Hours__c);
            }
            Decimal hoursBalance = taskHoursBalance.get(taskId);
            Boolean skipUpdate = false;
            if (hoursBalance == null) {
                if (timeEntry.Billable_Hours__c != timeEntry.MPM4_BASE__Hours__c || timeEntry.Overrun_Hrs__c != 0 || timeEntry.Billable__c != true) {
                    // estimated hours = null
                    timeEntry.Billable_Hours__c = timeEntry.MPM4_BASE__Hours__c;
                    timeEntry.Overrun_Hrs__c = 0;
                    timeEntry.Billable__c = true;
                } else {
                    skipUpdate = true;
                }
            } else if (hoursBalance == 0) {
                // estimated hours = 0
                timeEntry.Billable_Hours__c = 0;
                timeEntry.Overrun_Hrs__c = timeEntry.MPM4_BASE__Hours__c;
                timeEntry.Billable__c = false;
            } else {
                // non-zero estimated hours
                if (hoursBalance == 0) {                        
                    timeEntry.Overrun_Hrs__c = timeEntry.MPM4_BASE__Hours__c;
                    timeEntry.Billable_Hours__c = 0;
                    timeEntry.Billable__c = false;
                } else if (timeEntry.MPM4_BASE__Hours__c <= hoursBalance) {
                    hoursBalance -= timeEntry.MPM4_BASE__Hours__c;    
                    timeEntry.Billable_Hours__c = timeEntry.MPM4_BASE__Hours__c;
                    timeEntry.Overrun_Hrs__c = 0;
                    timeEntry.Billable__c = true;
                } else {
                    timeEntry.Billable_Hours__c = hoursBalance;
                    timeEntry.Overrun_Hrs__c = timeEntry.MPM4_BASE__Hours__c - hoursBalance;
                    timeEntry.Billable__c = true;
                    hoursBalance = 0;                        
                }
            }
            // don't go by value, flow ignores the ones with value = true
            timeEntry.forFlow__c = true;
            if (!skipUpdate) toUpdate.add(timeEntry);
            taskHoursBalance.put(taskId, hoursBalance);
        }
        if (toUpdate.size() != 0) collectErrors(Database.update(toUpdate));
    }
    
    public void finish(Database.BatchableContext bc) {
        addToAddress('imaginecommunications@cambridgecloudpartners.com');
        addCcAddress(UserInfo.getUserEmail());
        sendErrorEmails();
    }
    
    public static void run() {
        CategorizeTaskTimeBatch obj = new CategorizeTaskTimeBatch();
        Database.executeBatch(obj, 2000);
    }

    public void execute(SchedulableContext sc) {
        // only scheduling for Admin Project tasks
        Map<Id, MPM4_BASE__Milestone1_Task__c> tasksMap = new Map<Id, MPM4_BASE__Milestone1_Task__c>([
            select Id 
            from MPM4_BASE__Milestone1_Task__c 
            where MPM4_BASE__Project_Lookup__r.Name = 'Admin Project'
        ]);
        CategorizeTaskTimeBatch obj = new CategorizeTaskTimeBatch(tasksMap.keySet());
        Database.executeBatch(obj, 2000);
    }
}