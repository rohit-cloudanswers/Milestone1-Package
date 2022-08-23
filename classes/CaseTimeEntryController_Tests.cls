@IsTest(SeeAllData=false)
private class CaseTimeEntryController_Tests {
    @IsTest
    static void shouldSaveTime(){
        Case newCase = new Case();
        newCase.Subject = 'Test case';
        newCase.SuppliedEmail = 'john.smith@gmail.com';
        insert newCase;
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(newCase);
        CaseTimeEntryController con = new CaseTimeEntryController(stdCon);
        con.timeEntry.Hours__c = 1;
        con.minutes = 40;
        con.save();
        
        List<Milestone1_Time__c> timeEntries = [select Id, Hours__c from Milestone1_Time__c];
        System.assert(timeEntries.size() == 1);
    }
}