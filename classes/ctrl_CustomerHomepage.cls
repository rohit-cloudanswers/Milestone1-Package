public with sharing class ctrl_CustomerHomepage {
	public String userId {get; set;}
	public User runningUser {get; set;}
	public Contact runningContact {get; set;}
	public List<Case> caseList {get; set;}
	public List<Case> lowCaseList {get; set;}
	public List<Case> mediumCaseList {get; set;}
	public List<Case> highCaseList {get; set;}

	public Integer lowCaseListSize {get; set;}
	public Integer mediumCaseListSize {get; set;}
	public Integer highCaseListSize {get; set;}

	public String dtString{get; set;}


	public ctrl_CustomerHomepage() {
		List<User> userList = [Select u.Id,u.ContactId, u.AccountId from User u where u.Id = :UserInfo.getUserId()];

		if( userList != null && userList.size() > 0 )            
		{
		      System.debug('userList[0].ContactId::' + userList[0].ContactId);
		      userId = userList[0].ContactId;
		      runningUser = userList[0];
		      System.debug(runningUser.ContactId);

		      //runningContact = [Select c.Id, c.AccountId from Contact c where c.Id = :runningUser.ContactId];

	      		caseList = [SELECT id, CaseNumber, Subject, Product_Line__c, Status, CreatedDate, Impact__c, Urgency__c FROM Case WHERE ContactId =: runningUser.ContactId AND RecordType.Name IN ('Service') ORDER BY CreatedDate DESC LIMIT 5];
      			System.debug(caseList);
	      		lowCaseList = [SELECT id, CaseNumber, Subject, Product_Line__c, Status, CreatedDate, Impact__c, Urgency__c FROM Case WHERE ContactId =: runningUser.ContactId AND RecordType.Name IN ('Service') AND Impact__c = 'Low'];
	      		lowCaseListSize = lowCaseList.size();
	      		mediumCaseList = [SELECT id, CaseNumber, Subject, Product_Line__c, Status, CreatedDate, Impact__c, Urgency__c FROM Case WHERE ContactId =: runningUser.ContactId AND RecordType.Name IN ('Service') AND Impact__c = 'Medium'];
				mediumCaseListSize = mediumCaseList.size();
				highCaseList = [SELECT id, CaseNumber, Subject, Product_Line__c, Status, CreatedDate, Impact__c, Urgency__c FROM Case WHERE ContactId =: runningUser.ContactId AND RecordType.Name IN ('Service') AND Impact__c = 'High'];
				highCaseListSize = highCaseList.size();
		}
	}
}