@IsTest(SeeAllData=false)
private class TimeSheetControllerTests {

    @isTest
    static void isOppTimeEntryAllowed() {
        Test.startTest();
        Boolean actual = TimeSheetController.isOpportunityTimeAllowed();
        Test.stopTest();
        
        Boolean expected = MPM4_BASE__Milestone1_Time__c.Opportunity__c.getDescribe().isCreateable();
        System.assert(expected == actual);
    }
    
    @isTest
    static void shouldGetUserTasks(){
        MPM4_BASE__Milestone1_Project__c project = new MPM4_BASE__Milestone1_Project__c(
            Name='Test project'
        );
        insert project;
        MPM4_BASE__Milestone1_Milestone__c milestone = new MPM4_BASE__Milestone1_Milestone__c(
            Name='Test milestone',
            MPM4_BASE__Project__c=project.Id
        );
        insert milestone;
        
        MPM4_BASE__Milestone1_Resource__c res = new MPM4_BASE__Milestone1_Resource__c(MPM4_BASE__user__c = UserInfo.getUserID());
        insert res;
        
        MPM4_BASE__Milestone1_Task__c tk = new MPM4_BASE__Milestone1_Task__c(
            Name='Test task',
            MPM4_BASE__Resource__c=res.id,
            MPM4_BASE__Project_Milestone__c=milestone.Id
        );
        insert tk;
        Map<String, List<SObject>> data = TimeSheetController.getUserTasks();
    }

    @isTest
    static void shouldGetPicklistOptions(){
        Map<String, List<TimeSheetController.OptionWrapper>> wrappers = TimeSheetController.getPicklistOptions();
        System.assert(wrappers.get('Category__c').size() != 0);
        System.assert(wrappers.get('Time_Type__c').size() != 0);
    }
}