public class DescribeUtil {
    
    public static final Set<String> SUPPORT_PACKAGES = new Set<String>{
        'Support Package Care',
		'Support Package Care+',
		'Support Package Care+U'
    };
        
    public static List<Product2> getSupportPackages() {
        return [
            select Id, ProductCode
            from Product2
            where ProductCode in :SUPPORT_PACKAGES
        ];
    }
    
    /**
     * Returns a list of the name of the fields accessible to current user.
     */
    public static List<String> getSObjectFieldNames(String sObjectName) {
        List<String> fieldNames = new List<String>();
        Type t = Type.forName(sObjectName);
        DescribeSObjectResult objResult = ((SObject) t.newInstance()).getSObjectType().getDescribe();
        Map<String, Schema.SObjectField> objFields = objResult.fields.getMap();
        for (String fieldName : objFields.keySet()) {
            DescribeFieldResult fieldResult = objFields.get(fieldName).getDescribe();
            if (fieldResult.isAccessible()) {
                fieldNames.add(fieldResult.getName());
            }
        }
        return fieldNames;
    }
}