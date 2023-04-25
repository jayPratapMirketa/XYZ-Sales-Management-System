trigger OpportunityManagementTrigger on Opportunity  (before insert,before update) {
    OpportunityManagementTriggerClass.OpportunityHandler(trigger.new);
}