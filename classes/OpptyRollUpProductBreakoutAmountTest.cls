@isTest
private class OpptyRollUpProductBreakoutAmountTest {
 
    static testMethod void rollUpProductBreakoutAmount() {
 
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
 
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'testuser@test123456789.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test User';
        u.Username = 'testuser@test123456789.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'Test User';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        insert u;
 
        system.runAs(u){
 
            Opportunity o = new Opportunity();
            o.Name = 'Test Opportunity';
            o.StageName = 'Prospecting';
            o.CloseDate = system.today();
            insert o;
 
            system.assertEquals(o.Amount, null);
 
            //Test product breakout amounts on insert
            Product_Breakout__c p1 = new Product_Breakout__c();
            p1.Opportunity__c = o.Id;
            p1.Product_Breakout_Amount__c = 1000;
            insert p1;
 
            Opportunity ou1 = [select Amount from Opportunity where Id = :o.Id];
            system.assertEquals(ou1.Amount,p1.Product_Breakout_Amount__c);
 
            //Test product breakout amounts on update
            Product_Breakout__c p1u = [select Product_Breakout_Amount__c from Product_Breakout__c where Id = :p1.Id];
            p1u.Product_Breakout_Amount__c = 2000;
            update p1u;
 
            Opportunity ou2 = [select Amount from Opportunity where Id = :o.Id];
            system.assertEquals(ou2.Amount,p1u.Product_Breakout_Amount__c);
 
            //Test payments on second insert
            Product_Breakout__c p2 = new Product_Breakout__c();
            p2.Opportunity__c = o.Id;
            p2.Product_Breakout_Amount__c = 800;
            insert p2;
 
            AggregateResult ag1 = [select sum(Product_Breakout_Amount__c) from Product_Breakout__c where Opportunity__c = :o.Id];
 
            Opportunity ou3 = [select Amount from Opportunity where Id = :o.Id];
            system.assertEquals(ou3.Amount,ag1.get('expr0'));
 
            //Test payment on delete
            delete p2;
 
            AggregateResult ag2 = [select sum(Product_Breakout_Amount__c) from Product_Breakout__c where Opportunity__c = :o.Id];
 
            Opportunity ou4 = [select Amount from Opportunity where Id = :o.Id];
            system.assertEquals(ou4.Amount,ag2.get('expr0'));
 
        }
 
    }
 
}