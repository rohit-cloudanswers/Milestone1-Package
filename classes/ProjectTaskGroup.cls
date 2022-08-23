public class ProjectTaskGroup {

	// task ids must not be greater than 500    
    private static final Integer MAX_TASKS = 500;
    // time entry count must not exceed 8000
    private static final Integer MAX_ENTRIES = 8000;

    private List<Id> taskIds;
    private Integer timeEntryCount;
    
    public ProjectTaskGroup() {
        this.taskIds = new List<Id>();
        this.timeEntryCount = 0;
    }
    
    public void updateGroup(AggregateResult res) {
        Id taskId = (Id) res.get('MPM4_BASE__Project_Task__c');
        this.taskIds.add(taskId);
        Integer entryCount = (Integer) res.get('EntryCount__c');
        this.timeEntryCount += entryCount;
    }
    
    public Boolean hasSpace(AggregateResult res) {
        Integer entryCount = (Integer) res.get('EntryCount__c');
        return taskIds.size() < MAX_TASKS && (timeEntryCount + entryCount) <= MAX_ENTRIES;
    }
    
    public List<Id> getTaskIds() {
        return taskIds;
    }
}