@isTest(SeeAllData = true)
private  class QuoteTabControllerTest {
    static testMethod void testQTab(){
        Test.startTest();
        PageReference myVfPage = Page.QuotesListView;
        Test.setCurrentPage(myVfPage);      
        QuoteTabController obj  = new QuoteTabController();
        obj.getQuotes();
        obj.getViews();
        obj.viewChanged();
        obj.getViewName();
        obj.Next();
        obj.End();
        obj.Previous();
        obj.Beginning();
        obj.getTotal_size();
        obj.setViewName('My Quotes - Completed Approvals');
        obj.getViewName();                                
        obj.total_size = 0;        
        obj.getQuoteApprovals();        
        obj.getPageNumber();
        obj.getTotalPages();
        obj.getDisablePrevious();
        obj.getDisableNext();
        Test.stopTest();
    }
    static testMethod void testQPendings(){
        Test.startTest();
        List<ProcessInstanceWorkitem> processInstanceWorkitems = [SELECT ActorId, CreatedById, Id FROM ProcessInstanceWorkitem];
        Id uId;
        
        if(processInstanceWorkitems.size()>0)
        {
            uId = processInstanceWorkitems.get(0).ActorId;
        }
            

        User u = [select Id from User LIMIT 1];
        system.runAs(u)
        {
            PageReference myVfPage = Page.QuotesListView;
            Test.setCurrentPage(myVfPage);      
            QuoteTabController obj  = new QuoteTabController();        
            obj.setViewName('My Quotes - Pending Approvals');                
            obj.getViews();
            obj.getViewName();
            obj.Next();
            obj.End();
            obj.Previous();
            obj.Beginning();
            obj.getTotal_size();             
            obj.getPageNumber();
            obj.getTotalPages();
            obj.getDisablePrevious();
            obj.getDisableNext();
            obj.total_size = 0;        
            obj.getQuotePendings();
        } 
        Test.stopTest();
    }
}