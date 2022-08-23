@isTest
public class Test_SendingEmail {
  
	@isTest
    static void testsendTemplatedEmail(){
      Account a1 = new Account();
        a1.Name ='Test Account';
        
        Contact con = new Contact();
        con.LastName='Test';
        
        Case c = new Case(AccountId = a1.Id,contactId=con.Id);
        
        List<String> toRecipients =new List<String>{UserInfo.getUserEmail()};
            List<String> ccRecipients = new List<String>{UserInfo.getUserEmail()};
                
      Folder f = [Select Id,Name from Folder where Type='Email' LIMIT 1];
      BrandTemplate br = [Select Id,Name from BrandTemplate LIMIT 1];
      EmailTemplate et =[SElect Id,name,DeveloperName,FolderId,TemplateType,BrandTemplateId,TemplateStyle,Body from EmailTemplate
                          where FOlderId =: f.Id LIMIT 1];
       system.debug('et is : '+et);
      
      String templateApiName = et.DeveloperName;
      Id targetObjId = UserInfo.getUserId();
      Id whatId =c.Id;
      Id orgWideEmailId = null;
      Boolean saveAsActivity = false;
      
      List<Attachment> attachList = null;
        
        User u = [Select Id from User where Id =: UserInfo.getUserId()];
      
        System.runAs(u){
	      SendingEmail.sendTemplatedEmail(toRecipients, ccRecipients, templateApiName, targetObjId, whatId, orgWideEmailId, saveAsActivity, attachList) ;
        }
        system.debug('SendingEmail.email  : '+SendingEmail.email ); 
        system.assertNotEquals(SendingEmail.emailResult,null);
        
    }

}