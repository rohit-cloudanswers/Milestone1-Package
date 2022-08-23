/**
* @Author Raj Vooturi @ VOLO Solutions Inc.
* @Date 06/22/2014
* @Description Purpose is to help with account assignment .. on insert/ update - to use lead assignment and assign account owner
<br />
<b>- API Version ==> </b> 26
<b>- Details
    - insert or update
        - If insert then a) insert into lead, identify owner, capture for account, rollback and assign to account owner
**/
trigger AssignAccountOwnerTrigger on Account (before insert, before update) {
    /*for(Account acct:Trigger.New) {
        Account oldAcct = new Account();
        Lead ld = new Lead();         
        if(trigger.isUpdate) {
            oldAcct = Trigger.oldMap.get(acct.Id);

          
            
           
            if(!acct.RecordTypeId.equals(oldAcct.RecordTypeId)) {
                RecordType recType = [select name from RecordType where SobjectType = 'Account' and Id =: acct.RecordTypeId];
                String rectypename = String.ValueOf(recType.name);
                ld.Assgn_Account_RecType__c = rectypename;
            } else {
                RecordType recType = [select name from RecordType where SobjectType = 'Account' and Id =: oldAcct.RecordTypeId];
                String rectypename = String.ValueOf(recType.name);
                ld.Assgn_Account_RecType__c = rectypename;            
            }       
            if(!acct.name.equals(oldAcct.name)) {
                ld.Assgn_Account_Name__c = acct.name;
            } else {
                ld.Assgn_Account_Name__c = oldAcct.name;
            }    
            if (oldAcct.type != null) {
                if(!acct.type.equals(oldAcct.type)) {
                    ld.Assgn_Account_Type__c = acct.type;
                } else {
                    ld.Assgn_Account_Type__c = oldAcct.type;
                }  
            }  else {
                if (acct.type != null) {
                    ld.Assgn_Account_Type__c = acct.type;
                } else {
                    ld.Assgn_Account_Type__c = null;
                }    
            }
              
            if (oldAcct.Region_Channel_Partner__c != null) {   
                if (acct.Region_Channel_Partner__c == '' || acct.Region_Channel_Partner__c == null) {
                    system.debug ('111');
                    ld.Assgn_Account_Region__c =null;
                } else {
                    system.debug ('222');
                    if (!acct.Region_Channel_Partner__c.equals(oldAcct.Region_Channel_Partner__c)) {
                        system.debug ('222-111');
                        ld.Assgn_Account_Region__c = acct.Region_Channel_Partner__c;
                    }  else {
                        system.debug ('222-333');
                        ld.Assgn_Account_Region__c = oldAcct.Region_Channel_Partner__c;
                    }  
                }                        
            }  else {
                 system.debug ('000');
                if (acct.Region_Channel_Partner__c != null) { 
                    ld.Assgn_Account_Region__c = acct.Region_Channel_Partner__c;
                } else { 
                    ld.Assgn_Account_Region__c = null;
                }    
            }

            if (oldAcct.Sub_Region__c != null) {
                if(!acct.Sub_Region__c.equals(oldAcct.Sub_Region__c)) {
                    ld.Assgn_Account_SubRegion__c = acct.Sub_Region__c ;
                } else {
                    ld.Assgn_Account_SubRegion__c = oldAcct.Sub_Region__c ;
                }
            } else {
                if (acct.Sub_Region__c != null) {
                    ld.Assgn_Account_SubRegion__c = acct.Sub_Region__c ;
                } else {
                    ld.Assgn_Account_SubRegion__c = '' ;
                } 
            }
            if (oldAcct.BillingCountry != null) {
                if(!acct.BillingCountry.equals(oldAcct.BillingCountry)) {
                    ld.Assgn_Account_BillCtry__c = acct.BillingCountry ;
                } else {
                    ld.Assgn_Account_BillCtry__c = oldAcct.BillingCountry ;
                }
            } else {
                if (acct.BillingCountry != null) {
                    ld.Assgn_Account_BillCtry__c = acct.BillingCountry ;
                } else {
                    ld.Assgn_Account_BillCtry__c = '' ;
                } 
            }            
            system.debug ('acct.BillingCountry ' + acct.BillingCountry);
            system.debug ('oldAcct.BillingCountry ' + oldAcct.BillingCountry);
            system.debug ('ld.Assgn_Account_BillCtry__c ' + ld.Assgn_Account_BillCtry__c);            
            if (oldAcct.BillingState != null) {
                if(!acct.BillingState.equals(oldAcct.BillingState)) {
                    ld.Assgn_Account_BillState__c = acct.BillingState;
                } else {
                    ld.Assgn_Account_BillState__c = oldAcct.BillingState;
                }
            } else {
                 if (acct.BillingState != null) {
                     ld.Assgn_Account_BillState__c = acct.BillingState;
                 } else {    
                    ld.Assgn_Account_BillState__c = '';
                 }   
            } 
            if (oldAcct.ShippingState != null) {            
                if(!acct.ShippingState.equals(oldAcct.ShippingState)) {
                    ld.Assgn_Account_ShipState__c = acct.ShippingState;
                } else {
                    ld.Assgn_Account_ShipState__c = oldAcct.ShippingState;
                }
            } else {
                if (acct.ShippingState != null) { 
                    ld.Assgn_Account_ShipState__c = acct.ShippingState;
                } else {    
                    ld.Assgn_Account_ShipState__c = '';
                }    
            }
            if (oldAcct.BillingPostalCode != null) {              
                if(!acct.BillingPostalCode.equals(oldAcct.BillingPostalCode)) {
                    ld.Assgn_Account_BillZip__c = acct.BillingPostalCode;
                } else {
                    ld.Assgn_Account_BillZip__c = oldAcct.BillingPostalCode;
                }
            } else {
                if (acct.BillingPostalCode != null) { 
                    ld.Assgn_Account_BillZip__c = acct.BillingPostalCode;
                } else {    
                    ld.Assgn_Account_BillZip__c = '';
                }    
            }
            if (oldAcct.ShippingPostalCode != null) {              
                if(!acct.ShippingPostalCode.equals(oldAcct.ShippingPostalCode)) {
                    ld.Assgn_Account_ShipZip__c = acct.ShippingPostalCode;
                } else {
                    ld.Assgn_Account_ShipZip__c = oldAcct.ShippingPostalCode;
                }
            } else {
                if (oldAcct.ShippingPostalCode != null) {  
                    ld.Assgn_Account_ShipZip__c = acct.ShippingPostalCode;
                } else { 
                    ld.Assgn_Account_ShipZip__c = '';
                }
            }
            if (oldAcct.Sic != null) {              
                if(!acct.Sic.equals(oldAcct.Sic)) {
                    ld.Assgn_Account_Sic__c = acct.Sic;
                }   else {
                    ld.Assgn_Account_Sic__c = oldAcct.Sic;
                }  
            } else {
                if (oldAcct.Sic != null) { 
                    ld.Assgn_Account_Sic__c = acct.Sic;
                }   else {
                    ld.Assgn_Account_Sic__c = '';
                }    
            }
            
                                                                                                                                   
        }  

        if(trigger.isInsert) {
            RecordType recType = [select name from RecordType where SobjectType = 'Account' and Id =: acct.RecordTypeId]; 
            String rectypename = String.ValueOf(recType.name);
            ld.Assgn_Account_RecType__c = rectypename;
            ld.Assgn_Account_Name__c = acct.name;
            ld.Assgn_Account_Type__c = acct.type;
            ld.Assgn_Account_Region__c = acct.Region_Channel_Partner__c;
            ld.Assgn_Account_SubRegion__c = acct.Sub_Region__c ;
            ld.Assgn_Account_BillCtry__c = acct.BillingCountryCode;
            system.debug ('acct.BillingCountry ' + acct.BillingCountryCode);
            system.debug ('ld.Assgn_Account_BillCtry__c ' + ld.Assgn_Account_BillCtry__c);                 
            ld.Assgn_Account_BillState__c = acct.BillingState;
            ld.Assgn_Account_ShipCtry__c = acct.ShippingCountry;
            ld.Assgn_Account_ShipState__c = acct.ShippingState;
            ld.Assgn_Account_BillZip__c = acct.BillingPostalCode;
            ld.Assgn_Account_ShipZip__c = acct.ShippingPostalCode;
            ld.Assgn_Account_Sic__c = acct.Sic;
        }   
                       ld.company = 'bdfdfsssss';
                       ld.lastName = 'test123';
                       ld.status = 'New';
                       ld.City = 'whatever12';
                       ld.Country = 'United States of America';
                       ld.State = 'Texas';
                       ld.Street = 'sdkjhaskdjhasd';
                       ld.PostalCode = 'ddsfffdfdpostal';    
         system.debug('ld.Assgn_Account_RecType__c '+ ld.Assgn_Account_RecType__c); 
         system.debug('ld.Assgn_Account_Region__c '+ ld.Assgn_Account_Region__c);                        
        Savepoint sp = Database.setSavepoint();
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.assignmentRuleId= '01Qe0000000DIOV'; //Account Assign Rule(Indirect)DONOTDEL
        ld.setOptions(dmo);  
        insert ld;
        Lead ld2 = [select id, owner.name, owner.id  from lead where lead.id =: ld.id];
        string owner = ld2.owner.name; 
        system.debug('ld2.owner.name '+ ld2.owner.name);
        system.debug('ld2.owner.id '+ ld2.owner.id);       
        acct.ownerid = ld2.owner.id;
        Database.rollback(sp);  

    }*/
}