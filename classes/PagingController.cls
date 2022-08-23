public with sharing class PagingController {
  List<quote> quotes{get;set;}
  // instantiate the StandardSetController from a query locator
  public ApexPages.StandardSetController con {
    get {
        if(con == null) {
            con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name, NEW_Grand_Total__c , RecordType.Name ,ExpirationDate,Effective__c,Status,Active__c,Partner_Name__r.Id,Partner_Name__r.Name,AccountId,Account.Name,OpportunityId,Opportunity.Name FROM quote where lastmodifieddate >=: system.today()-90 and Status = 'Draft' LIMIT 100]));
            // sets the number of records in each page set
            con.setPageSize(5);
        }
        return con;
    }
    set;
   }
   
 // returns a list of wrapper objects for the sObjects in the current page set
 public List<quote> getQuotes() {
    quotes= [Select Id, Name,NEW_Grand_Total__c , RecordType.Name ,AccountId,Account.Name,ExpirationDate,Effective__c,Partner_Name__r.Id,Partner_Name__r.Name,Status,Active__c,OpportunityId,Opportunity.Name FROM quote where lastmodifieddate >=: system.today()-90 and Status = 'Draft' LIMIT 100];

    return quotes;
 }

 // indicates whether there are more records after the current page set.
 public Boolean hasNext {
    get {
        return con.getHasNext();
    }
    set;
 }

 // indicates whether there are more records before the current page set.
 public Boolean hasPrevious {
    get {
        return con.getHasPrevious();
    }
    set;
 }

 // returns the page number of the current page set
 public Integer pageNumber {
    get {
        return con.getPageNumber();
    }
    set;
 }

 // returns the first page of records
 public void first() {
    con.first();
 }

 // returns the last page of records
 public void last() {
    con.last();
 }

 // returns the previous page of records
 public void previous() {
    con.previous();
 }

 // returns the next page of records
 public void next() {
    con.next();
 }

 // returns the PageReference of the original page, if known, or the home page.
 public void cancel() {
    con.cancel();
 } 
}