public class QuoteDiscountBatch implements Database.Batchable<sObject> {
    
    public Set<Id> quotes {get; set;}

	public QuoteDiscountBatch(Set<Id> setQuotes){
		quotes = setQuotes;
	}

    public List<sObject> start(Database.BatchableContext bc) {
        return [
            select Id
			from Quote 
			where Id IN :quotes
        ];
    }
    
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
    	Set<Id> ids = new Set<Id>();
        for(Sobject q : scope){
           Quote qt = (Quote) q;
           ids.add(qt.Id);
        }
        
		updateQuotes(ids, bc.getJobId());
    }
    
    public void finish(Database.BatchableContext bc) {
        // do nothing
    }

    public static void updateQuotes(Set<Id> ids, String batchId){
    	Map<Id,QuoteDiscountWrapper> quote_discounts = QuoteDiscountBatch.summariseDiscounts(ids);
    	List<Quote> lstQuotes = new List<Quote>();
	  	for(Quote q: [
		  		select Id, Discount_Batch_Id__c, Hardware_Average_Discount__c,OEM_Average_Discount__c, 
		  		Service_Rate_Max_Discount__c, Software_Average_Discount__c, Support_Max_Discount__c, 
		  		Total_Discount_exc_Options__c, Managed_Services_Average_Discount__c
		  		from Quote 
		  		where Id in :ids
	  		]){
	  		q.Discount_Batch_Id__c = batchId;
	  		QuoteDiscountWrapper qw = quote_discounts.get(q.Id);
	  		if(qw == null) continue;
	  		if(qw.hardwareTotalAmount!= 0 ){
	  			q.Hardware_Average_Discount__c = ((qw.hardwareTotalAmount - qw.hardwareTotalDiscountAmount)/ qw.hardwareTotalAmount) * 100 ;
	  		}else if(qw.hardwareTotalAmount == 0 ){
	  			q.Hardware_Average_Discount__c = 0 ;
	  		}
	  		if(qw.oemTotalAmount!= 0 ){
	  			q.OEM_Average_Discount__c = ((qw.oemTotalAmount - qw.oemTotalDiscountAmount)/ qw.oemTotalAmount) * 100 ;
	  		}else if(qw.oemTotalAmount == 0 ){
	  			q.OEM_Average_Discount__c = 0 ;
	  		}
	  		if(qw.serviceTotalAmount!= 0 ){
	  			q.Service_Rate_Max_Discount__c = ((qw.serviceTotalAmount - qw.serviceTotalDiscountAmount)/ qw.serviceTotalAmount) * 100 ;
	  		}else if(qw.serviceTotalAmount == 0 ){
	  			q.Service_Rate_Max_Discount__c = 0 ;
	  		}
	  		if(qw.softwareTotalAmount!= 0 ){
	  			q.Software_Average_Discount__c = ((qw.softwareTotalAmount - qw.softwareTotalDiscountAmount)/ qw.softwareTotalAmount) * 100 ;
	  		}else if(qw.softwareTotalAmount == 0 ){
	  			q.Software_Average_Discount__c = 0 ;
	  		}
	  		if(qw.supportTotalAmount!= 0 ){
	  			q.Support_Max_Discount__c = ((qw.supportTotalAmount - qw.supportTotalDiscountAmount)/ qw.supportTotalAmount) * 100 ;
	  		}else if(qw.supportTotalAmount == 0 ){
	  			q.Support_Max_Discount__c = 0 ;
	  		}
	  		if(qw.managedServicesTotalAmount != 0){
	  			q.Managed_Services_Average_Discount__c = ((qw.managedServicesTotalAmount - qw.managedServicesTotalDiscountAmount) / qw.managedServicesTotalAmount) * 100;
	  		} else {
	  			q.Managed_Services_Average_Discount__c = 0;
	  		}
	  		if(qw.TotalExcl!= 0 ){
	  			q.Total_Discount_exc_Options__c = ((qw.TotalExcl - qw.TotalDsct)/qw.TotalExcl ) * 100 ;
	  		}else if(qw.TotalExcl == 0 ){
	  			q.Total_Discount_exc_Options__c = 0 ;
	  		}
	  		lstQuotes.add(q);
	  	}

	  	PopulateQuoteDiscounts.IS_BATCH_EXECUTED = true;
	  	update lstQuotes;
	  	PopulateQuoteDiscounts.IS_BATCH_EXECUTED = false;
    }

    public static  Map<Id,QuoteDiscountWrapper> summariseDiscounts(Set<Id> ids){
		Map<Id,QuoteDiscountWrapper> quote_discounts = new Map<Id,QuoteDiscountWrapper>();
	  	for(QuoteLineItem qli:[ SELECT Id, quoteId, UnitPrice, ListPrice, Quantity,Product_Type__c, TotalPrice, Solution_Optional__c,Product2.Product_Type__c FROM QuoteLineItem WHERE quoteId IN:ids]){
	  		QuoteDiscountWrapper qdw; 
	  		if(quote_discounts.containsKey(qli.quoteId)){
	  			qdw = quote_discounts.get(qli.quoteId);
	  		} else{
	  			qdw = new QuoteDiscountWrapper();
	  		}
	  		if(qli.Solution_Optional__c){
	  			quote_discounts.put(qli.quoteId, qdw);
	  			continue;
	  		}
	  		if( qli.Product_Type__c == 'Support' ){
	  			if('OEM'.equals(qli.Product2.Product_Type__c)){
	  				if(qli.ListPrice != qli.UnitPrice){
	  					qdw.oemTotalAmount += qli.UnitPrice * qli.Quantity ;
		  			} else{
		  				qdw.oemTotalAmount += qli.ListPrice * qli.Quantity ;
		  			}
	  				qdw.oemTotalDiscountAmount += qli.TotalPrice;
	  			}else{
	  				if(qli.ListPrice != qli.UnitPrice){
		  				qdw.supportTotalAmount += qli.UnitPrice * qli.Quantity ;
		  			} else{
		  				qdw.supportTotalAmount += qli.ListPrice * qli.Quantity ;
		  			}
		  			qdw.supportTotalDiscountAmount += qli.TotalPrice;
		  		}
	  		} else if( qli.Product_Type__c == 'Professional Services'){
	  			if('OEM'.equals(qli.Product2.Product_Type__c)){
	  				if(qli.ListPrice != qli.UnitPrice){
	  					qdw.oemTotalAmount += qli.UnitPrice * qli.Quantity ;
		  			} else{
		  				qdw.oemTotalAmount += qli.ListPrice * qli.Quantity ;
		  			}
	  				qdw.oemTotalDiscountAmount += qli.TotalPrice;
	  			}else{
		  			if(qli.ListPrice != qli.UnitPrice){
		  				qdw.serviceTotalAmount += qli.UnitPrice * qli.Quantity ;
		  			} else{
		  				qdw.serviceTotalAmount += qli.ListPrice * qli.Quantity ;
		  			}
		  			qdw.serviceTotalDiscountAmount += qli.TotalPrice;
		  		}
	  		} else if( qli.Product_Type__c == 'Software'){
	  			if('OEM'.equals(qli.Product2.Product_Type__c)){
	  				if(qli.ListPrice != qli.UnitPrice){
	  					qdw.oemTotalAmount += qli.UnitPrice * qli.Quantity ;
		  			} else{
		  				qdw.oemTotalAmount += qli.ListPrice * qli.Quantity ;
		  			}
	  				qdw.oemTotalDiscountAmount += qli.TotalPrice;
	  			}else{
	  				if(qli.ListPrice != qli.UnitPrice){
		  				qdw.softwareTotalAmount += qli.UnitPrice * qli.Quantity ;
	  				}else{
	  					qdw.softwareTotalAmount += qli.ListPrice * qli.Quantity ;
	  				}
		  			qdw.softwareTotalDiscountAmount += qli.TotalPrice;
		  		}
	  		} else if(qli.Product_Type__c == 'Hardware'){
	  			if('OEM'.equals(qli.Product2.Product_Type__c)){
	  				if(qli.ListPrice != qli.UnitPrice){
	  					qdw.oemTotalAmount += qli.UnitPrice * qli.Quantity ;
		  			} else{
		  				qdw.oemTotalAmount += qli.ListPrice * qli.Quantity ;
		  			}
	  				qdw.oemTotalDiscountAmount += qli.TotalPrice;
	  			}else{
		  			if(qli.ListPrice != qli.UnitPrice){
		  				qdw.hardwareTotalAmount += qli.UnitPrice * qli.Quantity ;
	  				}else{
	  					qdw.hardwareTotalAmount += qli.ListPrice * qli.Quantity ;
	  				}
		  			qdw.hardwareTotalDiscountAmount += qli.TotalPrice;
		  		}
	  		} else if(qli.Product_Type__c == 'Managed Services'){
	  			if('OEM'.equals(qli.Product2.Product_Type__c)){
	  				if(qli.ListPrice != qli.UnitPrice){
	  					qdw.oemTotalAmount += qli.UnitPrice * qli.Quantity ;
		  			} else{
		  				qdw.oemTotalAmount += qli.ListPrice * qli.Quantity ;
		  			}
	  				qdw.oemTotalDiscountAmount += qli.TotalPrice;
	  			}else{
		  			if(qli.ListPrice != qli.UnitPrice){
		  				qdw.managedServicesTotalAmount += qli.UnitPrice * qli.Quantity ;
	  				}else{
	  					qdw.managedServicesTotalAmount += qli.ListPrice * qli.Quantity ;
	  				}
		  			qdw.managedServicesTotalDiscountAmount += qli.TotalPrice;
		  		}
	  		}

	  		if( !qli.Solution_Optional__c ){
	  			if(qli.ListPrice != qli.UnitPrice){
	  				qdw.TotalExcl += qli.UnitPrice * qli.Quantity ; 
	  			}else{
	  				qdw.TotalExcl += qli.ListPrice * qli.Quantity ; 
	  			}
	  			qdw.TotalDsct += qli.TotalPrice ;
	  		}

	  		quote_discounts.put(qli.quoteId, qdw);
	  	}
	  	return quote_discounts;
	}

    public class QuoteDiscountWrapper{

		public Decimal serviceTotalAmount {get;set;}
		public Decimal serviceTotalDiscountAmount {get;set;}
		public Decimal oemTotalAmount {get;set;}
		public Decimal oemTotalDiscountAmount {get;set;}
		public Decimal hardwareTotalAmount {get;set;}
		public Decimal hardwareTotalDiscountAmount {get;set;}
		public Decimal supportTotalAmount {get;set;}
		public Decimal supportTotalDiscountAmount {get;set;}
		public Decimal softwareTotalAmount {get;set;}
		public Decimal softwareTotalDiscountAmount {get;set;}
		public Decimal managedServicesTotalAmount {get;set;}
		public Decimal managedServicesTotalDiscountAmount {get;set;}

		public Decimal TotalExcl {get; set;}
		public Decimal TotalDsct {get; set;}
		public QuoteDiscountWrapper(){
			this.serviceTotalAmount = 0 ;
			this.serviceTotalDiscountAmount = 0;
			this.oemTotalAmount = 0;
			this.oemTotalDiscountAmount = 0;
			this.hardwareTotalAmount = 0;
			this.hardwareTotalDiscountAmount = 0;
			this.supportTotalAmount = 0;
			this.supportTotalDiscountAmount = 0;
			this.softwareTotalAmount = 0;
			this.softwareTotalDiscountAmount = 0;
			this.managedServicesTotalAmount = 0;
			this.managedServicesTotalDiscountAmount = 0;
			this.TotalExcl = 0;
			this.TotalDsct = 0;
		}
	}
}