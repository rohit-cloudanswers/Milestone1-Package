trigger PreventTaskDeletion on MPM4_BASE__Milestone1_Task__c(before delete) 
{
    for(MPM4_BASE__Milestone1_Task__c task : Trigger.old) 
    {
        if (task.All_Time_on_this_Task__c > 0) 
        {
            task.addError('Tasks can only be deleted if there is no time on them.');
        }
    }
}