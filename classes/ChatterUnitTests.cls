@isTest
public with sharing class ChatterUnitTests {
    public static testMethod void testChatterActivity() {
        Task t = new Task();
        t.Subject = 'This is a test activity for chatter';
        t.ActivityDate = System.today();
        t.Status = 'In Progress';
        t.Description = 'Hello, this will be chattered';
        insert t;
    }
}