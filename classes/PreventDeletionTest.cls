@isTest
public class PreventDeletionTest {
    static String test_name = 'Test 123456790';
    
    @testSetup static void setup() {
        MPM4_BASE__Milestone1_Project__c project = new MPM4_BASE__Milestone1_Project__c(name=test_name);
        insert project;
        
        MPM4_BASE__Milestone1_Milestone__c milestone = new MPM4_BASE__Milestone1_Milestone__c(name=test_name,
                                                                                              MPM4_BASE__Project__c=project.id);
        insert milestone;
        
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User user = new User(Alias = 'standt',
                          Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8',
                          LastName='Testing',
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US',
                          ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='ImagineTestUser' + Datetime.now().getTime() + '@test.com');
        insert user;
                
        Contact contact = new Contact(LastName='Testerson');
        insert contact;
                
        MPM4_BASE__Milestone1_Resource__c resource = new MPM4_BASE__Milestone1_Resource__c (Name='Testy Testerson',
                                                                                            MPM4_BASE__User__c=user.id);
        insert resource;
        
        System.runAs(user) {
            MPM4_BASE__Milestone1_Task__c task = new MPM4_BASE__Milestone1_Task__c (name=test_name,
                                                                                    MPM4_BASE__Project_Lookup__c=project.id,
                                                                                    MPM4_BASE__Project_Milestone__c=milestone.id,
                                                                                    MPM4_BASE__Resource__c=resource.id
                                                                                   );
            insert task;
            
            MPM4_BASE__Milestone1_Time__c time_entry = new MPM4_BASE__Milestone1_Time__c(MPM4_BASE__Hours__c=2,
                                                                                         MPM4_BASE__Project_Task__c=task.id,
                                                                                         MPM4_BASE__Incurred_By_Resource__c=resource.id);
            insert time_entry;
        }
    }
    
	static testMethod void CheckTaskDeletion() {
        MPM4_BASE__Milestone1_Task__c task = [SELECT name, isDeleted
                                              FROM MPM4_BASE__Milestone1_Task__c
                                              WHERE name = :test_name
                                              LIMIT 1
                                             ];
        
        System.assert(!task.IsDeleted, 'Task shouldn\'t be deleted. ');
        
        try {
            delete task;
        } catch (DmlException e) {
            System.assert(true, e.getMessage());
        }
        
        List<MPM4_BASE__Milestone1_Time__c> times = [SELECT MPM4_BASE__Project_Task__c
                                                     FROM MPM4_BASE__Milestone1_Time__c
                                                     WHERE MPM4_BASE__Project_Task__c = :task.id];
        
        delete times;
        
        delete task;
        
        List<MPM4_BASE__Milestone1_Task__c> tasks = [SELECT name, isDeleted
                                                    FROM MPM4_BASE__Milestone1_Task__c
                                                    WHERE name = :test_name
                                                   ];
        
        System.assert(tasks.size() == 0, 'Task should be deleted!');
    }
    
    static testMethod void CheckMilestoneDeletion() {
        MPM4_BASE__Milestone1_Milestone__c milestone = [SELECT name, isDeleted
                                                        FROM MPM4_BASE__Milestone1_Milestone__c
                                                        WHERE name = :test_name
                                                        LIMIT 1
                                                       ];
        
        System.assert(!milestone.IsDeleted, 'Milestone shouldn\'t be deleted.');
        
        try {
            delete milestone;
        } catch (DmlException e) {
            System.assert(true, e.getMessage());
        }
        
        MPM4_BASE__Milestone1_Task__c task = [SELECT name
                                              FROM MPM4_BASE__Milestone1_Task__c
                                              WHERE MPM4_BASE__Project_Milestone__c = :milestone.id
                                              LIMIT 1
                                             ];
        
        List<MPM4_BASE__Milestone1_Time__c> times = [SELECT MPM4_BASE__Project_Task__c
                                                     FROM MPM4_BASE__Milestone1_Time__c
                                                     WHERE MPM4_BASE__Project_Task__c = :task.id];
        
        delete times;
        
        delete milestone;
        
        List<MPM4_BASE__Milestone1_Milestone__c> milestones = [SELECT name, isDeleted
                                                               FROM MPM4_BASE__Milestone1_Milestone__c
                                                               WHERE name = :test_name
                                                              ];
        
        System.assert(milestones.size() == 0, 'Milestones should be deleted! But found ' + milestones.size());
    }

    static testMethod void CheckProjectDeletion() {
        // Find project
        MPM4_BASE__Milestone1_Project__c project = [SELECT name, IsDeleted, MPM4_BASE__Total_Hours_Incurred__c
                                                    FROM MPM4_BASE__Milestone1_Project__c
                                                    WHERE name = :test_name
                                                    LIMIT 1
                                                   ];
        
        // Assert Project isn't deleted
        System.assert(!project.IsDeleted, 'Project shouldn\'t be deleted. ');
        
        // Remove time on Project
        MPM4_BASE__Milestone1_Task__c task = [SELECT name, isDeleted
                                              FROM MPM4_BASE__Milestone1_Task__c
                                              WHERE name = :test_name
                                              LIMIT 1
                                             ];
        
        List<MPM4_BASE__Milestone1_Time__c> times = [SELECT MPM4_BASE__Project_Task__c, Name, MPM4_BASE__Hours__c
                                                     FROM MPM4_BASE__Milestone1_Time__c
                                                     WHERE MPM4_BASE__Project_Task__c = :task.id];
        delete times;
        update project;
        
        //update the project object in the test method so we can pass it into the check project delete ~ line 166
        project = [SELECT name, IsDeleted, MPM4_BASE__Total_Hours_Incurred__c
                                                    FROM MPM4_BASE__Milestone1_Project__c
                                                    WHERE name = :test_name
                                                    LIMIT 1];
        
        
        //Test deletion of Project without Time
        test.startTest();
        	Test.setCurrentPage(Page.DeleteProject);
        	ApexPages.StandardController sc = new ApexPages.StandardController(project);
            CheckProjectDelete testProject = new CheckProjectDelete(sc);
        	
            try 
            {
                testProject.CheckProjectDelete();
            } 
            catch (DmlException e) 
            {
                System.debug(e.getMessage());
            }
    
            List<MPM4_BASE__Milestone1_Project__c> projects = [SELECT name
                                                               FROM MPM4_BASE__Milestone1_Project__c
                                                               WHERE name = :test_name];

            System.assert(projects.size() == 0, 'Projects should be deleted!');
        test.stopTest();
        
    }
}