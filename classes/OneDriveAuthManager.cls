global class OneDriveAuthManager {

    private static Organization org = getOrganization();
    @TestVisible
    private static String host = 'https://login.microsoftonline.com/';
    private static String tenant = 'common';
    private static String authURL = host + tenant + '/oauth2/v2.0/authorize';
    private static String tokenURL = host + tenant + '/oauth2/v2.0/token';
    private static final String CONSUMER_KEY = org.IsSandbox ? '7d1c3beb-4e9f-4e11-b636-0e9a54394684' : 'ad68376c-c595-42a2-bfcb-12b8ef4305c5';
    private static final String CONSUMER_SECRET = org.IsSandbox ? 'SpJKKdP8ck8vLncBba6nhM4' : 'zRpona4wcWA6KMtXAodxOSq';
    private static final String[] scopes = new String[]{
        'openid',
        'Files.ReadWrite.All',
        'offline_access'
    };
    
    global OneDriveAuthManager(OneDriveController controller) {
    }

    global class Session {
        String access_token;
        String refresh_token;
        Integer expires_in;
    }

    @RemoteAction
    global static String getAuthStartUrl(String redirectURL, String state){
        String params = 'client_id='+EncodingUtil.urlEncode(CONSUMER_KEY,'UTF-8')
            + '&scope='+EncodingUtil.urlEncode(String.join(scopes, ' '),'UTF-8')
            + '&response_type=code'
            + '&response_mode=query'
            + '&redirect_uri='+ EncodingUtil.urlEncode(completeUrl(redirectURL),'UTF-8')
            + '&state=' + EncodingUtil.urlEncode(state,'UTF-8');
        return authURL+'?'+ params;
    }

    @RemoteAction
    global static Session getTokenFromCode(String code, String redirectURL){
        String payload = 'code='+EncodingUtil.urlEncode(code,'UTF-8')
            +'&client_id='+EncodingUtil.urlEncode(CONSUMER_KEY,'UTF-8')
            +'&client_secret='+EncodingUtil.urlEncode(CONSUMER_SECRET,'UTF-8')
            +'&grant_type=authorization_code'
            +'&redirect_uri='+EncodingUtil.urlEncode(completeUrl(redirectURL),'UTF-8');
        String body = doPost(tokenURL,payload);
        Session sessionResult = (Session) JSON.deserialize(body, Session.class);
        return sessionResult;
    }

    @RemoteAction
    global static Session getTokenFromRefreshToken(String refreshToken){
        String payload = 'client_id='+EncodingUtil.urlEncode(CONSUMER_KEY, 'UTF-8')
            +'&client_secret='+EncodingUtil.urlEncode(CONSUMER_SECRET, 'UTF-8')
            +'&refresh_token='+EncodingUtil.urlEncode(refreshToken, 'UTF-8')
            +'&grant_type=refresh_token';
        String body = doPost(tokenURL,payload);
        return (Session)JSON.deserialize(body, Session.class);
    }

    @Testvisible
    private static String doPost(String endpoint, String payload){
        Http h = new Http();
        String resBody = '';
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(payload );
        req.setEndpoint(endpoint);
        resBody = Test.isRunningTest() ? '{}' : h.send(req).getBody();
        return resBody;
    }

    @Testvisible
    private static Organization getOrganization(){
        if(org == NULL){
            List<Organization> orgs = [
                SELECT Id , Name, InstanceName, IsSandbox
                FROM Organization
                LIMIT 1 // limit for force.com code scanner
            ];
            for(Organization o : orgs){
                org = o;
            }
        }
        return org;
    }

    @RemoteAction
    global static String redirectTo(String uri) {
        return completeUrl(uri);
    }

    @TestVisible
    private static String completeUrl (String url) {
        if (!url.startsWith('https://')) {
            if (!url.startsWith('/')) {
                url = '/' + url;
            }
            url = 'https://' + org.InstanceName + '.salesforce.com' + url;
        }
        return url;
    }
}