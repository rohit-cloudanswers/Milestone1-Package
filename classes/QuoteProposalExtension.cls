global with sharing class QuoteProposalExtension {
    
    public QuoteProposalExtension(ApexPages.StandardController sc) {
        // do nothing
    } 

    @RemoteAction
    global static Boolean saveImage(String name, String body, String parentId) {
        // delete old image
        delete [select Id from Attachment where ParentId = :parentId and Name like 'BusinessData_%'];
        // get instance name
		String instanceName = (String) ImagineOrg.get('InstanceName');
        instanceName = instanceName.toLowerCase();
        // save the latest version
        Attachment att = new Attachment();
        att.Name = name;
        att.Body = EncodingUtil.base64Decode(body);
        att.ParentId = parentId;
        Database.SaveResult res = Database.insert(att);
        return res.isSuccess();
    }
}