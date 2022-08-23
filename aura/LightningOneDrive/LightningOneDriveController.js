({
    afterScriptsLoaded: function(component, event, helper){
        swal.setDefaults({
            showCancelButton: false,
            allowOutsideClick : false,
            allowEscapeKey : false,
            allowEnterKey : false
        });
    },
    init: function(component, event, helper) {
        var ctrl = component.get('v.ctrl');
        if(ctrl == undefined) ctrl = {};
        ctrl.oneDrive = undefined;
        ctrl.breadcrumbs = [];
        ctrl.objectSettings = null;
        ctrl.selectedNode = null;
        ctrl.record = null;

        var OneDriveService = helper.getControllerService(component);
        var recordId = component.get('v.recordId');
        helper.showSpinner(component);
        Promise.all([
            OneDriveService.isAuthorized(),
            OneDriveService.getObjectSettings(recordId),
        ]).then(function(data){
            ctrl.hasToken =  data[0];
            ctrl.objectSettings = data[1];
            component.set('v.ctrl', ctrl);
            helper.hideSpinner(component);
        
            if(ctrl.hasToken === true) {
                // go as per existing logic
                helper.handleFolderNavigation(component, helper, recordId);
            }
        }).catch(function(error){
            if(error.length > 0) error = error[0];
            helper.showToast(component, 'error', 'Error', error.message);
            helper.hideSpinner(component);
        });
    },
    startAuthFlow: function(component, event, helper){
        var service = helper.getControllerService(component);
        var parser = helper.parseUrl(window.location.href);
        var redirectUrl = parser.protocol + '//' + parser.host + '/c/LightningOneDriveAuth.app';
        var state = component.get('v.recordId');
        service.getAuthStartUrl(redirectUrl, state).then(function(url){
            window.location.href = url;
        }).catch(function(error){
            helper.showToast(cmp, 'error', 'Error', JSON.stringify(error));
        });
    },
    handleLogout: function(cmp, event, helper){
        var OneDriveService = helper.getControllerService(cmp);
        helper.showSpinner(cmp);
        OneDriveService.logout().then(function(result){
            if(result == true){
                var ctrl = cmp.get('v.ctrl');
                ctrl.hasToken = false;
                ctrl.oneDrive = undefined;
                ctrl.breadcrumbs = [];
                ctrl.recordSetting = null;
                ctrl.selectedNode = null;
                ctrl.record = null;
                cmp.set('v.ctrl', ctrl);
            } else {
                helper.showToast(cmp, 'error', 'Error', 'Request failed');
            }
            helper.hideSpinner(cmp);
        }).catch(function(error){
            helper.hideSpinner(cmp);
            helper.showToast(cmp, 'error', 'Error', 'Request failed');
        })
    },
    handleNodeClick: function(cmp, event, helper){
        var nodeId = event.target.id;
        var ctrl = cmp.get('v.ctrl');
        var node = undefined;
        if(nodeId){
            for(var i=0; i<ctrl.selectedNode.nodes.length; i++){
                if(ctrl.selectedNode.nodes[i].id == nodeId){
                    node = ctrl.selectedNode.nodes[i];
                    break;
                }
            }
        }
        if(node != undefined && node.folder) {
            helper.handleOpenFolder(cmp, node);
        } else {
            helper.navigateToOneDrive(cmp, node);
        }
    },
    handleFileUploadEvent: function(cmp, event, helper){
        var status = event.getParam('status');
        var data = event.getParam('data');
        if(status == true){
            helper.showToast(cmp, 'success', 'Success', 'File uploaded successfully');
            var ctrl = cmp.get('v.ctrl');
            for(var i=0; i<data.length; i++){
                var node = helper.buildNode(data[i]);
                if(!helper.hasNode(ctrl.selectedNode.nodes, node)) ctrl.selectedNode.nodes.push(node);
            }
            cmp.set('v.ctrl', ctrl);
        } else {
            helper.showToast(cmp, 'error', 'Error', data.message || 'File upload failed');
        }
    },
    onBreadcrumbClick: function(cmp, event, helper){
        var breadcrumbId = event.target.id;
        var ctrl = cmp.get('v.ctrl');
        var index = -1;
        for(var i=0; i<ctrl.breadcrumbs.length; i++){
            if(ctrl.breadcrumbs[i].id == breadcrumbId){
                index = i;
                break;
            }
        }
        // don't let user move to top level
        if(index > 0){
            ctrl.breadcrumbs = ctrl.breadcrumbs.splice(0, index + 1);
            ctrl.selectedNode = ctrl.breadcrumbs[index];
        }
        cmp.set('v.ctrl', ctrl);
    },
    onBackClicked: function(cmp, event, helper){
        var ctrl = cmp.get('v.ctrl');
        if(ctrl.breadcrumbs.length > 2){
            var index = ctrl.breadcrumbs.length - 2;
            ctrl.breadcrumbs = ctrl.breadcrumbs.splice(0, index + 1);
            ctrl.selectedNode = ctrl.breadcrumbs[index];
        }
        cmp.set('v.ctrl', ctrl);
    },
    onCreateSubfolderClick: function(cmp, event, helper){
        $A.createComponents(
            [
                ["c:newFolderModalContent", {'folderName': cmp.getReference('v.newFolderName')}],
                ["c:newFolderModalFooter", {'folderName': cmp.getReference('v.newFolderName')}]
            ], function(components, status){
            if(status == 'SUCCESS'){
                var modalBody = components[0];
                var modalFooter = components[1];
                cmp.find('overlayLib').showCustomModal({
                    header: 'Create subfolder',
                    body: modalBody,
                    footer: modalFooter,
                    showCloseButton: true,
                    closeCallback: function(){
                        var selectedNode = cmp.get('v.ctrl').selectedNode;
                        var parentFolderId = selectedNode.isRoot == true ? 'root' : selectedNode.id;
                        var folderName = cmp.get('v.newFolderName');
                        cmp.set('v.newFolderName', '');
                        if(folderName.length > 0) {
                            helper.handleCreateFolder(cmp, parentFolderId, folderName);
                        }
                    }
                });
            }
        });
    },
    onUploadFileClick: function(cmp, event, helper){
        var parentNode = cmp.get('v.ctrl').selectedNode;
        var parentFolderId = parentNode.isRoot == true ? 'root' : parentNode.id;
        var OneDriveService = helper.getControllerService(cmp);
        OneDriveService.getDataForFileUpload().then($A.getCallback(function(result){
            var data = JSON.parse(result);
            $A.createComponents(
                [
                    ["c:uploadFileModalContent", {'folderId': parentFolderId, 'siteId': data.siteId, 'accessToken': data.accessToken}],
                    ["c:uploadFileModalFooter", {'folderId': parentFolderId}]
                ], function(components, status, errorMessage){
                    if(status == 'SUCCESS'){
                        var modalBody = components[0];
                        var modalFooter = components[1];
                        cmp.find('overlayLib').showCustomModal({
                            header: 'Upload file',
                            body: modalBody,
                            footer: modalFooter,
                            showCloseButton: true,
                            closeCallback: function(){
                                modalBody.destroy();
                                modalFooter.destroy();
                            }
                        });
                    } else if(status == 'ERROR') {
                        helper.showToast(cmp, 'error', 'Error', errorMessage);
                    }
                }
            );
        })).catch(function(error){
            helper.showToast(cmp, 'error', 'Error', JSON.stringify(error));
            console.log(error);
        });
    },
    onOpenClick: function(cmp, event, helper){
        var ctrl = cmp.get('v.ctrl');
        var selectedNode = ctrl.selectedNode;
        helper.navigateToOneDrive(cmp, selectedNode);
    },
    downloadFile: function(cmp, event, helper){
        var ctrl = cmp.get('v.ctrl');
        if(event.target && event.target.id){
            var id = event.target.id.split('-')[1];
            for(var i=0; i<ctrl.selectedNode.nodes.length; i++){
                var node = ctrl.selectedNode.nodes[i];
                if(node.file != null && node.id == id){
                    if(node.downloadUrl) {
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            'url': node.downloadUrl
                        });
                        urlEvent.fire();
                    } else {
                        helper.showToast(cmp, 'error', 'Error', 'Download url not available');
                    }
                }
            }
        }
    }
})