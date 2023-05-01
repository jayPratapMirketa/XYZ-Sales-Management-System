trigger mainInvoiceTrigger on Invoice__c (after insert) {
    try{
        mailInvoiceClass.sendConfirmationMail2(Trigger.new);
    }
    catch(Exception e){
        System.debug(e.getMessage());
    }

}