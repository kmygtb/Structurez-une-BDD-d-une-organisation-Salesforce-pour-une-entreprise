public with sharing class ContractSelector {

    public static Contract getById(Id contractId) {
        List<Contract> results = [
                SELECT Id, AccountId, Status, StartDate, EndDate, ContractTerm
                FROM Contract
                WHERE Id = :contractId
                WITH SECURITY_ENFORCED
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static List<Contract> getByAccountId(Id accountId) {
        return [
                SELECT Id, Status, StartDate, EndDate, ContractTerm
                FROM Contract
                WHERE AccountId = :accountId
                WITH SECURITY_ENFORCED
                ORDER BY StartDate DESC
                LIMIT 100
        ];
    }

    public static List<Contract> getExpiringSoon(Integer daysAhead) {
        Date targetDate = Date.today().addDays(daysAhead);
        return [
                SELECT Id, AccountId, Status, EndDate
                FROM Contract
                WHERE EndDate <= :targetDate
                AND Status = 'Activated'
                WITH SECURITY_ENFORCED
                ORDER BY EndDate ASC
                LIMIT 200
        ];
    }
}