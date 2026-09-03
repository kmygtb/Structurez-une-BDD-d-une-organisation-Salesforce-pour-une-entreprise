@isTest
private class ContractSelectorServiceTest {

    @isTest
    static void testGetById_ReturnsCorrectContract() {
        Account acc = TestDataFactory.createAccount('Compte Contract Test');
        Contract ctr = createDraftContract(acc.Id);

        Test.startTest();
        Contract result = ContractSelector.getById(ctr.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Le contrat doit être trouvé');
        System.assertEquals('Draft', result.Status);
    }

    @isTest
    static void testGetByAccountId_ReturnsOnlyMatchingContracts() {
        Account acc1 = TestDataFactory.createAccount('Compte Contract A');
        Account acc2 = TestDataFactory.createAccount('Compte Contract B');
        createDraftContract(acc1.Id);
        createDraftContract(acc1.Id);
        createDraftContract(acc2.Id);

        Test.startTest();
        List<Contract> results = ContractSelector.getByAccountId(acc1.Id);
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Seuls les 2 contrats du compte acc1 doivent être retournés');
    }

        @isTest
    static void testGetExpiringSoon_ReturnsOnlyActivatedContractsWithinRange() {
        Account acc = TestDataFactory.createAccount('Compte Expiring Test');

        Contract soonExpiring = new Contract(
                AccountId = acc.Id,
                StartDate = Date.today(),
                ContractTerm = 1
        );
        insert soonExpiring;
        ContractService.activateContract(soonExpiring.Id);

        Contract farExpiring = new Contract(
                AccountId = acc.Id,
                StartDate = Date.today(),
                ContractTerm = 24
        );
        insert farExpiring;
        ContractService.activateContract(farExpiring.Id);

        Contract stillDraft = new Contract(
                AccountId = acc.Id,
                StartDate = Date.today(),
                ContractTerm = 1
        );
        insert stillDraft;

        Test.startTest();
        List<Contract> results = ContractSelector.getExpiringSoon(60);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Seul le contrat activé expirant dans 60 jours doit être retourné');
        System.assertEquals(soonExpiring.Id, results[0].Id);
    }

    @isTest
    static void testCreateContract_ForcesDraftStatus() {
        Account acc = TestDataFactory.createAccount('Compte Create Contract');
        Contract newContract = new Contract(
                AccountId = acc.Id,
                StartDate = Date.today(),
                ContractTerm = 12
        );

        Test.startTest();
        Contract created = ContractService.createContract(newContract);
        Test.stopTest();

        Contract fromDb = [SELECT Status FROM Contract WHERE Id = :created.Id];
        System.assertEquals('Draft', fromDb.Status, 'Le contrat doit toujours être créé en Draft');
    }

    @isTest
    static void testActivateContract_ChangesStatusToActivated() {
        Account acc = TestDataFactory.createAccount('Compte Activate Contract');
        Contract ctr = createDraftContract(acc.Id);

        Test.startTest();
        ContractService.activateContract(ctr.Id);
        Test.stopTest();

        Contract fromDb = [SELECT Status FROM Contract WHERE Id = :ctr.Id];
        System.assertEquals('Activated', fromDb.Status);
    }

    @isTest
    static void testDeleteContract_RemovesSuccessfully() {
        Account acc = TestDataFactory.createAccount('Compte Delete Contract');
        Contract ctr = createDraftContract(acc.Id);

        Test.startTest();
        ContractService.deleteContract(ctr.Id);
        Test.stopTest();

        List<Contract> results = [SELECT Id FROM Contract WHERE Id = :ctr.Id];
        System.assertEquals(0, results.size(), 'Le contrat ne doit plus exister après suppression');
    }

    private static Contract createDraftContract(Id accountId) {
        Contract ctr = new Contract(
                AccountId = accountId,
                StartDate = Date.today(),
                ContractTerm = 12
        );
        insert ctr;
        return ctr;
    }

        @isTest
    static void testUpdateContract_ModifiesSuccessfully() {
        Account acc = TestDataFactory.createAccount('Compte Update Contract');
        Contract ctr = createDraftContract(acc.Id);
        ctr.ContractTerm = 24;

        Test.startTest();
        ContractService.updateContract(ctr);
        Test.stopTest();

        Contract fromDb = [SELECT ContractTerm FROM Contract WHERE Id = :ctr.Id];
        System.assertEquals(24, fromDb.ContractTerm, 'Le contrat doit être mis à jour');
    }
}