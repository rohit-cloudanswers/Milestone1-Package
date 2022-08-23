trigger Trigger_ContentDocumentLink on ContentDocumentLink (before insert) {
     //This trigger will make all new inserted files visible to Community Users
     for (ContentDocumentLink cdl : Trigger.new) {
 /*         if (cdl.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Case') {
               cdl.visibility = 'AllUsers'; 
          } */
         cdl.visibility = 'AllUsers';
     }
}