public class JCFS_API_Create_Jira_Issue_Invocable {
    
    public class Request {
        @InvocableVariable(required=true)
        public SObject record;
        @InvocableVariable(required=true)
        public String jiraProjectId;
        @InvocableVariable(required=true)
		public String jiraIssueTypeId;
    }
    
    @InvocableMethod()
	public static void createJiraIssue(Request[] reqs) {
        for (Request r : reqs) {
            JCFS.API.createJiraIssue(r.jiraProjectId, r.jiraIssueTypeId, new List<SObject>{r.record}, null);
        }
    }
}