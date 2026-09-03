@isTest
private class TripServiceTest {

    @isTest
    static void testCreateTripsForWonOpportunities_CreatesTripWithCorrectMapping() {
        Account acc = TestDataFactory.createAccount('Compte Test');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Closed Won', 5000, 'Bali',
                Date.today().addDays(30), Date.today().addDays(37), 12
        );

        Test.startTest();
        TripService.createTripsForWonOpportunities(new List<Opportunity>{ opp });
        Test.stopTest();

        List<Trip__c> trips = [
                SELECT Statut__c, Destination__c, Start_Date__c, End_Date__c,
                        Number_of_Participants__c, Account__c, Opportunity__c
                FROM Trip__c
                WHERE Opportunity__c = :opp.Id
        ];

        System.assertEquals(1, trips.size(), 'Un seul Trip doit être créé');
        System.assertEquals('À venir', trips[0].Statut__c);
        System.assertEquals('Bali', trips[0].Destination__c);
        System.assertEquals(12, trips[0].Number_of_Participants__c);
        System.assertEquals(acc.Id, trips[0].Account__c);
        System.assertEquals(opp.Id, trips[0].Opportunity__c);
    }

    @isTest
    static void testCreateTripsForWonOpportunities_EmptyList_DoesNothing() {
        Test.startTest();
        TripService.createTripsForWonOpportunities(new List<Opportunity>());
        Test.stopTest();

        Integer tripCount = [SELECT COUNT() FROM Trip__c];
        System.assertEquals(0, tripCount, 'Aucun Trip ne doit être créé avec une liste vide');
    }

    @isTest
    static void testValidateDates_BlocksWhenEndBeforeStart() {
        Trip__c trip = new Trip__c(
                Start_Date__c = Date.today().addDays(10),
                End_Date__c = Date.today().addDays(5)
        );

        Test.startTest();
        TripService.validateDates(trip);
        Test.stopTest();

        System.assert(trip.hasErrors(), 'Une erreur doit être ajoutée quand la date de fin précède la date de début');
    }

    @isTest
    static void testValidateDates_PassesWhenEndAfterStart() {
        Trip__c trip = new Trip__c(
                Start_Date__c = Date.today(),
                End_Date__c = Date.today().addDays(10)
        );

        Test.startTest();
        TripService.validateDates(trip);
        Test.stopTest();

        System.assert(!trip.hasErrors(), 'Aucune erreur ne doit être ajoutée quand les dates sont cohérentes');
    }

    @isTest
    static void testValidateDates_PassesWhenDatesAreNull() {
        Trip__c trip = new Trip__c();

        Test.startTest();
        TripService.validateDates(trip);
        Test.stopTest();

        System.assert(!trip.hasErrors(), 'Aucune erreur ne doit être ajoutée quand les dates sont vides');
    }
}