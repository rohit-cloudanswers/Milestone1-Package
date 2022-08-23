/**
 * 
 * In case of IMAGINE products the product LIST PRICE of all quoted products of the same 
 * product group (e.g. of all router parts) is summed up and then multiplied by the according 
 * MyCare SLA percentage (e.g. 5% in case of MYCARE-HW-PLATINUM for Imagine router products).
 *
 *
 * In case of ARISTA switches the QUANTITY of the quoted switches of each Arista switch type 
 * is summed up and then the total quantity multiplied by 12 will be the quantity for the 
 * according Arista SLA.
 *
 */
public class MyCareProductsController {

    private String quoteId;
    public Boolean processing {get; set;}
    
    public MyCareProductsController() {
        quoteId = ApexPages.currentPage().getParameters().get('id');
        processing = true;
    }
    
    public PageReference addSupportProducts() {
        if (quoteId != null && Approval.isLocked(quoteId)) {
			processing = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Quote Locked'));			
            return null;
        }
        Savepoint sp = Database.setSavepoint();
        try {
            Decimal supportDiscount = 0.0;
            if(String.isNotBlank(quoteId)) {
                Quote_Solutions__c solutionSet = getSupportSolutionSet(quoteId);
                Quote quote = [SELECT Id, Billing_Region__c, Billing_Sub_Region__c, Support_Type__c, Pricebook2Id, CurrencyIsoCode FROM Quote WHERE Id =: quoteId];
                if(String.isBlank(quote.Support_Type__c) || quote.Support_Type__c == 'None') {
                    // remove existing support line items
                    delete [select Id from QuoteLineItem where QuoteId = :quote.Id and (Product_Type__c = 'Support' or Solution__c = :solutionSet.Id)];
                }
                List<QuoteLineItem> qliList = [
                    SELECT Id, Quantity, Subtotal, Product2Id, Product2.Support_Product_MyCare__c, 
                    Product2.ProductCode, SLA_Discount__c, Product2.NonDiscountable__c, 
                    Product2.Support_Product_MyCare__r.Default_Support_Quantity__c, 
                    Product2.Support_Product_MyCare__r.Nondiscountable__c, Product2.Support_Product_MyCare__r.ProductCode, 
                    Product2.Support_Product_MyCare__r.Support_Rate__c, Product2.Support_Product_MyCarePlus__c, 
                    Product2.Support_Product_MyCarePlus__r.Default_Support_Quantity__c, 
                    Product2.Support_Product_MyCarePlus__r.Nondiscountable__c, Product2.Support_Product_MyCarePlus__r.ProductCode, 
                    Product2.Support_Product_MyCarePlus__r.Support_Rate__c, Product2.Support_Product_MyCareUniversal__c, 
                    Product2.Support_Product_MyCareUniversal__r.Default_Support_Quantity__c,
                    Product2.Support_Product_MyCareUniversal__r.Nondiscountable__c, Product2.Support_Product_MyCareUniversal__r.ProductCode,  
                    Product2.Support_Product_MyCareUniversal__r.Support_Rate__c, Quote.Support_Discount__c, Solution_Optional__c FROM QuoteLineItem 
                    WHERE QuoteId =: quote.Id AND Solution__c !=: solutionSet.Id AND Product_Type__c != 'Support' 
                    order by Solution__r.Parent_Order__c ASC, Solution__r.Order__c ASC
                ];
                Map<String, List<QuoteLineItem>> productSupportMap = new Map<String, List<QuoteLineItem>>();
                Map<String, Boolean> supportProductNotDiscountableMap = new Map<String, Boolean>();
                for(QuoteLineItem qli : qliList) {
                    if(quote.Support_Type__c == 'Care' && String.isNotBlank(qli.Product2.Support_Product_MyCare__c)) {
                        if(!productSupportMap.containsKey(qli.Product2.Support_Product_MyCare__c))
                            productSupportMap.put(qli.Product2.Support_Product_MyCare__c, new List<QuoteLineItem>());
                        productSupportMap.get(qli.Product2.Support_Product_MyCare__c).add(qli);
                        supportProductNotDiscountableMap.put(qli.Product2.Support_Product_MyCare__c, qli.Product2.Support_Product_MyCare__r.Nondiscountable__c);
                    } else if (quote.Support_Type__c == 'Care Plus' && String.isNotBlank(qli.Product2.Support_Product_MyCarePlus__c)) {
                        if(!productSupportMap.containsKey(qli.Product2.Support_Product_MyCarePlus__c))
                            productSupportMap.put(qli.Product2.Support_Product_MyCarePlus__c, new List<QuoteLineItem>());
                        productSupportMap.get(qli.Product2.Support_Product_MyCarePlus__c).add(qli);
                        supportProductNotDiscountableMap.put(qli.Product2.Support_Product_MyCarePlus__c, qli.Product2.Support_Product_MyCarePlus__r.Nondiscountable__c);
                    } else if (quote.Support_Type__c == 'MyCare+U' && String.isNotBlank(qli.Product2.Support_Product_MyCareUniversal__c)) {
                        if(!productSupportMap.containsKey(qli.Product2.Support_Product_MyCareUniversal__c))
                            productSupportMap.put(qli.Product2.Support_Product_MyCareUniversal__c, new List<QuoteLineItem>());
                        productSupportMap.get(qli.Product2.Support_Product_MyCareUniversal__c).add(qli);
                        supportProductNotDiscountableMap.put(qli.Product2.Support_Product_MyCareUniversal__c, qli.Product2.Support_Product_MyCareUniversal__r.Nondiscountable__c);
                    }
                    supportDiscount = qli.Quote.Support_Discount__c;
                }

                // query Special Support Rate records
                Map<Id, List<Special_Support_Rate__c>> specialSupportRates = new Map<Id, List<Special_Support_Rate__c>>();
                Set<String> supportProductIds = (Set<String>) productSupportMap.keySet();
                String specialRatesQuery = 'SELECT Id, Support_Rate__c, Product2__c, Account_Bill_To_Region__c, Account_Bill_To_Sub_Region__c FROM Special_Support_Rate__c ' +
                    'WHERE Product2__c IN :supportProductIds AND ';
                if(String.isNotBlank(quote.Billing_Region__c) && String.isNotBlank(quote.Billing_Sub_Region__c)) {
                    // region and sub-region are available
                    specialRatesQuery += '(Account_Bill_To_Region__c = \''+quote.Billing_Region__c+'\' OR Account_Bill_To_Sub_Region__c = \''+quote.Billing_Sub_Region__c+'\')';
                } else if (String.isNotBlank(quote.Billing_Region__c)) {
                    // only region is available
                    specialRatesQuery += 'Account_Bill_To_Region__c = \''+quote.Billing_Region__c+'\'';
                } else if (String.isNotBlank(quote.Billing_Sub_Region__c)) {
                    // only sub-region is available
                    specialRatesQuery += 'Account_Bill_To_Sub_Region__c = \''+quote.Billing_Sub_Region__c+'\'';
                } else {
                    // both region and sub-region are empty on quote
                    specialRatesQuery = '';
                }

                List<Special_Support_Rate__c> specialRates = new List<Special_Support_Rate__c>();
                if(specialRatesQuery.length() != 0) {
                    specialRates = Database.query(specialRatesQuery);
                    // categorize special rates by product id
                    for(Id supportProductId : supportProductIds) {
                        for(Special_Support_Rate__c specialRate : specialRates) {
                            if(supportProductId == specialRate.Product2__c) {
                                if(!specialSupportRates.containsKey(supportProductId)) {
                                    specialSupportRates.put(supportProductId, new List<Special_Support_Rate__c>());
                                }
                                specialSupportRates.get(supportProductId).add(specialRate);
                            }
                        }
                    }
                }
                
                List<QuoteLineItem> supportItems = [
                    select Id, UnitPrice, Quantity, Line_Discount__c, QuoteId, 
                    Solution__c, Product2Id, Product2.Default_Support_Quantity__c, 
                    PricebookEntryId from QuoteLineItem 
                    where QuoteId =: quote.Id and Solution__c = :solutionSet.Id
                ];
                List<PricebookEntry> entries = [
                    select Id, Product2Id, CurrencyIsoCode, UnitPrice  
                    from PricebookEntry 
                    where Pricebook2Id = :quote.Pricebook2Id 
                        and Product2.Quotable__c = true 
                        and Product2Id in :productSupportMap.keySet()
                ];
                // in Support solution set, one to one mapping between QLI and support product
                Map<String, QuoteLineItem> supportMap = new Map<String, QuoteLineItem>();
                for(QuoteLineItem qli : supportItems) {
                    supportMap.put(qli.Product2Id, qli);
                }
                
                Map<Id, QuoteLineItem> toUpdate = new Map<Id, QuoteLineItem>();                
                Map<String, QuoteLineItem> newSupportMap = new Map<String, QuoteLineItem>();
                Map<Id, QuoteLineItem> qliIdToSupportQliMap = new Map<Id, QuoteLineItem>();
                Map<String,Decimal> slaListPriceMap = new Map<String,Decimal>(); // KEY = supportProductId-qliProductId
                Integer quoteSolutionOrder = 1;
                for(String supportProductId : productSupportMap.keySet()) {
                    QuoteLineItem supportQLI = supportMap.get(supportProductId);
                    if(supportQLI == null) {
                        supportQLI = new QuoteLineItem(
                            UnitPrice = 0,
                            Quantity = 0,
                            Line_Discount__c = 0,
                            QuoteId = quote.Id,
                            Product2Id = supportProductId,
                            Solution__c = solutionSet.Id,
                            QuoteSolutionOrder__c = quoteSolutionOrder
                        );
                    } else {
                        supportQLI.Quantity = 0;
                        supportQLI.UnitPrice = 0;
                        supportQLI.QuoteSolutionOrder__c = quoteSolutionOrder;
                    }

                    Boolean isNotDiscountable = supportProductNotDiscountableMap.get(supportProductId);
                    supportQLI.Line_Discount__c = isNotDiscountable == true ? null : supportDiscount;
                    
                    quoteSolutionOrder++;
                    List<QuoteLineItem> qlis = productSupportMap.get(supportProductId);
                    slaListPriceMap.clear(); // KEY = supportProductId-qliProductId
                    for(QuoteLineItem qli : qlis) {
                        // use care support rates
                        Decimal slaListPrice = 0;
                        Decimal supportRate = null;
                        if(quote.Support_Type__c == 'Care') {
                            if(qli.Product2.Support_Product_MyCare__r.Default_Support_Quantity__c != null) {
                                if(qli.Solution_Optional__c == false) supportQLI.Quantity += qli.Quantity * getSupportQuantity(qli.Product2.Support_Product_MyCare__r);
                            } else {
                                supportQLI.Quantity = 1;
                            }
                            if(specialSupportRates.containsKey(qli.Product2.Support_Product_MyCare__c)) {
                                Special_Support_Rate__c specialRate = getSpecialRate(quote, specialSupportRates.get(qli.Product2.Support_Product_MyCare__c));
                                supportRate = specialRate.Support_Rate__c;
                                slaListPrice = (qli.Subtotal * (specialRate.Support_Rate__c / 100));
                                if(qli.Solution_Optional__c == false) supportQLI.UnitPrice += slaListPrice;
                            } else if(qli.Product2.Support_Product_MyCare__r.Support_Rate__c != null) {
                                supportRate = qli.Product2.Support_Product_MyCare__r.Support_Rate__c;
                                slaListPrice = (qli.Subtotal * (supportRate / 100));
                                if(qli.Solution_Optional__c == false) supportQLI.UnitPrice += slaListPrice;
                            } else {
                                // use price from pricebook
                                PricebookEntry entry = getPricebookEntry(entries, qli.Product2.Support_Product_MyCare__c);
                                if(entry != null) slaListPrice = entry.UnitPrice;
                                if(qli.Solution_Optional__c == false) slaListPriceMap.put(supportProductId + '-' + qli.Product2Id, slaListPrice);
                            }
                            // if(qli.Solution_Optional__c == false) supportQLI.UnitPrice += slaListPrice;
                            qli.Selected_SLA_Type__c = qli.Product2.Support_Product_MyCare__r.ProductCode;
                        } else if (quote.Support_Type__c == 'Care Plus') {
                            if(qli.Product2.Support_Product_MyCarePlus__r.Default_Support_Quantity__c != null) {
                                if(qli.Solution_Optional__c == false) supportQLI.Quantity += qli.Quantity * getSupportQuantity(qli.Product2.Support_Product_MyCarePlus__r);
                            } else {
                                supportQLI.Quantity = 1;
                            }
                            if(specialSupportRates.containsKey(qli.Product2.Support_Product_MyCarePlus__c)) {
                                Special_Support_Rate__c specialRate = getSpecialRate(quote, specialSupportRates.get(qli.Product2.Support_Product_MyCarePlus__c));
                                supportRate = specialRate.Support_Rate__c;
                                slaListPrice = (qli.Subtotal * (supportRate / 100));
                                if(qli.Solution_Optional__c == false) supportQLI.UnitPrice += slaListPrice;
                            } else if (qli.Product2.Support_Product_MyCarePlus__r.Support_Rate__c != null) {
                                supportRate = qli.Product2.Support_Product_MyCarePlus__r.Support_Rate__c;
                                slaListPrice = (qli.Subtotal * (qli.Product2.Support_Product_MyCarePlus__r.Support_Rate__c / 100));
                                if(qli.Solution_Optional__c == false) supportQLI.UnitPrice += slaListPrice;
                            } else {
                                // use price from pricebook
                                PricebookEntry entry = getPricebookEntry(entries, qli.Product2.Support_Product_MyCarePlus__c);
                                if(entry != null) slaListPrice = entry.UnitPrice;
                                if(qli.Solution_Optional__c == false) slaListPriceMap.put(supportProductId + '-' + qli.Product2Id, slaListPrice);
                            }
                            // if(qli.Solution_Optional__c == false) supportQLI.UnitPrice += slaListPrice;
                            qli.Selected_SLA_Type__c = qli.Product2.Support_Product_MyCarePlus__r.ProductCode;
                        } else if (quote.Support_Type__c == 'MyCare+U') {
                            if(qli.Product2.Support_Product_MyCareUniversal__r.Default_Support_Quantity__c != null) {
                                if(qli.Solution_Optional__c == false) supportQLI.Quantity += qli.Quantity * getSupportQuantity(qli.Product2.Support_Product_MyCareUniversal__r);
                            } else {
                                supportQLI.Quantity = 1;
                            }
                            if(specialSupportRates.containsKey(qli.Product2.Support_Product_MyCareUniversal__c)) {
                                Special_Support_Rate__c specialRate = getSpecialRate(quote, specialSupportRates.get(qli.Product2.Support_Product_MyCareUniversal__c));
                                supportRate = specialRate.Support_Rate__c;
                                slaListPrice = (qli.Subtotal * (supportRate / 100));
                                if(qli.Solution_Optional__c == false) supportQLI.UnitPrice += slaListPrice;
                            } else if (qli.Product2.Support_Product_MyCareUniversal__r.Support_Rate__c != null) {
                                supportRate = qli.Product2.Support_Product_MyCareUniversal__r.Support_Rate__c;
                                slaListPrice = (qli.Subtotal * (supportRate / 100));
                                if(qli.Solution_Optional__c == false) supportQLI.UnitPrice += slaListPrice;
                            } else {
                                // use price from pricebook
                                PricebookEntry entry = getPricebookEntry(entries, qli.Product2.Support_Product_MyCareUniversal__c);
                                if(entry != null) slaListPrice = entry.UnitPrice;
                                if(qli.Solution_Optional__c == false) slaListPriceMap.put(supportProductId + '-' + qli.Product2Id, slaListPrice);
                            }
                            qli.Selected_SLA_Type__c = qli.Product2.Support_Product_MyCareUniversal__r.ProductCode;
                        }
                        qli.SLA_List_Price__c = slaListPrice;
                        qli.SLA_Rate__c = supportRate;
                        qli.Annual_SLA_List_Price__c = slaListPrice;
                        if(qli.Product2.NonDiscountable__c == false) {
                            qli.SLA_Discount__c = supportQLI.Line_Discount__c;
                            qli.Annual_SLA_Net_Price__c = qli.SLA_Discount__c != null ? (slaListPrice - (slaListPrice * (qli.SLA_Discount__c / 100))) : slaListPrice;
                        } else {
                            qli.Annual_SLA_Net_Price__c = slaListPrice;
                        }
                        qli.Support_Discountable__c = !isNotDiscountable;
                        if(supportQLI.Id != null) {
                            qli.Support_QLI__c = supportQLI.Id;
                        } else {
                            qliIdToSupportQliMap.put(qli.Id, supportQLI);
                        }

                        if(qli.SLA_List_Price__c != null) toUpdate.put(qli.Id, qli);
                    }
                    
                    // don't double the price for Arista and Cisco products
                    if(!slaListPriceMap.isEmpty()) {
                        for(Decimal lp : slaListPriceMap.values()) {
                            supportQLI.UnitPrice += lp;
                        }
                    }

                    // append to new map
                    if(supportQLI.UnitPrice != null && supportQLI.UnitPrice != 0) newSupportMap.put(supportProductId, supportQLI);
                }
                // tie pricebook entries
                List<String> noEntries = new List<String>();
                for(String supportProductId : newSupportMap.keySet()) {
                    Boolean found = false;                    
                    for(PricebookEntry entry : entries) {
                        if(supportProductId == entry.Product2Id) {
                            if(newSupportMap.get(supportProductId).PricebookEntryId == null)
                                newSupportMap.get(supportProductId).PricebookEntryId = entry.Id;
                            found = true;
                            break;
                        }
                    }
                    if(found == false) {
                        noEntries.add(supportProductId);
                    }
                }
                if(noEntries.size() == 0) {
                    List<QuoteLineItem> newSupportItems = newSupportMap.values();
                    if(newSupportItems.size() != 0) {
                        // upsert support line items
                        upsert newSupportItems;
                        for(QuoteLineItem qli : toUpdate.values()){
                            if(qliIdToSupportQliMap.containsKey(qli.Id)){
                                qli.Support_QLI__c = qliIdToSupportQliMap.get(qli.Id).Id;
                            }
                        }
                        // update item lines
                        update toUpdate.values();
                    } else { 
                        // delete support items
                        List<QuoteLineItem> itemsToDelete = [
                            select Id 
                            from QuoteLineItem
                            where Solution__c =: solutionSet.Id 
                                or (QuoteId =: quoteId and Solution__c = null)
                        ];
                        delete itemsToDelete;
                        delete solutionSet;
                    }
                    processing = false;
                    return new PageReference('/' + quoteId);
                } else {
                    delete solutionSet;
                    throw new MyCareProductsException('No Pricebook Entry found for following Support products: ' + String.join(noEntries, ', '));
                    processing = false;
                    return null;
                }
            } else {
                processing = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a valid Quote.'));
                return null;
            }
        } catch (Exception ex) {
            processing = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() + ' at ' + ex.getLineNumber()));
            Database.rollback(sp);
            return null;
        }
    }

    @TestVisible
    private Decimal getSupportQuantity(Product2 product) {
        Decimal quantity = 0;
        if(product != null) {
            if(product.Default_Support_Quantity__c != null) {
                quantity = product.Default_Support_Quantity__c;
            } else {
                quantity = 1;
            }
        }
        return quantity;
    }

    @TestVisible
    private PricebookEntry getPricebookEntry(List<PricebookEntry> entries, Id productId) {
        PricebookEntry result = null;
        for(PricebookEntry entry : entries) {
            if(entry.Product2Id == productId) {
                result = entry;
                break;
            }
        }
        return result;
    }
    
    private Quote_Solutions__c getSupportSolutionSet(String quoteId) {
        List<Quote_Solutions__c> solutionSets = [
            SELECT Id, Name
            FROM Quote_Solutions__c 
            WHERE Name = 'Support' AND Quote__c =: quoteId
        ];
        if(solutionSets.size() != 0) {
            return solutionSets.get(0);
        } else {
            // set the order to be the last top level solution set when generated
            Decimal order = 1;
            for (Quote_Solutions__c qs : [select Order__c from Quote_Solutions__c where Quote__c = :quoteId and Parent_Solution__c = null order by Order__c desc limit 1]) {
                if (qs.Order__c != null && qs.Order__c > order) order = qs.Order__c;
            }
            order += 1; // increment past the biggest one

            Quote_Solutions__c supportSet = new Quote_Solutions__c(
                Name = 'Support',
                Quote__c = quoteId,
                Order__c = order
            );
            insert supportSet;
            return supportSet;
        }
    }

    private Special_Support_Rate__c getSpecialRate(Quote quote, List<Special_Support_Rate__c> rates) {
        Special_Support_Rate__c specialRate = null;
        Special_Support_Rate__c hasOnlyRegion = null;
        Special_Support_Rate__c hasOnlySubRegion = null;
        for(Special_Support_Rate__c rate : rates) {
            if(String.isNotBlank(quote.Billing_Region__c) && String.isNotBlank(quote.Billing_Sub_Region__c) 
                && quote.Billing_Region__c.equalsIgnoreCase(rate.Account_Bill_To_Region__c) && 
                quote.Billing_Sub_Region__c.equalsIgnoreCase(rate.Account_Bill_To_Sub_Region__c)) {
                specialRate = rate;
                break;
            } else if (String.isNotBlank(quote.Billing_Region__c) 
                && quote.Billing_Region__c.equalsIgnoreCase(rate.Account_Bill_To_Region__c)) {
                hasOnlyRegion = rate;
            } else if (String.isNotBlank(quote.Billing_Sub_Region__c) 
                && quote.Billing_Sub_Region__c.equalsIgnoreCase(rate.Account_Bill_To_Sub_Region__c)) {
                hasOnlySubRegion = rate;
            }
        }
        if(specialRate != null) {
            return specialRate;
        } else {
            specialRate = hasOnlyRegion != null ? hasOnlyRegion : hasOnlySubRegion != null ? hasOnlySubRegion : rates.get(0);
        }
        return specialRate;
    }
    
    public PageReference cancel() {
        return new PageReference('/' + quoteId);
    }
    
    public class MyCareProductsException extends Exception {}
}