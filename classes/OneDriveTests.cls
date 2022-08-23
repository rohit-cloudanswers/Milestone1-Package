@IsTest(SeeAllData=false)
public class OneDriveTests {
    
    @testSetup
    static void setupTestData(){
        Sharepoint_Site__c ss = new Sharepoint_Site__c(
            SetupOwnerId=UserInfo.getOrganizationId(),
            Site_Id__c='testsiteid'
        );
        insert ss;
        Token__c token = new Token__c(
            Access_Token__c='abcdefghijklmnopqrstuvwxyz',
            Refresh_Token__c='abcdefghijklmnopqrstuvwxyz'
        );
        insert token;
    }
    
    @isTest
    static void shouldGetAuthorized(){
        Boolean result = OneDriveController.isAuthorized();
        System.assert(result == false);
    }
    
    @isTest
    static void shouldSaveToken(){
        OneDriveController.Session s = new OneDriveController.Session();
        s.access_token = 'abcdefghijklmnopqrstuvwxyz';
        s.refresh_token = 'abcdefghijklmnopqrstuvwxyz';
        s.expires_in = 3600;
        OneDriveController.saveTokens(s);
        List<Token__c> tokens = [select Id from Token__c];
        System.assert(tokens.size() != 0);
    }
    
    @isTest
    static void shouldGetDocumentLibrary(){
        String str = OneDriveController.getDocumentLibrary();
        System.assert(String.isNotBlank(str));
    }
    
    @isTest
    static void shouldGetDocumentLibraryChildren(){
        String str = OneDriveController.getDocumentLibraryChildren(null);
        System.assert(String.isNotBlank(str));
    }
    
    @isTest
    static void shouldSearchBaseFolderUnderDocumentLibrary(){
        String str = OneDriveController.searchBaseFolderUnderDocumentLibrary('{"folderName":"Test"}');
        System.assert(String.isNotBlank(str));
    }
    
    @isTest
    static void shouldFetchChildren(){
        String str = OneDriveController.fetchChildren('testfolder');
        System.assert(String.isNotBlank(str));
    }
    
    @isTest
    static void shouldCreateFolder(){
        String str = OneDriveController.createFolder('parentFolderId', 'payload');
        System.assert(String.isNotBlank(str));
    }
    
    @isTest
    static void shouldGetDataForFileUpload(){
        String str = OneDriveController.getDataForFileUpload();
        System.assert(String.isNotBlank(str));
    }
    
    @isTest
    static void shouldUpdateFolderId(){
        Boolean result = OneDriveController.updateFolderId('Opportunity', 'recordId', 'folderId');
        System.assert(result == true);
    }
    
    @isTest
    static void shouldRefreshAndRetry(){
        String method = 'GET';
        String url = 'https://cloudanswers.com/';
        Map<String, String> headers = new Map<String, String>();
        String payload = '{}';
        String str = OneDriveService.refreshTokenAndRetry(method, url, headers, payload);
        System.assert(String.isNotBlank(str));
    }
    
    @isTest
    static void shouldLogout(){
        Boolean result = OneDriveController.logout();
        System.assert(result == true);
    }

    @isTest
    static void getAuthStartUrl_shouldPassParameters () {
        String res = OneDriveController.getAuthStartUrl('TESTURL', 'TESTSTATE');
        System.assert(res.contains('TESTURL'));
        System.assert(res.contains('TESTSTATE'));
    }
    @isTest
    static void getAuthStartUrl_shouldHaveHostname () {
        String res = OneDriveController.getAuthStartUrl('TESTURL', 'TESTSTATE');
        System.assert(res.startsWith(OneDriveController.host));
    }
    @isTest
    static void shouldGetTokenFromCode() {
        String str = OneDriveController.getTokenFromCode('testcode', 'testredirecturl');
        System.assert(str != null);
    }
    @isTest
    static void shouldGetTokenFromRefreshToken() {
        OneDriveController.Session session = OneDriveController.getTokenFromRefreshToken();
        System.assert(session != null);
    }
    @isTest
    static void completeUrl_shouldAddHostname() {
        String url = 'somepage';
        System.assert(OneDriveController.completeUrl(url).startsWith('https://'));
        System.assert(OneDriveController.completeUrl(url).endsWith('.salesforce.com/somepage'));
    }
    @isTest
    static void completeUrl_shouldNotDuplicateFirstSlash () {
        String url = '/somepage';
        System.assert(OneDriveController.completeUrl(url).startsWith('https://'));
        System.assert(OneDriveController.completeUrl(url).endsWith('.salesforce.com/somepage'));
    }
    @isTest
    static void redirectTo_shouldRedirectToSomepage(){
        String url = '/somepage';
        System.assert(OneDriveController.redirectTo(url).endsWith('.salesforce.com/somepage'));
    }
    
    @isTest
    static void shouldProvideObjectSettings(){
        OneDrive_Objects__c setting = new OneDrive_Objects__c();
        setting.Name = 'Projects';
        setting.Object_Identifier__c = 'Milestone1_Project2__c';
        setting.Base_Folder_Identifier__c = 'Projects';
        setting.Record_Folder_Identifier__c = 'Name';
        setting.Default_Folders__c = 'Testing';
        insert setting;
        
        Milestone1_Project__c project = new Milestone1_Project__c(
            Name='Test project'
        );
        insert project;
        
        List<Map<String, Object>> settings = OneDriveController.getObjectSettings(project.Id);
        System.assert(settings.size() != 0);
    }
    
    @isTest
    static void shouldGetParentIdField(){
        List<String> fieldNames = OneDriveService.getParentRecordIdField('Account', 'Contact');
        System.assert(fieldNames != null);
    }
    
    @isTest
    static void shouldGetSalesforceRecord(){
        Account acc = new Account(
            Name='Test account'
        );
        insert acc;
        Map<String, Object> data = OneDriveController.getSalesforceRecord(acc.Id, 'Name', 'Account', '', '');
        System.assert(data != null);
    }
    
    @isTest
    static void shouldFilterByFolderName(){
        List<Object> data = (List<Object>) JSON.deserializeUntyped('[{"id":"123456","name":"Test"}]');
        List<Object> filteredItems = OneDriveController.filterByFolderName(data, 'Test');
        System.assert(data.size() == filteredItems.size());
    }
    
    @isTest
    static void shouldFilterByFolderId(){
        List<Object> data = (List<Object>) JSON.deserializeUntyped('[{"id":"123456","name":"Test"}]');
        List<Object> filteredItems = OneDriveController.filterByFolderId(data, '123456');
        System.assert(data.size() == filteredItems.size());
    }
    
    @isTest
    static void shouldSearchFolderInParent(){
        String inputJson = '{"searchName":"Projects","parentId":"abcdefghijklmnopqrstuvwxyz"}';
        String resultJson = OneDriveController.searchFolderInParent(inputJson);
        System.assert(resultJson != null);
    }
    
    @isTest
    static void shouldLoadFolderDetails(){
        Sharepoint_Site__c ss = Sharepoint_Site__c.getInstance();
        String resultJson = OneDriveService.loadFolderDetails(ss.Site_Id__c, 'abcdefghijklmnopqrstuvwxyz', null);
        System.assert(resultJson != null);
    }
    
    @isTest
    static void shouldCreateUploadSession(){
        Sharepoint_Site__c ss = Sharepoint_Site__c.getInstance();
        String resultJson = OneDriveService.createUploadSession(ss.Site_Id__c, 'abcdefghijklmnopqrstuvwxyz', 'abc', null);
        System.assert(resultJson != null);
    }
}