@isTest
public class MPM4_Time_Custom_Trigger_Behavior {
    // GIVEN Multiple MPM Project Resource junction being inserted with filled out contact and user lookups
    // WHEN Inserting those records
    // THEN Create new MPM4_BASE__Milestone1_Resource__c records if no existing records exist
    public static testMethod void shouldCreateMissingResourceRecordsOnJunctionRecordCreation(){
        MPM4_BASE__Milestone1_Settings__c setting = MPM4_BASE__Milestone1_Settings__c.getOrgDefaults();
        setting.MPM4_BASE__disable_triggers__c = true;
        upsert setting;
        
        MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c(name='Test Proj');
        insert proj;
        
        
        Contact c1 = new Contact(lastname = 'c1');
        Contact c2 = new Contact(lastname = 'c2');     
        insert new List<contact>{c1,c2};
            
        setting.MPM4_BASE__disable_triggers__c = false;
        upsert setting;
        
        List<MPM_Project_Resource__c> toCreate = new List<MPM_Project_Resource__c>();
        
        toCreate.add(new MPM_Project_Resource__c( project__c = proj.id, User__c = UserInfo.getUserId() ) );
        toCreate.add(new MPM_Project_Resource__c( project__c = proj.id, Contact__c = c1.id ) );
        toCreate.add(new MPM_Project_Resource__c( project__c = proj.id, Contact__c = c2.id ) );
        
        
        Map<Id, MPM4_BASE__Milestone1_Resource__c> existingRes = new Map<Id, MPM4_BASE__Milestone1_Resource__c>([Select id from MPM4_BASE__Milestone1_Resource__c]);
        Test.startTest();
        insert toCreate;
        
        List<MPM_Project_Resource__c> toCreate2 = new List<MPM_Project_Resource__c>();
        
        toCreate2.add(new MPM_Project_Resource__c( project__c = proj.id, User__c = UserInfo.getUserId() ) );
        toCreate2.add(new MPM_Project_Resource__c( project__c = proj.id, Contact__c = c1.id ) );
        toCreate2.add(new MPM_Project_Resource__c( project__c = proj.id, Contact__c = c2.id ) );
        insert toCreate2;
        
        Test.stopTest();

        List<MPM4_BASE__Milestone1_Resource__c> newRes = [Select id from MPM4_BASE__Milestone1_Resource__c where id not in :existingRes.keySet()]; 
        System.assert(newRes.size() == 3);
        
        for(MPM_Project_Resource__c junction : [Select id, resource__c, user__c, contact__c, resource__r.MPM4_BASE__user__c, resource__r.MPM4_BASE__contact__c from MPM_Project_Resource__c]){
            System.assert(junction.resource__c != null);
            System.assert(junction.resource__r.MPM4_BASE__user__c == junction.user__c);
            System.assert(junction.resource__r.MPM4_BASE__contact__c == junction.contact__c);
        }
        
        System.assertEquals(6, [Select count() from MPM_Project_Resource__c]);
    }
    
    // GIVEN A Time record with incurred_by__c 
    // WHEN Inserting or updating the time record
    // THEN Find any available resource records of the user and assign to incurred_by_resource__c
    public static testMethod void shouldPopulateResourceBasedOnIncurredByUserID(){
        MPM4_BASE__Milestone1_Settings__c setting = MPM4_BASE__Milestone1_Settings__c.getOrgDefaults();
        setting.MPM4_BASE__disable_triggers__c = false;
        upsert setting;
        
        ID uid = userInfo.getUserID();
        MPM4_BASE__Milestone1_Resource__c myres = new MPM4_BASE__Milestone1_Resource__c(MPM4_BASE__User__c =uid); 
        insert myres; 
        
        MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c(name='Test Proj');
        insert proj;
        
        MPM4_BASE__Milestone1_Milestone__c mstone = new MPM4_BASE__Milestone1_Milestone__c(name='Test Mstone', MPM4_BASE__Project__c = proj.id);
        insert mstone;
        
        MPM4_BASE__Milestone1_Task__c mt = new MPM4_BASE__Milestone1_Task__c(name='Test Task', MPM4_BASE__project_milestone__c = mstone.id);
        insert mt;
        
        MPM4_BASE__Milestone1_Time__c t = new MPM4_BASE__Milestone1_Time__c(MPM4_BASE__project_task__c =  mt.id, MPM4_BASE__incurred_by__c = uid);
        insert t;
        
        t = [Select MPM4_BASE__Incurred_By_Resource__r.MPM4_BASE__User__c from MPM4_BASE__Milestone1_Time__c where id = :t.id];
        System.assertEquals(uid, t.MPM4_BASE__Incurred_By_Resource__r.MPM4_BASE__User__c);
        
        t.MPM4_BASE__Incurred_By_Resource__c = null;
        update t;
        
        t = [Select MPM4_BASE__Incurred_By_Resource__r.MPM4_BASE__User__c from MPM4_BASE__Milestone1_Time__c where id = :t.id];
        System.assertEquals(uid, t.MPM4_BASE__Incurred_By_Resource__r.MPM4_BASE__User__c); 
    }
}