public with sharing class QuotePagenationExt {
    public List<quote> quotes{get;set;}
    public Integer pageSize = 10;
    public Integer pageNumber = 0;
    private String baseQuery = 'SELECT name, industry FROM Quote ORDER BY name';
    public final Quote aQuote { get; set; }
  public List<String> searchFields { get; private set; }

    public PageReference next(){
        pageNumber++;
        quoteQuotes();
        return null;
    }

    public PageReference previous(){
        pageNumber--;
        if (pageNumber < 0)
            return null;
        quoteQuotes();
        return null;
    }

    private void quoteQuotes()
    {
        Integer offset = pageNumber * pageSize;
        String query = baseQuery + ' LIMIT '+pageSize +' OFFSET '+ offset;
        try{
            quotes = Database.query(query);
        }
        catch(Exception e){
            ApexPages.addMessages(e);
        }
    }
}