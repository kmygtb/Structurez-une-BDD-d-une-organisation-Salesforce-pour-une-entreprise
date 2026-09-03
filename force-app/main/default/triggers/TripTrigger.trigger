trigger TripTrigger on Trip__c (before insert, before update) {

    for (Trip__c trip : Trigger.new) {
        TripService.validateDates(trip);
    }
}