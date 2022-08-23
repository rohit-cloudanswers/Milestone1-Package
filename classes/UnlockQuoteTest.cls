@IsTest
public class UnlockQuoteTest {
	
    static Quote q;
    static {
        String pricebookId = Test.getStandardPricebookId();
        Account acc = TestDataFactory.createAccount();
        Contact con = TestDataFactory.createContact(acc);
        Opportunity opp = TestDataFactory.createOpportunity(acc);
        q = new Quote(
            Name=opp.Name,
            OpportunityId=opp.Id,
            Pricebook2Id=pricebookId
        );
        insert q;
        update new Opportunity(Id=opp.Id, SyncedQuoteId=q.Id);
    }
    
    @IsTest
    public static void shouldUnlockQuote(){
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', q.Id);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(q);
        UnlockQuoteController controller = new UnlockQuoteController(stdCon);
        PageReference pageRef = controller.toggleSync();
        Test.stopTest();
    }
    
    @IsTest
    public static void shouldNotUnlockQuote(){
        Test.startTest();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(new Quote());
        UnlockQuoteController controller = new UnlockQuoteController(stdCon);
        PageReference pageRef = controller.toggleSync();
        Test.stopTest();
    }
}