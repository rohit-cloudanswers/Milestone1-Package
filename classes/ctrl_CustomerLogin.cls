global with sharing class ctrl_CustomerLogin {
	global String username {get; set;}
	global String password {get; set;}
	
	global PageReference login() {
	    String startUrl = System.currentPageReference().getParameters().get('startURL');
	    //startUrl= 'https://c.na17.visual.force.com/apex/cleanPortalLandingPage';
	    //return Site.login(username, password, startUrl);
	    return Site.login(username, password, '/apex/customerCommunityHomepage');
	}

	public ctrl_CustomerLogin() {
		
	}
}