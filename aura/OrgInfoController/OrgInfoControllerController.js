({
  doInit: function(component, event, helper) {
    var action = component.get("c.getOrgInfoList");
    action.setCallback(this, function(data) {
      var x = data.getReturnValue();
		x = [...x];
		for (const y of x) y.Id = y.Id.substr(0,15);
		component.set('v.OrgInfoList', x);
      //component.set("v.OrgInfoList", data.getReturnValue());
      console.log(data.getReturnValue());
    });
    $A.enqueueAction(action);
    }
})