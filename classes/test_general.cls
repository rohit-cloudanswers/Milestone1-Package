@isTest
public class test_general {
    public static testmethod void testquotesolutionWrapper(){
        QuoteSolutionWrapper qsw = new QuoteSolutionWrapper();
        qsw.selected = true;
        qsw.displayName = 'test';
        qsw.qs = null;
    }
    public static testmethod void testdeployfix(){
        integer i = 0;
        i = temp_deployFix.deployFix();
    }
}