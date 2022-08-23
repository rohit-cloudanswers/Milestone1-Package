public class MPM4_Custom_Trigger_Utility {
    public static void handleTimeBeforeTrigger(List<MPM4_BASE__Milestone1_Time__c> newRecs){
        
        if(Trigger.isBefore && (MPM4_BASE__Milestone1_Settings__c.getOrgDefaults().MPM4_BASE__disable_triggers__c == false)){ 
            Map<Id, MPM4_BASE__Milestone1_Time__c> timeByUserID = new Map<Id, MPM4_BASE__Milestone1_Time__c>();
            Map<Id, MPM4_BASE__Milestone1_Time__c> timeByResourceID = new Map<Id, MPM4_BASE__Milestone1_Time__c>();
            
            for(MPM4_BASE__Milestone1_Time__c rec : newRecs){
                if(rec.MPM4_BASE__incurred_by__c != null && rec.MPM4_BASE__Incurred_By_Resource__c == null){ 
                    timeByUserID.put(rec.MPM4_BASE__incurred_by__c, rec);
                } else if (rec.MPM4_BASE__Incurred_By_Resource__c != null){
                    timeByResourceID.put(rec.MPM4_BASE__Incurred_By_Resource__c, rec);
                } 
            }
            
            if(timeByUserID.keyset().size() > 0){
                for(MPM4_BASE__Milestone1_Resource__c res : [Select id, MPM4_BASE__User__c from MPM4_BASE__Milestone1_Resource__c where MPM4_BASE__User__c in :timeByUserID.keyset()]){
                    timeByUserID.get(res.MPM4_BASE__User__c).MPM4_BASE__Incurred_By_Resource__c = res.id;
                }
            } 
            if(timeByResourceID.keyset().size() > 0){
                for(MPM4_BASE__Milestone1_Resource__c res : [Select id, MPM4_BASE__User__c from MPM4_BASE__Milestone1_Resource__c where id in :timeByResourceID.keyset()]){
                    timeByResourceID.get(res.id).MPM4_BASE__incurred_by__c = res.MPM4_BASE__User__c;
                }
            }
        }  
    } 
    
    public static void handleProjResBeforeTrigger(List<MPM_Project_Resource__c> newRecs){
        
        if(Trigger.isBefore && (MPM4_BASE__Milestone1_Settings__c.getOrgDefaults().MPM4_BASE__disable_triggers__c == false)){ 
            
            Set<ID> userIds = new Set<ID>();
            Set<ID> contactIds = new Set<ID>();
            
            for(MPM_Project_Resource__c junctionRec : newRecs){
                if(junctionRec.contact__c != null){
                    contactIds.add(junctionRec.contact__c);
                } else if (junctionRec.user__c != null){
                    userIds.add(junctionRec.user__c);
                }
            }
            
            Map<Id, Id> userOrContactIDByResourceID = new Map<Id, Id>();
            
            for(MPM4_BASE__Milestone1_Resource__c res :[SELECT Id, Name, MPM4_BASE__User__c, MPM4_BASE__Contact__c FROM MPM4_BASE__Milestone1_Resource__c WHERE MPM4_BASE__User__c IN :userIds OR MPM4_BASE__Contact__c IN: contactIds] ){
                userOrContactIDByResourceID.put( res.MPM4_BASE__User__c != null ? res.MPM4_BASE__User__c : res.MPM4_BASE__Contact__c, res.id);
            }
             

            Map<MPM_Project_Resource__c, MPM4_BASE__Milestone1_Resource__c> juncToMissingRes = new Map<MPM_Project_Resource__c, MPM4_BASE__Milestone1_Resource__c>();
            
            for(MPM_Project_Resource__c junctionRec : newRecs){
                ID existingRes = userOrContactIDByResourceID.get(junctionRec.user__c != null ? junctionRec.user__c : junctionRec.contact__c);
                if(existingRes != null){
                    junctionRec.resource__c = existingRes;
                } else {
                    MPM4_BASE__Milestone1_Resource__c singleMissingRes = new MPM4_BASE__Milestone1_Resource__c();
                    if(junctionRec.contact__c != null){
                        singleMissingRes.MPM4_BASE__contact__c = junctionRec.contact__c;
                    } else if (junctionRec.user__c != null){
                        singleMissingRes.MPM4_BASE__user__c = junctionRec.user__c;
                    } 
                    juncToMissingRes.put(junctionRec, singleMissingRes);
                }
            }
            

            insert juncToMissingRes.values();
            
            for(MPM_Project_Resource__c junctionRec : juncToMissingRes.keySet()){
                junctionRec.resource__c = juncToMissingRes.get(junctionRec).id;
            }
        }  
    } 
 
}