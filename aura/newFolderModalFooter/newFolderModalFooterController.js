({
    handleCancel: function(cmp, event, helper){
        cmp.set('v.folderName', '');
        cmp.find("overlayLib").notifyClose();
    },
	handleCreateFolder: function(cmp, event, helper) {
		cmp.find("overlayLib").notifyClose();
	}
})