/*

Author: Gulshan Raj
Class Name : ResetNonConvertedLead
Test class :TestResetNonConvertedLead
Description : W-001016 :Lead conversion blocked because time based workflow rules.
			  A new field Allow_Conversion__c under lead is set to true just before lead conversion to by-pass
			  any lead process builder's using scheduled taks. ResetNonConvertedLead is class which reset lead Allow_Conversion__c
			  field to false if user cancled lead conversion.
Modification: <User Name>  ||  <Modification Date> || <Modification Purpose>

To run this schedular every hour use this script
System.schedule('Hourly-ResetNonConvertedLead', '0 0 * * * ?', new ResetNonConvertedLead() );
*/

global class ResetNonConvertedLead implements Schedulable {
	global void execute(SchedulableContext sc) {
		List<Lead> lstNonConvertedLeads = new List<Lead>();
		for(Lead l: [select id, Allow_Conversion__c from Lead where Allow_Conversion__c=true limit 10000])
		{
			l.Allow_Conversion__c=false;
			lstNonConvertedLeads.add(l);
		}
		if(lstNonConvertedLeads.size()>0)
		{
			update lstNonConvertedLeads;
		}
	}
}