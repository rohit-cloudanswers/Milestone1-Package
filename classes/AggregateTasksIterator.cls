public class AggregateTasksIterator implements Iterator<ProjectTaskGroup> {
    
    private AggregateResult[] results {get;set;}
    private Integer index {get; set;}
    
    public AggregateTasksIterator(String query) {
        index = 0;
        results = Database.query(query);
    }
    
    public Boolean hasNext() {
        return results != null && !results.isEmpty() && index < results.size();
    }
    
    public ProjectTaskGroup next() {
        ProjectTaskGroup taskEntryGroup = new ProjectTaskGroup();
        AggregateResult res = results[index];
        while (taskEntryGroup.hasSpace(res)) {
            taskEntryGroup.updateGroup(res);
            index++;
            if (index < results.size()) {
                res = results[index];
            } else {
                break;
            }
        }
        return taskEntryGroup;
    }
}