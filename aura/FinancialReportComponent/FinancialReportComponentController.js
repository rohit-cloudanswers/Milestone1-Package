({
	doInit: function(component, event, helper) {
        var recordId = component.get('v.recordId');
        if(recordId == undefined && window.location.search){
            // search from location
            var queryString = window.location.search;
            queryString = queryString.replace(/\?/g, '');
            var queryParams = queryString.split('&');
            for(var i=0; i<queryParams.length; i++){
                var queryParam = queryParams[i];
                var parts = queryParam.split('=');
                if(parts[0] == 'id'){
                    recordId = parts[1];
                    component.set('v.recordId', recordId);
                    break;
                }
			}
        }
		var service = helper.getControllerService(component);
        helper.toggleSpinner(component);
        service.getCurrencies().then(function(currencyResult){
            var currencyData = JSON.parse(currencyResult);
            component.set('v.currencies', currencyData.currencies);
            component.set('v.selectedCurrency', currencyData.user_default);
            helper.toggleSpinner(component);
            helper.handleReportLoading(component);
        }).catch(function(error){
            helper.toggleSpinner(component);
            helper.showToast(component, 'error', 'Error', JSON.stringify(error));
            console.log(error);
        });
	},
    refreshReport: function(component, event, helper){
        var recordId = component.get('v.recordId');
        var selectedCurrency = component.get('v.selectedCurrency');
        helper.handleReportLoading(component);
    }
})