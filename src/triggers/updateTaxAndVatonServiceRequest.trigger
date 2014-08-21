trigger updateTaxAndVatonServiceRequest on Service_Request__c (before insert,before update) {

    String State = '';
    String ProductCategory = '';
     List<User> recordowner = [Select ID,State From User Where ID =: Trigger.New[0].OwnerID];  
       

 
    if (recordowner != null && recordowner.Size()>0)
          State = recordowner[0].State;   

    //if (Trigger.New[0].Product_Category__c != null)
    //    ProductCategory = Trigger.New[0].Product_Category__c;  
        
    //Get component from Component Movement table
    List<Component_Movement_Table__c> lstCMT = [Select Id,Service_Request__c,Select_Component__c from Component_Movement_Table__c where Service_Request__c =: Trigger.New[0].Id];
    
    if(lstCMT.size()>0)
    {
        //Get Product Category on basis of Product id
        Product__c objProduct = [select Product_Category__c from Product__c where id =: lstCMT[0].Select_Component__c];
        Date createdDate= System.Today();
        Date closedDate;
        if (Trigger.New[0].ClosedDate__c != null) 
         closedDate= Trigger.New[0].ClosedDate__c.date();
             
        List<VAT1__c> vats = new List<VAT1__c>();
        
        if(closedDate!= null)
            vats = [ SELECT ID,VAT_Percentage__c,Start_Date__c,End_Date__c FROM VAT1__c where State__c =:State 
                         AND Product_Category__c =: objProduct.Product_Category__c
                         AND (
                              (Start_Date__c <=: createdDate AND  End_Date__c >=: createdDate)
                               OR  
                              (Start_Date__c <=: closedDate AND  End_Date__c >=: closedDate)
                             )
                   ];
         else 
             vats = [ SELECT ID,VAT_Percentage__c,Start_Date__c,End_Date__c FROM VAT1__c where State__c =:State 
                         AND Product_Category__c =: objProduct.Product_Category__c
                         AND 
                         (Start_Date__c <=: createdDate AND  End_Date__c >=: createdDate)                                                                                                                           
                    ];

         if   (vats != null && vats.Size()> 0 )
           Trigger.new[0].Component_Tax_Rate_1__c = vats[0].VAT_Percentage__c;
    }
 
}