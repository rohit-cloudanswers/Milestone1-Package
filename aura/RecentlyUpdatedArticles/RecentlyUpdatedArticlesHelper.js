({
    getArts: function(cmp){
        var action = cmp.get("c.getArticlesList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.articles", response.getReturnValue());
            }
            else {
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
            }
        });
     $A.enqueueAction(action);
    }
})