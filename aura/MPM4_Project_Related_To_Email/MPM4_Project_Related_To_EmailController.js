({ 
    updateResult: function(c, e, h){ 
        h.showSpinner(c);
        h.updatedData(c,e,true);
        h.hideSpinner(c);
    },
    
    gotoList : function (c, e, h) {
        h.showSpinner(c);
        h.updatedData(c,e,false);
        c.set("v.showAllProjects",true);
        h.hideSpinner(c);
        let people = c.get("v.people");
        let peopleEmails = h.filterEmails(c, people);
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ShowAllProjects",
            componentAttributes: {
                emails : peopleEmails
            }
        });
        evt.fire();
        /*var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": null,
                    "scope": "MPM4_BASE__Milestone1_Project__c"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);*/
    },
    
    navi:function(c, e, h){
        let sa = e.currentTarget; 
        
        let sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId":  sa.id ,
            "slideDevName": "detail"
        });
        sObjectEvent.fire(); 
    }
})