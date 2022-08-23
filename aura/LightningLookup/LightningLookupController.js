({
    doInit: function(component, event, helper) {
        var selectedId = component.get("v.selectedId");
        if(selectedId) {
            var action = component.get("c.getContactById");
            action.setParams({
                "recordId": selectedId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var data = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(data){
                        component.set("v.selItem", data);
                        component.set("v.selectedId", data.Id);
                    }
                } else {
                    alert('Unable to find the selected record.');
                }
            });
            $A.enqueueAction(action);
        } else {
            // on first load, pull all records, limits enforced in controller
            helper.serverCall(component, event, helper);
        }
    },
    itemSelected: function(component, event, helper) {
        helper.itemSelected(component, event, helper);
    },
    serverCall:  function(component, event, helper) {
        helper.serverCall(component, event, helper);
    },
    clearSelection: function(component, event, helper) {
        helper.clearSelection(component, event, helper);
    },
    onTriggerOpen: function(component, event, helper){
        helper.handleTriggerOpen(component, event, helper);
    },
    onSearchStart: function(component, event, helper) {
        component.set('v.showOptions', true);
    }
})