trigger MPM_Project_Res_Custom_Trigger on MPM_Project_Resource__c (before insert, before update) {
    MPM4_Custom_Trigger_Utility.handleProjResBeforeTrigger(Trigger.new);

}