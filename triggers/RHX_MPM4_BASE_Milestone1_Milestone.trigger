trigger RHX_MPM4_BASE_Milestone1_Milestone on MPM4_BASE__Milestone1_Milestone__c
    (after delete, after insert, after undelete, after update, before delete) {
  	 Type rollClass = System.Type.forName('rh2', 'ParentUtil');
	 if(rollClass != null) {
		rh2.ParentUtil pu = (rh2.ParentUtil) rollClass.newInstance();
		if (trigger.isAfter) {
			pu.performTriggerRollups(trigger.oldMap, trigger.newMap, new String[]{'MPM4_BASE__Milestone1_Milestone__c'}, null);
    	}
    }
}