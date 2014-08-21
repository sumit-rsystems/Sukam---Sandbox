@isTest
public class Test_trgUpdateComponentCharge{
    public static testMethod void getCoverage()
    {
      
        Account objAcc = new Account(
        name = 'test',
        Customer_ID__c = 'ACC-1001'
        );
        insert objAcc;
        
      Contact cont = new Contact(
            LastName = 'Test Contact1',
            phone = '01122120767',
            MobilePhone = '09988899888',
            email = 'a@b.com',
            AccountId = objAcc.Id
        );
        insert cont;  
        
       Product__c Prod1 = new Product__c();
        Prod1.name = 'Test1';
        Prod1.Product_Code__c = '12345';
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Prod1.CurrencyIsoCode = null;
        insert Prod1;
       
        Price_Books__c objPB = new Price_Books__c();
             objPB.Name='Standard Price Book';
             insert objPB;
         
       Price_Book_Entry__c objPBE =new Price_Book_Entry__c();
       objPBE.Product__c=Prod1.id;
       objPBE.Price_Book__c=objPB.id;
       objPBE.UnitPrice__c=200;
       insert objPBE;
        
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
             ProfileId = [select id, Name from Profile where Name = 'Service Center'].id
         );       
        
        insert u; 
        
        
        User uuu = new User(
             Alias =  'alia1', 
             Email = 'test1@sk.com',
             EmailEncodingKey = 'UTF-8', 
             LanguageLocaleKey = 'en_US', 
             LocalesIdKey = 'en_US', 
             TimeZonesIdKey = 'America/Los_Angeles',
             Username = 'test1@sk.com',
             LastName = 'lname1',
             CommunityNickname = 'cname1',
             ProfileId = [select id, Name from Profile where Name = 'Service Center'].id
         );       
        
        insert uuu;
        
        User uu = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1]; 
        
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Center');
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
      insert objSP;
      
      Stock_Point__c objSP2 = new Stock_Point__c();
      objSP2.RecordTypeId = stockId;
      objSP2.OwnerId = uu.Id;
      objSP2.Name = 'XYZ';
      objSP2.Service_Center_Description__c = 'TestCenter1';
      objSP2.Service_Center_Address__c = 'Address12';
      objSP2.Service_Center_Location_Code__c = '044-';
      objSP2.DESIGNATION__c = 'HELPER';
      objSP2.Service_Engineer_Id__c = 'H900114';
      objSP2.Region__c = 'CENTRAL';
      objSP2.Branch__c ='LUCKNOW';
      insert objSP2;
      
      
        Current_Inventory_Component__c  cic1 = new Current_Inventory_Component__c ();
        cic1.Component__c = Prod1.id;
        cic1.Component_code__c = '12345';
        cic1.Name = 'test';
        cic1.Usable_Quantity_in_Hand__c = 200;
        cic1.Stock_Point__c = objSP.id;
        cic1.Defective_Quantity_in_Hand__c = 100;
        cic1.Cost_Unit__c = 50;
        insert cic1;
        
        
        Current_Inventory_Component__c  cic2 = new Current_Inventory_Component__c ();
        cic2.Component__c = Prod1.id;
        cic2.Component_code__c = '12345';
        cic2.Name = 'test';
        cic2.Usable_Quantity_in_Hand__c = 200;
        cic2.Stock_Point__c = objSP2.id;
        cic2.Defective_Quantity_in_Hand__c = 100;
        cic2.Cost_Unit__c = 50;
        insert cic2;
      
      
      Service_Request__c objSr = new Service_Request__c();
      objSr.Account__c = objAcc.id;
      objSr.Status__c = 'New';
      objSr.Reason__c = 'xyz';
      objSr.Origin__c = 'dfdf';
      objSr.Warranty_Status__c = 'no';
      objSr.Products__c = Prod1.id;
      objSr.Product_Category__c = 'sdfdsf';
      
      
      
      
       Schema.DescribeSObjectResult cc = Schema.SObjectType.Component_Movement_Table__c;
       Map<String,Schema.RecordTypeInfo> cmtrtMapp = cc.getRecordTypeInfosByName();
       Schema.RecordTypeInfo cmtrtByNamee ;
      
      Component_Movement_Table__c objCMT = new Component_Movement_Table__c();
        //objCMT.Product_Code_1__c = '1001';
        objCMT.CurrencyIsoCode = null;
        objCMT.Date__c=system.today();
        objCMT.RecordTypeId = cmtrtMapp.get('Inward Movement').getRecordTypeId();
        objCMT.Type_of_receipt__c = 'Stock Transfer';//'Stock Returned by Service Engineer';//'Stock Transfer';
        objCMT.Component_Status__c = 'Usable';
        objCMT.Select_Component__c = Prod1.Id;
        objCMT.Quantity__c = 10;
        objCMT.OwnerID=uu.id;
        objCMT.trgOldOwnerId__c = u.id;
        objCMT.Challan_No_Trig__c = 12;
        objCMT.Service_Request__c = objSr.id;
        //objCMT.Received_from_Stock_Point__c  = objSP.id;
        objCMT.Discount_in_component_charge__c = 10;
        objCMT.Misc_Component_Charges__c = 5;
        objCMT.Transferred_to_Stock_Point__c = objSP2.Id; 
        objCMT.Stock_Point_Type__c = 'Service Engineer'; 
        
        objCMT.Received_from_Stock_Point__c = objSP.Id;
        objCMT.Stock_Point_to_be_Reconciled__c = objSP2.Id;
        objCMT.Service_Engineer_Assigned__c = objSP.id;
    
      insert objCMT;
      
      Component_Movement_line_Item__c objCMLI = new Component_Movement_line_Item__c();
      objCMLI.CurrencyIsoCode = null;
      objCMLI.Select_Component__c = Prod1.id;
      objCMLI.VAT_Percent__c =1;
      objCMLI.Misc_Component_Charges__c = 1;
      objCMLI.Quantity__c = 1;
      objCMLI.Component_Movement_Table__c = objCMT.id;
      objCMLI.Stock_Transfer_Price_Unit__c = 1;
      insert objCMLI;
      update objCMLI;
    }


}