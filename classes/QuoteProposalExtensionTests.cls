@IsTest
public class QuoteProposalExtensionTests {

    @TestSetup
    static void setupTestData() {
        TestDataFactory.createAccount();
    }
    
    @isTest
    static void shouldSaveImage() {
        List<Account> accs = [select Id from Account limit 1];
        System.assert(!accs.isEmpty());
        String name = 'BusinessData_' + accs.get(0).Id + '.png';
        String body = EncodingUtil.base64Encode(Blob.valueOf('This is test.'));
        Boolean result = QuoteProposalExtension.saveImage(name, body, accs.get(0).Id);
        System.assert(result);
    }
}