global class schedule_IntegrationLog implements Schedulable {
    global void execute(SchedulableContext sc) {
        startBatch();       
    }
    public static void startBatch() {
       Id batchInstanceId = database.executeBatch(new blogic_IntegrationLog(), 200);
    }
}