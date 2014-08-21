trigger UpdateTaxAndVAtOnContract on Contracts__c (before insert,before update) {
   // This trigger is not bulk compatible as per discussion with client this will always run for 1 record.
    String State = '';
    String ProductCategory = '';
     List<User> LoggedInUSer = [Select ID,State From User Where ID =: Userinfo.getUserId()];  
        if (Trigger.IsInsert) 
             LoggedInUSer = [Select ID,State From User Where ID =: Userinfo.getUserId()];
           else if (Trigger.IsUpdate)
          LoggedInUSer = [Select ID,State From User Where ID =: Trigger.new[0].CreatedById];
    
    
    //Get stockpoint on the basis of current user id
    //List<Stock_Point__c> lstSP = [select id,name from Stock_Point__c where CreatedById =: Userinfo.getUserId()];
    User objU = [SELECT Branch__c, ContactId, City, Branch_State__c, Id, Username, CommunityNickname, Stock_Point__c FROM User where id =:Userinfo.getUserId()];
    if(objU <> null)
    {
      //Trigger.New[0].Stock_Point__c = lstSP[0].id;
      Trigger.New[0].Stock_Point_Name__c = objU.Stock_Point__c ;
    }
    
    
    if (LoggedInUSer != null && LoggedInUSer.Size()>0)
          State = LoggedInUSer[0].State;   

    if (Trigger.New[0].Product_Category__c != null)
        ProductCategory = Trigger.New[0].Product_Category__c;
    
    Date createdDate= System.Today();
    
    Date activatedDate;
    if (Trigger.New[0].Activated_Date__c != null) 
        activatedDate = Trigger.New[0].Activated_Date__c.date();
         
    List<VAT1__c> vats = new List<VAT1__c>();
    
    if(activatedDate != null)
        vats = [ SELECT ID,VAT_Percentage__c,Start_Date__c,End_Date__c FROM VAT1__c where State__c =:State 
                                  AND Product_Category__c =: ProductCategory
                                  AND (
                                       (Start_Date__c <=: createdDate AND  End_Date__c >=: createdDate)
                                        OR  
                                       (Start_Date__c <=: activatedDate AND  End_Date__c >=: activatedDate)
                                      ) 
                                  ];
     else 
         vats = [ SELECT ID,VAT_Percentage__c,Start_Date__c,End_Date__c FROM VAT1__c where State__c =:State 
                                  AND Product_Category__c =: ProductCategory
                                  AND 
                                       (Start_Date__c <=: createdDate AND  End_Date__c >=: createdDate)                                                                                                                           
                                  ];
                                                              
    List<TAX__c>  taxs = [ SELECT ID,Tax_Percentage__c ,Start_Date__c,End_Date__c FROM Tax__c where Tax_State__c =:State];
    
    if  ( vats != null && vats.Size()> 0) //|| vats[0].Start_Date__c > Trigger.new[0].CreatedDate || vats[0].Start_Date__c > Trigger.new[0].Activated_Date__c )
        Trigger.new[0].VAT_Percentage__c = vats[0].VAT_Percentage__c;
        
    if  ( taxs != null && taxs.Size()>0 )// || taxs[0].Start_Date__c > Trigger.new[0].CreatedDate || taxs[0].Start_Date__c > Trigger.new[0].Activated_Date__c )
        Trigger.new[0].Tax_Percentage__c = taxs[0].Tax_Percentage__c;
 
    
    datetime d= date.newInstance(2012,10,31);
    datetime dt= System.now();
    
   
     for(Contracts__c con : Trigger.new){
        /*
        if(trigger.isUpdate && ((con.CreatedDate > d) || (con.Activated_Date__c > d)))
           con.Total_AMC_Amount__c = (con.AMC_Amount_after_Discount__c  + ((con.AMC_Amount_after_Discount__c * 80/100) * con.VAT_Percentage__c/100)  + ((con.AMC_Amount_after_Discount__c * 70/100 ) * con.Tax_Percentage__c/100));                   
        else if(trigger.isInsert && (dt > d))
           con.Total_AMC_Amount__c = (con.AMC_Amount_after_Discount__c  + ((con.AMC_Amount_after_Discount__c * 80/100) * con.VAT_Percentage__c/100)  + ((con.AMC_Amount_after_Discount__c * 70/100 ) * con.Tax_Percentage__c/100));                                         
        else if(trigger.isUpdate && con.CreatedDate < d)
            con.Total_AMC_Amount__c = con.AMC_Amount_after_Discount__c +(con.AMC_Amount_after_Discount__c * con.Tax_Rate__c )/100;
        else if(trigger.isInsert && dt < d)
            con.Total_AMC_Amount__c = con.AMC_Amount_after_Discount__c +(con.AMC_Amount_after_Discount__c * con.Tax_Rate__c );               
        */
        Decimal AmountAfterDiscount = (con.AMC_Amount_after_Discount__c == null?0.0:con.AMC_Amount_after_Discount__c);
        Decimal VatPercentage = (con.VAT_Percentage__c == null?0.0:con.VAT_Percentage__c);        
        Decimal TaxPercentage = (con.Tax_Percentage__c == null?0.0:con.Tax_Percentage__c);                
        
        if( (trigger.isUpdate && ((con.CreatedDate > d) || (con.Activated_Date__c > d)))
            ||
            (trigger.isInsert && (dt > d)) ){
               con.Total_AMC_Amount__c = (AmountAfterDiscount  + ((AmountAfterDiscount * 80/100) * VatPercentage/100)  + ((AmountAfterDiscount * 70/100 ) * TaxPercentage/100));
               //  con.Total_AMC_Amount__c = (AmountAfterDiscount  + ((AmountAfterDiscount * 80/100) * VatPercentage/100));                 
           system.debug('===============hellloo'+con.Total_AMC_Amount__c);    
          }     
        else if ((trigger.isInsert && (dt < d))  
                ||  
                (trigger.isUpdate && ((con.CreatedDate <= d)|| (con.Activated_Date__c <= d)) ))
                {
                   con.Total_AMC_Amount__c = (AmountAfterDiscount  + ((AmountAfterDiscount * 80/100) * VatPercentage/100)  + ((AmountAfterDiscount * 70/100 ) * TaxPercentage/100));   
                   //con.Total_AMC_Amount__c = (AmountAfterDiscount  + ((AmountAfterDiscount * 80/100) * VatPercentage/100));   
                }                                      
            
    }
    
        
}