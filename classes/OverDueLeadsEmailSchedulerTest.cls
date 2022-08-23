@isTest(SeeAllData=true)
  class OverDueLeadsEmailSchedulerTest{
   
   static testMethod void testEmail() {
       test.startTest();
       
       //test data
      Lead testLead = new Lead(OwnerId = UserInfo.getUserId(), LastName = 'test',Country='United States Of America',State='California',Street='test' ,postalcode='94444',Company = 'Test',city='San Jose');
      // insert testLead; 
       Task newTask = new Task(WhoId = testLead.Id, ActivityDate = (Date.today() - 1));
       //insert newTask;
       OverDueLeadsEmailScheduler scheduler = new OverDueLeadsEmailScheduler();
       scheduler.execute(null);
       test.stoptest();
   }
}