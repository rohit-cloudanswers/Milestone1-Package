trigger Milestone_Exception on Milestone_Exception__c (after update) {
    CaseMilestoneExceptionEdit.afterUpdateTriggerHandler(Trigger.oldMap, Trigger.newMap);
}