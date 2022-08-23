/**
* @Author Raj Vooturi @ VOLO Solutions Inc.
* @Date 06/22/2014
* @Description Purpose is to help with opportunity assignment .. on insert/ update - to use lead assignment and assign opportunity owner
<br />
<b>- API Version ==> </b> 26
<b>- Details
    - insert or update
        - If insert then a) insert into lead, identify owner, capture for opportunity, rollback and assign to oportunity owner
**/
trigger AssignOpptyOwnerTrigger on Opportunity (before insert, before update) {
   for(Opportunity oppty:Trigger.New) {
       Opportunity oldOppty = new Opportunity();
       Lead ld = new Lead();     
       if(trigger.isUpdate) {

            if(!oppty.Account.RecordTypeId.equals(oldOppty.Account.RecordTypeId)) {
                RecordType recType = [select name from RecordType where SobjectType = 'Account' and Id =: oppty.Account.RecordTypeId];
                String rectypename = String.ValueOf(recType.name);
                ld.Assgn_Account_RecType__c = rectypename;
            } else {
                RecordType recType = [select name from RecordType where SobjectType = 'Account' and Id =: oldOppty.Account.RecordTypeId];
                String rectypename = String.ValueOf(recType.name);
                ld.Assgn_Account_RecType__c = rectypename;            
            }       
            if(!oppty.Account.name.equals(oldOppty.Account.name)) {
                ld.Assgn_Account_Name__c = oppty.Account.name;
            } else {
                ld.Assgn_Account_Name__c = oldOppty.Account.name;
            }    
            if (oldOppty.Account.type != null) {
                if(!oppty.Account.type.equals(oldOppty.Account.type)) {
                    ld.Assgn_Account_Type__c = oppty.Account.type;
                } else {
                    ld.Assgn_Account_Type__c = oldOppty.Account.type;
                }  
            }  else {
                if (oppty.Account.type != null) {
                    ld.Assgn_Account_Type__c = oppty.Account.type;
                } else {
                    ld.Assgn_Account_Type__c = null;
                }    
            }
              
            if (oldOppty.Account.Region_Channel_Partner__c != null) {   
                if (oppty.Account.Region_Channel_Partner__c == '' || oppty.Account.Region_Channel_Partner__c == null) {
                    system.debug ('111');
                    ld.Assgn_Account_Region__c =null;
                } else {
                    system.debug ('222');
                    if (!oppty.Account.Region_Channel_Partner__c.equals(oldOppty.Account.Region_Channel_Partner__c)) {
                        system.debug ('222-111');
                        ld.Assgn_Account_Region__c = oppty.Account.Region_Channel_Partner__c;
                    }  else {
                        system.debug ('222-333');
                        ld.Assgn_Account_Region__c = oldOppty.Account.Region_Channel_Partner__c;
                    }  
                }                        
            }  else {
                 system.debug ('000');
                if (oppty.Account.Region_Channel_Partner__c != null) { 
                    ld.Assgn_Account_Region__c = oppty.Account.Region_Channel_Partner__c;
                } else { 
                    ld.Assgn_Account_Region__c = null;
                }    
            }

            if (oldOppty.Account.Sub_Region__c != null) {
                if(!oppty.Account.Sub_Region__c.equals(oldOppty.Account.Sub_Region__c)) {
                    ld.Assgn_Account_SubRegion__c = oppty.Account.Sub_Region__c ;
                } else {
                    ld.Assgn_Account_SubRegion__c = oldOppty.Account.Sub_Region__c ;
                }
            } else {
                if (oppty.Account.Sub_Region__c != null) {
                    ld.Assgn_Account_SubRegion__c = oppty.Account.Sub_Region__c ;
                } else {
                    ld.Assgn_Account_SubRegion__c = '' ;
                } 
            }
            if(!oppty.Account.BillingCountry.equals(oldOppty.Account.BillingCountry)) {
                ld.Assgn_Account_BillCtry__c = oppty.Account.BillingCountry;
            } else {
                ld.Assgn_Account_BillCtry__c = oldOppty.Account.BillingCountry;
            }
            system.debug ('oppty.Account.BillingCountry ' + oppty.Account.BillingCountry);
            system.debug ('oldOppty.Account.BillingCountry ' + oldOppty.Account.BillingCountry);
            system.debug ('ld.Assgn_Account_BillCtry__c ' + ld.Assgn_Account_BillCtry__c);            
            if (oldOppty.Account.BillingState != null) {
                if(!oppty.Account.BillingState.equals(oldOppty.Account.BillingState)) {
                    ld.Assgn_Account_BillState__c = oppty.Account.BillingState;
                } else {
                    ld.Assgn_Account_BillState__c = oldOppty.Account.BillingState;
                }
            } else {
                 if (oppty.Account.BillingState != null) {
                     ld.Assgn_Account_BillState__c = oppty.Account.BillingState;
                 } else {    
                    ld.Assgn_Account_BillState__c = '';
                 }   
            }    
            
            if(!oppty.Account.ShippingCountry.equals(oldOppty.Account.ShippingCountry)) {
                ld.Assgn_Account_ShipCtry__c = oppty.Account.ShippingCountry;
            } else {
                ld.Assgn_Account_ShipCtry__c = '';
            }
            if (oldOppty.Account.ShippingState != null) {            
                if(!oppty.Account.ShippingState.equals(oldOppty.Account.ShippingState)) {
                    ld.Assgn_Account_ShipState__c = oppty.Account.ShippingState;
                } else {
                    ld.Assgn_Account_ShipState__c = oldOppty.Account.ShippingState;
                }
            } else {
                if (oppty.Account.ShippingState != null) { 
                    ld.Assgn_Account_ShipState__c = oppty.Account.ShippingState;
                } else {    
                    ld.Assgn_Account_ShipState__c = '';
                }    
            }
            if (oldOppty.Account.BillingPostalCode != null) {              
                if(!oppty.Account.BillingPostalCode.equals(oldOppty.Account.BillingPostalCode)) {
                    ld.Assgn_Account_BillZip__c = oppty.Account.BillingPostalCode;
                } else {
                    ld.Assgn_Account_BillZip__c = oldOppty.Account.BillingPostalCode;
                }
            } else {
                if (oppty.Account.BillingPostalCode != null) { 
                    ld.Assgn_Account_BillZip__c = oppty.Account.BillingPostalCode;
                } else {    
                    ld.Assgn_Account_BillZip__c = '';
                }    
            }
            if (oldOppty.Account.ShippingPostalCode != null) {              
                if(!oppty.Account.ShippingPostalCode.equals(oldOppty.Account.ShippingPostalCode)) {
                    ld.Assgn_Account_ShipZip__c = oppty.Account.ShippingPostalCode;
                } else {
                    ld.Assgn_Account_ShipZip__c = oldOppty.Account.ShippingPostalCode;
                }
            } else {
                if (oldOppty.Account.ShippingPostalCode != null) {  
                    ld.Assgn_Account_ShipZip__c = oppty.Account.ShippingPostalCode;
                } else { 
                    ld.Assgn_Account_ShipZip__c = '';
                }
            }
            if (oldOppty.Account.Sic != null) {              
                if(!oppty.Account.Sic.equals(oldOppty.Account.Sic)) {
                    ld.Assgn_Account_Sic__c = oppty.Account.Sic;
                }   else {
                    ld.Assgn_Account_Sic__c = oldOppty.Account.Sic;
                }  
            } else {
                if (oldOppty.Account.Sic != null) { 
                    ld.Assgn_Account_Sic__c = oppty.Account.Sic;
                }   else {
                    ld.Assgn_Account_Sic__c = '';
                }    
            }

            //ld.Assgn_Oppty_BillCtry__c = oppty.Billing_Country__c;
            //ld.Assgn_Oppty_ShipCtry__c  =  oppty.Shipping_Country__c;  
            if (oldOppty.Billing_Country__c != null) {              
                if(!oppty.Billing_Country__c.equals(oldOppty.Billing_Country__c)) {
                    ld.Assgn_Oppty_BillCtry__c = oppty.Billing_Country__c;
                }   else {
                    ld.Assgn_Oppty_BillCtry__c = oldOppty.Billing_Country__c;
                }  
            } else {
                if (oldOppty.Billing_Country__c != null) { 
                    ld.Assgn_Oppty_BillCtry__c = oppty.Billing_Country__c;
                }   else {
                    ld.Assgn_Oppty_BillCtry__c = '';
                }    
            } 
            if (oldOppty.Shipping_Country__c != null) {              
                if(!oppty.Shipping_Country__c.equals(oldOppty.Shipping_Country__c)) {
                    ld.Assgn_Oppty_ShipCtry__c = oppty.Shipping_Country__c;
                }   else {
                    ld.Assgn_Oppty_ShipCtry__c = oldOppty.Shipping_Country__c;
                }  
            } else {
                if (oldOppty.Shipping_Country__c != null) { 
                    ld.Assgn_Oppty_ShipCtry__c = oppty.Shipping_Country__c;
                }   else {
                    ld.Assgn_Oppty_ShipCtry__c = '';
                }    
            }             
       }
       if(trigger.isInsert) {
            RecordType recType = [select name from RecordType where SobjectType = 'Opportunity' and Id =: oppty.RecordTypeId]; 
            String rectypename = String.ValueOf(recType.name);
            ld.Assgn_Oppty_Rec_Type__c = rectypename;
            
            ld.Assgn_Account_Name__c = oppty.Account.name;      
            RecordType accrecType = [select name from RecordType where SobjectType = 'Account' and Id =: oppty.Account.RecordTypeId]; 
            String accrectypename = String.ValueOf(accrecType.name);
            ld.Assgn_Account_RecType__c = accrectypename;
            ld.Assgn_Account_Type__c = oppty.Account.type;
            ld.Assgn_Account_Region__c = oppty.Account.Region_Channel_Partner__c;
            ld.Assgn_Account_SubRegion__c = oppty.Account.Sub_Region__c ;
            ld.Assgn_Account_BillCtry__c = oppty.Account.BillingCountryCode;
            system.debug ('acct.BillingCountry ' + oppty.Account.BillingCountryCode);
            system.debug ('ld.Assgn_Account_BillCtry__c ' + ld.Assgn_Account_BillCtry__c);                 
            ld.Assgn_Account_BillState__c = oppty.Account.BillingState;
            ld.Assgn_Account_ShipCtry__c = oppty.Account.ShippingCountryCode;
            ld.Assgn_Account_ShipState__c = oppty.Account.ShippingState;
            ld.Assgn_Account_BillZip__c = oppty.Account.BillingPostalCode;
            ld.Assgn_Account_ShipZip__c = oppty.Account.ShippingPostalCode;
            ld.Assgn_Account_Sic__c = oppty.Account.Sic;       

            //ld.Assgn_Oppty_LOB__c  =
            //ld.Assgn_Oppty_Pgroup__c =   
            ld.Assgn_Oppty_BillCtry__c = oppty.Billing_Country__c;
            ld.Assgn_Oppty_ShipCtry__c  =  oppty.Shipping_Country__c;        
       }

       ld.company = 'bdfdfsssss';
       ld.lastName = 'test123';
       ld.status = 'New';
       ld.City = 'whatever12';
       ld.Country = 'United States of America';
       ld.State = 'Texas';
       ld.Street = 'sdkjhaskdjhasd';
       ld.PostalCode = 'ddsfffdfdpostal';          
       Savepoint sp = Database.setSavepoint();
       Database.DMLOptions dmo = new Database.DMLOptions();
       dmo.assignmentRuleHeader.assignmentRuleId= '01Qe0000000DIOp'; 
       ld.setOptions(dmo);  
       insert ld;       

       Lead ld2 = [select id, owner.name, owner.id  from lead where lead.id =: ld.id];  
       string owner = ld2.owner.name; 
       system.debug('ld2.owner.name '+ ld2.owner.name);
       system.debug('ld2.owner.id '+ ld2.owner.id);
       oppty.ownerid = ld2.owner.id;        
       Database.rollback(sp);      
   }              
}