trigger trgAssignSaleEnquiry on Enquiry__c(after insert, after update){

    
    List<string> listServiceCenterState = new List<string>();
    
    for (Enquiry__c oCase : Trigger.new){
        if (oCase.City__c != null)
           listServiceCenterState.add(oCase.State__c);
    }


    //Map of ServiceCenterCity Id and the respective User
      Map<string,string> map_BMEmail = new Map<string,string>();
    
      for (State__c scc : [Select Id,Branch_Manager_Name__c,Branch_Manager_Email_Id__c,State_Name__c From State__c where State_Name__c in :listServiceCenterState]){
        map_BMEmail.put(scc.State_Name__c, scc.Branch_Manager_Email_Id__c);
      }
    
    //Select Email template 
    
    EmailTemplate objTmp = [SELECT Body, Description, CreatedDate, IsActive, Id, Name, Subject, HtmlValue, TemplateStyle FROM EmailTemplate where name = 'Product Enquiry'][0];
    
    
    //To Set the Owner based on the Service Center City selected for each case.
    for (Enquiry__c oCase : Trigger.new){
        if (oCase.State__c != null){
 
            //Send email of sales enquiry to BM based on selected state
            //string[] BMEmail = new string[]{map_BMEmail.get(oCase.State__c)};
            string[] BMEmail = new string[]{'amit91280@gmail.com'};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            //------
              //mail.setSaveAsActivity(false);
              //mail.setTargetObjectId('00590000000c9vEAAQ');
              //mail.setWhatId(trigger.new[0].id);
              //mail.setTemplateId(objTmp.id);
            //------
            
              mail.setToAddresses(BMEmail);
              mail.setSubject('SalesEnquiry : ');
              mail.setPlainTextBody('');
              mail.setHtmlBody('<b>Sales Enquiry No.: </b>' + trigger.new[0].Sale_Enquiry__c + '<br><b>Name: </b>' + trigger.new[0].Name + '<br><b>Company: </b>' + trigger.new[0].Company__c + '<br><b>Email: </b>' + trigger.new[0].Email__c +'<br><b>City: </b>' + trigger.new[0].City__c +'<br><b> Title </b>' + trigger.new[0].Title__c + '<br><b> Product </b>' + trigger.new[0].Product__c + '<br><b>Description: </b>' + trigger.new[0].Description__c +'<br><b> Phone </b>' + trigger.new[0].Phone__c + '');
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            
            //Send Enquiry details to Customer
              
                /*string[] CustEmail = new string[]{trigger.new[0].Email__c};
                Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
                mail2.setSaveAsActivity(false);
                mail2.setTargetObjectId('00590000000c9vEAAQ');
                mail2.setWhatId(trigger.new[0].id);
                mail2.setTemplateId(objTmp.id);
                mail2.setToAddresses(CustEmail);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail2 });*/
        }
    }
    
    
   
}