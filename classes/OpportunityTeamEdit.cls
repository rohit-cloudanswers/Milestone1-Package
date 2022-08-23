public without sharing class OpportunityTeamEdit {
	
    private ApexPages.StandardController sc;
    
	public List<OpportunityTeamMember> team {get; set;}
    public Id deleteId {get; set;}
    
	public OpportunityTeamEdit(ApexPages.StandardController sc) {
        this.sc = sc;
        init();
    }
    
    private void init () {
		this.team = [
			SELECT UserId, Name, TeamMemberRole, OpportunityAccessLevel
			FROM OpportunityTeamMember
			where OpportunityId = :sc.getId()
		];
	}

    public void defaultRoles() {
        Set<Id> userIds = new Set<Id>();
        for(OpportunityTeamMember otm : team) {
            userIds.add(otm.UserId);
        }

        Map<Id,User> users = new Map<Id,User>([SELECT Id, Name, Default_Opportunity_Team_Role__c, (SELECT UserId, Name, TeamMemberRole from OpportunityTeams order by CreatedDate desc LIMIT 1) from User where Id IN : userIds]);

        for(OpportunityTeamMember otm : team) {
            if(otm.TeamMemberRole == null && users.get(otm.UserId) != null) {
                if(users.get(otm.UserId).Default_Opportunity_Team_Role__c != null) {
                    otm.TeamMemberRole = users.get(otm.UserId).Default_Opportunity_Team_Role__c;
                } else {
                    otm.TeamMemberRole = users.get(otm.UserId).OpportunityTeams.size() == 0 ? null : users.get(otm.UserId).OpportunityTeams[0].TeamMemberRole;
                }
            }
        }

    }
    
    public PageReference save () {
        upsert team;
        return sc.view();
    }
    
    public void addTeamMemberRow () {
        team.add(new OpportunityTeamMember(OpportunityId = sc.getId(), OpportunityAccessLevel = 'Edit'));
    }
    
    public void deleteTeamMember () {
        delete new OpportunityTeamMember(Id=deleteId);
        init();
    }
}