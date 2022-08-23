({
    afterScriptsLoaded: function(component, event, helper){
        swal.setDefaults({
            showCancelButton: false,
            allowOutsideClick : false,
            allowEscapeKey : false,
            allowEnterKey : false
        });
    },
    onInit: function(component, event, helper) {
        var actions = helper.getGroupActions.bind(this, component);
        var recordId = component.get('v.recordId');
        helper.showSpinner(component);
        helper.getGridData(component, recordId).then(function(result){
            var isoCode = result.currency_iso_code;
            component.set('v.isLocked', result.isLocked);
            var columns = helper.getGridColumns(component, actions);
            for (var i=0; i<columns.length; i++) {
                if (columns[i].type == 'currency') {
                    columns[i].typeAttributes.currencyCode = isoCode;
                }
            }
            component.set('v.gridColumns', columns);
            component.set('v.gridData', result.data);
            component.set('v.lineGroups', result.groups);
            component.set('v.uiThemeDisplayed', result.uiThemeDisplayed);
            helper.hideSpinner(component);
            helper.pollCalculationStatus(component);
        }).catch(function(err){
            var columns = helper.getGridColumns(component, actions);
            component.set('v.gridColumns', columns);
            helper.hideSpinner(component);
            console.log(err);
        });
    },
    expandAll: function (component, event, helper) {
        var treeGrid = component.find('lineGroupHierarchy');
        treeGrid.expandAll();
        component.set('v.expandedAll', true);
    },
    collapseAll: function (component, event, helper) {
        var treeGrid = component.find('lineGroupHierarchy');
        treeGrid.collapseAll();
        component.set('v.expandedAll', false);
    },
    moveItems: function (component, event, helper) {
        var treeGrid = component.find('lineGroupHierarchy');
        var selectedRows = treeGrid.getSelectedRows();
        if(selectedRows && selectedRows.length > 0) {
            var moveToId = event.getSource().get('v.value');
            if (moveToId) {
                var allLines = true;
                var allGroups = true;
                var lineIds = [];
                for(var i=0; i<selectedRows.length; i++) {
                    var lineItem = selectedRows[i];
                    allLines = allLines && lineItem.groupUri.indexOf('SBQQ__QuoteLine__c') != -1;
                    allGroups = allGroups && lineItem.groupUri.indexOf('SBQQ__QuoteLineGroup__c') != -1;
                    lineIds.push(selectedRows[i].groupId);
                }
                
                if(allLines) {
                    helper.showSpinner(component);
                    helper.isValidMove(component, moveToId, null, lineIds).then(
                        function(result) {
                            helper.handleValidateResult(component, result, moveToId, null, lineIds);
                        }, function(err) {
                            helper.hideSpinner(component);
                            alert(err.message || err);
                        }
                    );
                } else if (allGroups && selectedRows.length == 1) {
                    helper.showSpinner(component);
                    helper.isValidMove(component, moveToId, selectedRows[0].groupId, null).then(
                        function(result) {
                            helper.handleValidateResult(component, result, moveToId, selectedRows[0].groupId, null);
                        }, function(err) {
                            helper.hideSpinner(component);
                            alert(err.message || err);
                        }
                    );
                } else {
                    alert('Please either select a Quote Line Group or Quote Lines, not a combination of both.');
                }
            }
        } else {
            alert('Please select at least a Quote Line or Quote Line Group to move.');
        }
    },
    copyItems: function(component, event, helper) {
        var treeGrid = component.find('lineGroupHierarchy');
        var selectedRows = treeGrid.getSelectedRows();
        if(selectedRows && selectedRows.length > 0) {
            var copyToId = event.getSource().get('v.value');
            if (copyToId) {
                var allLines = true;
                var allGroups = true;
                var lineIds = [];
                for(var i=0; i<selectedRows.length; i++) {
                    var lineItem = selectedRows[i];
                    allLines = allLines && lineItem.groupUri.indexOf('SBQQ__QuoteLine__c') != -1;
                    allGroups = allGroups && lineItem.groupUri.indexOf('SBQQ__QuoteLineGroup__c') != -1;
                    lineIds.push(selectedRows[i].groupId);
                }
                
                if(allLines) {
                    helper.showSpinner(component);
                    helper.isValidMove(component, copyToId, null, lineIds).then(
                        function(result) {
                            helper.handleValidateCopyResult(component, result, copyToId, null, lineIds);
                        }, function(err) {
                            helper.hideSpinner(component);
                            alert(err.message || err);
                        }
                    );
                } else if (allGroups && selectedRows.length == 1) {
                    helper.showSpinner(component);
                    helper.isValidMove(component, copyToId, selectedRows[0].groupId, null).then(
                        function(result) {
                            helper.handleValidateCopyResult(component, result, copyToId, selectedRows[0].groupId, null);
                        }, function(err) {
                            helper.hideSpinner(component);
                            alert(err.message || err);
                        }
                    );
                } else {
                    alert('Please either select a Quote Line Group or Quote Lines, not a combination of both.');
                }
            }
        } else {
            alert('Please select at least a Quote Line or Quote Line Group to move.');
        }
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch(action.name) {
            case 'make_optional':
                helper.showSpinner(component);
                helper.toggleOptional(component, row, true).then(function(res){
                    helper.hideSpinner(component);
                    component.set('v.polling', true);
            		helper.pollCalculationStatus(component);
                }, function(err){
                    console.log(err);
                    helper.hideSpinner(component);
                });
                break;
            case 'make_non_optional':
                helper.showSpinner(component);
                helper.toggleOptional(component, row, false).then(function(res){
                    helper.hideSpinner(component);
                    component.set('v.polling', true);
            		helper.pollCalculationStatus(component);
                }, function(err){
                    console.log(err);
                    helper.hideSpinner(component);
                })
                break;
        }
    },
    onClickDeleteAll: function(component, event, helper) {
        swal({
            title: '',
            text: 'Are you sure you want to delete all line groups and items on this Quote?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes'
        }).then(function(isConfirm){
            if(isConfirm == true) {
                helper.showSpinner(component);
                helper.handleDeleteAll(component).then(function(res) {
                    helper.hideSpinner(component);
                    var message = null;
                    if (res.status == true) {
                        message = 'All Quote Line Groups and Items deleted.';
                        helper.showSwalMessage('Success', message, 'success');
                        $A.get('e.force:refreshView').fire();
                    } else {
                        helper.showSwalMessage('Error', res.message, 'error');
                    }
                }, function(err) {
                    var message = err.length ? err[0].message : (err.message || err);
                    helper.showSwalMessage('Error', message, 'error');
                    helper.hideSpinner(component);
                });
            }
        }, function(cancel){
            console.log(cancel);
        });
    },
    handleHeaderAction: function(component, event, helper) {
        var actionName = event.getParam('action').name;
        var treeGrid = component.find('lineGroupHierarchy');
        var gridData = component.get('v.gridData');
        var selectedRows = treeGrid.getSelectedRows();
        if(selectedRows && selectedRows.length > 0) {
            var lineIds = [];
            var groupIds = [];
            for(var i=0; i < selectedRows.length; i++) {
                var row = selectedRows[i];
                if (row.groupId.indexOf('a4Z') == -1) {
                    // is a quote line item
                    lineIds.push(row.groupId);
                } else {
                    groupIds.push(row.groupId);
                }
            }
            
            for (var i=0; i < gridData.length; i++) {
                var row = gridData[i];
                for (var j=0; j < row['_children'].length; j++)  {
                    var subRow = row['_children'][j];
                    if (subRow.groupId.indexOf('a4Z') == 0) {
                        for (var k=0; k < subRow['_children'].length; k++)  {
                            var lineRow = subRow['_children'][k];
                            if ((groupIds.indexOf(row.groupId) != -1 || groupIds.indexOf(subRow.groupId) != -1)
                                && lineIds.indexOf(lineRow.groupId) == -1){
                                lineIds.push(lineRow.groupId);
                            }
                        }
                    } else if (groupIds.indexOf(row.groupId) != -1 && lineIds.indexOf(subRow.groupId) == -1) {
                        lineIds.push(subRow.groupId);
                    }
                }
            }
            
            if (lineIds.length > 0) {
                if (actionName == 'mass_edit_margin' && groupIds.length > 1) {
                    alert('Please select only one Quote Line Group.');
                } else {
                    component.set('v.massEditLineIds', lineIds);
                    component.set('v.currentAction', actionName);
                    component.set('v.isOpen', true);
                    setTimeout(function(){
                        helper.hideSpinner(component, 'mass_edit_spinner');
                    }, 500);
                }
            } else {
                alert('Selected Quote Line Groups have no Quote Lines.');
            }
        } else {
            alert('Please select at least one Quote Line to proceed.');
        }
    },
    onClickSave: function(component, event, helper) {
        var selectedLineIds = component.get('v.massEditLineIds');
        var massEditAction = component.get('v.currentAction');
        var massQuantity = component.get('v.massQuantity');
        var massDiscount = component.get('v.massDiscount');
        var targetMargin = component.get('v.targetMargin');
        var massValue = null;
        if (massEditAction == 'mass_edit_quantity') {
            massValue = massQuantity;
        } else if (massEditAction == 'mass_edit_discount') {
            massValue = massDiscount;
        } else if (massEditAction == 'mass_edit_margin') {
            massValue = targetMargin;
        }
        helper.showSpinner(component, 'mass_edit_spinner');
        helper.handleMassEdit(component, selectedLineIds, massEditAction, massValue).then(
            function(res) {
                helper.hideSpinner(component, 'mass_edit_spinner');
                if (res.status == true) {
                    helper.resetMassEdit(component);
                    if(component.find('lineGroupHierarchy')) {
                        // reset selection
                        component.find('lineGroupHierarchy').set('v.selectedRows', []);
                    }
                    component.set('v.polling', true);
            		helper.pollCalculationStatus(component);
                } else {
                    helper.showSwalMessage('Error', res.message, 'error');
                }
            }, function(err) {
                helper.hideSpinner(component, 'mass_edit_spinner');
                helper.resetMassEdit(component);
                var message = err.length ? err[0].message : (err.message || err);
                helper.showSwalMessage('Error', message, 'error');
            }
        ).catch(function(err){
            helper.hideSpinner(component, 'mass_edit_spinner');
            alert('Something went wrong during Mass Edit.');
        });
    },
    cancelMassEdit: function(component, event, helper) {
        helper.resetMassEdit(component);
    },
    onRecalculate: function(component, event, helper) {
        var oldValue = event.getParam('oldValue');
        var newValue = event.getParam('value');
        if (newValue == false && newValue != oldValue) {
            $A.get('e.force:refreshView').fire();
        }
    }
})