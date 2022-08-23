@isTest(SeeAllData=true)
public class RHX_TEST_MPM4_BASE_Milestone1_Project {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM MPM4_BASE__Milestone1_Project__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new MPM4_BASE__Milestone1_Project__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}