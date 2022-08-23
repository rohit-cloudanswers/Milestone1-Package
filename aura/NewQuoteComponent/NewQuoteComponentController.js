({
	doInit: function(component, event, helper) {
        var recordId = component.get('v.recordId');
        var action = component.get('c.getDefaultValues');
        action.setParams({
            'oppId': recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                helper.openQuoteModal(component, response.getReturnValue());
            } else if(state === 'ERROR'){
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	}
})