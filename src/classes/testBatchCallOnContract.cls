@isTest
//@isTest(SeeAllData=false)
private class testBatchCallOnContract {

    static testmethod void test() {

        
        
       // List<Contracts__c>lstCon = [Select id,Service_Engineer_Ass__c,Account_Name__c,Start_Date__c,ERP_Start_Date__c,ERP_End_Date__c,ERP_Activated_Date__c,Products__c,Product_Category__c,Product_Serial_No__c from Contracts__c where Status__c =:'Activated' and (Start_Date__c =: AMCStartDate_FirstQtr or Start_Date__c =: AMCStartDate_SecondQtr or Start_Date__c =: AMCStartDate_ThirdQtr  or Start_Date__c =: AMCStartDate_FourthQtr)];

        
      //User u = [Select Id,Stock_Point__c from user where profile.name = 'CRM Branch User'  limit 1];
      User u = new User(
             Alias =  'alia', 
             Email = 'test@sk.com',
             EmailEncodingKey = 'UTF-8', 
             LanguageLocaleKey = 'en_US', 
             LocalesIdKey = 'en_US', 
             TimeZonesIdKey = 'America/Los_Angeles',
             Username = 'test@sk.com',
             LastName = 'lname',
             CommunityNickname = 'cname',
             Stock_Point__c = '033-',
             ProfileId = [select id, Name from Profile where Name = 'System Administrator'].id
         );       
        
        insert u;
       
        System.runAs(u) {
        
        Product__c Prod1 = new Product__c();
        Prod1.name = 'Test1';
        Prod1.Product_Code__c = '12345';
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Prod1.CurrencyIsoCode = null;
        Prod1.Product_Category__c = 'UPS';
        Prod1.Category_Code__c = 'Cat';
        Prod1.OwnerId = u.id;
        Prod1.No_Of_PM__c = '4';
        insert Prod1;
        
        Price_Books__c objPB = new Price_Books__c();
             objPB.Name='Standard Price Book';
             insert objPB;
         
       Price_Book_Entry__c objPBE =new Price_Book_Entry__c();
       objPBE.Product__c=Prod1.id;
       objPBE.Price_Book__c=objPB.id;
       objPBE.UnitPrice__c=200;
       insert objPBE;
       
       Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Engineer');
        Id stockId = rtByName.getRecordTypeId();
        
          Stock_Point__c objSP = new Stock_Point__c();
          objSP.RecordTypeId = stockId;
          objSP.OwnerId = u.Id;
          objSP.Name = 'XYZ';
          objSP.Service_Center_Description__c = 'TestCenter1';
          objSP.Service_Center_Address__c = 'Address1';
          objSP.Service_Center_Location_Code__c = '033-';
          objSP.DESIGNATION__c = 'HELPER';
          objSP.Service_Engineer_Id__c = 'H900113';
          objSP.Region__c = 'CENTRAL';
          objSP.Branch__c ='LUCKNOW';
          objSP.Active__c = true;
          insert objSP;
            
        Service_Centre_City__c objSCC = new Service_Centre_City__c();
        objSCC.Name = 'Agra';
        objSCC.State__c = 'Uttar Pradesh';
        objSCC.District__c = 'Agra';    
        objSCC.Service_Center__c = 'Agra';
        objSCC.OwnerId = u.id;
        insert objSCC;
            
            
        Account objAcc = new Account();
        objAcc.Name = 'Suresh';
        objAcc.State__c = 'Uttar Pradesh';
        objAcc.District__c = 'Agra';    
        objAcc.City__c = objSCC.id;
        objAcc.Phone = '01122120766';
        objAcc.Mobile_No__c = '9911334423';
        //objAcc.Country__c = 'India';
        objAcc.OwnerId = u.id;
        insert objAcc;
        
        Contact cont = new Contact(
            LastName = 'Test Contact1',
            phone = '01122120767',
            MobilePhone = '09988899888',
            email = 'a@b.com',
            AccountId = objAcc.Id
        );
        
        insert cont;
        
        List<Contracts__c> lstContract = new List<Contracts__c>(); 
        for(integer i=0;i<5;i++)
        {
          Contracts__c objCon = new Contracts__c();
          //objCon.Service_Engineer_Ass__c =objSP.id;
          objCon.Start_Date__c = System.Today();
          objCon.Products__c = Prod1.id;//objProd.id;
          //objCon.Product_Category__c = Prod1.Product_Category__c ;
          objCon.Product_Serial_No__c = '12345';
          objCon.Service_Engineer_Ass__c = objSP.id;
          objCon.Product_Quantity__c = 1;
          objCon.Account_Name__c = objAcc.id;
          objCon.OwnerId = u.id;
          objCon.Total_Maintenance__c = 4;
          objCon.Maintenance_Done__c = 0;
          objCon.Next_Maintenance_Date__c = System.Today();
          lstContract.add(objCon);
        }
        insert lstContract ;
        //system.assertNotEquals(lstContract.size(),0);
    
         List<Service_Request__c> lstSR = new List<Service_Request__c>();
         for(Contracts__c con : lstContract)
         {
             Service_Request__c objSR = new Service_Request__c();
             objSR.Account__c = objAcc.id ;//objCon.Account_Name__c;
             objSR.Status__c = 'xyz';
             objSR.Origin__c = 'Phone';
             objSR.Reason__c = 'Reason';
             objSR.Warranty_Status__c = 'No';
             objSR.Products__c = con.Products__c;
             objSR.Product_Category__c = 'BATTERY';//objCon.Product_Category__c;
             objSR.Product_Code__c = con.Product_Serial_No__c ;
             //objSR.Service_Engineer_Assigned__c = objSP.id;
             objSR.Product_Serial_No__c = '12345678900';
             objSR.OwnerId = u.id;
             objSR.AMC_Status__c = 'Yes';
             objSR.Contact__c = cont.id;
             objSR.Service_Charge_Type__c = 'Visit';
             objSR.Type_of_Service_Request__c = 'Others';
             
             lstSR.add(objSR);
         }
         insert lstSR;
         //system.assertNotEquals(lstSR.size(),0);
         update lstContract;
    
    
       Test.startTest();
       CreateCallOnContract c = new CreateCallOnContract();
       ID batchprocessid = Database.executeBatch(c);
       Database.BatchableContext aa;
       c.start(aa);
       //c.execute(aa, [Select id,Service_Engineer_Ass__c,Account_Name__c,Start_Date__c,ERP_Start_Date__c,ERP_End_Date__c,ERP_Activated_Date__c,Products__c,Product_Category__c,Product_Serial_No__c,Total_Maintenance__c,Contract_Term__c,Maintenance_Done__c,Next_Maintenance_Date__c from Contracts__c where  Next_Maintenance_Date__c =: System.Today()]);
       c.execute(aa, lstContract);
       c.finish(aa);
         
       ScheduleCreateCallOnContract batch1 = new ScheduleCreateCallOnContract(); 
       SchedulableContext SCt ;
       batch1.execute(SCt);
       Test.stopTest();
     }
    }
}