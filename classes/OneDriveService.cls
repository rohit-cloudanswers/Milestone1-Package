public with sharing class OneDriveService {

    private static final String ONEDRIVE_BASE_URL = 'https://graph.microsoft.com/v1.0/sites/';
    private static final String ONEDRIVE_DOCUMENT_LIBRARY = ONEDRIVE_BASE_URL + '{0}/drive';
    private static final String ONEDRIVE_DOCUMENT_LIBRARY_CHILDREN = ONEDRIVE_DOCUMENT_LIBRARY + '/items/root';
    private static final String FOLDER_DETAILS = ONEDRIVE_BASE_URL + '{0}/drive/items/{1}';
    private static final String FOLDER_CHILD_URL = ONEDRIVE_BASE_URL + '{0}/drive/items/{1}?expand=children';
    private static final String FOLDER_URL = ONEDRIVE_BASE_URL + '{0}/drive/items/{1}/children';
    private static final String CREATE_UPLOAD_SESSION = ONEDRIVE_BASE_URL + '{0}/drive/items/{1}:/{2}:/createUploadSession';
    private static final String INVALID_AUTHENTICATION_TOKEN = 'InvalidAuthenticationToken';
    
    public static String loadDocumentLibrary(String siteId, String accessToken){
        String url = String.format(ONEDRIVE_DOCUMENT_LIBRARY, new String[]{siteId});
        Map<String, String> headers = getAuthorizationHeader(accessToken);
        String response = HttpHelper.doGet(url, headers);
        if(String.isNotBlank(response) && response.indexOf(INVALID_AUTHENTICATION_TOKEN) != -1) {
            // refresh access token and retry
            response = refreshTokenAndRetry('GET', url, headers, null);
        }
        return response;
    }

    public static String loadDocumentLibraryChildren(String siteId, String accessToken){
        String url = String.format(ONEDRIVE_DOCUMENT_LIBRARY_CHILDREN, new String[]{siteId});
        Map<String, String> headers = getAuthorizationHeader(accessToken);
        String response = HttpHelper.doGet(url, headers);
        if(String.isNotBlank(response) && response.indexOf(INVALID_AUTHENTICATION_TOKEN) != -1) {
            // refresh access token and retry
            response = refreshTokenAndRetry('GET', url, headers, null);
        }
        return response;
    }
    
    public static String loadFolderDetails(String siteId, String folderId, String accessToken){
        String url = String.format(FOLDER_DETAILS, new String[]{siteId, folderId});
        Map<String, String> headers = getAuthorizationHeader(accessToken);
        String response = HttpHelper.doGet(url, headers);
        if(String.isNotBlank(response) && response.indexOf(INVALID_AUTHENTICATION_TOKEN) != -1) {
            // refresh access token and retry
            response = refreshTokenAndRetry('GET', url, headers, null);
        }
        return response;
    }
    
    public static String loadChildren(String siteId, String folderId, String accessToken){
        String url = String.format(FOLDER_CHILD_URL, new String[]{siteId, folderId});
        Map<String, String> headers = getAuthorizationHeader(accessToken);
        String response = HttpHelper.doGet(url, headers);
        if(String.isNotBlank(response) && response.indexOf(INVALID_AUTHENTICATION_TOKEN) != -1) {
            // refresh access token and retry
            response = refreshTokenAndRetry('GET', url, headers, null);
        }
        return response;
    }
    
    public static String loadChildrenPaginated(String siteId, String folderId, String accessToken){
        String url = String.format(FOLDER_URL, new String[]{siteId, folderId});
        Map<String, String> headers = getAuthorizationHeader(accessToken);
        String response = HttpHelper.doGet(url, headers);
        if(String.isNotBlank(response) && response.indexOf(INVALID_AUTHENTICATION_TOKEN) != -1) {
            // refresh access token and retry
            response = refreshTokenAndRetry('GET', url, headers, null);
        }
        return response;
    }
    
    public static String createUploadSession(String siteId, String folderId, String fileName, String accessToken) {
        String url = String.format(CREATE_UPLOAD_SESSION, new String[]{siteId, folderId, fileName});
        Map<String, String> headers = getAuthorizationHeader(accessToken);
        headers.put('Accept', 'application/json');
        String payload = '{"item":{"@microsoft.graph.conflictBehavior":"rename","name":"'+fileName+'"}}';
        String response = HttpHelper.doPost(url, payload, headers);
        if(String.isNotBlank(response) && response.indexOf(INVALID_AUTHENTICATION_TOKEN) != -1) {
            // refresh access token and retry
            response = refreshTokenAndRetry('GET', url, headers, null);
        }
        return response;
    }
    
    public static String createFolder(String siteId, String parentFolderId, String payload, String accessToken){
        String url = String.format(FOLDER_URL, new String[]{siteId, parentFolderId});
        Map<String, String> headers = getAuthorizationHeader(accessToken);
        headers.put('Accept', 'application/json');
        String response = HttpHelper.doPost(url, payload, headers);
        if(String.isNotBlank(response) && response.indexOf(INVALID_AUTHENTICATION_TOKEN) != -1) {
            // refresh access token and retry
            headers.put('Accept', 'application/json');
            response = refreshTokenAndRetry('POST', url, headers, payload);
        }
        return response;
    }
    
    public static String refreshTokenAndRetry(String method, String url, Map<String, String> headers, String payload){
        String response = null;
        OneDriveController.Session s = OneDriveController.getTokenFromRefreshToken();
        if(String.isNotBlank(s.access_token)) {
            OneDriveController.saveSession = s;
            headers.putAll(getAuthorizationHeader(s.access_token));
            if(method == 'GET'){
                response = HttpHelper.doGet(url, headers);
            } else if(method == 'POST'){
                response = HttpHelper.doPost(url, payload, headers);
            }
        }
        return response;
    }
    
    public static Map<String, String> getAuthorizationHeader(String accessToken){
        Map<String, String> authHeader = new Map<String, String>();
        if(String.isNotBlank(accessToken)) {
            authHeader.put('Authorization', 'Bearer ' + accessToken);
        } else {
            List<Token__c> tokens = [
                select Access_Token__c 
                from Token__c where CreatedById = :UserInfo.getUserId()
            ];
            if(tokens.size() != 0) accessToken = tokens.get(0).Access_Token__c;
            if(String.isNotBlank(accessToken)) {
                authHeader.put('Authorization', 'Bearer ' + accessToken);
            } else {
                throw new MissingTokenException('Token missing for current user');
            }
        }
        return authHeader;
    }

    public static Map<String, Object> getOneDriveObjectSetting(String sObjName, String recordId){
        Map<String, Object> objectSetting = null;
        List<OneDrive_Objects__c> settings = OneDrive_Objects__c.getAll().values();
        for(OneDrive_Objects__c setting : settings) {
            if(setting.Object_Identifier__c.equals(sObjName)) {
                objectSetting = new Map<String, Object>();
                objectSetting.put('recordId', recordId);
                objectSetting.put('objectName', setting.Object_Identifier__c);
                objectSetting.put('parentObjectIdentifier', setting.Parent_Object_Identifier__c);
                objectSetting.put('baseFolderName', setting.Base_Folder_Identifier__c);
                objectSetting.put('baseFolderId', setting.Base_Folder_Id__c);
                objectSetting.put('folderField', setting.Record_Folder_Identifier__c);
                objectSetting.put('defaultFolders', setting.Default_Folders__c);
                objectSetting.put('createNestedFolder', setting.Create_Nested_Folder__c);
            }
        }
        if(objectSetting != null && objectSetting.containsKey('parentObjectIdentifier')) {
            String parentObjectIdentifier = (String) objectSetting.get('parentObjectIdentifier');
            // describe current object
            System.Type systemType = Type.forName(sObjName);
            SObject sObj = (SObject) systemType.newInstance();
            DescribeSObjectResult objectDescribe = sObj.getSObjectType().getDescribe();
            if(objectDescribe.fields.getMap().containsKey(parentObjectIdentifier)) {
                List<sObject> records = Database.query('select ' + parentObjectIdentifier + ' from ' + sObjName + ' where Id = :recordId');
                if(!records.isEmpty()) {
                    sObject obj = records.get(0);
                    String lookupField = (String) obj.get(parentObjectIdentifier);
                    if(String.isNotBlank(lookupField)) {
                        if(objectDescribe.fields.getMap().containsKey(lookupField)) {
                            DescribeFieldResult dfr = objectDescribe.fields.getMap().get(lookupField).getDescribe();
                            List<Schema.SObjectType> parentObjects = dfr.getReferenceTo();
                            objectSetting.put('parentObjectName', parentObjects.get(0).getDescribe().getName());
                            objectSetting.put('parentLookupField', lookupField);
                        } else {
                            objectSetting.remove('parentObjectIdentifier');
                        }
                    }
                }
            }
        }
        return objectSetting;
    }

    public static List<String> getParentRecordIdField(String parentObjectName, String objectName){
        List<String> fieldNames = new List<String>();
        System.Type systemType = Type.forName(parentObjectName);
        SObject sObj = (SObject) systemType.newInstance();
        DescribeSObjectResult parentDescribe = sObj.getSObjectType().getDescribe();
        for (Schema.ChildRelationship rel : parentDescribe.getChildRelationships()) {
            DescribeSObjectResult childDescribe = rel.getChildSObject().getDescribe();
            if(childDescribe.getName() == objectName){
                String fieldName = rel.getField().getDescribe().getName();
                fieldNames.add(fieldName);
            }
        }
        return fieldNames;
    }
    
    public class MissingTokenException extends Exception {}
}