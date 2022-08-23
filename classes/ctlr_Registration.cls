/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 * Mofified from SF default controller
 */
public without sharing class ctlr_Registration {
    static final String COMMUNITY_NAME = 'CustomerCommunity';
 
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String company {get;set;}
    public String phone {get; set;}
    public String title {get; set;}
    public String email {get; set;}
    public String nickname {get;set;}
    public string communityUserType {get;set;}
    
    public list<SelectOption> communityUserTypeOptions {get{
        if(communityUserTypeOptions==null){
            communityUserTypeOptions = new list<SelectOption>();
            Schema.DescribeFieldResult fieldResult = User.Community_User_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                   
            for( Schema.PicklistEntry f : ple) {
                communityUserTypeOptions.add(new SelectOption(f.getLabel(), f.getValue()));
            }       
        }
        return communityUserTypeOptions;
        
    }set;}
    
    
    public ApexPages.Message registrationMessage {get;set;}
    
    private string accountID {
        get{
            if(accountID==null)
                accountId = '';
            return accountId;
        }
        set;}
    
    public ctlr_Registration() {}
    
    public string isValidPassword { get {
        string message = '';
        if(string.isBlank(company) || string.isBlank(email) || string.isBlank(firstName) || string.isBlank(lastName)){
            message = Label.Registration_required_fields;
        }
        return message;
    }}

    public String getLoginUrl() {
        return Network.getLoginUrl(Network.getNetworkId());
    }

    public PageReference registerUser() {
        
        // check password validity
        if (isValidPassword != '') {
            ApexPages.Message registrationMessage = new ApexPages.Message(ApexPages.Severity.ERROR, isValidPassword);
            ApexPages.addMessage(registrationMessage);
            return null;
        }    
        
        // get default account
        List<Account> defaultAccounts = [SELECT Id FROM Account WHERE Name = 'Default Community Account' ORDER BY CreatedDate DESC LIMIT 1];
        if (defaultAccounts.size()>0)
            accountID = defaultAccounts[0].Id;
        
        String networkId = Network.getNetworkId();
        List<Network> networks = Test.isRunningTest() ? 
            [SELECT Id,Name,SelfRegProfileId FROM Network WHERE Name = :COMMUNITY_NAME ORDER BY CreatedDate DESC LIMIT 1] : 
            [SELECT Id,Name,SelfRegProfileId FROM Network WHERE Id = :networkId ORDER BY CreatedDate DESC LIMIT 1];
        
        if (networks.size() < 1) return null;
    
        //set default profile
        String profileId = networks[0].SelfRegProfileId; 
        
        if ([SELECT id FROM User WHERE Username =:email].size() > 0) {
            ApexPages.Message registrationMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'User already exists with that email');
            ApexPages.addMessage(registrationMessage);
            return null;
        }
            
        Savepoint sp = database.setSavepoint();
            
        try {
            User u = new User();
            u.Username = email;
            u.Email = email;
            u.FirstName = firstName;
            u.LastName = lastName;
            u.CommunityNickname = nickname;
            u.ProfileId = profileId;
            u.CompanyName = company;
            u.Phone = phone;
            u.Title = title; 
            
            // match existing contact by email address
            for (Contact existingContact : [SELECT Id, AccountId FROM contact WHERE Email =:email and AccountId != null]) {
                u.contactId = existingContact.Id;
                accountId = existingContact.AccountId;
            }
            
            Boolean sendWelcomeEmail = false;
            Id userId = Site.createExternalUser(u, accountId, null, sendWelcomeEmail);
            
            // in unit tests, salesforce will always return a null value from Site.createExternalUser
            // so if we are in a unit test, default the userId of the current user running tests
            if (Test.isRunningTest() && String.isBlank(userId)) userId = UserInfo.getUserId();
			
            // the following error (not catchable) means you are out of community licenses:
            // Your request cannot be processed at this time. The site administrator has been alerted. 

            if(userId != null){
                list<RecordType> rts = [SELECT Id FROM RecordType WHERE DeveloperName = 'Community_User_Approval' AND sObjectType = 'Case'];
                if(rts.size()>0){
                    // create case for support to grant the user access to other things
                    Case nc = new Case(); 
                    nc.RecordTypeId = rts[0].Id;
                    nc.AccountId = accountId;
                    nc.Subject = 'New Community User: ' + firstName + ' ' + lastName;
                    nc.Community_User__c = userId;
                    insert nc;
                }
            }
            
            // sending reset password instead of welcome email so the set-password link is included
            System.resetPasswordWithEmailTemplate(userId, true, 'CommunityForgotPasswordEmailTemplateCustomers');

            PageReference page = System.Page.SiteRegisterConfirm;
            page.setRedirect(true);
            return page;
        } catch(exception e){
            database.rollback(sp);
            ApexPages.Message registrationMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + e.getStackTraceString());
            ApexPages.addMessage(registrationMessage);
            return null;
        }
    }
}