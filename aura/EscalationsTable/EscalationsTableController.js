// Copyright (C) Tigerface Systems, LLC - All Rights Reserved                    
// Unauthorized copying of this file, via any medium is strictly prohibited.     
// Proprietary and confidential.  Only authorized for use via Managed Packages   
// created and distrubuted by Tigerface Systems, LLC.                            
// This is a wrapper to a base component that represents a Screen Data Table for 
// Flow Builder.  This component was auto generated by Tigerface Systems, LLC    
// AppExchange Managed Package.                                                  
//                                                                               
// WARNING: DO NOT MAKE ANY CHANGES TO THIS AUTO GENERATED COMPONENT.            
//                                                                               
({ 
    handleRowSelection: function(component, event) { 
        var selectedRecords = event.getParam('selectedRows'); 
        component.set('v.selectedRecords', selectedRecords); 
    }, 
    handleUpdateRecords: function(component, event) { 
        var updatedRecords = event.getParam('updatedRecords'); 
        component.set('v.Executive_Escalation__cList', updatedRecords); 
    }, 
});