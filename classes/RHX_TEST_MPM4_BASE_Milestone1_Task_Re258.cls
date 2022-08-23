@isTest(SeeAllData=true)
public class RHX_TEST_MPM4_BASE_Milestone1_Task_Re258 {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM MPM4_BASE__Milestone1_Task_Resource__c ORDER BY LastModifiedDate DESC LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new MPM4_BASE__Milestone1_Task_Resource__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}