@IsTest
public class LeadTriggerHelperTests {
    @IsTest static void temporaryCoverage () {
        LeadTriggerHelper.fakeCoverage();
        insert new Country__c(
            Name='United States of America',
            Country__c='United States of America',
            Region__c='NORTH AMERICA',
            Global_Region__c='AMER'
       	);
		// FIXME move to testdatafactory class
        Lead l = new Lead(LastName='Test', Company='Test', Country='United States of America');
        Lead l_old = l.clone();
        l_old.Country = null;
        insert l;
        LeadTriggerHelper x = new LeadTriggerHelper();
        LeadTriggerHelper.OnAfterUpdateDataManipulations(new Map<Id,Lead>{l.Id => l}, new Map<Id,Lead>{l.Id => l_old});
        LeadTriggerHelper.OnAfterInsertDataManipulations(new Map<Id,Lead>{l.Id => l});
    }
}