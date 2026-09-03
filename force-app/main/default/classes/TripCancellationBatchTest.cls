@isTest
private class TripCancellationBatchTest {

    @isTest
    static void testBatch_CancelsTripWithFewParticipantsAtSevenDays() {
        Trip__c tripToCancel = TestDataFactory.createTrip(
                null, null, 'À venir',
                Date.today().addDays(7), Date.today().addDays(14), 5
        );

        Test.startTest();
        Database.executeBatch(new TripCancellationBatch());
        Test.stopTest();

        Trip__c updatedTrip = [SELECT Statut__c FROM Trip__c WHERE Id = :tripToCancel.Id];
        System.assertEquals('Annulé', updatedTrip.Statut__c, 'Le voyage doit être annulé');
    }

    @isTest
    static void testBatch_DoesNotCancelTripWithEnoughParticipants() {
        Trip__c tripOk = TestDataFactory.createTrip(
                null, null, 'À venir',
                Date.today().addDays(7), Date.today().addDays(14), 15
        );

        Test.startTest();
        Database.executeBatch(new TripCancellationBatch());
        Test.stopTest();

        Trip__c updatedTrip = [SELECT Statut__c FROM Trip__c WHERE Id = :tripOk.Id];
        System.assertEquals('À venir', updatedTrip.Statut__c, 'Le voyage ne doit pas être annulé, il a assez de participants');
    }

    @isTest
    static void testBatch_DoesNotCancelTripNotAtSevenDays() {
        Trip__c tripFarAway = TestDataFactory.createTrip(
                null, null, 'À venir',
                Date.today().addDays(20), Date.today().addDays(27), 3
        );

        Test.startTest();
        Database.executeBatch(new TripCancellationBatch());
        Test.stopTest();

        Trip__c updatedTrip = [SELECT Statut__c FROM Trip__c WHERE Id = :tripFarAway.Id];
        System.assertEquals('À venir', updatedTrip.Statut__c, 'Le voyage ne doit pas être annulé, il ne part pas dans 7 jours');
    }

    @isTest
    static void testBatch_DoesNotCancelAlreadyCancelledTrip() {
        Trip__c tripAlreadyCancelled = TestDataFactory.createTrip(
                null, null, 'Annulé',
                Date.today().addDays(7), Date.today().addDays(14), 2
        );

        Test.startTest();
        Database.executeBatch(new TripCancellationBatch());
        Test.stopTest();

        Trip__c updatedTrip = [SELECT Statut__c FROM Trip__c WHERE Id = :tripAlreadyCancelled.Id];
        System.assertEquals('Annulé', updatedTrip.Statut__c, 'Le statut ne doit pas changer, il était déjà Annulé');
    }
}