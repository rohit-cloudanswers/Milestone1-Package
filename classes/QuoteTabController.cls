public with sharing class QuoteTabController {
   private integer counter=0;  //keeps track of the offset
   private integer list_size=20; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
   private String soql;
   private String soqlCount;
   Boolean isPartnerUser = OpportunityConvert_WS.isPartnerUser();
   public String viewName;   
            
    private Id userId = UserInfo.getUserId();   
    private String filter;
    private String filterCount = '';
    public String getViewName(){
        return viewName;
    }
    public void setViewName(String viewStyle){
        viewName = viewStyle;    
    } 
    
    public QuoteTabController() {
        if(!isPartnerUser)
        {
            viewName = 'All Quotes';
        }
        else
        {
            viewName = 'My Quotes';
        }
        calculateTotalSize();
      //set the total size in the constructor
    }

    private void calculateTotalSize(){
        soqlCount = 'select count() from Quote';
         if(viewName == 'My Quotes')
         {
            filterCount = ' where CreatedById=:userId';
         }
         else if(viewName == 'Open Quotes')
         {
            filterCount = ' where CreatedById=:userId and Status = \'Draft\'';
         }
         else
         {
            filterCount = '';
         }        
         if(filterCount != '' && filterCount!=null)
         {
            soqlCount = soqlCount + filterCount;
         }       
         total_size = Database.countQuery(soqlCount);
         if(total_size > 2000){
            total_size = 2000;
         }
    }

    private void calculateTotalSizeApprovals(){
        Map<Id,ProcessInstance> QuoteVsWorkItem = new Map<Id,ProcessInstance>();
        Map<Id,Id> ProcessVsWorkItem = new Map<Id,Id>();
         List<ProcessInstanceStep> processWork = [SELECT ActorId,Comments,CreatedById,CreatedDate,Id,OriginalActorId,ProcessInstanceId,StepNodeId,StepStatus,SystemModstamp FROM ProcessInstanceStep where ActorId=:userId]; 
         for(ProcessInstanceStep item:processWork)
         {
            ProcessVsWorkItem.put(item.ProcessInstanceId,item.Id);
         }
        List<ProcessInstance> processIns = [SELECT CompletedDate,ElapsedTimeInDays,CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,ProcessDefinitionId,Status,SystemModstamp,TargetObjectId FROM ProcessInstance where Id IN :ProcessVsWorkItem.KeySet() and Status='Approved'];
         for(ProcessInstance instance:processIns)
         {
            if(String.valueOf(instance.TargetObjectId).startsWith('0Q0'))
            {
                QuoteVsWorkItem.put(instance.TargetObjectId,instance);
            }
         }
         if(!QuoteVsWorkItem.isEmpty()) {
             soqlCount = 'select count() from Quote';
             filterCount = ' where Id IN (';
             for(Id quoteId:QuoteVsWorkItem.KeySet())
             {
                filterCount = filterCount+'\'' + quoteId+'\',';
             }
             if(filterCount != '' && filterCount!=null)
             {
                soqlCount = soqlCount + filterCount.substring(0, filterCount.length()-1) + ')';
             }      
             system.debug('printing query'+soqlCount);       
             total_size = Database.countQuery(soqlCount);
             if(total_size > 2000){
                total_size = 2000;
             }
         }
    }

    private void calculateTotalSizePendings(){
        Map<Id,Id> QuoteVsWorkItem = new Map<Id,Id>();
        Map<Id,Id> ProcessVsWorkItem = new Map<Id,Id>();
         List<ProcessInstanceWorkitem> processWork = [SELECT ActorId,CreatedById,CreatedDate,Id,IsDeleted,OriginalActorId,ProcessInstanceId,SystemModstamp FROM ProcessInstanceWorkitem where ActorId=:userId]; 
         for(ProcessInstanceWorkitem item:processWork)
         {
            ProcessVsWorkItem.put(item.ProcessInstanceId,item.Id);
         }
        List<ProcessInstance> processIns = [SELECT CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,ProcessDefinitionId,Status,SystemModstamp,TargetObjectId FROM ProcessInstance where Id IN :ProcessVsWorkItem.KeySet() and Status='Pending'];
         for(ProcessInstance instance:processIns)
         {
            if(String.valueOf(instance.TargetObjectId).startsWith('0Q0%'))
            {
                QuoteVsWorkItem.put(instance.TargetObjectId,ProcessVsWorkItem.get(instance.Id));
            }
         }
         if(!QuoteVsWorkItem.isEmpty()) {
             soqlCount = 'select count() from Quote';
             filterCount = ' where Id IN (';
             for(Id quoteId:QuoteVsWorkItem.KeySet())
             {
                filterCount = filterCount+'\'' + quoteId+'\',';
             }
             if(filterCount != '' && filterCount!=null)
             {
                soqlCount = soqlCount + filterCount.substring(0, filterCount.length()-1) + ')';
             }       
             total_size = Database.countQuery(soqlCount);
             if(total_size > 2000){
                total_size = 2000;
             }
         }
    }
    
    public void viewChanged(){
        counter = 0;
        total_size = 0;
    }
  
   public Quote[] getQuotes() {
      try {
         soql = 'Select Id, Name,NEW_Grand_Total__c , RecordType.Name ,AccountId,Account.Name,ExpirationDate,Effective__c,Partner_Name__r.Id,Partner_Name__r.Name,Status,Active__c,OpportunityId,Opportunity.Name FROM quote ';
         if(viewName == 'My Quotes')
         {
            filter = 'where CreatedById=:userId';
         }
         else if(viewName == 'Open Quotes')
         {
            filter = 'where CreatedById=:userId and Status = \'Draft\'';
         }         
         else
         {
            filter = '';
         } 
         if(filter != '' && filter!=null)
         {
            soql = soql+filter;
         }
         if(counter > 2000){
            counter = 2000;
         }
         soql = soql+' order by LastModifiedDate desc limit :list_size offset :counter';
         Quote[] quotes = Database.query(soql);
         if(total_size == 0){
            calculateTotalSize();
         } 
         return quotes;
      } catch (QueryException e) {
         ApexPages.addMessages(e);   
         return null;
      }
   }

   public QuoteVsInstanceWrapper[] getQuoteApprovals() {
      try {
        Map<Id,ProcessInstance> QuoteVsWorkItem = new Map<Id,ProcessInstance>();
        Map<Id,Id> ProcessVsWorkItem = new Map<Id,Id>();
         List<ProcessInstanceStep> processWork = [SELECT ActorId,Comments,CreatedById,CreatedDate,Id,OriginalActorId,ProcessInstanceId,StepNodeId,StepStatus,SystemModstamp FROM ProcessInstanceStep where ActorId=:userId]; 
         for(ProcessInstanceStep item:processWork)
         {
            ProcessVsWorkItem.put(item.ProcessInstanceId,item.Id);
         }
        List<ProcessInstance> processIns = [SELECT CompletedDate,ElapsedTimeInDays,CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,ProcessDefinitionId,Status,SystemModstamp,TargetObjectId FROM ProcessInstance where Id IN :ProcessVsWorkItem.KeySet() and Status='Approved'];
         for(ProcessInstance instance:processIns)
         {
            if(String.valueOf(instance.TargetObjectId).startsWith('0Q0'))
            {
                QuoteVsWorkItem.put(instance.TargetObjectId,instance);
            }
         }
         // Query all the Quotes 
         // Loop through Quotes and create Wrapper object which has Quote and the corresponding workitem 
         List<QuoteVsInstanceWrapper> wrapperList = new List<QuoteVsInstanceWrapper>();             
         if(!QuoteVsWorkItem.isEmpty()) {
             soql = 'Select Id, Name,NEW_Grand_Total__c , RecordType.Name ,AccountId,Account.Name,ExpirationDate,Effective__c,Partner_Name__r.Id,Partner_Name__r.Name,Status,Active__c,OpportunityId,Opportunity.Name FROM quote ';         
             filter = 'where Id IN (';
             for(Id quoteId:QuoteVsWorkItem.KeySet())
             {
                filter = filter+'\'' + quoteId+'\',';
             }
             if(filter != '' && filter!=null)
             {
                soql = soql + filter.substring(0, filter.length()-1) + ')';
             }
             if(counter > 2000){
                counter = 2000;
             }
             soql = soql+' order by LastModifiedDate desc limit :list_size offset :counter';
             System.debug('Query 12345:' + soql);
             Quote[] quotes = Database.query(soql);
             for(Quote quoteRecord:quotes)
             {
                QuoteVsInstanceWrapper wrapper = new QuoteVsInstanceWrapper(quoteRecord,QuoteVsWorkItem.get(quoteRecord.Id));
                wrapperList.add(wrapper);   
             }
             if(total_size == 0){
                calculateTotalSizeApprovals();
             }
         }   
         return wrapperList;
      } catch (QueryException e) {
         ApexPages.addMessages(e);   
         return null;
      }
   }

   public QuoteVsWorkItemWrapper[] getQuotePendings() {
      try {
        Map<Id,Id> QuoteVsWorkItem = new Map<Id,Id>();
        Map<Id,Id> ProcessVsWorkItem = new Map<Id,Id>();
         List<ProcessInstanceWorkitem> processWork = [SELECT ActorId,CreatedById,CreatedDate,Id,IsDeleted,OriginalActorId,ProcessInstanceId,SystemModstamp FROM ProcessInstanceWorkitem where ActorId=:userId]; 
         for(ProcessInstanceWorkitem item:processWork)
         {
            ProcessVsWorkItem.put(item.ProcessInstanceId,item.Id);
         }
        List<ProcessInstance> processIns = [SELECT CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,ProcessDefinitionId,Status,SystemModstamp,TargetObjectId FROM ProcessInstance where Id IN :ProcessVsWorkItem.KeySet() and Status='Pending'];
         for(ProcessInstance instance:processIns)
         {
            if(String.valueOf(instance.TargetObjectId).startsWith('0Q0'))
            {
                QuoteVsWorkItem.put(instance.TargetObjectId,ProcessVsWorkItem.get(instance.Id));
            }
         }
         // Query all the Quotes 
         // Loop through Quotes and create Wrapper object which has Quote and the corresponding workitem 
         List<QuoteVsWorkItemWrapper> wrapperList = new List<QuoteVsWorkItemWrapper>();
         if(!QuoteVsWorkItem.isEmpty()) {
             soql = 'Select Id, Name,NEW_Grand_Total__c , RecordType.Name ,AccountId,Account.Name,ExpirationDate,Effective__c,Partner_Name__r.Id,Partner_Name__r.Name,Status,Active__c,OpportunityId,Opportunity.Name FROM quote ';         
             filter = 'where Id IN (';
             for(Id quoteId:QuoteVsWorkItem.KeySet())
             {
                filter = filter+'\'' + quoteId+'\',';
             }
             if(filter != '' && filter!=null)
             {
                soql = soql + filter.substring(0, filter.length()-1) + ')';
             }
             if(counter > 2000){
                counter = 2000;
             }
             soql = soql+' order by LastModifiedDate desc limit :list_size offset :counter';
             System.debug('Query :' + soql);
             Quote[] quotes = Database.query(soql);
             for(Quote quoteRecord:quotes)
             {
                QuoteVsWorkItemWrapper wrapper = new QuoteVsWorkItemWrapper(quoteRecord,QuoteVsWorkItem.get(quoteRecord.Id));
                wrapperList.add(wrapper);   
             }
         }
         if(total_size == 0){
            calculateTotalSizePendings();
         } 
         return wrapperList;
      } catch (QueryException e) {
         ApexPages.addMessages(e);   
         return null;
      }
   }

    public class QuoteVsWorkItemWrapper {
      public Quote quoteRecord{get;set;}
      public Id workItemId{get;set;}
      public QuoteVsWorkItemWrapper(Quote quoteRecord, Id workItemId){
        this.quoteRecord = quoteRecord;
        this.workItemId = workItemId;
      }
    }

    public class QuoteVsInstanceWrapper {
      public Quote quoteRecord{get;set;}
      public ProcessInstance workItemId{get;set;}
      public QuoteVsInstanceWrapper(Quote quoteRecord, ProcessInstance workItemId){
        this.quoteRecord = quoteRecord;
        this.workItemId = workItemId;
      }
    }

    public List<SelectOption> getViews() {
        List<SelectOption> options = new List<SelectOption>();
        if(!isPartnerUser)
        {
        options.add(new SelectOption('All Quotes','All Quotes'));
        options.add(new SelectOption('My Quotes - Pending Approvals','My Quotes - Pending Approvals'));         
        options.add(new SelectOption('My Quotes - Completed Approvals','My Quotes - Completed Approvals')); 
        }
        options.add(new SelectOption('Open Quotes','Open Quotes'));
        options.add(new SelectOption('My Quotes','My Quotes'));
        return options;
    }
 
   public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      counter += list_size;
      return null;
   }
 
   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      return null;
   }
 
   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
 
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) >= 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
}