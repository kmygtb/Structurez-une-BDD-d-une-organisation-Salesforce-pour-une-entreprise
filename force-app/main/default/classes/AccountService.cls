public with sharing class AccountService {

    public static Account createAccount(Account newAccount) {
        if (!Schema.sObjectType.Account.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de créer un compte.');
        }
        System.debug('AccountService : creation d\'un compte : ' + newAccount.Name);
        insert newAccount;
        return newAccount;
    }

    public static void updateAccount(Account accountToUpdate) {
        if (!Schema.sObjectType.Account.isUpdateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de modifier ce compte.');
        }
        System.debug('AccountService : mise à jour d\'un compte : ' + accountToUpdate.Name);
        update accountToUpdate;
    }

    public static void deleteAccount(Id accountId) {
        if (!Schema.sObjectType.Account.isDeletable()) {
            throw new SecurityException('Vous n\'avez pas le droit de supprimer ce compte.');
        }
        System.debug('AccountService : suppression d\'un compte : ' + accountId);
        delete new Account(Id = accountId);
    }
}