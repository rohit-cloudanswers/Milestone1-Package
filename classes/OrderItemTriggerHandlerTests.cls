@IsTest
public class OrderItemTriggerHandlerTests {
	@IsTest
    public static void testBeforeDelete () {
        OrderItemTriggerHandler.beforeDelete(
            new List<OrderItem>{
                new OrderItem()
            }
      	);
    }
}