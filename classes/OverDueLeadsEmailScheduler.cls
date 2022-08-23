global class OverDueLeadsEmailScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      
      // 1. Get all the Leads 
      List<Lead> leads = [SELECT Id,Owner.email from Lead];
      Map<Id,String> leadMap = new Map<Id,String>();
      for(Lead currentLead : leads){
          leadMap.put(currentLead.Id,currentLead.Owner.email);
      }
      System.debug(leadMap.keySet());
      Date emailSentCutOff = Date.today()-7;
      
      // 2. Find all the open tasks related to lead which are overdue 
      List<Task> overdueTasks = [SELECT Id,WhoId,Subject,ActivityDate,isClosed FROM Task 
          WHERE WhoId IN :leadMap.keySet() AND ActivityDate <= :Date.today() AND isClosed =: false AND
          (Email_Sent_Date__c =: null OR Email_Sent_Date__c <= :emailSentCutOff)];
      
      // 3. Prepare Messages
      List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>(); 
      for(Task overdueTask : overdueTasks){
          String leadEmail = leadMap.get(overdueTask.WhoId);
          if(leadEmail == null) continue;
          Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
          message.setSubject('Task Overdue: Action Needed');
          message.setPlainTextBody('The Task '+ overdueTask.Subject +'(Id:'+overdueTask.Id +') assigned to you is overdue. Please perform the necessary action immediately.');
          message.setToAddresses(new String[] { leadEmail });
          messages.add(message);
          overdueTask.Email_Sent_Date__c = Date.today();
      }
      
      // 4. Send Emails
      if(!messages.isEmpty()){
          Messaging.sendEmail(messages);
          update overdueTasks;  
      }         
   }
}