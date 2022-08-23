({
	invoke : function(component, event, helper) {
        var recid = component.get("v.recId");
        if(!recId) return alert("Missing Record Id");
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            "recordId": recid
        });
        navEvent.fire();
	}
})