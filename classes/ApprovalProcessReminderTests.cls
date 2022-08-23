@IsTest
public class ApprovalProcessReminderTests {
    
    class MyTestException extends Exception {
    }
    
    static testMethod void testBatch () {
        Set<Id> setActorIds = new Set<Id>{UserInfo.getUserId()};
        Test.startTest();
        ApprovalProcessReminder.runBatch(setActorIds);
        Test.stopTest();
    }

    static testMethod  void testPageMethods () {
        Test.startTest();
        ApprovalProcessReminder.schedule();
        ApprovalProcessReminder.deschedule();
        System.assert(!ApprovalProcessReminder.getIsScheduled());
        System.assert(!ApprovalProcessReminder.getIsRunning());
        Test.stopTest();
    }
   	
    static testMethod void shouldMakeEmail () {
        Test.startTest();
        String emailBody = ApprovalProcessReminder.emailBody(
            new List<ProcessInstanceWorkitem> {new ProcessInstanceWorkItem()}, 
            new List<sbaa__Approval__c>{new sbaa__Approval__c(Quote__r = new SBQQ__Quote__c())}
        );
        System.assert(emailBody != null);
        Test.stopTest();
    }
    
    static testMethod void shouldFindGroupsForUser () {

        // Given a user in a group
        Group g1 = new Group(Name='APR-TEST-1');
        insert g1;
        GroupMember gm1 = new GroupMember(GroupId=g1.Id, UserOrGroupId=UserInfo.getUserId());
        insert gm1;

        // and given a user in a group in a group

        Group g2 = new Group(Name='APR-TEST-2');
        insert g2;
        Group g2b = new Group(Name='APR-TEST-2b');
        insert g2b;
        GroupMember gm2 = new GroupMember(GroupId=g2.Id, UserOrGroupId=g2b.Id);
        insert gm2;
        GroupMember gm2b = new GroupMember(GroupId=g2b.Id, UserOrGroupId=UserInfo.getUserId());
        insert gm2b;

        Test.startTest();
        ApprovalProcessReminder apr = new ApprovalProcessReminder();
        Set<Id> res = apr.getUsers(UserInfo.getUserId());
        System.assert(res.contains(UserInfo.getUserId()));

        //Test for nested group
        Group g3 = new Group(Name='APR-TEST-3');
        insert g3;
        GroupMember gmUser = new GroupMember(GroupId=g3.Id, UserOrGroupId=UserInfo.getUserId());
        insert gmUser;
        GroupMember gmGroup = new GroupMember(GroupId=g3.Id, UserOrGroupId=g2.Id);
        insert gmGroup;
        Set<Id> resGroup = apr.getUsers(g3.id);
        System.assert(resGroup.contains(UserInfo.getUserId()));
        Test.stopTest();
    }
    
    static testMethod void testFinish () {
        ApprovalProcessReminder ctrl = new ApprovalProcessReminder();
        ctrl.errors.add(new MyTestException('TEST')); // add a test error
        ctrl.finish(null);
    }
}