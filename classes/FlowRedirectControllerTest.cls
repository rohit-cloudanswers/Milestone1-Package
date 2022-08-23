@isTest
private class FlowRedirectControllerTest {
    private static FlowRedirectController controller = new FlowRedirectController();
	@testSetup static void setup() {
        Test.loadData(Case.sObjectType, 'TestData_Case');
        Test.loadData(Bug__c.sObjectType, 'TestData_Bug');
    }
    static testMethod void testRealId () {
        Test.setCurrentPageReference(new PageReference('/FlowRedirectController?id=some_random_id'));
        PageReference result = controller.onLoad();
        System.assertEquals(result.getUrl(), '/' + [select Id from Bug__c limit 1].Id);
    }
    static testMethod void testBlankId () {
        Test.setCurrentPageReference(new PageReference('/FlowRedirectController?id='));
        PageReference result = controller.onLoad();
        System.assert(result.getUrl().contains('home.jsp'), 'should redirect home');
    }
    static testMethod void testBadId () {
        Test.setCurrentPageReference(new PageReference('/FlowRedirectController?id=BAD_ID'));
        PageReference result = controller.onLoad();
        System.assert(result.getUrl().contains('home.jsp'), 'should redirect home');
    }
}