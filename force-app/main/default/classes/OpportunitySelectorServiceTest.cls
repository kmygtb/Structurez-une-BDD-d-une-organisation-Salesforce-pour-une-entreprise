@isTest
private class OpportunitySelectorServiceTest {

    @isTest
    static void testGetById_ReturnsCorrectOpportunity() {
        Account acc = TestDataFactory.createAccount('Compte Opp Test');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Prospecting', 4000, 'Lisbonne',
                Date.today().addDays(15), Date.today().addDays(20), 6
        );

        Test.startTest();
        Opportunity result = OpportunitySelector.getById(opp.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'L\'opportunité doit être trouvée');
        System.assertEquals('Lisbonne', result.Destination__c);
    }

    @isTest
    static void testGetByAccountId_ReturnsOnlyMatchingOpportunities() {
        Account acc1 = TestDataFactory.createAccount('Compte Opp A');
        Account acc2 = TestDataFactory.createAccount('Compte Opp B');
        TestDataFactory.createOpportunity(acc1.Id, 'Prospecting', 1000, 'Nice', Date.today(), Date.today().addDays(5), 4);
        TestDataFactory.createOpportunity(acc1.Id, 'Prospecting', 2000, 'Nice', Date.today(), Date.today().addDays(5), 4);
        TestDataFactory.createOpportunity(acc2.Id, 'Prospecting', 3000, 'Nice', Date.today(), Date.today().addDays(5), 4);

        Test.startTest();
        List<Opportunity> results = OpportunitySelector.getByAccountId(acc1.Id);
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Seules les 2 opportunités du compte acc1 doivent être retournées');
    }

    @isTest
    static void testGetByStage_ReturnsOnlyMatchingStage() {
        Account acc = TestDataFactory.createAccount('Compte Stage Test');
        TestDataFactory.createOpportunity(acc.Id, 'Prospecting', 1000, 'Madrid', Date.today(), Date.today().addDays(5), 4);
        TestDataFactory.createOpportunity(acc.Id, 'Closed Won', 2000, 'Madrid', Date.today(), Date.today().addDays(5), 4);

        Test.startTest();
        List<Opportunity> results = OpportunitySelector.getByStage('Closed Won');
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Une seule opportunité au stage Closed Won doit être retournée');
    }

    @isTest
    static void testCreateOpportunity_InsertsSuccessfully() {
        Account acc = TestDataFactory.createAccount('Compte Create Opp');
        Opportunity newOpp = new Opportunity(
                Name = 'Nouvelle Opportunite',
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
        );

        Test.startTest();
        Opportunity created = OpportunityService.createOpportunity(newOpp);
        Test.stopTest();

        System.assertNotEquals(null, created.Id, 'L\'opportunité doit avoir un Id après création');
    }

    @isTest
    static void testUpdateOpportunity_ModifiesSuccessfully() {
        Account acc = TestDataFactory.createAccount('Compte Update Opp');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Prospecting', 1000, 'Athenes', Date.today(), Date.today().addDays(5), 4
        );
        opp.Amount = 9999;

        Test.startTest();
        OpportunityService.updateOpportunity(opp);
        Test.stopTest();

        Opportunity fromDb = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(9999, fromDb.Amount);
    }

    @isTest
    static void testDeleteOpportunity_RemovesSuccessfully() {
        Account acc = TestDataFactory.createAccount('Compte Delete Opp');
        Opportunity opp = TestDataFactory.createOpportunity(
                acc.Id, 'Prospecting', 1000, 'Vienne', Date.today(), Date.today().addDays(5), 4
        );

        Test.startTest();
        OpportunityService.deleteOpportunity(opp.Id);
        Test.stopTest();

        List<Opportunity> results = [SELECT Id FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(0, results.size(), 'L\'opportunité ne doit plus exister après suppression');
    }
}