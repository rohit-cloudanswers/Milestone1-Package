@isTest
public with sharing class ProductPriceUpdate_TestBatch {
	
	@testSetup static void setupData(){
		List<String> oracleIds = new List<String>{'12072','12074','12078','12076','12071','12073','12077','12075', '184027'};
		
		Product2 producto =new Product2();
        producto.Name='test';
        producto.productCode='1234';
        producto.isActive = true;
        producto.CurrencyIsoCode='USD';
        
        insert producto;
        
        List<Pricebook2> lstPBs = new List<Pricebook2>();
        lstPBs.add(new Pricebook2(
        	Name = 'Standard Price Book',
	        IsActive = true,
	        CurrencyIsoCode='USD'
	    ));
        for(String oracleId : oracleIds){
        	PriceBook2 pb2=new PriceBook2();
	        pb2.Name = 'test';
	        pb2.Oracle_Id__c = oracleId;
	        pb2.IsActive = true;
	        pb2.CurrencyIsoCode='USD';
	        lstPBs.add(pb2);
        }
        insert lstPBs;
        
        List<PricebookEntry> lstPBEs = new List<PricebookEntry>();
        for(Pricebook2 pb : lstPBs){
        	PricebookEntry cusPBE = new PriceBookEntry(
		        Product2Id=producto.Id,
		        Pricebook2Id=pb.Id,
		        UnitPrice = 5000000.00,
		        UseStandardPrice = false,
		        IsActive=true
		    );
		   	lstPBEs.add(cusPBE);
        }
	    insert lstPBEs;
	}

    static Testmethod void batchTest(){
        Test.startTest();
        ProductPriceUpdate_Batch b = new ProductPriceUpdate_Batch();
        Database.executeBatch(b);
        Test.stopTest();
    }
}