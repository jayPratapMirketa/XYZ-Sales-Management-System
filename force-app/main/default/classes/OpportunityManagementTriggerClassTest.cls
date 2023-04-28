
@istest
private class OpportunityManagementTriggerClassTest {

    @isTest
    private static void opportunityTriggerTest() {
        Account acc = new Account(Name = 'Harshit Kumar');
        insert acc;

        Opportunity opportunity1 = new Opportunity(
            Name = 'opp1',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = date.today() + 5
        );

        Opportunity opportunity2 = new Opportunity(
            Name = 'opp2',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = date.today() + 5
        );

        Opportunity opportunity3 = new Opportunity(
            Name = 'opp3',
            AccountId = acc.Id,
            StageName = 'Closed Won',
            CloseDate = date.today() + 5
        );

        Opportunity opportunity4 = new Opportunity(
            Name = 'opp4',
            AccountId = acc.Id,
            StageName = 'Closed Lost',
            CloseDate = date.today() + 5
        );


        List<Opportunity> allOpportunities = new List<Opportunity>();

        allOpportunities.add(opportunity1);
        allOpportunities.add(opportunity2);

        try {
            insert allOpportunities;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('You are inserting more than 1 open Opportunity for Account'));
        }

        List<Opportunity> opportunityList = [SELECT Id, Name FROM Opportunity];

        System.assertEquals(0, opportunityList.size());

        try {
            insert opportunity1;
        } catch (Exception e) {
            //System.debug(e.getMessage());
        }


        opportunityList = [SELECT Id FROM Opportunity];

        System.assertEquals(1, opportunityList.size());

        try {
            insert opportunity3;
        } catch (Exception e) {
            //System.debug(e.getMessage());
        }
        
        opportunityList = [SELECT Id FROM Opportunity];

        System.assertEquals(2, opportunityList.size());


        try {
            insert opportunity2;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('There can only be one open Opportunity for Account'));
        }
        
        opportunityList = [SELECT Id FROM Opportunity];

        System.assertEquals(2, opportunityList.size());




        try {
            insert opportunity4;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
        opportunityList = [SELECT Id FROM Opportunity];

        System.assertEquals(3, opportunityList.size());


        Opportunity insertedClosedOpportunity = [SELECT Id,StageName FROM Opportunity WHERE Name = 'opp3'];
        insertedClosedOpportunity.StageName = 'Prospecting';

        try {
            update insertedClosedOpportunity;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('There can only be one open Opportunity for Account'));
        }

        opportunityList = [SELECT Id FROM Opportunity WHERE StageName = 'Prospecting'];
        System.assertEquals(1, opportunityList.size());

}

}

