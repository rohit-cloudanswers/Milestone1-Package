@isTest
public class MPM4_Custom_Owner_Update_Ctrl_Test {
    public static testMethod void shouldUpdateProjectOwner(){
        User si = [select id, name from user where name = 'System Interface'];
        
        MPM4_BASE__Milestone1_Resource__c siRes = new MPM4_BASE__Milestone1_Resource__c(MPM4_BASE__user__c = si.id);
        insert siRes;
        
        MPM4_BASE__Milestone1_Resource__c cRes = new MPM4_BASE__Milestone1_Resource__c(MPM4_BASE__user__c = UserInfo.getUserID());
        insert cRes;
        
        MPM4_BASE__Milestone1_Project__c p = new MPM4_BASE__Milestone1_Project__c(name = 'test', ownerid = si.id);
        insert p; 
        
        MPM4_BASE__Milestone1_Milestone__c m = new MPM4_BASE__Milestone1_Milestone__c(MPM4_BASE__project__c = p.id, name = 'tm', ownerid = UserInfo.getUserID());
        insert m;
        
        MPM4_BASE__Milestone1_Task__c t = new MPM4_BASE__Milestone1_Task__c(name = 'tt', MPM4_BASE__project_milestone__c = m.id, MPM4_BASE__resource__c = cRes.id);
        insert t;
        
        
        ApexPages.StandardController stdC = new ApexPages.StandardController(p);
         MPM4_Custom_Owner_Update_Ctrl sc = new MPM4_Custom_Owner_Update_Ctrl(stdC);
        sc.project.ownerid = UserInfo.getuserID();
        sc.sendEmail = true;
        sc.updateToSystemInterface = true;
        sc.save();
        
        p = [select id, ownerid from MPM4_BASE__Milestone1_Project__c where id =: p.id];
        System.assert(p.ownerid == UserInfo.getuserID());
        
        
        m = [select id, ownerid from MPM4_BASE__Milestone1_Milestone__c where id =: m.id];
        System.assert(m.ownerid == si.id);
        
        t = [select id, MPM4_BASE__resource__c from MPM4_BASE__Milestone1_Task__c where id =: t.id];
        System.assert(t.MPM4_BASE__resource__c == siRes.id);
        
    }
}