@isTest
private class QuoteTriggerHelperTest
{
	@testsetup
	static void generateData()
	{
		Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
	    insert testAccount;
	    Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
	    insert cty;
	    Address__c testAddress = new Address__c(Account__c = testAccount.Id, Active__c = true, Street_Address__c='test Street Address',Salesforce_Primary__c=true, State__c= 'California' , Country__c = 'United States of America');
	    insert testAddress;      
	   
	    Pricebook2 pb =  new Pricebook2(isActive = true, Name='Canadian Domestic List Prices (CAD)', Currency_Code__c='CAD');
	    insert pb;

	    Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity',Pricebook2Id=pb.ID,AccountId=testAccount.Id, StageName='Prospecting',CloseDate = Date.today()+30, Description = 'testing' );
	    insert testOpportunity;
	    Quote testQuote = new Quote(Name = 'test Quote', OpportunityId = testOpportunity.Id,Default_Price_Book__c=pb.ID,Additional_DIscount__c = 10, Tier_Discount2__c = 20 );   
	    insert testQuote;

	    List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
	    
	    quoteLineItemList.add(createQuoteLineItem('Hardware',testQuote.Id,pb.Id,10,100, 'OEM'));
	    quoteLineItemList.add(createQuoteLineItem('Software',testQuote.Id,pb.Id,10,100, 'OEM'));
	    quoteLineItemList.add(createQuoteLineItem('Professional Services',testQuote.Id,pb.Id,10,100, 'OEM'));
	    quoteLineItemList.add(createQuoteLineItem('Support',testQuote.Id,pb.Id,10,100, 'OEM'));
	    quoteLineItemList.add(createQuoteLineItem('Software',testQuote.Id,pb.Id,10,100, 'Software'));
	    quoteLineItemList.add(createQuoteLineItem('Hardware',testQuote.Id,pb.Id,10,100, 'Hardware'));
	    quoteLineItemList.add(createQuoteLineItem('Professional Services',testQuote.Id,pb.Id,10,100, 'Professional Services'));
	    quoteLineItemList.add(createQuoteLineItem('Support',testQuote.Id,pb.Id,10,100, 'Support'));

	    QuoteLineItemTriggerManager.ALLOWTRIGGERPROCESS = true;
	    QuoteLineItemTriggerManager.ALLOWQUOTETRIGERPROCESS = true;  
	    insert quoteLineItemList; 
	}

	@isTest
	static void updateQuote(){
		Pricebook2 pb =  new Pricebook2(isActive = true, Name='Canadian Domestic List Prices (CAD)', Currency_Code__c='CAD');
	    insert pb;
		Test.startTest();
		Quote testQuote = [select id,Default_Price_Book__c,Support_Type__c,OEM_Support_Discount__c,Hardware_Discount__c,Software_Discount__c,Service_Discount__c,OEM_Discount__c,OEM_Hardware_Discount__c,OEM_Software_Discount__c,OEM_Professional_Services_Discount__c from quote];
		Pricebook2 pb1 = [select Id from Pricebook2 where isActive = true Limit 1];
	    testQuote.OEM_Hardware_Discount__c = 2;
	    testQuote.OEM_Software_Discount__c = 2;
	    testQuote.OEM_Professional_Services_Discount__c = 2;
	    testQuote.OEM_Support_Discount__c = 2;
	    testQuote.Software_Discount__c = 2;
	    testQuote.Service_Discount__c = 2;
	    testQuote.Support_Discount__c = 2;
	    testQuote.Hardware_Discount__c = 2;
	    testQuote.Professional_Service_Requested__c = true;
	    testQuote.submit_to_ps__c = true;
	    update testQuote;
	    Test.stopTest();
	}

	public  static QuoteLineItem createQuoteLineItem(String productType,Id quoteId , Id priceBookId, Integer quantity , Integer unitPrice, String productSubType){
	    Product2 product = new Product2();
	    product.Product_Cost__c = unitPrice ;
	    product.Name = 'test';
	    product.Salesforce_Product_Type__c = productType;
	    product.Product_Type__c = productSubType;
	    product.IsActive = true;
	    product.CurrencyIsoCode  ='CAD';
	    insert product;
	    PricebookEntry pbe = new PricebookEntry();
	    pbe.product2id = product.Id;
	    pbe.pricebook2id = priceBookId;
	    pbe.UnitPrice = unitPrice;
	    pbe.IsActive = true;
	    pbe.CurrencyIsoCode = 'CAD';
	    insert pbe;
	    system.debug('*****pbe*****'+pbe);
	    QuoteLineItem item = new quotelineitem(); 
	    item.pricebookentryid = pbe.id; 
	    item.quantity = quantity; 
	    item.unitprice = unitPrice;
	    item.QuoteId = quoteId;
	    return item;
 }
}