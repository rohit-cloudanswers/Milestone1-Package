public class CaseMilestoneExceptionEdit {

    private ApexPages.StandardController sc;
    public Milestone_Exception__c sobj {public get; public set;}
    public CaseMilestone[] milestones {public get; private set;}
    public SelectOption[] milestoneOptions {public get; private set;}

    public CaseMilestoneExceptionEdit(ApexPages.StandardController sc) {
        this.sc = sc;
        this.sobj = (Milestone_Exception__c)sc.getRecord();
        this.sobj.Status__c = String.isBlank(this.sobj.Status__c) ? 'Draft' : this.sobj.Status__c;
        this.milestones = [select StartDate, TargetDate, MilestoneType.Name from CaseMilestone where CaseId = :sobj.Case__c and MilestoneType.Name not in ('Update', 'Automated Update') and IsCompleted = false order by TargetDate asc];
        milestoneOptions = new SelectOption[]{};
        for (CaseMilestone cm : this.milestones) {
            milestoneOptions.add(new SelectOption(cm.Id, cm.MilestoneType.Name + ' ('+cm.TargetDate+')'));
        }
        if (this.milestones.isEmpty() != true) {
            sobj.Case_Milestone_ID__c = this.milestones[0].Id;
        }
        milestoneOptionChanged();
    }

    public void milestoneOptionChanged () {
        for (CaseMilestone cm : [select MilestoneType.Name, StartDate, TargetDate from CaseMilestone where Id = :sobj.Case_Milestone_ID__c]) {
            sobj.Milestone__c = cm.MilestoneType.Name;
            sobj.Original_Target_Date__c = cm.TargetDate;
            sobj.Original_Start_Date__c = cm.StartDate;
            sobj.Proposed_Target_Date__c = cm.TargetDate;
        }
    }

    public PageReference save() {

        if (String.isBlank(this.sobj.Type__c)) {
            this.sobj.Type__c.addError('Type required');
            return null;
        }

        if (String.isBlank(this.sobj.Description__c)) {
            this.sobj.Description__c.addError('Reason is required');
            return null;
        }

        PageReference pr = this.sc.save();

        // submit for approval
        try {
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            //req1.setComments('Submitting request for approval.');
            req1.setObjectId(this.sc.getId());
            req1.setNextApproverIds(new Id[]{[select ManagerId from User where Id = :UserInfo.getUserId()].ManagerId});
            Approval.process(req1);
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        return pr;
    }

    public static void afterUpdateTriggerHandler (Map<Id, Milestone_Exception__c> oldExceptions, Map<Id, Milestone_Exception__c> newExceptions) {
        CaseMilestone[] toUpdate = new CaseMilestone[]{};
        for (Milestone_Exception__c me : newExceptions.values()) {
            String oldValue = oldExceptions.containsKey(me.Id) ? oldExceptions.get(me.Id).Status__c : null;
            String newValue = me.Status__c;
            if (newValue == 'Approved' && oldValue != newValue) {
                toUpdate.add(
                    new CaseMilestone(
                        Id = me.Case_Milestone_Id__c,
                        StartDate = me.Proposed_Start_Date__c
                    )
                );
            }
        }
        update toUpdate;

        // adjust for business hours
        
        Map<Id, CaseMilestone> check = new Map<Id, CaseMilestone>([
            select Id, StartDate, TargetDate, CaseId
            from CaseMilestone
            where Id in :toUpdate
        ]);

        CaseMilestone[] toUpdate2 = new CaseMilestone[]{};
        for (Milestone_Exception__c me : newExceptions.values()) {
            if (!check.containsKey(me.Case_Milestone_Id__c)) continue;
            if (me.Proposed_Target_Date__c == null) continue;
            Long dt1Long = me.Proposed_Target_Date__c.getTime();
            Long dt2Long = check.get(me.Case_Milestone_ID__c).TargetDate.getTime();
            Long milliseconds = dt1Long - dt2Long;
            if (milliseconds != 0) {
                CaseMilestone cm  = check.get(me.Case_Milestone_ID__c);
                cm.StartDate.addSeconds(Integer.valueOf(milliseconds/1000));
            }
        }
        
        try {
        	update toUpdate2;
        } catch (Exception e) {
            // ignore exception since it's just fine-tuning the date
        }
        
        // force dml on case so rollups re-run
        Set<Id> caseIds = new Set<Id>();
        for (Milestone_Exception__c e : newExceptions.values()) {
            if (e.Case__c != null) {
	            caseIds.add(e.Case__c);
            }
        }
		update [select Id from Case where Id in :caseIds];
    }
}