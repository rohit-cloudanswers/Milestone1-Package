/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class blogic_AccountTest {


    static testMethod void myUnitTest() {
        //TEST
        //    That when Accounts are added, they inherit their parents Top_Level_Parent_Account
        test.startTest();
        list<Account> AllAccounts=data.staticHierarchy;
        test.stopTest();
        Account hTop=data.top;
        map<id,Account> resultingAccounts=new map<id,Account>([Select id, name, parentid, Top_Level_Parent_Account__c from Account]);
        //All Descendants of the Top of Hierarchy
        list<Account> descendants=blogic_Account.getChildren(hTop.id,resultingAccounts.values());
        for(Account a : descendants){
            system.debug('***positive test decendant:'+a.name);
            system.assertEquals(hTop.id,resultingAccounts.get(a.id).Top_Level_Parent_Account__c);
        }
    }
    
    //IGNORE TO BE REMOVED
    static testMethod void testHierarchy(){
        return;
        list<Account> TopLevel = data.buildTopLevel(1);
        data.buildAccountHierarchy(TopLevel[0],3,2);
        list<Account> resAccts = [Select id, name from Account];
        system.debug('***Actual Accounts: '+resAccts.size());
        for(Account a : resAccts){
            system.debug('Account Name: '+a.name);
        }
    }
    
    static testMethod void testChange(){
        //Test
        //    With An existing Heirarchy, Change one of its descendant's parentID to another TOP Account
        //        Result will be the Descendants and all of its descendants will have the new TOP Account
        //        Descendants from another branch of the tree will not be affected.
        list<Account> AllAccounts=data.staticHierarchy;
        Account OriginalTopAccount=data.Top;
        Account TestTopAccount = new Account(name='NEW TOP');
        insert TestTopAccount;
        test.startTest();
        Account TestAccount = data.Childp1;
        TestAccount.parentId=TestTopAccount.id;
        update TestAccount;
        test.stopTest();
        map<id,Account> resultingAccounts=new map<id,Account>([Select id, name, parentid, Top_Level_Parent_Account__c from Account]);
        system.assertEquals(TestTopAccount.id,resultingAccounts.get(TestAccount.id).Top_Level_Parent_Account__c);
        list<Account> descendants=blogic_Account.getChildren(testAccount.id,resultingAccounts.values());
        for(Account a : descendants){
            system.debug('***positive test decendant:'+a.name);
            system.assertEquals(TestTopAccount.id,resultingAccounts.get(a.id).Top_Level_Parent_Account__c);
        }
        //Test to make sure branches from another limb didn't get changed
        Account testUncle=data.Parent2;
        list<Account> nondescendants=blogic_Account.getChildren(testUncle.id,resultingAccounts.values());
        for(Account a : nondescendants){
            system.debug('***negative test decendant:'+a.name);
            system.assertEquals(OriginalTopAccount.id,resultingAccounts.get(a.id).Top_Level_Parent_Account__c);
        }
    }

    static testMethod void testChangeTop(){
        //TEST
        //    An existing TOP Account with children is added to another's hierarchy
        //        Resulting in the Existing Top Account's TopLevelParentAccount to be the TOP Level in the new hierarchy
        //        Its children also inherit the new TopLevelParentAccount
        list<Account> AllAccounts=data.staticHierarchy;
        Account OriginalTopAccount=data.Top;
        Account TestTopAccount = new Account(name='NEW TOP');
        insert TestTopAccount;
        Account TestChild = new Account(name='NEW TEST CHILD',parentId=TestTopAccount.id);
        insert TestChild;
        Account resTestChild=[Select id, Top_Level_Parent_Account__c from account where id = :testChild.id];
        //just verify testChilds TopLevel
        system.assertEquals(testTopAccount.id,resTestChild.Top_Level_Parent_Account__c);
        test.startTest();
        //Change the test top to a child of Original
        TestTopAccount.parentid=OriginalTopAccount.id;
        update testTopAccount;
        test.stopTest();
        map<id,Account> resultingAccounts=new map<id,Account>([Select id, name, parentid, Top_Level_Parent_Account__c from Account]);
        
        system.assertEquals(OriginalTopAccount.id,resultingAccounts.get(TestTopAccount.id).Top_Level_Parent_Account__c);
        
        list<Account> descendants=blogic_Account.getChildren(TestTopAccount.id,resultingAccounts.values());
        for(Account a : descendants){
            system.debug('***positive test decendant:'+a.name);
            //system.assertEquals(OriginalTopAccount.id,resultingAccounts.get(a.id).Top_Level_Parent_Account__c);
        }
    }
    static testMethod void testChangeChildToTop(){
        //Test
        //  The Child Account is changed to a Top Account.
        //      Resulting TopLevelParentAccount should be null
        //      All of its Decendants will now have this NEW top as its TopLevelParentAccount
        list<Account> AllAccounts=data.staticHierarchy;
        Account OriginalTopAccount=data.Top;
        Account TestTopAccount = new Account(name='NEW TOP');
        insert TestTopAccount;
        test.startTest();
        Account TestAccount = data.Parent1;
        TestAccount.parentId=null;
        update TestAccount;
        test.stopTest();
        map<id,Account> resultingAccounts=new map<id,Account>([Select id, name, parentid, Top_Level_Parent_Account__c from Account]);
        //system.assertEquals(null,resultingAccounts.get(TestAccount.id).Top_Level_Parent_Account__c);
        list<Account> descendants=blogic_Account.getChildren(testAccount.id,resultingAccounts.values());
        for(Account a : descendants){
            system.debug('***positive test decendant:'+a.name);
            //system.assertEquals(TestAccount.id,resultingAccounts.get(a.id).Top_Level_Parent_Account__c);
        }
    }
    static testMethod void testBulkChange(){
        //Test
        //  Update 200 Children (one of which has a child) of a Parent Account in existing Hierarchy to the Test TOP Account
        //      Resulting No Limits Exceptions
        //      All 200 and the one ones Decendant will now have this NEW top as its TopLevelParentAccount
        list<Account> AllAccounts=data.staticHierarchy;
        Account OriginalTopAccount=data.Top;
        Account TestTopAccount = new Account(name='NEW TOP');
        insert TestTopAccount;
        Account TestAccount=data.parent1;
        list<Account> testChildren=data.addChildren(TestAccount,200);
        Account randomChild=testChildren[50];
        Account randomChildChild=new Account(name='Random',parentid=randomChild.id);
        insert randomChildChild;
        test.startTest();
        for(Account a : testChildren){
            a.parentid=TestTopAccount.id;
        }
        update testChildren;
        test.stopTest();
        map<id,Account> resultingAccounts=new map<id,Account>([Select id, name, parentid, Top_Level_Parent_Account__c from Account]);
        for(Account a : testChildren){
            system.debug('***positive test decendant:'+a.name);
            system.assertEquals(TestTopAccount.id,resultingAccounts.get(a.id).Top_Level_Parent_Account__c);
        }
        list<Account> descendants=blogic_Account.getChildren(randomChild.id,resultingAccounts.values());
        system.assertNotEquals(0,descendants.size());
        for(Account a : descendants){
            system.debug('***positive test decendant:'+a.name);
            system.assertEquals(TestTopAccount.id,resultingAccounts.get(a.id).Top_Level_Parent_Account__c);
        }
        
    }

}