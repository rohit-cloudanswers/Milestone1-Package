public with sharing class SolutionHierarchyGenerator {
	public String currentSolutionId {get;set;}
	public String currentSolutionName {get;set;}
	public list<Quote_Solutions__c> solList {get;set;}
	public list<Quote_Solutions__c> solList2 {get;set;}
	public list<QuoteLineItem> qLineItemList {get;set;}
	public String targetSol {get;set;}
	public Boolean showData {get;set;}
    
    public SolutionHierarchyGenerator(){
    	showData = false;
    	currentSolutionId = Apexpages.currentPage().getParameters().get('solId');
    	currentSolutionName = Apexpages.currentPage().getParameters().get('solName');
    	solList = new list<Quote_Solutions__c>();
    	solList2 = new list<Quote_Solutions__c>();
    	list<String> solList2Ids = new list<String>();
    	solList = [Select id,name,(Select id,name from Quote_Solutions__r) from Quote_Solutions__c where Parent_Solution__c =:currentSolutionId];
    	for(Quote_Solutions__c eachSol : solList){
    		for(Quote_Solutions__c eachCh : eachSol.Quote_Solutions__r){
    			solList2Ids.add(eachCh.Id);
    		}
    	}
    	solList2 = [Select id,name,Parent_Solution__c from Quote_Solutions__c where Parent_Solution__c in:solList2Ids];
    	if(solList.size()==0){
    		Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info,'There are no child solutions for this Solution set.'));
    	}
    }
    public void processLineItems(){
    	qLineItemList = new  list<QuoteLineItem>();
    	qLineItemList = [Select id,Product2.name,Discount from QuoteLineItem where Solution__c=:targetSol];
    	if(qLineItemList.size()>0)showData = true;
    	else  
    	{
    		Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,'No Quote line items found for this solution.'));
    		showData = false;
    	}
    }

}