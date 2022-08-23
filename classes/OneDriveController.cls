/**
 * Using a CustomObject (Token__c) instead of CustomSetting because 
 * access token returned by OneDrive api is more than 1000 characters.
 */
global class OneDriveController {
    
    @TestVisible
    private static String host = 'https://login.microsoftonline.com/';
    private static String tenant = 'common';
    private static String authURL = host + tenant + '/oauth2/v2.0/authorize';
    private static String tokenURL = host + tenant + '/oauth2/v2.0/token';
    private static final String CONSUMER_KEY = getCustomerKey();
    private static final String CONSUMER_SECRET = getCustomerSecret();
    private static final String[] scopes = new String[]{
        'openid',
        'Files.ReadWrite.All',
        'offline_access'
    };
    private static final String LIGHTNING_AUTH_APP = 'https://imaginecommunications' + (((Boolean) ImagineOrg.get('IsSandbox')) ? '--test.sandbox' : '') + '.lightning.force.com/c/LightningOneDriveAuth.app';
    public static Session saveSession;
    
    @AuraEnabled @RemoteAction
    global static List<Map<String, Object>> getObjectSettings(String recordId){
        List<Map<String, Object>> objectSettings = new List<Map<String, Object>>();
        Map<String, Object> objectSetting = new Map<String, Object>();
        if(String.isNotBlank(recordId)){
            Id recId = recordId;
            SObjectType sObjType = recId.getSObjectType();
            String sObjName = sObjType.getDescribe().getName();
            objectSetting = OneDriveService.getOneDriveObjectSetting(sObjName, recordId);
            while(objectSetting != null){
                objectSettings.add(objectSetting);
                sObjName = (String) objectSetting.get('objectName');
                String parentObjectName = (String) objectSetting.get('parentObjectName');
                if(String.isNotBlank(parentObjectName)) {
                    String lookupField = (String) objectSetting.get('parentLookupField');
                    List<SObject> records = Database.query('select ' + lookupField + ' from ' + sObjName + ' where Id = :recordId');
                    recordId = (String) records.get(0).get(lookupField);
                    objectSetting = OneDriveService.getOneDriveObjectSetting(parentObjectName, recordId);
                } else {
                    objectSetting = null;
                }
            }
        } else {
            objectSetting.put('error', true);
            objectSettings.add(objectSetting);
        }
        return objectSettings;
    }
    
    @AuraEnabled
    global static Boolean isAuthorized(){
        List<Token__c> tokens = [
            select Access_Token__c, Refresh_Token__c 
            from Token__c
            where CreatedById = :UserInfo.getUserId() and Name = 'Onedrive'
        ];
        return tokens.size() != 0;
    }

    @AuraEnabled @RemoteAction
    global static String getAuthStartUrl(String redirectUrl, String state){
        String params = 'client_id='+EncodingUtil.urlEncode(CONSUMER_KEY,'UTF-8')
            + '&scope='+EncodingUtil.urlEncode(String.join(scopes, ' '),'UTF-8')
            + '&response_type=code'
            + '&response_mode=query'
            + '&redirect_uri='+ EncodingUtil.urlEncode(completeUrl(redirectURL),'UTF-8')
            + '&state=' + EncodingUtil.urlEncode(state,'UTF-8');
        return authURL+'?'+ params;
    }

    @AuraEnabled @RemoteAction
    global static String getTokenFromCode(String code, String redirectURL){
        if(UserInfo.getUiThemeDisplayed() == 'Theme4d'){
            redirectURL = LIGHTNING_AUTH_APP;
        } else {
            redirectURL = completeUrl(redirectURL);
        }
        String payload = 'code='+EncodingUtil.urlEncode(code,'UTF-8')
            +'&client_id='+EncodingUtil.urlEncode(CONSUMER_KEY,'UTF-8')
            +'&client_secret='+EncodingUtil.urlEncode(CONSUMER_SECRET,'UTF-8')
            +'&grant_type=authorization_code'
            +'&redirect_uri='+EncodingUtil.urlEncode(redirectURL,'UTF-8');
        Map<String, String> headers = new Map<String, String>();
        headers.put('Content-Type', 'application/x-www-form-urlencoded');
        String body = HttpHelper.doPost(tokenURL, payload, headers);
        Session sessionResult = (Session) JSON.deserialize(body, Session.class);
        saveTokens(sessionResult);
        return JSON.serialize(sessionResult);
    }

    @RemoteAction
    global static Session getTokenFromRefreshToken(String refreshToken){
        return getTokenUsingRefreshToken(refreshToken);
    }
    
    @AuraEnabled
    global static Session getTokenFromRefreshToken(){
        List<Token__c> tokens = [
            select Refresh_Token__c
            from Token__c 
            where CreatedById = :UserInfo.getUserId() and Name = 'Onedrive'
        ];
        String refreshToken = tokens.size() == 0 ? '' : tokens.get(0).Refresh_Token__c;
        return getTokenUsingRefreshToken(refreshToken);
    }

    private static Session getTokenUsingRefreshToken(String refreshToken){
        String payload = 'client_id='+EncodingUtil.urlEncode(CONSUMER_KEY, 'UTF-8')
            +'&client_secret='+EncodingUtil.urlEncode(CONSUMER_SECRET, 'UTF-8')
            +'&refresh_token='+EncodingUtil.urlEncode(refreshToken, 'UTF-8')
            +'&grant_type=refresh_token';
        Map<String, String> headers = new Map<String, String>();
        headers.put('Content-Type', 'application/x-www-form-urlencoded');
        String body = HttpHelper.doPost(tokenURL, payload, headers);
        Session s = (Session) JSON.deserialize(body, Session.class);
        if(Test.isRunningTest()) s.access_token = 'testtoken';
        return s;
    }
    
    public static void saveTokens(Session result){
        if(result != null && result.access_token != null) {
            List<Token__c> tokens = [
                select Id, Refresh_Token__c, Access_Token__c 
                from Token__c 
                where CreatedById = :UserInfo.getUserId() and Name = 'Onedrive'
            ];
            Token__c token;
            if(tokens.size() != 0) {
                token = tokens.get(0);
            } else {
                token = new Token__c(
                    Name='Onedrive'
                );
            }
            token.Access_Token__c = result.access_token;
            token.Refresh_Token__c = result.refresh_token;
            upsert token;
        }
    }
    
    @AuraEnabled @RemoteAction
    global static String redirectTo(String uri) {
        return completeUrl(uri);
    }
    
    @AuraEnabled
    global static String getDocumentLibrary(){
        String siteId = Sharepoint_Site__c.getOrgDefaults().Site_Id__c;
        String result = OneDriveService.loadDocumentLibrary(siteId, null);
        if(saveSession != null) saveTokens(saveSession);
        return result;
    }

    @AuraEnabled
    global static String getDocumentLibraryChildren(String recordId){
        String siteId = Sharepoint_Site__c.getOrgDefaults().Site_Id__c;
        // load the root folder
        String rootJson = OneDriveService.loadDocumentLibraryChildren(siteId, null);
        Map<String, Object> rootData = (Map<String, Object>) JSON.deserializeUntyped(rootJson);
        
        // query salesforce record for OneDrive Folder Id
        String folderId = null;
        if(String.isNotBlank(recordId)) {
            Id recId = (Id) recordId;
            String objectName = recId.getSobjectType().getDescribe().getName();
            String query = 'select Id, OneDrive_Folder_Id__c from ' + objectName + ' where Id = :recordId';
            List<sObject> sObjs = Database.query(query);
            
            if(!sObjs.isEmpty() && String.isNotBlank((String)sObjs.get(0).get('OneDrive_Folder_Id__c'))) 
                folderId = (String) sObjs.get(0).get('OneDrive_Folder_Id__c');
        }
        
        List<Object> folders = new List<Object>();
        if(String.isNotBlank(folderId)) {
            // load only the record folder
            String folderJson = OneDriveService.loadFolderDetails(siteId, folderId, null);
            Map<String, Object> folderData = (Map<String, Object>) JSON.deserializeUntyped(folderJson);
            folders.add(folderData);
        }
        // only include matching folder
        rootData.put('children', folders);
        
        if(saveSession != null) saveTokens(saveSession);
        return JSON.serialize(rootData);
    }    

    @AuraEnabled
    global static String searchBaseFolderUnderDocumentLibrary(String folderJson){
        String siteId = Sharepoint_Site__c.getOrgDefaults().Site_Id__c;
        String rootJson = OneDriveService.loadDocumentLibraryChildren(siteId, null);
        Map<String, Object> rootData = (Map<String, Object>) JSON.deserializeUntyped(rootJson);
        // search folder by name
        loadAllChildren(siteId, rootData, folderJson);
        if(saveSession != null) saveTokens(saveSession);
        return JSON.serialize(rootData);
    }
    
    @AuraEnabled
    global static String searchFolderInParent(String folderJson) {
        String siteId = Sharepoint_Site__c.getOrgDefaults().Site_Id__c;
        Map<String, Object> searchMap = (Map<String, Object>) JSON.deserializeUntyped(folderJson);
        String searchId = (String) searchMap.get('searchId');
        String searchName = (String) searchMap.get('searchName');
        String parentId = (String) searchMap.get('parentId');
        List<Object> folders = new List<Object>();
        
        String nextLink = null;
        // start downloading all the children
        String childrenJson = OneDriveService.loadChildrenPaginated(siteId, parentId, null);
        Map<String, Object> childrenMap = (Map<String, Object>) JSON.deserializeUntyped(childrenJson);
        
        if(String.isNotBlank(searchId)) folders.addAll(filterByFolderId((List<Object>) childrenMap.get('value'), searchId));
        else if(String.isNotBlank(searchName)) folders.addAll(filterByFolderName((List<Object>) childrenMap.get('value'), searchName));
        
        if( (String.isNotBlank(searchId) || String.isNotBlank(searchName)) && folders.isEmpty() && childrenMap.containsKey('@odata.nextLink') ) {
            
            nextLink = (String) childrenMap.get('@odata.nextLink');
            Map<String, String> headers = OneDriveService.getAuthorizationHeader(null);
            do {
                childrenJson = HttpHelper.doGet(nextLink, headers);
                childrenMap = (Map<String, Object>) JSON.deserializeUntyped(childrenJson);
                
                if (String.isNotBlank(searchId)) folders.addAll(filterByFolderId((List<Object>) childrenMap.get('value'), searchId));
                else if(String.isNotBlank(searchName)) folders.addAll(filterByFolderName((List<Object>) childrenMap.get('value'), searchName));
                
                if( (String.isNotBlank(searchId) || String.isNotBlank(searchName)) && folders.isEmpty() && childrenMap.containsKey('@odata.nextLink') ) {
                    nextLink = (String) childrenMap.get('@odata.nextLink');
                } else {
                    nextLink = null;
                }
            } while(nextLink != null);
        }
        Map<String, Object> data = new Map<String, Object>();
        data.put('children', folders);
        return JSON.serialize(data);
    }
    
    private static void loadAllChildren(String siteId, Map<String, Object> rootData, String folderJson) {
        if(folderJson == null) folderJson = '{}';
        Map<String, Object> searchMap = (Map<String, Object>) JSON.deserializeUntyped(folderJson);
        String searchId = (String) searchMap.get('searchId');
        String folderName = (String) searchMap.get('folderName');
        String baseFolderId = (String) searchMap.get('baseFolderId');
        
        if(rootData.containsKey('folder')) {
            String folderId = (String) rootData.get('id');
            Map<String, Object> folderMap = (Map<String, Object>) rootData.get('folder');
            Integer childCount = Integer.valueOf(folderMap.get('childCount'));
            
            if(String.isNotBlank(folderId) && childCount > 0) {
                List<Object> folders = new List<Object>();
                if(String.isBlank(baseFolderId)) {
                    String nextLink = null;
                    // start downloading all the children
                    String childrenJson = OneDriveService.loadChildrenPaginated(siteId, folderId, null);
                    Map<String, Object> childrenMap = (Map<String, Object>) JSON.deserializeUntyped(childrenJson);
                    
                    if (String.isNotBlank(searchId)) folders.addAll(filterByFolderId((List<Object>) childrenMap.get('value'), searchId));
                    else if(String.isNotBlank(folderName)) folders.addAll(filterByFolderName((List<Object>) childrenMap.get('value'), folderName));
                    
                    if( (String.isNotBlank(folderName) || String.isNotBlank(searchId)) && folders.isEmpty() && childrenMap.containsKey('@odata.nextLink') ) {
                        
                        nextLink = (String) childrenMap.get('@odata.nextLink');
                        Map<String, String> headers = OneDriveService.getAuthorizationHeader(null);
                        do {
                            childrenJson = HttpHelper.doGet(nextLink, headers);
                            childrenMap = (Map<String, Object>) JSON.deserializeUntyped(childrenJson);
                            
                            if (String.isNotBlank(searchId)) folders.addAll(filterByFolderId((List<Object>) childrenMap.get('value'), searchId));
                            else if(String.isNotBlank(folderName)) folders.addAll(filterByFolderName((List<Object>) childrenMap.get('value'), folderName));
                            
                            if( (String.isNotBlank(folderName) || String.isNotBlank(searchId)) && folders.isEmpty() && childrenMap.containsKey('@odata.nextLink') ) {
                                nextLink = (String) childrenMap.get('@odata.nextLink');
                            } else {
                                nextLink = null;
                            }
                        } while(nextLink != null);
                    }
                } else {
                    String baseFolderDetails = OneDriveService.loadFolderDetails(siteId, baseFolderId, null);
                    Map<String, Object> baseFolderMap = (Map<String, Object>) JSON.deserializeUntyped(baseFolderDetails);
                    folders.add(baseFolderMap);
                }
                rootData.put('children', folders);
            } else {
                rootData.put('children', new List<Object>());
            }
        }
    }
    
    @TestVisible
    private static List<Object> filterByFolderName(List<Object> childItems, String folderName){
        List<Object> filteredItems = new List<Object>();
        if(childItems != null) {
            for(Object obj : childItems) {
                Map<String, Object> itemMap = (Map<String, Object>) obj;
                String itemName = (String) itemMap.get('name');
                if(String.isNotBlank(itemName) && itemName.equals(folderName)) {
                    filteredItems.add(obj);
                    break;
                }
            }
        }
        return filteredItems;
    }
    
    @TestVisible
    private static List<Object> filterByFolderId(List<Object> childItems, String folderId){
        List<Object> filteredItems = new List<Object>();
        if(childItems != null) {
            for(Object obj : childItems) {
                Map<String, Object> itemMap = (Map<String, Object>) obj;
                String itemId = (String) itemMap.get('id');
                if(String.isNotBlank(itemId) && itemId.equals(folderId)) {
                    filteredItems.add(obj);
                    break;
                }
            }
        }
        return filteredItems;
    }
    
    @AuraEnabled
    global static Map<String, Object> getSalesforceRecord(String recordId, String folderField, String objectName, String parentObjectName, String parentIdField){
        String query = 'select Id, ' + folderField;
        if(!Test.isRunningTest()) query += ', OneDrive_Folder_Id__c ';
        if(String.isNotBlank(parentIdField)) query += ', ' + parentIdField;
        query += ' from ' + objectName;
        query += ' where Id = \'' + recordId + '\'';
        List<sObject> records = Database.query(query);
        Map<String, Object> result = new Map<String, Object>();
        result.put('record', JSON.serialize(records.get(0)));
        result.put('parent_id_field', parentIdField);
        return result;
    }
    
    @AuraEnabled
    global static String fetchChildren(String folderId){
        String siteId = Sharepoint_Site__c.getOrgDefaults().Site_Id__c;
        String result = OneDriveService.loadChildren(siteId, folderId, null);
        if(saveSession != null) saveTokens(saveSession);
        return result;
    }
    
    @AuraEnabled
    global static String requestFileUploadSession(String parentFolderId, String fileName) {
        String siteId = Sharepoint_Site__c.getOrgDefaults().Site_Id__c;
        String result = OneDriveService.createUploadSession(siteId, parentFolderId, fileName, null);
        if(saveSession != null) saveTokens(saveSession);
        return result;
    }
    
    @AuraEnabled
    global static String createFolder(String parentFolderId, String payload){
        String siteId = Sharepoint_Site__c.getOrgDefaults().Site_Id__c;
        String result = OneDriveService.createFolder(siteId, parentFolderId, payload, null);
        if(saveSession != null) saveTokens(saveSession);
        return result;
    }
    
    @AuraEnabled
    global static String getDataForFileUpload(){
        Map<String, String> data = new Map<String, String>();
        String siteId = Sharepoint_Site__c.getOrgDefaults().Site_Id__c;
        data.put('siteId', siteId);
        List<Token__c> tokens = [
            select Access_Token__c 
            from Token__c 
            where CreatedById = :UserInfo.getUserId() and Name = 'Onedrive'
        ];
        if(tokens.size() != 0) data.put('accessToken', tokens.get(0).Access_Token__c);
        return JSON.serialize(data);
    }

    @AuraEnabled
    global static Boolean updateFolderId(String objectName, String recordId, String folderId){
        Type objType = Type.forName(objectName);
        SObject sObj = (SObject) objType.newInstance();
        sObj.put('Id', recordId);
        sObj.put('OneDrive_Folder_Id__c', folderId);
        if(!Test.isRunningTest()) update sObj;
        return true;
    }

    @AuraEnabled
    global static Boolean logout(){
        delete [select Id from Token__c where Name = 'Onedrive' and CreatedById =: UserInfo.getUserId()];
        return true;
    }

    @TestVisible
    private static String completeUrl (String url) {
        if (!url.startsWith('https://')) {
            if (!url.startsWith('/')) {
                url = '/' + url;
            }
            url = 'https://' + ((String) ImagineOrg.get('InstanceName')) + '.salesforce.com' + url;
        }
        return url;
    }

    @TestVisible
    private static String getCustomerKey(){
        String key = null;
        String theme = UserInfo.getUiThemeDisplayed();
        if(((Boolean) ImagineOrg.get('IsSandbox'))){
            if(theme == 'Theme4d'){
                key = '7d1c3beb-4e9f-4e11-b636-0e9a54394684';
            } else {
                key = '21ad23a4-9684-43fd-b2f5-f93605e0e5d7';
            }
        } else {
            if(theme == 'Theme4d'){
                key = '97ed6cba-cdf4-426a-b885-04f96be5b9de';
            } else {
                key = 'ad68376c-c595-42a2-bfcb-12b8ef4305c5';
            }
        }
        return key;
    }

    @TestVisible
    private static String getCustomerSecret(){
        String secret = null;
        String theme = UserInfo.getUiThemeDisplayed();
        if(((Boolean) ImagineOrg.get('IsSandbox'))){
            if(theme == 'Theme4d'){
                secret = 'SpJKKdP8ck8vLncBba6nhM4';
            } else {
                secret = 'ngrWJQbsbfLZTG45377[:}!';
            }
        } else {
            if(theme == 'Theme4d'){
                secret = 'ofhAKWD934-%-#nnxqAJQ69';
            } else {
                secret = 'zRpona4wcWA6KMtXAodxOSq';
            }
        }
        return secret;
    }
    
    global class Session {
        public String access_token {get; set;}
        public String refresh_token {get; set;}
        public Integer expires_in {get; set;}
    }
}