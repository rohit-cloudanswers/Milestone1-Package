public with sharing class CPQQuoteLineGroupHelper {
    
    public static Boolean hasRun = false;
    public static final String SEPARATOR = '~~';
    
    public static void saveReferenceToOldParentGroup(List<SBQQ__QuoteLineGroup__c> quoteLineGroups) {
        Map<Id, SBQQ__QuoteLineGroup__c> parentGroupsMap = new Map<Id, SBQQ__QuoteLineGroup__c>();
        for (SBQQ__QuoteLineGroup__c quoteLineGroup : quoteLineGroups) {
            if (quoteLineGroup.Parent_Group__c != null) parentGroupsMap.put(quoteLineGroup.Parent_Group__c, null);
        }
        parentGroupsMap = new Map<Id, SBQQ__QuoteLineGroup__c>([
            select Id, Name, SBQQ__Quote__c, SBQQ__Optional__c
            from SBQQ__QuoteLineGroup__c
            where Id IN :parentGroupsMap.keySet()
        ]);
        for (SBQQ__QuoteLineGroup__c quoteLineGroup : quoteLineGroups) {
            if (quoteLineGroup.Parent_Group__c != null && quoteLineGroup.SBQQ__Quote__c != parentGroupsMap.get(quoteLineGroup.Parent_Group__c).SBQQ__Quote__c) {
                quoteLineGroup.Parent_Group_Cloned_From__c = quoteLineGroup.Parent_Group__c + SEPARATOR + parentGroupsMap.get(quoteLineGroup.Parent_Group__c).Name + SEPARATOR + parentGroupsMap.get(quoteLineGroup.Parent_Group__c).SBQQ__Optional__c;
                quoteLineGroup.Parent_Group__c = null;
            } else if (quoteLineGroup.Parent_Group__c == null) {
                // for quotes in inconsistent state
                quoteLineGroup.Quote_Line_Count__c = 0;
            }
        }
    }

    public static Map<Id, String> getParentGroupNamesMap(List<SBQQ__QuoteLineGroup__c> quoteLineGroups) {
        Set<Id> quoteIds = new Set<Id>();
        Map<Id, String> groupNamesMap = new Map<Id, String>();
        for (SBQQ__QuoteLineGroup__c quoteLineGroup : quoteLineGroups) {
            quoteIds.add(quoteLineGroup.SBQQ__Quote__c);
            if (quoteLineGroup.Parent_Group_Cloned_From__c != null) {
                String[] parts = quoteLineGroup.Parent_Group_Cloned_From__c.split(SEPARATOR);
                // append optional status to group name
                groupNamesMap.put(parts[0], parts[1] + SEPARATOR + parts[2]);
            }
        }
        return groupNamesMap;
    }
    
    public static Map<Id, Map<String, SBQQ__QuoteLineGroup__c>> getCurrentParentGroupsByQuote(List<SBQQ__QuoteLineGroup__c> quoteLineGroups) {
        Map<Id, Map<String, SBQQ__QuoteLineGroup__c>> currentParentGroups = new Map<Id, Map<String, SBQQ__QuoteLineGroup__c>>();
        for (SBQQ__QuoteLineGroup__c quoteLineGroup : quoteLineGroups) {
            // parent groups on the existing quote will have this field as null
            if (quoteLineGroup.Parent_Group_Cloned_From__c == null) {
                if (!currentParentGroups.containsKey(quoteLineGroup.SBQQ__Quote__c)) {
                    currentParentGroups.put(quoteLineGroup.SBQQ__Quote__c, new Map<String, SBQQ__QuoteLineGroup__c>());
                }
                currentParentGroups.get(quoteLineGroup.SBQQ__Quote__c).put(
                    quoteLineGroup.Name + SEPARATOR + quoteLineGroup.SBQQ__Optional__c,
                    quoteLineGroup
                );
            }
        }
        return currentParentGroups;
    }
    
    public static List<SBQQ__QuoteLineGroup__c> linkParentGroups(List<SBQQ__QuoteLineGroup__c> quoteLineGroups, Map<Id, String> parentGroupNamesMap, Map<Id, Map<String, SBQQ__QuoteLineGroup__c>> possibleParentGroups) {
        List<SBQQ__QuoteLineGroup__c> toLink = new List<SBQQ__QuoteLineGroup__c>();
        if(!hasRun) {
            for (SBQQ__QuoteLineGroup__c quoteLineGroup : quoteLineGroups) {
                if (quoteLineGroup.Parent_Group_Cloned_From__c != null) {
                    String[] parts = quoteLineGroup.Parent_Group_Cloned_From__c.split(SEPARATOR);
                    String parentGroupName = parentGroupNamesMap.get(parts[0]);
                    Map<String, SBQQ__QuoteLineGroup__c> currentGroupsMap = possibleParentGroups.get(quoteLineGroup.SBQQ__Quote__c);
                    if (String.isNotBlank(parentGroupName) && currentGroupsMap != null) {
                        if(currentGroupsMap.containsKey(parentGroupName)) {
                            toLink.add(new SBQQ__QuoteLineGroup__c(
                                Id=quoteLineGroup.Id,
                                Parent_Group_Cloned_From__c=null,
                                Parent_Group__c=currentGroupsMap.get(parentGroupName).Id
                            ));
                        } else {
                            quoteLineGroup.addError('Unable to clone Parent Group.');
                        }
                    }
                }
            }
            hasRun = true;
        }
        return toLink;
    }
}