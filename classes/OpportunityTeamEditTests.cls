@isTest
private class OpportunityTeamEditTests {

	@isTest static void integrationTest() {
		Opportunity testOpportunity = TestDataFactory.createOpportunity(null);
		ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunity);
		OpportunityTeamEdit controller = new OpportunityTeamEdit(sc);
		controller.save();
		controller.addTeamMemberRow();
		controller.defaultRoles();
        System.assert(controller.team != null && controller.team.size() != 0);
        controller.deleteId = controller.team.get(0).Id;
        controller.deleteTeamMember();
	}

}