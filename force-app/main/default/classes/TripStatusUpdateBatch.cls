public with sharing class TripStatusUpdateBatch implements Database.Batchable<SObject> {

    private static final String STATUT_A_VENIR = 'À venir';
    private static final String STATUT_EN_COURS = 'En cours';
    private static final String STATUT_TERMINE = 'Terminé';
    private static final String STATUT_ANNULE = 'Annulé';

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
                SELECT Id, Start_Date__c, End_Date__c, Statut__c
                FROM Trip__c
                WHERE Statut__c != :STATUT_ANNULE
                AND Start_Date__c != null
                AND End_Date__c != null
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Trip__c> scope) {
        Date today = Date.today();
        List<Trip__c> tripsToUpdate = new List<Trip__c>();

        for (Trip__c trip : scope) {
            String newStatus = computeStatus(trip, today);
            if (newStatus != trip.Statut__c) {
                trip.Statut__c = newStatus;
                tripsToUpdate.add(trip);
            }
        }

        if (!tripsToUpdate.isEmpty()) {
            update tripsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch de mise à jour des statuts terminé.');
    }

    private String computeStatus(Trip__c trip, Date today) {
        if (today < trip.Start_Date__c) {
            return STATUT_A_VENIR;
        }
        if (today > trip.End_Date__c) {
            return STATUT_TERMINE;
        }
        return STATUT_EN_COURS;
    }
}