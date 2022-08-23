@isTest
private class CEOReportTests {
    
    @isTest static void testInit() {
        Account a = new Account(
            Name = 'Test',
            Customer_Performance_Report_Name__c = 'Test'
        );
        insert a;

        Country__c testCountry = new Country__c(
            Name = 'United States of America',
            Global_Region__c = 'NORTH AMERICA', // region
            Region__c = 'US' // sub region
        );
        insert testCountry;
        Address__c addr = new Address__c(
            Country_LK__c = testCountry.Id,
            Account_Service__c = a.Id,
            State__c = 'Massachusetts'
        );
        insert addr;

        a.Billing_Address__c = addr.Id;
        update a;

        insert new Customer_Performance__c(
            Account__c = a.Id,
            Year__c = '2017'
        );
        insert new Opportunity(
            Name = 'Test Opp',
            AccountId = a.Id,
            StageName = 'Prospecting',
            Amount = 1,
            CloseDate = Date.today().addDays(100)
        );

        // lots of dependent objects up there, just make sure we have them setup right
        System.assertEquals('NORTH AMERICA', [select Bill_To_Region__c from Account].Bill_To_Region__c);

        CEOReport controller = new CEOReport();
        controller.onLoad();
        controller.roleFilter = controller.roleOptions[0].getValue();
        CEOReport.Row[] res = controller.getRows();
        System.assertEquals(1, res.size());

        // just for coverage:
        controller.usersUnderMe();
    }
    
}