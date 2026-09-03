public with sharing class TripStatusUpdateScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new TripStatusUpdateBatch());
    }
}