public class CalculateOrderRollups {

    @InvocableMethod(label='Recalculate Order Rollups' description='recalculate order rollups')
    public static void performRollupCalculations(List<Id> orderIds) {
        List<Order> orders = [
            select Id, MPM4_Project__c
            from Order 
            where Id IN: orderIds and MPM4_Project__c != null
        ];
        Set<Id> projectIds = new Set<Id>();
        for (Order o : orders) {
            projectIds.add(o.MPM4_Project__c);
        }
        Map<Id, OrderItem> orderItemsMap = new Map<Id, OrderItem>([
            select Id, OrderId
            from OrderItem
            where OrderId in (select Id from Order where MPM4_Project__c in :projectIds and MPM4_Project__c != null)
        ]);
        // do rollup calculations
        blogic_OrderItem.doRollupCalculations(orderItemsMap);
    }
}