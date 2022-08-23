public with sharing class CheckProjectDelete 
{
    private ApexPages.StandardController stdCtrl;
    
    public CheckProjectDelete(ApexPages.StandardController std) 
    {
        this.stdCtrl = std;
    }
    
    public PageReference CheckProjectDelete() 
    {
        MPM4_BASE__Milestone1_Project__c project = (MPM4_BASE__Milestone1_Project__c) this.stdctrl.getRecord();
        
        if(project.MPM4_BASE__Total_Hours_Incurred__c <= 0.00 || project.MPM4_BASE__Total_Hours_Incurred__c == null) 
        {
            delete project;
            Schema.DescribeSObjectResult result = MPM4_BASE__Milestone1_Project__c.SObjectType.getDescribe();
            
            PageReference page = new PageReference('/' + result.getKeyPrefix());
            page.setRedirect(true);
            return page;
        } 
        else 
        {
            return null;
        }
    }
}