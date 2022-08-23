public class SendingEmail {
    public static Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    public static Messaging.SendEmailResult[] emailResult = new Messaging.SendEmailResult[]{};
    
    public static void sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity, Attachment[] attachList ) {
  //  templateId   must be ID of an Email template
  //  targetObjId must be a Contact, User, Lead Id -- also used in merge fields of template recipient.xxxx
  //  whatId    must be an SObject that is used in the merge fields of the template relatedTo.xxxx
  //  fromId    if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
  //  bcc      not permitted when using templates

    
	Id templateId; 

	try {templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;}

    catch (Exception e) {
      system.debug('Exception Occured while getting Email template : '+e.getMessage());
    }
    
    email.setToAddresses(toRecipients);
    email.setCcAddresses(ccRecipients);
    email.setTargetObjectId(targetObjId);
    email.setWhatId(whatId);
    email.setorgWideEmailAddressId(orgWideEmailId);
    email.setTemplateId(templateId);
    email.setSaveAsActivity(saveAsActivity);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users
    System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, to:' + toRecipients + ' cc:' + ccRecipients +  ' templateId:' + templateId + ' tagetObjId:' + targetObjId +
                    ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
    try {
        emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        return;
    }
    catch (EmailException e) {system.debug('Exception occured while sending email :'+ e.getMessage());}
}


}