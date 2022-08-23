({
    getControllerService: function(component) {
        var service = {
            getAuthStartUrl: function (redirectUrl, state) {
                return setupAction("c.getAuthStartUrl", parseToParams(getArgumentNames(this.getAuthStartUrl), arguments));
            },
            isAuthorized: function () {
                return setupAction("c.isAuthorized", parseToParams(getArgumentNames(this.isAuthorized), arguments));
            },
            getObjectSettings: function (recordId) {
                return setupAction("c.getObjectSettings", parseToParams(getArgumentNames(this.getObjectSettings), arguments));
            },
            getDocumentLibrary: function () {
                return setupAction('c.getDocumentLibrary', parseToParams(getArgumentNames(this.getDocumentLibrary), arguments));
            },
            getDocumentLibraryChildren: function (recordId) {
                return setupAction('c.getDocumentLibraryChildren', parseToParams(getArgumentNames(this.getDocumentLibraryChildren), arguments));
            },
            searchBaseFolderUnderDocumentLibrary: function (folderJson) {
                return setupAction('c.searchBaseFolderUnderDocumentLibrary', parseToParams(getArgumentNames(this.searchBaseFolderUnderDocumentLibrary), arguments));
            },
            searchFolderInParent: function (folderJson) {
                return setupAction('c.searchFolderInParent', parseToParams(getArgumentNames(this.searchFolderInParent), arguments));
            },
            getSalesforceRecord: function (recordId, folderField, objectName, parentObjectName, parentIdField) {
                return setupAction('c.getSalesforceRecord', parseToParams(getArgumentNames(this.getSalesforceRecord), arguments));
            },
            fetchChildren: function (folderId) {
                return setupAction('c.fetchChildren', parseToParams(getArgumentNames(this.fetchChildren), arguments));
            },
            createFolder: function (parentFolderId, payload) {
                return setupAction('c.createFolder', parseToParams(getArgumentNames(this.createFolder), arguments));
            },
            getDataForFileUpload: function () {
                return setupAction('c.getDataForFileUpload', parseToParams(getArgumentNames(this.getDataForFileUpload), arguments));
            },
            updateFolderId: function (objectName, recordId, folderId) {
                return setupAction('c.updateFolderId', parseToParams(getArgumentNames(this.updateFolderId), arguments));
            },
            logout: function () {
                return setupAction('c.logout', parseToParams(getArgumentNames(this.logout), arguments));
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
    },
    parseUrl: function(url){
        var parser = document.createElement('a');
        parser.href = url;
        return parser;
    },
    handleFolderNavigation: function(component, helper, recordId) {
        var ctrl = component.get('v.ctrl');
        var OneDriveService = helper.getControllerService(component);
        var promises = [OneDriveService.getDocumentLibrary()];
        /*
        Root => Account => BaseFolder => Object record folder

        Root => Account => Object record folder

        Root => BaseFolder => Object record folder

        Root => Object record folder
        */

        if(ctrl.objectSettings.length > 0) {


            var objectSetting = ctrl.objectSettings[ctrl.objectSettings.length - 1];
            if(objectSetting.baseFolderName || objectSetting.baseFolderId) { 
                var baseFolderId = objectSetting.baseFolderId;
                var baseFolderName = objectSetting.baseFolderName;
                
                if(!baseFolderId && baseFolderName) {
                    var requestJson = '{"folderName":"'+baseFolderName+'"}';
                    promises.push(OneDriveService.searchBaseFolderUnderDocumentLibrary(requestJson));
                } else {
                    var requestJson = '{"baseFolderId":"'+baseFolderId+'"}';
                    promises.push(OneDriveService.searchBaseFolderUnderDocumentLibrary(requestJson));
                }
            } else {
                promises.push(OneDriveService.getDocumentLibraryChildren(recordId));
            }
            helper.showSpinner(component);
            Promise.all(promises).then(function(response){
                var driveData = JSON.parse(response[0]);
                var driveChildren = JSON.parse(response[1]);
                helper.hideSpinner(component);
                if(driveData) {
                    if(!driveData.error) {
                        var objectRecords = response[2];
                        // setup drive
                        helper.setupOneDrive(component, driveData, driveChildren);
                        // load record heirarchy
                        var recId = recordId;
                        var objectSettings = ctrl.objectSettings;
                        helper.showSpinner(component);
                        objectSettings.reduce(
                            (previousPromise, objectSetting) => {
                                return previousPromise.then((chainResults) => {
                                    var result = chainResults.length > 0 ? chainResults[chainResults.length - 1] : null;
                                    if(result && result.parent_id_field) recId = JSON.parse(result.record)[result.parent_id_field];
                                    return OneDriveService.getSalesforceRecord(recId, objectSetting.folderField, objectSetting.objectName, objectSetting.parentObjectName || '', objectSetting.parentLookupField || '')
                                        .then(currentResult => [ ...chainResults, currentResult ]);
                                });
                            }, Promise.resolve([])
                        ).then(records => {
                            // process records
                            for(var i=0; i<records.length; i++){
                                var record = JSON.parse(records[i].record);
                                records[i].record = record;
                            }
                            ctrl.objectRecords = records;
                            ctrl.settingIndex = ctrl.objectRecords.length - 1;
                            component.set('v.ctrl', ctrl);
                            helper.hideSpinner(component);
                            // open the record specific folders
                            helper.navigateToFolder(component);                            
                        }).catch(function(err){
                            helper.hideSpinner(component);
                            helper.showToast(component, 'error', 'Error', err.message || (err.length ? err[0].message : 'Something went wrong, please reload the page.'));
                        })
                    } else {
                        ctrl.hasToken = false;
                        component.set('v.ctrl', ctrl);
                        helper.showToast(component, 'error', 'Error', driveData.error.message);
                    }
                } else {
                    component.set('v.ctrl', ctrl);
                    helper.showToast(component, 'error', 'Error', 'Something went wrong, please reload the page.');
                }
            }).catch(function(error){
                helper.hideSpinner(component);
                var msg = (error.length && error.length > 0) ? error[0].message : error.message;
                helper.showToast(component, 'error', 'Error', msg);
            });
        }
    },
    setupOneDrive: function(cmp, drive, driveChildren){
        var helper = this;
        var ctrl = cmp.get('v.ctrl');
        var rootNode = {
            id: drive.id,
            title: drive.name || 'Documents',
            folder: {
                childCount: 0
            },
            nodes: [],
            isRoot: true,
            webUrl: drive.webUrl
        };
        // append children to root node
        if(driveChildren && driveChildren.parentReference && driveChildren.parentReference.driveId == drive.id){
            rootNode.folder.childCount = driveChildren.folder.childCount;
            for(var i=0; i<driveChildren.children.length; i++){
                var node = helper.buildNode(driveChildren.children[i]);
                rootNode.nodes.push(node);
            }
        }
        // setup breadcrumps
        ctrl.oneDrive = rootNode;
        ctrl.selectedNode = ctrl.oneDrive;
        ctrl.breadcrumbs.push(ctrl.selectedNode);
        cmp.set('v.ctrl', ctrl);
    },
    buildNode: function(child){
        if(child.error) throw child.error.message;
        var node = {};
        node.id = child.id;
        node.title = child.name;
        node.nodes = [];
        if(child.folder) {
            node.folder = JSON.parse(JSON.stringify(child.folder));
        } else {
            node.file = JSON.parse(JSON.stringify(child.file));
            node.downloadUrl = child['@microsoft.graph.downloadUrl'];
        }
        node.size = child.size;
        node.webUrl = child.webUrl;
        return node;
    },
    navigateToBaseFolder: function(cmp){
        var helper = this;
        var ctrl = cmp.get('v.ctrl');
        var setting = ctrl.objectSettings[ctrl.settingIndex];
        var baseNode = undefined;
        if(setting.baseFolderName){
            for(var i=0; i<ctrl.selectedNode.nodes.length; i++){
                var node = ctrl.selectedNode.nodes[i];
                if(node.title == setting.baseFolderName) {
                    baseNode = node;
                }
            }
            if(baseNode) {
                ctrl.selectedNode = baseNode;
                ctrl.breadcrumbs.push(ctrl.selectedNode);
                cmp.set('v.ctrl', ctrl);
            } else {
                // create base folder
                var payload = JSON.stringify({name: setting.baseFolderName, folder: {}});
                var parentId = ctrl.selectedNode.isRoot == true ? 'root' : ctrl.selectedNode.id;
                helper.showSpinner(cmp);
                var OneDriveService = helper.getControllerService(cmp);
                OneDriveService.createFolder(parentId, payload).then(function(createResult){
                    var result = JSON.parse(createResult);
                    helper.hideSpinner(cmp);
                    if(result.id) {
                        var node = helper.buildNode(result);
                        ctrl.selectedNode.nodes.push(node);
                        ctrl.selectedNode = node;
                        ctrl.breadcrumbs.push(node);
                        cmp.set('v.ctrl', ctrl);
                    }
                }).catch(function(error){
                    console.log(error);
                    helper.hideSpinner(cmp);
                });
            }
        }
    },
    navigateToFolder: function(cmp){
        var helper = this;
        var ctrl = cmp.get('v.ctrl');
        var settingIndex = ctrl.settingIndex;

        // logic to skip creating parent records for existing folders
        var startIndex = settingIndex;
        if((settingIndex == ctrl.objectRecords.length - 1) && settingIndex > 0) {
            for(var i=settingIndex; i >= 0; i--) {
                if(ctrl.objectRecords[i].record.OneDrive_Folder_Id__c) {
                    startIndex = i;
                    break;
                }
            }
        }
        if(startIndex > -1 && startIndex != settingIndex) {
            ctrl.settingIndex = startIndex;
            settingIndex = startIndex;
            cmp.set('v.ctrl', ctrl);
        }
        
        if(settingIndex > -1) {
            // if the current record setting has base folder defined, 
            // navigate to base folder before navigating to record folder
            var record = ctrl.objectRecords[settingIndex].record;
            var setting = ctrl.objectSettings[settingIndex];
            if(setting.baseFolderName) {
                // navigate to base folder
                helper.navigateToBaseFolder(cmp);
            }
            helper.handleObjectRecord(cmp);
        }
    },
    handleObjectRecord: function(cmp){
        var helper = this;
        var ctrl = cmp.get('v.ctrl');
        var settingIndex = ctrl.settingIndex;
        var record = ctrl.objectRecords[settingIndex].record;
        var setting = ctrl.objectSettings[settingIndex];
        if(record){
            if(!record.OneDrive_Folder_Id__c){
                // prompt to create folder only when set to true
                if(setting.createNestedFolder) helper.promptCreateFolder(cmp, record, setting);
            } else {
                // load record drive item
                var OneDriveService = helper.getControllerService(cmp);
                var recordNode = undefined;
                if(ctrl.selectedNode.nodes) {
                    for(var i=0; i<ctrl.selectedNode.nodes.length; i++){
                        var node = ctrl.selectedNode.nodes[i];
                        if(node.id == record.OneDrive_Folder_Id__c) {
                            recordNode = node;
                            break;
                        }
                    }
                }
                if(!recordNode) {
                    helper.showSpinner(cmp);
                    OneDriveService.fetchChildren(record.OneDrive_Folder_Id__c).then(function(result){
                        var data = JSON.parse(result);
                        helper.hideSpinner(cmp);
                        if(!data.error) {
                            var node = helper.buildNode(data);
                            // child nodes
                            for(var i=0; i<data.children.length; i++){
                                var childNode = helper.buildNode(data.children[i]);
                                node.nodes.push(childNode);
                            }

                            /*
                            // check missing default folders
                            var defaultFolders = [];
                            if(setting.defaultFolders) {
                                defaultFolders = setting.defaultFolders.split(';');
                            }
                            var missingFolders = [];
                            for(var i=0; i<defaultFolders.length; i++) {
                                var childNode = undefined;
                                for(var j=0; j<node.nodes.length; j++) {
                                    if(defaultFolders[i] == node.nodes[j].title) {
                                        childNode = node.nodes[j];
                                    }
                                }
                                if(!childNode) missingFolders.push(defaultFolders[i]);
                            }
                            if(missingFolders.length > 0) {
                                // create missing default folders
                                (function(node, folders){
                                    var promises = [];
                                    for(var i=0; i<missingFolders.length; i++){
                                        var payload = JSON.stringify({
                                            name: folders[i],
                                            folder: {}
                                        });
                                        promises.push(OneDriveService.createFolder(node.id, payload));
                                    }
                                    return Promise.all(promises);
                                })(node, missingFolders).then(resultNodes => {
                                    for(var i=0; i<resultNodes.length; i++) {
                                        var missingNode = helper.buildNode(JSON.parse(resultNodes[i]));
                                        node.nodes.push(missingNode);
                                    }
                                    ctrl.selectedNode.nodes.push(node);
                                    ctrl.selectedNode = node;
                                    ctrl.breadcrumbs.push(ctrl.selectedNode);
                                    // folder loaded, move to next setting
                                    settingIndex = settingIndex - 1;
                                    ctrl.settingIndex = settingIndex;
                                    cmp.set('v.ctrl', ctrl);
                                    // ctrl.objectRecords[0].record.OneDrive_Folder_Id__c != null && (!ctrl.objectRecords[1] || !ctrl.objectRecords[1].record.OneDrive_Folder_Id__c)
                                    // if the first folder has one drive folder id and parent root has missing one drive folder id, simply shake that from tree
                                    helper.navigateToFolder(cmp);
                                });
                            } else {
                                ctrl.selectedNode.nodes.push(node);
                                ctrl.selectedNode = node;
                                ctrl.breadcrumbs.push(ctrl.selectedNode);
                                // folder loaded, move to next setting
                                settingIndex = settingIndex - 1;
                                ctrl.settingIndex = settingIndex;
                                cmp.set('v.ctrl', ctrl);
                                helper.navigateToFolder(cmp);
                            }*/
                            ctrl.selectedNode.nodes.push(node);
                            ctrl.selectedNode = node;
                            ctrl.breadcrumbs.push(ctrl.selectedNode);
                            // folder loaded, move to next setting
                            settingIndex = settingIndex - 1;
                            ctrl.settingIndex = settingIndex;
                            cmp.set('v.ctrl', ctrl);
                            helper.navigateToFolder(cmp);
                        } else {
                            OneDriveService.updateFolderId(setting.objectName, record.Id, '').then(function(updated){
                                delete record.OneDrive_Folder_Id__c;
                                ctrl.objectRecords[settingIndex].record = record;
                                cmp.set('v.ctrl', ctrl);
                            });
                            helper.showToast(cmp, 'error', 'Error', data.error.message);
                        }
                    }).catch(function(error){
                        helper.hideSpinner(cmp);
                        helper.showToast(cmp, 'error', 'Error', JSON.stringify(error));
                    });
                } else {
                    settingIndex = settingIndex - 1;
                    ctrl.settingIndex = settingIndex;
                    cmp.set('v.ctrl', ctrl);
                    helper.handleOpenFolder(cmp, recordNode);
                }
            }
        }
    },
    handleOpenFolder: function(cmp, node){
        var helper = this;
        if(node.file) {
            return;
        }
        var ctrl = cmp.get('v.ctrl');
        var OneDriveService = helper.getControllerService(cmp);
        if(node.folder.childCount > 0 && node.nodes.length == 0){
            // nodes.length == 0 means the data hasn't been loaded from onedrive
            helper.showSpinner(cmp);
            OneDriveService.fetchChildren(node.id).then(function(result){
                var data = JSON.parse(result);
                helper.hideSpinner(cmp);
                for(var i=0; i<data.children.length; i++){
                    var childNode = helper.buildNode(data.children[i]);
                    node.nodes.push(childNode);
                }
                ctrl.selectedNode = node;
                ctrl.breadcrumbs.push(node);
                cmp.set('v.ctrl', ctrl);
                // folder loaded, move next setting
                helper.navigateToFolder(cmp);
            }).catch(function(error){
                helper.hideSpinner(cmp);
                helper.showToast(cmp, 'error', 'Error', JSON.stringify(error));
            })
        } else {
            ctrl.breadcrumbs.push(node);
            ctrl.selectedNode = node;
            cmp.set('v.ctrl', ctrl);
        }
    },
    promptCreateFolder: function(cmp, record, setting){
        var helper = this;
        var ctrl = cmp.get('v.ctrl');
        var container = document.querySelector('#onedrive_' + cmp.get('v.recordId'));
        var OneDriveService = helper.getControllerService(cmp);
        var folderName = record[setting.folderField];
        swal({
            title: 'Create record folder',
            showCancelButton: true,
            confirmButtonText: 'Create',
            html: 'No matching folder found for selected object record. Do you want to create folder with name: <b>' 
                + folderName + '</b> ?',
            animation: 'slide-from-top',
            target: container
        }).then(function(isConfirm){
            if(isConfirm == true) {
                var payload = JSON.stringify({name: folderName, folder: {}});
                var parentId = ctrl.selectedNode.isRoot == true ? 'root' : ctrl.selectedNode.id;
                helper.showSpinner(cmp);
                OneDriveService.createFolder(parentId, payload).then(function(createResult){
                    var result = JSON.parse(createResult);
                    helper.hideSpinner(cmp);
                    if(result.id) {
                        var node = helper.buildNode(result);
                        ctrl.selectedNode.nodes.push(node);
                        ctrl.selectedNode = node;
                        ctrl.breadcrumbs.push(node);
                        ctrl.settingIndex = ctrl.settingIndex - 1;
                        cmp.set('v.ctrl', ctrl);
                        helper.showToast(cmp, 'success', 'Success', 'Record folder created');
                        // update on record
                        helper.showSpinner(cmp);
                        OneDriveService.updateFolderId(setting.objectName, record.Id, result.id).then(function(status){
                            helper.hideSpinner(cmp);
                            if(setting.defaultFolders) { 
                                helper.createDefaultSubfolders(cmp, setting, result.id, true);
                            } else {
                                // navigate to record folder
                                helper.navigateToFolder(cmp);
                            }
                        });
                    } else if (result.error) {
                        helper.showToast(cmp, 'error', 'Error', result.error.message);
                    }
                }).catch(function(error){
                    console.log(error);
                    helper.hideSpinner(cmp);
                });
            }
        }, function(cancel){
            console.log(cancel);
        }).catch(function(err){
            console.log(err);
        });
    },
    handleCreateFolder: function(cmp, parentFolderId, folderName){
        var helper = this;
        var OneDriveService = this.getControllerService(cmp);
        var payload = JSON.stringify({
            name: folderName,
            folder: {}
        });
        helper.showSpinner(cmp);
        OneDriveService.createFolder(parentFolderId, payload).then(function(data){
            var result = JSON.parse(data);
            if(result.id){
                var node = helper.buildNode(result);
                var ctrl = cmp.get('v.ctrl');
                if(!helper.hasNode(ctrl.selectedNode.nodes, node)){
                    ctrl.selectedNode.nodes.push(node);
                    ctrl.selectedNode.folder.childCount++;
                    cmp.set('v.ctrl', ctrl);
                }
                helper.showToast(cmp, 'success', 'Success!', 'New folder created');
            } else if(result.error) {
                helper.showToast(cmp, 'error', 'Error', result.error.message);
            }
            helper.hideSpinner(cmp);
        }).catch(function(error){
            console.log(error);
            helper.hideSpinner(cmp);
        })
    },
    createDefaultSubfolders: function(cmp, setting, parentFolderId, moveInside){
        var helper = this;
        var OneDriveService = helper.getControllerService(cmp);
        var ctrl = cmp.get('v.ctrl');
        if(setting.defaultFolders){
            var defaultFolders = setting.defaultFolders.split(';');
            if(defaultFolders.length != 0){
                helper.showSpinner(cmp);
                var promises = [];
                for(var i=0; i<defaultFolders.length; i++){
                    var payload = JSON.stringify({
                        name: defaultFolders[i],
                        folder: {}
                    });
                    promises.push(OneDriveService.createFolder(parentFolderId, payload));
                }
                Promise.all(promises).then(function(data){
                    if(parentFolderId == ctrl.selectedNode.id){
                        if(!ctrl.selectedNode.nodes) ctrl.selectedNode.nodes = [];
                        for(var j=0; j<data.length; j++){
                            var childNode = helper.buildNode(JSON.parse(data[j]));
                            ctrl.selectedNode.nodes.push(childNode);
                        }
                    }
                    helper.hideSpinner(cmp);
                    cmp.set('v.ctrl', ctrl);
                    if(moveInside == true) helper.navigateToFolder(cmp);
                }).catch(function(error){
                    helper.showToast(cmp, 'error', 'Error', JSON.stringify(error));
                    helper.hideSpinner(cmp);
                });
            }
        }
    },
    hasNode: function(nodes, node){
        var result = false;
        for(var i=0; i<nodes.length; i++){
            if(nodes[i].id == node.id) {
                result = true;
                break;
            }
        }
        return result;
    },
    navigateToOneDrive: function(cmp, node){
        if(node && node.webUrl) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                'url': node.webUrl
            });
            urlEvent.fire();
        }
    },
    showSpinner: function(cmp){
        var spinner = cmp.find('spinner_123');
        $A.util.removeClass(spinner, 'slds-hide');
    },
    hideSpinner: function(cmp){
        var spinner = cmp.find('spinner_123');
        $A.util.addClass(spinner, 'slds-hide');
    },
    showToast: function(cmp, type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})