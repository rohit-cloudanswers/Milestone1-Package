@isTest(seeAlldata  = true)
public with sharing class AddressTest {
	static testMethod void testOnBeforeInsertDataManipulation(){
		Account testAccount = new Account(Name = 'test Account',Type ='Prospect');
	insert testAccount;
	Country__c cty = new Country__c(Name = 'United States of America', Global_Region__c = 'NORTH AMERICA', Region__c = 'US', Country__c = 'United States of America');
	try{
	insert cty;
	}catch(exception e){}
	Address__c testAddress = new Address__c(Sub_Region__c = 'APAC',Account__c = testAccount.Id, Active__c = true, Street_Address__c='test Street Address',Salesforce_Primary__c=true, State__c= 'California' , Country__c = 'United States of America');
	try{
	insert testAddress;
	}catch(exception e){}
	Pricebook2 pb = [select Id from Pricebook2 where isActive = true and Name='Canadian Domestic List Prices (CAD)'];
	Product2 product = new Product2();
 	product.Product_Cost__c = 1.0 ;
 	product.Name = 'test';
 	product.Salesforce_Product_Type__c = 'Software';
 	product.IsActive = true;
 	product.CurrencyIsoCode  ='CAD';
 	insert product;
 	Prices_History__c obj  = new Prices_History__c();
 	obj.Price_Book__c = pb.Id;
 	obj.Product__c = product.Id;
 	obj.Price__c = 1.00;
 	obj.Price_List_Flag__c = true;
 	obj.Price_Name__c = 'Test';
 	obj.Start_Date__c = date.today();
 	obj.End_Date__c = date.today().addDays(5);
 	obj.Currency__c = 'USD';
 	try{
 		insert obj;
 	}catch(exception e){}
 	product.Name = 'test123';
 	update product;
	}
	
}