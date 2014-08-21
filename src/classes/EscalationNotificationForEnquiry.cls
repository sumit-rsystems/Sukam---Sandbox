global class EscalationNotificationForEnquiry implements Database.Batchable<SObject>{
    
    
    global Database.QueryLocator start(Database.BatchableContext bi){
        Date EnquiryOneDayOld = System.Today().adddays(-1);
        Date EnquirySevenDayOld = System.Today().adddays(-7);
        
        
        return Database.getQueryLocator([Select id from Enquiry__c where CreatedDate =:EnquiryOneDayOld or CreatedDate =:EnquirySevenDayOld]);
        
    }
   
   
    global void execute(Database.BatchableContext bi, List<sObject> scope){
    
     if(scope.size()>0)
     {   
       //List<Contracts__c> contractList = (List<sObject>)scope; 
       
     }
       try
       {
          //if(lstSR != null && lstSR.size() > 0) 
          //insert lstSR;
       }
       catch(Exception e)
       {
         System.debug('--- Error Message ---' + e.getMessage());
       }
 
    }
    
   
    global void finish(Database.BatchableContext bi){       
       
    }
}