trigger trigger_ServiceContract on ServiceContract (before insert) {
    //no helper class because only one method would be called
    //can be moved to helper class if need arises
    
    //get serviceContracts with a Business_Hours_Integration__c value and map that value to the BH id in the BH temp store
    
    //get default businesshours
    Id defaultBusinessHours = null;

    try{
        ServiceCloudSettings__c bhs = ServiceCloudSettings__c.getValues('DefaultBusinessHours');
        defaultBusinessHours = bhs.value__c;
    } catch (exception e){
        list<BusinessHours> defaultHoursList = [select Id from BusinessHours where IsDefault=true];
        if(defaultHoursList.size()>0){
            defaultBusinessHours = defaultHoursList[0].Id;
        }
    }
    
    //get bh temp store
    list<BusinessHourTempStore__c > bhts = [SELECT Business_Hours_ID__c,Integration_Id__c, IsDefault__c  FROM BusinessHourTempStore__c 
                                                WHERE Business_Hours_ID__c != null AND Integration_Id__c != null];
    map<string,string> bhTempBHID = new map<string,string>();
    
    for(BusinessHourTempStore__c bht : bhts){
        bhTempBHID.put(bht.Integration_Id__c, bht.Business_Hours_ID__c);
        if(bht.IsDefault__c)
            defaultBusinessHours = bht.Business_Hours_ID__c;
    }
    
    //loop through ServiceContracts and apply businessHours
    for(ServiceContract sc : trigger.new){
        if(sc.Business_Hours_Integration__c != null){
            if(bhTempBHID.containsKey(sc.Business_Hours_Integration__c)){
                sc.Business_Hours__c = bhTempBHID.get(sc.Business_Hours_Integration__c);
            } else {
                sc.Business_Hours__c = defaultBusinessHours;
            }
        } else {
            sc.Business_Hours__c = defaultBusinessHours;
        }
    }
    
}