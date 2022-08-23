public with sharing class UsersOver60DaysController {
      @AuraEnabled
      public static List<User> getUsersOver60DaysList(){
       return [SELECT Id,LastName,Firstname,Name,Email,EmployeeNumber,IsActive,CreatedDate,LastLoginDate,Username 
               FROM User 
               WHERE IsActive = True
               AND UserType = 'Standard'
               AND LastLoginDate != LAST_N_DAYS:60
               AND Username NOT IN ('sfdc.admin@imagine.com','charlie.vogt@imaginecommunications.com','system.interface@imaginecommunications.com','sfdcadmin1@imaginecommunications.com','insightssecurity@00di0000000iaejea2.com','premiersfdc@00di0000000iaejea2.ext','tom@imaginecommunications.com','terry@imaginecommunications.com')
               ORDER BY LastLoginDate
			   LIMIT 10]; 
  }
}