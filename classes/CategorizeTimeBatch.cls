// MUST run this batch with scope size of 1
public class CategorizeTimeBatch extends BatchErrorAlert implements Database.Batchable<ProjectTaskGroup>, Schedulable, Database.Stateful {

    private Id taskId;

    public CategorizeTimeBatch() {
        taskId = null;
    }

    public CategorizeTimeBatch(Id taskId) {
        this.taskId = taskId;
    }

    public Iterable<ProjectTaskGroup> start(Database.BatchableContext bc) {
        String query = 'select count(Id) EntryCount__c, MPM4_BASE__Project_Task__c ' 
            + ' from MPM4_BASE__Milestone1_Time__c ' 
            + ' where MPM4_BASE__Project_Task__r.Skip_Time_Calculation__c = false';
        if (String.isNotBlank(taskId)) {
            query += ' and MPM4_BASE__Project_Task__c = \'' + taskId + '\'';
        }
        query += ' and MPM4_BASE__Hours__c != null '
            + ' group by MPM4_BASE__Project_Task__c order by count(Id) desc';
        return new AggregateTasksIterable(query);
    }
    
    public void execute(Database.BatchableContext bc, List<ProjectTaskGroup> scope) {
        System.assertEquals(1, scope.size());
        List<MPM4_BASE__Milestone1_Time__c> timeEntries = [
            select Id, MPM4_BASE__Hours__c, Billable_Hours__c, Overrun_Hrs__c, 
            MPM4_BASE__Date__c, Billable__c, MPM4_BASE__Project_Task__c, 
            MPM4_BASE__Project_Task__r.MPM4_BASE__Estimated_Hours__c
            from MPM4_BASE__Milestone1_Time__c
            where MPM4_BASE__Project_Task__c IN :scope.get(0).getTaskIds()
            and MPM4_BASE__Hours__c != null
            order by MPM4_BASE__Project_Task__c, MPM4_BASE__Date__c asc
        ];
        
        Map<Id, Decimal> estimatedHoursMap = new Map<Id, Decimal>();
        Set<Id> alwaysOverrun = new Set<Id>();
        Set<Id> alwaysBillable = new Set<Id>();
        
        Map<Id, List<MPM4_BASE__Milestone1_Time__c>> taskTimeMap = new Map<Id, List<MPM4_BASE__Milestone1_Time__c>>();
        for (MPM4_BASE__Milestone1_Time__c timeEntry : timeEntries) {
            if (!taskTimeMap.containsKey(timeEntry.MPM4_BASE__Project_Task__c)) {
                taskTimeMap.put(timeEntry.MPM4_BASE__Project_Task__c, new List<MPM4_BASE__Milestone1_Time__c>());
            }
            taskTimeMap.get(timeEntry.MPM4_BASE__Project_Task__c).add(timeEntry);
            if (timeEntry.MPM4_BASE__Project_Task__r.MPM4_BASE__Estimated_Hours__c == null) {
                // all time is billable
                alwaysBillable.add(timeEntry.MPM4_BASE__Project_Task__c);
            } else if (timeEntry.MPM4_BASE__Project_Task__r.MPM4_BASE__Estimated_Hours__c <= 0) {
                // all time is overrun
                alwaysOverrun.add(timeEntry.MPM4_BASE__Project_Task__c);
            } else {
                // need calculation
                estimatedHoursMap.put(timeEntry.MPM4_BASE__Project_Task__c, timeEntry.MPM4_BASE__Project_Task__r.MPM4_BASE__Estimated_Hours__c);
            }
        }
        
        List<MPM4_BASE__Milestone1_Time__c> toUpdate = new List<MPM4_BASE__Milestone1_Time__c>();
        for (Id taskId : taskTimeMap.keySet()) {
            if (alwaysBillable.contains(taskId)) {
                // estimated hours = null
                List<MPM4_BASE__Milestone1_Time__c> taskTime = taskTimeMap.get(taskId);
                for (MPM4_BASE__Milestone1_Time__c timeEntry : taskTime) {
                    if (timeEntry.MPM4_BASE__Hours__c != timeEntry.Billable_Hours__c || timeEntry.Overrun_Hrs__c != 0 || timeEntry.Billable__c != true) {
                        timeEntry.Billable_Hours__c = timeEntry.MPM4_BASE__Hours__c;
                        timeEntry.Overrun_Hrs__c = 0;
                        timeEntry.Billable__c = true;
                        // don't go by value, flow ignores the ones with value = true
                        timeEntry.forFlow__c = true;
                        toUpdate.add(timeEntry);
                    }
                }
            } else if (alwaysOverrun.contains(taskId)) {
                // estimated hours = 0
                List<MPM4_BASE__Milestone1_Time__c> taskTimes = taskTimeMap.get(taskId);
                for (MPM4_BASE__Milestone1_Time__c timeEntry : taskTimes) {
                    if (timeEntry.Billable_Hours__c != 0 || timeEntry.Overrun_Hrs__c != timeEntry.MPM4_BASE__Hours__c || timeEntry.Billable__c != false) {
                        timeEntry.Billable_Hours__c = 0;
                        timeEntry.Overrun_Hrs__c = timeEntry.MPM4_BASE__Hours__c;
                        timeEntry.Billable__c = false;
                        // don't go by value, flow ignores the ones with value = true
                        timeEntry.forFlow__c = true;
                        toUpdate.add(timeEntry);
                    }
                }
            } else {
                // non-zero estimated hours
                Decimal hoursAvailable = estimatedHoursMap.get(taskId);
                List<MPM4_BASE__Milestone1_Time__c> taskTime = taskTimeMap.get(taskId);
                for (MPM4_BASE__Milestone1_Time__c timeEntry : taskTime) {
                    Boolean doUpdate = false;
                    if (hoursAvailable == 0) {
                        if (timeEntry.Overrun_Hrs__c != timeEntry.MPM4_BASE__Hours__c || timeEntry.Billable_Hours__c != 0 || timeEntry.Billable__c != false) {
                            timeEntry.Overrun_Hrs__c = timeEntry.MPM4_BASE__Hours__c;
                            timeEntry.Billable_Hours__c = 0;
                            timeEntry.Billable__c = false;
                            doUpdate = true;
                        } 
                    } else if (timeEntry.MPM4_BASE__Hours__c <= hoursAvailable) {
                        hoursAvailable -= timeEntry.MPM4_BASE__Hours__c;
                        if (timeEntry.Billable_Hours__c != timeEntry.MPM4_BASE__Hours__c || timeEntry.Overrun_Hrs__c != 0 || timeEntry.Billable__c != true) {
                            timeEntry.Billable_Hours__c = timeEntry.MPM4_BASE__Hours__c;
                            timeEntry.Overrun_Hrs__c = 0;
                            timeEntry.Billable__c = true;
                            doUpdate = true;
                        }
                    } else {
                        if (timeEntry.Billable_Hours__c != hoursAvailable || timeEntry.Overrun_Hrs__c != (timeEntry.MPM4_BASE__Hours__c - hoursAvailable) || timeEntry.Billable__c != true) {
                            timeEntry.Billable_Hours__c = hoursAvailable;
                            timeEntry.Overrun_Hrs__c = timeEntry.MPM4_BASE__Hours__c - hoursAvailable;
                            timeEntry.Billable__c = true;
                            doUpdate = true;
                        }
                        hoursAvailable = 0;                        
                    }
                    timeEntry.forFlow__c = true;
                    if (doUpdate) toUpdate.add(timeEntry);
                }
            }
        }
        if (toUpdate.size() != 0) collectErrors(Database.update(toUpdate));
    }
    
    public void finish(Database.BatchableContext bc) {
        addToAddress('imaginecommunications@cambridgecloudpartners.com');
        sendErrorEmails();
    }
    
    public void execute(SchedulableContext sc) {
        run();
    }
    
    public static void run() {
        CategorizeTimeBatch obj = new CategorizeTimeBatch();
        Database.executeBatch(obj, 1);
    }
}