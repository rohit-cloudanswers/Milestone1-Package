public with sharing class OrgInfoController {
      @AuraEnabled
      public static List<Organization> getOrgInfoList(){
       return [SELECT Id,InstanceName,IsSandbox,Name,OrganizationType FROM Organization]; 
  }
}