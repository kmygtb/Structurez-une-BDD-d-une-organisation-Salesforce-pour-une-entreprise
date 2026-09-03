public with sharing class OpportunitySelector {

    public static Opportunity getById(Id opportunityId) {
        List<Opportunity> results = [
                SELECT Id, Name, AccountId, StageName, Amount, CloseDate,
                        Destination__c, Start_Date__c, End_Date__c, Number_of_Participants__c
                FROM Opportunity
                WHERE Id = :opportunityId
                WITH SECURITY_ENFORCED
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static List<Opportunity> getByAccountId(Id accountId) {
        return [
                SELECT Id, Name, StageName, Amount, CloseDate, Destination__c
                FROM Opportunity
                WHERE AccountId = :accountId
                WITH SECURITY_ENFORCED
                ORDER BY CloseDate DESC
                LIMIT 100
        ];
    }

    public static List<Opportunity> getByStage(String stageName) {
        return [
                SELECT Id, Name, AccountId, Amount, CloseDate, Destination__c
                FROM Opportunity
                WHERE StageName = :stageName
                WITH SECURITY_ENFORCED
                ORDER BY CloseDate ASC
                LIMIT 200
        ];
    }
}