@isTest
public class Test_InventoryUpdate{
        
             
   
    public static testMethod void getCoverage(){
    
        Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName ;
       
        
        Schema.DescribeSObjectResult c = Schema.SObjectType.Component_Movement_Table__c;
        Map<String,Schema.RecordTypeInfo> cmtrtMap = c.getRecordTypeInfosByName();
        Schema.RecordTypeInfo cmtrtByName ;
        
        User u = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        User use = [Select Id from user where  IsActive = true limit 1];
        
        Stock_Point__c StockPt1 = new Stock_Point__c();
        
        StockPt1.RecordTypeId = rtMapByName.get('Service Center').getRecordTypeId();
        StockPt1.Service_Engineer_Name__c = 'TestEngineer1';
        StockPt1.ownerId = u.Id;
        StockPt1.Name = 'PARWEZ ALAM';
        StockPt1.Service_Center_Location_Code__c='051-SC-PATNA';
        StockPt1.Service_Engineer_Id__c = 'P900257';
        Insert StockPt1;
        
        Stock_Point__c StockPt2 = new Stock_Point__c();
        
        
        StockPt2.Service_Engineer_Name__c = 'TestEngineer1';
        StockPt2.ownerId = u.Id;
        StockPt2.Name = 'PARWEZ ALAM';
        StockPt2.Service_Center_Location_Code__c='051-SC-PATNA';
        StockPt2.Service_Engineer_Id__c = 'P900257';
        Insert StockPt2;
       
            
        Current_Inventory_Component__c CurrentStock = new Current_Inventory_Component__c();
        CurrentStock.Name = 'Test';
        CurrentStock.Defective_Quantity_in_Hand__c = 45;
        CurrentStock.Usable_Quantity_in_Hand__c = 20;
        CurrentStock.Component_Code__c = '1001';
        CurrentStock.Stock_Point__c= StockPt1.Id;
        CurrentStock.OwnerId = u.id;
        insert CurrentStock;
        
        Current_Inventory_Component__c CurrentStock1 = new Current_Inventory_Component__c();
        CurrentStock1.Name = 'Test';
        CurrentStock1.Component_Code__c = '1001';
        CurrentStock1.Stock_Point__c= StockPt1.Id;
        CurrentStock1.OwnerId = u.id;
        insert CurrentStock1;
        
        Current_Inventory_Component__c CurrentStock2 = new Current_Inventory_Component__c();
        CurrentStock2.Name = 'Test';
        CurrentStock2.Component_Code__c = '1001';
        CurrentStock2.Stock_Point__c= StockPt2.Id;
        CurrentStock2.OwnerId = u.id;
        insert CurrentStock2;
        
        
        Product__c Prod = new  Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        Set<Id> pid = new Set<Id>();
        pid.add(Prod.id);
        
         //Rajni jain
            Stock_Point__c ServiceEngineer = new Stock_Point__c();
            
            serviceEngineer.RecordTypeId = rtMapByName.get('Service Engineer').getRecordTypeId();           
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
            Cas.Service_Bill_No__c = 'ss';
            Cas.Products__c = Prod.id;          
            Insert Cas;
        
       // Id InwardMovementRecordTypeId = [Select Id from RecordType 
            //     where Name = 'Inward Movement' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
            
            
            
         Component_Movement_Table__c CompMove1 = new Component_Movement_Table__c();
             
            CompMove1.RecordTypeId = cmtrtMap.get('Inward Movement').getRecordTypeId();
            CompMove1.Type_of_receipt__c = 'Stock Transfer';
            CompMove1.Component_Status__c = 'Usable';
            CompMove1.Select_Component__c = Prod.Id;
            CompMove1.Quantity__c = 10;
            CompMove1.OwnerID=u.id;
          //  CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            //CompMove1.Service_Request__c = Cas.id;
            CompMove1.trgOldOwnerId__c = u.id;
            CompMove1.Mrn_No_Trig__c = 12;
            CompMove1.OwnerId = u.id;
            CompMove1.Challan_No_Trig__c = 12;
            CompMove1.Product_Code_1__c = '1001';
           // compMove1.Mrn_No__c = '101010';
           // compMove1.Stock_Transfer_Sl_No__c = '1234';
            
            Insert CompMove1;
            //}catch(Exception e){}
            
             Price_Books__c pb = new Price_Books__c();
             pb.Name='Standard Price Book';
             insert pb;
         
           Price_Book_Entry__c pbe =new Price_Book_Entry__c();
           pbe.Product__c=prod.id;
           pbe.Price_Book__c=pb.id;
           pbe.UnitPrice__c=200;
           
           insert pbe;
            
        Component_Movement_Table__c CompMove2 = new Component_Movement_Table__c();
             
            CompMove2.RecordTypeId = cmtrtMap.get('Inward Movement').getRecordTypeId();
            CompMove2.Type_of_receipt__c = 'Stock Transfer';
            CompMove2.Component_Status__c = 'Usable';
            CompMove2.Select_Component__c = Prod.Id;
            CompMove2.Quantity__c = 10;
            CompMove2.OwnerID=CompMove1.id;
          //  CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            //CompMove1.Service_Request__c = Cas.id;
            CompMove2.trgOldOwnerId__c = u.id;
            CompMove2.Mrn_No_Trig__c = 12;
            CompMove2.OwnerId = u.id;
            CompMove2.Challan_No_Trig__c = 12;
            CompMove2.Product_Code_1__c = '1001';
           // compMove1.Mrn_No__c = '101010';
           // compMove1.Stock_Transfer_Sl_No__c = '1234';
            
            Insert CompMove2;    
            
             Component_Movement_Table__c CompMove3 = new Component_Movement_Table__c();
             
            CompMove3.RecordTypeId = cmtrtMap.get('Inward Movement').getRecordTypeId();
            CompMove3.Type_of_receipt__c = 'Stock Transfer';
            CompMove3.Component_Status__c = 'Usable';
            CompMove3.Select_Component__c = Prod.Id;
            CompMove3.Quantity__c = 10;
            CompMove3.OwnerID=CompMove1.id;
          //  CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            //CompMove1.Service_Request__c = Cas.id;
            CompMove3.trgOldOwnerId__c = u.id;
            
            CompMove3.OwnerId = u.id;
            CompMove3.Challan_No_Trig__c = 12;
            CompMove3.Product_Code_1__c = '1001';
           // compMove1.Mrn_No__c = '101010';
           // compMove1.Stock_Transfer_Sl_No__c = '1234';
            
            Insert CompMove3;    
            
            Component_Movement_Table__Share Share = new Component_Movement_Table__Share();       

            Share.parentId = CompMove1.Id;

            Share.UserorGroupId = u.id;

            Share.AccessLevel = 'Read';

            //Insert Share;   
            
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
           Purchaser_TIN_No__c ='1212018',
           Document_Invoice_No__c = '1212018',
           Scrap_Approval_Status__c = 'Approved',
           ownerId = u.Id,
           TCS__c = 2,
           Bill_Date__c = System.today() 
        );
        insert sd;
        
        InventoryUpdate inv = new InventoryUpdate();
        inv.AddbyStockPointId('Test', '1001',ServiceEngineer.id, 'Usable',5); 
        inv.SubtractbyStockPointId(StockPt1.id, '1001','Usable', 10 );
        
        //inv.SubtractExistingRecord(CurrentStock,'Usable', 5);
        inv.SubtractbyOwner(u.id,'1001','Usable', 10 );
        inv.CheckScrapStockAvailability('Test','1001', u.id, 20 );
        //inv.SetTRCMrnNo(CompMove1);
        inv.SetChallanNo(CompMove1);
        //inv.SetMrnNo(CompMove1);
        inv.SetStockTransferSlNo(CompMove1,u.id);
        inv.SetStockTransferSlNo (CompMove1,use.id);
        //inv.PopulateStockTransferPrice(CompMove1,pid);
        ///inv.SendTRCReceiptEmail();
        Map<Id, Double> testMap = new  Map<Id, Double>();
        testMap.put(Prod.id ,1199);
        List<Product__c> products = new List<Product__c>();
        products.add(prod);
        //inv.SendTRCReceiptEmail(testMap, CompMove1, products);
        inv.ReceivebyStockPointId('test', '1001', StockPt1.id, 'Usable', 10,10 );
        inv.ReceivebyStockPointId('test', '2002', StockPt1.id, 'Usable', 10,10 );
        inv.SetTRCMrnNo(CompMove2);
        inv.SetTRCMrnNo(CompMove3);
        inv.SetNewOwner(CompMove2);
        //inv.SetSharing(Share);
    }
    
    // Varsha Tomar - 15/08/2012
   /* public static testmethod void increasecoverage() {
    
        Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName ;
       
        
        Schema.DescribeSObjectResult c = Schema.SObjectType.Component_Movement_Table__c;
        Map<String,Schema.RecordTypeInfo> cmtrtMap = c.getRecordTypeInfosByName();
        Schema.RecordTypeInfo cmtrtByName ;
        
        User u = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        
        Stock_Point__c StockPt1 = new Stock_Point__c();
        StockPt1.RecordTypeId = rtMapByName.get('Service Center').getRecordTypeId(); // [Select Id from RecordType where Name = 'Service Center' And SObjectType = 'Stock_Point__c'].Id;
        StockPt1.Service_Engineer_Name__c = 'TestEngineer1';
        StockPt1.ownerId = u.Id;
        StockPt1.Name = 'PARWEZ ALAM';
        StockPt1.Service_Center_Location_Code__c='051-SC-PATNA';
        StockPt1.Service_Engineer_Id__c = 'P900257';
        Insert StockPt1;
        
       
        Product__c Prod = new  Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        
         
        Stock_Point__c ServiceEngineer = new Stock_Point__c();
        
        ServiceEngineer.RecordTypeId = rtMapByName.get('Service Engineer').getRecordTypeId();
        ServiceEngineer.Service_Center_Description__c = 'TestEngineer';
        ServiceEngineer.Service_Center_Address__c = 'Address22';
        ServiceEngineer.Service_Center_Location_Code__c = '022';            
        Insert ServiceEngineer;
        
        
         Service_Request__c Cas = new Service_Request__c();  
            Cas.Origin__c = 'Email';  
            Cas.Product_Serial_No__c = '0101';
            Cas.Service_Engineer_Assigned__c = ServiceEngineer.Id;
            Cas.Products__c = Prod.id;
            Cas.Status__c ='Open';            
            Insert Cas;
        //Id InwardMovementRecordTypeId1 = [Select Id from RecordType 
          //       where Name = 'Inward Movement' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
        
            
            
         Component_Movement_Table__c CompMove1 = new Component_Movement_Table__c();
            CompMove1.RecordTypeId =  cmtrtMap.get('Inward Movement').getRecordTypeId();
            CompMove1.Type_of_receipt__c = 'Stock Transfer';
            CompMove1.Component_Status__c = 'Usable';
            CompMove1.Select_Component__c = Prod.Id;
            CompMove1.Quantity__c = 10;
            CompMove1.OwnerID=u.id;
            CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            CompMove1.Service_Request__c = Cas.id;
            CompMove1.trgOldOwnerId__c = u.id;
            Insert CompMove1;
            
       // Id InwardMovementRecordTypeId2 = [Select Id from RecordType 
            //     where Name = 'Outward Movement' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
            
            Component_Movement_Table__c CompMove2 = new Component_Movement_Table__c();
            CompMove2.RecordTypeId = cmtrtMap.get('Outward Movement').getRecordTypeId();
            CompMove2.Type_of_receipt__c = 'Stock Transfer';
            CompMove2.Component_Status__c = 'Usable';
            CompMove2.Select_Component__c = Prod.Id;
            CompMove2.Quantity__c = 10;
            CompMove2.OwnerID=u.id;
            CompMove2.Received_from_Stock_Point__c = StockPt1.Id;
            CompMove2.Service_Request__c = Cas.id;
            CompMove2.trgOldOwnerId__c = u.id;
            CompMove2.Transferred_to_Stock_Point__c = StockPt1.Id;
             try{
            Insert CompMove2;
            CompMove2.Stock_Transfer_Status__c = 'Received';
           
            update CompMove2;
            }catch(Exception e){}
        Component_Movement_Table__c CompMove3 = new Component_Movement_Table__c();
            CompMove3.RecordTypeId = cmtrtMap.get('Outward Movement').getRecordTypeId();
            CompMove3.Type_of_receipt__c = 'Stock Transfer';
            CompMove3.Component_Status__c = 'Open';
            CompMove3.Select_Component__c = Prod.Id;
            CompMove3.Quantity__c = 0;
            CompMove3.OwnerID=u.id;
            CompMove3.Received_from_Stock_Point__c = StockPt1.Id;
            CompMove3.Service_Request__c = Cas.id;
            CompMove3.trgOldOwnerId__c = u.id;
            
            Insert CompMove3;
            
            
            
        Id InwardMovementRecordTypeId3 =  cmtrtMap.get('Short Receipt').getRecordTypeId(); //[Select Id from RecordType 
              //   where Name = 'Short Receipt' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
        
         Component_Movement_Table__c CompMove4 = new Component_Movement_Table__c();
            CompMove4.RecordTypeId = InwardMovementRecordTypeId3;
            CompMove4.Type_of_receipt__c = 'Stock Transfer';
            CompMove4.Component_Status__c = 'Usable';
           // CompMove4.Select_Component__c = Prod.Id;
            CompMove4.Quantity__c = 10;
            CompMove4.OwnerID=u.id;
            CompMove4.Received_from_Stock_Point__c = StockPt1.Id;
            CompMove4.Service_Request__c = Cas.id;
            CompMove4.trgOldOwnerId__c = u.id;
            CompMove4.Transferred_to_Stock_Point__c = StockPt1.Id;
            Insert CompMove4;
            
        Component_Movement_Table__c CompMove5 = new Component_Movement_Table__c();
            CompMove5.RecordTypeId = InwardMovementRecordTypeId3;
            CompMove5.Type_of_receipt__c = 'Stock Transfer';
            CompMove5.Component_Status__c = 'Usable';
           // CompMove5.Select_Component__c = Prod.Id;
            CompMove5.Quantity__c = 10;
            CompMove5.OwnerID=u.id;
            CompMove5.Service_Request__c = Cas.id;
            CompMove5.trgOldOwnerId__c = u.id;
            CompMove5.Transferred_to_Stock_Point__c = StockPt1.Id;
            Insert CompMove5;
           
            
    }*/
    

    
    

}