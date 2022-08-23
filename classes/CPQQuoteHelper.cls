public with sharing class CPQQuoteHelper {
    
    public static Boolean hasRHRun = false;

    public static void addOppToUpdate(Map<Id, Opportunity> toUpdate, Id oppId, Id quoteId) {
        toUpdate.put(oppId, new Opportunity(
            Id=oppId,
            SBQQ__PrimaryQuote__c=quoteId
        ));
    }
    
    public static void addQuoteToUpdate(Map<Id, SBQQ__Quote__c> toUpdate, Id quoteId) {
        toUpdate.put(quoteId, new SBQQ__Quote__c(
            Id=quoteId,
            SBQQ__Primary__c=true
        ));
    }

    public static Map<Id, Set<String>> getDiscountFields(Map<Id, SBQQ__Quote__c> oldQuotes, Map<Id, SBQQ__Quote__c> newQuotes) {
        Map<Id, Set<String>> quoteDiscountFields = new Map<Id, Set<String>>();
        for (Id quoteId : oldQuotes.keySet()) {
            SBQQ__Quote__c oldValues = oldQuotes.get(quoteId);
            SBQQ__Quote__c newValues = newQuotes.get(quoteId);
            Set<String> updatedDiscountFields = getQuoteDiscountUpdates(oldValues, newValues);
            if (!updatedDiscountFields.isEmpty()) quoteDiscountFields.put(quoteId, updatedDiscountFields);
        }
        return quoteDiscountFields;
    }

    private static Set<String> getQuoteDiscountUpdates(SBQQ__Quote__c oldQuote, SBQQ__Quote__c newQuote) {
        Set<String> updatedFields = new Set<String>();
        Set<String> fieldsToCheck = new Set<String>{
            'Hardware_Discount__c',
            'OEM_Hardware_Discount__c',
            'Software_Discount__c',
            'OEM_Software_Discount__c',
            'Professional_Services_Discount__c',
            'OEM_Professional_Services_Discount__c',
            'Managed_Services_Discount__c',
            'OEM_Managed_Services_Discount__c',
            'Support_Discount__c',
            'OEM_Support_Discount__c',
			'SBQQ__CustomerDiscount__c'
        };
        for (String field : fieldsToCheck) {
            System.debug(oldQuote.get(field) + ' => ' + newQuote.get(field));
            if (oldQuote.get(field) != newQuote.get(field)) {
                updatedFields.add(field);
            }
        }
        return updatedFields;
    }

    public static void applyDiscountByProductType(Map<Id, Set<String>> quoteDiscountUpdates, Map<Id, Set<String>> quoteMarginUpdates, Map<Id, SBQQ__Quote__c> quotes) {
        // only run for one quote at a time
        if (quoteDiscountUpdates.size() == 1) {
            List<SBQQ__QuoteLine__c> quoteLines = [
                select Id, SBQQ__ListPrice__c, Product_Cost__c, Product_Type__c, 
                Salesforce_Product_Type__c, SBQQ__ListTotal__c, Total_Cost__c, SBQQ__Discount__c, 
                SBQQ__Product__r.SBQQ__NonDiscountable__c, SBQQ__Quote__c, SBQQ__ProductCode__c, SBQQ__Bundle__c
                from SBQQ__QuoteLine__c where SBQQ__Quote__c IN :quoteDiscountUpdates.keySet() and 
                SBQQ__Product__r.SBQQ__NonDiscountable__c = false and SBQQ__Optional__c = false
            ];
            
            if (!quoteLines.isEmpty()) {
                Id quoteId = quoteLines.get(0).SBQQ__Quote__c;
                // calculate totals
                Map<String, Decimal> typeTotals = calculateTypeTotals(quoteLines);
                // calculate average discounts for product line
                SBQQ__Quote__c qt = quotes.get(quoteId);
                Set<String> discountFields = quoteDiscountUpdates.get(quoteId);
                calculateTotalMargins(qt, discountFields, typeTotals);
            }
        }
    }
    
    public static Map<Id, Set<String>> getMarginFields(Map<Id, SBQQ__Quote__c> oldQuotes, Map<Id, SBQQ__Quote__c> newQuotes) {
        Map<Id, Set<String>> quoteMarginFields = new Map<Id, Set<String>>();
        for (Id quoteId : oldQuotes.keySet()) {
            SBQQ__Quote__c oldValues = oldQuotes.get(quoteId);
            SBQQ__Quote__c newValues = newQuotes.get(quoteId);
            Set<String> updatedMarginFields = getQuoteMarginUpdates(oldValues, newValues);
            if (!updatedMarginFields.isEmpty()) quoteMarginFields.put(quoteId, updatedMarginFields);
        }
        return quoteMarginFields;
    }
    
    private static Set<String> getQuoteMarginUpdates(SBQQ__Quote__c oldQuote, SBQQ__Quote__c newQuote) {
        Set<String> updatedFields = new Set<String>();
        Set<String> fieldsToCheck = new Set<String>{
            'Hardware_Margin__c',
            'OEM_Hardware_Margin__c',
            'Software_Margin__c',
            'OEM_Software_Margin__c',
            'Professional_Services_Margin__c',
            'OEM_Professional_Services_Margin__c',
            'Managed_Services_Margin__c',
            'OEM_Managed_Services_Margin__c',
            'Support_Margin_Input__c',
            'OEM_Support_Margin__c'
        };
        for (String field : fieldsToCheck) {
            System.debug(oldQuote.get(field) + ' => ' + newQuote.get(field));
            if (oldQuote.get(field) != newQuote.get(field)) {
                updatedFields.add(field);
            }
        }
        return updatedFields;
    }
    
    public static void applyMarginByProductType(Map<Id, Set<String>> quoteMarginUpdates, Map<Id, SBQQ__Quote__c> quotes) {
        // only run for one quote at a time
        if (quoteMarginUpdates.size() == 1) {
            List<SBQQ__QuoteLine__c> quoteLines = [
                select Id, SBQQ__ListPrice__c, Product_Cost__c, Product_Type__c, Salesforce_Product_Type__c,
                SBQQ__Discount__c, SBQQ__Product__r.SBQQ__Nondiscountable__c, SBQQ__Quote__c, Total_Cost__c,
                SBQQ__ListTotal__c, SBQQ__ProductCode__c, SBQQ__Bundle__c
                from SBQQ__QuoteLine__c where SBQQ__Quote__c IN :quoteMarginUpdates.keySet() and 
                SBQQ__Product__r.SBQQ__Nondiscountable__c = false and SBQQ__Optional__c = false
            ];
            
            if (!quoteLines.isEmpty()) {
                Id quoteId = quoteLines.get(0).SBQQ__Quote__c;
                // calculate totals
                Map<String, Decimal> typeTotals = calculateTypeTotals(quoteLines);
                // calculate average discounts for product line
                SBQQ__Quote__c qt = quotes.get(quoteId);
                Set<String> marginFields = quoteMarginUpdates.get(quoteId);
                calculateTotalDiscounts(qt, marginFields, typeTotals);
            }
        }
    }

    // calculate totals by product types
	@TestVisible
    private static Map<String, Decimal> calculateTypeTotals(List<SBQQ__QuoteLine__c> quoteLines) {
        Map<String, Decimal> typeTotals = new Map<String, Decimal>();
        for (SBQQ__QuoteLine__c ql : quoteLines) {
            Decimal productCost = ql.Total_Cost__c == null ? 0 : ql.Total_Cost__c;
            if (ql.SBQQ__ProductCode__c != null && ql.SBQQ__ProductCode__c.indexOf('Support Package') == 0 && ql.SBQQ__Bundle__c == true) continue;
            if (ql.Salesforce_Product_Type__c == 'Hardware') {
                if (ql.Product_Type__c == 'OEM') {
                    // OEM Hardware
                    if (!typeTotals.containsKey('OEMHardware_TotalLP')) typeTotals.put('OEMHardware_TotalLP', 0);
                    typeTotals.put('OEMHardware_TotalLP', typeTotals.get('OEMHardware_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('OEMHardware_TotalPC')) typeTotals.put('OEMHardware_TotalPC', 0);
                    typeTotals.put('OEMHardware_TotalPC', typeTotals.get('OEMHardware_TotalPC') + productCost);
                } else {
                    // Hardware
                    if (!typeTotals.containsKey('Hardware_TotalLP')) typeTotals.put('Hardware_TotalLP', 0);
                    typeTotals.put('Hardware_TotalLP', typeTotals.get('Hardware_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('Hardware_TotalPC')) typeTotals.put('Hardware_TotalPC', 0);
                    typeTotals.put('Hardware_TotalPC', typeTotals.get('Hardware_TotalPC') + productCost);
                }
            } else if (ql.Salesforce_Product_Type__c == 'Software') {
                if (ql.Product_Type__c == 'OEM') {
                    // OEM Software
                    if (!typeTotals.containsKey('OEMSoftware_TotalLP')) typeTotals.put('OEMSoftware_TotalLP', 0);
                    typeTotals.put('OEMSoftware_TotalLP', typeTotals.get('OEMSoftware_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('OEMSoftware_TotalPC')) typeTotals.put('OEMSoftware_TotalPC', 0);
                    typeTotals.put('OEMSoftware_TotalPC', typeTotals.get('OEMSoftware_TotalPC') + productCost);
                } else {
                    // Software
                    if (!typeTotals.containsKey('Software_TotalLP')) typeTotals.put('Software_TotalLP', 0);
                    typeTotals.put('Software_TotalLP', typeTotals.get('Software_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('Software_TotalPC')) typeTotals.put('Software_TotalPC', 0);
                    typeTotals.put('Software_TotalPC', typeTotals.get('Software_TotalPC') + productCost);
                }
            } else if (ql.Salesforce_Product_Type__c == 'Professional Services') {
                if (ql.Product_Type__c == 'OEM') {
                    // OEM Professional Services
                    if (!typeTotals.containsKey('OEMPS_TotalLP')) typeTotals.put('OEMPS_TotalLP', 0);
                    typeTotals.put('OEMPS_TotalLP', typeTotals.get('OEMPS_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('OEMPS_TotalPC')) typeTotals.put('OEMPS_TotalPC', 0);
                    typeTotals.put('OEMPS_TotalPC', typeTotals.get('OEMPS_TotalPC') + productCost);
                } else {
                    // Professional Services
                    if (!typeTotals.containsKey('PS_TotalLP')) typeTotals.put('PS_TotalLP', 0);
                    typeTotals.put('PS_TotalLP', typeTotals.get('PS_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('PS_TotalPC')) typeTotals.put('PS_TotalPC', 0);
                    typeTotals.put('PS_TotalPC', typeTotals.get('PS_TotalPC') + productCost);
                }
            } else if (ql.Salesforce_Product_Type__c == 'Managed Services') {
                if (ql.Product_Type__c == 'OEM') {
                    // OEM Managed Services
                    if (!typeTotals.containsKey('OEMMS_TotalLP')) typeTotals.put('OEMMS_TotalLP', 0);
                    typeTotals.put('OEMMS_TotalLP', typeTotals.get('OEMMS_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('OEMMS_TotalPC')) typeTotals.put('OEMMS_TotalPC', 0);
                    typeTotals.put('OEMMS_TotalPC', typeTotals.get('OEMMS_TotalPC') + productCost);
                } else {
                    // Managed Services
                    if (!typeTotals.containsKey('MS_TotalLP')) typeTotals.put('MS_TotalLP', 0);
                    typeTotals.put('MS_TotalLP', typeTotals.get('MS_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('MS_TotalPC')) typeTotals.put('MS_TotalPC', 0);
                    typeTotals.put('MS_TotalPC', typeTotals.get('MS_TotalPC') + productCost);
                }
            } else if (ql.Salesforce_Product_Type__c == 'Support') {
                if (ql.Product_Type__c == 'OEM') {
                    // OEM Support
                    if (!typeTotals.containsKey('OEMSupport_TotalLP')) typeTotals.put('OEMSupport_TotalLP', 0);
                    typeTotals.put('OEMSupport_TotalLP', typeTotals.get('OEMSupport_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('OEMSupport_TotalPC')) typeTotals.put('OEMSupport_TotalPC', 0);
                    typeTotals.put('OEMSupport_TotalPC', typeTotals.get('OEMSupport_TotalPC') + productCost);
                } else {
                    // Support
                    if (!typeTotals.containsKey('Support_TotalLP')) typeTotals.put('Support_TotalLP', 0);
                    typeTotals.put('Support_TotalLP', typeTotals.get('Support_TotalLP') + ql.SBQQ__ListTotal__c);
                    if (!typeTotals.containsKey('Support_TotalPC')) typeTotals.put('Support_TotalPC', 0);
                    typeTotals.put('Support_TotalPC', typeTotals.get('Support_TotalPC') + productCost);
                }
            }
        }
        return typeTotals;
    }

    @TestVisible
    private static void calculateTotalDiscounts(SBQQ__Quote__c qt, Set<String> marginFields, Map<String, Decimal> typeTotals) {
        for (String field : marginFields) {
            if (qt.get(field) != null) {
                Decimal margin = ((Decimal) qt.get(field)) / 100;
                Decimal totalPrice, totalCost, discount;
                if (field == 'Hardware_Margin__c') {
                    totalPrice = typeTotals.get('Hardware_TotalLP');
                    totalCost = typeTotals.get('Hardware_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.Hardware_Discount__c = discount - getAdditionalDiscount(qt);
                } else if (field == 'OEM_Hardware_Margin__c') {
                    totalPrice = typeTotals.get('OEMHardware_TotalLP');
                    totalCost = typeTotals.get('OEMHardware_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.OEM_Hardware_Discount__c = discount - getAdditionalDiscount(qt);
                } else if (field == 'Software_Margin__c') {
                    totalPrice = typeTotals.get('Software_TotalLP');
                    totalCost = typeTotals.get('Software_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.Software_Discount__c = discount - getAdditionalDiscount(qt);
                } else if (field == 'OEM_Software_Margin__c') {
                    totalPrice = typeTotals.get('OEMSoftware_TotalLP');
                    totalCost = typeTotals.get('OEMSoftware_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.OEM_Software_Discount__c = discount - getAdditionalDiscount(qt);
                } else if (field == 'Professional_Services_Margin__c') {
                    totalPrice = typeTotals.get('PS_TotalLP');
                    totalCost = typeTotals.get('PS_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.Professional_Services_Discount__c = discount - getAdditionalDiscount(qt);
                } else if (field == 'OEM_Professional_Services_Margin__c') {
                    totalPrice = typeTotals.get('OEMPS_TotalLP');
                    totalCost = typeTotals.get('OEMPS_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.OEM_Professional_Services_Discount__c = discount - getAdditionalDiscount(qt);
                } else if (field == 'Managed_Services_Margin__c') {
                    totalPrice = typeTotals.get('MS_TotalLP');
                    totalCost = typeTotals.get('MS_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.Managed_Services_Discount__c = discount - getAdditionalDiscount(qt);
                } else if (field == 'OEM_Managed_Services_Margin__c') {
                    totalPrice = typeTotals.get('OEMMS_TotalLP');
                    totalCost = typeTotals.get('OEMMS_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.OEM_Managed_Services_Discount__c = discount - getAdditionalDiscount(qt);
                } else if (field == 'Support_Margin_Input__c') {
                    totalPrice = typeTotals.get('Support_TotalLP');
                    totalCost = typeTotals.get('Support_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.Support_Discount__c = discount - getAdditionalDiscount(qt);
                } else if (field == 'OEM_Support_Margin__c') {
                    totalPrice = typeTotals.get('OEMSupport_TotalLP');
                    totalCost = typeTotals.get('OEMSupport_TotalPC');
                    discount = calculateDiscount(totalPrice, totalCost, margin);
                    qt.OEM_Support_Discount__c = discount - getAdditionalDiscount(qt);
                }
            }
        }
    }
    
    public static Decimal calculateDiscount(Decimal totalPrice, Decimal totalCost, Decimal margin) {
        if (totalPrice == null) return 0;
        if (totalCost == null) totalCost = 0;
        Decimal discount = ((totalPrice * (1 - margin)) - totalCost) / (totalPrice * (1 - margin));
        discount = discount * 100;
        discount = discount.setScale(2, RoundingMode.HALF_UP);
        return discount;
    }
    
    public static Decimal getAdditionalDiscount(SBQQ__Quote__c qt) {
        Decimal discount = qt.SBQQ__CustomerDiscount__c;
        if (discount == null) discount = 0;
        discount = discount.setScale(2, RoundingMode.HALF_UP);
        return discount;
    }

    @TestVisible
    private static void calculateTotalMargins(SBQQ__Quote__c qt, Set<String> marginFields, Map<String, Decimal> typeTotals) {
        for (String field : marginFields) {
            if (qt.get(field) != null) {
                Decimal discount = ((Decimal) qt.get(field)) / 100;
                Decimal totalPrice, totalCost, margin;
                if (field == 'Hardware_Discount__c') {
                    totalPrice = typeTotals.get('Hardware_TotalLP');
                    totalCost = typeTotals.get('Hardware_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.Hardware_Margin__c = margin;
                } else if (field == 'OEM_Hardware_Discount__c') {
                    totalPrice = typeTotals.get('OEMHardware_TotalLP');
                    totalCost = typeTotals.get('OEMHardware_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.OEM_Hardware_Margin__c = margin;
                } else if (field == 'Software_Discount__c') {
                    totalPrice = typeTotals.get('Software_TotalLP');
                    totalCost = typeTotals.get('Software_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.Software_Margin__c = margin;
                } else if (field == 'OEM_Software_Discount__c') {
                    totalPrice = typeTotals.get('OEMSoftware_TotalLP');
                    totalCost = typeTotals.get('OEMSoftware_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.OEM_Software_Margin__c = margin;
                } else if (field == 'Professional_Services_Discount__c') {
                    totalPrice = typeTotals.get('PS_TotalLP');
                    totalCost = typeTotals.get('PS_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.Professional_Services_Margin__c = margin;
                } else if (field == 'OEM_Professional_Services_Discount__c') {
                    totalPrice = typeTotals.get('OEMPS_TotalLP');
                    totalCost = typeTotals.get('OEMPS_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.OEM_Professional_Services_Margin__c = margin;
                } else if (field == 'Managed_Services_Discount__c') {
                    totalPrice = typeTotals.get('MS_TotalLP');
                    totalCost = typeTotals.get('MS_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.Managed_Services_Margin__c = margin;
                } else if (field == 'OEM_Managed_Services_Discount__c') {
                    totalPrice = typeTotals.get('OEMMS_TotalLP');
                    totalCost = typeTotals.get('OEMMS_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.OEM_Managed_Services_Margin__c = margin;
                } else if (field == 'Support_Discount__c') {
                    totalPrice = typeTotals.get('Support_TotalLP');
                    totalCost = typeTotals.get('Support_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.Support_Margin_Input__c = margin;
                } else if (field == 'OEM_Support_Discount__c') {
                    totalPrice = typeTotals.get('OEMSupport_TotalLP');
                    totalCost = typeTotals.get('OEMSupport_TotalPC');
                    margin = calculateMargin(totalPrice, totalCost, discount);
                    qt.OEM_Support_Margin__c = margin;
                }
            }
        }
    }

    public static Decimal calculateMargin(Decimal totalPrice, Decimal totalCost, Decimal discount) {
        if (totalPrice == null) return 0;
        if (totalCost == null) totalCost = 0;
        Decimal margin = ((totalPrice * (discount - 1)) + totalCost) / (totalPrice * (discount - 1));
        margin = margin * 100;
        margin = margin.setScale(2, RoundingMode.HALF_UP);
        return margin;
    }
}