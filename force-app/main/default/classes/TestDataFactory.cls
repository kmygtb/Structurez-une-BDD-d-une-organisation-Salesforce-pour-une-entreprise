@isTest
public class TestDataFactory {

    public static Account createAccount(String accountName) {
        Account acc = new Account(Name = accountName);
        insert acc;
        return acc;
    }

    public static Opportunity createOpportunity(Id accountId, String stageName, Decimal amount,
            String destination, Date startDate, Date endDate, Integer participants) {
        Opportunity opp = new Opportunity(
                Name = 'Opportunite Test',
                AccountId = accountId,
                StageName = stageName,
                CloseDate = Date.today().addDays(30),
                Amount = amount,
                Destination__c = destination,
                Start_Date__c = startDate,
                End_Date__c = endDate,
                Number_of_Participants__c = participants
        );
        insert opp;
        return opp;
    }

    public static Trip__c createTrip(Id accountId, Id opportunityId, String statut,
            Date startDate, Date endDate, Integer participants) {
        Trip__c trip = new Trip__c(
                Statut__c = statut,
                Destination__c = 'Destination Test',
                Start_Date__c = startDate,
                End_Date__c = endDate,
                Number_of_Participants__c = participants,
                Account__c = accountId,
                Opportunity__c = opportunityId
        );
        insert trip;
        return trip;
    }
}