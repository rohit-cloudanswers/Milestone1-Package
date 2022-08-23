public with sharing class OpportunityTabController {
   private integer counter=0;  //keeps track of the offset
   private integer list_size=10; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
   private String soql;
   private String soqlCount;
   public String viewName = 'All Opportunities';
    
    private Id userId = UserInfo.getUserId();   
    private String filter;
    private String filterCount;
    public String getViewName(){
        return viewName;
    }
    public void setViewName(String viewStyle){
        viewName = viewStyle;    
    } 
    
    public OpportunityTabController() {
      //set the total size in the constructor
      calculateTotalSize();
    }
    
    private void calculateTotalSize(){
        soqlCount = 'select count() from Opportunity';
         if(viewName == 'My Opportunities')
         {
            filterCount = ' where OwnerId=:userId';
         }
         else
         {
            filterCount = '';
         }
         if(filterCount != '' && filter!=null)
         {
            soqlCount = soqlCount + filterCount;
         }      
         total_size = Database.countQuery(soqlCount);
         if(total_size > 2000){
            total_size = 2000;
         }
    }

    public void viewChanged(){
        counter = 0;
        total_size = 0;
    }
  
   public Opportunity[] getOpportunities() {
      try {
         soql = 'Select Id, Name,RecordType.Name ,AccountId,Account.Name,Amount,CloseDate,StageName,OwnerId,Owner.Name,Partner_Name__r.Id,Partner_Name__r.Name FROM opportunity';
         if(viewName == 'My Opportunities')
         {
            filter = ' where OwnerId=:userId';
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
         Opportunity[] opportunities = Database.query(soql);
         if(total_size == 0){
            calculateTotalSize();
         }
         return opportunities;
      } catch (QueryException e) {
         ApexPages.addMessages(e);   
         return null;
      }
   }

    public List<SelectOption> getViews() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All Opportunities ','All Opportunities'));
        options.add(new SelectOption('My Opportunities','My Opportunities'));
        return options;
    }
    
    public PageReference openNew(){
        Id uId = Userinfo.getUserId();
        User u = [select ContactId from User where Id=:uId];
        Contact c = [select AccountId,Account.Name from Contact where Id=:u.ContactId];
        Pagereference Url = new Pagereference('/partners/006/e?retURL=%2F&ent=Quote&CF00Ni000000EriOz='+c.Account.Name+'&CF00Ni000000EriOz_lkid='+c.Account.Id);
        return Url;
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
      System.debug('TotalPages : ' + math.mod(total_size, list_size));
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
}