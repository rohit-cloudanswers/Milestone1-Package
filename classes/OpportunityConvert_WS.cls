global with sharing class OpportunityConvert_WS {

    webservice static string convertToDirectOpty(String oppId){
        String successMsg = 'Success';
        String recrdTypeId = [Select id from recordType where developerName ='Direct_Sales' and sobjectType='Opportunity' limit 1].id;
        Opportunity opp = [select id,recordTypeId,Converted_Opportunity__c from opportunity where id=:oppId limit 1];
        try{
            opp.recordTypeId = recrdTypeId;
            opp.Converted_Opportunity__c = true;
            update opp;
            return successMsg;
        }
        catch(exception e){
            return e.getMessage();
        }
    }
    webservice static string convertToIndirectOpty(String oppId){
        String successMsg = 'Success';
        String recrdTypeId = [Select id from recordType where developerName ='Indirect_Sales' and sobjectType='Opportunity' limit 1].id;
        Opportunity opp = [select id,recordTypeId,Converted_Opportunity__c from opportunity where id=:oppId limit 1];
        try{
            opp.recordTypeId = recrdTypeId;
            opp.Converted_Opportunity__c = true;
            update opp;
            return successMsg;
        }
        catch(exception e){
            return e.getMessage();
        }
    }
       
    webservice static String updateQuote(String qId){
        String successMsg = 'The quote has already been submitted to the PS';
        List<QuoteLineItem> ql = [Select QuoteId,Product_Group__c From QuoteLineItem Where QuoteId=:qId and Product_Group__c like 'Professional Services%'];        
        Quote q = [select id,Professional_Service_Requested__c,submit_to_ps__c from quote where id=:qId];
        try{
            if(!q.Professional_Service_Requested__c){
                successMsg = 'Professional Service Requested should be selected inorder to Submit to PS.';
            }
            else if(!q.submit_to_ps__c && ql.size()>0)
            {
                q.submit_to_ps__c = true;
                update q;
                successMsg = 'You have successfully submitted the quote to the PS.';
            }
            else if(!q.submit_to_ps__c && ql.size()==0)
            {
                successMsg = 'The quote should have atleast one Professional Services line item on the quote.';                
            }
            return successMsg;
        }
        catch(exception e){
            return e.getMessage();
        }
    } 

    webservice static void updateQuoteStatus(String qId){
        Quote q = [select id,submit_to_ps__c,status from quote where id=:qId];
        if(q.status == 'Draft')
        {
            q.status = 'Needs Review';
            update q;
        }
    }

    webservice static Boolean isPartnerUser(){
      Id userId = UserInfo.getUserId();
      User u = [select Id,IsPortalEnabled from User where Id =:userId];
      return u.IsPortalEnabled;
    }
    
    webservice static String getLoggedInUserAccount(String uId){
        String accountString = '';
        try{
            User u = [select ContactId from User where Id=:uId];
            Contact c = [select AccountId,Account.Name from Contact where Id=:u.ContactId];
            accountString = c.AccountId+'@'+c.Account.Name;
            return accountString;
        }
        catch(exception e){
            return e.getMessage();
        }
    }
}