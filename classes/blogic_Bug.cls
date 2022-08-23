global without sharing class blogic_Bug {
    global static void updateDevComment(Map<Id,Bug__c> oldBugs,Map<Id,Bug__c> newBugs){
        system.debug('oldBugs is : '+oldBugs);
        system.debug('newBugs is : '+newBugs);
        
        List<Bug__c> changedBugs = new List<Bug__c>();
        
        //Looping through the values to check if the comments have changed from Bugzilla
        for(Bug__c b : newBugs.values()){
            if(b.Developer_Comments__c != oldBugs.get(b.Id).Developer_Comments__c && (b.Developer_Comments__c != null || oldBugs.get(b.Id).Developer_Comments__c != null)){
                    changedBugs.add(b);
            }
            //check to make sure the status will not be overwritten by "submitted"
            if(b.status__c != null && b.status__c.toLowerCase() == 'submitted'){
               if(!String.IsEmpty(oldBugs.get(b.id).status__c)){
                   b.status__c = oldBugs.get(b.id).status__c;
               }
            }
        }
        system.debug('changedBugs is : '+changedBugs);
        if(changedBugs == null){
            return;
        }
        //Looping through the bugs that has new comments to append
        for(Bug__c bug : changedBugs){
            String oldValue = oldBugs.get(bug.Id).Developer_Comments__c;
            String newValue = newBugs.get(bug.Id).Developer_Comments__c;
            
            if(oldValue != null && newValue != null){
                newBugs.get(bug.Id).Developer_Comments__c = oldValue +'\n'+system.now()+'\n'+ newValue;    
            }else if(oldValue != null && newValue == null){
                newBugs.get(bug.Id).Developer_Comments__c = oldValue;
            }else if(oldValue == null && newValue != null){
                newBugs.get(bug.Id).Developer_Comments__c = newValue;
            }
            
        }
        system.debug('newBugs is : '+newBugs);
        
    }
    
    global static string nnull(String val){
        if(val==null)
            val = '';
        return val.escapeXml();
    }
    
    webservice static string sendBug(Id bugId){
        String result = '';
        try{
            if(bugId!=null){
                
                Bug__c bug = [SELECT Account_Name__c,case__r.CaseNumber, Bugzilla_URL__c,Bug_Attachments__c,Bug_Number__c,Case_Asset_Version__c,Bug_Integration_Id__c,
                              Case_Priority__c,Case_Product_Category__c,Case_Product_Family__c,Case_Severity__c,Case__c,
                              Comments__c,CreatedBy.Name,CreatedDate,CurrencyIsoCode,Description__c,Developer_Comments__c,
                              Fixed_Version_Number__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,
                              Name,Old_Bug_Number__c,Operation_Code__c,Oracle_Customer_Number__c,
                              Planned_Completion__c,RecordTypeId,Record_Type__c,Release_Date__c,Siebel_Row_Id__c,Status__c,
                              Submitted_By__c,Submitted_Date__c,SystemModstamp,Type__c,Update_Date__c FROM Bug__c WHERE Id = :bugId];
                
                String response = bugCallOut(getXMLOut(bug));
                if(!response.contains('Error')){
                    bug.Bug_Integration_Id__c = response;
                    update bug;
                    result = 'Success.';
                } else {
                    result = response;
                }
            }
        }
        catch(exception e){
            result = e.getMessage();
        }
        return result;
    }
    
    global static string getXMLOut(bug__c bug){
        String response = '';
        if(bug!=null){

            list<StaticResource> srs = [SELECT Id,Name,body FROM StaticResource WHERE Name = 'BugOutxml'];
            
            if(srs.size()>0){
                String ns = 'http://www.siebel.com/xml/H_BCDActivityBugzillaInterfaceOB';
                Dom.Document xdoc = new Dom.Document();
                xdoc.load(srs[0].body.tostring());
                
                //Retrieve the root element for this document.
                Dom.XMLNode bugMessageDoc = xdoc.getRootElement();
                Dom.XMLNode bugMessageList = bugMessageDoc.getChildElement('ListOfH_BcdActivityBugzillaInterfaceOb',ns);
                Dom.XMLNode bugMessage = bugMessageList.getChildElement('H_BcdActivityBugzillaInterface',ns);
                system.debug('message ' + bugMessage);
                bugMessage.getChildElement('AccountId', ns).addTextNode(nnull(bug.Oracle_Customer_Number__c));
                bugMessage.getChildElement('AccountName', ns).addTextNode(nnull(bug.Account_Name__c));
                bugMessage.getChildElement('ActivityId', ns).addTextNode(bug.Id);
                bugMessage.getChildElement('ActivityUpdateDateTime', ns).addTextNode(string.valueOf(bug.LastModifiedDate));
                bugMessage.getChildElement('Attachment', ns).addTextNode(nnull(string.valueOf(bug.Bug_Attachments__c)));
                bugMessage.getChildElement('BugId', ns).addTextNode(nnull(bug.Bug_Number__c));
                bugMessage.getChildElement('BugURL', ns).addTextNode(nnull(bug.Bugzilla_URL__c));
                bugMessage.getChildElement('BugUpdDt', ns).addTextNode(nnull(string.valueOf(bug.Update_Date__c)));
                bugMessage.getChildElement('Comments', ns).addTextNode(nnull(bug.Developer_Comments__c));
                bugMessage.getChildElement('Component', ns).addTextNode(nnull(bug.Case_Product_Category__c));
                bugMessage.getChildElement('CreatedByName', ns).addTextNode(bug.CreatedBy.Name);
                bugMessage.getChildElement('CritDateTime', ns).addTextNode(nnull(string.valueOf(bug.Planned_Completion__c)));
                bugMessage.getChildElement('DeadlineDateTime', ns).addTextNode(nnull(string.valueOf(bug.Release_Date__c)));
                bugMessage.getChildElement('Description', ns).addTextNode(nnull(bug.Comments__c));
                bugMessage.getChildElement('FixedVerNum', ns).addTextNode(nnull(bug.Fixed_Version_Number__c));
                bugMessage.getChildElement('OldBugNum', ns).addTextNode(nnull(bug.Old_Bug_Number__c));
                bugMessage.getChildElement('OperationCode', ns).addTextNode(nnull(bug.Operation_Code__c));
                bugMessage.getChildElement('Priority', ns).addTextNode(nnull(bug.Case_Priority__c));
                
                bugMessage.getChildElement('Product', ns).addTextNode(nnull(bug.Case_Product_Family__c));
                //system.debug('family: ' + bugMessage.getChildElement('Product', ns).getText());
                bugMessage.getChildElement('ServiceRequestId', ns).addTextNode(bug.case__r.CaseNumber);
                bugMessage.getChildElement('Severity', ns).addTextNode(nnull(bug.Case_Severity__c));
                bugMessage.getChildElement('Status', ns).addTextNode(nnull(bug.Status__c));
                bugMessage.getChildElement('Summary', ns).addTextNode(nnull(bug.Description__c));
                bugMessage.getChildElement('Type', ns).addTextNode(nnull(bug.Type__c));
                bugMessage.getChildElement('VerNum', ns).addTextNode(nnull(bug.Case_Asset_Version__c));
                
                response = xdoc.toXmlString().replace('&amp;amp;','&amp;' );
                
            }
        }
        return response;
    }
    
    global static string bugCallOut(String bugXml){
        String response = '';
        try{
            //this is the test callout check custom setting for prod
            String url = 'http://66.70.8.153/Bugzilla/BTSHTTPReceive.dll';
            try{
                ServiceCloudSettings__c bhs = ServiceCloudSettings__c.getValues('BugUrl');
                url = bhs.value__c;
            } catch (exception e){
                //trap custom setting exception
                system.debug('=================================================');
                system.debug('  Custom Setting BugUrl Is Not Set');
                system.debug('=================================================');
            }
            
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setBody(bugXml);
            if(test.isRunningTest()){
                response = '<BizTalkHttpReceive><CorrelationToken TokenType="SUBMIT">{VALUE}</CorrelationToken></BizTalkHttpReceive>';
            } else {
                HttpResponse res = h.send(req);
                response = res.getBody();
            } 
        } catch(exception e){
            response = e.getMessage();
        }
        if(response!=null && response.contains('<BizTalkHttpReceive><CorrelationToken TokenType="SUBMIT">{')){
            response = response.remove('<BizTalkHttpReceive><CorrelationToken TokenType="SUBMIT">{');
            response = response.remove('}</CorrelationToken></BizTalkHttpReceive>');
        }   else {
            if(response == null)
                response = 'Null http response.';
            response = 'Error: ' + response;
        }
        return response;
    }
    
}