@isTest
private class Test_blogic_Order {
	
	static testMethod void populateAddressTest(){
		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.Pricebook_List_Values__c = 'US Domestic';
		pb.Name = 'Parts - test pricebook';
		insert pb;
		
		Account acc1 = new Account();
		acc1.Name = 'test account 1';
		insert acc1;
		
		Contact con = new Contact();
		con.LastName = 'conLastName';
		con.AccountId = acc1.id;
		con.Email = 'test12345@aol.com';
		insert con;
		test_Utility.loadCountry();
		Address__c add1 = new Address__c();
		add1.Name = 'test address 1';
		add1.Street_Address__c = '876 test1';
		add1.City__c = 'Chicago';
		add1.State__c = 'Illinois';
		add1.Country__c = 'US';
		add1.Zip_Code__c = '60646';
		add1.Account_Service__c = acc1.id;
		add1.Salesforce_Primary__c = true;
		add1.Bill_To__c = true;
		add1.Oracle_Last_Updated_Date_Time__c = Datetime.now();
        add1.Oracle_Cloud_Id__c = '1234567891';
		add1.Operating_Unit__c = 'US OU';
		
		Address__c add2 = new Address__c();
		add2.Name = 'test address 2';
		add2.Street_Address__c = '8765 test2';
		add2.City__c = 'Chicago';
		add2.State__c = 'Illinois';
		add2.Country__c = 'US';
		add2.Zip_Code__c = '60646';
		add2.Account_Service__c = acc1.id;
		add2.Salesforce_Primary__c = true;
		add2.Ship_To__c = true;
		add2.Oracle_Last_Updated_Date_Time__c = Datetime.now();
		add2.Operating_Unit__c = 'US OU';
        add2.Oracle_Cloud_Id__c = '1234567890';
		insert new List<Address__c>{add1, add2};
		
		Case case1 = new Case();
		case1.AccountId = acc1.id;
		case1.Type = 'Performance';
		case1.Product_Line__c = 'Stream';
		case1.ContactId = con.id;
		insert case1;
		
		Order o = new Order();
		o.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Order' AND Name ='Work Order Header' limit 1].id;
		o.Case__c = case1.id;
		o.Operating_Unit__c = 'US OU';
		o.Type = 'Replacement';
		o.Price_Book__c = pb.id;
		o.PoNumber = '876787';
		o.Voltage__c = '110V-120V';
		o.Freight_Terms__c= 'Prepaid';
		o.Supply_Priority__c = 'Low';
		o.Shipping_Instructions__c = 'ship me';
		o.AccountId = acc1.id;
		o.Non_Billable_Reason__c = 'Warranty';
		o.EffectiveDate = Date.Today();
		o.Status = 'Draft';
		
		Order o1 = new Order();
		o1.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Order' AND Name ='Work Order Request' limit 1].id;
		o1.Case__c = case1.id;
		o1.Operating_Unit__c = 'US OU';
		o1.Type = 'Replacement';
		o1.Price_Book__c = pb.id;
		o1.PoNumber = '876787';
		o1.Voltage__c = '110V-120V';
		o1.Freight_Terms__c= 'Prepaid';
		o1.Supply_Priority__c = 'Low';
		o1.Shipping_Instructions__c = 'ship me';
		o1.AccountId = acc1.id;
		o1.Non_Billable_Reason__c = 'Warranty';
		o1.EffectiveDate = Date.Today();
		o1.Status = 'Draft';
		
		Test.startTest();
		insert new List<Order>{o, o1};
		o1.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Order' AND Name ='Work Order Header' limit 1].id;
		update o1;
		Test.stopTest();
		
		//requery
		List<Order> newOrders = [SELECT id, Bill_to_Account__c, Bill_to_Address__c, Ship_to_Account__c, Ship_to_Address__c FROM Order WHERE id=:o.id];
		List<Order> newOrders2 = [SELECT id, Bill_to_Account__c, Bill_to_Address__c, Ship_to_Account__c, Ship_to_Address__c FROM Order WHERE id=:o1.id];
		
		//assertions
		System.assertEquals(newOrders[0].Bill_to_Account__c, acc1.id);
		System.assertEquals(newOrders[0].Ship_to_Account__c, acc1.id);
		System.assertEquals(newOrders[0].Bill_to_Address__c, add1.id);
		System.assertEquals(newOrders[0].Ship_to_Address__c, add2.id);
		System.assertEquals(newOrders2[0].Bill_to_Account__c, acc1.id);
		System.assertEquals(newOrders2[0].Ship_to_Account__c, acc1.id);
		System.assertEquals(newOrders2[0].Bill_to_Address__c, add1.id);
		System.assertEquals(newOrders2[0].Ship_to_Address__c, add2.id);
	}
	
	static testMethod void test_populateSupplyPriority(){
		Account acc1 = new Account();
		acc1.Name = 'test account 1';
		insert acc1;
		
		Contact con = new Contact();
		con.LastName = 'conLastName';
		con.AccountId = acc1.id;
		con.Email = 'test12345@aol.com';
		insert con;
		
		Case case1 = new Case();
		case1.AccountId = acc1.id;
		case1.Type = 'Performance';
		case1.Product_Line__c = 'Stream';
		case1.ContactId = con.id;
		case1.Priority = '2-High';
		insert case1;
		
		Order o = new Order();
		o.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Order' AND Name ='Work Order Request' limit 1].id;
		o.Case__c = case1.id;
		//o.Operating_Unit__c = 'US OU';
		//o.Type = 'Replacement';
		//o.Price_Book__c = pb.id;
		//o.PoNumber = '876787';
		//o.Voltage__c = '110V-120V';
		//o.Freight_Terms__c= 'Prepaid';
		//o.Supply_Priority__c = 'Low';
		//o.Shipping_Instructions__c = 'ship me';
		o.AccountId = acc1.id;
		o.Non_Billable_Reason__c = 'Warranty';
		o.EffectiveDate = Date.Today();
		o.Status = 'Requested';
		o.Due_Date__c = Date.today();
		o.Request_Comments__c = 'test comments';
		
		insert o;
		
		Test.startTest();
		o.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Order' AND Name ='Work Order Header' limit 1].id;
		update o;
		Test.stopTest();
		
		//requery
		List<Order> newList = [SELECT id, Supply_Priority__c FROM Order WHERE id =:o.id];
		

	}
}