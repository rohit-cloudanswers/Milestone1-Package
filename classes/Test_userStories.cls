@isTest(SeeAllData=true)
public class Test_userStories{
    public static testMethod void userStoryTest() {
        try {
            User_Story__c us = new User_Story__c(Name='TestACCXy12');
            insert us;
            system.debug(us);
            
            PageReference pageref = Page.UserStory;
            Test.setCurrentPageReference(pageref);

            userStoryController con = new userStoryController(); 
            con.getUserStories(); 
            con.uslist2 = con.getUserStories2();   
            //con.selected = true; 
            /*
            List<SelectOption> listGroups=candWrap.getListGroups();
            for(con.cOpportunity cOpp: con.getOpportunities2()) {
                if(cOpp.selected == true) {
                    selectedOpptys.add(cOpp.opp);
                    cOpp.selected = false;
                }
            }   
            */           
            con.process();
        } catch(Exception e) {
               System.debug('exception occurred:' +e); 
        }
    }        
}