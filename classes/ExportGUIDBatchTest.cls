@isTest
public class ExportGUIDBatchTest {
    
	public static final String TEST_RESPONSE = '{"@odata.context":"https://graph.microsoft.com/v1.0/$metadata#sites(\'myimagine.sharepoint.com%2C6d6ebfdc-b42a-40f3-8071-21db2c07bca1%2Cd7b6b550-5285-4619-ad46-8e0568ba46c2\')/drive/items(\'root\')/children","@odata.nextLink":"https://graph.microsoft.com/v1.0/sites/myimagine.sharepoint.com,6d6ebfdc-b42a-40f3-8071-21db2c07bca1,d7b6b550-5285-4619-ad46-8e0568ba46c2/drive/items/root/children?$skiptoken=UGFnZWQ9VFJVRSZwX1NvcnRCZWhhdmlvcj0xJnBfRmlsZUxlYWZSZWY9NzI2MzgyOCtFbmNvbXBhc3MrQXRsYW50YStQRiUyMzQ5MzYxJnBfSUQ9NzM5NTc","value":[{"createdDateTime":"2016-01-27T22:47:45Z","id":"01UJG2UNYDGQI5S5NUYVD3O3TTJJNUKCQQ","lastModifiedDateTime":"2017-03-21T10:27:51Z","name":"[FTV] New Facility System Expansion","webUrl":"https://myimagine.sharepoint.com/teams/SalesForceTest/Shared%20Documents/%5BFTV%5D%20New%20Facility%20System%20Expansion","size":197120,"parentReference":{"driveId":"b!3L9ubSq080CAcSHbLAe8oVC1tteFUhlGrUaOBWi6RsIKpjt7puIlSLNEaGtG41rk","driveType":"documentLibrary","id":"01UJG2UN56Y2GOVW7725BZO354PWSELRRZ","path":"/drive/root:"},"folder":{"childCount":2}}]}';
    public static final String TEST_NEXT_RESPONSE = '{"@odata.context":"https://graph.microsoft.com/v1.0/$metadata#sites(\'myimagine.sharepoint.com%2C6d6ebfdc-b42a-40f3-8071-21db2c07bca1%2Cd7b6b550-5285-4619-ad46-8e0568ba46c2\')/drive/items(\'root\')/children","value":[{"createdDateTime":"2016-01-27T22:47:45Z","id":"01UJG2UNYDGQI5S5NUYVD3O3TTJJNUKCQQ","lastModifiedDateTime":"2017-03-21T10:27:51Z","name":"[FTV] New Facility System Expansion","webUrl":"https://myimagine.sharepoint.com/teams/SalesForceTest/Shared%20Documents/%5BFTV%5D%20New%20Facility%20System%20Expansion","size":197120,"parentReference":{"driveId":"b!3L9ubSq080CAcSHbLAe8oVC1tteFUhlGrUaOBWi6RsIKpjt7puIlSLNEaGtG41rk","driveType":"documentLibrary","id":"01UJG2UN56Y2GOVW7725BZO354PWSELRRZ","path":"/drive/root:"},"folder":{"childCount":2}}]}';
        
	@TestSetup
    static void setupTestData() {
        Sharepoint_Site__c ss = new Sharepoint_Site__c(
            SetupOwnerId=UserInfo.getOrganizationId(),
            Site_Id__c='testsiteid'
        );
        insert ss;
        Token__c token = new Token__c(
            Access_Token__c='abcdefghijklmnopqrstuvwxyz',
            Refresh_Token__c='abcdefghijklmnopqrstuvwxyz'
        );
        insert token;
    }
    
    @isTest
    static void shouldExportGUID(){
        Test.startTest();
        String siteId = Sharepoint_Site__c.getInstance().Site_Id__c;
        System.assert(String.isNotBlank(siteId));
        String rootUrl = 'https://graph.microsoft.com/v1.0/sites/{0}/drive/items/root/children';
        String driveUrl = String.format(rootUrl, new String[]{siteId});
        HttpHelper.httpTestResponse = TEST_RESPONSE;
        ExportGUIDBatch obj = new ExportGUIDBatch(driveUrl, 'help@cloudanswers.com');
        Database.executeBatch(obj, 1);
        Test.stopTest();
    }
}