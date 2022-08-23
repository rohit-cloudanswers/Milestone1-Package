public virtual class BatchErrorAlert {

    @TestVisible
    public List<String> errors;
    protected String emailSubject;
    protected String bodyTitle;
    private List<String> toAddresses;
    private List<String> ccAddresses;
    
    public BatchErrorAlert(){
        this.errors = new List<String>();
        this.toAddresses = new List<String>();
        this.ccAddresses = new List<String>();
        // class name so we know which class
        this.emailSubject = 'Batch Apex Errors for ' + (''+this).substringBefore(':');
        this.bodyTitle = 'The following errors occured during the last execution: ';
    }
    
    @TestVisible
    protected void collectErrors (List<Database.SaveResult> saveResults) {
        for(Database.SaveResult res : saveResults){
            if(!res.isSuccess()){
                for(Database.Error error : res.getErrors()) {
                    errors.add('Record: ' + res.getId()  + ' => Error: ' + error.getMessage());
                }
            }
        }
    }
    
    @TestVisible
    protected void sendErrorEmails(){
        
        // don't send empty error emails
        if (errors == null || errors.isEmpty()) {
            System.debug('no errors, skipping email');
            return;
        }
        
        String htmlBody = '<div>Hi there,<br /><br /><h4>'+ bodyTitle +'</h4><ul>';
        for(String error : errors) {
            htmlBody += '<li>'+ error +'</li>';
        }
        htmlBody += '</ul></div>';
        
        if(toAddresses.size() == 0) toAddresses.add(UserInfo.getUserEmail());

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(toAddresses);
        if(ccAddresses.size() != 0) email.setCcAddresses(ccAddresses);
        email.setSubject(emailSubject);
        email.setHtmlBody(htmlBody);
        emails.add(email);
        if(!emails.isEmpty() && !Test.isRunningTest()) Messaging.sendEmail(emails);
    }
    
    protected void addToAddress(String emailAddress){
        toAddresses.add(emailAddress);
    }
    
    protected void addCcAddress(String emailAddress){
        ccAddresses.add(emailAddress);
    }
}