@IsTest
public class LightningLookupCtrlTests {
    
    @TestSetup
    static void setupTestData() {
        Account acc = TestDataFactory.createAccount();
        Contact con = TestDataFactory.createContact(acc);
    }

    @isTest
    static void shouldGetContactById() {
        List<Contact> contacts = [select Id from Contact limit 1];
        Contact con = LightningLookupCtrl.getContactById(contacts.get(0).Id);
        System.assert(con != null);
    }
    
    @isTest
    static void shouldGetContacts () {
        List<Account> accounts = [select Id from Account limit 1];
        List<Contact> contacts = LightningLookupCtrl.getContacts('AccountId', accounts.get(0).Id, 'John');
        System.assert(!contacts.isEmpty());
    }
}