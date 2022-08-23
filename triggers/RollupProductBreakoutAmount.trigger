trigger RollupProductBreakoutAmount on Product_Breakout__c (after delete, after insert, after update) {

    Set<id> opportunityIds = new Set<id>();
    List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
    map<Id,Double> OpportunityMap = new map<Id,Double>();

    if(Trigger.isInsert || Trigger.isUpdate )
    {
        for (Product_Breakout__c breakout : Trigger.new){
            opportunityIds.add(breakout.Opportunity__c);
        }
    }
    else if(Trigger.isDelete){
        for (Product_Breakout__c breakout : Trigger.old)
        {
            opportunityIds.add(breakout.Opportunity__c);
        }
        
    }

    List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Opportunity' and isActive=true and Name = 'Trials'];
    if(rtypes.size()>0)
    {
        for(Opportunity o: [Select Id,RecordTypeId from Opportunity where Id IN :OpportunityIds and RecordTypeId =: rtypes.get(0).Id])
        {
            OpportunityIds.remove(o.Id);
        }
    }      
    
    OpportunityMap.clear();
    
    //Produce a sum of Product Breakout Amount and add them to the map
    //use group by to have a single Opportunity Id with a single sum value
    for(AggregateResult q : [select Opportunity__c,sum(Product_Breakout_Amount__c)
      from Product_Breakout__c where Opportunity__c IN :OpportunityIds group by Opportunity__c]){
         OpportunityMap.put((Id)q.get('Opportunity__c'),(Double)q.get('expr0'));
    }
     
    //Run the for loop on Opportunity using the non-duplicate set of Opportunities Ids
    //Get the sum value from the map and create a list of Opportunities to update
    for(Opportunity o : [Select Id, SyncedQuoteId, Amount from Opportunity where Id IN :OpportunityIds]){
	    if(o.SyncedQuoteId == null)
	    {		
	       Double PaymentSum = OpportunityMap.get(o.Id);
	       o.Amount = PaymentSum;
	       OpportunitiesToUpdate.add(o);
	    }
    }
    if(!OpportunitiesToUpdate.isEmpty())
    { 
    	update OpportunitiesToUpdate;
    }
}