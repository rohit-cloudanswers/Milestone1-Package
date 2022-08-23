@isTest(SeeAllData = true)
private class ProductDetailControllerTest {
 
 static testMethod void unitTest(){
   UserRole oRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
   Profile oProfile = [Select Id from Profile where name = 'System Administrator'];
   
   User oUser = new User(
    ProfileId = oProfile.Id,
    UserRoleId = oRole.Id,
    Username = System.now().millisecond() + '_test1@test.com',
    Alias = 'batman',
    Email='test1@test.com',
    EmailEncodingKey='UTF-8',
    Firstname='Test',
    Lastname='Account',
    LanguageLocaleKey='en_US',
    LocaleSidKey='en_US',
    TimeZoneSidKey='America/Chicago'
    );
    insert oUser;
    
    System.runAs ( oUser ) {
      Account oPortalAccount = new Account(
      Name = 'Test Portal Account',
      OwnerId = oUser.Id,
      Opportunity_Line_of_Business__c = 'Asset Management; Automation',
      Partner_Product_Prices__c='Asia US$; Can Dom'
      );
      insert oPortalAccount;
      
      Contact oContact = new Contact(
      FirstName = 'Test',
      Lastname = 'Contact',
      AccountId = oPortalAccount.Id,
      Email = System.now().millisecond() + 'test1@test.com'
      );
      insert oContact ;
      
      Profile portalProfile = [SELECT Id FROM Profile Where Name = 'Partner User' limit 1];
      User oPortalUser = new User(
      Username = System.now().millisecond() + 'test12345@test.com',
      ContactId = oContact.Id,
      ProfileId = portalProfile.Id,
      Alias = 'test123',
      Email = 'test12345@test.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'PortalUser',
      CommunityNickname = 'test12345',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
      );
     // insert oPortalUser;
      
      //System.runAs ( oPortalUser ) {
        Product2 oProduct = new Product2(
         Name = 'Test Product',
         Channel_Product_Family__c = 'Asset Management; Automation'
        );
        insert oProduct;
        
        ApexPages.currentPage().getParameters().put('Id',oProduct.id);
    ApexPages.StandardController stdController = new ApexPages.StandardController(oProduct);
    ProductDetailController ctrl = new ProductDetailController(stdController);
    
     // }
    }
 }
}