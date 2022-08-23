({
    itemSelected : function(component, event, helper) {
        var target = event.target;
        var SelIndex = helper.getIndexFrmParent(target,helper,"data-selectedIndex");
        var selectedReport = null;
        if(SelIndex){
            var serverResult = component.get("v.server_result");
            var selItem = serverResult[SelIndex];
            if(selItem.Id){
                component.set("v.selItem",selItem);
                component.set("v.selectedId",selItem.Id);
                component.set("v.last_ServerResult",serverResult);
                selectedReport = selItem;
                component.set("v.errors", []);
            } else {
                selectedReport = null;
            }
            component.set("v.server_result",null);
        } else {
            selectedReport = null;
        }
    },
    serverCall : function(component, event, helper) {
        var target = event.target;
        var searchText = target ? (!target.value ? 'all_contacts' : target.value) : 'all_contacts';
        var last_SearchText = component.get("v.last_SearchText");
        // escape button pressed 
		if (event.keyCode == 27 || !searchText.trim()) { 
			helper.clearSelection(component, event, helper);
		} else if(searchText.trim() != last_SearchText || searchText == 'all_contacts'){ 
			//Save server call, if last text not changed
          	//Search only when space character entered
          	var parentField = component.get("v.parentFieldId");
			var parentId = component.get("v.parentRecordId");
			var action = component.get('c.getContacts');
            
			if (searchText == 'all_contacts') searchText = '';
            action.setParams({
            	parentFieldApi: parentField,
				parentFieldValue: parentId,   
				searchTerm: searchText
			});
            action.setCallback(this, function(a){
                this.handleResponse(a,component,helper);
            });
            component.set("v.last_SearchText", searchText.trim());
            $A.enqueueAction(action);
        } else if(searchText && last_SearchText && searchText.trim() == last_SearchText.trim()){
            component.set("v.server_result", component.get("v.last_ServerResult"));
        }
    },
    handleResponse : function (res,component,helper){
        if (res.getState() === 'SUCCESS') {
            var retObj = res.getReturnValue();
            if(retObj.length <= 0){
                var noResult = JSON.parse('[]');
                component.set("v.server_result", noResult);
                component.set("v.last_ServerResult", noResult);
            } else {
                component.set("v.server_result", retObj);
                component.set("v.last_ServerResult", retObj);
            }
        } else if (res.getState() === 'ERROR'){
            var errors = res.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    alert(errors[0].message);
                }
            }
        }
    },
    getIndexFrmParent : function(target,helper,attributeToFind){
        //User can click on any child element, so traverse till intended parent found
        var SelIndex = target.getAttribute(attributeToFind);
		while(!SelIndex){
          	target = target.parentNode ;
          	SelIndex = helper.getIndexFrmParent(target,helper,attributeToFind);           
		}
        return SelIndex;
	},
    clearSelection: function(component, event, helper){
        component.set("v.selItem", null);
        component.set("v.server_result", null);
        component.set("v.last_ServerResult", null);
        component.set("v.last_SearchText", null);
        component.set("v.errors", [{message: "Complete this field."}]);
	},
    handleTriggerOpen: function(component, event, helper){
        var selectedItem = component.get("v.selItem");
        component.set("v.selItem", null);
        var lastResults = component.get("v.last_ServerResult");
        if(!lastResults || lastResults.length == 0) lastResults = [selectedItem];
        component.set("v.server_result", lastResults);
        var last_SearchText = component.get("v.last_SearchText");
        setTimeout($A.getCallback(function(){
            var input = document.querySelector('#combobox-unique-id');
            if(input) {
                if(last_SearchText) input.value = last_SearchText;
                input.focus();
            }
        }), 100);
    }
})