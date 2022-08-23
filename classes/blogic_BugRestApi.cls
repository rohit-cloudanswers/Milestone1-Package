@RestResource(urlMapping='/BugResponse')
global without sharing class blogic_BugRestApi {
    
    global static string nnull(String val){
        if(val==null)
            val = '';
        return val.escapeXml();
    }
    
    @HttpPost
    global static string doPost(){
        String result = '';
        String reqX = '';
        try{
            if(test.isRunningTest()){
                bug__c bug = [SELECT Bug_Number__c, Bugzilla_URL__c, Update_Date__c, Developer_Comments__c, 
                                 Release_Date__c, Fixed_Version_Number__c, Old_Bug_Number__c, Operation_Code__c, Status__c
                                FROM Bug__c LIMIT 1];
                reqX = '<ns0:SiebelMessage MessageId="MessageId_0" IntObjectName="H_BCD Activity Bugzilla Interface IB" MessageType="Integration Object" IntObjectFormat="IntObjectFormat_3" xmlns:ns0="http://www.siebel.com/xml/H_BCD%20Activity%20Bugzilla%20Interface%20IB">  <ListOfH_BcdActivityBugzillaInterfaceIb>    <H_BcdActivityBugzillaInterface>';
                reqX += '<ActivityId>' + bug.Id + '</ActivityId>      <ActivityUpdateDateTime>ActivityUpdateDateTime_0</ActivityUpdateDateTime>      <AccountId>AccountId_0</AccountId>      <AccountName>AccountName_0</AccountName>      <Comments>Comments_0</Comments>      <CreatedByName>CreatedByName_0</CreatedByName>      <Summary>Summary_0</Summary>      <Product>Product_0</Product>      <Component>Component_0</Component>      <BugId>BugId_0</BugId>      <CritDateTime>CritDateTime_0</CritDateTime>      <Priority>Priority_0</Priority>      <Severity>Severity_0</Severity>      <Status>Status_0</Status>      <Type>Type_0</Type>      <FixedVerNum>FixedVerNum_0</FixedVerNum>      <VerNum>VerNum_0</VerNum>      <BugUpdDt>BugUpdDt_0</BugUpdDt>      <OldBugNum>OldBugNum_0</OldBugNum>      <OperationCode>9</OperationCode>      <Attachment>Attachment_0</Attachment>      <BugURL>BugURL_0</BugURL>      <ServiceRequestId>ServiceRequestId_0</ServiceRequestId>      <DeadlineDateTime>DeadlineDateTime_0</DeadlineDateTime>      <Description>Description_0</Description>    </H_BcdActivityBugzillaInterface>  </ListOfH_BcdActivityBugzillaInterfaceIb></ns0:SiebelMessage>';
            } else {
                RestRequest req = RestContext.request;
                system.debug('Restrequest: ' + req);
                reqX = req.requestBody.toString();
            }
            system.debug('Restrequest Body: ' + reqX);
            reqX = reqX.right(reqX.length()-reqx.indexOf('<ListOfH_BcdActivityBugzillaInterfaceIb>'));
            reqX = reqX.remove('<ListOfH_BcdActivityBugzillaInterfaceIb>');
            reqX = reqX.remove('</ListOfH_BcdActivityBugzillaInterfaceIb>');
            reqX = reqX.remove('</ns0:SiebelMessage>');
            reqX = reqX.trim();

            Dom.Document xdoc = new Dom.Document();
            xdoc.load(reqX); 
            String ns = null;
            
            //Retrieve the root element for this document.
            Dom.XMLNode bugMessage = xdoc.getRootElement();

            //SF ID
            String sfbugId = nnull(bugMessage.getChildElement('ActivityId', ns).getText());
            String bugNumber = nnull(bugMessage.getChildElement('BugId', ns).getText());
            if(sfBugID!='' && bugNumber != ''){
                //try to retrieve bug record
                List<Bug__c> bugs = [SELECT Bug_Number__c, Bugzilla_URL__c, Update_Date__c, Developer_Comments__c, 
                                     Release_Date__c, Fixed_Version_Number__c, Old_Bug_Number__c, Operation_Code__c, Status__c
                                    FROM Bug__c WHERE Siebel_Row_Id__c = :sfBugId OR Id = :sfbugId ORDER BY CreatedDate DESC LIMIT 1];
                if (bugs.size()>0) {
                    bug__c bug = bugs[0];
                    bug.Bug_Number__c = bugNumber;
                    bug.Bugzilla_URL__c = nnull(bugMessage.getChildElement('BugURL', ns).getText());
                    bug.Developer_Comments__c = nnull(bugMessage.getChildElement('Comments', ns).getText());
                    bug.Fixed_Version_Number__c = nnull(bugMessage.getChildElement('FixedVerNum', ns).getText());
                    bug.Old_Bug_Number__c = nnull(bugMessage.getChildElement('OldBugNum', ns).getText());
                    bug.Operation_Code__c = nnull(bugMessage.getChildElement('OperationCode', ns).getText());
                    bug.Status__c = nnull(bugMessage.getChildElement('Status', ns).getText());
                    
                    String dateString = bugMessage.getChildElement('DeadlineDateTime', ns).getText();
                    if (String.isNotBlank(dateString)) {
                        // remove time
                        dateString = dateString.split(' ')[0];
                        try {
                            bug.Release_Date__c = Date.parse(dateString);
                        } catch (Exception e) {
                            bug.Release_Date__c = Date.valueOf(dateString);
                        }
                    } else {
                        bug.Release_Date__c = null;
                    }
                        
                    String dateString1 = bugMessage.getChildElement('BugUpdDt', ns).getText();
                    if (String.isNotBlank(dateString1)) {
                        // remove time
                        dateString1 = dateString1.split(' ')[0];
                        try {
                            bug.Update_Date__c = Date.parse(dateString1);
                        } catch (Exception e) {
                            bug.Update_Date__c = Date.valueOf(dateString1);
                        }
                    } else {
                        bug.Update_Date__c = null;
                    }


                   // try{
                  //      bug.Update_Date__c = date.valueOf(nnull(bugMessage.getChildElement('BugUpdDt', ns).getText())); 
                 //   }
                  //  catch (exception de){}
                  //  try{
                  //      bug.Release_Date__c = date.valueOf(nnull(bugMessage.getChildElement('DeadlineDateTime', ns).getText()));
                  //  }
                 //   catch (exception de){}
                    
                    update bug;
                    
                    result = 'Success';
                    
                } else {
                    //no bug found
                    result = 'Error: No bug found for: ' + sfBugId + ' | RequestBody: ' + reqX; 
                    writeErrorLog(sfbugId, result);
                }
            } else { 
                //no bug number or activityId
                result = 'Error: No value for ActivityId or BugId. ActivityId: ' + sfBugId + ' BugId: ' + bugNumber + ' | RequestBody: ' + reqX; 
                writeErrorLog(sfbugId, result);
            }
        }
        catch(exception e) {
            result = 'Error: ' + e.getMessage() + ' ' + e.getStackTraceString() + ' | RequestBody: ' + reqX;
            writeErrorLog('', result);
        }
        return result;
    }
    
    global static void writeErrorLog(String sfBugId, String message){
        try{
            Integration_Log__c il = new Integration_log__c();
                il.Action__c = 'Error';
                il.Category__c = 'Integration';
                il.Detail__c = 'Error for bug Id: ' + sfBugId + ', message: ' + message;
                il.Direction__c = 'InToSF';
                il.External_Id__c = sfBugId;
                il.Message__c = message.abbreviate(255);
                il.Object_Api_Name__c = 'Bug__c';
                il.External_Id__c = sfBugId;
                il.Requires_Attention__c = true;
            insert il;
        } 
        catch (exception e){
            system.debug(e.getMessage());
        }
    }
    
    @HttpGet
    global static String doGet(){
        if(RestContext.request.params.containsKey('bugId')){
            String bugId = RestContext.request.params.get('bugId');
            return blogic_bug.getXMLOut(getBug(bugId));
        } else {
            return null;
        }
    }
    
    global static bug__c getBug(String bugId){
        try{
            Bug__c bug = [SELECT Account_Name__c,Bugzilla_URL__c,Bug_Attachments__c,Bug_Number__c,Case_Asset_Version__c,
                              Case_Priority__c,Case_Product_Category__c,Case_Product_Family__c,Case_Severity__c,Case__c,
                              Comments__c,CreatedById, CreatedBy.Name,CreatedDate,CurrencyIsoCode,Description__c,Developer_Comments__c,
                              Fixed_Version_Number__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,
                              LastViewedDate,Name,Old_Bug_Number__c,Operation_Code__c,Oracle_Customer_Number__c,
                              Planned_Completion__c,RecordTypeId,Record_Type__c,Release_Date__c,Siebel_Row_Id__c,Status__c,
                              Submitted_By__c,Submitted_Date__c,SystemModstamp,Type__c,Update_Date__c 
                          FROM  Bug__c 
                          WHERE Siebel_Row_Id__c = :bugId OR Id = :bugId OR Bug_Number__c = :bugId OR bug_Integration_Id__c = :bugId];
            return bug;  
        } 
        catch (exception e){
            return null;
        }   
    }
}