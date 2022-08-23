/**
 * VOLO Usa - CustomLandingControllerTest
 */
@IsTest global with sharing class CustomLandingControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testCustomLandingControllerTest () {
        CustomLandingController controller = new CustomLandingController();
        
        Apexpages.currentPage().getParameters().put('startURL', '/somethingsomething'); 
        Apexpages.currentPage().getParameters().put('what', '/events'); 
        Apexpages.currentPage().getParameters().put('rPgName', 'whatever'); 
        
        

        controller.forwardToCustomAuthPage();
        controller.forwardToCustomAuthPage2();   
        controller.showPopup();      
        controller.closePopup();       
    }    
}