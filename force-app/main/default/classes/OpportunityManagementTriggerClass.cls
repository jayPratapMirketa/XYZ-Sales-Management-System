public class OpportunityManagementTriggerClass {

    public static void OpportunityHandler(List<Opportunity> newOpportunities) {

        //Mapping AccountIDs and the count of open Opportunities in each  Account
        Map<Id, Integer> accountOpportunityMap = new Map<Id, Integer>();

        //Map to get Name of Account By using Id
        Map<Id,Account> accountNameMap =  new Map<Id,Account>([Select Id,Name from Account]);

        /* Considering the fact that the user is trying to insert  multiple opportunities in multiple accounts at once  And the list of open staged opportunities are more than one*/                                                        
        for(Opportunity opp : newOpportunities) {
            if(opp.IsWon == false && opp.IsClosed == false) {
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
        for(Id accountId : accountOpportunityMap.keySet()) {
            //Getting all existing opportunity for each Account  
            List<Opportunity> oldOpportunities = [SELECT Id, IsWon, IsClosed FROM Opportunity WHERE AccountId = :accountId AND IsWon = false AND IsClosed = false];
            //If One open stage opportunity already exist in the Account
            if(oldOpportunities.size() >= 1) {
                for(Opportunity opp : newOpportunities) {
                    if(opp.AccountId == accountId && opp.IsWon == false && opp.IsClosed == false) {
                        opp.addError('There can only be one open Opportunity for Account ' + accountNameMap.get(opp.AccountId).Name);
                    }
                }
            }
        }
    }
}