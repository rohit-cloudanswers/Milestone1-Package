@isTest
private class AccountTypeChangeValidateTriggerTest {
  static testMethod void accountTypeChangeValidate() {
      test.startTest();
      Id uId = Userinfo.getUserId();
      Account testAccount = new Account(Name = 'TestAccount',Type ='Prospect',ownerId = uId);
      insert testAccount;
      testAccount.Type = 'End Customer';
      update testAccount;
      ApexPages.Message[] msgs=ApexPages.getMessages();
      Boolean found=false;
      for (ApexPages.Message msg : msgs)
      {
         if (msg.getSummary()=='The Account Type cannot be updated until an asset is associated to the account')
         {
            found=true;
            system.debug('message details'+msg.getSummary());
         }
      }
      test.stopTest();
   }
}