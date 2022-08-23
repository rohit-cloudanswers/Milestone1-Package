({
    doInit : function(c, e, h) {
        var rec = c.get('v.record');
        var fieldname = c.get('v.fieldName');
 
        if (fieldname.indexOf(".") !== -1) {  
            var parentRec = rec[fieldname.split(".")[0]]; 
            if(parentRec){
                c.set("v.resultvalue", parentRec[fieldname.split(".")[1]]);
            }
        }
        else {
            c.set("v.resultvalue", rec[fieldname]);
        }  
    }
})