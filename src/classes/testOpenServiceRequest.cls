@isTest
public class testOpenServiceRequest{
    private static testMethod void TestForOpenServiceRequest(){
        //User u = [Select Id from user where profile.name = 'Call Center' and IsActive = true limit 1];
        
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
      System.runAs(u) {  
        /*Product__c Prod = new Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;*/
        
        Product__c Prod = new Product__c();
        Prod.name = 'Test1';
        Prod.Product_Code__c = '12345';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Prod.CurrencyIsoCode = null;
        Prod.Product_Category__c = 'UPS';
        Prod.Category_Code__c = 'Cat';
        Prod.OwnerId = u.id;
        Prod.No_Of_PM__c = '4';
        insert Prod;
        
         Price_Books__c objPB = new Price_Books__c();
             objPB.Name='Standard Price Book';
             insert objPB;
         
       Price_Book_Entry__c objPBE =new Price_Book_Entry__c();
       objPBE.Product__c=Prod.id;
       objPBE.Price_Book__c=objPB.id;
       objPBE.UnitPrice__c=200;
       insert objPBE;
        
        
       Account acct = new Account(
        name = 'test',
        Customer_ID__c = '0007'
        );
        insert acct; 
    
       Contact cont = new Contact(
            LastName = 'Test Contact1',
            phone = '01122120767',
            MobilePhone = '09988899888',
            email = 'a@b.com',
            AccountId = acct.Id
        );
        
        insert cont;
        
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
        
        Service_Request__c Cas1 = new Service_Request__c();
        Cas1.Origin__c = 'Email';
        Cas1.Contact__c = cont.id;
        Cas1.Product_Serial_No__c = '1001';
        Cas1.Service_Charge_Type__c = 'Visit';
        Cas1.Products__c = Prod.Id;
        Cas1.OwnerId = u.id;
        Cas1.Type_of_Service_Request__c = 'Others';
        Cas1.Status__c = 'New';
        Cas1.AMC_Status__c = 'Yes';
        //Cas1.Product_Code__c = con.Product_Serial_No__c ;
        Cas1.Product_Category__c = 'BATTERY';
        Cas1.Warranty_Status__c = 'No';
        Cas1.Reason__c = 'Reason';
        Cas1.Account__c = acct.id ;
        Cas1.PROBLEM_OBSERVED__c = 'FUSE BROKEN';
        Cas1.Service_Engineer_Assigned__c = objSP.id;
        Cas1.Agent_Name__c = 'MAMTA';
        Cas1.ClosedDate__c = system.today();
        Insert Cas1;
        ApexPages.currentPage().getParameters().put('id',cas1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(cas1);
        OpenServiceRequest csr = new OpenServiceRequest(con);
        
        csr.srObj.Completion_Date_Time__c = system.now();
        csr.srObj.Attended_Date_Time__c =  system.now();   
        csr.srObj.Reason__c =  'SYSTEM DEAD';  
        csr.srObj.Service_Type__c = 'LOCAL - ON SITE';
        csr.srObj.CALL_TYPE__c = 'COMPLAIN END USER';
        csr.srObj.Preferred_Date_for_Visit__c = Date.Today();
        csr.srObj.Warranty_Status__c = 'No';
        csr.srObj.Product_Serial_No__c = '1001';//'PKG-FM-048';
        csr.srObj.Service_Engineer_Assigned__c = objSP.id;
        
        csr.getOptions();
        csr.SelectedStatus = 'ReOpen';
        csr.doSave();
        csr.doCancel();
        Service_Request__c Cas = new Service_Request__c();
        Cas = [Select id, Status__c from Service_Request__c where id=:Cas1.id];
        //system.assertEquals('Closed', cas.Status__c);       
    }
}
}