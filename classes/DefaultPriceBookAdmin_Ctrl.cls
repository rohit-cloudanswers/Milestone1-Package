public with sharing class DefaultPriceBookAdmin_Ctrl {
	public String recName {get;set;}
	public list<pricebook2> pbObj {get;set;}
	public list<profile> pObj {get;set;}
	public list<genWrap> genWrapList {get;set;}
	public list<SelectOption> pbOptions {get;set;}
	public String selectedPB {get;set;}
	public Boolean assignToCurrentUser {get;set;}
	public String currentUser;
	
	public DefaultPriceBookAdmin_Ctrl(apexpages.standardController std){
		currentUser = std.getId();
		genWrapList = new list<genWrap>();
		pbOptions = new list<SelectOption>();
		selectedPB = '';
		recName = '';
		pObj = new list<profile>();
		pObj = [Select id,name from profile];
		pbObj = new list<pricebook2>();
		pbObj = [Select id,name from pricebook2];
		system.debug('---pbObj---'+pbObj);
		for(pricebook2 each : pbObj){
			pbOptions.add(new selectOption(each.Id,each.name));
		}
		for(Profile each: pObj){
			genWrap w = new genWrap(each,false);
			genWrapList.add(w);
		}
	}
	public class genWrap{
		public profile prof{get;set;}
		public Boolean isSelected {get;set;}
		public genWrap(profile p,Boolean isSelected){
			this.prof = p;
			this.isSelected = isSelected;
		}
	}
	public void insertData(){
		list<Quote_PriceBook_Default__c> csList = new list<Quote_PriceBook_Default__c>();
		for(genWrap each:genWrapList ){
			if(each.isSelected){
				Quote_PriceBook_Default__c cs = new Quote_PriceBook_Default__c();
				//cs.name = recName;
				cs.SetupOwnerId = each.prof.Id;
				cs.PriceBookId__c = selectedPB;
				csList.add(cs);
			}
		}
		if(assignToCurrentUser){
			Quote_PriceBook_Default__c cs1= new Quote_PriceBook_Default__c();
			//cs1.name = recName;
			cs1.SetupOwnerId = currentUser;
			cs1.PriceBookId__c = selectedPB;
			csList.add(cs1);
		}
		system.debug('--csList-----'+csList);
		try{
			if(csList.size()>0)
			insert csList;
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.confirm,'Successfully inserted the data.'));
		}
		catch(exception e){
			if(e.getMessage().contains('SetupOwnerId duplicates value on record')){
				String recId = e.getMessage().split('id:')[1];
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,'One of the selected user/profile with id-'+recId+' already has a default pricebook,please delete that and then retry adding.'));
			}
			else
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,e.getMessage()));
		}
	}
}