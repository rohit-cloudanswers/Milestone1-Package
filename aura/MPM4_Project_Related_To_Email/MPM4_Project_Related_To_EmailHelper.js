({ 
    filterEmails : function(c, people){ 
        let addrs = []; 
        
        if(c.get('v.includeFrom') === true){  
            if(people.from){
                addrs.push(people.from.email); 
            } 
        }  
        
        if(c.get('v.includeTo') === true){
            addrs = addrs.concat(this.getEmailsFromList(people.to));
        }
        
        if(c.get('v.includeCC') === true){ 
            addrs = addrs.concat(this.getEmailsFromList(people.cc));
        } 
 
        addrs = addrs.filter(function(n){ return n != undefined });
        return addrs;
    },
    
    getEmailsFromList : function(list){
        var ret = [];
        for (var i in list) {
            ret.push(list[i].email);
        } 
        return ret;
    },
    
    updatedData : function(c, e , isLimited){
        let people = c.get("v.people");
        let peopleEmails = this.filterEmails(c, people);
        
        let action = c.get("c.findMPM4Projects");
        action.setParam("emails", peopleEmails);
        action.setParam("isLimited", isLimited);
        
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){  
                var projectWrap = response.getReturnValue();
                c.set("v.projects", projectWrap.projects);
                c.set("v.total",projectWrap.count);
            } else {
                c.set("v.projects",[]);
                c.set("v.total","0");
            }
        });
        $A.enqueueAction(action);
        
        
        let getNames = c.get("c.getFieldsetFieldNames"); 
        getNames.setCallback(this, function(response){ 
            if(response.getState() === "SUCCESS"){  
                c.set('v.fieldNames', JSON.parse(response.getReturnValue())); 
            } 
        });
        $A.enqueueAction(getNames);
    },
    
    showSpinner: function(cmp){
        var spinner = cmp.find('spinner1');
        $A.util.removeClass(spinner, 'slds-hide');
    },
    
    hideSpinner: function(cmp){
        var spinner = cmp.find('spinner1');
        $A.util.addClass(spinner, 'slds-hide');
    }
})