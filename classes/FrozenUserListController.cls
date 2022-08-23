public with sharing class FrozenUserListController {
      @AuraEnabled
      public static List<User> getFrozenUserList(){
       return [SELECT Id,LastName,Firstname,Name,Email,EmployeeNumber,IsActive,CreatedDate,LastLoginDate,Username 
               FROM User 
               WHERE Id IN (SELECT UserId FROM UserLogin WHERE IsFrozen = True) 
               AND UserType = 'Standard']; 
  }
}