global class CreateIndividualFromLead_Sch implements Schedulable{

    global void execute(SchedulableContext sc) {
    startBatch();       
   }
    public static void startBatch() {
       Id batchInstanceId = database.executeBatch(new CreateIndividualFromLead(), 200);
    }
}