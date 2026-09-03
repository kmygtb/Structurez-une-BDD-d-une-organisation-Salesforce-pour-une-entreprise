@isTest
private class TripStatusUpdateBatchTest {

    @isTest
    static void testBatch_SetsStatusToTermine_WhenEndDateIsInThePast() {
        Trip__c tripPast = TestDataFactory.createTrip(
                null, null, 'À venir',
                Date.today().addDays(-10), Date.today().addDays(-3), 8
        );

        Test.startTest();
        Database.executeBatch(new TripStatusUpdateBatch());
        Test.stopTest();

        Trip__c updatedTrip = [SELECT Statut__c FROM Trip__c WHERE Id = :tripPast.Id];
        System.assertEquals('Terminé', updatedTrip.Statut__c, 'Un voyage dont la date de fin est passée doit être Terminé');
    }

    @isTest
    static void testBatch_SetsStatusToEnCours_WhenTodayIsBetweenDates() {
        Trip__c tripOngoing = TestDataFactory.createTrip(
                null, null, 'À venir',
                Date.today().addDays(-1), Date.today().addDays(5), 8
        );

        Test.startTest();
        Database.executeBatch(new TripStatusUpdateBatch());
        Test.stopTest();

        Trip__c updatedTrip = [SELECT Statut__c FROM Trip__c WHERE Id = :tripOngoing.Id];
        System.assertEquals('En cours', updatedTrip.Statut__c, 'Un voyage en cours entre ses deux dates doit être En cours');
    }

    @isTest
    static void testBatch_SetsStatusToAVenir_WhenStartDateIsInTheFuture() {
        Trip__c tripFuture = TestDataFactory.createTrip(
                null, null, 'En cours',
                Date.today().addDays(10), Date.today().addDays(15), 8
        );

        Test.startTest();
        Database.executeBatch(new TripStatusUpdateBatch());
        Test.stopTest();

        Trip__c updatedTrip = [SELECT Statut__c FROM Trip__c WHERE Id = :tripFuture.Id];
        System.assertEquals('À venir', updatedTrip.Statut__c, 'Un voyage qui n\'a pas encore commencé doit être À venir');
    }

    @isTest
    static void testBatch_DoesNotChangeAlreadyCancelledTrip() {
        Trip__c tripCancelled = TestDataFactory.createTrip(
                null, null, 'Annulé',
                Date.today().addDays(-1), Date.today().addDays(5), 3
        );

        Test.startTest();
        Database.executeBatch(new TripStatusUpdateBatch());
        Test.stopTest();

        Trip__c updatedTrip = [SELECT Statut__c FROM Trip__c WHERE Id = :tripCancelled.Id];
        System.assertEquals('Annulé', updatedTrip.Statut__c, 'Un voyage Annulé ne doit jamais être recalculé');
    }

    @isTest
    static void testBatch_DoesNotUpdateTripWhenStatusAlreadyCorrect() {
        Trip__c tripAlreadyCorrect = TestDataFactory.createTrip(
                null, null, 'En cours',
                Date.today().addDays(-1), Date.today().addDays(5), 8
        );

        Test.startTest();
        Database.executeBatch(new TripStatusUpdateBatch());
        Test.stopTest();

        Trip__c updatedTrip = [SELECT Statut__c, LastModifiedDate FROM Trip__c WHERE Id = :tripAlreadyCorrect.Id];
        System.assertEquals('En cours', updatedTrip.Statut__c, 'Le statut doit rester En cours, il était déjà correct');
    }
}