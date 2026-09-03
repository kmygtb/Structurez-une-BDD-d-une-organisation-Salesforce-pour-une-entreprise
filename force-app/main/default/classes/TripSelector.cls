public with sharing class TripSelector {

    public static Trip__c getById(Id tripId) {
        List<Trip__c> results = [
                SELECT Id, Statut__c, Destination__c, Start_Date__c, End_Date__c,
                        Number_of_Participants__c, Total_Cost__c, Account__c, Opportunity__c
                FROM Trip__c
                WHERE Id = :tripId
                WITH SECURITY_ENFORCED
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static List<Trip__c> getByAccountId(Id accountId) {
        return [
                SELECT Id, Statut__c, Destination__c, Start_Date__c, End_Date__c, Total_Cost__c
                FROM Trip__c
                WHERE Account__c = :accountId
                WITH SECURITY_ENFORCED
                ORDER BY Start_Date__c DESC
                LIMIT 100
        ];
    }

    public static List<Trip__c> getByStatus(String statut) {
        return [
                SELECT Id, Statut__c, Destination__c, Start_Date__c, End_Date__c, Account__c
                FROM Trip__c
                WHERE Statut__c = :statut
                WITH SECURITY_ENFORCED
                ORDER BY Start_Date__c ASC
                LIMIT 200
        ];
    }
}