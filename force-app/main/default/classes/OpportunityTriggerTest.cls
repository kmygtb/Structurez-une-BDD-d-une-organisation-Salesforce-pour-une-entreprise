@isTest
private class OpportunityTriggerTest {

    @isTest
    static void testTrigger_CreatesTrip_WhenOpportunityBecomesClosedWon() {
        Account acc = TestDataFactory.createAccount('Compte Trigger Test');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Prospecting', 3000, 'Rome',
                Date.today().addDays(20), Date.today().addDays(25), 8
        );

        opp.StageName = 'Closed Won';

        Test.startTest();
        update opp;
        Test.stopTest();

        List<Trip__c> trips = [SELECT Id, Statut__c FROM Trip__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(1, trips.size(), 'Un Trip doit être créé automatiquement');
        System.assertEquals('À venir', trips[0].Statut__c);
    }

    @isTest
    static void testTrigger_DoesNotCreateTrip_WhenStageChangesButNotToClosedWon() {
        Account acc = TestDataFactory.createAccount('Compte Trigger Test 2');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Prospecting', 3000, 'Rome',
                Date.today().addDays(20), Date.today().addDays(25), 8
        );

        opp.StageName = 'Qualification';

        Test.startTest();
        update opp;
        Test.stopTest();

        Integer tripCount = [SELECT COUNT() FROM Trip__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(0, tripCount, 'Aucun Trip ne doit être créé si le stage ne devient pas Closed Won');
    }

    @isTest
    static void testTrigger_DoesNotCreateDuplicateTrip_WhenAlreadyClosedWonUpdatedAgain() {
        Account acc = TestDataFactory.createAccount('Compte Trigger Test 3');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Closed Won', 3000, 'Rome',
                Date.today().addDays(20), Date.today().addDays(25), 8
        );

        opp.Amount = 3500;

        Test.startTest();
        update opp;
        Test.stopTest();

        Integer tripCount = [SELECT COUNT() FROM Trip__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(0, tripCount, 'Aucun nouveau Trip ne doit être créé si l\'opportunité était déjà Closed Won');
    }
}