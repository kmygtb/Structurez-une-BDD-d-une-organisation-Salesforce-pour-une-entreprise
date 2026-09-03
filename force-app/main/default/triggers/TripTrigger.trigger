trigger TripTrigger on Trip__c (before insert, before update) {

for (Trip__c trip : Trigger.new) {
    System.debug('TripTrigger : validation des dates pour le Trip ' + trip.Id);
    TripService.validateDates(trip);
}
}