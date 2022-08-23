@isTest
public class test_Bugs {
    public static testmethod void testBugComments(){
        list<Case> cases = test_utility.createCases(1,true);
		bug__c bug = new bug__c();
		bug.Case__c = cases[0].Id;
		bug.Bug_Attachments__c = true;
		bug.Comments__c = 'Test';
		bug.Description__c = 'Description';
		Bug.Developer_Comments__c = 'DevComments';
        bug.Status__c = 'submitted';
		insert bug;
        bug.Comments__c = 'More Test';
        bug.Description__c = 'More Description';
        bug.Developer_Comments__c = 'More DevComments';
        update bug;
        blogic_bug.sendBug(bug.Id);
        blogic_BugRestApi.doPost();
    }
    public static testMethod void getBug() {
        blogic_BugRestApi.getBug('test');
    }
    public static testMethod void doGet() {
		RestContext.request = new RestRequest();
        
        // without bugId
        blogic_BugRestApi.doGet();
        
        // with bugId
        RestContext.request.params.put('bugId', 'test');
        blogic_BugRestApi.doGet();
    }
    public static testMethod void nnull() {
        System.assertEquals('', blogic_BugRestApi.nnull(''));
        System.assertNotEquals(null, blogic_BugRestApi.nnull(null));
    }
}