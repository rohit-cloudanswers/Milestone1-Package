public without sharing class ProductViewerController { 
 public String dblQuote {get;set;}
 public String comma {get;set;}
 public String newLine {get;set;}
 
 public list<Id> prdSearchResults {get;set;}
 public list<Id> prdCurrentRecordSet {get;set;}
 public Paginator prdPaginator {get;set;}
  
 public list<Product2> lstProduct {get;set;}
 public User usr {get;set;}
 public Account acc {get;set;}
 
 public Boolean isUK_Dom {get;set;}
 public Boolean isUS_Domestic {get;set;}
 public Boolean isUS_Int_l_EA {get;set;}
 public Boolean isMESA_US {get;set;}
 public Boolean isAsia_US {get;set;}
 public Boolean isCan_Dom {get;set;}
 public Boolean isEuro {get;set;}
 public Boolean isChinaDom {get;set;}
 public Boolean isAusDom {get;set;}
 public Boolean isCALA {get; set;}
 
 public String sProductName {get;set;}
 public String sProductName_Operator {get;set;}
 
 public String sProductFamily {get;set;}
 public String sProductFamily_Operator {get;set;}

 public String sChannelProductFamily {get;set;}
 public String sChannelProductFamily_Operator {get;set;} 
 
 public String sProductCode {get;set;}
 public String sProductCode_Operator {get;set;}
 
 public String sOpportunityProductGroup {get;set;}
 public String sOpportunityProductGroup_Operator {get;set;}
 
 public String sBusinessUnitPillar {get;set;}
 public String sBusinessUnitPillar_Operator {get;set;}
 
 public list<String> lineOfBusiness {get;set;}
 public String exportCSVFileName {get;set;}
 public String exportPDFFileName {get;set;}
 
 public String pageType {get;set;}
 
 private String sFields = '';
 
 public ProductViewerController(){
  dblQuote= '"';
  comma = ',';
  newLine = '\n';
  
  sFields += ' Id,Name,Asia_US__c,product2.Pillar__c,Can_Dom__c,Euro__c,Family,MESA_US__c, ';
  sFields += ' Product_Group__c,Product_Family__c, ';
  sFields += ' ProductCode,Part_No__c,UK_Dom__c,US_Domestic__c,US_Int_l_EA__c, China_Domestic_US__c, Australia_Domestic__c, CALA_List_Price__c, product_line__c,Description  ';
  sFields += ' ,Product_Weight__c, Product_Length__c, Dimensions__c, Unit_of_Measure__c, Product_Width__c, Product_Height__c, Unit_Measure_Weight__c, Unit_Measure_Dimension__c ';
  // TODO: move the above fields into a fieldset so it can be modified with point and click
  
  exportCSVFileName = 'ProductsCSVExport_' + system.now().format('MM-dd-yyyy_hh-mm');
  exportPDFFileName = 'ProductsPDFExport_' + system.now().format('MM-dd-yyyy_hh-mm');
  
  acc = null;
  sProductName = '';
  pageType = 'apex';
  
  lstProduct = new List<Product2>();
  prdSearchResults = new List<Id>();
  prdCurrentRecordSet = new List<Id>();
  prdPaginator = new Paginator();
  prdPaginator.resultsPerPage = 50;
  prdPaginator.searchResults = (list<Id>)prdSearchResults;
  prdPaginator.currentRecordSet = (list<Id>)prdCurrentRecordSet;
  
  usr = [Select Id,AccountId From User Where Id =: userInfo.getUserId() limit 1 ];
  
  if(usr.AccountId != null || test.isRunningTest()){
    pageType = 'partners';
   if(test.isRunningTest())
    acc = [Select Id,Product_Family__c,Partner_Product_Prices__c,Opportunity_Line_of_Business__c  From Account where Partner_Product_Prices__c != null limit 1];
    else
   acc = [Select Id,Product_Family__c,Partner_Product_Prices__c,Opportunity_Line_of_Business__c  From Account Where Id =: usr.AccountId limit 1];
   System.debug('Suraj -->acc:' +acc);
   if(acc.Opportunity_Line_of_Business__c != null){
    lineOfBusiness = acc.Opportunity_Line_of_Business__c.split(';');
   }
   else{
    lineOfBusiness = new list<String>();
   }
  }
  
  searchProducts();
 }
 
 public void removeFilters(){
   sProductName = '';
   sProductName_Operator = '';
   sProductFamily = '';
   sProductFamily_Operator = '';
   sProductCode = '';
   sProductCode_Operator = '';
   sOpportunityProductGroup = '';
   sOpportunityProductGroup_Operator = '';
   sChannelProductFamily = '';
   sChannelProductFamily_Operator = '';
   sBusinessUnitPillar = '';
   sBusinessUnitPillar_Operator = '';
   searchProducts();
 }
 
 public list<Product2> getExportData(){
  list<Id> lstTmp = prdSearchResults;
  String sSoql = 'Select ' + sFields;
  sSoql += ' From Product2 ';
  sSoql += ' Where Id in: lstTmp order by Product_Line__c, ProductCode ';
  return database.query(sSoql);
 }
  
 public PageReference exportCSV(){
  //PageReference prProductViewer_CSV = Page.ProductViewer_CSV;
  PageReference prProductViewer_CSV = Page.ProductViewer_EXCEL;
  
  prProductViewer_CSV.setRedirect(false); 
  return prProductViewer_CSV;
  return null;
 }
 
 public PageReference exportPDF(){ 
  PageReference prProductViewer_PDF = Page.ProductViewer_PDF;
  prProductViewer_PDF.setRedirect(false);
 prProductViewer_PDF.getHeaders().put('content-disposition', 'attachemnt; filename='+exportPDFFileName);
 //prProductViewer_PDF.getContentAsPDF(); 
  return prProductViewer_PDF;
  return null;
 }
 
 public PageReference searchProducts(){
    System.debug('Suraj -->acc:' +acc);
    
  if(acc != null){
   
   isUK_Dom = false;
   isUS_Domestic = false;
   isUS_Int_l_EA = false;
   isMESA_US = false;
   isAsia_US = false;
   isCan_Dom = false;
   isEuro = false;
   isChinaDom = false;
   isAusDom = false;
   
   System.debug('Suraj -->acc.Partner_Product_Prices__c:' +acc.Partner_Product_Prices__c);
   
   if(acc.Partner_Product_Prices__c != null){
       for(String s: acc.Partner_Product_Prices__c.split(';')){
        if(s == 'UK Dom'){
         isUK_Dom = true;
         
        }
        else if(s == 'US Domestic'){
         isUS_Domestic = true;
        }
        else if(s == 'US$ Int\'l - EA'){
         isUS_Int_l_EA = true;
        }
        else if(s == 'MESA US$'){
         isMESA_US = true;
        }
        else if(s == 'Asia US$'){
         isAsia_US = true;
        }
        else if(s == 'Can Dom'){
         isCan_Dom = true;
        }
        else if(s == 'Euro'){
         isEuro = true;
        }
        else if(s == 'China Domestic US$'){
         isChinaDom = true;
        }
        else if(s == 'Australia Domestic'){
         isAusDom = true;
        }
        else if(s == 'CALA List Prices'){
         isCALA = true;
        }
       }
   }
  }
  else{
   isUK_Dom = true;
   isUS_Domestic = true;
   isUS_Int_l_EA = true;
   isMESA_US = true;
   isAsia_US = true;
   isCan_Dom = true;
   isEuro = true;
   isChinaDom = true;
   isAusDom = true; 
   isCALA = true;
  }
  
  String sSoql = '';
  String sCriteria;
  String filterCriteria = '';
    
  sSoql += 'Select Id,Product_Line__c ';
  sSoql += 'From Product2 ';
  
  if(acc != null){
   list<String> sTmp = lineOfBusiness;
   // filterCriteria = 'WHERE Opportunity_Line_of_Business__c In :sTmp ';   // Change this to marketing family Channel_Product_Family__c
   System.debug('Suraj -->sTmp:' +sTmp);
   //filterCriteria = 'WHERE Channel_Product_Family__c In :sTmp ';
      filterCriteria = 'WHERE isActive = TRUE and quotable__c = TRUE and Product_Line__c In :sTmp ';
  } else {
      filterCriteria = 'WHERE isActive = TRUE and quotable__c = TRUE ';
  }
  
  sCriteria = makeCondition('Name','STRING',sProductName_Operator,sProductName);
  System.debug('Suraj -->sCriteria:' +sCriteria);
  
  if(sCriteria != null && sCriteria != ''){
   if(filterCriteria.toUpperCase().contains('WHERE')){
    filterCriteria += ' AND ' + sCriteria;
   }
   else{
    filterCriteria += ' WHERE ' + sCriteria;
   }
  }
  
  sCriteria = makeCondition('Product_Family__c','STRING',sProductFamily_Operator,sProductFamily);
  System.debug('Suraj -->sCriteria:' +sCriteria);
  
  if(sCriteria != null && sCriteria != ''){
   if(filterCriteria.toUpperCase().contains('WHERE')){
    filterCriteria += ' AND ' + sCriteria;
   }
   else{
    filterCriteria += ' WHERE ' + sCriteria;
   }
  }
  
  sCriteria = makeCondition('ProductCode','STRING',sProductCode_Operator,sProductCode);
  System.debug('Suraj -->sCriteria:' +sCriteria);
  
  if(sCriteria != null && sCriteria != ''){
   if(filterCriteria.toUpperCase().contains('WHERE')){
    filterCriteria += ' AND ' + sCriteria;
   }
   else{
    filterCriteria += ' WHERE ' + sCriteria;
   }
  }
  
  sCriteria = makeCondition('Product_Group__c','STRING',sOpportunityProductGroup_Operator,sOpportunityProductGroup);
  System.debug('Suraj -->sCriteria:' +sCriteria);
  
  if(sCriteria != null && sCriteria != ''){
   if(filterCriteria.toUpperCase().contains('WHERE')){
    filterCriteria += ' AND ' + sCriteria;
   }
   else{
    filterCriteria += ' WHERE ' + sCriteria;
   }
  }

  sCriteria = makeCondition('Product_Line__c','STRING',sChannelProductFamily_Operator,sChannelProductFamily);
  System.debug('Suraj -->sCriteria:' +sCriteria);
  
  if(sCriteria != null && sCriteria != ''){
   if(filterCriteria.toUpperCase().contains('WHERE')){
    filterCriteria += ' AND ' + sCriteria;
   }
   else{
    filterCriteria += ' WHERE ' + sCriteria;
   }
  }
  
  sCriteria = makeCondition('product2.Pillar__c','STRING',sBusinessUnitPillar_Operator,sBusinessUnitPillar);
  System.debug('Suraj -->sCriteria:' +sCriteria);
  
  if(sCriteria != null && sCriteria != ''){
   if(filterCriteria.toUpperCase().contains('WHERE')){
    filterCriteria += ' AND ' + sCriteria;
   }
   else{
    filterCriteria += ' WHERE ' + sCriteria;
   }
  }
  
  System.debug('Suraj -->filterCriteria:' +filterCriteria);
  
  sSoql += filterCriteria;
  sSoql += ' order by Product_Line__c, ProductCode ';
  sSoql += ' limit 5001 ';
  
  System.debug('Suraj --> sSoql:'+sSoql);
  
  prdSearchResults.clear();
  
  list<Product2> result = database.query(sSoql);
  
  if(result.size()>5000){
   prdPaginator.moreThan5000 = true;
   result.remove(1000);
  }
  else{
   prdPaginator.moreThan5000 = false;
  }
  
  for(Product2 p: result){
   prdSearchResults.add(p.Id);
  }
  
  firstPage();
   
  return null;
 }
 
 private String makeCondition(String fieldName,String fieldType,String operator,String value){
  system.debug('Suraj --> fieldName: ' + fieldName );
  system.debug('Suraj --> fieldType: ' + fieldType );
  system.debug('Suraj --> operator: ' + operator );
  system.debug('Suraj --> value: ' + value );
  
  String criteria ='';
  
  if(fieldType=='STRING'){
   
   if(operator == null || operator == ''){
    operator = 'c';
   }
  
   //"c"-->contains
   if(operator=='c'){
    if(value == null){
     value = '';
    }
    criteria = fieldName + ' like \'%' + value + '%\'';
   }
   //"k"-->does not contain
   else if(operator=='k'){
    criteria = '( not ' + fieldName + ' like \'%' + value + '%\')';
   }
   //"e"-->equals
   else if(operator=='e'){
    if(value == '' || value.toLowerCase() == 'null'){
     criteria = fieldName + ' = null ';
    }
    else{
     criteria = fieldName + ' = \'' + value + '\'';
    }
   }
   //"n"-->not equal to
   else if(operator=='n'){
    if(value == '' || value.toLowerCase() == 'null'){
     criteria = fieldName + ' != null ';
    }
    else{
     criteria = fieldName + ' != \'' + value + '\'';
    }
   }
   //"s"-->starts with
   else if(operator=='s'){
    criteria = fieldName + ' like \'' + value + '%\'';
   }
   //"d"-->ends with
   else if(operator=='d'){
    criteria = fieldName + ' like \'%' + value + '\'';
   }
  }
    
  system.debug('Suraj --> criteria: ' + criteria );
  return criteria;
 }
 
 private void fetchProducts(){
  list<Id> lstTmp = prdCurrentRecordSet;
  
  lstProduct.clear();
  
  String sSoql = 'Select ' + sFields;
  sSoql += ' From Product2 ';
  sSoql += ' Where Id in: lstTmp order by Product_Line__c, ProductCode';
  system.debug('------sSoql-------'+sSoql);
  system.debug('------lstTmp-------'+lstTmp);
  lstProduct = database.query(sSoql);
 }
 
 public void nextPage(){
  prdPaginator.nextPage();
  fetchProducts();
 }

 public void prevPage(){
  prdPaginator.prevPage();
  fetchProducts();
 }

 public void firstPage(){
  prdPaginator.firstPage();
  fetchProducts();
 }

 public void lastPage(){
  prdPaginator.lastPage();
  fetchProducts();
 }

 public void goToPage(){
  prdPaginator.goToPage();
  fetchProducts();
 }
 
 //-----------------------------------
 // Inner Class for pagination
 //-----------------------------------
 public class Paginator {
  public list<Object> searchResults {get;set;}
  public list<Object> currentRecordSet {get;set;}
  public Integer resultsPerPage {get;set;}
  public Integer pageNumber {get;set;}
  
  public Boolean moreThan5000 {get;set;}
  public Integer showingFrom {get;set;}
  public Integer showingTo {get;set;}
  
  private Integer currentPageNumber;
  
  public Paginator(){
   
  }
  
  public Integer totalResults {
   get {
    return searchResults.size();
   }
   set;
  }
  
  private void reflact(){
   Integer startIndx = (currentPageNumber-1) * resultsPerPage ;
   for(Object obj:currentRecordSet){
    searchResults[startIndx] = obj;
    startIndx++;
   }
  }
  
  public void refresh(){
   reflact();
   currentRecordSet.clear();
   Integer startIndx = (pageNumber-1) * resultsPerPage + 1 ;
   Integer stopIndx = startIndx+(resultsPerPage-1);
   if(searchResults.size()<stopIndx){
    stopIndx = searchResults.size();
   }
   showingFrom = startIndx;
   showingTo = stopIndx;
   Integer indx =1;
   for(Object obj:searchResults){
    if(indx>=startIndx){
     currentRecordSet.add(obj);
     if(startIndx==stopIndx){
      break;
     }
     startIndx++;
    }
    indx++;
   }
  }
  
  private void moveNext(){
   reflact();
   currentRecordSet.clear();
   Integer startIndx = pageNumber * resultsPerPage + 1 ;
   Integer stopIndx = startIndx+(resultsPerPage-1);
   if(searchResults.size()<stopIndx){
    stopIndx = searchResults.size();
   }
   showingFrom = startIndx;
   showingTo = stopIndx;
   pageNumber++;
   Integer indx =1;
   for(Object obj:searchResults){
    if(indx>=startIndx){
     currentRecordSet.add(obj);
     if(startIndx==stopIndx){
      break;
     }
     startIndx++;
    }
    indx++;
   }
  }

  private void movePrevious(){
   reflact();
   currentRecordSet.clear();
   pageNumber--;
   Integer startIndx = (pageNumber-1) * resultsPerPage + 1 ;
   Integer stopIndx = startIndx+(resultsPerPage-1);
   showingFrom = startIndx;
   showingTo = stopIndx;
   Integer indx =1;
   for(Object obj:searchResults){
    if(indx>=startIndx){
     currentRecordSet.add(obj);
     if(startIndx==stopIndx){
      break;
     }
     startIndx++;
    }
    indx++;
   }
  }

  private void moveFirst(){
   currentRecordSet.clear();
   Integer startIndx = 1;
   Integer stopIndx = resultsPerPage;
   
   if(searchResults.size()<stopIndx){
    stopIndx = searchResults.size();
   }
   
   showingFrom = startIndx;
   showingTo = stopIndx;
   pageNumber = 1;
   Integer indx =1;
   for(Object obj:searchResults){
    if(indx>=startIndx){
     currentRecordSet.add(obj);
     if(startIndx==stopIndx){
      break;
     }
     startIndx++;
    }
    indx++;
   }
  }

  private void moveLast(){
   reflact();
   currentRecordSet.clear();
   Integer startIndx = (totalPage-1) * resultsPerPage + 1 ;
   Integer stopIndx = searchResults.size();
   showingFrom = startIndx;
   showingTo = stopIndx;
   Integer indx =1;
   pageNumber=totalPage;
   for(Object obj:searchResults){
    if(indx>=startIndx){
     currentRecordSet.add(obj);
     if(startIndx==stopIndx){
      break;
     }
     startIndx++;
    }
    indx++;
   }
  }

  public Integer totalPage {
   get {
    integer pagecount = searchResults.size() / resultsPerPage;
    return Math.mod(searchResults.size(),resultsPerPage) > 0 ? pagecount + 1 : pagecount;
   }
   set;
  }

  public Integer currentPage{
   get {
    currentPageNumber = pageNumber;
    return pageNumber;
   }
   set;
  }
  
  public Boolean hasNextPage{
   get{
    if(currentPage < totalPage){
     return true;
    }
    else{
     return false;
    }
   }
   set;
  }

  public Boolean hasPrevPage{
   get{
    if(currentPage > 1){
     return true;
    }
    else{
     return false;
    }
   }
  }

  public Boolean hasFirstPage{
   get{return hasPrevPage;}
  }

  public Boolean hasLastPage{
   get{return hasNextPage;}
  }

  public void nextPage(){
   moveNext();
  }

  public void prevPage(){
   movePrevious();
  }

  public void firstPage(){
   moveFirst();
  }

  public void lastPage(){
   moveLast();
  }
  
  public void goToPage(){
   refresh();
  }
 }
 
}