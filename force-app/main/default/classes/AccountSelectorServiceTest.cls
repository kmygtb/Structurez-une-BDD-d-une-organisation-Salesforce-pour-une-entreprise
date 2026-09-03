@isTest
private class AccountSelectorServiceTest {

    @isTest
    static void testGetById_ReturnsCorrectAccount() {
        Account acc = TestDataFactory.createAccount('Compte Selector Test');

        Test.startTest();
        Account result = AccountSelector.getById(acc.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Le compte doit être trouvé');
        System.assertEquals('Compte Selector Test', result.Name);
    }

    @isTest
    static void testGetById_ReturnsNullWhenNotFound() {
        Account acc = TestDataFactory.createAccount('Compte a supprimer');
        Id accountId = acc.Id;
        delete acc;

        Test.startTest();
        Account result = AccountSelector.getById(accountId);
        Test.stopTest();

        System.assertEquals(null, result, 'Aucun compte ne doit être retourné pour un Id supprimé');
    }

    @isTest
    static void testGetAll_ReturnsCreatedAccounts() {
        TestDataFactory.createAccount('Compte A');
        TestDataFactory.createAccount('Compte B');

        Test.startTest();
        List<Account> results = AccountSelector.getAll();
        Test.stopTest();

        System.assert(results.size() >= 2, 'Au moins les 2 comptes créés doivent être retournés');
    }

    @isTest
    static void testSearchByName_FindsMatchingAccounts() {
        TestDataFactory.createAccount('Voyages Bali Excellence');
        TestDataFactory.createAccount('Club Rome Aventure');

        Test.startTest();
        List<Account> results = AccountSelector.searchByName('Bali');
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Un seul compte doit correspondre au terme "Bali"');
        System.assertEquals('Voyages Bali Excellence', results[0].Name);
    }

    @isTest
    static void testCreateAccount_InsertsSuccessfully() {
        Account newAccount = new Account(Name = 'Nouveau Compte Service');

        Test.startTest();
        Account created = AccountService.createAccount(newAccount);
        Test.stopTest();

        System.assertNotEquals(null, created.Id, 'Le compte doit avoir un Id après création');

        Account fromDb = [SELECT Name FROM Account WHERE Id = :created.Id];
        System.assertEquals('Nouveau Compte Service', fromDb.Name);
    }

    @isTest
    static void testUpdateAccount_ModifiesSuccessfully() {
        Account acc = TestDataFactory.createAccount('Nom Original');
        acc.Name = 'Nom Modifie';

        Test.startTest();
        AccountService.updateAccount(acc);
        Test.stopTest();

        Account fromDb = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Nom Modifie', fromDb.Name);
    }

    @isTest
    static void testDeleteAccount_RemovesSuccessfully() {
        Account acc = TestDataFactory.createAccount('Compte a effacer');

        Test.startTest();
        AccountService.deleteAccount(acc.Id);
        Test.stopTest();

        List<Account> results = [SELECT Id FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, results.size(), 'Le compte ne doit plus exister après suppression');
    }
}