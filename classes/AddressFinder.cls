public with sharing class AddressFinder {

    @TestVisible
    public SObject toUpdate {get; private set;}
    @TestVisible
    public String nameField {get; private set;}
    public String addressField {get; set;}
    public Map<String, String> searchFields {get; set;}
    public String resultLimit {get; set;}
    public String addressId {get; set;}
    public String sObjectName {get; private set;}
    public List<SelectOption> addressFields {get; private set;}
    public String parentAccount {get; private set;}
    public Boolean newAddress {get; set;}
    public Address__c address {get; set;}
    
    public AddressFinder() {
        Id recId = ApexPages.currentPage().getParameters().get('recordId');
        if(String.isBlank(recId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a record first.'));
        } else {
            newAddress = false;
            parentAccount = ApexPages.currentPage().getParameters().get('parentAccount');
            addressField = ApexPages.currentPage().getParameters().get('address');
            // record details
            sObjectName = recId.getSobjectType().getDescribe().getName();
            nameField = getNameField(recId);
            addressFields = describeAddressFields(recId);
            toUpdate = getRecordToUpdate(recId, sObjectName, nameField, addressField);
            
            searchFields = new Map<String, String>();
            Set<String> fields = generateCSVFromFieldSets('Address__c', new Set<String>{'AddressFinder_Search_Fields'}, null);
            for(String field : fields) {
                searchFields.put(field, '');
            }
            resultLimit = '100';
        }
    }
    
    public List<Address__c> getAddresses() {
        String query = 'select ';
        Set<String> displayFields = generateCSVFromFieldSets('Address__c', new Set<String>{'AddressFinder_Display_Fields'}, null);
        // query fields to display
        query += String.join(new List<String>(displayFields), ',');
        query += ' from Address__c ';
        // build conditions
        List<String> conditions = new List<String>();
        for(String key : searchFields.keySet()) {
            String value = searchFields.get(key);
            if(String.isNotBlank(value)) {
                String condition = key + ' like \'%' + String.escapeSingleQuotes(value) + '%\'';
                conditions.add(condition);
            }
        }
        String filter = ' where Active__c = true ';
        if(String.isNotBlank(parentAccount)) filter += ' and Account_Service__c = \'' + String.escapeSingleQuotes(parentAccount) + '\'';
        if(!conditions.isEmpty()) {
            filter += ' and (' + String.join(conditions, ' or ') + ')';
        }
        // set result limit
        resultLimit = '100';
        query = (query + filter + ' limit ' + resultLimit);
        System.debug(query);
        // query data
        return Database.query(query);
    }
    
    public PageReference updateAddress() {
        toUpdate = getRecordToUpdate((String) toUpdate.get('Id'), sObjectName, nameField, addressField);
        toUpdate.put(addressField, addressId);
        System.assert(toUpdate.isSet(addressField) != null);
        update toUpdate;
        PageReference pageRef = new PageReference('/' + toUpdate.get('Id'));
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private SObject getRecordToUpdate(Id recId, String sObjectName, String nameField, String addressField) {
        SObject sObj = null;
        String query = 'select Id, ' + nameField;
        if(String.isNotBlank(addressField)) query += ', ' + addressField;
        query += ' from ' + sObjectName;
        query += ' where Id = :recId';
        List<SObject> sObjs = Database.query(query);
        if(sObjs.size() != 0) sObj = sObjs.get(0);
        return sObj;
    }
    
    public PageReference newAction() {
        newAddress = true;
        address = new Address__c();
        address.Account_Service__c = parentAccount;
        return null;
    }
    
    public PageReference saveAction() {
        try {
            insert address;
            addressId = address.Id;
            return updateAddress();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        } 
        return null;
    }
    
    public PageReference cancel(){
        if (newAddress) {
            newAddress = false;
            return null;
        }
        return new PageReference('/' + toUpdate.get('Id'));
    }
    
    public Set<String> generateCSVFromFieldSets(String sObjectName, Set<String> fieldSets, Set<String> additionalFields){
        Set<String> fields = new Set<String>{'id'};
        //describe the provided sObject
        Schema.DescribeSObjectResult res = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
        //get the fields set map
        Map<String, Schema.FieldSet> fieldSetMap = res.fieldSets.getMap();
		// add additional fields
        if(additionalFields != null) {
            for(String fs : additionalFields) {
                fields.add(fs);
            }
        }
        //iterate through provided fieldsets and generate query
        for(String fieldSetName : fieldSets){
            Schema.FieldSet fs = fieldSetMap.get(fieldSetName);
            for(Schema.FieldSetMember fsm : fs.getFields()) {
              	String fieldName = fsm.getFieldPath();
                fields.add(fieldName);
            }
        }
        return fields;
    }
    
    private String getNameField(String nameOrId){
        String nameField = null;
        Schema.SObjectType sObjType = getSObjectType(nameOrId);
        Schema.DescribeSObjectResult objectResult = sObjType.getDescribe();
        Map<String, Schema.SObjectField> objectFields = objectResult.fields.getMap();
        for(Schema.SObjectField objectField : objectFields.values()) {
            DescribeFieldResult fieldResult = objectField.getDescribe();
            if(fieldResult.isNameField()) {
                nameField = fieldResult.getName();
                break;
            }
        }
        return nameField;
	}
    
    private SObjectType getSObjectType(String nameOrId){
        Schema.SObjectType sObjType = null;
        if(nameOrId instanceof Id) {
            sObjType = ((Id) nameOrId).getSObjectType();
        } else {
            Type typeObj = Type.forName(nameOrId);
            SObject sObj = (SObject) typeObj.newInstance();
            sObjType = sObj.getSObjectType();
        }
        return sObjType;
    }
    
    private List<SelectOption> describeAddressFields(String nameOrId){
        List<SelectOption> addressFields = new List<SelectOption>();
        Schema.SObjectType sObjType = getSObjectType(nameOrId);
        Schema.DescribeSObjectResult objectResult = Address__c.sObjectType.getDescribe();
        List<ChildRelationship> relationships = objectResult.getChildRelationships();
        for(ChildRelationship relationship : relationships) {
            if(relationship.getChildSObject() == sObjType) {
                DescribeFieldResult fieldResult = relationship.getField().getDescribe();
                addressFields.add(new SelectOption(
                    fieldResult.getName(),
                    fieldResult.getLabel()
                ));
            }
        }
        return addressFields;
    }
}