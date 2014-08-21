global class CreateCallOnContract implements Database.Batchable<SObject>{
    global Database.QueryLocator start(Database.BatchableContext bi){
        //Date AMCStartDate_FirstQtr = System.Today().addMonths(-3);
        //return Database.getQueryLocator([Select id,Service_Engineer_Ass__c,Account_Name__c,Start_Date__c,ERP_Start_Date__c,ERP_End_Date__c,ERP_Activated_Date__c,Products__c,Product_Category__c,Product_Serial_No__c,Total_Maintenance__c,Contract_Term__c,Maintenance_Done__c from Contracts__c where Status__c =:'Activated' and Due_Maintenance_Date__c =: System.Today()]);
        return Database.getQueryLocator([Select id,Service_Engineer_Ass__c,Account_Name__c,Start_Date__c,ERP_Start_Date__c,ERP_End_Date__c,ERP_Activated_Date__c,Products__c,Product_Category__c,Product_Serial_No__c,Total_Maintenance__c,Contract_Term__c,Maintenance_Done__c,Next_Maintenance_Date__c from Contracts__c where  Next_Maintenance_Date__c =: System.Today()]);
    }

    global void execute(Database.BatchableContext bi, List<sObject> scope){
     if(scope.size()>0)
     {
       List<Contracts__c> contractList = (List<sObject>)scope; 
       List<Service_Request__c> lstSR = new List<Service_Request__c>();
       List<Contracts__c> lstUpdateContract = new List<Contracts__c>();
       for(Contracts__c con : contractList)
       {
         integer TotalMaintenance = Integer.valueOf(con.Contract_Term__c * con.Total_Maintenance__c / 12) ; 
         if(Integer.valueOf(con.Maintenance_Done__c) < TotalMaintenance)
         {
             Service_Request__c objSR = new Service_Request__c();
             objSR.Account__c = con.Account_Name__c;
             objSR.Status__c = 'New';
             objSR.Origin__c = 'Web';
             objSR.Reason__c = '038 - AMC VISIT';
             objSR.Warranty_Status__c = 'No';
             objSR.Products__c = con.Products__c;
             objSR.Product_Category__c = con.Product_Category__c;
             //objSR.Product_Code__c = con.Product_Serial_No__c ;
             objSR.Service_Engineer_Assigned__c = con.Service_Engineer_Ass__c;
             objSR.Complain_Type__c = 'ADDITIONAL SERVICE';
             objSR.CALL_TYPE__c = 'PM VISIT';
             objSR.AMC_Status__c = 'Yes';
             objSR.Warranty_Status__c = 'No';
             lstSR.add(objSR);
                  
             if(Integer.valueOf(con.Total_Maintenance__c) == 4 )
             {
               con.Next_Maintenance_Date__c =con.Next_Maintenance_Date__c.addMonths(3);
               date dObj =date.newInstance(con.Next_Maintenance_Date__c.year(),con.Next_Maintenance_Date__c.month(),con.Next_Maintenance_Date__c.day());
               con.Next_Maintenance_Date__c =  dObj ;
               con.Maintenance_Done__c  = con.Maintenance_Done__c + 1;
               lstUpdateContract.add(con);
             }
             if(Integer.valueOf(con.Total_Maintenance__c) == 3 )
             {
               con.Next_Maintenance_Date__c = con.Next_Maintenance_Date__c.addMonths(4);
               date dObj =date.newInstance(con.Next_Maintenance_Date__c.year(),con.Next_Maintenance_Date__c.month(),con.Next_Maintenance_Date__c.day());
               con.Next_Maintenance_Date__c =  dObj ;
               con.Maintenance_Done__c  = con.Maintenance_Done__c + 1;
               lstUpdateContract.add(con);
             }
             if(Integer.valueOf(con.Total_Maintenance__c) == 2 )
             {
               con.Next_Maintenance_Date__c = con.Next_Maintenance_Date__c.addMonths(6);
               date dObj =date.newInstance(con.Next_Maintenance_Date__c.year(),con.Next_Maintenance_Date__c.month(),con.Next_Maintenance_Date__c.day());
               con.Next_Maintenance_Date__c =  dObj ;
               con.Maintenance_Done__c  = con.Maintenance_Done__c + 1;
               lstUpdateContract.add(con);
             }
             if(Integer.valueOf(con.Total_Maintenance__c) == 1 )
             {
               con.Next_Maintenance_Date__c = con.Next_Maintenance_Date__c.addMonths(12);
               date dObj =date.newInstance(con.Next_Maintenance_Date__c.year(),con.Next_Maintenance_Date__c.month(),con.Next_Maintenance_Date__c.day());
               con.Next_Maintenance_Date__c =  dObj ;
               con.Maintenance_Done__c  = con.Maintenance_Done__c + 1;
               lstUpdateContract.add(con);
             }
         }
       }
       try
       {
          if(lstSR != null && lstSR.size() > 0) 
          insert lstSR;
          update lstUpdateContract;
       }
       catch(Exception e)
       {
         System.debug('--- Error Message ---' + e.getMessage());
       }
      } 
    }
    global void finish(Database.BatchableContext bi){       
    }
}