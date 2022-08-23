({
    initFileUploadSession: function(component, folderId, fn) {
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.requestFileUploadSession');
            var params = {
                parentFolderId: folderId,
                fileName: fn
            };
            action.setParams(params);
            action.setCallback(this, function(a) {
                var err = a.getError();
                var result = a.getReturnValue();
                if (err && err.length > 0) reject(err);
                else resolve(result);
            });
            $A.enqueueAction(action, false);
        }));
    },
    uploadFile: function(cmp, theFile) {
        var helper = this;
        var fileName = theFile.name;
        var siteId = cmp.get('v.siteId');
        var parentId = cmp.get('v.folderId');
        var accessToken = cmp.get('v.accessToken');
        fileName = fileName.replace(/\(/g, '%28').replace(/\)/g, '%29');
        var url = 'https://graph.microsoft.com/v1.0/sites/'+siteId+'/drive/items/'+parentId+'/children/'+encodeURIComponent(fileName)+'/content';
        return new Promise(function(resolve, reject){
            var reader = new FileReader();
            reader.readAsArrayBuffer(theFile);
            reader.onload = function(e){
                // for files upto 4MB
                if(reader.result.byteLength <= (4 * 1024 * 1024)) {
                    try {
                        var xhr = new XMLHttpRequest();
                        xhr.open('PUT', url);
                        xhr.setRequestHeader("Authorization", "Bearer " + accessToken);
                        xhr.setRequestHeader("Content-Type", theFile.type);
                        xhr.onload = function(res){
                            if(res.currentTarget){
                                resolve(JSON.parse(res.currentTarget.response));
                            } else if(res.srcElement) {
                                resolve(JSON.parse(res.srcElement.response));
                            }
                        };
                        xhr.onerror = function(err){
                            if(err.currentTarget){
                                reject(JSON.parse(err.currentTarget.response));
                            } else if(err.srcElement) {
                                reject(JSON.parse(err.srcElement.response));
                            }
                        }
                        xhr.send(reader.result);
                    } catch(ex) {
                        reject(ex);
                    }
                } else {
                    helper.initFileUploadSession(cmp, parentId, fileName).then(function(result){
                        var sess = JSON.parse(result);
                        var defaultErr = '{"error": "File upload failed."}';
                        if(sess.uploadUrl) {
                            try {
                                var xhr = new XMLHttpRequest();
                                xhr.open('PUT', sess.uploadUrl);
                                xhr.setRequestHeader("Content-Type", theFile.type);
                                xhr.setRequestHeader("Content-Length", reader.result.byteLength);
                                xhr.setRequestHeader("Content-Range", 'bytes 0-' + (reader.result.byteLength - 1) + '/' + reader.result.byteLength);
                                xhr.onload = function(res){
                                    if(res.currentTarget){
                                        var uploadResult = JSON.parse(res.currentTarget.response);
                                        if(uploadResult.error) {
                                            reject(uploadResult);
                                        } else {
                                            resolve(uploadResult);
                                        }
                                    } else if(res.srcElement) {
                                        var uploadResult = JSON.parse(res.srcElement.response);
                                        if(uploadResult.error) {
                                            reject(uploadResult);
                                        } else {
                                            resolve(uploadResult);
                                        }
                                    }
                                };
                                xhr.onerror = function(err){
                                    if(err.currentTarget){
                                        reject(JSON.parse(err.currentTarget.response || defaultErr));
                                    } else if(err.srcElement) {
                                        reject(JSON.parse(err.srcElement.response || defaultErr));
                                    }
                                }
                                xhr.send(reader.result);
                            } catch(ex) {
                                reject(ex);
                            }
                        } else {
                            reject(result);
                        }
                    }, function(err) {
                        reject(err);
                    })
                }
            }
        });
    },
    toggleSpinner: function(cmp){
        var spinner = cmp.find('spinner-01');
        $A.util.toggleClass(spinner, 'slds-hide');
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