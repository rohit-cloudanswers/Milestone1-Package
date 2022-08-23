@isTest
public class SyncQuoteTests {
    public static Boolean testException {get;set;}
	@isTest static void test_method_one() {

		Account acc = new Account(Name = 'Edge');
		insert acc;

		Opportunity opp = new Opportunity(
			AccountId = acc.Id,
			Name = 'Opp',
			StageName = 'Prospect',
			CloseDate = Date.today()
		);
		insert opp;

		Quote q = new Quote(
			Name = 'Quote of doom',
			OpportunityId = opp.Id
		);
		insert q;

		ApexPages.StandardController con = new ApexPages.StandardController(q);
		SyncQuote sq = new SyncQuote(con);
        try{
            testException = true;
            sq.autoSync();
            testException = false;
        }catch(Exception ex){
            
        }
	}
	
	@isTest static void test_locked_quote() {
		Account acc = new Account(Name = 'Edge');
		insert acc;

		Opportunity opp = new Opportunity(
			AccountId = acc.Id,
			Name = 'Opp',
			StageName = 'Prospect',
			CloseDate = Date.today()
		);
		insert opp;

		Quote q = new Quote(
			Name = 'Quote of doom',
			OpportunityId = opp.Id
		);
		insert q;

		ApexPages.StandardController con = new ApexPages.StandardController(q);
		SyncQuote sq = new SyncQuote(con);
		testException = false;
		sq.autoSync();

		Test.startTest();
		Quote q1 = new Quote(
			Name = 'Quote-1',
			OpportunityId = opp.Id
		);
		insert q1;

		ApexPages.StandardController con2 = new ApexPages.StandardController(q1);
		SyncQuote sq1 = new SyncQuote(con2);

		sq1.autoSync();

		Test.stopTest();
	}
	
}