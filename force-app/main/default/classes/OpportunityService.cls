public with sharing class OpportunityService {

    public static Opportunity createOpportunity(Opportunity newOpportunity) {
        if (!Schema.sObjectType.Opportunity.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de créer une opportunité.');
        }
        insert newOpportunity;
        return newOpportunity;
    }

    public static void updateOpportunity(Opportunity opportunityToUpdate) {
        if (!Schema.sObjectType.Opportunity.isUpdateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de modifier cette opportunité.');
        }
        update opportunityToUpdate;
    }

    public static void deleteOpportunity(Id opportunityId) {
        if (!Schema.sObjectType.Opportunity.isDeletable()) {
            throw new SecurityException('Vous n\'avez pas le droit de supprimer cette opportunité.');
        }
        delete new Opportunity(Id = opportunityId);
    }
}