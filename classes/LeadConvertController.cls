public with sharing class LeadConvertController {

	@AuraEnabled
	public static void updateLeadBeforeConvert(String leadId){
		Lead l = new Lead();
		l.Id = Id.valueOf(leadId);
		l.Allow_Conversion__c = true ;
		update l ;
	}
}