public class AggregateTasksIterable implements Iterable<ProjectTaskGroup> {
    
    private String query;
    
    public AggregateTasksIterable(String soql){
        query = soql;
    }
    
    public Iterator<ProjectTaskGroup> iterator(){
        return new AggregateTasksIterator(query);
    }
}