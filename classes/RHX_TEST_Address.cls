@isTest(SeeAllData=true)
public class RHX_TEST_Address {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Address__c ORDER BY LastModifiedDate DESC LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Address__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}