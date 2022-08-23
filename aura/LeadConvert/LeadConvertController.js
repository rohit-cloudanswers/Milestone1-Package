({
	doInit : function(component, event, helper) {
		var action = component.get("c.updateLeadBeforeConvert");
		action.setParams({ leadId : component.get("v.recordId") });
		//Update lead Allow_Conversion__c = true
		action.setCallback(this, function(response) {
			helper.toggle(component);
			var state = response.getState();
			if (state === "SUCCESS") {
				//Open standard lead convert screen
				var aClick = document.querySelector('[title="Convert"]');
				var dataClass = aClick.getAttribute("data-aura-class");
				if(dataClass && (dataClass == 'forceActionLink') && (aClick.tagName == 'A')){
					aClick.click();
				}

				/*search for Lead convert modal and and hide it after it renders*/
				var leadConvertModal;
				var waitForLeadConvertModal = setInterval(function() {
					leadConvertModal = document.querySelector('[data-aura-class="uiModal--leadConvert uiModal"]');;
					if(leadConvertModal){
						leadConvertModal.style.display = "none" ;
						clearInterval(waitForLeadConvertModal);
					}
				},100);

				/*search for "Don't create an opportunity upon conversion" checkbox and wait until it renders
				 and then fire click event */
				var opptyCheckBox = setInterval(function() {
				   if (document.getElementById("opptyCheckBox")) {
				   		var oppty = document.getElementById("opptyCheckBox");
				   		oppty.click();
				   		//close quick action modal
						$A.get("e.force:closeQuickAction").fire();
				      	clearInterval(opptyCheckBox);
				      	//show lead convertion modal
				      	leadConvertModal.style.display = "block" ;
				   }
				}, 5000);

			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + 
							errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
				var errorMessagesDiv = cmp.find("errorMessages");
                errorMessagesDiv.set("v.body", 'Error occurs!');
			}
		});
		$A.enqueueAction(action);
	}
})