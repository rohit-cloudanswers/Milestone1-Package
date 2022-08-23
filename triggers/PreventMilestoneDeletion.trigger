trigger PreventMilestoneDeletion on MPM4_BASE__Milestone1_Milestone__c(before delete) 
{
    for(MPM4_BASE__Milestone1_Milestone__c milestone : Trigger.old) 
    {
        if (milestone.Tasks_With_Time__c > 0){
            milestone.addError('Milestones can only be deleted if there is no time on them.');
        }
    }
}