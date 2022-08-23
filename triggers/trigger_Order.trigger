trigger trigger_Order on Order (before insert,after insert, before update, after update, after delete, after undelete) {
     
    if(trigger.isInsert){
        if(trigger.isBefore){
            system.debug('trigger.newMap is : '+trigger.newMap);
            blogic_Order.populateAddress(trigger.new, null);
        } else {
           blogic_Order.populateOracleOrderNumber(trigger.newMap, null);
        }
     }else if(trigger.isUpdate){
        if(trigger.isBefore){
            blogic_Order.populateAddress(trigger.new, Trigger.oldMap);
            blogic_Order.populateSupplyPriority(Trigger.oldMap, Trigger.new);
        }else{
            system.debug('After update :'+trigger.newMap);
           blogic_Order.populateOracleOrderNumber(trigger.newMap, trigger.oldMap); 
           blogic_Order.ensureProjectRollups(trigger.newMap, trigger.oldMap);
        }
     } else if(trigger.isDelete){
         blogic_Order.ensureProjectRollups(null,trigger.oldMap);
     } else if(trigger.isUnDelete){
         blogic_Order.ensureProjectRollups(trigger.newMap,null);
     }

}