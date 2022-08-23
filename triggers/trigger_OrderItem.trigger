trigger trigger_OrderItem on OrderItem (before insert, before update, after insert, after update) {
    //ensure that a pricebookentry is created for all incoming orderItems
  if(trigger.isBefore){  
    if(trigger.isInsert){
      blogic_OrderItem.addDummyPriceBookEntry(trigger.new);
      for(OrderItem oi : trigger.new){
        if(oi.Quantity == 0){
          oi.Quantity = 1;
        }
      }
    } 
    else if(trigger.isUpdate){
      for(OrderItem oi : trigger.newMap.values()){
        if(oi.Quantity == 0){
          oi.Quantity = trigger.oldMap.get(oi.id).quantity;
        }
      }
    }
  }
  else if(trigger.isAfter){
    if(trigger.isInsert || trigger.isUpdate){
      blogic_OrderItem.doRollupCalculations(trigger.newMap);
    }
  }
}