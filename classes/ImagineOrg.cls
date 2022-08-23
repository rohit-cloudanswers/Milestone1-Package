public without sharing class ImagineOrg {

    private static Organization org;
    
    static {
        org = [
            select Id , Name, InstanceName, IsSandbox
            from Organization
            limit 1
        ];
    }
    
    public static Object get(String field){
        Object res = null;
        if(org != null && org.isSet(field)) {
            res = org.get(field);
        }
        return res;
    }
}