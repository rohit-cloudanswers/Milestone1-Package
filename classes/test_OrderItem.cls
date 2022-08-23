@isTest
(seeAllData=true)
public class test_OrderItem {
    public static testmethod void testOrderItemTrigger(){
        list<case> cases = test_utility.createCases(1, true);
        Address__c add = [SELECT Id, Account__c FROM Address__c 
                          WHERE account__c != null and Oracle_Address_Id__c != null 
                          and active__c = true AND Oracle_Last_Updated_Date_Time__c !=null and Operating_Unit__c ='US OU'
                          Limit 1];
        Order o = new Order();
        	o.EffectiveDate = system.today();
        	o.CSR_Representative__c = userInfo.getUserId();
        	o.Status = 'Draft';
        	o.Type = 'Replacement';
        	o.Supply_Priority__c = 'Low';
        	o.Price_Book__c = Test.getStandardPricebookId();
        	o.Customer_PO__c = 'asa';
         	o.Shipping_Instructions__c = 'sdsfd';
        	o.Freight_Terms__c = 'TBD';
        	o.Voltage__c = '110V-120V';
        	o.Operating_Unit__c = 'US OU';
        	o.AccountId = add.Account__c;
        	o.End_Customer_Account__c = add.Account__c;
        	o.End_Customer_Address__c = add.id;
        	o.Oracle_Order_Header_ID__c = 'ohid';
        	o.Non_Billable_Reason__c = 'Because';
        insert o;
        Product2 prod = [SELECT Id, Oracle_Product_Id__c FROM Product2 WHERE Oracle_Product_Id__c != null Limit 1];
        OrderItem oi = new OrderItem();
        	oi.OrderId = o.id;
        	oi.Quantity = 1;
       		oi.Oracle_Product_Id__c = prod.Oracle_Product_Id__c;
        	oi.Oracle_Order_Header_ID__c = 'ohid';
        insert oi;
        
        // coverage for delete trigger
        delete oi;
    }
    
     public static testmethod void testContractLineItemTrigger(){
        
        Address__c add = [SELECT Id, Account__c FROM Address__c WHERE account__c != null and Oracle_Address_Id__c != null and active__c = true Limit 1];
        
        ServiceContract sc = new ServiceContract();
        	sc.Name = 'sdadas';
         	sc.AccountId = add.Account__c;
         	sc.Service_Level__c = 'Standard';
             sc.End_Customer_Account__c = add.Account__c;
             sc.Bill_To_Account__c = add.Account__c;
             sc.Ship_To_Account__c = add.Account__c;
             sc.Bill_To_Address__c = add.id;
             sc.Ship_To_Address__c = add.id;
             sc.Oracle_Contract_Line_ID__c = 'ohid';
             sc.Pricebook2Id = Test.getStandardPricebookId();
             sc.Price_Book__c = Test.getStandardPricebookId();
        insert sc;
        Product2 prod = [SELECT Id, Oracle_Product_Id__c FROM Product2 WHERE Oracle_Product_Id__c != null Limit 1];
        ContractLineItem cli = new ContractLineItem();
         	cli.ServiceContractId = sc.id;
         	cli.Quantity = 1;
       		cli.Oracle_Product_Id__c = prod.Oracle_Product_Id__c;
        	cli.Oracle_Contract_Line_ID__c = 'ohid';
        insert cli;
    }
}