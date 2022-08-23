({
	onFileSelect: function(cmp, event, helper) {
        var self = this;
        helper.toggleSpinner(cmp);
        var promises = [];
        for(var i=0; i<event.srcElement.files.length; i++){
            var theFile = event.srcElement.files[i];
            promises.push(helper.uploadFile(cmp, theFile));
        }
        Promise.all(promises).then($A.getCallback(function(result){
            var fileUploadEvent = $A.get('e.c:FileUploadEvent');
            fileUploadEvent.setParams({
                status: true,
                data: result
            });
            fileUploadEvent.fire();
            helper.toggleSpinner(cmp);
            cmp.find("overlayLib").notifyClose();
        })).catch($A.getCallback(function(error){
            var fileUploadEvent = $A.get('e.c:FileUploadEvent');
            fileUploadEvent.setParams({
                status: false,
                data: error
            });
            fileUploadEvent.fire();
            helper.toggleSpinner(cmp);
            cmp.find("overlayLib").notifyClose();
        }));
	}
})