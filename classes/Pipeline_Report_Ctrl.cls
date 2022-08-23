public class Pipeline_Report_Ctrl{

    public Pipeline_Report_Ctrl(ApexPages.StandardController controller) {

    }
    
/*
    public List<Opportunity> getOpportunityList() {
        Opportunity[] opps = [SELECT name,account.name,account.Logo_id__c,account.Account_Classification__c,amount,owner.name,CloseDate,StageName,Probability FROM Opportunity where IsClosed=false];
        return opps;
    }
    
    */
        // Variables required for Sorting.
    private String soql;
    public String classification = 'None';
    public List <Opportunity> OpportunityList1 = New List<Opportunity>();
    private String soqlsort;
    public List <Opportunity> OpportunityList2 = New List<Opportunity>();

    public String getClassification(){
        return classification;
    }
    public void setClassification(String classStyle){
        classification = classStyle;    
    }

    // List used in to display the table in VF page.
    public List<Opportunity> getOpportunityList() {
        // Passing the values of list to VF page.
        return con.getRecords();
    }

    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
                if(con == null) {
                                // String Query to have a list of cases for a respective End-user.
                                soql = 'SELECT name,account.name,account.Account_Classification__c,account.Logo_id__c,amount,owner.name,CloseDate,StageName,Probability FROM Opportunity where IsClosed=false';
                                
                                if(classification != null && classification != 'None')
                                {
                                    soql = soql + ' and account.Account_Classification__c =: classification';
                                }
                                
                                System.debug('SOQL debug 1' + soql);
                                // Passing the String array to a list with Selected field sorting.
                                OpportunityList1 = Database.query(soql + ' order by ' + sortField + ' ' + sortDir ); 

                                // setting values of List in StandardSetController.
                                con = new ApexPages.StandardSetController(OpportunityList1);

                                // sets the number of records in each page set
                                con.setPageSize(8);
                }
                return con;
            }
        set;
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

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','None'));
        options.add(new SelectOption('S25','S25'));
        options.add(new SelectOption('F350','F350'));
        options.add(new SelectOption('G2500','G2500'));

        return options;
    }
 
    public void classChanged(){
        con = null;
    }
    
   //Toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';

            // run the query again for sorting other columns
            soqlsort = 'SELECT name,account.name,account.Logo_id__c,account.Account_Classification__c,amount,owner.name,CloseDate,StageName,Probability FROM Opportunity where IsClosed=false'; 

            if(classification != 'None')
            {
                soqlsort = soqlsort + ' and account.Account_Classification__c =: classification';
            }
            
            System.debug('SOQL debug' + soqlsort);
            
            // Adding String array to a List array
            OpportunityList2 = Database.query(soqlsort + ' order by ' + sortField + ' ' + sortDir ); 

            // Adding Caselist to Standard Pagination controller variable
            con = new ApexPages.StandardSetController(OpportunityList2);

            // Set Page Size to 25
            con.setPageSize(8);

    }

    // the current sort direction. defaults to asc
    public String sortDir {
        // To set a Direction either in ascending order or descending order.
                                get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;}
        set;
    }

    // the current field to sort by. defaults to last name
    public String sortField {
        // To set a Field for sorting.
                                get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
        set;
    }
}