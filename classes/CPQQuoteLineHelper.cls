public with sharing class CPQQuoteLineHelper {

	@TestVisible    
    private static Boolean hasRun = false;
    private Integer groupNumber = 0;

    public void populateQuoteLineGroups(List<SBQQ__QuoteLine__c> quoteLines) {
        if(hasRun) return;
        
        Map<Id, Set<String>> quoteGroupsMap = new Map<Id, Set<String>>();
        Map<Id, List<SBQQ__QuoteLine__c>> quoteLinesMap = new Map<Id, List<SBQQ__QuoteLine__c>>();
        // for handling two level groups i.e parent group => child group => quote line
        Map<String, Set<String>> parentChildMap = new Map<String, Set<String>>();
        // for handling single level group i.e. group => quote line
        Set<String> groups = new Set<String>();
        Map<String, String> casePreservedMap = new Map<String, String>();
        
        // store the key as {quoteid}_{child_group_name}_{parent_group_name} or 
        // {quoteid}_{group_name}
        Map<String, Boolean> groupOptional = new Map<String, Boolean>();
        
        for (SBQQ__QuoteLine__c quoteLine : quoteLines) {
            String groupName = quoteLine.Import_Group_Name__c;
            String parentGroupName = quoteLine.Import_Parent_Group_Name__c;
            if (String.isNotBlank(parentGroupName)) {
                String casePreserved = parentGroupName.trim();
                parentGroupName = casePreserved.toLowerCase();
                casePreservedMap.put(parentGroupName, casePreserved);
                
                casePreserved = groupName.trim();
                groupName = casePreserved.toLowerCase();
                casePreservedMap.put(groupName, casePreserved);

                if (!parentChildMap.containsKey(parentGroupName)) {
                    parentChildMap.put(parentGroupName, new Set<String>());
                }
                parentChildMap.get(parentGroupName).add(groupName);
                // quote groups mapping
                if(!quoteGroupsMap.containsKey(quoteLine.SBQQ__Quote__c))
                    quoteGroupsMap.put(quoteLine.SBQQ__Quote__c, new Set<String>());
                quoteGroupsMap.get(quoteLine.SBQQ__Quote__c).add(parentGroupName);
                
                if(quoteLine.SBQQ__Optional__c) 
                    groupOptional.put(quoteLine.SBQQ__Quote__c + '_' + groupName + '_' + parentGroupName, true);
            } else if (String.isNotBlank(groupName)) {
                String casePreserved = groupName.trim();
                groupName = casePreserved.toLowerCase();
                casePreservedMap.put(groupName, casePreserved);
                groups.add(groupName);
                // quote groups mapping
                if(!quoteGroupsMap.containsKey(quoteLine.SBQQ__Quote__c))
                    quoteGroupsMap.put(quoteLine.SBQQ__Quote__c, new Set<String>());
                quoteGroupsMap.get(quoteLine.SBQQ__Quote__c).add(groupName);
                
                if(quoteLine.SBQQ__Optional__c) 
                    groupOptional.put(quoteLine.SBQQ__Quote__c + '_' + groupName, true);
            }
            if(!quoteLinesMap.containsKey(quoteLine.SBQQ__Quote__c))
                quoteLinesMap.put(quoteLine.SBQQ__Quote__c, new List<SBQQ__QuoteLine__c>());
            quoteLinesMap.get(quoteLine.SBQQ__Quote__c).add(quoteLine);
        }
        
        List<SBQQ__QuoteLineGroup__c> quoteLineGroups = [
            select Id, Name, SBQQ__Quote__c, Parent_Group__c, Parent_Group__r.Name 
            from SBQQ__QuoteLineGroup__c 
            where SBQQ__Quote__c IN :quoteGroupsMap.keySet()
        ];
        
        List<SBQQ__QuoteLineGroup__c> parentGroups = new List<SBQQ__QuoteLineGroup__c>();
        Map<SBQQ__QuoteLineGroup__c, SBQQ__QuoteLineGroup__c> childToParentGroups = new Map<SBQQ__QuoteLineGroup__c, SBQQ__QuoteLineGroup__c>();
        for(Id quoteId : quoteGroupsMap.keySet()) {
            Set<String> groupNames = quoteGroupsMap.get(quoteId);
            for(String groupName : groupNames) {
                Boolean found = false;
                for(SBQQ__QuoteLineGroup__c quoteLineGroup : quoteLineGroups) {
                    if(groupName.endsWithIgnoreCase(quoteLineGroup.Name)) {
                        found = true;
                    }
                }
                if(!found) {
                    if(parentChildMap.containsKey(groupName)) {
                        SBQQ__QuoteLineGroup__c parentGroup = getQuoteLineGroup(quoteId, casePreservedMap.get(groupName), false);
                        parentGroups.add(parentGroup);
                        // add child groups
                        Set<String> childGroupNames = parentChildMap.get(groupName);
                        for(String childGroupName : childGroupNames) {
                            Boolean optional = groupOptional.containsKey(quoteId + '_' + childGroupName + '_' + groupName);
                            if(optional) parentGroup.SBQQ__Optional__c = true;
                            SBQQ__QuoteLineGroup__c childGroup = getQuoteLineGroup(quoteId, casePreservedMap.get(childGroupName), optional);
                            childGroup.Name = childGroup.Name + '~' + parentGroup.Name;
                            childToParentGroups.put(childGroup, parentGroup);
                        }
                    } else {
                        Boolean optional = groupOptional.containsKey(quoteId + '_' + groupName);
                        childToParentGroups.put(getQuoteLineGroup(quoteId, casePreservedMap.get(groupName), optional), null);
                    }
                }
            }
        }
        insert parentGroups;
        Map<Id, SBQQ__QuoteLineGroup__c> parentGroupsMap = new Map<Id, SBQQ__QuoteLineGroup__c>(parentGroups);
        List<SBQQ__QuoteLineGroup__c> childGroups = new List<SBQQ__QuoteLineGroup__c>();
        for(SBQQ__QuoteLineGroup__c childGroup : childToParentGroups.keySet()) {
            if(childToParentGroups.get(childGroup) != null) {
                childGroup.Parent_Group__c = childToParentGroups.get(childGroup).Id;
                childGroup.Name = childGroup.Name.split('~')[0];
            }
            childGroups.add(childGroup);
        }
        insert childGroups;
        
        List<SBQQ__QuoteLineGroup__c> allGroups = new List<SBQQ__QuoteLineGroup__c>();
        allGroups.addAll(quoteLineGroups);
        allGroups.addAll(childGroups);
        
        // tie groups to quote lines
        for(Id quoteId : quoteLinesMap.keySet()) {
            for(SBQQ__QuoteLine__c quoteLine : quoteLinesMap.get(quoteId)) {
                for(SBQQ__QuoteLineGroup__c lineGroup : allGroups) {
                    if (lineGroup.SBQQ__Quote__c == quoteId) {
                        if (String.isNotBlank(quoteLine.Import_Parent_Group_Name__c)) {
                            if (lineGroup.Parent_Group__c != null && quoteLine.Import_Parent_Group_Name__c.equals(parentGroupsMap.get(lineGroup.Parent_Group__c)?.Name) 
                                && quoteLine.Import_Group_Name__c.equals(lineGroup.Name)) {
                                quoteLine.SBQQ__Group__c = lineGroup.Id;
                                // once mapped to a group, clear fields
                                quoteLine.Import_Group_Name__c = '';
                                quoteLine.Import_Parent_Group_Name__c = '';
                            }
                        } else if (quoteLine.Import_Group_Name__c != null && quoteLine.Import_Group_Name__c.equals(lineGroup.Name)) {
                            quoteLine.SBQQ__Group__c = lineGroup.Id;
                            // once mapped to a group, clear fields
                            quoteLine.Import_Group_Name__c = '';
                            quoteLine.Import_Parent_Group_Name__c = '';
                        }
                    }
                }
            }
        }
        hasRun = true;
    }

    public void syncOptionalStatusWithGroup(Map<Id, SBQQ__QuoteLine__c> oldLines, Map<Id, SBQQ__QuoteLine__c> newLines) {
        Map<Id, List<SBQQ__QuoteLine__c>> newGroupLinesMap = new Map<Id, List<SBQQ__QuoteLine__c>>();
        for (Id lineId : newLines.keySet()) {
            SBQQ__QuoteLine__c newLine = newLines.get(lineId);
            SBQQ__QuoteLine__c oldLine = oldLines.get(lineId);
            if (oldLine.SBQQ__Group__c != newLine.SBQQ__Group__c) {
                if (!newGroupLinesMap.containsKey(newLine.SBQQ__Group__c)) {
                    newGroupLinesMap.put(newLine.SBQQ__Group__c, new List<SBQQ__QuoteLine__c>());
                }
                newGroupLinesMap.get(newLine.SBQQ__Group__c).add(newLine);
            }
        }
        if (!newGroupLinesMap.isEmpty()) {
            List<SBQQ__QuoteLineGroup__c> lineGroups = [
                select Id, SBQQ__Optional__c
                from SBQQ__QuoteLineGroup__c
                where Id in :newGroupLinesMap.keySet()
            ];
            for (SBQQ__QuoteLineGroup__c lineGroup : lineGroups) {
                for (SBQQ__QuoteLine__c quoteLine : newGroupLinesMap.get(lineGroup.Id)) {
                    quoteLine.SBQQ__Optional__c = lineGroup.SBQQ__Optional__c;
                }
            }
        }
    }
    
    private SBQQ__QuoteLineGroup__c getQuoteLineGroup(String quoteId, String groupName, Boolean optional) {
        groupNumber++;
        SBQQ__QuoteLineGroup__c lineGroup = new SBQQ__QuoteLineGroup__c(
            SBQQ__Quote__c=quoteId,
            Name=groupName,
            SBQQ__ListTotal__c=0.0,
            SBQQ__CustomerTotal__c=0.0,
            SBQQ__NetTotal__c=0.0,
            SBQQ__Number__c=groupNumber,
            SBQQ__Optional__c=optional
        );
        return lineGroup;
    }
}