({
	afterScriptsLoaded: function(component, event, helper) {
        swal.setDefaults({
          showCancelButton: false,
          allowOutsideClick : false,
          allowEscapeKey : false,
          allowEnterKey : false
        });
        var code = component.get("v.code");
        var state = component.get("v.state");
        var OneDriveService = helper.getControllerService(component);
        OneDriveService.getTokenFromCode(code, state).then(function(result) {
          var tokens = JSON.parse(result);
          if (tokens.refresh_token) {
            swal({
              title: "Success",
              text: "Auhorization complete.",
              type: "success",
              showCancelButton: false,
              confirmButtonColor: "#DD6B55",
              confirmButtonText: "Ok"
            }).then(
              function(isConfirm) {
                if(isConfirm) {
                    window.location.href = '/' + state;
                }
              });
          }
          else{
            swal({
              title: "Error",
              text: "Auhorization failed.",
              type: "error",
              showCancelButton: false
            }).then(function(){
                window.location.href = '/' + state;
            }).catch(swal.noop);
          }
        }).catch(function(error){
            swal({
              title: "Error",
              text: "Unable to fetch token",
              type: "error",
              showCancelButton: false
            }).catch(swal.noop);
        })
	}
})