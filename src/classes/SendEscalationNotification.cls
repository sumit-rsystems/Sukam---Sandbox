global class SendEscalationNotification implements Database.Batchable<SObject>{
    
    
    global Database.QueryLocator start(Database.BatchableContext bi){
    
        Escalation_Settings__c record = Util.escSettings();
        DateTime days48strt = System.now().addDays(-Integer.valueOf(record.Escalation_Age_Over_1__c + 2));
        DateTime days48end = System.now().addDays(-Integer.valueOf(record.Escalation_Age_Over_1__c - 2));
        DateTime days72strt = System.now().addDays(-Integer.valueOf(record.Escalation_Age_Over_2__c + 2));
        DateTime days72end = System.now().addDays(-Integer.valueOf(record.Escalation_Age_Over_2__c - 2));
        
        return Database.getQueryLocator([Select Owner.Email, OwnerId, CreatedDate, Status__c 
                                            from Service_Request__c where
                                            ((CreatedDate >= :days48strt and CreatedDate <= :days48end) or
                                            (CreatedDate >= :days72strt and CreatedDate <= :days72end)) and
                                            (Status__c != 'Closed' or Status__c != 'REJECT')]);
    }
   
   /*
    *  execute the bach process 
    */
    global void execute(Database.BatchableContext bi, List<sObject> scope){
        Escalation_Settings__c record = Util.escSettings();
        Set<String> toAddresses = new Set<String>();
        Set<String> ccAddresses = new Set<String>();
        Id targetObjId;
        List<Service_Request__c> caseList = (List<sObject>)scope;
        
        List<Service_Request__c> caseListToUpdate = new List<Service_Request__c>();
        
        for(Service_Request__c c :caseList) {
            Date startDate = Date.valueOf(c.CreatedDate);
            if(startDate.daysBetween(System.today()) == record.Escalation_Age_Over_1__c 
                    || startDate.daysBetween(System.today()) == record.Escalation_Age_Over_2__c) {
                toAddresses.add(c.Owner.Email);
                targetObjId = c.OwnerId;
                
                if(startDate.daysBetween(System.today()) == record.Escalation_Age_Over_1__c )
                    ccAddresses.add(record.Additional_Emails_1__c);
                if(startDate.daysBetween(System.today()) == record.Escalation_Age_Over_2__c )
                    ccAddresses.add(record.Additional_Emails_2__c);
                    
                 if(toAddresses != null && toAddresses.size() > 0) {
                    List<String> toAddr = new List<String>();
                    toAddr.addAll(toAddresses);
                    List<String> ccAddr = new List<String>();
                    ccAddr.addAll(ccAddresses);
                    Util.sendNotification(toAddr, ccAddr, targetObjId);
                    c.Status__c = 'Escalated';
                    caseListToUpdate.add(c);
                }
            }
        }
        
        try {
            if(caseListToUpdate != null && caseListToUpdate.size() > 0) 
                update caseListToUpdate;
        } catch(Exception e) {
            System.debug('--- Error Message ---' + e.getMessage());
        }
    }//end of method
    
   /*
    *  Send information After execute the bach process 
    */
    global void finish(Database.BatchableContext bi){       
       
    }
}