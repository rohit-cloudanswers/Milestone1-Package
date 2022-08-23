@IsTest(SeeAllData=false)
public class Trigger_ContentDocumentLink_TestClass {

    @IsTest
    static void TestContentDocument () {
        Test.startTest();
        
        List<Account> accounts = (List<Account>) Test.loadData(Account.sObjectType, 'TestData_Account');
        System.assert(!accounts.isEmpty());
        Account acc = accounts.get(0);
        Contact con = TestDataFactory.createContact(acc);
                
        List<Case> cases = new List<Case>();
        Case cs = new Case(
            Subject='This is test case',
            ContactId=con.Id,
            AccountId=acc.Id
        );
        
        cases.add(cs);
        insert cases;
 
        /*
        //Create ContentDocument
        ContentVersion content = new ContentVersion();
        content.Title = 'Header_Picture1'; 
        content.PathOnClient = '/' + content.Title + '.jpg'; 
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData = bodyBlob;
        content.origin = 'H';
        insert content;
*/
        
    //Create ContentDocumentLink
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = cs.id;
 //       contentlink.contentdocumentid = content.id;
 //       Yeah I know its bad to hard code but I couldn't get the above contentdocument create to work properly. darcie
                contentlink.contentdocumentid = '0693r00000AAON4AAP';
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
        
        
        Test.stopTest();
}
}