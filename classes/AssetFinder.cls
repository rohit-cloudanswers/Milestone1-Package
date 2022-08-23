public with sharing class AssetFinder {
    @TestVisible
    public Case caseToUpdate {get; private set;}
    public Id assetId {get; set;}
    public String accountSearch {get; set;}
    public String productSearch {get; set;}
    public Boolean onlySupportedAssets {public get; public set;}
    public String resultLimit {get; set;}
    public AssetFinder () {
        if (ApexPages.currentPage().getParameters().get('caseId') != null) {
            caseToUpdate = [select Id, AssetId, CaseNumber from Case where Id = :ApexPages.currentPage().getParameters().get('caseId')];
        }
        String companyName = ApexPages.currentPage().getParameters().get('companyName');
        if(companyName != null) {
            this.accountSearch = companyName;
        }
        resultLimit = '100';
    }
    public List<Asset> getAssets () {
        String query = 'select Account.Name, Account.Oracle_Customer_Number__c, Account.Service_Alias__c, End_Customer__r.Name, End_Customer__r.Oracle_Customer_Number__c, Name, Product2.Name, Product2.Product_Family__c, Part_Number__c, SerialNumber, Product2.Business_Unit__c, Product2.Product_Group__c, (select ServiceContract.Name, Status, StartDate, EndDate, Service_Level__c from ContractLineItems where Status=\'Active\' order by ServiceContract.EndDate desc) from Asset ';
        
		String accountLike = '%' + accountSearch + '%';
        String productLike = '%' + productSearch + '%';
        String accountFilter = ' (Account.Name like :accountLike or End_Customer__r.Name like :accountLike or Account.Oracle_Customer_Number__c = :accountSearch or End_Customer__r.Oracle_Customer_Number__c = :accountSearch or Account.Service_Alias__c like :accountLike) ';
        String productFilter = ' (Name = :productSearch or Product2.Name like :productLike or Product2.Product_Family__c like :productLike or Part_Number__c like :productLike or SerialNumber like :productLike or Product2.Business_Unit__c like :productLike or Product2.Product_Group__c like :productLike) ';
        String filter = '';
        resultLimit = '100';
        if (!String.isBlank(accountSearch)) {
            filter += ' where ' + accountFilter;
            resultLimit = '1000';
        }        
        if (!String.isBlank(productSearch)) {
            filter += (filter != '' ? ' and ' : ' where ') + productFilter;
            resultLimit = '1000';
        }
        if (this.onlySupportedAssets == true) {
            filter += (filter != '' ? ' and ' : ' where ') + ' Id in (select AssetId from ContractLineItem where EndDate >= TODAY) ';
            resultLimit = '1000';
        }
        return Database.query(query + filter + ' limit ' + resultLimit);
    }
    public PageReference updateCaseAsset() {
        System.assert(caseToUpdate.AssetId != null);
        update caseToUpdate;
        PageReference pageRef = new PageReference('/' + caseToUpdate.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference cancel(){
        return new PageReference('/' + caseToUpdate.Id);
    }
}