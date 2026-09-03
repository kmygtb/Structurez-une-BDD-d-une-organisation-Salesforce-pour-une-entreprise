@isTest
private class TripTriggerTest {

    @isTest
    static void testInsert_BlocksWhenEndDateBeforeStartDate() {
        Account acc = TestDataFactory.createAccount('Compte Trigger Dates');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Prospecting', 0, 'Athenes',
                Date.today().addDays(10), Date.today().addDays(5), 5
        );

        Trip__c trip = new Trip__c(
                Statut__c = 'À venir',
                Destination__c = 'Athenes',
                Start_Date__c = Date.today().addDays(10),
                End_Date__c = Date.today().addDays(5),
                Account__c = acc.Id,
                Opportunity__c = opp.Id
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
        Account acc = TestDataFactory.createAccount('Compte Trigger Dates 2');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Prospecting', 0, 'Athenes',
                Date.today(), Date.today().addDays(7), 5
        );

        Trip__c trip = new Trip__c(
                Statut__c = 'À venir',
                Destination__c = 'Athenes',
                Start_Date__c = Date.today(),
                End_Date__c = Date.today().addDays(7),
                Account__c = acc.Id,
                Opportunity__c = opp.Id
        );

        Test.startTest();
        insert trip;
        Test.stopTest();

        Trip__c insertedTrip = [SELECT Id FROM Trip__c WHERE Id = :trip.Id];
        System.assertNotEquals(null, insertedTrip.Id, 'Le Trip doit être correctement inséré');
    }

    @isTest
    static void testUpdate_BlocksWhenEndDateChangedToBeforeStartDate() {
        Account acc = TestDataFactory.createAccount('Compte Trigger Dates 3');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Prospecting', 0, 'Athenes',
                Date.today(), Date.today().addDays(7), 5
        );

        Trip__c trip = new Trip__c(
                Statut__c = 'À venir',
                Destination__c = 'Athenes',
                Start_Date__c = Date.today(),
                End_Date__c = Date.today().addDays(7),
                Account__c = acc.Id,
                Opportunity__c = opp.Id
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