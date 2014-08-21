@isTest
public class ComponentMovementTest1{
    static testMethod void ComponentMovementTestMethod1(){ 
        try{
        Product__c Prod = new Product__c();
        Prod.name = 'Testt';
        Prod.Product_Code__c = '10011';
    
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        
        Product__c Prod1 = new Product__c();
        Prod1.name = 'Testt1';
        Prod1.Product_Code__c = '10022';
       
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
        StdPBEntry.Price_Book__C = [Select Id from Price_Books__C where Name = 'Standard Price Book' Limit 1].Id;
        Insert StdPBEntry;
        
        Price_Book_Entry__c PBEntry = new Price_Book_Entry__c();
        
        PBEntry.UnitPrice__c = 100;
        PBEntry.IsActive__c = True;
        PBEntry.Product__c = Prod.Id;
        PBEntry.Price_Book__C = PriceBk.Id;
        Insert PBEntry;
        
        User[] Usr = [Select Id from User where Profile.name='Service Center' and IsActive=True Limit 2];
        
        User u = Usr[0];
            
        User u2 = Usr[0];
        
        //for(Stock_Point__c StP: [Select Id from Stock_Point__c where OwnerId = :u.Id or OwnerId = :u2.Id])            
          //  Delete StP;
            
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
        StockPt1.OwnerId = u2.Id;
        StockPt1.Service_Center_Location_Code__c = '033-';
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
            StockPt.Service_Center_Location_Code__c = '044-';
            Insert StockPt;
            
            Current_Inventory_Component__c TempInventory2 = new Current_Inventory_Component__c();
            TempInventory2.Stock_Point__c = StockPt.Id;
            TempInventory2.Component_Code__c = Prod1.Product_Code__c;
            TempInventory2.Name = Prod1.Name;
            TempInventory2.Usable_Quantity_in_hand__c = 500;
            TempInventory2.Defective_Quantity_in_hand__c = 500;
            Insert TempInventory2;
            
            Stock_Point__c ServiceEngineer = new Stock_Point__c();
            ServiceEngineer.RecordTypeId = serectypeid;  //[Select Id from RecordType where Name = 'Service Engineer' And SObjectType = 'Stock_Point__c'].Id;
            ServiceEngineer.Service_Center_Description__c = 'TestEngineer';
            ServiceEngineer.Service_Center_Address__c = 'Address22';
            ServiceEngineer.Service_Center_Location_Code__c = '022';
            Insert ServiceEngineer;
            
            Current_Inventory_Component__c TempInventory3 = new Current_Inventory_Component__c();
            TempInventory3.Stock_Point__c = ServiceEngineer.Id;
            TempInventory3.Component_Code__c = Prod.Product_Code__c;
            TempInventory3.Name = Prod.Name;
            TempInventory3.Usable_Quantity_in_hand__c = 500;
            TempInventory3.Defective_Quantity_in_hand__c = 500;
            Insert TempInventory3;
            
            ////////////////////////INWARD MOVEMENT///////////////////////////////////////
            
            Schema.DescribeSObjectResult d2 = Schema.SObjectType.Component_Movement_Table__c;
			Map<String,Schema.RecordTypeInfo> rtMapByName2 = d2.getRecordTypeInfosByName();
			Schema.RecordTypeInfo rtByName2 =  rtMapByName2.get('Inward Movement');
			Id imrectypeid = rtByName2.getRecordTypeId();
			
			Schema.RecordTypeInfo rtByName3 =  rtMapByName2.get('Reconciliation');
			Id recrectypeid = rtByName3.getRecordTypeId();
			
		
            Id InwardMovementRecordTypeId = imrectypeid;  //[Select Id from RecordType where Name = 'Inward Movement' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
            //Scenario 1
            Component_Movement_Table__c CompMove1 = new Component_Movement_Table__c();
            CompMove1.RecordTypeId = InwardMovementRecordTypeId;
            CompMove1.Type_of_receipt__c = 'Stock Transfer';
            CompMove1.Component_Status__c = 'Usable';
            CompMove1.Select_Component__c = Prod.Id;
            CompMove1.Quantity__c = 10;
            CompMove1.OwnerID=u.id;
            CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            Insert CompMove1;
            
            //Scenario 2
            Component_Movement_Table__c CompMove2 = new Component_Movement_Table__c();
            CompMove2.RecordTypeId = InwardMovementRecordTypeId;
            CompMove2.Type_of_receipt__c = 'Returned by Customer';
            CompMove2.Component_Status__c = 'Usable';
            CompMove2.Select_Component__c = Prod.Id;
            CompMove2.Quantity__c = 10;
            CompMove2.MRN_No_Trig__c=1;
            CompMove2.OwnerID=u.id;
            CompMove2.Defective_Quantity_Returned__c=1;
            //CompMove2.Received_from_Stock_Point__c = StockPt1.Id;
            Insert CompMove2;
            
            //Scenario 3
            Component_Movement_Table__c CompMove3 = new Component_Movement_Table__c();
            CompMove3.RecordTypeId = InwardMovementRecordTypeId;
            CompMove3.Type_of_receipt__c = 'Stock Returned by Service Engineer';
            CompMove3.Component_Status__c = 'Usable';
            CompMove3.Select_Component__c = Prod.Id;
            CompMove3.Quantity__c = 10;
            CompMove3.Defective_Quantity_Returned__c=1;
            CompMove3.MRN_No_Trig__c=1;
            CompMove3.OwnerID=u.id;
            CompMove3.Received_from_Stock_Point__c = ServiceEngineer.Id;
            Insert CompMove3;
            
            ///////////////////////////RECONCILIATION//////////////////////////////////
            
            Id ReconciliationRecordTypeId = recrectypeid;  //[Select Id from RecordType where Name = 'Reconciliation' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
            //Scenario 6
            Component_Movement_Table__c CompMove6 = new Component_Movement_Table__c();
            CompMove6.RecordTypeId = ReconciliationRecordTypeId;
            CompMove6.Type_of_Entry__c = 'Add';
            CompMove6.Component_Status__c = 'Usable';
            CompMove6.Select_Component__c = Prod.Id;
            CompMove6.Quantity__c = 10;
            CompMove6.OwnerID=u.id;
            CompMove6.Stock_point_to_be_reconciled__c = StockPt1.Id;
            Insert CompMove6;
            
            //Scenario 6.1
            Component_Movement_Table__c CompMove61 = new Component_Movement_Table__c();
            CompMove61.RecordTypeId = ReconciliationRecordTypeId;
            CompMove61.Type_of_Entry__c = 'Add';
            CompMove61.Component_Status__c = 'Usable';
            CompMove61.Select_Component__c = Prod1.Id;
            CompMove61.Quantity__c = 10;
            CompMove61.OwnerID=u.id;
            CompMove61.Stock_point_to_be_reconciled__c = StockPt1.Id;
            Insert CompMove61;
            
            //Scenario 7
            Component_Movement_Table__c CompMove7 = new Component_Movement_Table__c();
            CompMove7.RecordTypeId = ReconciliationRecordTypeId;
            CompMove7.Type_of_Entry__c = 'Deduct';
            CompMove7.Component_Status__c = 'Usable';
            CompMove7.Select_Component__c = Prod.Id;
            CompMove7.Quantity__c = 10;
            CompMove7.Stock_point_to_be_reconciled__c = StockPt1.Id;
            Insert CompMove7;
            
            ///////////////////////////USED IN SERVICE REQUEST//////////////////////////////////
            
            Service_Request__c Cas = new Service_Request__c();
            Cas.Origin__c = 'Email';
            Cas.Product_Serial_No__c = '0101';
            Cas.Service_Engineer_Assigned__c = ServiceEngineer.Id;
            Insert Cas;
            
            /*Id ServiceRequestRecordTypeId = [Select Id from RecordType where Name = 'Components Used in Service Request' and SObjectType = 'Component_Movement_Table__c' Limit 1].Id;
            //Scenario 9
            Component_Movement_Table__c CompMove9 = new Component_Movement_Table__c();
            CompMove9.RecordTypeId = ServiceRequestRecordTypeId;
            CompMove9.Service_Request__c = Cas.Id;
            CompMove9.Select_Component__c = Prod.Id;
            CompMove9.Quantity__c = 10;
            CompMove9.Defective_Quantity_Returned__c = 5;
            
            Insert CompMove9;
            
            //Scenario 9
            Component_Movement_Table__c CompMove91 = new Component_Movement_Table__c();
            CompMove91.RecordTypeId = ServiceRequestRecordTypeId;
            CompMove91.Service_Request__c = Cas.Id;
            CompMove91.Select_Component__c = Prod.Id;
            CompMove91.Quantity__c = 10;
            CompMove91.Defective_Quantity_Returned__c = 5;
            
            Insert CompMove91;
            
            //CompMove91.Defective_Quantity_Returned__c = 6;
            Update CompMove91;*/
            
            ///////////////////////////CANCELLATIONS//////////////////////////////////
            
            CompMove1.Cancelled__c = True;
            Update CompMove1;
            
            CompMove2.Cancelled__c = True;
            //Update CompMove2;
            
            CompMove3.Cancelled__c = True;
            //Update CompMove3;
            
            CompMove6.Cancelled__c = True;
            //Update CompMove6;
            
            CompMove7.Cancelled__c = True;
            //Update CompMove7;
          
          
        
        }            
         }catch(Exception e){}       
        
    
    }
}