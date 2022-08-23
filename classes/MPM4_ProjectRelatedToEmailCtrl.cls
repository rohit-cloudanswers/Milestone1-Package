public class MPM4_ProjectRelatedToEmailCtrl {
 
    @AuraEnabled
    public static ProjectsWrapper findMPM4Projects(List<String> emails, Boolean isLimited) {
        
        Set<ID> accountIds = new Set<ID>(); 
        for(Contact c : [SELECT Name, AccountID FROM Contact WHERE Contact.Email IN :emails]){
            accountIds.add(c.AccountID);
        }
        
        Set<ID> projectIds = new Set<ID>();  
        for(MPM_Project_Resource__c mpr : [SELECT Id, Phone__c, Project__c, Resource__c, Email__c, Type__c FROM MPM_Project_Resource__c where Email__c IN :emails]){
            projectIds.add(mpr.project__c);
        }
        
        
        List<Schema.FieldSetMember> fieldset = Schema.SObjectType.MPM4_BASE__Milestone1_Project__c.fieldSets.MPM4_Project_Outlook_Component_Fields.getFields();
        
        Set<String> fieldsToQuery = new Set<String>{'Name', 'Id'};
        String query = 'SELECT ';
        
        for(Schema.FieldSetMember f : fieldset){
            fieldsToQuery.add(f.getFieldPath());
            
        } 
        
        for(String field : fieldsToQuery){
            query += 'FORMAT(' + field + '), ';
        } 
        query = query.removeEnd(', ');
        
        if(isLimited){
            query += ' FROM MPM4_BASE__Milestone1_Project__c WHERE MPM4_BASE__Account__c in :accountIds OR Id in :projectIds  ORDER BY lastmodifieddate DESC LIMIT 5';    
        }else{
             query += ' FROM MPM4_BASE__Milestone1_Project__c WHERE MPM4_BASE__Account__c in :accountIds OR Id in :projectIds  ORDER BY lastmodifieddate DESC';    
        }
        
        
        AggregateResult[] groupedResults = [SELECT count(id) total FROM MPM4_BASE__Milestone1_Project__c WHERE MPM4_BASE__Account__c in :accountIds OR Id in :projectIds];
        Integer count = Integer.valueOf(groupedResults[0].get('total'));
        
        ProjectsWrapper pw = new ProjectsWrapper();
        pw.count = count;
        pw.projects = Database.query(query);
        return pw;
    }
    
    @AuraEnabled
    public static ListView getListViews() {
        return [SELECT Id, Name FROM ListView WHERE SobjectType = 'MPM4_BASE__Milestone1_Project__c' and name='All' LIMIT 1];
    }
    @AuraEnabled
    public static string getFieldsetFieldNames() {
        List<fieldNamePair> names = new List<fieldNamePair>();
 
        List<Schema.FieldSetMember> fieldset =  Schema.SObjectType.MPM4_BASE__Milestone1_Project__c.fieldSets.MPM4_Project_Outlook_Component_Fields.getFields();
        
        for(Schema.FieldSetMember f : fieldset){ 
            names.add(new fieldNamePair(f));
        } 
        return JSON.serialize(names);
    }   
    
    private class fieldNamePair{
      String label = '';
      String apiname = '';
      public fieldNamePair(Schema.FieldSetMember fs){
        label = fs.getLabel();
        apiname = fs.getFieldPath();
 
      }
    }

    public class ProjectsWrapper{
        @AuraEnabled
        public List<MPM4_BASE__Milestone1_Project__c> projects{get;set;}

        @AuraEnabled
        public Integer count {get;set;}
        
    }
}