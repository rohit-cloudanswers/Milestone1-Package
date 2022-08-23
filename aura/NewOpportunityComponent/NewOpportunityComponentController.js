({
	doInit: function(component, event, helper) {
        var sObjectName = component.get('v.sObjectName');
        var accId = component.get('v.accId');
        var conId = component.get('v.conId');
        var recordTypeId = component.get('v.recordTypeId');
        helper.openOpportunityModal(component, {AccountId: accId, ContactId: conId, RecordTypeId: recordTypeId});
	}
})