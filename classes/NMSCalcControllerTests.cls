@IsTest(SeeAllData=false)
public class NMSCalcControllerTests {

    @isTest
    static void shouldCalcNMSProserv(){
        Quote qt = TestDataFactory.setupTestQuote(true);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', qt.Id);
        NMSCalcController con = new NMSCalcController();
        System.assert(con.quoteId != null);
        PageReference pageRef = con.calculateNMSServ();
        Test.stopTest();
        System.assert(pageRef != null);
        List<Quote_Solutions__c> solutions = [select Id from Quote_Solutions__c where Name like :NMSCalcController.NMS_SOLUTION_SET];
        System.assert(solutions.size() != 0);
    }
    
    @isTest
    static void shouldCleanupNMSSolutionSet(){
        Quote qt = TestDataFactory.setupTestQuote(false);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', qt.Id);
        NMSCalcController con = new NMSCalcController();
        con.calculateNMSServ();
        Test.stopTest();
        List<Quote_Solutions__c> solutions = [
            select Id from Quote_Solutions__c 
            where Name like :NMSCalcController.NMS_SOLUTION_SET
            and Quote__c = :qt.Id
        ];
        System.assert(solutions.size() == 0);
    }
    
    @isTest
    static void shouldCancel(){
        Quote qt = TestDataFactory.setupTestQuote(true);
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', qt.Id);
        NMSCalcController con = new NMSCalcController();
        System.assert(con.quoteId != null);
        PageReference pageRef = con.cancel();
        Test.stopTest();
        System.assert(pageRef != null);
    }
}