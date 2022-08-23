({
	getControllerService: function(component) {
		var service = {
            getTokenFromCode: function (code, redirectURL) {
                return setupAction("c.getTokenFromCode", parseToParams(getArgumentNames(this.getTokenFromCode), arguments));
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
    }
})