public class MPM4_EditMilestonesTasksRedirect {
    public Object x2 {get; private set;}
    public MPM4_EditMilestonesTasksRedirect (ApexPages.StandardSetController standardController) {
        x2 = ApexPages.currentPage().getParameters();
    }
    public PageReference onLoad () {
        // swap out the page reference to direct to a different page:
        PageReference pr = Page.MPM4_EditMilestonesTasks;
        pr.getParameters().putAll(ApexPages.currentPage().getParameters());
        pr.setRedirect(true);
        return pr;
    }
}