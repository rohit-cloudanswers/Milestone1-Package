@isTest
public class MPM4_ProjectRelatedToEmailCtrlTest {

	@testsetup
	public static void generateData(){
		RecordType rtProjectContact = [select id from recordtype where sobjecttype='MPM_Project_Resource__c' and name ='Contact' limit 1];
		Account acc = TestDataFactory.createAccount();
		Contact con = TestDataFactory.createContact(acc);
		con.email = 'sample@demo.com';
		update con;


		MPM4_BASE__Milestone1_Project__c milestone = new MPM4_BASE__Milestone1_Project__c();
		milestone.MPM4_BASE__Account__c = acc.id;
		insert milestone;

		MPM_Project_Resource__c  project = new MPM_Project_Resource__c();
        project.Contact__c = con.id;
		project.recordTypeId = rtProjectContact.Id;
		project.Project__c = milestone.id;
		insert project;

	}

	@isTest
	public static void testProjects(){
		List<String> lstEmails = new List<String>();
		lstEmails.add('sample@demo.com');
		MPM4_ProjectRelatedToEmailCtrl.ProjectsWrapper projWrapper = MPM4_ProjectRelatedToEmailCtrl.findMPM4Projects(lstEmails, true);
		system.assert(projWrapper.count == 1);
		system.assert(projWrapper.projects.size() == 1);
		MPM4_ProjectRelatedToEmailCtrl.getListViews();
		MPM4_ProjectRelatedToEmailCtrl.getFieldsetFieldNames();
	}
}