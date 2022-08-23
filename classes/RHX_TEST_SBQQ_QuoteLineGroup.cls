@isTest(SeeAllData=true)
public class RHX_TEST_SBQQ_QuoteLineGroup {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM SBQQ__QuoteLineGroup__c ORDER BY LastModifiedDate DESC LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new SBQQ__QuoteLineGroup__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}