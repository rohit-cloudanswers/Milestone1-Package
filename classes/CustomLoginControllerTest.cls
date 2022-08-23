/**
 * VOLO Usa - CustomLoginControllerTest
 */
@IsTest global with sharing class CustomLoginControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testCustomLoginControllerTest () {
        CustomLoginController controller = new CustomLoginController();
        
        
        controller.username = 'test123@123.com';
        controller.password = 'blahblah';
        controller.forgotPass();
        controller.forwardToCustomAuthPage();   
        controller.login();            
    }    
}