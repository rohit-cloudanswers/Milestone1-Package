@isTest
  public class LogoControllerTest{
   
  static testMethod void testController() {
      test.startTest();
      // Insert test data here      
      Document doc = new Document(Name = 'TestDocument');
      doc.AuthorId = UserInfo.getUserId();
      doc.FolderId = UserInfo.getUserId();  
      insert doc;
      
      Account testAccount = new Account(Name = 'TestAccount',Logo_Id__c = doc.Id);
      insert testAccount;
      

      ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
      LogoController testController = new LogoController(sc);
      system.assertEquals(testController.logoId,doc.Id);
      test.stoptest();
   }
}