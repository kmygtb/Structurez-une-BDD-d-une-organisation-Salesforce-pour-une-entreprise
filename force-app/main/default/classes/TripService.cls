public with sharing class TripService {

    private static final String DEFAULT_STATUS = 'À venir';

    /**
     * Crée un Trip__c par défaut pour chaque opportunité venant de passer
     * au stade "Closed Won", avec mapping automatique des champs.
     */
  public static void createTripsForWonOpportunities(List<Opportunity> wonOpportunities) {
    Set<Id> opportunityIds = new Set<Id>();
    for (Opportunity opp : wonOpportunities) {
        opportunityIds.add(opp.Id);
    }

    Map<Id, Trip__c> existingTripByOpportunity = new Map<Id, Trip__c>();
    for (Trip__c existingTrip : [
            SELECT Id, Opportunity__c
            FROM Trip__c
            WHERE Opportunity__c IN :opportunityIds
    ]) {
        existingTripByOpportunity.put(existingTrip.Opportunity__c, existingTrip);
    }

    List<Trip__c> tripsToInsert = new List<Trip__c>();
    for (Opportunity opp : wonOpportunities) {
        if (existingTripByOpportunity.containsKey(opp.Id)) {
            System.debug('Trip deja existant pour Opportunity ' + opp.Id + ', creation ignoree.');
            continue;
        }
        tripsToInsert.add(new Trip__c(
                Statut__c = DEFAULT_STATUS,
                Destination__c = opp.Destination__c,
                Start_Date__c = opp.Start_Date__c,
                End_Date__c = opp.End_Date__c,
                Number_of_Participants__c = opp.Number_of_Participants__c,
                Account__c = opp.AccountId,
                Opportunity__c = opp.Id
        ));
    }

    if (!tripsToInsert.isEmpty()) {
        System.debug('Insertion de ' + tripsToInsert.size() + ' nouveau(x) Trip__c.');
        insert tripsToInsert;
    }
}

        public static void validateDates(Trip__c trip) {
        Boolean datesRenseignees = trip.Start_Date__c != null && trip.End_Date__c != null;

        if (datesRenseignees && trip.End_Date__c <= trip.Start_Date__c) {
            trip.addError('La date de fin doit être postérieure à la date de début.');
        }
    }

        public static Trip__c createTrip(Trip__c newTrip) {
        if (!Schema.sObjectType.Trip__c.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de créer un voyage.');
        }
        System.debug('TripService : creation d\'un voyage : ' + newTrip.Name);
        insert newTrip;
        return newTrip;
    }

    public static void updateTrip(Trip__c tripToUpdate) {
        if (!Schema.sObjectType.Trip__c.isUpdateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de modifier ce voyage.');
        }
        System.debug('TripService : mise à jour du voyage : ' + tripToUpdate.Name);
        update tripToUpdate;
    }

    public static void deleteTrip(Id tripId) {
        if (!Schema.sObjectType.Trip__c.isDeletable()) {
            throw new SecurityException('Vous n\'avez pas le droit de supprimer ce voyage.');
        }
        System.debug('TripService : suppression du voyage : ' + tripId);
        delete new Trip__c(Id = tripId);
    }
}