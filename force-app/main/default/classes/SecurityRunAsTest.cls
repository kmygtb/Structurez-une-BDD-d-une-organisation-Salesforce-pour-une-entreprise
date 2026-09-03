@isTest
private class SecurityRunAsTest {

    @isTest
    static void testCreateAccount_BlockedForUserWithoutCreatePermission() {
        User restrictedUser = [
                SELECT Id
                FROM User
                WHERE Profile.Name = 'Commercial Restreint'
                LIMIT 1
        ];

        Boolean exceptionThrown = false;

        System.runAs(restrictedUser) {
            try {
                Account testAccount = new Account(Name = 'Compte Non Autorise');
                AccountService.createAccount(testAccount);
            } catch (SecurityException e) {
                exceptionThrown = true;
            }
        }

        System.assert(exceptionThrown, 'Une SecurityException doit être levée pour un utilisateur sans droit de création');
    }

    @isTest
    static void testCreateAccount_SucceedsForAdminUser() {
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            Account testAccount = new Account(Name = 'Compte Autorise Admin');
            AccountService.createAccount(testAccount);
        } catch (SecurityException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(!exceptionThrown, 'Un administrateur doit pouvoir créer un compte sans erreur');
    }
}