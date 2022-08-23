@IsTest(SeeAllData=false)
private class RollupTotalHoursTest {
    
   @IsTest(SeeAllData=true)
    static void shouldRollupCaseHours() {
        RecordType serviceRecord = [
            select Id from RecordType 
            where DeveloperName = 'Service' AND SObjectType = 'Case'
        ];
        Account acc = new Account(Name='test account', Status__c='Active', Partner_Product_Prices__c='US Domestic', RecordTypeId=[SELECT Id FROM RecordType where sobjectType='Account' AND Name='Channel Partner' limit 1].Id);
        insert acc;
        Address__c add1 = new Address__c(Account__c = acc.id, Name='test Address 1', Street_Address__c ='745 test avenue', Country__c ='United States of America', City__c = 'Boston', Salesforce_Primary__c = true, State__c = 'Massachusetts', Zip_Code__c ='02144', Bill_To__c=true,Ship_To__c=true);
        insert add1;
        Contact con = new Contact(
            FirstName='John',
            LastName='Smith',
            Email='john.smith@gmail.com',
            CurrencyIsoCode='USD',
            AccountId=acc.Id
        );
        insert con;
        
        Case c = new Case(
            Subject='Test case',
            Description='This is a test case.',
            Status='New',
            RecordTypeId=serviceRecord.Id,
            AccountId=acc.Id,
            Address__c=add1.Id,
            ContactId=con.Id,
            Type='Fault',
            Urgency__c='Medium',
            Impact__c='Medium',
            Product_Line__c='Automation'
        );
        insert c;
        
        Test.startTest();
        
        c = [select Id, Total_Time_Entered__c from Case where Id =: c.Id];
        System.assert(c.Total_Time_Entered__c == null);

        List<Milestone1_Time__c> times = new List<Milestone1_Time__c>{
            new Milestone1_Time__c(
                Hours__c=1,
                Date__c=Date.today(),
                Case__c=c.Id
            ),
            new Milestone1_Time__c(
                Hours__c=1,
                Date__c=Date.today(),
                Case__c=c.Id
            ),
            new Milestone1_Time__c(
                Hours__c=1,
                Date__c=Date.today(),
                Case__c=c.Id
            ),
            new Milestone1_Time__c(
                Hours__c=1,
                Date__c=Date.today(),
                Case__c=c.Id
            ) 
        };
        insert times;

        c = [select Id, Total_Time_Entered__c from Case where Id =: c.Id];
        System.assert(c.Total_Time_Entered__c == 4);
    }

    @IsTest
    static void shouldRollupHours() {
        Milestone1_Project__c project = new Milestone1_Project__c(
            Name='Test Project'
        );
        insert project;
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(
            Name='Test Milestone',
            Project__c=project.Id
        );
        insert milestone;
        Milestone1_Task__c ts1 = new Milestone1_Task__c(
            Name='Test Task 1',
            Project_Milestone__c=milestone.Id
        );
        insert ts1;
        Milestone1_Task__c ts2 = new Milestone1_Task__c(
            Name='Test Task 2',
            Project_Milestone__c=milestone.Id
        );
        insert ts2;
        List<Milestone1_Time__c> times = new List<Milestone1_Time__c>{
            new Milestone1_Time__c(
                Hours__c=1,
                Date__c=Date.today(),
                Project_Task2__c=ts1.Id
            ),
            new Milestone1_Time__c(
                Hours__c=1,
                Date__c=Date.today(),
                Project_Task2__c=ts1.Id
            ),
            new Milestone1_Time__c(
                Hours__c=1,
                Date__c=Date.today(),
                Project_Task2__c=ts1.Id
            ),
            new Milestone1_Time__c(
                Hours__c=1,
                Date__c=Date.today(),
                Project_Task2__c=ts1.Id
            ) 
        };
        insert times;
        Milestone1_Task__c testTask = [SELECT Id, Total_Hours__c FROM Milestone1_Task__c WHERE Id = :ts1.Id];
        System.assert(testTask.Total_Hours__c == 4);
        // update hours
        Milestone1_Time__c mt = times.get(0);
        mt.Hours__c += 1;
        update mt;
        testTask = [SELECT Id, Total_Hours__c FROM Milestone1_Task__c WHERE Id = :ts1.Id];
        System.assert(testTask.Total_Hours__c == 5);
        // switch project task
        Milestone1_Time__c mt2 = times.get(1);
        mt2.Project_Task2__c = ts2.Id; 
        update mt2;
        testTask = [SELECT Id, Total_Hours__c FROM Milestone1_Task__c WHERE Id = :ts1.Id];
        System.assert(testTask.Total_Hours__c == 4);
        Milestone1_Task__c testTask1 = [SELECT Id, Total_Hours__c FROM Milestone1_Task__c WHERE Id = :ts2.Id];
        System.assert(testTask1.Total_Hours__c == 1);
        // delete 
        delete mt;
        testTask = [SELECT Id, Total_Hours__c FROM Milestone1_Task__c WHERE Id = :ts1.Id];
        System.assert(testTask.Total_Hours__c == 2);
    }
}