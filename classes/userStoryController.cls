public with sharing class userStoryController {


    public List<cUserStory> uslist2 {get; set;}

    public User_Story__c[] uslist {get;set;}
    public List<User_Story__c> getUserStories() {
           uslist2 = new List<cUserStory>();
           uslist = [select id, Name, As_A__c,  I_Want__c,  So_That__c,     Epic__c, Topic__c, Phase__c,    LOE__c, Harris_Broadcast_Priority__c,   Object_Or_Domain__c, Notes__c, Functional_Area__c, Dependencies__c, Burned__c  from User_Story__c];
           for(User_Story__c c: uslist) {
               uslist2.add(new cUserStory(c));
           }    
        return uslist;
    }   
    public List<cUserStory> getUserStories2() {
           uslist2 = new List<cUserStory>();
           uslist = [select id, Name, As_A__c,  I_Want__c,  So_That__c, Release__c,     Epic__c, Topic__c, Phase__c,    LOE__c, Harris_Broadcast_Priority__c,   Object_Or_Domain__c, Notes__c, Functional_Area__c, Dependencies__c, Burned__c  from User_Story__c];
           for(User_Story__c c: uslist) {
               uslist2.add(new cUserStory(c));
           }    
        return uslist2;
    }      
    public PageReference process() {
        try
        {
            List<User_Story__c > selectedUsts = new List<User_Story__c >(); 
            //We will cycle through our list of cContacts and will check to see if the selected property is set to true, if it is we add the Contact to the selectedContacts list
            for(cUserStory cUs: getUserStories2()) {
                if(cUs.selected == true) {
                    selectedUsts.add(cUs.ust);
                    cUs.selected = false;
                }
            }   

        // Now we have our list of selected contacts and can perform any type of logic we want, sending emails, updating a field on the Contact, etc
        
 
        for(User_Story__c con: selectedUsts) {
            system.debug('BLAHBLAH' + con.id + '--' + con.name  );
            update con;
            System.debug('Update completed: ');             
        }                
        } catch(Exception ex){}
        
        //PageReference pageRef = new PageReference('/apex/testcode1');
        //pageRef.setRedirect(true);
        //        return pageRef;   
        return null;           
    }  
    public class cUserStory {
        public User_Story__C ust {get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public cUserStory(User_Story__C u) {
            ust = u;
            selected = false;
        }
    }      
     
}