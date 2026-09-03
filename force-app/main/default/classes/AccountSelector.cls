public with sharing class AccountSelector {

    public static Account getById(Id accountId) {
        List<Account> results = [
                SELECT Id, Name, Phone, Industry, Website,
                        BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
                FROM Account
                WHERE Id = :accountId
                WITH SECURITY_ENFORCED
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static List<Account> getAll() {
        return [
                SELECT Id, Name, Phone, Industry, Website, BillingCity, BillingCountry
                FROM Account
                WITH SECURITY_ENFORCED
                ORDER BY Name ASC
                LIMIT 200
        ];
    }

    public static List<Account> searchByName(String searchTerm) {
        String likePattern = '%' + searchTerm + '%';
        return [
                SELECT Id, Name, Phone, Industry
                FROM Account
                WHERE Name LIKE :likePattern
                WITH SECURITY_ENFORCED
                ORDER BY Name ASC
                LIMIT 50
        ];
    }
}