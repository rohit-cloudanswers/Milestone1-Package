@IsTest(SeeAllData=false)
public class Test_blogic_Case {
    
	@IsTest
    static void integrationTest () {
        List<Account> accounts = (List<Account>) Test.loadData(Account.sObjectType, 'TestData_Account');
        System.assert(!accounts.isEmpty());
        Account acc = accounts.get(0);
        Contact con = TestDataFactory.createContact(acc);
        // FIXME: need to trigger entitlement record
        List<SlaProcess> slas = [select Id from SlaProcess where IsActive = true and SObjectType = 'Case' and Name = 'Care Service'];
        System.assert(!slas.isEmpty());
        Entitlement entl = new Entitlement(
            Name='Test Entilement',
            AccountId=acc.Id,
            Type='Phone Support', 
            StartDate=Date.valueof(System.now().addDays(-2)), 
            EndDate=Date.valueof(System.now().addYears(2)),
            SLAProcessId=slas.get(0).Id
        );
        insert entl;
		List<Case> cases = new List<Case>();
        Case cs = new Case(
            Subject='This is test case',
            EntitlementId = entl.Id,
            SlaStartDate=Date.today(),
            ContactId=con.Id,
            AccountId=acc.Id
        );
        cases.add(cs);
        insert cases;
        update cases;
        cs = [
            select Resolution_Milestone_Target_Date__c, Response_Milestone_Target_Date__c, Restore_Milestone_Target_Date__c
            from Case 
            where Id = :cs.Id
        ];
        System.assert(cs.Resolution_Milestone_Target_Date__c != null);
	}
}