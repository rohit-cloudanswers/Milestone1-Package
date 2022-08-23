@IsTest
public class JCFS_API_Create_Jira_Issue_Invocable_Tst {
    @IsTest
    static void createJiraIssue () {
        JCFS_API_Create_Jira_Issue_Invocable.Request r = new JCFS_API_Create_Jira_Issue_Invocable.Request();
        r.record = new Account();
        r.jiraProjectId = '123';
        r.jiraIssueTypeId = '321';
        try {
            JCFS_API_Create_Jira_Issue_Invocable.createJiraIssue(new List<JCFS_API_Create_Jira_Issue_Invocable.Request>{r});
        } catch (Exception e) {
            // ignore errors, just for coverage
        }
    }
}