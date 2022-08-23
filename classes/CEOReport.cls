public class CEOReport {
    
    public class Row {
        public String region {get; private set;}
        public String subRegion {get; private set;}
        public String rsm {get; private set;}
        public String leadManager {get; private set;}
        public String segment {get; private set;}
        public String accountId {get; private set;}
        public String accountOwnerId {get; private set;}
        public String accountName {get; private set;}
        public Date accountLastActivityDate {get; private set;}
        public String accountLastActivitySubject {get; private set;}
        public Customer_Performance__c[] customerPerformances {get; private set;}
        public Decimal customerPerformancesTotal {get; private set;}
        public Opportunity[] opps {get; private set;}
        public Decimal oppsOpenCount {get; private set;}
        public Decimal oppsOpenAmount {get; private set;}
        public Task newTask {get; set;}
        public void save () {
            insert newTask;
        }
        public Row(Account a) {
            newTask = new Task(WhatId=a.Id, Status='Completed');
            Row r = this;
            r.accountId = a.Id;
            r.accountName = String.isNotBlank(a.Customer_Performance_Report_Name__c) ? a.Customer_Performance_Report_Name__c : a.Name;
            r.accountOwnerId = a.OwnerId;
            r.region = a.Bill_To_Region__c;
            r.segment = a.Segment__c;
            r.subRegion = a.Bill_To_Sub_Region__c;
            r.rsm = a.Owner.Name;
            r.leadManager = a.Lead_Manager__r.Name;
            r.opps = a.Opportunities;
            r.oppsOpenCount = 0;
            r.oppsOpenAmount = 0;
            r.customerPerformances = a.Customer_Performance__r;
            if (a.ActivityHistories != null && !a.ActivityHistories.isEmpty()) {
                r.accountLastActivityDate = a.ActivityHistories[0].ActivityDate;
                r.accountLastActivitySubject = a.ActivityHistories[0].Subject;
            }
            if (r.opps != null)
            for (Opportunity o : r.opps) {
                r.oppsOpenCount++;
                r.oppsOpenAmount += (o.Amount != null ? o.Amount : 0);
            }
            if (r.customerPerformances == null) {
                r.customerPerformances = new Customer_Performance__c[]{};
            }
        }
    }
    
    public Integer[] years {get; private set;}
    public String searchString {get; set;}
    public String ownerIdFilter {get; set;}
    public SelectOption[] ownerOptions {get; set;}
    public String leadManagerFilter {get; set;}
    public SelectOption[] leadManagerOptions {get; set;}
    public String regionFilter {get; set;}
    public SelectOption[] regionOptions {get; set;}
    public String roleFilter {get; set;}
    public SelectOption[] roleOptions {get; set;}
    public Boolean[] yearToggle {get; set;}
    
    public CEOReport () {
        years = new Integer[]{0, 1, 2};
        yearToggle = new Boolean[]{false, false, false};
    }

    public void onload () {
        loadOptions();
        
        // if your user id is an RSM option, you want to default to your data only
        for (SelectOption so : ownerOptions) {
            if (so.getValue() == UserInfo.getUserId()) {
                ownerIdFilter = so.getValue();
                break;
            }
        }

        // default to top level (ceo)
        roleFilter = roleOptions[0].getValue();
    }

    public void loadOptions() {
        Map<String, Id> owners = new Map<String, Id>();
        Map<String, Id> leadManagers = new Map<String, Id>();
        Set<String> regions = new Set<String>();
        String profileName = [select Name from Profile where Id = :UserInfo.getProfileId()].Name;
        User[] users = usersUnderMe();
        for (AggregateResult ar : (AggregateResult[])Database.query(
            'select OwnerId, Owner.Name ownername, Lead_Manager__c, Lead_Manager__r.Name leadmanagername, Billing_Address__r.Region__c region, Billing_Address__r.Sub_Region__c subregion, count(Id) ' +
            'from Account ' +
            'group by ownerid, owner.name, Lead_Manager__c, Lead_Manager__r.Name, Billing_Address__r.Region__c, Billing_Address__r.Sub_Region__c '
        )) {
            owners.put((String)ar.get('ownername'), (String)ar.get('OwnerId'));
            if (ar.get('Lead_Manager__c') != null) {
                owners.put((String)ar.get('leadmanagername'), (String)ar.get('Lead_Manager__c'));
            }
            String region = (String)ar.get('region');
            String subRegion = (String)ar.get('subregion');
            if (String.isNotBlank(region)) {
                regions.add(region);
                if (String.isNotBlank(subRegion)) {
                    regions.add(region + ' / ' + subRegion);
                }
            }
        }

        for (AggregateResult ar : (AggregateResult[])Database.query(
            'select OwnerId, Owner.Name ownername, count(Id) ' +
            'from Opportunity where IsClosed = false ' +
            'group by ownerid, owner.name'
        )) {
            owners.put((String)ar.get('ownername'), (String)ar.get('OwnerId'));
        }

        // owner options
        List<String> names = new List<String>(owners.keySet());
        names.sort();
        ownerOptions = new SelectOption[]{new SelectOption('', '')};
        for (String name : names) {
            ownerOptions.add(new SelectOption(owners.get(name), name));
        }
        
        // region options
        List<String> regionsList = new List<String>(regions);
        regionsList.sort();
        regionOptions = new SelectOption[]{new SelectOption('', '')};
        for (String region : regionsList) {
            regionOptions.add(new SelectOption(region, region));
        }

        // role options
        roleOptions = new SelectOption[]{new SelectOption('', '')};
        UserRole ceoRole = [select Id, Name from UserRole where Name = 'CEO'];
        UserRole[] allRoles = [select Id, Name, ParentRoleId from UserRole where PortalAccountId = null order by Name];
        roleOptions.add(new SelectOption(ceoRole.Id, ceoRole.Name));
        for (SelectOption so : getRoleChildren(ceoRole.Id, 1, allRoles)) {
            if (!so.getLabel().startsWith('----')) {
                roleOptions.add(so);
            }
        }
    }

    private static SelectOption[] getRoleChildren (Id userRoleId, Integer level, UserRole[] allRoles) {
        SelectOption[] result = new SelectOption[]{};
        String prefix = '';
        while (prefix.length() < level) prefix += '-';
        for (UserRole r : allRoles) {
            if (userRoleId == r.ParentRoleId) {
                result.add(new SelectOption(r.Id, prefix + r.Name));
                result.addAll(getRoleChildren(r.Id, level + 1, allRoles));
            }
        }
        return result;
    }

    private static Set<Id> collectIds (Id parentId, Map<Id, Set<Id>> hierarchy) {
        Set<Id> result = new Set<Id>();
        if (!String.isBlank(parentId) && hierarchy.containsKey(parentId)) {
            for (Id i : hierarchy.get(parentId)) {
                result.add(i);
                result.addAll(collectIds(i, hierarchy));
            }
        }
        return result;
    }

    private static Set<Id> getUsersUnderRole (Id roleId) {
        Set<Id> roleIds = new Set<Id>{roleId};
        UserRole[] allRoles = [select Id, Name, ParentRoleId from UserRole where PortalAccountId = null order by Name];
        for (SelectOption so : getRoleChildren(roleId, 1, allRoles)) {
            roleIds.add(so.getValue());
        }
        return (new Map<Id, User>([select Id from User where UserRoleId in :roleIds])).keySet();
    }
    
    @TestVisible
    private User[] usersUnderMe () {
        Map<Id, Set<Id>> hierarchy = new Map<Id, Set<Id>>();
        for (UserRole r : [select Id, ParentRoleId from UserRole]) {
            if (!hierarchy.containsKey(r.ParentRoleId)) {
                hierarchy.put(r.ParentRoleId, new Set<Id>{r.Id});
            } else {
                hierarchy.get(r.ParentRoleId).add(r.Id);
            }
        }
        Set<Id> roles = collectIds(UserInfo.getUserRoleId(), hierarchy);
        return [select Id, Name from User where UserRoleId in :roles];
    }
    
    public List<List<Row>> getRowsChunked () {
        List<List<Row>> result = new List<List<Row>>();
        result.add(new List<Row>());
        for (Row r : getRows()) {
            if (result.get(result.size()-1).size() == 1000) result.add(new List<Row>());
            result.get(result.size()-1).add(r);
        }
        return result;
    }

    @RemoteAction
    public static Row[] getRowsRemote (String search, String ownerId, String region, String roleId) {
        CEOReport c = new CEOReport();
        c.searchString = search;
        c.ownerIdFilter = ownerId;
        c.regionFilter = region;
        c.roleFilter = roleId;
        return c.getRows();
    }
    
    public Row[] getRows () {
        User EloquaAPIUser = [select id from User where name='Eloqua API User' limit 1];
        String searchFilter = String.isNotBlank(searchString) ? '%' + searchString + '%' : '';
        Row[] rows = new Row[]{};
        Set<Id> ownerIds = new Set<Id>();
        if (String.isNotBlank(ownerIdFilter)) {
            ownerIds.add(ownerIdFilter);
        } else if (String.isNotBlank(roleFilter)) {
            ownerIds.addAll(getUsersUnderRole(roleFilter));
        }

        String billToRegion = String.isNotBlank(regionFilter) ? regionFilter + '%' : '';
        String billToSubRegion = '';
        if (regionFilter != null && regionFilter.contains('/')) {
            String[] parts = regionFilter.split('\\/');
            billToRegion = parts[0].trim() + '%';
            billToSubRegion = parts[1].trim() + '%';
        }
        
        Set<Id> accountsWithOpenOpportunities = new Set<Id>();
        if (String.isNotBlank(ownerIdFilter)) {
            for (Opportunity o : [select AccountId from Opportunity where IsClosed = false and OwnerId = :ownerIdFilter]) {
                accountsWithOpenOpportunities.add(o.AccountId);
            }
        }
        String ownerFilter = '';

        
        String soql = 'select Id, Name, Customer_Performance_Report_Name__c, '+
            'Owner.Name, Segment__c, Lead_Manager__r.Name, LastActivityDate, '+
            'Bill_To_Region__c, Bill_To_Sub_Region__c, '+
            '( '+
                'select Id, Year__c,  '+
                'AMS_Revenue__c, PLAYOUT_Revenue__c,  '+
                'NETWORKING_Revenue__c, DISTRIBUTION_Revenue__c,  '+
                'PND_Revenue__c, Total__c,  '+
                'Last_Contact_Date__c, Last_Contact_Notes__c '+
                'from Customer_Performance__r '+
                'order by Year__c asc'+
            '), '+
            '( '+
                'select Id, Name, Amount '+
                'from Opportunities '+
                'where IsClosed = false '+
                'order by CloseDate desc '+
                'limit 5 '+
            '), '+
            '( '+
                'select ActivityDate, Subject '+
                'from ActivityHistories '+
                'where IsClosed = true '+
                'and CreatedByID<>\''+EloquaAPIUser.ID+'\' '+
                'and ActivityDate != null '+
                'order by ActivityDate desc '+
                'limit 1 '+
            ') '+
            'from Account ';
        List<String> filters = new List<String>();
        if (String.isNotBlank(searchFilter)) {
            filters.add('(Customer_Performance_Report_Name__c like :searchFilter OR Name like :searchFilter)');
        }
        if (!ownerIds.isEmpty() || !accountsWithOpenOpportunities.isEmpty()) filters.add('(OwnerId in :ownerIds or Id in :accountsWithOpenOpportunities or Lead_Manager__c in :ownerIds)');
        if (String.isNotBlank(billToRegion)) filters.add('Bill_To_Region__c like :billToRegion');
        if (String.isNotBlank(billToSubRegion)) filters.add('Bill_To_Sub_Region__c like :billToSubRegion');
        if (String.isNotBlank(leadManagerFilter)) filters.add('Lead_Manager__c = :leadManagerFilter');
        if (!filters.isEmpty()) soql += ' where ' + String.join(filters, ' and ');
        soql += ' order by Bill_To_Region__c, Bill_To_Sub_Region__c, Owner.Name, Customer_Performance_Report_Name__c ';

        String previousAccountName = '';
        for (Account a : (List<Account>)Database.query(soql)) {
            
            Row r = new Row(a);
            
            // de-dupe customers by account name
            Boolean reUsedRow = false;
            if (previousAccountName.equalsIgnoreCase(r.accountName)) {
                if (r.customerPerformances.isEmpty()) {
                    Row previousRow = rows.get(rows.size()-1);
                    previousRow.customerPerformances.addAll(r.customerPerformances);
                    previousRow.oppsOpenCount += r.oppsOpenCount;
                    previousRow.oppsOpenAmount += r.oppsOpenAmount;
                    r = previousRow;
                }
                reUsedRow = true;
            }
            previousAccountName = r.accountName;
            
            r.opps = null; // clear out for viewstate limit
            
            if (!reUsedRow) rows.add(r);
        }
        for (Row r : rows) {
            // fill in blank values so no null pointer exceptions
            while (r.customerPerformances.size() < 3) {
                r.customerPerformances.add(new Customer_Performance__c());
            }
            // create grand total
            r.customerPerformancesTotal = 0;
            for (Customer_Performance__c cp : r.customerPerformances) {
                if (cp.Total__c != null) {
                    r.customerPerformancesTotal += cp.Total__c;
                }
            }
        }
        return rows;
    }
}