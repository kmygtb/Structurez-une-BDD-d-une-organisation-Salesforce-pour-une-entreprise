@isTest
private class TripTriggerTest {

    @isTest
    static void testInsert_BlocksWhenEndDateBeforeStartDate() {
        Trip__c trip = new Trip__c(
                Statut__c = 'À venir',
                Destination__c = 'Athenes',
                Start_Date__c = Date.today().addDays(10),
                End_Date__c = Date.today().addDays(5)
        );

        Test.startTest();
        try {
            insert trip;
            System.assert(false, 'L\'insertion aurait dû échouer');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('date de fin'), 'Le message d\'erreur doit mentionner la date de fin');
        }
        Test.stopTest();
    }

    @isTest
    static void testInsert_SucceedsWhenDatesAreCoherent() {
        Trip__c trip = new Trip__c(
                Statut__c = 'À venir',
                Destination__c = 'Athenes',
                Start_Date__c = Date.today(),
                End_Date__c = Date.today().addDays(7)
        );

        Test.startTest();
        insert trip;
        Test.stopTest();

        Trip__c insertedTrip = [SELECT Id FROM Trip__c WHERE Id = :trip.Id];
        System.assertNotEquals(null, insertedTrip.Id, 'Le Trip doit être correctement inséré');
    }

    @isTest
    static void testUpdate_BlocksWhenEndDateChangedToBeforeStartDate() {
        Trip__c trip = new Trip__c(
                Statut__c = 'À venir',
                Destination__c = 'Athenes',
                Start_Date__c = Date.today(),
                End_Date__c = Date.today().addDays(7)
        );
        insert trip;

        trip.End_Date__c = Date.today().addDays(-1);

        Test.startTest();
        try {
            update trip;
            System.assert(false, 'La mise à jour aurait dû échouer');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('date de fin'), 'Le message d\'erreur doit mentionner la date de fin');
        }
        Test.stopTest();
    }
}