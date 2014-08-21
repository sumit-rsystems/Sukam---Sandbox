public with sharing class searchenginecontroller  {

public Product__c thisProduct {get;set;}
public Account thisAccount {get;set;}
public Service_Centre_City__c thisCity {get;set;}
public Stock_Point__c thisStockPonit{get;set;}
public User thisUser {get;set;}
public Service_Request__c fromSr {get;set;}
public Service_Request__c toSr {get;set;}

public string strNew {get;set;}      
public string strAssigned {get;set;}
public string strAllocated {get;set;}
public string strPending {get;set;}
public string strAttended {get;set;}
public string strReject {get;set;}
public string strClose {get;set;}
public string strDoorLock {get;set;}
public string strPartPending {get;set;}
public string strNoPower {get;set;}
public string strCustomerNotAvailble {get;set;}
public string strReferToTrc {get;set;}
public string strPendingForPJP {get;set;}
public string strTechnicalProblem {get;set;}
public string strPendingForReplacement {get;set;}
public string strApprovalOnHold {get;set;}
public string strApproved {get;set;}
public string strDisapproved {get;set;}
public string strothers {get;set;}
public string strWrongAddress {get;set;}
public string strOtherBrandProduct {get;set;}
public string strCustomerRefused {get;set;}
public string strDuplicateCall {get;set;}
public string strTotal {get;set;}
public string strOthersPending {get;set;}
public boolean isNewStatusSelected {get;set;}
public List<Service_Request__c> searchResultRecords {get;set;}

/*Paginate*/
public Paginate pSearchItems {get;set;}


List<String> validStatusList = new List<String>{'New','Assigned','Allocated','Pending','Attended'};
//List<String> validSubStatusList = new List<String>{'Part Pending','No Power','Door Lock','Customer Not Availble','Refer To Trc','Pending For PJP','Technical Problem','Pending For Replacement'};
List<String> validSubStatusForList = new List<String>{'Pending','Reject'};
List<String> validStatusList1 = new List<String>{'Closed', 'Reject'};
    
   String ProfileName = [Select ID,Name from PROFILE where id =: USerInfo.getProfileId()].name;  
 public searchenginecontroller (){
   init();
   getCounts();
   getCounts1();
   getCountSubStatus ();
   
 }

public void init(){
  
   thisAccount = new Account();
    fromSr= new Service_Request__c ();
   toSr= new Service_Request__c ();
    thisProduct = new Product__c();
    thisuser = new User ();
    thisCity = new Service_Centre_City__c ();
    thisStockPonit = new  Stock_Point__c ();
   
   
   strNew  = '';
   strAssigned = '';
   strAllocated = '';
   strPending = '';
   strAttended = '';
   strReject = '';
   strClose ='';
   strDoorLock = '';
   strPartPending ='';
   strNoPower = '';
   strCustomerNotAvailble = '';
   strReferToTrc = '';
   strPendingForPJP = '';
   strTechnicalProblem = '';
   strPendingForReplacement = '';
   strApprovalOnHold ='';
   strApproved ='';
   strDisapproved ='';
   strOthers = '';
   strOthersPending = '';
   strWrongAddress = '';
   strOtherBrandProduct = '';
   strCustomerRefused = '';
   strDuplicateCall = '';
   strTotal ='';
   isNewStatusSelected = false;

   searchResultRecords = new List<Service_Request__c>();
   /*Pagination*/
    pSearchItems = new Paginate();
    pSearchItems.IsSearchResult = true;   
}

public void getCounts(){
        AggregateResult[] groupedResults ;
        if(ProfileName == 'System Administrator'|| ProfileName == 'sukam System Administrator'){
        groupedResults = [ Select Status__c ,count(Id) 
                           FROM Service_Request__c  
                           Where FSR_No__c != null AND Status__c IN :validStatusList 
                           //AND OwnerID= : UserInfo.getUserId() 
                           Group by Status__c Limit 10000
                            ];
         }
         else{
                    groupedResults = [ Select Status__c ,count(Id) 
                           FROM Service_Request__c  
                           Where FSR_No__c != null AND Status__c IN :validStatusList 
                           AND OwnerID= : UserInfo.getUserId() 
                           Group by Status__c Limit 10000
                            ];
         }
               
          for (AggregateResult ar : groupedResults) {
              
              if (String.valueOf(ar.get('Status__c')) == 'New'   ) 
                  strNew = String.valueOf(ar.get('expr0')) ;         
              if (String.valueOf(ar.get('Status__c')) == 'Assigned'   ) 
                  strAssigned = String.valueOf(ar.get('expr0')) ;
              if (String.valueOf(ar.get('Status__c')) == 'Allocated'   ) 
                  strAllocated = String.valueOf(ar.get('expr0')) ;  
              if (String.valueOf(ar.get('Status__c')) == 'Pending'   ) 
                  strPending = String.valueOf(ar.get('expr0')) ; 
              if (String.valueOf(ar.get('Status__c')) == 'Attended'   ) 
                  strAttended = String.valueOf(ar.get('expr0')) ; 
               
          }
          groupedResults.clear();
}

 public void getCounts1(){
        AggregateResult[] groupedResultsClo ;
        if(ProfileName == 'System Administrator'|| ProfileName == 'sukam System Administrator'){
        groupedResultsClo = [ Select Status__c ,count(Id) 
                           FROM Service_Request__c  
                           Where FSR_No__c != null AND ClosedDate__c = THIS_MONTH 
                           AND Status__c IN :validStatusList1 
                           //AND OwnerID= : UserInfo.getUserId() 
                           Group by Status__c Limit 10000
                            ];
         }
         else{
                    groupedResultsClo = [ Select Status__c ,count(Id) 
                           FROM Service_Request__c  
                            Where FSR_No__c != null AND ClosedDate__c = THIS_MONTH    
                           AND Status__c IN :validStatusList1  
                           AND OwnerID= : UserInfo.getUserId()
                           Group by Status__c Limit 10000
                            ];
         }
                
          
          for (AggregateResult ar : groupedResultsClo) {
              
              if (String.valueOf(ar.get('Status__c')) == 'Closed'   ) 
                  strClose = String.valueOf(ar.get('expr0')) ;         
              if (String.valueOf(ar.get('Status__c')) == 'Reject'   ) 
                  strReject = String.valueOf(ar.get('expr0')) ;
             
               
          } 
          groupedResultsClo.clear();
}


      
 public void getCountSubStatus (){
 
         AggregateResult[] groupedResults1 ;
         
         if(ProfileName == 'System Administrator'|| ProfileName == 'sukam System Administrator'){
             groupedResults1 = [ Select CALL_SUB_STATUS__c,count(Id) 
                           FROM Service_Request__c  
                           Where FSR_No__c != null AND Status__c IN :validSubStatusForList 
                           //AND OwnerID= :UserInfo.getUserId() 
                           Group by CALL_SUB_STATUS__c Limit 10000];
         }
         else{
             groupedResults1 = [ Select CALL_SUB_STATUS__c,count(Id) 
                   FROM Service_Request__c  
                   Where FSR_No__c != null AND Status__c IN :validSubStatusForList 
                   AND OwnerID= :UserInfo.getUserId() 
                   Group by CALL_SUB_STATUS__c Limit 10000];
         }
           strtotal = String.valueOf(groupedResults1.Size());
          for (AggregateResult ar1 : groupedResults1) {
                
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'PART PENDING'   ) 
                  strPartPending = String.valueOf(ar1.get('expr0')) ;
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'DOOR LOCKED'   ) 
                  strDoorLock = String.valueOf(ar1.get('expr0')) ;  
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'NO POWER'   ) 
                  strNoPower = String.valueOf(ar1.get('expr0')) ; 
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'CUSTOMER NOT AVAILBLE'   ) 
                  strCustomerNotAvailble = String.valueOf(ar1.get('expr0')) ; 
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'REFER TO TRC'   ) 
                  strReferToTrc = String.valueOf(ar1.get('expr0')) ; 
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'PENDING FOR PJP' ) 
                   strPendingForPJP = String.valueOf(ar1.get('expr0')) ;  
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'TECHANICAL PROBLEM' ) 
                   strTechnicalProblem  = String.valueOf(ar1.get('expr0')) ;
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'PENDING FOR REPLACEMENT' ) 
                   strPendingForReplacement = String.valueOf(ar1.get('expr0')) ;        
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'APPROVAL ON HOLD' ) 
                    strApprovalOnHold  = String.valueOf(ar1.get('expr0')) ;    
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'DISAPPROVED' ) 
                    strDisapproved = String.valueOf(ar1.get('expr0')) ;  
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'WRONG ADDRESS/INVALID CONTACT NO' ) 
                    strWrongAddress = String.valueOf(ar1.get('expr0')) ;  
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'OTHER BRAND PRODUCT' ) 
                    strOtherBrandProduct = String.valueOf(ar1.get('expr0')) ;  
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'CUSTOMER REFUSED' ) 
                    strCustomerRefused = String.valueOf(ar1.get('expr0')) ;  
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'DUPLICATE CALL' ) 
                    strDuplicateCall = String.valueOf(ar1.get('expr0')) ;                
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'OTHERS' ) 
                    strothers = String.valueOf(ar1.get('expr0')) ; 
                if (String.valueOf(ar1.get('CALL_SUB_STATUS__c')) == 'OTHERS-PENDING' ) 
                    strOthersPending = String.valueOf(ar1.get('expr0')) ;                  
    }
    
    groupedResults1.clear();
 }


 public pagereference SearchResult(){
    //String query= 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c  ,Product_Code__c ,Service_Engineer_Assigned__r.Name ,Reason__c,Category__c,Preferred_Date_for_Visit__c,CreatedDate,Status__c,OwnerId,owner.name FROM Service_Request__c WHERE ';
    String query= 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c  ,Service_Engineer_Assigned__r.Name ,CreatedDate,Status__c,OwnerId,owner.name FROM Service_Request__c WHERE ';
    String whereClause = '';
    Date fd ;
    Date fd1 ;
    Date fd2;
    Date fd3;
    Datetime fdt ;
    Datetime fdt1 ;
    Datetime fdt2 ;
    Datetime fdt3 ;
    Datetime fdt4 ;
    Datetime fdt5 ;

    if (fromSr.Preferred_Date_for_Visit__c != null){
        fd = date.valueOf(fromSr.Preferred_Date_for_Visit__c);            
        whereClause = 'Preferred_Date_for_Visit__c >=:fd' ;
    }
    
    if (toSr.Preferred_Date_for_Visit__c != null){
        fd1 = date.valueof(toSr.Preferred_Date_for_Visit__c);
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Preferred_Date_for_Visit__c <=:fd1' ;
       else
        whereClause = 'Preferred_Date_for_Visit__c <=:fd1' ;      
    }
    
      if (fromSr.Created_Date__c != null){
         fd2 =  date.valueOf(fromSr.Created_Date__c );
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Date_Time_Opened__c >=:fdt' ;
       else
        whereClause = ' Date_Time_Opened__c >=:fdt' ;
    }

    if(toSr.Created_Date__c != null){
         fd3 = date.valueof(toSr.Created_Date__c);
       if (whereclause != '' )
          whereclause = whereclause + ' AND ' + 'Date_Time_Opened__c <=:fdt1' ;
       else
          whereclause = 'Date_Time_Opened__c <=:fdt1' ;
     } 


    if (fromSr.Attended_Date_Time__c != null){
         fdt =  date.valueOf(fromSr.Attended_Date_Time__c );
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Attended_Date_Time__c >=:fdt' ;
       else
        whereClause = ' Attended_Date_Time__c >=:fdt' ;
    }

    if(toSr.Attended_Date_Time__c != null){
         fdt1 = date.valueof(toSr.Attended_Date_Time__c);
       if (whereclause != '' )
          whereclause = whereclause + ' AND ' + 'Attended_Date_Time__c <=:fdt1' ;
       else
          whereclause = 'Attended_Date_Time__c <=:fdt1' ;
     } 
      


    if (fromSr.Completion_Date_Time__c != null){
        fdt2 = date.valueof(fromSr.Completion_Date_Time__c );
        
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Completion_Date_Time__c >=:fdt2';
       else
        whereClause = ' Completion_Date_Time__c >=:fdt2' ;
    }

    if(toSr.Completion_Date_Time__c != null){
        fdt3 = date.valueof(toSr.Completion_Date_Time__c );
       if (whereclause != '' )
          whereclause = whereclause + ' AND ' + 'Completion_Date_Time__c <=:fdt3' ;
       else
          whereclause = 'Completion_Date_Time__c <=:fdt3' ;
     }
      


    if (fromSr.ClosedDate__c != null){
        fdt4 = date.valueof(fromSr.ClosedDate__c);
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' ClosedDate__c >=:fdt4';
       else
        whereClause = ' ClosedDate__c >=:fdt4' ;
    }   
    if(toSr.ClosedDate__c != null){
        fdt5 = date.valueof(toSr.ClosedDate__c);
       if (whereclause != '' )
          whereclause = whereclause + ' AND ' + 'ClosedDate__c <=:fdt5';
       else
          whereclause = 'ClosedDate__c <=:fdt5' ;
      }  
     
     if(fromSr.Account__c!=null){  
       if (whereClause != '' )
            whereClause =whereClause + ' AND ' + ' Account__c =' +  '\'' + fromSr.Account__c +  '\'' ;
       else
            whereClause = ' Account__c =' +  '\'' +fromSr.Account__c +  '\'' ;
            system.debug('dttttttttttttttttt====='+whereClause);
     }
    

     /**********************       Account related Fields *********************/
     if(thisAccount.Mobile_No__c!=null){  
       if (whereClause != '' )
            whereClause =whereClause + ' AND ' + 'Customer_Mobile_No__c '  + '\'' + thisAccount.Mobile_No__c  + '\''  ;
       else
            whereClause = 'Customer_Mobile_No__c = ' + '\'' + thisAccount.Mobile_No__c  + '\'' ;     
     }
     
      if(thisAccount.Customer_ID__c!=null){  
       if (whereClause != '' )
            whereClause =whereClause + ' AND ' + 'Customer_ID__c'  + '\'' + thisAccount.Customer_ID__c  + '\''  ;
       else
            whereClause = 'Customer_ID__c = ' + '\'' + thisAccount.Customer_ID__c + '\'' ;     
     }

     if(thisAccount.State__c!=null){  
       if (whereClause != '' )
            whereClause =whereClause + ' AND ' + ' Account__r.State__c = '  + '\'' + thisAccount.State__c  + '\'' ;
       else
            whereClause =' Account__r.State__c = '  + '\'' + thisAccount.State__c  + '\'';               
     }
     
     if(thisAccount.District__c!=null){  
       if (whereClause != '' )
            whereClause =whereClause + ' AND ' + ' Account__r.District__c = '  + '\'' + thisAccount.District__c  + '\'' ;
       else
            whereClause =' Account__r.District__c = '  + '\'' + thisAccount.District__c  + '\'';       
     }

     if(thisAccount.City__c!=null){  
       if (whereClause != '' )
            whereClause =whereClause + ' AND ' + ' Account__r.City__c = ' + '\'' + thisAccount.City__c  + '\'';
       else
            whereClause =' Account__r.City__c = ' + '\'' + thisAccount.City__c  + '\'';       
     }
     /***************************************************************************/
     
    

    if (fromSr.Service_Engineer_Assigned__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Service_Engineer_Assigned__c = ' +  '\'' + fromSr.Service_Engineer_Assigned__c +  '\'' ;
       else
        whereClause = ' Service_Engineer_Assigned__c = ' +  '\'' + fromSr.Service_Engineer_Assigned__c +  '\'' ;
    }
    
    if (fromSr.Product_Category__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Product_Category__c = ' + '\'' + fromSr.Product_Category__c + '\'' ;
       else
        whereClause = ' Product_Category__c = '  + '\'' + fromSr.Product_Category__c + '\'';
    }
    
    if (fromSr.Group__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Group__c = ' + '\'' + fromSr.Group__c + '\'' ;
       else
        whereClause = ' Group__c = ' + '\'' + fromSr.Group__c + '\'';
    }
    
    if (fromSr.Sub_Group__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Sub_Group__c = ' + '\'' + fromSr.Sub_Group__c  + '\'';
       else
        whereClause = ' Sub_Group__c = ' + '\'' + fromSr.Sub_Group__c + '\'' ;
    }
    
    
    if (fromSr.Warranty_Status__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Warranty_Status__c = ' + '\'' + fromSr.Warranty_Status__c + '\'';
       else
        whereClause = ' Warranty_Status__c = ' + '\'' + fromSr.Warranty_Status__c + '\'' ;
    }
    
     
    if (fromSr.PROBLEM_OBSERVED__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' PROBLEM_OBSERVED__c = ' + '\'' + fromSr.PROBLEM_OBSERVED__c + '\'';
       else
        whereClause = ' PROBLEM_OBSERVED__c = ' + '\'' + fromSr.PROBLEM_OBSERVED__c + '\'' ;
    }
    
     if (fromSr.Products__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Products__c = ' + '\'' + fromSr.Products__c  + '\'';
       else
        whereClause = ' Products__c = ' + '\'' + fromSr.Products__c + '\'' ;
    }

    
    if (fromSr.Category__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Category__c = ' + '\'' + fromSr.Category__c + '\'' ;
       else
        whereClause = ' Category__c = ' + '\'' + fromSr.Category__c ;
    }
    
    if (fromSr.Status__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Status__c = ' + '\'' + fromSr.Status__c + '\'' ;
       else
        whereClause = ' Status__c =  ' + '\''  + fromSr.Status__c + '\'' ;
        
        if (fromSr.Status__c =='New')
            isNewStatusSelected = true;
        else
            isNewStatusSelected = false;    
    }
    else
        isNewStatusSelected = false;
      
       if (fromSr.CALL_SUB_STATUS__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' CALL_SUB_STATUS__c    = ' + '\'' + fromSr.CALL_SUB_STATUS__c + '\'' ;
       else
        whereClause = ' CALL_SUB_STATUS__c   =  ' + '\''  + fromSr.CALL_SUB_STATUS__c + '\'' ;
    }
    
    
    
    
    if (fromSr.Complain_Type__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Complain_Type__c = ' +'\'' + fromSr.Complain_Type__c + '\'' ;
       else
        whereClause = ' Complain_Type__c = ' + '\'' + fromSr.Complain_Type__c + '\'' ;
    }
    
    if (fromSr.CALL_TYPE__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' CALL_TYPE__c = ' + '\'' + fromSr.CALL_TYPE__c + '\'' ;
       else
        whereClause = ' CALL_TYPE__c = ' + '\'' + fromSr.CALL_TYPE__c + '\'';
    }       
    
    if (fromSr.Service_Type__c != null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + ' Service_Type__c = ' + '\'' + fromSr.Service_Type__c + '\'' ;
       else
        whereClause = ' Service_Type__c = ' + '\'' + fromSr.Service_Type__c + '\'';
    }
    
    if (thisProduct.Product_Code__c!= null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + 'Products__r.Product_Code__c = ' +  '\'' + thisProduct.Product_Code__c + '\'' ;
       else
        whereClause = 'Products__r.Product_Code__c = ' + '\'' + thisProduct.Product_Code__c + '\'' ;
    }  
 
    
    if (fromSr.Product_Serial_No__c!= null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + 'Product_Serial_No__c =' +  '\'' + fromSr.Product_Serial_No__c+ '\'' ;
       else
        whereClause = 'Product_Serial_No__c =' +  '\'' + fromSr.Product_Serial_No__c+ '\''  ;
    }  
    
      if (fromSr.Owner_Name__c!= null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + 'ownerid ='+ '\''  + fromSr.Owner_Name__c + '\''  ;
       else
        whereClause = 'ownerid =' + '\''  + fromSr.Owner_Name__c + '\'' ;
    } 
   
      if (thisUser.Region__c!= null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + 'Account__r.Region__c=' + '\''  + thisUser.Region__c + '\''  ;
       else
        whereClause = 'Account__r.Region__c =' +  '\'' + thisUser.Region__c + '\''  ;
    } 
    
     if (thisUser.Branch_State__c!= null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + 'Account__r.Branch_State__c =' + '\''  + thisUser.Branch_State__c + '\''  ;
       else
        whereClause = 'Account__r.Branch_State__c =' +  '\'' + thisUser.Branch_State__c + '\''  ;
    } 
     if (thisUser.Branch__c!= null){
       if (whereClause != '' ) 
        whereClause =whereClause + ' AND ' + 'Account__r.Branch__c =' + '\'' + thisUser.Branch__c + '\''  ;
       else
        whereClause = 'Account__r.Branch__c =' + '\'' + thisUser.Branch__c + '\'' ;
    } 
    
    
   /*
        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.Info,query  +  whereClause);
        ApexPages.addMessage(myMsg1);
        RETURN NULL;
       */           
    if (whereClause == ''){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Atleast make some selection and then try again.');
        ApexPages.addMessage(myMsg);
        return null ;
    }
    else{
        if(ProfileName == 'System Administrator'|| ProfileName == 'sukam System Administrator'){
            whereClause =  whereClause ;
        }else{
             whereClause =  whereClause   + ' AND OwnerID= ' +  '\'' + UserInfo.getUserId() +  '\'' ; 
         }
        
    }
        
    //Exeute Query and get records        
    query= query  +  whereClause;
    system.debug('####' +  query);      
    List<sObject> sobjects = new List<sObject>();
    sobjects  =  Database.query(query);
    searchResultRecords  = (List<Service_Request__c>)sobjects ;
    
    List<searchEngineItem> sEItems = new List<searchEngineItem>();
    for(Service_Request__c s : searchResultRecords)
        sEItems.add(new searchEngineItem(s));
    
    System.debug('sEItems' + sEItems.size());
    /*Pagination*/
    //pSearchItems.searchResultItems = searchResultRecords;
        pSearchItems.searchResultItems = sEItems ;
        pSearchItems.inititateBind();              
    //
    
    searchResultRecords.clear();  
    sEItems.clear();                  
    return null;
 }
 
 public String getRecordCount(){
    if (pSearchItems.searchResultItems != null && pSearchItems.searchResultItems.size() > 0 )
        return String.valueOf( pSearchItems.searchResultItems.Size());
    else if (pSearchItems.pageResultItems != null && pSearchItems.pageResultItems.size() > 0 )
        return String.valueOf( pSearchItems.pageResultItems.Size());    
    else 
        return '0'; 
 }
   
 public void refreshSearchResult(){
    String query= '';
    
    /*
    if(ProfileName != 'System Administrator')
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c ,Product_Code__c ,Service_Engineer_Assigned__r.Name ,Reason__c,Category__c,Preferred_Date_for_Visit__c,CreatedDate,Status__c , OwnerId,owner.name FROM Service_Request__c WHERE OwnerID= ' +  '\'' + UserInfo.getUserId() +  '\'' + 'AND Status__C = '  ;
    else
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c ,Product_Code__c, Service_Engineer_Assigned__r.Name,Reason__c,Category__c,Preferred_Date_for_Visit__c,CreatedDate,Status__c , OwnerId,owner.name FROM Service_Request__c WHERE Status__C = '  ;
    
    if (System.currentPageReference().getParameters().get('selectedStatus') != null)
        query = query   + '\'' + System.currentPageReference().getParameters().get('selectedStatus') + '\'' ;                 
    */
     if(ProfileName != 'System Administrator'|| ProfileName == 'sukam System Administrator')
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c  ,Service_Engineer_Assigned__r.Name ,CreatedDate,Status__c , OwnerId,owner.name FROM Service_Request__c WHERE OwnerID= ' +  '\'' + UserInfo.getUserId() +  '\'' + 'AND Status__C = '  ;
    else
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c , Service_Engineer_Assigned__r.Name,CreatedDate,Status__c , OwnerId,owner.name FROM Service_Request__c WHERE Status__C = '  ;

    if (System.currentPageReference().getParameters().get('selectedStatus') != null){
        query = query   + '\'' + System.currentPageReference().getParameters().get('selectedStatus') + '\'' ;                 
    
        if (System.currentPageReference().getParameters().get('selectedStatus') == 'New')
            isNewStatusSelected = true;
        else
            isNewStatusSelected = false;    
    }
    
    List<sObject> sobjects = new List<sObject>();
    sobjects  =  Database.query(query);
    searchResultRecords  = (List<Service_Request__c>)sobjects  ;
    
    List<searchEngineItem> sEItems = new List<searchEngineItem>();
    for(Service_Request__c s : searchResultRecords) 
        sEItems.add(new searchEngineItem(s));
        
    /*Pagination*/
    //pSearchItems.searchResultItems = searchResultRecords;
        pSearchItems.searchResultItems = sEItems ;
        pSearchItems.inititateBind();
    //
    
    searchResultRecords.clear();
    sEItems.clear();
        
    /*Pagination*/
    //pSearchItems.searchResultItems = searchResultRecords;
    //pSearchItems.inititateBind();
     
 }
 
  public void refreshSearchResultClosed(){
    
    String query= '';
    
    /*
    if(ProfileName != 'System Administrator')
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c ,Product_Code__c,Service_Engineer_Assigned__r.Name ,Reason__c,Category__c,Preferred_Date_for_Visit__c,CreatedDate,Status__c , OwnerId,owner.name FROM Service_Request__c WHERE OwnerID= ' +  '\'' + UserInfo.getUserId() +  '\'' + 'AND Status__C = '  ;
    else
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c ,Product_Code__c ,Service_Engineer_Assigned__r.Name ,Reason__c,Category__c,Preferred_Date_for_Visit__c,CreatedDate,Status__c , OwnerId,owner.name FROM Service_Request__c WHERE Status__C = '  ;
    */
    if(ProfileName != 'System Administrator'|| ProfileName == 'sukam System Administrator')
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c ,Service_Engineer_Assigned__r.Name ,CreatedDate,Status__c , OwnerId,owner.name FROM Service_Request__c WHERE OwnerID= ' +  '\'' + UserInfo.getUserId() +  '\'' + 'AND Status__C = '  ;
    else
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c ,Service_Engineer_Assigned__r.Name ,CreatedDate,Status__c , OwnerId,owner.name FROM Service_Request__c WHERE Status__C = '  ;
    
    
    if (System.currentPageReference().getParameters().get('selectedStatusClosed') != null)
        query = query   + '\'' + System.currentPageReference().getParameters().get('selectedStatusClosed') + '\'' ;                 
    
    List<sObject> sobjects = new List<sObject>();
    sobjects  =  Database.query(query);
    searchResultRecords  = (List<Service_Request__c>)sobjects  ;
    
    List<searchEngineItem> sEItems = new List<searchEngineItem>();
    for(Service_Request__c s : searchResultRecords) 
        sEItems.add(new searchEngineItem(s));
    
    /*Pagination*/
    pSearchItems.searchResultItems = sEItems;
    pSearchItems.inititateBind(); 
    
    searchResultRecords.clear();
    sEItems.clear();
 }
 
 
 
 
 
 public void refreshSearchResult1(){
     String query= '';
/*     
     if(ProfileName != 'System Administrator')
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name ,Account__r.City__r.Name , Account__r.District__c,Product_Code__c ,Service_Engineer_Assigned__r.Name,Reason__c,Category__c,Preferred_Date_for_Visit__c,CreatedDate,Status__c ,OwnerId ,Owner.name FROM Service_Request__c WHERE OwnerID= ' +  '\'' + UserInfo.getUserId() +  '\'' + 'AND CALL_SUB_STATUS__c = ';
      else
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c ,Product_Code__c,Service_Engineer_Assigned__r.Name ,Reason__c,Category__c,Preferred_Date_for_Visit__c,CreatedDate,Status__c ,OwnerId ,Owner.name FROM Service_Request__c WHERE CALL_SUB_STATUS__c = ';   
*/
     if(ProfileName != 'System Administrator' || ProfileName == 'sukam System Administrator')
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name ,Account__r.City__r.Name , Account__r.District__c ,Service_Engineer_Assigned__r.Name,CreatedDate,Status__c ,OwnerId ,Owner.name FROM Service_Request__c WHERE OwnerID= ' +  '\'' + UserInfo.getUserId() +  '\'' + 'AND CALL_SUB_STATUS__c = ';
      else
        query = 'SELECT ID ,FSR_No__c, Account__r.Name, Name,Account__r.City__r.Name,Account__r.District__c ,Service_Engineer_Assigned__r.Name ,CreatedDate,Status__c ,OwnerId ,Owner.name FROM Service_Request__c WHERE CALL_SUB_STATUS__c = ';   

 
     if (System.currentPageReference().getParameters().get('selectedSubStatus') != null)
    query = query   + '\'' + System.currentPageReference().getParameters().get('selectedSubStatus') + '\'' ;
 
 
     List<sObject> sobjects = new List<sObject>();
    sobjects  =  Database.query(query);
    searchResultRecords  = (List<Service_Request__c>)sobjects  ;
    
    List<searchEngineItem> sEItems = new List<searchEngineItem>();
    for(Service_Request__c s : searchResultRecords) 
        sEItems.add(new searchEngineItem(s));
        
    /*Pagination*/
    //pSearchItems.searchResultItems = searchResultRecords;
    //pSearchItems.inititateBind();
    
    pSearchItems.searchResultItems = sEItems ;
    pSearchItems.inititateBind();
        
    searchResultRecords.clear();
    sEItems.clear();
    
 }
  
  /************* Pagination code STARTS ******************************* */
    
    public List<SelectOption> getPageSizeList() {
        //SIZE SHOULD NOT BE MPORE THEN 1000 AS THIS IS MAXIMUM SIZE on VF PAGE.
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('25','25'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        options.add(new SelectOption('150','150'));
        options.add(new SelectOption('200','200'));
        options.add(new SelectOption('250','250'));                
        return options;
    }
       
/************* Pagination code ENDS ******************************* */  
    
    public pagereference assignToEngineer(){
        if(fromSr.Service_Engineer_Assigned__c == null){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.Info,'Kindly select service Engineer from section [ ENGINEER FEEDBACK DETAILS ] and then try again.');
            ApexPages.addMessage(myMsg1);           
        }
        else{
                List<Service_Request__c> sr_ToUpdate = new List<Service_Request__c>();              
                for(searchEngineItem s : pSearchItems.pageResultItems){
                    if (s.isSelected){
                        s.thisServiceReq.Service_Engineer_Assigned__c = fromSr.Service_Engineer_Assigned__c;
                        sr_ToUpdate.add(s.thisServiceReq);
                    }                   
                }
                if (sr_ToUpdate.Size()>0){
                    update sr_ToUpdate;
                    getCounts();
                    pSearchItems = new Paginate();
                    pSearchItems.IsSearchResult = true;
                }
        }
        return null;        
    }    
}