({
	doInit: function(component, event, helper) {
		helper.handleInit(component);
	},
    onRender: function(component, event, helper) {
        helper.hideSpinner(component);
    },
    closeModal: function(component, event, helper) {
        helper.processCloseModal(component);
    },
    removeNonQuotable: function(component, event, helper) {
        var recordId = component.get('v.recordId');
        var ctrlService = helper.getControllerService(component);
        helper.showSpinner(component);
        component.set('v.processing', true);
        ctrlService.deleteNonQuotableProducts(recordId).then(function(res){
            component.set('v.processing', false);
            if (res.success == true) {
                var isVfPage = component.get('v.isVfPage');
                if (isVfPage == false) {
                    $A.get('e.force:refreshView').fire();
                }
                helper.processCloseModal(component);
            } else {
                component.set('v.errorText', res.message);
            }
            helper.hideSpinner(component);
        }, function(err){
            component.set('v.processing', false);
            helper.hideSpinner(component);
        });
    },
    resetError: function(component, event, helper) {
        component.set('v.errorText', '');
    }
})