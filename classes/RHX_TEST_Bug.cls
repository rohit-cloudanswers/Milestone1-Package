@isTest(SeeAllData=true)
public class RHX_TEST_Bug {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Bug__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Bug__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}