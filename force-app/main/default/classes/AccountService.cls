public with sharing class AccountService {

    public static Account createAccount(Account newAccount) {
        if (!Schema.sObjectType.Account.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de créer un compte.');
        }
        insert newAccount;
        return newAccount;
    }

    public static void updateAccount(Account accountToUpdate) {
        if (!Schema.sObjectType.Account.isUpdateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de modifier ce compte.');
        }
        update accountToUpdate;
    }

    public static void deleteAccount(Id accountId) {
        if (!Schema.sObjectType.Account.isDeletable()) {
            throw new SecurityException('Vous n\'avez pas le droit de supprimer ce compte.');
        }
        delete new Account(Id = accountId);
    }
}