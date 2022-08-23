public class OrderItemTriggerHandler {
    public static void beforeDelete (List<OrderItem> triggerOld) {
        for (OrderItem oi : triggerOld) {
            if (String.isNotBlank(oi.Delete_Blocker__c)) {
                oi.addError(oi.Delete_Blocker__c);
            }
        }
    }
}