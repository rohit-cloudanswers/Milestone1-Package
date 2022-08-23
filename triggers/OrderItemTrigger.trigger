trigger OrderItemTrigger on OrderItem (before delete) {
    OrderItemTriggerHandler.beforeDelete(Trigger.old);
}