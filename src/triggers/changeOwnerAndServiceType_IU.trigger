trigger changeOwnerAndServiceType_IU on Service_Request__c(before insert, before update){
   List<Service_Request__c> lstSr = Trigger.new;
   
    Set<String> setAccountids= new Set<String>();
        for(integer i=0; i<lstSr.size(); i++ ) {
        setAccountids.add(lstSr[i].Account__c);
       }
    
    List<Account> lstAccounts = [SELECT ID, City__c , service_center__c, service_type__c FROM Account
                      WHERE id IN : setAccountids];
                      
    Set<String> setServicecenters= new Set<String>();
      for(integer i=0; i<lstAccounts.size();i++){
        setServicecenters.add(lstAccounts[i].service_center__c );
      }
      
    List<User> lstUsers= new List<User>();
    lstUsers =[select Id ,city__c, name from user where city__c IN :setServicecenters ];
   
    Map<ID,ID> mapAccountUser= new Map<ID,Id>();    
    Map<ID,Account> mapAccrecords = new Map<ID,Account>();
    
    for(integer i=0; i<lstAccounts.size();i++){
        if (lstAccounts[i].City__c != null){
                mapAccrecords.put(lstAccounts[i].id,lstAccounts[i]);
                
                for(integer j=0; j<lstUsers.size();j++){
                    if(lstAccounts[i].service_center__c == lstUsers[j].city__c )
                        mapAccountUser.put(lstAccounts[i].id,lstUsers[j].id);               
                }                     
        }
    }
      
    for(integer i=0; i<Trigger.new.size();i++){
        
        if(mapAccountUser.containsKey(Trigger.new[i].account__c)&& Trigger.new[i].Email_To_Case__c != True){
        
              Trigger.new[i].ownerid = mapAccountUser.get(Trigger.new[i].account__c);
                   
              If(Trigger.new[i].CALL_TYPE__c == 'COMPLAIN END USER'|| Trigger.new[i].CALL_TYPE__c == 'COMPLAIN DEALER'){               
                   Trigger.new[i].service_type__c= mapAccrecords.get(Trigger.new[i].account__c).service_type__c;

                   /*if ( Trigger.new[i].Warranty_Status__c=='No'&& Trigger.new[i].AMC_Status__c== 'No' && (Trigger.new[i].service_type__c=='Local' || Trigger.new[i].service_type__c== 'Upcountry') )
                        Trigger.new[i].Service_Charge_Type__c ='On Site'; */              
                    }
              else{
                   if(Trigger.new[i].CALL_TYPE__c =='TRC REPAIR')
                        Trigger.new[i].service_type__c = 'CARRY IN';     
                        /*if( Trigger.new[i].Warranty_Status__c=='No' && Trigger.new[i].AMC_Status__c== 'No' && Trigger.new[i].service_type__c == 'CARRY IN') 
                            Trigger.new[i].Service_Charge_Type__c = 'Carry In'; */     
                        
              }
    
                    if( (Trigger.new[i].Status__c == 'Pending' || Trigger.new[i].Status__c == 'Reject' ) && ( Trigger.new[i].CALL_SUB_STATUS__c == null || Trigger.new[i].CALL_SUB_STATUS__c == '' ) )
                         Trigger.new[i].addError('Fill Call Sub Status if status is either Pending Or Reject');
                    else{ 
                         System.debug('====before if ===='+Trigger.new[i].Status__c);                  
                        if( Trigger.new[i].Service_Engineer_Assigned__c== null && Trigger.new[i].Preferred_Date_for_Visit__c==null && Trigger.new[i].Status__c != 'ReOpen')
                            {Trigger.new[i].Status__c='New';} 
                        if(Trigger.new[i].Service_Engineer_Assigned__c!=null && Trigger.new[i].Preferred_Date_for_Visit__c==null && Trigger.new[i].CALL_SUB_STATUS__c== null && Trigger.new[i].Status__c != 'ReOpen')
                             {Trigger.new[i].Status__c = 'Assigned';} 
                        if(Trigger.new[i].Service_Engineer_Assigned__c!=null && Trigger.new[i].Preferred_Date_for_Visit__c!=null && Trigger.new[i].CALL_SUB_STATUS__c== null && Trigger.new[i].Status__c != 'ReOpen')
                             {Trigger.new[i].Status__c = 'Allocated';} 
                         if( Trigger.new[i].Completion_Date_Time__c != null && Trigger.new[i].Attended_Date_Time__c!=null && Trigger.new[i].CALL_SUB_STATUS__c== null && Trigger.new[i].Status__c != 'ReOpen' )
                            {Trigger.new[i].Status__c='ATTENDED';}
                         if (Trigger.new[i].Completion_Date_Time__c != null && Trigger.new[i].Attended_Date_Time__c!=null && Trigger.new[i].CALL_SUB_STATUS__c== null&& Trigger.new[i].ClosedDate__c != null && Trigger.new[i].Status__c != 'ReOpen')  
                          {Trigger.new[i].Status__c = 'Closed';}  
                    }
                    String ProfileName = [Select ID,Name from PROFILE where id =: USerInfo.getProfileId()].name; 
                      System.debug('====ProfileName===='+ProfileName);
   
                         //if(Trigger.isUpdate && Trigger.new[i].Status__c  != Trigger.old[i].Status__c && ProfileName != 'System Administrator')
                         if(Trigger.isUpdate && Trigger.new[i].Status__c  != Trigger.old[i].Status__c)
                        {
                            if (Trigger.old[i].Status__c == 'New' && Trigger.new[i].Status__c == '' )
                              Trigger.new[i].addError('Status can not be blank.');
                            else if (Trigger.old[i].Status__c == 'ATTENDED' && (Trigger.New[i].Status__c == 'New' || Trigger.new[i].Status__c == 'Allocated'  ||  Trigger.new[i].Status__c == 'Assigned'))
                                 Trigger.new[i].addError('Can not delete Attended Date and Completion Date once it has been Attended.');     
                              
                            else if (Trigger.old[i].Status__c == 'Allocated' && (Trigger.New[i].Status__c == 'New' ||  Trigger.new[i].Status__c == 'Assigned'))
                                 Trigger.new[i].addError('Can not delete Service Engineer Assigned or Appointment Date once it has been Allocated .');
                                 
                            else if (Trigger.old[i].Status__c == 'Assigned' && (Trigger.New[i].Status__c == 'New' )){
                                     Trigger.new[i].addError('Can not delete Service Engineer Assigned Once it has been Assigned.');     
                                 }
                            else if (Trigger.old[i].Status__c == 'Closed' && (Trigger.New[i].Status__c == 'ReOpen' )){
                                 Trigger.new[i].Status__c = 'ReOpen';  
                                 }
                        }    
                      
                                   
            }
            else{
                    if (!test.isRunningTest()&& Trigger.new[i].Email_To_Case__c != True) 
                        Trigger.new[i].addError('Please Fill the City in Customer to Auto Assign the Call');
            }       
       }
}