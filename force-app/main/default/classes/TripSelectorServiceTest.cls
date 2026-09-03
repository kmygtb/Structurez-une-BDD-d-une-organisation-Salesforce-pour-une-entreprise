@isTest
private class TripSelectorServiceTest {

    @isTest
    static void testGetById_ReturnsCorrectTrip() {
        Trip__c trip = TestDataFactory.createTrip(
                null, null, 'À venir',
                Date.today().addDays(20), Date.today().addDays(27), 10
        );

        Test.startTest();
        Trip__c result = TripSelector.getById(trip.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Le voyage doit être trouvé');
        System.assertEquals('À venir', result.Statut__c);
    }

    @isTest
    static void testGetByAccountId_ReturnsOnlyMatchingTrips() {
        Account acc1 = TestDataFactory.createAccount('Compte Trip A');
        Account acc2 = TestDataFactory.createAccount('Compte Trip B');
        TestDataFactory.createTrip(acc1.Id, null, 'À venir', Date.today().addDays(10), Date.today().addDays(15), 8);
        TestDataFactory.createTrip(acc1.Id, null, 'À venir', Date.today().addDays(10), Date.today().addDays(15), 8);
        TestDataFactory.createTrip(acc2.Id, null, 'À venir', Date.today().addDays(10), Date.today().addDays(15), 8);

        Test.startTest();
        List<Trip__c> results = TripSelector.getByAccountId(acc1.Id);
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Seuls les 2 voyages du compte acc1 doivent être retournés');
    }

    @isTest
    static void testGetByStatus_ReturnsOnlyMatchingStatus() {
        TestDataFactory.createTrip(null, null, 'À venir', Date.today().addDays(10), Date.today().addDays(15), 8);
        TestDataFactory.createTrip(null, null, 'Annulé', Date.today().addDays(10), Date.today().addDays(15), 3);

        Test.startTest();
        List<Trip__c> results = TripSelector.getByStatus('Annulé');
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Un seul voyage Annulé doit être retourné');
    }

    @isTest
static void testCreateTrip_InsertsSuccessfully() {
    Account acc = TestDataFactory.createAccount('Compte Create Trip Test');
    Opportunity opp = TestDataFactory.createOpportunity(
            acc.Id, 'Prospecting', 0, 'Nouvelle Destination',
            Date.today().addDays(30), Date.today().addDays(37), 6
    );

    Trip__c newTrip = new Trip__c(
            Statut__c = 'À venir',
            Destination__c = 'Nouvelle Destination',
            Start_Date__c = Date.today().addDays(30),
            End_Date__c = Date.today().addDays(37),
            Number_of_Participants__c = 6,
            Account__c = acc.Id,
            Opportunity__c = opp.Id
    );

    Test.startTest();
    Trip__c created = TripService.createTrip(newTrip);
    Test.stopTest();

    System.assertNotEquals(null, created.Id, 'Le voyage doit avoir un Id après création');
}

    @isTest
    static void testUpdateTrip_ModifiesSuccessfully() {
        Trip__c trip = TestDataFactory.createTrip(
                null, null, 'À venir',
                Date.today().addDays(10), Date.today().addDays(15), 8
        );
        trip.Number_of_Participants__c = 20;

        Test.startTest();
        TripService.updateTrip(trip);
        Test.stopTest();

        Trip__c fromDb = [SELECT Number_of_Participants__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(20, fromDb.Number_of_Participants__c);
    }

    @isTest
    static void testDeleteTrip_RemovesSuccessfully() {
        Trip__c trip = TestDataFactory.createTrip(
                null, null, 'À venir',
                Date.today().addDays(10), Date.today().addDays(15), 8
        );

        Test.startTest();
        TripService.deleteTrip(trip.Id);
        Test.stopTest();

        List<Trip__c> results = [SELECT Id FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(0, results.size(), 'Le voyage ne doit plus exister après suppression');
    }
}