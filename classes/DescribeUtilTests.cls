@isTest
public class DescribeUtilTests {

    @isTest
    static void shouldGetSObjectFieldNames() {
        Test.startTest();
        List<String> fieldNames = DescribeUtil.getSObjectFieldNames('Account');
        Test.stopTest();
        System.assert(!fieldNames.isEmpty());
    }
}