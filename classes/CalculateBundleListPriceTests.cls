@IsTest
public class CalculateBundleListPriceTests {
    @IsTest
    static void test1 () {
        //Create a Product
        Product2 p = new Product2(
            Name = 'Test Product' 
        );
        insert p;
        Account a = new Account(
        	Name = 'Test Account',
            OwnerId = UserInfo.getUserId()
        );
        insert a;
        Opportunity o = new Opportunity(
			Name = 'Test Opp',
            CloseDate = Date.today(),
            OwnerId = UserInfo.getUserId(),
            AccountId = a.Id,
            Amount = 1,
            StageName = [
                select ApiName 
                from OpportunityStage 
                where IsActive = true 
                and IsClosed = false 
                order by SortOrder 
                asc limit 1
            ].ApiName
        );
        insert o;
        SBQQ__Quote__c q = new SBQQ__Quote__c(
        	SBQQ__Opportunity2__c = o.Id
        );
        insert q;
        SBQQ__QuoteLineGroup__c g = new SBQQ__QuoteLineGroup__c(
            SBQQ__Quote__c = q.Id
        );
        insert g;
        SBQQ__QuoteLine__c line1 = new SBQQ__QuoteLine__c(
            SBQQ__Quantity__c = 1,
            SBQQ__RegularPrice__c = 100,
            SBQQ__CustomerPrice__c = 50,
            SBQQ__Product__c = p.Id,
            SBQQ__Quote__c = q.Id,
            SBQQ__Group__c = g.Id,
            SBQQ__Description__c = 'test',
            SBQQ__Bundle__c = true,
            SBQQ__ListPrice__c = 1
        );
        insert line1;
        SBQQ__QuoteLine__c line2 = new SBQQ__QuoteLine__c(
            SBQQ__Quantity__c = 1,
            SBQQ__RegularPrice__c = 100,
            SBQQ__CustomerPrice__c = 50,
            SBQQ__Product__c = p.Id,
            SBQQ__Quote__c = q.Id,
            SBQQ__Group__c = g.Id,
            SBQQ__Description__c = 'test',
            SBQQ__RequiredBy__c = line1.Id,
            SBQQ__Bundled__c = true,
            SBQQ__ListPrice__c = 2
        );
        insert line2;
        Test.startTest();
        CalculateBundleListPrice.calculateBundleListPrice(new List<Id>{q.Id});
        Test.stopTest();
		line1 = [select Bundle_List_Price_via_Options__c from SBQQ__QuoteLine__c where Id = :line1.Id];
        System.assertEquals(2, line1.Bundle_List_Price_via_Options__c);
    }
}