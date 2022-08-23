({
	getControllerService: function(component) {
        var service = {
            getReportData: function (recordId, isoCode) {
                return setupAction("c.getReportData", parseToParams(getArgumentNames(this.getReportData), arguments));
            },
            getCurrencies: function () {
                return setupAction("c.getCurrencies", parseToParams(getArgumentNames(this.getCurrencies), arguments));
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
    handleReportLoading: function(component){
        var helper = this;
        var service = helper.getControllerService(component);
        var recordId = component.get('v.recordId');
        var selectedCurrency = component.get('v.selectedCurrency');
        helper.toggleSpinner(component);
        service.getReportData(recordId, selectedCurrency).then(function(result){
            var report = JSON.parse(result);
            component.set('v.report', report);
            var groupings = report.groupingsAcross.groupings;
            var rows = [];
            var level = 0;
            helper.setupColumnGroupings(rows, groupings, level);
            // prepend rows with groupingsAcross from report metadata
            if(report.reportMetadata.groupingsAcross){
                for(var i=0;i<rows.length; i++){
                    if(report.reportMetadata.groupingsAcross[i]) {
                        var row = rows[i];
                        var key = report.reportMetadata.groupingsAcross[i].name;
                        var grouping = report.reportExtendedMetadata.groupingColumnInfo[key];
                        row = [{
                            key: grouping.name,
                            label: grouping.label,
                            value: grouping.name,
                            children: 1
                        }].concat(row);
                        rows[i] = row;
                    }
                }
            }
            // prepend rows with groupingsAcross from report metadata
            if(report.reportMetadata.groupingsDown){
                var totalGroupingsDown = report.reportMetadata.groupingsDown.length;
                for(var i=0;i<totalGroupingsDown; i++){
                    var row = rows[i];
                    var key = report.reportMetadata.groupingsDown[i].name;
                    var grouping = report.reportExtendedMetadata.groupingColumnInfo[key];
                    row = [{
                        key: grouping.name,
                        label: grouping.label,
                        value: grouping.name,
                        children: 1
                    }].concat(row);
                    rows[i] = row;
                }
                if(totalGroupingsDown < rows.length){
                    rows[totalGroupingsDown - 1][0].children = 0;
                }
            }
            component.set('v.groupingsAcross', rows);
            // setup grouping data
            helper.setupColumnData(component, rows);
            helper.toggleSpinner(component);
        }).catch(function(error){
            helper.toggleSpinner(component);
            helper.showToast(component, 'error', 'Error', JSON.stringify(error));
            console.log(error);
        });
    },
    setupColumnGroupings: function(rows, groupings, level){
        var row = rows[level] || [];
        for(var i=0; i<groupings.length; i++){
            var column = {};
            column.key = groupings[i].key;
            column.value = groupings[i].value;
            column.label = groupings[i].label;
            column.children = groupings[i].groupings ? groupings[i].groupings.length : 1;
            row.push(column);
            if(groupings[i].groupings) {
                var nextLevel = level + 1;
                this.setupColumnGroupings(rows, groupings[i].groupings, nextLevel);
            }
        }
        if(level == 0) row.push({key: '0!T', label: 'Grand Total', value: 'Grand Total', children: 0})
        rows[level] = row;
        return;
    },
    setupColumnData: function(component, groupRows){
        var report = component.get('v.report');
        var helper = this;
        var lastGroupRow = groupRows[groupRows.length - 1];
        var columnData = new Array();
        
        for(var k=0; k<report.groupingsDown.groupings.length; k++) {
            var row = [];
            row.push([report.groupingsDown.groupings[k]]);
            
            var data = [];
            var aggregates = report.reportMetadata.aggregates;
            for(var j=0; j<aggregates.length; j++){
                var aggregate = aggregates[j];
                var columnInfo = report.reportExtendedMetadata.aggregateColumnInfo[aggregate];
                data.push({
                    label: columnInfo.label,
                    value: columnInfo.name
                });
            }
            row.push(data);
            
            for(var i=0; i<lastGroupRow.length; i++){
                var key = lastGroupRow[i].key;
                if(report.factMap[k+'!'+key]){
                    data = report.factMap[k+'!'+key].aggregates;
                    helper.addCurrencySymbol(data);
                    row.push(data);
                }
            }

            var aggregates = report.factMap[k+'!T'].aggregates;
            helper.addCurrencySymbol(aggregates);
            row.push(aggregates);
            
            columnData.push(row);
        }
        
        // add grant total row
        var grandTotalRow = [];
        grandTotalRow.push([{key:'T', label: 'Grand Total', value: 'Grand Total', groupings: null}]);
        // add aggregates info to grant total row
        var data = [];
        var aggregates = report.reportMetadata.aggregates;
        for(var j=0; j<aggregates.length; j++){
            var aggregate = aggregates[j];
            var columnInfo = report.reportExtendedMetadata.aggregateColumnInfo[aggregate];
            data.push({
                label: columnInfo.label,
                value: columnInfo.name
            });
        }
        grandTotalRow.push(data);
        
        // add grand totals for each column
        for(var i=1; i<lastGroupRow.length; i++){
            var key = 'T!' + lastGroupRow[i].key;
            if(report.factMap[key]){
                data = report.factMap[key].aggregates;
                helper.addCurrencySymbol(data);
                grandTotalRow.push(data);
            }
        }
        // add grand totals
        aggregates = report.factMap['T!T'].aggregates;
        helper.addCurrencySymbol(aggregates);
        grandTotalRow.push(aggregates);
        columnData.push(grandTotalRow);
        
        component.set('v.groupingData', columnData);
    },
    addCurrencySymbol: function(aggregates) {
        for (var l=0; l<aggregates.length; l++) {
            var obj = aggregates[l];
            if (obj && obj.label) {
                // remove decimal places
                if (obj.label.startsWith('USD') || obj.label.startsWith('CAD') || obj.label.startsWith('AUD')) {
                    obj.label = obj.label.replace('USD', '$');
                    obj.label = obj.label.substring(0, obj.label.length - 3);
                } else if (obj.label.startsWith('GBP')) {
                    obj.label = obj.label.replace('GBP', '£');
                    obj.label = obj.label.substring(0, obj.label.length - 3);
                } else if (obj.label.startsWith('EUR')) {
                    obj.label = obj.label.replace('EUR', '€');
                    obj.label = obj.label.substring(0, obj.label.length - 3);
                } else if (obj.label.startsWith('INR')) {
                    obj.label = obj.label.replace('INR', '₹');
                    obj.label = obj.label.substring(0, obj.label.length - 3);
                }
            }
        }
    },
    toggleSpinner: function(component){
        var spinner = component.find('spinner');
        component.set('v.loading', !component.get('v.loading'));
        $A.util.toggleClass(spinner, 'slds-hide');
    },
    showToast: function(cmp, type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})