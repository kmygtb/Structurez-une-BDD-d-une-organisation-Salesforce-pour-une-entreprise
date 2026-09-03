public with sharing class TripCancellationBatch implements Database.Batchable<SObject> {

    private static final Integer DAYS_BEFORE_START = 7;
    private static final Integer MIN_PARTICIPANTS = 10;
    private static final String STATUT_ANNULE = 'Annulé';

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date targetStartDate = Date.today().addDays(DAYS_BEFORE_START);

        return Database.getQueryLocator([
                SELECT Id, Number_of_Participants__c, Statut__c
                FROM Trip__c
                WHERE Start_Date__c = :targetStartDate
                AND Number_of_Participants__c != null
                AND Number_of_Participants__c < :MIN_PARTICIPANTS
                AND Statut__c != :STATUT_ANNULE
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Trip__c> scope) {
        for (Trip__c trip : scope) {
            trip.Statut__c = STATUT_ANNULE;
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch d\'annulation des voyages terminé.');
    }
}