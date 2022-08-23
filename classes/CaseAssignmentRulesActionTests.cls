@IsTest
public class CaseAssignmentRulesActionTests {
	@IsTest static void getAccountNames_coverage () {
        // not doing test record setup because this is a thin wrapper on a system method
        // just passing a "valid" id to get coverage to be good
        CaseAssignmentRulesAction.getAccountNames(new List<Id>{'5000v0000000001'});
    }
}