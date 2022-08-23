@IsTest (SeeAllData=true) 
public class LeadMainTest{
    public static testMethod void leadTest() {
    // create a Lead
    Lead lead=new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Inquiry',City = 'Houston',State='Texas',Country='United States of America',Street='7200 Almeda Rd',PostalCode = '98432');
    insert lead;   
    lead.Country = 'India';
    lead.State = 'Delhi';
    update lead;    
    
    //
    Database.LeadConvert lc = new database.LeadConvert();
	lc.setLeadId(lead.Id);
    lc.setDoNotCreateOpportunity(True); 
    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    lc.setConvertedStatus(convertStatus.MasterLabel);
    Database.LeadConvertResult lcr = Database.convertLead(lc);
    
    
    //System.assert(lcr.isSuccess());
    }
}