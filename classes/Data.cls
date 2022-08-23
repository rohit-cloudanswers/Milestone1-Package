public with sharing class Data {
	
	public Static Account Top {get;set;}
	public Static Account Parent1 {get;set;}
	public Static Account Parent2 {get;set;}
	public Static Account ChildP1 {get;set;}
	public Static Account ChildP2 {get;set;}
	
	public static list<Account> staticHierarchy{
		get{
			list<Account> allAccounts=new list<Account>();
			list<Account> parents = new list<Account>();
			Account Parent; 
			list<Account> children = new list<Account>();
			Account Child;
			list<Account> gchildren = new list<Account>();
			
			Account topAccount = new account(name='Top');
			top=TopAccount;
			insert topAccount;
			Parent= new Account(name='p1',parentid=topAccount.id);
			parent1=parent;
			parents.add(parent);
			parent=new Account(name='p2',parentid=topAccount.id);
			parent2=parent;
			parents.add(parent);
			insert Parents;
			Child = new Account(name='p1c1',parentid=parents[0].id);
			childP1=Child;
			children.add(child);
			Child = new Account(name='p1c2',parentid=parents[0].id);
			children.add(child);
			Child = new Account(name='p2c1',parentid=parents[1].id);
			childP2=child;
			children.add(child);
			Child = new Account(name='p2c2',parentid=parents[1].id);
			children.add(child);
			insert children;
			Child = new Account(name='p1c1g1',parentid=children[0].id);
			gchildren.add(child);
			Child = new Account(name='p1c1g2',parentid=children[0].id);
			gchildren.add(child);
			Child = new Account(name='p1c2g1',parentid=children[1].id);
			gchildren.add(child);
			Child = new Account(name='p1c2g1',parentid=children[1].id);
			gchildren.add(child);
			Child = new Account(name='p2c1g1',parentid=children[2].id);
			gchildren.add(child);
			Child = new Account(name='p2c1g2',parentid=children[2].id);
			gchildren.add(child);
			Child = new Account(name='p2c2g1',parentid=children[3].id);
			gchildren.add(child);
			Child = new Account(name='p2c2g2',parentid=children[3].id);
			gchildren.add(child);
			insert gchildren;
			
			allAccounts.add(TopAccount);
			allAccounts.addAll(Parents);
			allAccounts.addAll(children);
			allAccounts.addAll(gchildren);
			
			return allAccounts;
			
		}
		set;
	}
	
	public static void buildAccountHierarchy(Account parent, integer depth, integer width){
		list<Account> accounts=new list<Account>();
		for(integer i=depth;i>0;i--){
			accounts.addAll(addChildren(parent,width));
			if(i-1!=0){
				for(Account a : accounts){
					buildAccountHierarchy(a,i-1,width);
				}
			}
		}
		//return accounts;
	}
	
	public static list<Account> addChildren(Account act, integer numChildren){
		list<Account> children = new list<Account>();
		for(integer i=0;i<numChildren;i++){
			Account child = new Account(name=act.name+'-'+i, parentid=act.id);
			children.add(child);
		}
		insert children;
		return children;
	}
	
	public static list<Account> buildTopLevel(integer width){
		list<Account> accounts=new list<Account>();
		for(integer i=0;i<width;i++){
			Account topLevel = new Account(name='Top-'+i);
			accounts.add(topLevel);
		}
		insert accounts;
		return accounts;
	}
	

}