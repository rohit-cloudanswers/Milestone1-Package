@isTest
private class AccountTypeChangeOnAssetTriggerTest {
  static testMethod void accountTypeChange() {
      test.startTest();
      Id uId = Userinfo.getUserId();
      Account testAccount = new Account(Name = 'TestAccount',Type ='Prospect',OwnerId = uId);
      insert testAccount;
      system.debug('Account inserted');
      Asset testAsset = new Asset(Name = 'TestAsset',AccountID = testAccount.Id,Status = 'Purchased');
      insert testAsset;
      Account testAcc = [select Type, Status__c from Account where Id =: testAccount.Id];
      System.assertEquals(testAcc.Type,'End User');      
      System.assertEquals(testAcc.Status__c,'Active');
      test.stopTest();
  }
}