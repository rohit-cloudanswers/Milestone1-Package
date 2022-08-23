global class ExportGUIDBatch implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    
    private List<String> output;
    private String driveUrl;
    private String emailAddress;
    
    global ExportGUIDBatch(String driveUrl, String emailAddress){
        this.output = new List<String>();
        this.driveUrl = driveUrl;
        this.emailAddress = emailAddress;
    }
    
    global List<Integer> start(Database.BatchableContext bc) {
        return new List<Integer>{1};
    }
    
    global void execute(Database.BatchableContext bc, List<Integer> scope) {
        Map<String, String> headers = OneDriveService.getAuthorizationHeader(null);
        String nextLink = null;
        String response = HttpHelper.doGet(driveUrl, headers);
        if(String.isNotBlank(response) && response.indexOf('InvalidAuthenticationToken') != -1) {
            // refresh access token and retry
            response = OneDriveService.refreshTokenAndRetry('GET', driveUrl, headers, null);
        }
        if(response != null) {
            Map<String, Object> container = (Map<String, Object>)JSON.deserializeUntyped(response);
            nextLink = (String) container.get('@odata.nextLink');
        
            for (Object o : (Object[])container.get('value')) {
                Map<String, Object> oMap = (Map<String, Object>)o;
                output.add('' + oMap.get('id') + '\t' + oMap.get('name'));
            }
            // if you get "Uncommitted work expection", please comment the following lines of code, run the snippet
            // and then uncomment and run again, it should work
            while(String.isNotBlank(nextLink)){
                if(Test.isRunningTest()) HttpHelper.httpTestResponse = ExportGUIDBatchTest.TEST_NEXT_RESPONSE;
                response = HttpHelper.doGet(nextLink, headers);
                
                container = (Map<String, Object>)JSON.deserializeUntyped(response);
        
                for (Object o : (Object[])container.get('value')) {
                    Map<String, Object> oMap = (Map<String, Object>)o;
                    output.add('' + oMap.get('id') + '\t' + oMap.get('name'));
                }
                nextLink = (String) container.get('@odata.nextLink');
            }
            if(OneDriveController.saveSession != null) OneDriveController.saveTokens(OneDriveController.saveSession);
        } else {
            System.debug('@@ ' + response);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { emailAddress };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Sharepoint GUIDs');
        mail.setHtmlBody('Please find attached');
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setBody(Blob.valueOf(String.join(output, '\n')));
        efa.setFileName('GUIDs.csv');
        mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{efa});
        if(!output.isEmpty() && !Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}