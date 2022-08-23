public class MPM4_Custom_Owner_Update_Ctrl {
    
    public MPM4_BASE__Milestone1_Project__c project;
    public MPM4_BASE__Milestone1_Project__c originalProject;
    public Boolean sendEmail {get; set;} 
    public Boolean updateToSystemInterface {get; set;}
    
    public MPM4_Custom_Owner_Update_Ctrl(ApexPages.StandardController controller){
        this.project = (MPM4_BASE__Milestone1_Project__c) controller.getrecord();
        originalProject = [select id, name, ownerid from MPM4_BASE__Milestone1_Project__c where id =: project.id];
        
        sendEmail = false;
        updateToSystemInterface = false;
    }
    
    Public PageReference save(){
        
        MPM4_BASE__Milestone1_Settings__c st = MPM4_BASE__Milestone1_Settings__c.getOrgDefaults();
        Boolean oldValue = st.MPM4_BASE__disable_triggers__c;
        
        st.MPM4_BASE__disable_triggers__c = true;
        upsert st; 
 
        update project; 
        assignToSysInterface();
        sendEmailMsg();
        
        st.MPM4_BASE__disable_triggers__c = oldValue;
        upsert st; 
        
        return new pagereference('/' + project.id);
    }
    
    private void sendEmailMsg(){ 
        if(this.sendEmail){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {project.ownerid};
                
                message.subject = 'Project transferred to you.';
            message.plainTextBody = originalProject.name + ' has been assigned to you. Please click on the link below to view the record.';
            message.plainTextBody += '\n' + URL.getSalesforceBaseUrl().toExternalForm()+ '/'+ project.id;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }
    
    private void assignToSysInterface(){
 
        if(this.updateToSystemInterface){
            User si = [select id, name from user where name = 'System Interface'];
            MPM4_BASE__Milestone1_Resource__c siRes = [select id from MPM4_BASE__Milestone1_Resource__c where MPM4_BASE__user__c =: si.id];
            
            List<MPM4_BASE__Milestone1_Milestone__c > mts = [select id, ownerid from MPM4_BASE__Milestone1_Milestone__c where MPM4_BASE__project__c =: project.id];
            List<MPM4_BASE__Milestone1_Task__c> ts = [select id, MPM4_BASE__resource__c from MPM4_BASE__Milestone1_Task__c where MPM4_BASE__project_milestone__r.MPM4_BASE__project__c =: project.id];
            
            for(MPM4_BASE__Milestone1_Milestone__c m : mts){
                m.ownerid = si.id;
            }
            
            for(MPM4_BASE__Milestone1_Task__c t: ts){
                t.MPM4_BASE__resource__c = siRes.id;
            }    
            
            update mts;
            update ts;
        }
        
    }
}