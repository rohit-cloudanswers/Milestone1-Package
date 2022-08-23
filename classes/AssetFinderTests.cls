@IsTest
public class AssetFinderTests {
	@IsTest
    static void shouldIncreaseResultsWhenSearching () {
        AssetFinder c = new AssetFinder();
		c.getAssets();
        System.assertEquals('100', c.resultLimit);
        c.accountSearch = 'test';
		c.getAssets();
        System.assertEquals('1000', c.resultLimit);
		c.accountSearch = '';
		c.productSearch = 'test';
		c.getAssets();
        System.assertEquals('1000', c.resultLimit);
		c.productSearch = '';
		c.getAssets();
        System.assertEquals('100', c.resultLimit);
        c.onlySupportedAssets = true;
        c.getAssets();
	}
    
    @isTest
    static void shouldUseCompanyName() {
        Test.setCurrentPageReference(Page.AssetFinder);
        ApexPages.currentPage().getParameters().put('companyName', 'test');
        AssetFinder c = new AssetFinder();
		c.getAssets();
        Case cs = new Case(
            Id='500000000000000'
        );
        c.caseToUpdate = cs;
        c.cancel();
    }
}