@IsTest(SeeAllData=true)
public class CaseTimeBatch_Tests {

   @isTest
    static void shouldRollupCaseTime() {
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
        
        // fixme: moved this up because of a lot of queries happening in flows now
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
        
        // Test.startTest();
        CaseTimeBatch batch = new CaseTimeBatch();
        Database.executeBatch(batch, 1);
        Test.stopTest();
        
        c = [select Id, Total_Time_Entered__c from Case where Id =: c.Id];
        System.assert(c.Total_Time_Entered__c == 4);
    }
}