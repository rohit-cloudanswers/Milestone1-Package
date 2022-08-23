@isTest(SeeAllData=true)
public class RHX_TEST_MPM4_BASE_Milestone1_Milestone {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM MPM4_BASE__Milestone1_Milestone__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new MPM4_BASE__Milestone1_Milestone__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}