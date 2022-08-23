@isTest
public class TestCustomerSatisfactionSurveyTrigger {
    static testmethod void TestCustomerSatisfactionSurveyTrigger()
    {
        RecordType MSRecType = [select Id from RecordType where SobjectType = 'Milestone1_Milestone__c' and Name = 'Standard Milestone'];

        Milestone1_Project__c testProject = new Milestone1_Project__c();
        testProject.Name = 'Test Project1';
        Insert testProject;
        
        Contact Con= new Contact();
        Con.LastName = 'My';
        Con.FirstName = 'Name';        
        Con.Email = 'MyName@email.com';
        Insert Con;
        
        Project_Contact__c testContact = new Project_Contact__c();
        testContact.Contact_Type__c = 'Customer Satisfaction Contact';
        testContact.Contact__c = Con.Id;
        testContact.Project2__c = testProject.Id;
        Insert testContact;
        
        Milestone1_Milestone__c testMilestone = new Milestone1_Milestone__c();
        testMilestone.Project__c = testProject.id;
        testMilestone.RecordTypeId = MSRecType.Id;
        testMilestone.Name = 'Test Milestone';
        
        testMilestone.CHK_Customer_Satisfaction_Contact_Info__c = True;
        testMilestone.CHK_Customer_satisfaction_survey_del__c = Date.today();
        
        insert testMilestone;
    }
}