@IsTest(SeeAllData=false)
public class AddressFinderTests {

    @TestSetup
    static void setupTestData() {
        Account acc = TestDataFactory.createAccount();
        Address__c address = TestDataFactory.createAddress(acc);
        Contact con = TestDataFactory.createContact(acc);
        Opportunity opp = TestDataFactory.createOpportunity(acc);
    }
    
    @isTest
    static void shouldGetAddresses() {
        Opportunity opp = [select Id, AccountId from Opportunity limit 1];
        Test.setCurrentPageReference(Page.AddressFinder);
        ApexPages.currentPage().getParameters().put('recordId', opp.Id);
        ApexPages.currentPage().getParameters().put('address', 'Billing_Address__c');
        ApexPages.currentPage().getParameters().put('parentAccount', opp.AccountId);
        AddressFinder finder = new AddressFinder();
        finder.searchFields.put('City__c', 'Somerville');
        List<Address__c> addresses = finder.getAddresses();
        System.assert(addresses.size() == 1);
    }
    
    @isTest
    static void shouldUpdateAddress() {
        Opportunity opp = [select Id, AccountId from Opportunity limit 1];
        Test.setCurrentPageReference(Page.AddressFinder);
        ApexPages.currentPage().getParameters().put('recordId', opp.Id);
        ApexPages.currentPage().getParameters().put('address', 'Billing_Address__c');
        ApexPages.currentPage().getParameters().put('parentAccount', opp.AccountId);
        AddressFinder finder = new AddressFinder();
        finder.searchFields.put('City__c', 'Somerville');
        List<Address__c> addresses = finder.getAddresses();
        System.assert(addresses.size() == 1);
        finder.addressId = addresses.get(0).Id;
        finder.updateAddress();
		opp = [select Id, Billing_Address__c from Opportunity limit 1];
        System.assert(opp.Billing_Address__c == addresses.get(0).Id);
    }
    
    @isTest
    static void shouldCreateNewAddress() {
        Opportunity opp = [select Id, AccountId from Opportunity limit 1];
        Test.setCurrentPageReference(Page.AddressFinder);
        ApexPages.currentPage().getParameters().put('recordId', opp.Id);
        ApexPages.currentPage().getParameters().put('address', 'Billing_Address__c');
        ApexPages.currentPage().getParameters().put('parentAccount', opp.AccountId);
        AddressFinder finder = new AddressFinder();
        finder.newAction();
        System.assert(finder.newAddress && finder.address != null);
        finder.address.Street_Address__c = '15 Test Street';
        finder.address.Account_Service__c = opp.AccountId;
        finder.address.City__c = 'Somerville';
        finder.address.State__c = 'Massachusetts';
        finder.address.Country__c = 'United States of America';
        finder.address.Zip_Code__c = '02144';
        finder.saveAction();
        List<Address__c> addresses = [select Id from Address__c where Account_Service__c = :opp.AccountId];
        System.assert(addresses.size() == 2);
    }
}