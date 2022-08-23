({
    getControllerService: function(component) {
        var service = {
            getNonQuotableProducts: function (quoteId) {
                return setupAction("c.getNonQuotableProducts", parseToParams(getArgumentNames(this.getNonQuotableProducts), arguments));
            },
            deleteNonQuotableProducts: function (quoteId) {
                return setupAction("c.deleteNonQuotableProducts", parseToParams(getArgumentNames(this.deleteNonQuotableProducts), arguments));
            },
            getProductsWithLongLeadTime: function (quoteId) {
                return setupAction("c.getProductsWithLongLeadTime", parseToParams(getArgumentNames(this.getProductsWithLongLeadTime), arguments));
            },
            getProductsWithLimitedSupply: function (quoteId) {
                return setupAction("c.getProductsWithLimitedSupply", parseToParams(getArgumentNames(this.getProductsWithLimitedSupply), arguments));
            }
        };
        
        function parseToParams(argNames, args) {
            var params = {};
            for (var i = 0; i < args.length; i++) {
                params[argNames[i]] = args[i]
            }
            return params;
        }
        
        function setupAction(actionName, params) {
            return new Promise($A.getCallback(function(resolve, reject) {
                var action = component.get(actionName);
                if(params){
                    action.setParams(params);
                }
                action.setCallback(this, function(a) {
                    var err = a.getError();
                    var result = a.getReturnValue();
                    if (err && err.length > 0) reject(err);
                    else resolve(result);
                });
                $A.enqueueAction(action, false);
            }));
        }
        
        function getArgumentNames(func){
            // First match everything inside the function argument parens.
            var args = func.toString().match(/function\s.*?\(([^)]*)\)/)[1];
            // Split the arguments string into an array comma delimited.
            return args.split(',').map(function(arg) {
                // Ensure no inline comments are parsed and trim the whitespace.
                return arg.replace('/\/\*.*\*\//', '').trim();
            }).filter(function(arg) {
                // Ensure no undefined values are added.
                return arg;
            });
        }
        return service;
    },
	handleInit: function(component) {
        var helper = this;
		var recordId = component.get('v.recordId');
        var ctrlService = helper.getControllerService(component);
        helper.showSpinner(component);
        var promises = [
            ctrlService.getNonQuotableProducts(recordId), 
            ctrlService.getProductsWithLongLeadTime(recordId),
            ctrlService.getProductsWithLimitedSupply(recordId)
        ];
        Promise.all(promises).then(function(results){
            component.set('v.lineItems', results[0]);
            var isOpen = results[0].length != 0;
            var showLeadTimeModal = results[1].length != 0;
            var showLimitedSupplyModal = results[2].length != 0;
            component.set('v.isOpen', isOpen);
            component.set('v.longLeadItems', results[1]);
            component.set('v.limitedSupplyItems', results[2]);
            component.set('v.isLeadTimeModal', !isOpen && showLeadTimeModal);
            component.set('v.isLimitedSupplyModal', !isOpen && !showLeadTimeModal && showLimitedSupplyModal);
            helper.hideSpinner(component);
        }, function(err){
            console.log(err);
            helper.hideSpinner(component);
        });
	},
    processCloseModal: function(component) {
        var helper = this;
        var isLeadTimeModal = component.get('v.isLeadTimeModal');
        var isLimitedSupplyModal = component.get('v.isLimitedSupplyModal');
        var isNonQuotableModal = component.get('v.isOpen');
        if (isNonQuotableModal == true) {
            component.set('v.isOpen', false);
            var longLeadItems = component.get('v.longLeadItems');
            if (longLeadItems.length > 0) {
                component.set('v.isLeadTimeModal', true);
                helper.hideSpinner(component);
                component.set('v.processing', false);
            } else {
                helper.handleLimitedSupplyModal(component);
            }
        } else if (isLeadTimeModal == true) {
            component.set('v.isLeadTimeModal', false);
            helper.handleLimitedSupplyModal(component);
        } else if (isLimitedSupplyModal == true) {
            component.set('v.isLimitedSupplyModal', false);
        }
    },
    handleLimitedSupplyModal: function(component) {
        var helper = this;
        var limitedSupplyItems = component.get('v.limitedSupplyItems');
        if (limitedSupplyItems.length > 0) {
            component.set('v.isLimitedSupplyModal', true);
            helper.hideSpinner(component);
            component.set('v.processing', false);
        }
    },
    hideSpinner: function(component) {
        var spinner = component.find('nqp_spinner');
        if (spinner && spinner.length > 0) {
            for (var i=0; i<spinner.length; i++) {
                $A.util.addClass(spinner[i], 'slds-hide');
            }
        } else {
            $A.util.addClass(spinner, 'slds-hide');
        }
    },
    showSpinner: function(component) {
        var spinner = component.find('nqp_spinner');
        $A.util.removeClass(spinner, 'slds-hide');
    }
})