({
	openOpportunityModal: function(component, defaults) {
        defaults = defaults || {};
        var defaultValues = {};
        if(defaults.AccountId) {
            defaultValues.AccountId = defaults.AccountId;
            defaultValues.Created_From__c = 'Account:CustomLEX:'+defaults.AccountId;
        }
        if(defaults.ContactId) defaultValues.Created_From__c = 'Contact:CustomLEX:'+defaults.ContactId;
		setTimeout(function(){
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            setTimeout(function(){
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Opportunity",
                    "defaultFieldValues": defaultValues,
                    "recordTypeId": defaults.RecordTypeId
                });
                createRecordEvent.fire();
            }, 300);
        }, 100);
	},
    getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = decodeURIComponent(window.location.href);
        var regex = new RegExp("([?&]*)" + name + "(=([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[3]) return '';
        return decodeURIComponent(results[3].replace(/\+/g, " "));
    }
})