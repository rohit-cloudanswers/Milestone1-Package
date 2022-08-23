({
	toggle : function(component) {
		var spinner = component.find("processing");
        $A.util.toggleClass(spinner, "slds-hide");
	}
})