@isTest(SeeAllData=true)
public class RHX_TEST_Oracle_Project_Task {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Oracle_Project_Task__c ORDER BY LastModifiedDate DESC LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Oracle_Project_Task__c()
            );
        }
    	

       rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}