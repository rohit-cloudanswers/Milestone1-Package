trigger MPM4_Time_Custom_Trigger on MPM4_BASE__Milestone1_Time__c (before insert, before update) {
    MPM4_Custom_Trigger_Utility.handleTimeBeforeTrigger(Trigger.new);
}