public class CaseAssignmentRulesAction {
    @InvocableMethod(label='Reassign cases' description='')
    public static void getAccountNames(List<Id> caseIds) {
        reassignFuture(caseIds);
    }
    @future
    public static void reassignFuture (List<Id> ids) {
        // TODO elegantly error if no ARs
        AssignmentRule AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

        //recreating the DMLOptions setting for "Assign using active assignment rules" checkbox on Case object...
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
		dmlOpts.EmailHeader.triggerUserEmail = true;
        Case[] cases = [select Id from Case where Id in :ids];
        for (Case c : cases) {
            c.setOptions(dmlOpts);
        }

        update cases; 
    }
}