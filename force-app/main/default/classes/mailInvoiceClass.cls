public class mailInvoiceClass{
   public static void sendConfirmationMail2(List<Invoice__c> newRecordList){
  	   set<Id>opportunityIdset = new set<Id>();
       set<Id>accountIdset = new set<Id>();
       for(Invoice__c cinvoiceob:newRecordList){
           opportunityIdset.add(cinvoiceob.Opportunity__c);
           accountIdset.add(cinvoiceob.Account__c);
       }
       List<OpportunityLineItem> productList=[SELECT Name, Quantity, UnitPrice, TotalPrice FROM OpportunityLineItem WHERE opportunityId in:opportunityIdset];
       Map<Id,Account> accemailMap=new Map<Id,Account>([Select Id, Primary_contact__r.Email,Primary_contact__r.Name FROM Account WHERE Id in :accountIdset]);
       List<Messaging.SingleEmailMessage> mails=new List<Messaging.SingleEmailMessage>();
       for(Invoice__c cinvoiceob:newRecordList){
           Account acc= accemailMap.get(cinvoiceob.Account__c);
           Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();        
           mail.setToAddresses(new String[]{acc.Primary_contact__r.Email});
           System.debug('Email of Recipient='+ acc.Primary_contact__r.Email);
  		   String subject = 'Invoice for Products purchased.';
           mail.setSubject(subject);
           String body='Hey '+acc.Primary_contact__r.Name+',';
           body+='<br>Here is the list of items purchased by your company.';
           body += '<br><br><table style="border: solid #000000 width: 80%;"><thead><tr><th>Product Name</th><th>Quantity</th><th>Unit Price</th><th>Total Amount</th></tr></thead><tbody>';
           for(OpportunityLineItem opp:productList){
               body += '<tr><td style= "border: 2px solid #000000; padding: 5px">'+opp.Name+'</td><td style="border: 2px solid #000000; padding: 5px">'+opp.Quantity +'</td><td style="border: 2px solid #000000; padding: 5px">'+opp.UnitPrice+'</td><td style="border: 2px solid #000000; padding: 5px">'+opp.TotalPrice+ '</td></tr>';
           } 
           body += '</tbody></table>';
           body += '<br><br>Thank you for the purchase.';           
           mail.setHtmlBody(body);
           mails.add(mail);
       }
        Messaging.sendEmail(mails);
   }
}