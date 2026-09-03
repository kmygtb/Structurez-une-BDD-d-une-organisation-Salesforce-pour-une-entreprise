trigger OpportunityTrigger on Opportunity (after update) {

    private static final String STAGE_CLOSED_WON = 'Closed Won';

    List<Opportunity> wonOpportunities = new List<Opportunity>();

    for (Opportunity opp : Trigger.new) {
        Opportunity previousOpp = Trigger.oldMap.get(opp.Id);
        Boolean justWon = opp.StageName == STAGE_CLOSED_WON && previousOpp.StageName != STAGE_CLOSED_WON;

        if (justWon) {
            wonOpportunities.add(opp);
        }
    }

    if (!wonOpportunities.isEmpty()) {
        TripService.createTripsForWonOpportunities(wonOpportunities);
    }
}