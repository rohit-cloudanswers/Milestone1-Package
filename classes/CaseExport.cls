public with sharing class CaseExport {
    public Case[] getCases () {
        Date afterDate = Date.today().addMonths(-12);
        return [
            select Id, CaseNumber, Status_Overview__c,
            Subject, Description, Description_2__c,
            CreatedDate, ClosedDate,
            Parent.CaseNumber,
            Account.Name, Contact.Name, Customer_Reference_Number__c,
            Case_Last_Updated__c, Product__c, Last_Public_Case_Comment__c, Last_Public_Case_Comment_Date__c, Type,
            Resolution__c, Current_Version__C, Reported_Version__c, Priority
           
            from Case 
            where CreatedDate >= :afterDate
            order by CreatedDate desc
            limit 1000
        ];  
    }
}