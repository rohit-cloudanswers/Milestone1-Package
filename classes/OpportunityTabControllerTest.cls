@isTest
private  class OpportunityTabControllerTest {
  static testMethod void testOpportunityTab(){
    OpportunityTabController obj  = new OpportunityTabController();
    obj.getOpportunities();
    obj.getViews();
    obj.viewChanged();
    //obj.openNew();
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
  }

}