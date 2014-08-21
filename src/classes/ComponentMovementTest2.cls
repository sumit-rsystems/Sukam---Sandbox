@isTest
public class ComponentMovementTest2{
    static testMethod void ComponentMovementTestMethod2(){ 
        try{
        Product__c Prod = new Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        
        Product__c Prod1 = new Product__c();
        Prod1.name = 'Test1';
        Prod1.Product_Code__c = '1002';
       
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Insert Prod1;
        
        Price_Books__C PriceBk = new Price_Books__C();
        PriceBk.Name = 'Carry In Service Charges';
        PriceBk.Description__c = 'Carry In Service Charges';
        PriceBk.IsActive__c = True;
        Insert PriceBk;
        
        Price_Book_Entry__c StdPBEntry = new Price_Book_Entry__c();
        
        StdPBEntry.UnitPrice__c = 1000;
        StdPBEntry.IsActive__c = True;
        StdPBEntry.Product__c = Prod.Id;
        StdPBEntry.Price_book__c = [Select Id from Price_book__c where Name = 'Standard Price Book' Limit 1].Id;
        Insert StdPBEntry;
        
        Price_Book_Entry__c PBEntry = new Price_Book_Entry__c();
       
        PBEntry.UnitPrice__c = 100;
        PBEntry.IsActive__c = True;
        PBEntry.Product__c = Prod.Id;
        PBEntry.Price_book__c = PriceBk.Id;
        Insert PBEntry;
        
        User[] Usr = [Select Id from User where Profile.name='Service Center' and IsActive=True Limit 2];
        
        User u = Usr[0];
        User u2 = Usr[1];              
         
             
            
        /*Current_Inventory_Component__c InTransitInventory = new Current_Inventory_Component__c();
        InTransitInventory.Stock_Point__c = [Select Id from Stock_point__c where Service_Center_Description__c = 'In Transit' Limit 1].Id;
        InTransitInventory.Component_Code__c = Prod.ProductCode;
        InTransitInventory.Name = Prod.Name;
        InTransitInventory.Usable_Quantity_in_hand__c = 500;
        InTransitInventory.Defective_Quantity_in_hand__c = 500;
        Insert InTransitInventory;*/
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
		Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
		Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Center');
		Id screctypeid = rtByName.getRecordTypeId();
		
		Schema.RecordTypeInfo rtByName1 =  rtMapByName.get('Service Engineer');
		Id serectypeid = rtByName1.getRecordTypeId();
		
        Stock_Point__c StockPt1 = new Stock_Point__c();
        StockPt1.RecordTypeId = screctypeid;  //[Select Id from RecordType where Name = 'Service Center' And SObjectType = 'Stock_Point__c'].Id;
        StockPt1.Service_Center_Description__c = 'TestCenter1';
        StockPt1.Service_Center_Address__c = 'Address1';
        StockPt1.Service_Center_Location_Code__c = '011';
        if(u2 != null){
            StockPt1.OwnerId = u2.Id;
        }
        Insert StockPt1;
        
        Current_Inventory_Component__c TempInventory = new Current_Inventory_Component__c();
        TempInventory.Stock_Point__c = StockPt1.Id;
        TempInventory.Component_Code__c = Prod.Product_Code__c;
        TempInventory.Name = Prod.Name;
        TempInventory.Usable_Quantity_in_hand__c = 500;
        TempInventory.Defective_Quantity_in_hand__c = 500;
        Insert TempInventory;
        
        System.runAs(u)
        {
            Stock_Point__c StockPt = new Stock_Point__c();
            StockPt.RecordTypeId = screctypeid;  //[Select Id from RecordType where Name = 'Service Center' And SObjectType = 'Stock_Point__c'].Id;
            StockPt.Service_Center_Description__c = 'TestCenter2';
            StockPt.Service_Center_Address__c = 'Address2';
            StockPt.Service_Center_Location_Code__c = '022';
            Insert StockPt;
            
            Stock_Point__c ServiceEngineer = new Stock_Point__c();
            ServiceEngineer.RecordTypeId = serectypeid;  //[Select Id from RecordType where Name = 'Service Engineer' And SObjectType = 'Stock_Point__c'].Id;
            ServiceEngineer.Service_Center_Description__c = 'TestEngineer';
            ServiceEngineer.Service_Center_Address__c = 'Address2';
            ServiceEngineer.Service_Center_Location_Code__c = '022';
            Insert ServiceEngineer;
            
            Current_Inventory_Component__c TempInventory2 = new Current_Inventory_Component__c();
            TempInventory2.Stock_Point__c = StockPt.Id;
            TempInventory2.Component_Code__c = Prod1.Product_Code__c;
            TempInventory2.Name = Prod1.Name;
            TempInventory2.Usable_Quantity_in_hand__c = 500;
            TempInventory2.Defective_Quantity_in_hand__c = 500;
            Insert TempInventory2;
            
            Current_Inventory_Component__c TempInventory3 = new Current_Inventory_Component__c();
            TempInventory3.Stock_Point__c = StockPt.Id;
            TempInventory3.Component_Code__c = Prod.Product_Code__c;
            TempInventory3.Name = Prod.Name;
            TempInventory3.Usable_Quantity_in_hand__c = 500;
            TempInventory3.Defective_Quantity_in_hand__c = 500;
            Insert TempInventory3;
            
            ///////////////////////////OUTWARD MOVEMENT//////////////////////////////////
            
            Schema.DescribeSObjectResult d2 = Schema.SObjectType.Component_Movement_Table__c;
			Map<String,Schema.RecordTypeInfo> rtMapByName2 = d2.getRecordTypeInfosByName();
			Schema.RecordTypeInfo rtByName2 =  rtMapByName2.get('Outward Movement');
			Id omrectypeid = rtByName2.getRecordTypeId();
			
			Schema.RecordTypeInfo rtByName3 =  rtMapByName2.get('Stock Inward');
			Id sirectypeid = rtByName3.getRecordTypeId();
			
            Id OutwardMovementRecordTypeId = omrectypeid;  //[Select Id from RecordType where Name = 'Outward Movement' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
            //Scenario 4
            Component_Movement_Table__c CompMove4 = new Component_Movement_Table__c();
            CompMove4.RecordTypeId = OutwardMovementRecordTypeId;
            CompMove4.Type_of_transfer__c = 'Stock Transfer';
            CompMove4.Component_Status__c = 'Usable';
            CompMove4.Select_Component__c = Prod.Id;
            CompMove4.Quantity__c = 10;
            CompMove4.Select_Component_2__c = Prod.Id;
            CompMove4.Quantity_2__c = 10;
            CompMove4.Select_Component_3__c = Prod.Id;
            CompMove4.Quantity_3__c = 10;
            CompMove4.Select_Component_4__c = Prod.Id;
            CompMove4.Quantity_4__c = 10;
            CompMove4.Transferred_to_Stock_Point__c = StockPt1.Id;
            Insert CompMove4;
            
            //Scenario 4.1
            Component_Movement_Table__c CompMove41 = new Component_Movement_Table__c();
            CompMove41.RecordTypeId = OutwardMovementRecordTypeId;
            CompMove41.Type_of_transfer__c = 'Stock Transfer';
            CompMove41.Component_Status__c = 'Usable';
            CompMove41.Select_Component__c = Prod1.Id;
            CompMove41.Quantity__c = 10;
            CompMove41.Transferred_to_Stock_Point__c = StockPt1.Id;
            Insert CompMove41;
            
            //Scenario 4.1
            Component_Movement_Table__c CompMove42 = new Component_Movement_Table__c();
            CompMove42.RecordTypeId = OutwardMovementRecordTypeId;
            CompMove42.Type_of_transfer__c = 'Stock Transfer';
            CompMove42.Component_Status__c = 'Usable';
            CompMove42.Select_Component__c = Prod1.Id;
            CompMove42.Quantity__c = 10;
            CompMove42.Transferred_to_Stock_Point__c = StockPt1.Id;
            CompMove42.From_Org__c = '019-SC-GGN';
            Insert CompMove42;
            
            //Scenario 5
            Component_Movement_Table__c CompMove5 = new Component_Movement_Table__c();
            CompMove5.RecordTypeId = OutwardMovementRecordTypeId;
            CompMove5.Type_of_transfer__c = 'Transferred to Service Engineer';
            CompMove5.Component_Status__c = 'Usable';
            CompMove5.Select_Component__c = Prod.Id;
            CompMove5.Quantity__c = 10;
            CompMove5.Transferred_to_Stock_Point__c = ServiceEngineer.Id;
            Insert CompMove5;
            
            ///////////////////////////CANCELLATIONS//////////////////////////////////
            Id StockInwardRecordTypeId = sirectypeid;  //[Select Id from RecordType where Name = 'Stock Inward' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
            if(u2 != null){ 
            System.runAs(u2)
            {
                CompMove4.RecordTypeId = StockInwardRecordTypeId;
                CompMove4.Received_Quantity1__c = 5;
                CompMove4.Defective_Quantity1__c = 5;
                CompMove4.Received_Quantity2__c = 5;
                CompMove4.Defective_Quantity2__c = 5;
                CompMove4.Received_Quantity3__c = 5;
                CompMove4.Defective_Quantity3__c = 5;
                CompMove4.Received_Quantity4__c = 5;
                CompMove4.Defective_Quantity4__c = 3;
                CompMove4.Stock_Transfer_Status__c = 'Received';
                //Update CompMove4;
                
                CompMove42.RecordTypeId = StockInwardRecordTypeId;
                CompMove42.Received_Quantity1__c = 5;
                CompMove42.Defective_Quantity1__c = 5;
                CompMove42.Stock_Transfer_Status__c = 'Received';
                Update CompMove42;
            }
            }
            CompMove5.Cancelled__c = True;
            Update CompMove5;
            
            
        
        }            
        
      }catch(Exception e)   
            {}   
    
    }
}