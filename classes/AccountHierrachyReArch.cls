public without sharing class AccountHierrachyReArch {
    //Declare variables
    public String currentId;
    public List<ObjectStructureMap> asm ;
    public Map<String, ObjectStructureMap> masm;
    public List<Integer> maxLevel;
    public list<String> sIds;
    public map<String,list<quoteLineItem>> solIdVsQLitems {get;set;}
    public map<String,Boolean> solIdVsRender {get;set;}
    public String quoteId {get;set;}
    public quote qt {get;set;}
    public String txtArea {get;set;}
    public String qName {get;set;}
    public String dToday {get;set;}
    public Quote_Solutions__c newSol {get;set;}
    public list<quoteLineItem> itemsWithNoSolutions {get;set;}
    public Boolean showType {get;set;}
    public Boolean showDisc {get;set;}
    public Boolean userType {get;set;}
    public String selectedType {get;set;}
     public map<String,String> solIds {get;set;}
     public list<String> sols {get;set;}
     public map<String,Decimal> solVsAmount {get;set;}
     public Decimal qtAmount {get;set;}
     public Decimal qtAmountAfterDisc {get;set;}
     public Decimal solTotal  {get;set;}
     public String docGen {get;set;}
     public String DocumentLogoUrl {get;set;}
     public String effDate {get;set;}
      public String vaildDate {get;set;}
    /**
    * Contructor
    */
    public AccountHierrachyReArch(apexpages.standardController std) {
        this.asm = new List<ObjectStructureMap>{};
        this.masm = new Map<String, ObjectStructureMap>{};
        this.maxLevel = new List<Integer>{};
        showType = true;
        selectedType='';
        docGen = '';
        qt = new quote();
        quoteId = std.getId();
        newSol = new Quote_Solutions__c();
        newSol.isActive__c = true;
        newSol.Quote__c = quoteId;
        String sType = apexPages.currentPage().getParameters().get('showType');
        if(sType!=null)showType = Boolean.valueOf(sType);
        String sDisc = apexPages.currentPage().getParameters().get('showDisc');
        docGen = apexPages.currentPage().getParameters().get('docGen');
        if(sDisc!=null)showDisc = Boolean.valueOf(sDisc);
        qt = [Select Account.Payment_Terms__c,Contact.name,priceBook2.currencyisocode,Account.Freight_Terms__c,Opportunity.Owner.name,Opportunity.owner.title,opportunity.owner.Street,opportunity.owner.City,opportunity.owner.State,opportunity.owner.PostalCode,opportunity.owner.Country,
                opportunity.owner.MobilePhone,opportunity.owner.fax,opportunity.owner.email,Account.name,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingPostalCode,account.BillingCountry,Effective__c,BillingName,BillingStreet,BillingCity,BillingState,
                BillingCountry,BillingPostalCode,ShippingName,ShippingStreet,ShippingCity,Quote_Version__c,ShippingState,ShippingPostalCode,ShippingCountry,ExpirationDate,QuoteNumber,
                UserEnteredData_Dummy__c,Bill_To_Contact__r.name,Ship_To_Contact__r.name from quote where id=:quoteId];
        dToday = string.valueOf(date.today());
        effDate = String.valueOf(date.valueOf(qt.Effective__c)).split('00:')[0];
        vaildDate = String.valueOf(date.valueOf(qt.ExpirationDate)).split('00:')[0];
        itemsWithNoSolutions = new  list<quoteLineItem>();
        list<quoteLineItem> qlItem = [Select id,product2.Description,TotalPrice,Solution__c,Solution__r.name,Quote.Quote_Name__c,product2.name,quoteId,
                                                        Quantity,Part_Number__c,Part_No__c,Long_Description__c,ListPrice,subtotal,Discount,Extended_List_Price__c 
                                                        from QuoteLineItem where QuoteId =:quoteId];
        solIds = new map<String,String>();
        set<String> solset = new set<String>();
        sols  = new list<String>();
        solVsAmount = new map<String,Decimal>();
        qtAmount=0.0;
        qtAmountAfterDisc = 0.0;
        for(quoteLineItem each : qlItem){
            solIds.put(each.Solution__c,each.Solution__r.name);
            solset.add(each.Solution__c);
            if(each.Discount == null)each.Discount = 0;
            qtAmount+=(each.Discount*each.subtotal)/100;
            if(each.Solution__c == null)
            itemsWithNoSolutions.add(each);
        }
        for(String eachString : solset){
            sols.add(eachString);
        }
        for(String each : solIds.keySet()){
            for(quoteLineItem eachQl : qlItem){
                if(eachQl.Solution__c == each && eachQl.Solution__c!=null){
                    if(!solVsAmount.containsKey(each)){
                        solVsAmount.put(each,eachQl.subtotal);
                    }
                    else{
                        Decimal amt = eachQl.subtotal+solVsAmount.get(each);
                        solVsAmount.put(each,amt);
                    }
                }
            }
        }
        solTotal =0.0;
        for(Decimal each : solVsAmount.values()){
            solTotal+=each;
        }
        if(solTotal != 0.0)
        qtAmountAfterDisc = solTotal - qtAmount;
        else
        qtAmountAfterDisc = qtAmount;
        if(qlItem.size()>0)
        qName = qlItem[0].Quote.Quote_Name__c;
        if(qlItem.size()>0 && qlItem[0].Solution__c != null)
        currentId = qlItem[0].Solution__c;
        
        if(System.currentPageReference().getParameters().get( 'renderAs' ) == null ){
         qt.UserEnteredData_Dummy__c = dToday + '\n' + 'Quote Name:' + qName + '\n';
        }
        List<Document> lstDocument = [Select Id,Name,LastModifiedById from Document where DeveloperName = 'Imagine_Logo' limit 1];
        string strOrgId = UserInfo.getOrganizationId();
        DocumentLogoUrl = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+ '/servlet/servlet.ImageServer?id='+lstDocument[0].Id+'&oid=' + strOrgId;
        system.debug('*******DocumentLogoUrl********'+DocumentLogoUrl);
        isPartnerUser();
    }
    public void switchType(){
        showType = false;
        if(selectedType == 'showDisc')showDisc = true;
        else showDisc = false;
    }
   public void saveSolution(){
    try{
        insert newSol;
        newSol = new Quote_Solutions__c(Quote__c = quoteId);
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.confirm,'Save successful.'));
    }
    catch(exception e){
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,e.getMessage()));
    }
   }
   public Pagereference renderAsPDF(){
    system.debug('Sarath --> qt.UserEnteredData_Dummy__c:'+qt.UserEnteredData_Dummy__c);
    //update qt;
    system.debug('Sarath --> qt.UserEnteredData_Dummy__c:'+qt.UserEnteredData_Dummy__c);
    Pagereference pr = new Pagereference('/apex/solutionHierarchy_tabular?renderAs=pdf&id='+quoteId+'&showType=false&showDisc='+showDisc+'&docGen=true');
    pr.setRedirect(true); 
    return pr;
   }
   public Pagereference renderAsWord(){
    //update qt;
    //Pagereference pr = new Pagereference('/apex/solutionHierarchy_tabular_Word?renderAs=word&id='+quoteId+'&showType=false&showDisc='+showDisc+'&docGen=true');
    Pagereference pr = new Pagereference('/apex/solutionHierarchy_tabular_WordNew?renderAs=word&id='+quoteId+'&showType=false&showDisc='+showDisc+'&docGen=true');
    pr.setRedirect(true); 
    return pr;
   }
    /**
    * Allow page to set the current ID
    */
    public void setcurrentId( String cid ){
        currentId = cid;
    }

    /**
    * Return ObjectStructureMap to page
    * @return asm
    */
    public List<ObjectStructureMap> getObjectStructure(){
        try{
            asm.clear();
            if ( currentId == null ) {
                currentId = System.currentPageReference().getParameters().get( 'id' );
            }
            
            System.assertNotEquals( currentId, null, 'sObject ID must be provided' );
            asm = formatObjectStructure( CurrentId );
        }
        catch(exception e){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info,'Hierarchy cannot be generated at this time,please try later.'+e.getMessage()));
        }
        system.debug('----asm-------'+asm);
        return asm;
    }

    /**
    * Query Account from top down to build the ObjectStructureMap
    * @param currentId
    * @return asm
    */
    public ObjectStructureMap[] formatObjectStructure( String currentId ){
    
        List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
        masm.clear();

        //Change below
        List<Quote_Solutions__c> al            = new List<Quote_Solutions__c>{};
        List<ID> currentParent      = new List<ID>{};
        Map<ID, String> nodeList    = new Map<ID, String>{};
        List<String> nodeSortList   = new List<String>{};
        List<Boolean> levelFlag     = new List<Boolean>{};
        List<Boolean> closeFlag     = new List<Boolean>{};
        String nodeId               = '0';
        String nodeType             = 'child';
        Integer count               = 0;
        Integer level               = 0;
        Boolean endOfStructure      = false;
        
        //Find highest level obejct in the structure
        currentParent.add( GetTopElement( currentId ) );

        //Loop though all children
        while ( !endOfStructure ){

            if( level == 0 ){
                //Change below     
                al = [ Select id,name,Parent_Solution__c from Quote_Solutions__c where id IN : CurrentParent and Quote__c =:quoteId ORDER BY Name ];
            } 
            else {
                //Change below      
                al = [Select id,name,Parent_Solution__c from Quote_Solutions__c where Parent_Solution__c IN : CurrentParent and Quote__c =:quoteId ORDER BY Name ];
            }

            if( al.size() == 0 ){
                endOfStructure = true;
            }
            else{
                currentParent.clear();
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    //Change below
                    Quote_Solutions__c a = al[i];
                    nodeId = ( level > 0 ) ? NodeList.get( a.Parent_Solution__c )+'.'+String.valueOf( i ) : String.valueOf( i );
                    masm.put( NodeID, new ObjectStructureMap( nodeID, levelFlag, closeFlag, nodeType, false, false,level,a.id, a ) );
                    currentParent.add( a.id );
                    nodeList.put( a.id,nodeId );
                    nodeSortList.add( nodeId );
                }
                
                maxLevel.add( level );                
                level++;
            }
        }
        
        //Account structure must now be formatted
        NodeSortList.sort();
        for( Integer i = 0; i < NodeSortList.size(); i++ ){
            List<String> pnl = new List<String> {};
            List<String> cnl = new List<String> {};
            List<String> nnl = new List<String> {};
            
            if ( i > 0 ){
                String pn   = NodeSortList[i-1];
                pnl         = pn.split( '\\.', -1 );
            }

            String cn   = NodeSortList[i];
            cnl         = cn.split( '\\.', -1 );

            if( i < NodeSortList.size()-1 ){
                String nn = NodeSortList[i+1];
                nnl = nn.split( '\\.', -1 );
            }
            
            ObjectStructureMap tasm = masm.get( cn );
            if ( cnl.size() < nnl.size() ){
                //Parent
                tasm.nodeType = ( isLastNode( cnl ) ) ? 'parent_end' : 'parent';
            }
            else if( cnl.size() > nnl.size() ){
                tasm.nodeType   = 'child_end';
                tasm.closeFlag  = setcloseFlag( cnl, nnl, tasm.nodeType );
            }
            else{
                tasm.nodeType = 'child';
            }
            
            tasm.levelFlag = setlevelFlag( cnl, tasm.nodeType ); 
            
            //Change below
            if ( tasm.solution.id == currentId ) {
                //tasm.currentNode = true;
            }
            asm.add( tasm );
        }
        
        asm[0].nodeType             = 'start';
        asm[asm.size()-1].nodeType  = 'end';
        sIds = new list<String>(); 
        for(ObjectStructureMap each : asm){
            sIds.add(each.solution.id);
        }
        list<quoteLineItem> qt = new list<quoteLineItem>();
        solIdVsQLitems = new map<String,list<quoteLineItem>>(); 
        qt = [Select id,product2.name,TotalPrice,product2.Description,Solution__c,quoteId,Quantity,Part_Number__c,Part_No__c,Long_Description__c,ListPrice,subtotal,Discount,Extended_List_Price__c  from quoteLineItem where Solution__c in:sIds and quoteId=:quoteId];
        for(quoteLineItem eachQt : qt){
                if(!solIdVsQLitems.containsKey(eachQt.Solution__c)){
                    solIdVsQLitems.put(eachQt.Solution__c,new list<quoteLineItem>());
                    solIdVsQLitems.get(eachQt.Solution__c).add(eachQt);
                }
                else{
                    solIdVsQLitems.get(eachQt.Solution__c).add(eachQt);
                }
        }
        for(ObjectStructureMap each : asm){
            if(!solIdVsQLitems.containsKey(each.solution.id))
            solIdVsQLitems.put(each.solution.id,new list<quotelineItem>());
              system.debug('----each----'+each);
        }
        solIdVsRender = new map<String,Boolean>();
        for(String each : solIdVsQLitems.keySet()){
            Integer i =  solIdVsQLitems.get(each).size();
            if(i>0)solIdVsRender.put(each,true);
            else solIdVsRender.put(each,false);
        } 
        return asm;
    }
    
    /**
    * Determin parent elements relationship to current element
    * @return flagList
    */
    public List<Boolean> setlevelFlag( List<String> nodeElements, String nodeType ){
        
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode   = '';
        String workNode     = '';
        Integer cn          = 0;
        
        for( Integer i = 0; i < nodeElements.size() - 1; i++ ){
            cn = Integer.valueOf( nodeElements[i] );
            cn++;
            searchNode  = workNode + String.valueOf( cn );
            workNode    = workNode + nodeElements[i] + '.';
            if ( masm.containsKey( searchNode ) ){
                flagList.add( true );
            }
            else {
                flagList.add( false );
            }
        }
        
        return flagList;
    }
    
    /**
    * Determin if the element is a closing element
    * @return flagList
    */
    public List<Boolean> setcloseFlag( List<String> cnl, List<String> nnl, String nodeType ){
        
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode   = '';
        String workNode     = '';
        Integer cn          = 0;
        
        for( Integer i = nnl.size(); i < cnl.size(); i++ ){
            flagList.add( true );
        }
        
        return flagList;
    }
    
    /**
    * Determin if Element is the bottom node  
    * @return Boolean
    */
    public Boolean isLastNode( List<String> nodeElements ){
        
        String searchNode   = '';
        Integer cn          = 0;
        
        for( Integer i = 0; i < nodeElements.size(); i++ ){
            if ( i == nodeElements.size()-1 ){
                cn = Integer.valueOf( nodeElements[i] );
                cn++;
                searchNode = searchNode + String.valueOf( cn );
            }
            else {
                searchNode = searchNode + nodeElements[i] + '.';
            }
        }
        if ( masm.containsKey( searchNode ) ){
            return false;
        }
        else{
            return true;
        }
    }
    
    /**
    * Find the tom most element in Heirarchy  
    * @return objId
    */
    public String GetTopElement( String objId ){
            Boolean top = false;
            while ( !top ) {
                //Change below
                Quote_Solutions__c a = new Quote_Solutions__c();
                system.debug('-----objId----'+objId);
                a = [ Select id,name,Parent_Solution__c from Quote_Solutions__c where id=: objId limit 1 ];
                
                if ( a.Parent_Solution__c != null ) {
                    objId = a.Parent_Solution__c;
                }
                else {
                    top = true;
                }
            }
        return objId ;
    }

    public void isPartnerUser(){
      Id userId = UserInfo.getUserId();
      User u = [select Id,IsPortalEnabled from User where Id =:userId];
      userType = u.IsPortalEnabled;
    }
              
    /**
    * Wrapper class 
    */
    public with sharing class ObjectStructureMap{

        public String nodeId;
        public Boolean[] levelFlag = new Boolean[]{};
        public Boolean[] closeFlag = new Boolean[]{};
        public String nodeType;
        public Boolean currentNode;
        public Integer nodeLevel {get;set;}
        public String parentNodeId  {get;set;}
        
        /**
        * @Change this to your sObject
        */
        public Quote_Solutions__c solution;
        
        public String getnodeId() { return nodeId; }
        public Boolean[] getlevelFlag() { return levelFlag; }
        public Boolean[] getcloseFlag() { return closeFlag; }
        public String getnodeType() { return nodeType; }
        public Boolean getcurrentNode() { return currentNode; }


        /**
        * @Change this to your sObject
        */
        public Quote_Solutions__c getaccount() { return solution; }
        
        public void setnodeId( String n ) { this.nodeId = n; }
        public void setlevelFlag( Boolean l ) { this.levelFlag.add(l); }
        public void setlcloseFlag( Boolean l ) { this.closeFlag.add(l); }
        public void setnodeType( String nt ) { this.nodeType = nt; }
        public void setcurrentNode( Boolean cn ) { this.currentNode = cn; }

        /**
        * @Change this to your sObject
        */
        public void setaccount( Quote_Solutions__c a ) { this.solution = a; }
        
        public list<String> sIds;
        public map<String,quoteLineItem> solIdVs;

        /**
        * @Change the parameters to your sObject
        */
        public ObjectStructureMap(String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode,Integer nodeLevel,string parentNodeId, Quote_Solutions__c a ){
            
            this.nodeId         = nodeId;
            this.levelFlag      = levelFlag; 
            this.closeFlag      = closeFlag;
            this.nodeType       = nodeType;
            this.currentNode    = currentNode;
            this.nodeLevel = nodeLevel;
            this.parentNodeId = parentNodeId;
            //Change this to your sObject  
            this.solution = a;
        }
    }
    public String getWordPrintViewXML() {
    // doesn't need to be on multiple lines, it's just for readability
    return '<!--[if gte mso 9]>' +
        '<xml>' +
        '<w:WordDocument>' +
        '<w:View>Print</w:View>' +
        '<w:Zoom>100</w:Zoom>' +
        '<w:DoNotOptimizeForBrowser/>' +
        '</w:WordDocument>' +
        '</xml>' +
        '<![endif]>';
    }    
    public String getSiteUrl() {
        // https://test.salesforce.com/servlet/servlet.ImageServer?id=015e00000007gZA&oid=00De0000005OcSQ
        // https://test.salesforce.com/servlet/servlet.ImageServer?id=015e00000007gZA&oid=00De0000005OcSQ&lastMod=1404920124000
        // https://c.cs15.visual.force.com/servlet/servlet.ImageServer?id=015e00000007kPiAAI&oid=00De0000005OcSQEA0
        String strDomain = System.URL.getSalesforceBaseURL().getHost();
        String finalUrl ='';
        String strDocName = 'Imagine_LOGO';  //015e00000007gZA sandbox pdata
        /*List<Document> lstDocument = [Select Id,Name,DeveloperName from Document where DeveloperName =:strDocName limit 1];
        String strDocId=lstDocument[0].Id;*/
        Imagine_LOGO__c myCS1 = Imagine_LOGO__c.getValues('Logo');
        String strDocId = myCS1.Imagine_LOGO__c;
        String strOrgId = UserInfo.getOrganizationId();
        if(!OpportunityConvert_WS.isPartnerUser())
        {
            finalUrl = 'https://'+strDomain+'/servlet/servlet.ImageServer?id='+strDocId+'&oid='+strOrgId;
        }
        else
        {
            finalUrl = 'https://'+strDomain+'/partners/servlet/servlet.ImageServer?id='+strDocId+'&oid='+strOrgId;
        }
        system.debug('URL RAAAAAJ'+ finalUrl);
        return finalUrl;
    }
}