public with sharing class FlowRedirectController {
    
    public PageReference onLoad() {
        String unique_id = ApexPages.currentPage().getParameters().get('id');
        
        if(String.isNotBlank(unique_id))
            for (Bug__c bug : [SELECT Id FROM Bug__c WHERE Unique_Flow_Identifier__c = :unique_id order by CreatedDate desc])
                return new PageReference('/' + bug.Id);
        
        return new PageReference('/home/home.jsp'); 
        
    }

}