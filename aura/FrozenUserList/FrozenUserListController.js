({
  doInit: function(component, event, helper) {
    var action = component.get("c.getFrozenUserList");
    action.setCallback(this, function(data) {
      component.set("v.FrozenUserList", data.getReturnValue());
      console.log(data.getReturnValue());
    });
    $A.enqueueAction(action);
    }
})