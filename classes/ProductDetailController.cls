public without sharing class ProductDetailController {
 public Product2 oProduct {get;set;}
 
 public Boolean isUK_Dom {get;set;}
 public Boolean isUS_Domestic {get;set;}
 public Boolean isUS_Int_l_EA {get;set;}
 public Boolean isMESA_US {get;set;}
 public Boolean isAsia_US {get;set;}
 public Boolean isCan_Dom {get;set;}
 public Boolean isEuro {get;set;}
 public Boolean isChinaDom {get;set;}
 public Boolean isAusDom {get;set;}
 public Boolean isCala {get;set;}
 
 public String message {get;set;}
 public String detailedMessage {get;set;}
 
 public ProductDetailController(ApexPages.StandardController stdController){
   message = '<div class="cMessage">Unauthorized Access</div>';
   
   detailedMessage = '<div class="cDetailedMessage">';
   detailedMessage += 'You do not have access to this product. Please reach out to';
  detailedMessage += '<a class="cDetailedMessage" href="mailto:support@ic.com" target="_top">support@ic.com</a>';
  detailedMessage += ' for further questions/concerns<div>';
  
  list<String> lineOfBusiness;
  
  User usr = [Select Id,AccountId From User Where Id =: userInfo.getUserId() limit 1 ];
  Account acc = null;
  
  isUK_Dom = true;
  isUS_Domestic = true;
  isUS_Int_l_EA = true;
  isMESA_US = true;
  isAsia_US = true;
  isCan_Dom = true;
  isEuro = true;
  isChinaDom = true;
  isAusDom = true;
  isCala = true;
  
  if(usr.AccountId != null || test.isRunningTest()){
  if(test.isRunningTest())
  acc = [Select Id,Product_Family__c,Partner_Product_Prices__c,Opportunity_Line_of_Business__c  From Account where Partner_Product_Prices__c != null  limit 1];
  else
   acc = [Select Id,Product_Family__c,Partner_Product_Prices__c,Opportunity_Line_of_Business__c  From Account Where Id =: usr.AccountId limit 1];
   if(acc != null){
    if(acc.Opportunity_Line_of_Business__c != null){
     lineOfBusiness = acc.Opportunity_Line_of_Business__c.split(';');
    }
    else{
     lineOfBusiness = new list<String>();
    }
    
    isUK_Dom = false;
    isUS_Domestic = false;
    isUS_Int_l_EA = false;
    isMESA_US = false;
    isAsia_US = false;
    isCan_Dom = false;
    isEuro = false;
    isChinaDom = false;
    isAusDom = false;
    isCala = false;
    
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
      else if(s == 'CALA'){
       isCala = true;
      }
     }
    }
   }
  }
  
  Id prdId = ((Product2)stdController.getRecord()).id;
  String sSoql = '';
  String sCriteria;
  String filterCriteria = '';
  String sFields = '';
  
  sFields += ' Id,Name,Asia_US__c,Business_Unit_Pillar__c,Can_Dom__c,Euro__c,Family,MESA_US__c, ';
  sFields += ' Opportunity_Product_Group__c,Product_Family__c, ';
  sFields += ' ProductCode,UK_Dom__c,US_Domestic__c,US_Int_l_EA__c, ' ;
  sFields += ' China_Domestic_US__c, Australia_Domestic__c, CALA_List_Price__c, Channel_Product_Family__c,Description, ';
  sFields += ' IsActive,Quotable__c,Item_Class_Desc__c,Opportunity_Line_of_Business__c, Product_Line__c  ';
  
  sSoql += 'Select ' + sFields;
  sSoql += 'From Product2 ';
  
  filterCriteria = ' Where Id = :prdId ';
  
  if(acc != null){
   filterCriteria += ' And Product_Line__c In :lineOfBusiness ';
  }
  
  sSoql += filterCriteria;
  sSoql += ' limit 1 ';
  
  System.debug('Suraj --> sSoql:'+sSoql);
  
  oProduct = null;
  
  
  for(Product2 prd :database.query(sSoql)){
   oProduct = prd;
  }
 }
}