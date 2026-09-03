public with sharing class TripCancellationScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new TripCancellationBatch());
    }
}