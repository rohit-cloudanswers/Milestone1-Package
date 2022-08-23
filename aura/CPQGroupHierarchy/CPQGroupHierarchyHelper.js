({
	getGridData: function(component, recordId) {
		return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.getGroupHierarchy');
            var params = {
                quoteId: recordId
            };
            action.setParams(params);
            action.setCallback(this, function(a) {
                var err = a.getError();
                var result = a.getReturnValue();
                if (err && err.length > 0) reject(err);
                else resolve(result);
            });
            $A.enqueueAction(action, false);
        }));
	},
    getGridColumns: function(component, actions) {
        var isLocked = component.get('v.isLocked');
        var quantityActions = [];
        var discountActions = [];
        var marginActions = [];
        if (isLocked == false) {
            quantityActions.push({
                name: 'mass_edit_quantity',
                label: 'Mass Edit'
            });
            discountActions.push({
                name: 'mass_edit_discount',
                label: 'Mass Edit'
            });
            marginActions.push({
                name: 'mass_edit_margin',
                label: 'Mass Edit'
            });
        }
        var columns = [
            {
                type: 'url',
                fieldName: 'groupUri',
                label: 'Quote Line Group',
                typeAttributes: {
                    label: { fieldName: 'groupName' },
                    currencyCode: 'USD'
                },
                initialWidth: 250
            },
            {
                type: 'number',
                fieldName: 'quantity',
                label: 'Qty',
                typeAttributes: {
                    minimumFractionDigits: 2
                },
                initialWidth: 75,
                actions: quantityActions
            },
            {
                type: 'currency',
                fieldName: 'totalUnitPrice',
                label: 'List Unit Price',
                typeAttributes: {
                    currencyCode: 'USD'
                }
            },
            {
                type: 'currency',
                fieldName: 'totalListPrice',
                label: 'Total List Price',
                typeAttributes: {
                    currencyCode: 'USD'
                }
            },
            {
                type: 'percent',
                fieldName: 'totalDiscountPercent',
                label: 'Total Discount (%)',
                typeAttributes: {
                    minimumFractionDigits: 2
                },
                actions: discountActions
            },
            {
                type: 'percent',
                fieldName: 'totalMargin',
                label: 'Total Margin (%)',
                typeAttributes: {
                    minimumFractionDigits: 2
                },
                actions: marginActions
            },
            {
                type: 'currency',
                fieldName: 'totalPrice',
                label: 'Net Unit Price',
                typeAttributes: {
                    currencyCode: 'USD'
                }
            },
            {
                type: 'currency',
                fieldName: 'totalNet',
                label: 'Net Total',
                typeAttributes: {
                    currencyCode: 'USD'
                }
            },
            {
                type: 'boolean',
                fieldName: 'optional',
                label: 'Optional'
            }
        ];
        if (!isLocked) {
            columns.push({
                type: 'action',
                typeAttributes: {
                    rowActions: actions
                }
            });
        }
        return columns;
    },
    isValidMove: function(component, moveToId, selectedGroupIds, selectedLineIds) {
		return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.validateMove');
            var params = {
                destinationGroupId: moveToId,
                groupIds: selectedGroupIds,
                lineIds: selectedLineIds
            };
            action.setParams(params);
            action.setCallback(this, function(a) {
                var err = a.getError();
                var result = a.getReturnValue();
                if (err && err.length > 0) reject(err);
                else resolve(result);
            });
            $A.enqueueAction(action, false);
        }));
	},
    doMove: function(component, moveToId, selectedGroupIds, selectedLineIds) {
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.handleMove');
            var params = {
                destinationGroupId: moveToId,
                groupIds: selectedGroupIds,
                lineIds: selectedLineIds
            };
            action.setParams(params);
            action.setCallback(this, function(a) {
                var err = a.getError();
                var result = a.getReturnValue();
                if (err && err.length > 0) reject(err);
                else resolve(result);
            });
            $A.enqueueAction(action, false);
        }));
    },
    handleValidateResult: function(component, validateResult, moveToId, selectedGroupIds, selectedLineIds) {
        var helper = this;
        if (validateResult.status) {
            helper.doMove(component, moveToId, selectedGroupIds, selectedLineIds).then(function(moveResult){
                helper.handleMoveResult(component, moveResult);
            }, function(err){
                helper.hideSpinner(component);
                alert(err.message || err);
            });
        } else {
            helper.hideSpinner(component);
            swal({
                title: 'Warning',
                text: validateResult.message + ' Do you still want to proceed?',
                type: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes'
            }).then(function(isConfirm){
                if(isConfirm == true) {
                    helper.doMove(component, moveToId, selectedGroupIds, selectedLineIds).then(function(moveResult){
                        helper.handleMoveResult(component, moveResult);
                    }, function(err){
                        helper.hideSpinner(component);
                        alert(err.message || err);
                    });
                }
            }, function(cancel){
                console.log(cancel);
                component.find('moveto_group').set('v.value', '');
            });
        }
    },
    handleMoveResult: function(component, moveResult) {
        var helper = this;
        helper.hideSpinner(component);
        if (moveResult.status) {
            component.find('moveto_group').set('v.value', '');
            component.set('v.polling', true);
            helper.pollCalculationStatus(component);
            if(component.find('lineGroupHierarchy')) {
                // reset selection
                component.find('lineGroupHierarchy').set('v.selectedRows', []);
            }
            helper.showSwalMessage('Success', 'Selected items moved successfully.', 'success');
        } else {
            component.find('moveto_group').set('v.value', '');
            helper.showSwalMessage('Error', moveResult.message, 'error');
        }
    },
    doCopy: function(component, copyToId, selectedGroupIds, selectedLineIds) {
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.handleCopy');
            var params = {
                destinationGroupId: copyToId,
                groupIds: selectedGroupIds,
                lineIds: selectedLineIds
            };
            action.setParams(params);
            action.setCallback(this, function(a) {
                var err = a.getError();
                var result = a.getReturnValue();
                if (err && err.length > 0) reject(err);
                else resolve(result);
            });
            $A.enqueueAction(action, false);
        }));
    },
    handleValidateCopyResult: function(component, validateResult, copyToId, selectedGroupIds, selectedLineIds) {
        var helper = this;
        if (validateResult.status) {
            helper.doCopy(component, copyToId, selectedGroupIds, selectedLineIds).then(function(copyResult){
                helper.handleCopyResult(component, copyResult);
            }, function(err){
                helper.hideSpinner(component);
                alert(err.message || err);
            });
        } else {
            helper.hideSpinner(component);
            swal({
                title: 'Warning',
                text: validateResult.message + ' Do you still want to proceed?',
                type: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes'
            }).then(function(isConfirm){
                if(isConfirm == true) {
                    helper.doCopy(component, copyToId, selectedGroupIds, selectedLineIds).then(function(copyResult){
                        helper.handleCopyResult(component, copyResult);
                    }, function(err){
                        helper.hideSpinner(component);
                        alert(err.message || err);
                    });
                }
            }, function(cancel){
                console.log(cancel);
                component.find('copyto_group').set('v.value', '');
            });
        }
    },
    handleCopyResult: function(component, copyResult) {
        var helper = this;
        helper.hideSpinner(component);
        if (copyResult.status) {
            component.find('copyto_group').set('v.value', '');
            component.set('v.polling', true);
            helper.pollCalculationStatus(component);
            if(component.find('lineGroupHierarchy')) {
                // reset selection
                component.find('lineGroupHierarchy').set('v.selectedRows', []);
            }
            helper.showSwalMessage('Success', 'Selected items copied successfully.', 'success');
        } else {
            component.find('copyto_group').set('v.value', '');
            helper.showSwalMessage('Error', copyResult.message, 'error');
        }
    },
    getGroupActions: function(component, row, doneCallback) {
        var actions = [];
        if (row.groupId && row.groupId.indexOf('a4Z') == 0) {
            if (row.optional == true) {
                // add Not Optional action
                actions.push({
                    name: 'make_non_optional',
                    label: 'Not Optional'
                });
            } else {
                actions.push({
                    name: 'make_optional',
                    label: 'Optional'
                });
            }
        }
        setTimeout($A.getCallback(function(){
            doneCallback(actions);
        }), 200);
    },
    toggleOptional: function(component, row, state) {
        var recordId = component.get('v.recordId');
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.changeOptional');
            var params = {
                quoteId: recordId,
                groupId: row.groupId,
                state: state
            };
            action.setParams(params);
            action.setCallback(this, function(a) {
                var err = a.getError();
                var result = a.getReturnValue();
                if (err && err.length > 0) reject(err);
                else resolve(result);
            });
            $A.enqueueAction(action, false);
        }));
    },
    handleDeleteAll: function(component) {
        var recordId = component.get('v.recordId');
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.deleteAll');
            var params = {
                quoteId: recordId
            };
            action.setParams(params);
            action.setCallback(this, function(a) {
                var err = a.getError();
                var result = a.getReturnValue();
                if (err && err.length > 0) reject(err);
                else resolve(result);
            });
            $A.enqueueAction(action, false);
        }));
    },
    handleMassEdit: function(component, selectedLineIds, massAction, massValue) {
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.processMassEdit');
            var params = {
                lineIds: selectedLineIds,
                massEditAction: massAction,
                value: massValue
            };
            action.setParams(params);
            action.setCallback(this, function(a) {
                var err = a.getError();
                var result = a.getReturnValue();
                if (err && err.length > 0) reject(err);
                else resolve(result);
            });
            $A.enqueueAction(action, false);
        }));
    },
    pollCalculationStatus: function(component) {
        var helper = this;
        var refreshObj = setInterval(function(){
            helper.checkCalculationStatus(component).then(function(result){
                if(result == false) {
                    clearInterval(refreshObj);
                }
                component.set('v.polling', result);
                component.set('v.calculating', result);
            }).catch(function(err){
            	component.set('v.calculating', false);
            });
        }, 4000);
    },
    checkCalculationStatus: function(component) {
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.isRecalculating');
            action.setCallback(this, function(a) {
                var err = a.getError();
                var result = a.getReturnValue();
                if (err && err.length > 0) reject(err);
                else resolve(result);
            });
            $A.enqueueAction(action, false);
        }));
    },
    showSpinner: function(component, spinnerId){
        var spinner = component.find(spinnerId || 'spinner');
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, spinnerId){
        var spinner = component.find(spinnerId || 'spinner');
        $A.util.addClass(spinner, "slds-hide");
    },
    showToast: function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    resetMassEdit: function(component) {
        component.set('v.isOpen', false);
        component.set('v.currentAction', null);
        component.set('v.massQuantity', null);
        component.set('v.massDiscount', null);
        component.set('v.massEditLineIds', []);
        component.set('v.massProcessing', false);
        component.set('v.targetMargin', null);
    },
    showSwalMessage: function(txtTitle, txtBody, modalType) {
        swal({
            title: txtTitle,
            text: txtBody,
            type: modalType,
            showCancelButton: false,
            confirmButtonText: 'OK'
        }).then(function(res){}, function(err){});
    }
})