@isTest(SeeAllData=true)
public class RHX_TEST_ContractLineItem {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM ContractLineItem LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new ContractLineItem()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}