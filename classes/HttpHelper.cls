public with sharing class HttpHelper {
    
    public static String httpTestResponse = '{}';

    public static String doGet(String endpoint, Map<String, String> headers){
        Http h = new Http();
        String resBody = '';
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setTimeout(120000);
        // can be overriden with passed values for headers
        req.setHeader('Accept', 'application/json');
        if(headers != null && !headers.isEmpty()){
            for(String key : headers.keySet()){
                req.setHeader(key, headers.get(key));
            }
        }
        req.setEndpoint(endpoint);
        resBody = Test.isRunningTest() ? httpTestResponse : h.send(req).getBody();
        return resBody;
    }
    
    public static String doPost(String endpoint, String payload, Map<String, String> headers){
        Http h = new Http();
        String resBody = '';
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(120000);
        // can be overriden with passed values for headers
        req.setHeader('Content-Type', 'application/json');
        // set headers
        if(headers != null && !headers.isEmpty()){
            for(String key : headers.keySet()){
                req.setHeader(key, headers.get(key));
            }
        }
        // set payload
        if(payload != null) req.setBody(payload );
        req.setEndpoint(endpoint);
        resBody = Test.isRunningTest() ? httpTestResponse : h.send(req).getBody();
        return resBody;
    }
}