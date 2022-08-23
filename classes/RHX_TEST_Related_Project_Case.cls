@isTest(SeeAllData=true)
public class RHX_TEST_Related_Project_Case {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Related_Project_Case__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Related_Project_Case__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}