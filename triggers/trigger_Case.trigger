trigger trigger_Case on Case (before update) {
    blogic_Case.caseBeforeUpdateTrigger(Trigger.new);
}