/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CustomLandingController {
    public User usr {get;set;}
    public Account acc {get;set;}
    public boolean displayPopup {get;set;}
    public boolean evrender {get;set;}
    public String cPage {get; set;}
    public String pageparam {get; set;}
    
    // Code we will invoke on page load.
    public PageReference forwardToCustomAuthPage() {
        if(UserInfo.getUserType() == 'Guest'){
            return new PageReference('/customLogin');
        } else {
            return null;
        }    
    }
    // Code for custom login page - VOLO USa
    public PageReference forwardToCustomAuthPage2() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return new PageReference(Site.getPrefix() + '/customLogin?startURL=' + EncodingUtil.urlEncode(startURL, 'UTF-8'));
    }    
    public CustomLandingController() {
        acc = null;
        usr = [Select Id,AccountId From User Where Id =: userInfo.getUserId() limit 1 ];
        
        if(usr.AccountId != null){
            acc = [Select Id From Account Where Id =: usr.AccountId limit 1];
        }            
        pageparam = ApexPages.currentPage().getParameters().get('what'); 
    }
    public void showPopup() {  
        cPage = Apexpages.currentPage().getParameters().get('rPgName');    
        displayPopup = true;  
        evrender = true;    
    }
    public PageReference closePopup() {
        displayPopup = false;
        evrender=false;
       PageReference pr = new PageReference (cPage);
       pr.setRedirect(true);
       return pr;        
    }
    
}