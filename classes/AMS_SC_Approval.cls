public with sharing class AMS_SC_Approval {
    ApexPages.StandardController sc;
    public AMS_SC_Approval(ApexPages.StandardController sc) {
        this.sc = sc;
    }
    public PageReference saveAndSubmit () {
        try {
        
            sc.save();
            
            //Get current SC approval process name
            AdTech_SC_Approval_Prc__c sca = AdTech_SC_Approval_Prc__c.getInstance();
            string SCApprovalName = sca.AdTech_Approval_Name__c;
            
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            //req1.setComments('Submitting request for approval.');
            req1.setObjectId(sc.getRecord().Id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(UserInfo.getUserId()); 
            
            // Submit the record to specific process and skip the criteria evaluation
            req1.setProcessDefinitionNameOrId(SCApprovalName);
            req1.setSkipEntryCriteria(true);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            // Verify the result
            System.assert(result.isSuccess());
        
            return new PageReference('/' + sc.getRecord().Id);
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
}