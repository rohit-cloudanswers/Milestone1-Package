@isTest
  public class PipelineReportCtrlTest{
   
   static testMethod void testDefaultSettings(){
       Pipeline_Report_Ctrl pipeline = new Pipeline_Report_Ctrl(null);
       System.assertEquals(pipeline.getClassification(),'None');
       System.assertEquals(pipeline.sortDir, 'asc');
       System.assertEquals(pipeline.sortField,'Name');
   }
   
   static testMethod void testPipeline() {
       test.startTest();
       
       //test data
       Account testAccount = new Account(Name = 'testAccount', Account_Classification__c = 'S25');
       insert testAccount; 
       Opportunity testOpp = new Opportunity(Name = 'testOpp',StageName='Prospecting',AccountId = testAccount.Id,CloseDate = (Date.today() + 30));
       insert testOpp;
       Pipeline_Report_Ctrl pipeline = new Pipeline_Report_Ctrl(null);
       System.assertEquals(pipeline.getOpportunityList().size(),1);
       System.assertEquals(pipeline.hasNext,false);
       System.assertEquals(pipeline.hasPrevious,false);
       System.assertEquals(pipeline.pageNumber,1);
       pipeline.setClassification('S25');
       System.assertEquals(pipeline.getOpportunityList().size(),1);
       pipeline.toggleSort();
       test.stoptest();
   }
   
   static testMethod void testSort() {
       test.startTest();
       
       //test data
       Account testAccount = new Account(Name = 'testAccount', Account_Classification__c = 'S25');
       insert testAccount; 
       Opportunity testOpp = new Opportunity(Name = 'testOpp',AccountId = testAccount.Id,CloseDate = (Date.today() + 30));
       testOpp.StageName = 'Prospecting';
       insert testOpp;
       Pipeline_Report_Ctrl pipeline = new Pipeline_Report_Ctrl(null);
       pipeline.setClassification('S25');
       pipeline.toggleSort();
       System.assertEquals(pipeline.getOpportunityList().size(),1);
       System.assertEquals(pipeline.sortDir, 'desc');
       test.stoptest();
   }
   
   static testMethod void testGetItems() {
       test.startTest();
       
       //test data
       Pipeline_Report_Ctrl pipeline = new Pipeline_Report_Ctrl(null);
       System.assertEquals(pipeline.getItems().size(),4);
       test.stoptest();
   }
}