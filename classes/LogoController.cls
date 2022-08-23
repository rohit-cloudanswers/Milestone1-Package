public class LogoController{
    public String logoId{get;set;}
    public LogoController(ApexPages.StandardController stdController)
    {
        Account accRecord = (Account)stdController.getRecord();
        Account accLogo = [select Logo_Id__c from Account where Id =: accRecord.Id];        
        logoId = accLogo.Logo_Id__c;    
    }
}