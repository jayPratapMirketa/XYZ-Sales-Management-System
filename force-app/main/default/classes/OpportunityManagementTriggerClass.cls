public class OpportunityManagementTriggerClass {

    public static void OpportunityHandler(List<Opportunity> newOpportunities) {

        //Mapping AccountIDs and the count of open Opportunities in each  Account
        Map<Id, Integer> accountOpportunityMap = new Map<Id, Integer>();

        //Map to get Name of Account By using Id
        Map<Id,Account> accountNameMap =  new Map<Id,Account>([Select Id,Name from Account]);

        /* Considering the fact that the user is trying to insert  multiple opportunities in multiple accounts at once  And the list of open staged opportunities are more than one*/                                                        
        for(Opportunity opp : newOpportunities) {
            if(opp.IsClosed == false) {
                Id accountId = opp.AccountId;
                if(accountOpportunityMap.containsKey(accountId)) {
                    //Founded that the user is trying to insert more than one open opportunity for the particular account.
                    opp.addError('You are inserting more than 1 open Opportunity for Account ' + accountNameMap.get(opp.AccountId).Name);
                } else {
                    accountOpportunityMap.put(accountId, 1);
                }
            }
            
        }

    
        /* ---------------Considering the fact that there can be already existing open opportunities-----------------------*/

        List<Opportunity> oldOpportunities = [SELECT Id, IsClosed,AccountId FROM Opportunity WHERE AccountId = :accountOpportunityMap.keySet() AND IsClosed = false];

        Map<Id, List<Opportunity>> oldOpportunityMap = new Map<Id, List<Opportunity>>();

        // Filling in the oldOpportunity Map
        for (Opportunity opp : oldOpportunities) {
            Id accId = opp.AccountId;
            if (oldOpportunityMap.containsKey(accId)) {
                oldOpportunityMap.get(accId).add(opp);
            } else {
                oldOpportunityMap.put(accId, new List<Opportunity>{opp});
            }
        }

        if(oldOpportunities.size() >= 1) {
            for(Opportunity opp : newOpportunities) {
                if(oldOpportunityMap.containsKey(opp.AccountId) && opp.IsClosed == false && oldOpportunities.get(0).Id != opp.Id) {
                    opp.addError('There can only be one open Opportunity for Account ' + accountNameMap.get(opp.AccountId).Name);
                }
            }
        }
    }
}