@IsTest(seealldata=true)
private class CaseMilestoneExceptionEditTests {
    @IsTest
    private static void integrationTest () {
        Account acc = TestDataFactory.createAccount();
        Case c = TestDataFactory.createCase(null);
        c.Subject = 'Test Case with Entitlement';
        c.AccountId = acc.id;
        c.slaStartDate=system.now();
        update c;
        User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'testImagine@ImagineTest.com',
             Username = 'testImagine@ImagineTest.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             ManagerId = UserInfo.getUserId()
        );
        Test.startTest();
        system.runAs(u){
            List<CaseMileStone> lstCMS = [select id from CaseMilestone limit 1];
            system.debug('@@@ issue'+[select StartDate, TargetDate, MilestoneType.Name from CaseMilestone where CaseId = :c.id and MilestoneType.Name not in ('Update', 'Automated Update') and IsCompleted = false]);
            Milestone_Exception__c me = new Milestone_Exception__c(Case__c = c.Id, Case_Milestone_ID__c = lstCMS[0].Id );
            ApexPages.StandardController sc = new ApexPages.StandardController(me);
            CaseMilestoneExceptionEdit controller = new CaseMilestoneExceptionEdit(sc);
            controller.sobj.Type__c = 'test';
            controller.sobj.Description__c = 'Test';
            controller.save();
            Test.stopTest(); 
        }
    }
    
    @IsTest
    private static void updateMileStoneException () {
        Account acc = TestDataFactory.createAccount();
        Case c = TestDataFactory.createCase(null);
        c.Subject = 'Test Case with Entitlement';
        c.AccountId = acc.id;
        c.slaStartDate=system.now();
        update c;
        List<CaseMileStone> lstCMS = [select id from CaseMilestone limit 1];
        Datetime dt = Datetime.now();
        dt = dt.addDays(30);
        Milestone_Exception__c me = new Milestone_Exception__c(
            Case__c = c.Id, 
            Status__c ='Draft', 
            Case_Milestone_ID__c = lstCMS[0].Id, 
            type__c='Customer',
            Proposed_Target_Date__c = dt
        );
        insert me;
        Test.startTest();
        Milestone_Exception__c upMilestoneExp = [SELECT Id,Status__c from Milestone_Exception__c where id=:me.Id];
        upMilestoneExp.Status__c = 'Approved';
        update upMilestoneExp;
        Test.stopTest();
    }
}