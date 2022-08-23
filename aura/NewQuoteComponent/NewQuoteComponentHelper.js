({
	openQuoteModal: function(component, defaultValues) {
        defaultValues = defaultValues || {};
		setTimeout(function(){
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            setTimeout(function(){
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Quote",
                    "defaultFieldValues": defaultValues
                });
                createRecordEvent.fire();
            }, 300);
        }, 100);
	}
})