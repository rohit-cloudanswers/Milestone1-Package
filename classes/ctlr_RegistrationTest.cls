@isTest
private class ctlr_RegistrationTest {
    @testsetup
    static void generateUserAndContact()
    {
        Id p = [select id from profile where name='Partner Community User'].id;
       
        Account ac = new Account(name ='Default Community Account') ;
        insert ac; 
       
        Contact con = new Contact(LastName ='Test Contact',AccountId = ac.Id, Email='testcommunityUser0010@imagine.com');
        insert con;  
        
        /*
        User user = new User(alias = 'TestUser', email='testcommunityUser0010@imagine.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States of America',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='testcommunityUser0010@imagine.com');
       
        insert user;
		*/
    }
	
    
    @isTest static void testRegisterUserWithUniqueEmail() {
        
        PageReference pageRef = Page.customerCommunityRegistration;
        Test.setCurrentPage(pageRef);
        ctlr_Registration ctlRegis= new ctlr_Registration();
        ctlRegis.firstName='Test';
        ctlRegis.lastName='User';
        ctlRegis.company='imagine';
        ctlRegis.phone='0987654321';
        ctlRegis.title='Mr';
        ctlRegis.email='testcommunityUsertest30@imagine.com';
        ctlRegis.nickname='Test';
        ctlRegis.communityUserType='Test';
        System.assert(ctlRegis.registerUser() != null, 'user should not be null: ' + ApexPages.getMessages());
    }

    @isTest static void testRegisterUserWithInvalidInput() {
        
        PageReference pageRef = Page.customerCommunityRegistration;
        Test.setCurrentPage(pageRef);
        ctlr_Registration ctlRegis= new ctlr_Registration();
        ctlRegis.firstName='';
        ctlRegis.lastName='';
        ctlRegis.company='';
        ctlRegis.phone=null;
        ctlRegis.title='Mr';
        ctlRegis.email='testcommunityUsertest30@imagine.com';
        ctlRegis.nickname='Test';
        ctlRegis.communityUserType='Test';
        System.assert(ctlRegis.registerUser() == null);
    }
    @isTest static void testRegisterUserWithSameEmail() {

        List<User> communityExistingUser = [select id from user where email='testcommunityUser0010@imagine.com'];
        PageReference pageRef = Page.customerCommunityRegistration;
        Test.setCurrentPage(pageRef);
        ctlr_Registration ctlRegis= new ctlr_Registration();
        ctlRegis.firstName='Test';
        ctlRegis.lastName='User';
        ctlRegis.company='imagine';
        ctlRegis.phone='0987654321';
        ctlRegis.title='Mr';
        ctlRegis.email='testcommunityUser0010@imagine.com';
        ctlRegis.nickname='Test';
        ctlRegis.communityUserType='Test';
        List<SelectOption> lstSO=ctlRegis.communityUserTypeOptions;
        PageReference returnRef = ctlRegis.registerUser();

        ctlRegis.getLoginUrl();
        
        //List<Contact> communityUser = [select id from Contact where email='testcommunityUser0010@imagine.com'];
        //system.assertEquals(communityUser.size(),1);
    }
    
}