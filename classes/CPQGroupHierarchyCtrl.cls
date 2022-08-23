public with sharing class CPQGroupHierarchyCtrl {

    @AuraEnabled
    public static Map<String, Object> getGroupHierarchy(String quoteId) {
        Map<String, Object> allData = new Map<String, Object>();
        List<SBQQ__Quote__c> quoteList = [
            select Id, SBQQ__Status__c 
            from SBQQ__Quote__c 
            where Id = :quoteId
        ];
        List<SBQQ__QuoteLineGroup__c> lineGroups = [
            select Id, Name, SBQQ__NetTotal__c, SBQQ__ListTotal__c, Total_Discount_Amount_Group__c, SBQQ__Optional__c, 
            (select Id, Name, SBQQ__NetTotal__c, SBQQ__ListTotal__c, Total_Discount_Amount_Group__c, SBQQ__Optional__c from Sub_Groups__r order by SBQQ__Number__c asc) 
            from SBQQ__QuoteLineGroup__c where SBQQ__Quote__c = :quoteId and Parent_Group__c = null order by SBQQ__Number__c asc
        ];
        Set<Id> groupIds = new Set<Id>();
        List<OptionWrapper> groupOptions = new List<OptionWrapper>();
        for(SBQQ__QuoteLineGroup__c lineGroup : lineGroups) {
            groupIds.add(lineGroup.Id);
            groupOptions.add(new OptionWrapper(lineGroup.Id, lineGroup.Name, false));
            if(lineGroup.Sub_Groups__r != null) {
                for(SBQQ__QuoteLineGroup__c subGroup : lineGroup.Sub_Groups__r) {
                    groupIds.add(subGroup.Id);
                    groupOptions.add(new OptionWrapper(subGroup.Id, subGroup.Name, true));
                }
            }
        }
        List<SBQQ__QuoteLine__c> lineItems = [
            select Id, Name, SBQQ__Quantity__c, SBQQ__ListTotal__c, SBQQ__NetPrice__c,  SBQQ__NetTotal__c, 
            Total_Cost__c, Margin__c, SBQQ__Group__c, SBQQ__Group__r.Parent_Group__c, SBQQ__Optional__c, 
            SBQQ__ProductCode__c, CurrencyIsoCode, SBQQ__TotalDiscountAmount__c, Total_Discount__c, 
            SBQQ__ListPrice__c, Product_Cost__c, SBQQ__Discount__c, Product_Code__c, SBQQ__Bundled__c,
            SBQQ__ProductOption__c, SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__r.ProductCode
            from SBQQ__QuoteLine__c 
            where SBQQ__Group__c IN :groupIds order by SBQQ__Number__c asc
        ];
        Map<String, Decimal> marginMap = new Map<String, Decimal>();
        Map<String, Decimal> parentMarginMap = new Map<String, Decimal>();
        Map<String, Decimal> numeratorsMap = new Map<String, Decimal>();
        Map<String, Decimal> denominatorsMap = new Map<String, Decimal>();
        Map<String, List<SBQQ__QuoteLine__c>> groupQuoteLinesMap = new Map<String, List<SBQQ__QuoteLine__c>>();
        for(Id groupId : groupIds) {
            Decimal nemo = 0, deno = 0;
            for(SBQQ__QuoteLine__c item : lineItems) {
                Decimal totalUnitPrice = item.SBQQ__ListPrice__c == null ? 0 : item.SBQQ__ListPrice__c;
                Decimal netTotal = item.SBQQ__ListTotal__c == null ? 0 : item.SBQQ__ListTotal__c;
                Decimal discount = item.SBQQ__Discount__c == null ? 0 : item.SBQQ__Discount__c / 100;
                Decimal totalCost = item.Total_Cost__c == null ? 0 : item.Total_Cost__c;
                if (item.Product_Code__c != null && item.Product_Code__c.containsIgnoreCase('Support Package')) totalCost = 0;
                if (item.SBQQ__Bundled__c && item.SBQQ__ProductOption__c != null && item.SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__c != null 
                    && !item.SBQQ__ProductOption__r.SBQQ__ConfiguredSKU__r.ProductCode.containsIgnoreCase('Support Package')) {
                    totalCost = 0;
                }
                Decimal itemNemo = (netTotal * (discount - 1)) + totalCost;
                Decimal itemDeno = netTotal * (discount - 1);
                if(item.SBQQ__Group__c == groupId) {
                    nemo += itemNemo;
                    deno += itemDeno;
                }
                if(item.SBQQ__Group__r.Parent_Group__c == groupId) {
                    if(numeratorsMap.get(groupId) == null) {
                        numeratorsMap.put(groupId, 0);
                        denominatorsMap.put(groupId, 0);
                    }
                    numeratorsMap.put(groupId, (numeratorsMap.get(groupId) + itemNemo));
                    denominatorsMap.put(groupId, (denominatorsMap.get(groupId) + itemDeno));
                }
                // store quote lines by group
                if(!groupQuoteLinesMap.containsKey(groupId)) groupQuoteLinesMap.put(groupId, new List<SBQQ__QuoteLine__c>());
                if(item.SBQQ__Group__c == groupId) groupQuoteLinesMap.get(groupId).add(item);
            }

            if(deno != 0) {
                Decimal temp = (nemo / deno) * 100;
                marginMap.put(groupId, temp.setScale(2, RoundingMode.HALF_EVEN));
            } else {
                marginMap.put(groupId, 0);
            }
            // override parent group margin
            if(numeratorsMap.containsKey(groupId) && denominatorsMap.get(groupId) != 0) {
                Decimal temp = (numeratorsMap.get(groupId) / denominatorsMap.get(groupId)) * 100;
                marginMap.put(groupId, temp.setScale(2, RoundingMode.HALF_EVEN));
            }
        }

        List<Map<String, Object>> data = new List<Map<String, Object>>();
        if(lineGroups.size() > 0) {
            Set<Id> quoteLinesProcessed = new Set<Id>();
            for(SBQQ__QuoteLineGroup__c lineGroup : lineGroups) {
                Map<String, Object> groupData = new Map<String, Object>();
                groupData.put('groupId', lineGroup.Id);
                groupData.put('groupUri', '/lightning/r/SBQQ__QuoteLineGroup__c/'+lineGroup.Id+'/view');
                groupData.put('groupName', lineGroup.Name);
                groupData.put('quantity', '-');
                groupData.put('optional', lineGroup.SBQQ__Optional__c);
                groupData.put('totalMargin', marginMap.get(lineGroup.Id) / 100);
                if(lineGroup.Sub_Groups__r.isEmpty()) {
                    groupData.put('totalListPrice', lineGroup.SBQQ__ListTotal__c);
                    groupData.put('totalNet', lineGroup.SBQQ__NetTotal__c);
                    groupData.put('totalDiscountAmount', lineGroup.Total_Discount_Amount_Group__c);
                    if(lineGroup.SBQQ__ListTotal__c != 0) {
                        Decimal listTotal = lineGroup.SBQQ__ListTotal__c == null ? 1 : lineGroup.SBQQ__ListTotal__c;
                        Decimal discountAmount = lineGroup.Total_Discount_Amount_Group__c == null ? 0 : lineGroup.Total_Discount_Amount_Group__c;
                        groupData.put('totalDiscountPercent', calculateDiscount(discountAmount, listTotal));
                    } else {
                        groupData.put('totalDiscountPercent', 0.0);
                    }
                    // add Quote Lines as children
                    if(groupQuoteLinesMap.containsKey(lineGroup.Id)) {
                        Decimal totalUnitPrice = 0.0, totalPrice = 0.0;
                        List<Map<String, Object>> listQuoteLines = new List<Map<String, Object>>();
                        for(SBQQ__QuoteLine__c quoteLine : groupQuoteLinesMap.get(lineGroup.Id)) {
                            totalUnitPrice += (quoteLine.SBQQ__ListPrice__c == null ? 0 : quoteLine.SBQQ__ListPrice__c);
                            totalPrice += (quoteLine.SBQQ__NetPrice__c == null ? 0 : quoteLine.SBQQ__NetPrice__c);
                            listQuoteLines.add(getQuoteLineRow(quoteLine));
                        }
                        groupData.put('totalUnitPrice', totalUnitPrice);
                        groupData.put('totalPrice', totalPrice);
                        groupData.put('_children', listQuoteLines);
                    }
                } else {
                    Decimal totalNet = 0.0, totalUnitPrice = 0.0, totalListPrice = 0.0, totalPrice = 0.0, totalDiscountAmount = 0.0;
                    List<Map<String, Object>> childGroups = new List<Map<String, Object>>();
                    for(SBQQ__QuoteLineGroup__c childLineGroup : lineGroup.Sub_Groups__r) {
                        Decimal totalGroupUnitPrice = 0.0, totalChildPrice = 0.0;
                        Map<String, Object> childGroupData = new Map<String, Object>();
                        childGroupData.put('groupId', childLineGroup.Id);
                        childGroupData.put('groupUri', '/lightning/r/SBQQ__QuoteLineGroup__c/'+childLineGroup.Id+'/view');
                        childGroupData.put('groupName', childLineGroup.Name);
                        childGroupData.put('quantity', '-');
                        childGroupData.put('optional', childLineGroup.SBQQ__Optional__c);
                        childGroupData.put('totalMargin', marginMap.get(childLineGroup.Id) / 100);
                        childGroupData.put('totalNet', childLineGroup.SBQQ__NetTotal__c);
                        childGroupData.put('totalListPrice', childLineGroup.SBQQ__ListTotal__c);
                        childGroupData.put('totalDiscountAmount', childLineGroup.Total_Discount_Amount_Group__c);
                        if(childLineGroup.SBQQ__ListTotal__c != 0) {
                            Decimal listTotal = childLineGroup.SBQQ__ListTotal__c == null ? 1 : childLineGroup.SBQQ__ListTotal__c;
                            Decimal discountAmount = childLineGroup.Total_Discount_Amount_Group__c == null ? 0 : childLineGroup.Total_Discount_Amount_Group__c;
                            childGroupData.put('totalDiscountPercent', calculateDiscount(discountAmount, listTotal));
                        } else {
                            childGroupData.put('totalDiscountPercent', 0.0);
                        }
                        // add Quote Lines as children
                        if(groupQuoteLinesMap.containsKey(childLineGroup.Id)) {
                            List<Map<String, Object>> listQuoteLines = new List<Map<String, Object>>();
                            for(SBQQ__QuoteLine__c quoteLine : groupQuoteLinesMap.get(childLineGroup.Id)) {
                                totalGroupUnitPrice += (quoteLine.SBQQ__ListPrice__c == null ? 0 : quoteLine.SBQQ__ListPrice__c);
                                totalChildPrice += (quoteLine.SBQQ__NetPrice__c == null ? 0 : quoteLine.SBQQ__NetPrice__c);
                                listQuoteLines.add(getQuoteLineRow(quoteLine));
                            }
                            childGroupData.put('totalUnitPrice', totalGroupUnitPrice);
                            childGroupData.put('totalPrice', totalChildPrice);
                            childGroupData.put('_children', listQuoteLines);
                        }
                        childGroups.add(childGroupData);
                        totalUnitPrice += totalGroupUnitPrice;
                        totalPrice += totalChildPrice;
                        totalNet += (childLineGroup.SBQQ__NetTotal__c == null ? 0 : childLineGroup.SBQQ__NetTotal__c);
                        totalListPrice += (childLineGroup.SBQQ__ListTotal__c == null ? 0 : childLineGroup.SBQQ__ListTotal__c);
                        totalDiscountAmount += childLineGroup.Total_Discount_Amount_Group__c;
                    }
                    groupData.put('totalNet', totalNet);
                    groupData.put('totalPrice', totalPrice);
                    groupData.put('totalUnitPrice', totalUnitPrice);
                    groupData.put('totalListPrice', totalListPrice);
                    groupData.put('totalDiscountAmount', totalDiscountAmount);
                    if(totalListPrice != 0) {
                        groupData.put('totalDiscountPercent', calculateDiscount(totalDiscountAmount, totalListPrice));
                    } else {
                        groupData.put('totalDiscountPercent', 0.0);
                    }
                    groupData.put('_children', childGroups);
                }
                data.add(groupData);
            }
        }
        allData.put('data', data);
        allData.put('groups', groupOptions);
        // get quote currency
        if (!lineItems.isEmpty()) {
            String currencyIsoCode = lineItems.get(0).CurrencyIsoCode;
            allData.put('currency_iso_code', currencyIsoCode);
            if (currencyIsoCode != 'USD') {
                List<CurrencyType> currencies = [
                    select ConversionRate 
                    from CurrencyType 
                    where IsoCode = :currencyIsoCode
                        and IsActive = true
                ];
                if(!currencies.isEmpty()) allData.put('conversion_rate', currencies.get(0).ConversionRate);
            }
        }
        allData.put('uiThemeDisplayed', UserInfo.getUiThemeDisplayed());
        String approvalStatus = quoteList.get(0).SBQQ__Status__c;
        approvalStatus = approvalStatus == null ? '' : approvalStatus;
        allData.put('isLocked', 
            approvalStatus.equals('Presented') || approvalStatus.equals('Approved') || 
            approvalStatus.equals('In Review') || approvalStatus.equals('Accepted')
        );
        return allData;
    }
    
    @AuraEnabled
    public static List<Map<String, Object>> getQuoteLineGroups(String quoteId) {
        List<SBQQ__QuoteLineGroup__c> lineGroups = [
            select Id, Name, SBQQ__NetTotal__c, SBQQ__ListTotal__c, Total_Discount_Amount_Group__c, SBQQ__Optional__c, 
            (select Id, Name, SBQQ__NetTotal__c, SBQQ__ListTotal__c, Total_Discount_Amount_Group__c, SBQQ__Optional__c from Sub_Groups__r order by SBQQ__Number__c asc) 
            from SBQQ__QuoteLineGroup__c where SBQQ__Quote__c = :quoteId and Parent_Group__c = null order by SBQQ__Number__c asc
        ];
        Set<Id> groupIds = new Set<Id>();
        for(SBQQ__QuoteLineGroup__c lineGroup : lineGroups) {
            groupIds.add(lineGroup.Id);
            if(lineGroup.Sub_Groups__r != null) {
                for(SBQQ__QuoteLineGroup__c subGroup : lineGroup.Sub_Groups__r) {
                    groupIds.add(subGroup.Id);
                }
            }
        }

        List<Map<String, Object>> data = new List<Map<String, Object>>();
        if(lineGroups.size() > 0) {
            for(SBQQ__QuoteLineGroup__c lineGroup : lineGroups) {
                Map<String, Object> groupData = new Map<String, Object>();
                groupData.put('name', lineGroup.Id);
                groupData.put('label', lineGroup.Name);
                if(!lineGroup.Sub_Groups__r.isEmpty()) {
                    groupData.put('expanded', true);
                    // add child groups
                    List<Map<String, Object>> childGroups = new List<Map<String, Object>>();
                    for(SBQQ__QuoteLineGroup__c childLineGroup : lineGroup.Sub_Groups__r) {
                        Map<String, Object> childGroupData = new Map<String, Object>();
                        childGroupData.put('name', childLineGroup.Id);
                        childGroupData.put('label', childLineGroup.Name);
                        childGroupData.put('expanded', false);
                        childGroups.add(childGroupData);
                    }
                    groupData.put('items', childGroups);
                } else {
                    groupData.put('expanded', false);
                }
                data.add(groupData);
            }
        }
        return data;
    }
    
    @AuraEnabled
    public static Map<String, Object> validateMove(String destinationGroupId, List<String> groupIds, List<String> lineIds) {
        Map<String, Object> result = new Map<String, Object>();
        if (String.isBlank(destinationGroupId)) {
            result.put('status', false);
            result.put('message', 'Please select a Quote Line Group.');
        } else {
            SBQQ__QuoteLineGroup__c lineGroup = [
                select Id, Parent_Group__c, (select Id from Sub_Groups__r), (select Id from SBQQ__LineItems__r)
                from SBQQ__QuoteLineGroup__c
                where Id = :destinationGroupId
            ];
            if (!groupIds.isEmpty()) {
                if (String.isNotBlank(lineGroup.Parent_Group__c)) {
                    result.put('status', false);
                    result.put('message', 'Multi-level grouping not supported. The destination Quote Line Group has Parent Group.');
                } else if (lineGroup.SBQQ__LineItems__r != null && !lineGroup.SBQQ__LineItems__r.isEmpty()) {
                    result.put('status', false);
                    result.put('message', 'Only sub-groups can have line items. The destination Quote Line Group already has line items.');
                } else {
                    result.put('status', true);
                    result.put('message', '');
                }
            } else if (!lineIds.isEmpty()) {
                if (!lineGroup.Sub_Groups__r.isEmpty()) {
                    result.put('status', false);
                    result.put('message', 'Quote Lines are only allowed under Quote Line Groups with no child Quote Line Groups.');
                } else {
                    result.put('status', true);
                    result.put('message', '');
                }
            }
        }
        return result;
    }
    
    @AuraEnabled
    public static Map<String, Object> handleMove(String destinationGroupId, List<String> groupIds, List<String> lineIds) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            SBQQ__QuoteLineGroup__c qlg = [
                select SBQQ__Quote__c 
                from SBQQ__QuoteLineGroup__c 
                where Id = :destinationGroupId
            ];
            if (!groupIds.isEmpty()) {
                List<SBQQ__QuoteLineGroup__c> lineGroups = new List<SBQQ__QuoteLineGroup__c>();
                for (String groupId : groupIds) {
                    SBQQ__QuoteLineGroup__c lineGroup = new SBQQ__QuoteLineGroup__c(
                        Id=groupId,
                        Parent_Group__c=destinationGroupId
                    );
                    lineGroups.add(lineGroup);
                }
                update lineGroups;
                // re-order line groups
                if (!Test.isRunningTest()) reorderLineGroups(qlg.SBQQ__Quote__c);
            }
            if (!lineIds.isEmpty()) {
                List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
                for (String lineId : lineIds) {
                    SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c(
                        Id=lineId,
                        SBQQ__Group__c=destinationGroupId
                    );
                    quoteLines.add(quoteLine);
                }
                update quoteLines;
                update new SBQQ__QuoteLineGroup__c(Id=destinationGroupId);
            }
            result.put('status', true);
        } catch (Exception ex) {
            result.put('status', false);
            result.put('message', ex.getMessage());
        }
        return result;
    }
    
    @AuraEnabled
    public static Map<String, Object> handleCopy(String destinationGroupId, List<String> groupIds, List<String> lineIds) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            String clonedGroupId = null;
            SBQQ__QuoteLineGroup__c qlg = [
                select SBQQ__Quote__c 
                from SBQQ__QuoteLineGroup__c 
                where Id = :destinationGroupId
            ];
            if (!groupIds.isEmpty() && groupIds.size() == 1) {
                // query for max group number
                AggregateResult res = [
                    select MAX(SBQQ__Number__c) max 
                    from SBQQ__QuoteLineGroup__c 
                    where SBQQ__Quote__c = :qlg.SBQQ__Quote__c
                ];
                Decimal maxGroupNumber = (Decimal) res.get('max');
                List<String> lineGroupFields = new List<String>(getCreateableFields(SBQQ__QuoteLineGroup__c.sObjectType));
                String query = 'select ' + String.join(lineGroupFields, ',');
                query += ', (select Id from SBQQ__LineItems__r) from SBQQ__QuoteLineGroup__c where Id IN :groupIds';
                List<SBQQ__QuoteLineGroup__c> lineGroups = Database.query(query);
                List<SBQQ__QuoteLineGroup__c> toCopy = new List<SBQQ__QuoteLineGroup__c>();
                lineIds = new List<String>();

                for (SBQQ__QuoteLineGroup__c lineGroup : lineGroups) {
                    maxGroupNumber++;
                    SBQQ__QuoteLineGroup__c copiedLineGroup = lineGroup.clone(false, true);
                    copiedLineGroup.Parent_Group__c = destinationGroupId;
                    copiedLineGroup.SBQQ__Number__c = maxGroupNumber;
                    toCopy.add(copiedLineGroup);
                    for (SBQQ__QuoteLine__c quoteLine : lineGroup.SBQQ__LineItems__r) {
                        lineIds.add(quoteLine.Id);
                    }
                }
                insert toCopy;
                // re-order line groups
                if(!Test.isRunningTest()) reorderLineGroups(qlg.SBQQ__Quote__c);
                clonedGroupId = toCopy.get(0).Id;
            }
            if (!lineIds.isEmpty()) {
                List<String> quoteLineFields = new List<String>(getCreateableFields(SBQQ__QuoteLine__c.sObjectType));
                String query = 'select ' + String.join(quoteLineFields, ',');
                query += ' from SBQQ__QuoteLine__c where Id IN :lineIds';
                List<SBQQ__QuoteLine__c> quoteLines = Database.query(query);
                List<SBQQ__QuoteLine__c> toCopy = new List<SBQQ__QuoteLine__c>();
                for (SBQQ__QuoteLine__c quoteLine : quoteLines) {
                    // don't need to set the order, CPQ quote re-calculate handles that.
                    SBQQ__QuoteLine__c copiedLine = quoteLine.clone(false, true);
                    if (clonedGroupId != null) {
                        copiedLine.SBQQ__Group__c = clonedGroupId;
                    } else {
                        copiedLine.SBQQ__Group__c = destinationGroupId;
                    }
                    toCopy.add(copiedLine);
                }
                insert toCopy;
            }
            result.put('status', true);
        } catch (Exception ex) {
            result.put('status', false);
            result.put('message', ex.getMessage());
        }
        return result;
    }
    
    @AuraEnabled
    public static Map<String, Object> changeOptional(String quoteId, String groupId, Boolean state) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            List<SBQQ__QuoteLineGroup__c> toUpdate = new List<SBQQ__QuoteLineGroup__c>();
            SBQQ__QuoteLineGroup__c lineGroup = [
                select Id, SBQQ__Optional__c, Parent_Group__c, 
                (select Id, SBQQ__Optional__c from Sub_Groups__r) 
                from SBQQ__QuoteLineGroup__c 
                where Id = :groupId
            ];
            // check parent
            if (lineGroup.Parent_Group__c != null) {
                SBQQ__QuoteLineGroup__c parentGroup = [
                    select Id, SBQQ__Optional__c, Parent_Group__c, 
                    (select Id, SBQQ__Optional__c from Sub_Groups__r) 
                    from SBQQ__QuoteLineGroup__c 
                    where Id = :lineGroup.Parent_Group__c
                ];
                Boolean allOptional = true, atLeastOneNonOptional = false;
                for (SBQQ__QuoteLineGroup__c childGroup : parentGroup.Sub_Groups__r) {
                    if (childGroup.Id == groupId) {
                        childGroup.SBQQ__Optional__c = state;
                        toUpdate.add(childGroup);
                    }
                    allOptional = allOptional && childGroup.SBQQ__Optional__c;
                    atLeastOneNonOptional = atLeastOneNonOptional || !childGroup.SBQQ__Optional__c;
                }
                if (allOptional && state == true) {
                    parentGroup.SBQQ__Optional__c = state;
                    toUpdate.add(parentGroup);
                }
                if (atLeastOneNonOptional && state == false && parentGroup.SBQQ__Optional__c) {
                    parentGroup.SBQQ__Optional__c = state;
                    toUpdate.add(parentGroup);
                }
            } else {
                lineGroup.SBQQ__Optional__c = state;
                toUpdate.add(lineGroup);
                for (SBQQ__QuoteLineGroup__c childGroup : lineGroup.Sub_Groups__r) {
                    childGroup.SBQQ__Optional__c = state;
                    toUpdate.add(childGroup);
                }
            }
            List<SBQQ__QuoteLine__c> quoteLines = [
                select Id, SBQQ__Optional__c
                from SBQQ__QuoteLine__c
                where SBQQ__Group__c IN :toUpdate
            ];
            for (SBQQ__QuoteLine__c quoteLine : quoteLines) {
                quoteLine.SBQQ__Optional__c = state;
            }
            update toUpdate;
            update quoteLines;
            result.put('status', true);
        } catch (Exception ex) {
            result.put('status', false);
            result.put('message', ex.getMessage() + ' at ' + ex.getLineNumber());
            result.put('details', ex.getStackTraceString());
        }
        return result;
    }
    
    @AuraEnabled
    public static Boolean isRecalculating(){
        Boolean result = false;
        List<AsyncApexJob> jobs = [
            select Id, ApexClass.Name 
            from AsyncApexJob 
            where JobType = 'Queueable' 
            and Status NOT IN ('Aborted', 'Completed', 'Failed')
            and ApexClass.Name IN ('QueueableCalculatorService')
            and CreatedById = :UserInfo.getUserId()
        ];
        result = jobs.size() != 0;
        return result;
    }
    
    @AuraEnabled
    public static Map<String, Object> processMassEdit(List<String> lineIds, String massEditAction, Decimal value) {
        Map<String, Object> result = new Map<String, Object>();
        if (massEditAction == 'mass_edit_quantity') {
            return massUpdateQuantity(lineIds, value);
        } else if (massEditAction == 'mass_edit_discount') {
            return massUpdateDiscount(lineIds, value);
        } else if (massEditAction == 'mass_edit_margin') {
            return massUpdateMargin(lineIds, value);
        } else {
            result.put('status', false);
            result.put('message', 'Unsupported action [' + massEditAction + ']');
        }
        return result;
    }
    
    private static Map<String, Object> massUpdateQuantity(List<String> lineIds, Decimal value) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            Map<String, SBQQ__QuoteLine__c> lineItemsMap = new Map<String, SBQQ__QuoteLine__c>();
            for (String lineId : lineIds) {
                lineItemsMap.put(lineId, new SBQQ__QuoteLine__c(
                    Id=lineId,
                    SBQQ__Quantity__c=value
                ));
            }
            update lineItemsMap.values();
            result.put('status', true);
        } catch (Exception ex) {
            result.put('status', false);
            result.put('message', ex.getMessage());
        }
        return result;
    }
    
    private static Map<String, Object> massUpdateDiscount(List<String> lineIds, Decimal value) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            Map<String, SBQQ__QuoteLine__c> lineItemsMap = new Map<String, SBQQ__QuoteLine__c>();
            List<SBQQ__QuoteLine__c> quoteLines = [
                select Id, SBQQ__Discount__c 
                from SBQQ__QuoteLine__c
                where Id in :lineIds and SBQQ__Product__r.NonDiscountable__c = false and SBQQ__Optional__c = false
            ];
            for (SBQQ__QuoteLine__c quoteLine : quoteLines) {
                quoteLine.SBQQ__Discount__c = value * 100;
                lineItemsMap.put(quoteLine.Id, quoteLine);
            }
            update lineItemsMap.values();
            result.put('status', true);
        } catch (Exception ex) {
            result.put('status', false);
            result.put('message', ex.getMessage());
        }
        return result;
    }
    
    @TestVisible
    private static Map<String, Object> massUpdateMargin(List<String> lineIds, Decimal margin) {
        Map<String, Object> result = new Map<String, Object>();
        List<SBQQ__QuoteLine__c> quoteLines = [
            select Id, SBQQ__ListPrice__c, Product_Cost__c, Product_Type__c, Salesforce_Product_Type__c,
            SBQQ__Discount__c, SBQQ__Product__r.NonDiscountable__c, SBQQ__Quote__c
            from SBQQ__QuoteLine__c where Id IN :lineIds and 
            SBQQ__Product__r.NonDiscountable__c = false and SBQQ__Optional__c = false
        ];
        try {
            if (quoteLines.size() > 0) {
                Decimal totalPrice = 0.0, totalCost = 0.0;
                for (SBQQ__QuoteLine__c ql : quoteLines) {
                    totalPrice += (ql.SBQQ__ListPrice__c == null ? 0 : ql.SBQQ__ListPrice__c);
                    totalCost += (ql.Product_Cost__c == null ? 0 : ql.Product_Cost__c);
                }
                Decimal discount = 0;
                if (totalPrice > 0 ) CPQQuoteHelper.calculateDiscount(totalPrice, totalCost, margin);
                discount = discount / 100;
                result = massUpdateDiscount(lineIds, discount);
            }
        } catch (Exception ex) {
            result.put('status', false);
            result.put('message', ex.getMessage());
        }
        return result;
    }
    
    private static Map<String, Object> getQuoteLineRow(SBQQ__QuoteLine__c quoteLine) {
        Map<String, Object> quoteLineData = new Map<String, Object>();
        quoteLineData.put('groupId', quoteLine.Id);
        quoteLineData.put('groupUri', '/lightning/r/SBQQ__QuoteLine__c/'+quoteLine.Id+'/view');
        quoteLineData.put('groupName', quoteLine.SBQQ__ProductCode__c);
        quoteLineData.put('quantity', quoteLine.SBQQ__Quantity__c);
        quoteLineData.put('optional', quoteLine.SBQQ__Optional__c);
        quoteLineData.put('totalMargin', quoteLine.Margin__c != null ? quoteLine.Margin__c / 100.0 : 0);
        quoteLineData.put('totalUnitPrice', quoteLine.SBQQ__ListPrice__c == null ? 0 : quoteLine.SBQQ__ListPrice__c);
        quoteLineData.put('totalListPrice', quoteLine.SBQQ__ListTotal__c == null ? 0 : quoteLine.SBQQ__ListTotal__c);
        quoteLineData.put('totalPrice', quoteLine.SBQQ__NetPrice__c == null ? 0 : quoteLine.SBQQ__NetPrice__c);
        quoteLineData.put('totalNet', quoteLine.SBQQ__NetTotal__c == null ? 0 : quoteLine.SBQQ__NetTotal__c);
        quoteLineData.put('totalDiscountAmount', quoteLine.SBQQ__TotalDiscountAmount__c);
        quoteLineData.put('totalDiscountPercent', quoteLine.Total_Discount__c / 100);
        return quoteLineData;
    }
    
    public static Set<String> getCreateableFields(Schema.SObjectType sObjType) {
        Set<String> result = new Set<String>();
        Map<String, Schema.SObjectField> fieldsMap = sObjType.getDescribe().fields.getMap();
        for(String fieldName : fieldsMap.keySet()) {
            DescribeFieldResult fieldResult = fieldsMap.get(fieldName).getDescribe();
            DisplayType dt = fieldResult.getType();
            if((fieldResult.isAccessible() && fieldResult.isCreateable()) ||
                (dt == DisplayType.DATETIME || dt == DisplayType.DATE)) {
                result.add(fieldName);
            }
        }
        return result;
    }
    
    @TestVisible
    private static void reorderLineGroups(String quoteId) {
        // now re-order groups
        List<SBQQ__QuoteLineGroup__c> groups = [
            select Id, SBQQ__Number__c, (select Id, SBQQ__Number__c from Sub_Groups__r) 
            from SBQQ__QuoteLineGroup__c 
            where SBQQ__Quote__c = :quoteId and Parent_Group__c = null
            order by SBQQ__Number__c asc
        ];
        
        Decimal groupOrder = 1;
        Map<Id, SBQQ__QuoteLineGroup__c> toUpdate = new Map<Id, SBQQ__QuoteLineGroup__c>();
        for (SBQQ__QuoteLineGroup__c lineGroup : groups) {
            lineGroup.SBQQ__Number__c = groupOrder;
            toUpdate.put(lineGroup.Id, lineGroup);
            groupOrder++;
            for (SBQQ__QuoteLineGroup__c childGroup : lineGroup.Sub_Groups__r) {
                childGroup.SBQQ__Number__c = groupOrder;
                toUpdate.put(childGroup.Id, childGroup);
                groupOrder++;
            }
        }
        update toUpdate.values();
    }
    
    @AuraEnabled
    public static Map<String, Object> deleteAll(String quoteId) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            delete [select Id from SBQQ__QuoteLine__c where SBQQ__Quote__c = :quoteId];
            delete [select Id from SBQQ__QuoteLineGroup__c where SBQQ__Quote__c = :quoteId];
            update new SBQQ__Quote__c(
                Id=quoteId,
                SBQQ__LineItemsGrouped__c=false
            );
            result.put('status', true);
        } catch (Exception ex) {
            result.put('status', false);
            result.put('message', ex.getMessage());
        }
        return result;
    }

    private static Decimal calculateDiscount(Decimal discountAmount, Decimal totalAmount) {
        Decimal discount = discountAmount / totalAmount;
        discount = discount.setScale(2, RoundingMode.HALF_UP);
        return discount;
    }
    
    public class OptionWrapper {
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public Boolean hasParent;
        
        public OptionWrapper(String value, String label, Boolean hasParent) {
            this.value = value;
            this.label = label;
            this.hasParent = hasParent;
        }
    }
}