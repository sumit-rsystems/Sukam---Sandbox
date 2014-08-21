@isTest
public class Test_ScrapSalesClass{
    
        static Schema.DescribeSObjectResult c = Schema.SObjectType.Stock_Point__c;
        static Map<String,Schema.RecordTypeInfo> cmtrtMap = c.getRecordTypeInfosByName();
        
        static Schema.DescribeSObjectResult c1 = Schema.SObjectType.Component_Movement_Table__c;
        static Map<String,Schema.RecordTypeInfo> cmtrtMap1 = c1.getRecordTypeInfosByName();
        
        public static testMethod void getCoverage(){
          //try{
        User u = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        
        Stock_Point__c StockPt1 = new Stock_Point__c();
        StockPt1.RecordTypeId = cmtrtMap.get('Service Center').getRecordTypeId();  //[Select Id from RecordType where Name = 'Service Center' And SObjectType = 'Stock_Point__c'].Id;
        StockPt1.Service_Engineer_Name__c = 'TestEngineer1';
        StockPt1.ownerId = u.Id;
        StockPt1.Name = 'PARWEZ ALAM';
        StockPt1.Service_Center_Location_Code__c='051-SC-PATNA';
        StockPt1.Service_Engineer_Id__c = 'P900257';
        Insert StockPt1;
        
       
            
        Current_Inventory_Component__c CurrentStock = new Current_Inventory_Component__c();
        CurrentStock.Name = 'Test';
        CurrentStock.Defective_Quantity_in_Hand__c = 45;
        CurrentStock.Usable_Quantity_in_Hand__c = 2;
        CurrentStock.Component_Code__c = '1001';
        CurrentStock.Stock_Point__c= StockPt1.Id;
        insert CurrentStock;
        
        Product__c Prod = new  Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Prod.Product_Category__c = 'COMPONENT';
        Insert Prod;
        
         //Rajni jain
            Stock_Point__c ServiceEngineer = new Stock_Point__c();
            ServiceEngineer.RecordTypeId = cmtrtMap.get('Service Engineer').getRecordTypeId();  //[Select Id from RecordType where Name = 'Service Engineer' And SObjectType = 'Stock_Point__c'].Id;             
            ServiceEngineer.Service_Center_Description__c = 'TestEngineer';
            ServiceEngineer.Service_Center_Address__c = 'Address22';
            ServiceEngineer.Service_Center_Location_Code__c = '022';            
            Insert ServiceEngineer;
        //Rajni jain
        
         Service_Request__c Cas = new Service_Request__c();  
            Cas.Origin__c = 'Email';  
            Cas.Product_Serial_No__c = '0101';
            Cas.Service_Engineer_Assigned__c = ServiceEngineer.Id;
            Cas.Status__c = 'Open'; 
            cas.Product_Code__c = '1001';
            cas.Product_Category__c = 'COMPONENT';
            cas.Products__c = 'a04O0000004nwda';          
            Insert Cas;
        
        Id InwardMovementRecordTypeId = cmtrtMap1.get('Inward Movement').getRecordTypeId(); //[Select Id from RecordType where Name = 'Inward Movement' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
        
         /*Component_Movement_Table__c CompMove1 = new Component_Movement_Table__c();
            CompMove1.RecordTypeId = InwardMovementRecordTypeId;
            CompMove1.Type_of_receipt__c = 'Stock Transfer';
            CompMove1.Component_Status__c = 'Usable';
            CompMove1.Quantity__c = 10;
            CompMove1.OwnerID=u.id;
            CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            CompMove1.Service_Request__c = Cas.id;
            CompMove1.trgOldOwnerId__c = u.id;
            Insert CompMove1;*/
            
            
            Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Center');
        Id stockId = rtByName.getRecordTypeId();
            
        User uu = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        
        Product__c Prod1 = new Product__c();
        Prod1.name = 'Test1';
        Prod1.Product_Code__c = '12345';
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Prod1.CurrencyIsoCode = null;
        insert Prod1;     
        
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
            
       Schema.DescribeSObjectResult cc = Schema.SObjectType.Component_Movement_Table__c;
       Map<String,Schema.RecordTypeInfo> cmtrtMapp = cc.getRecordTypeInfosByName();
       Schema.RecordTypeInfo cmtrtByNamee ;
         
        Component_Movement_Table__c CompMove1= new Component_Movement_Table__c();
        CompMove1.CurrencyIsoCode = null;
        CompMove1.Date__c=system.today();
        CompMove1.RecordTypeId = cmtrtMapp.get('Inward Movement').getRecordTypeId();
        CompMove1.Type_of_receipt__c = 'Stock Transfer';
        CompMove1.Component_Status__c = 'Usable';
        CompMove1.Select_Component__c = Prod1.Id;
        CompMove1.Quantity__c = 10;
        CompMove1.OwnerID=uu.id;
        CompMove1.trgOldOwnerId__c = u.id;
        CompMove1.Challan_No_Trig__c = 12;
        CompMove1.Service_Request__c = Cas.id;
        CompMove1.Discount_in_component_charge__c = 10;
        CompMove1.Misc_Component_Charges__c = 5;
        CompMove1.Transferred_to_Stock_Point__c = StockPt1.Id; 
        CompMove1.Stock_Point_Type__c = 'Service Engineer'; 
        
        CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
        CompMove1.Stock_Point_to_be_Reconciled__c = objSP2.Id;
        CompMove1.Service_Engineer_Assigned__c = StockPt1.id;
    
      insert CompMove1;
         
         
            
            
        
        Stock_Point__c sp1= new Stock_Point__c();
        sp1.RecordTypeId = cmtrtMap.get('Vendors').getRecordTypeId();  //[Select Id from RecordType where Name = 'Service Center' And SObjectType = 'Stock_Point__c'].Id;
        sp1.Service_Engineer_Name__c = 'TestEngineer2';
        sp1.ownerId = u.Id;
        sp1.Name = 'PARVIK ALAM';
        sp1.Service_Center_Location_Code__c='051-SC-PATNA';
        sp1.Service_Engineer_Id__c = 'P900257';
        sp1.CST_Interstate__c = 10;
        sp1.CST_within_State__c = 10;
        sp1.TCS__c = 10;
        Insert sp1;
            
        List<Scrap_del__c> scrpList = new List<Scrap_del__c>();
        
           Scrap_del__c  sd = new Scrap_del__c (
           Name = 'aa',
           Type_of_Scrap__c  = 'Battery Scrap',
           Purchaser_Name__c ='nn',
           Purchaser_Type__c = 'Unregistered',
           Purchaser_Address__c = 'sss',
           Select_Item_1__c = Prod.id,
           Rate_1__c = 123,
           Sale_Location_Type__c = 'Interstate',
           Purchaser_Billing_State__c ='delhi',
           Quantity_1__c = 10,   
           Purchaser_TIN_No__c ='test',
           Document_Invoice_No__c = 'testnew',
           Scrap_Approval_Status__c = 'Approved',
           ownerId = u.Id,
           Service_Engineer_Assigned__c = sp1.Id,
           TCS__c = 2 ,
           Bill_Date__c = System.today()           
        );
        insert sd;
        
        ///Rajni jain
        Map<Id, Double> QtyMap = new Map<Id, Double>();
        QtyMap.put(sd.Select_Item_1__c, sd.Quantity_1__c);
        
        InventoryUpdate InvUpd = new InventoryUpdate();        
        InvUpd.SetSCCode(u.id);    
        InvUpd.SetTRCMrnNo(CompMove1);
        InvUpd.SetChallanNo(CompMove1);
        InvUpd.SetStockTransferSlNo(CompMove1,u.id);
        //InvUpd.SendTRCReceiptEmail(QtyMap,CompMove1, new List< Product__c>{Prod});
        InvUpd.RepairbyOwner('Test', '1001', u.id,10 );
        InvUpd.CheckScrapStockAvailability('Test', '1001', u.id,10 );         
        InvUpd.CalculateTotalComponentCharges(CompMove1);
        CompMove1.Transferred_to_Stock_Point__c =StockPt1.id ;
        update CompMove1;        
        InvUpd.SetNewOwner(CompMove1);             
        Double Difference = 0;
        InvUpd.CalculateTotalUsedAndDefective(CompMove1,Difference);
        
        //SetTRCMrnNo - else part
        //SetChallanNo - else part          
        
        InvUpd.ReceivebyStockPointId('Test', '1001',StockPt1.Id ,'Defective',5,10);
        
        //CompMove1.trgOldOwnerId__c = u.id;update CompMove1;
        //InvUpd.SetSharing(CompMove1);
        
        
        System.debug('====sd===' +sd);
        scrpList.add(sd);
        System.debug('====scrpList===' +scrpList);
        
        ScrapSalesClass obj = new ScrapSalesClass ();
        obj.ScrapSalesUpdate(sd);
        
        update sd;
        
    }
    
    
}