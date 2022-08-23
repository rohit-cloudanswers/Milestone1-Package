public without sharing class blogic_Case {
    public static void caseBeforeUpdateTrigger (Case[] cases) {    
        Map<Id, Case> casesWithMilestones = new Map<Id, Case>([
            select Id, 
            Resolution_Milestone_Target_Date__c, 
            Response_Milestone_Target_Date__c,
            Restore_Milestone_Target_Date__c,
            (select Id, TargetDate, MilestoneType.Name from CaseMilestones)
            from Case
            where Id in :cases
        ]);
        for (Case c : cases) {
            Case caseWithMilestone = casesWithMilestones.get(c.Id);
            // if (caseWithMilestone.CaseMilestones == null) continue; // null pointer exception check, is this necessary? 
            for (CaseMilestone cm : caseWithMilestone.CaseMilestones) {
                if ('Resolution'.equalsIgnoreCase(cm.MilestoneType.Name) && c.Resolution_Milestone_Target_Date__c != cm.TargetDate) {
                    c.Resolution_Milestone_Target_Date__c = cm.TargetDate;
                }
                if ('Response'.equalsIgnoreCase(cm.MilestoneType.Name) && c.Response_Milestone_Target_Date__c != cm.TargetDate) {
                    c.Response_Milestone_Target_Date__c = cm.TargetDate;
                }
                if ('Restore'.equalsIgnoreCase(cm.MilestoneType.Name) && c.Restore_Milestone_Target_Date__c != cm.TargetDate) {
                    c.Restore_Milestone_Target_Date__c = cm.TargetDate;
                }
            }
        }
    }
    
}