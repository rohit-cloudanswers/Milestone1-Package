/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CustomLoginController {

    public PageReference forgotPass() {
        return page.ForgotPassword;
    }

    global String username{get;set;}
    global String password{get;set;}
    global CustomLoginController () {}
    global PageReference forwardToCustomAuthPage() {
        return new PageReference( '/CustomLogin');
    }
    global PageReference login() {
        try{
            system.debug('TESTING RAJ111');
            pagereference pg = Site.login(username, password, null);
            system.debug('&&&&&&&'+pg);
            if(pg == null){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info,'Invalid username or password.'));
                return null;
            }
            return pg;
        } 
        catch(exception e){
             system.debug('*****'+e.getMessage());
             return null;
        }
        return null;
    }

}