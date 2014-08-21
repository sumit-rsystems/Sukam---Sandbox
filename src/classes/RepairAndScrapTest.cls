@isTest
public class RepairAndScrapTest{
    static testMethod void RepairAndScrapTestMethod(){ 
       
         try{
        Product__c Prod1 = new Product__c();
        Prod1.name = 'Test1';
        Prod1.Product_Code__c = '1002';
        Prod1.CurrencyIsoCode = 'INR';
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Insert Prod1;
        
        User[] Usr = [Select Id from User where Profile.name='Service Center' and IsActive=True Limit 2];
        
        User u = Usr[0];
            
        User u2 = Usr[1];
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Center');
        Id screctypeid = rtByName.getRecordTypeId();
        
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
            
            Repair__c Repair = new Repair__c();
            Repair.Item_Repaired_1__c = Prod1.Id;
            Repair.Quantity_1__c = 10;
            Repair.Item_Repaired_2__c = Prod1.Id;
            Repair.Quantity_2__c = 10;
            Repair.Item_Repaired_3__c = Prod1.Id;
            Repair.Quantity_3__c = 10;
            Repair.Item_Repaired_4__c = Prod1.Id;
            Repair.Quantity_4__c = 10;
            Insert Repair;
            
            Scrap_del__c Scrap = new Scrap_del__c();
            Scrap.Select_Item_1__c = Prod1.Id;
            Scrap.Quantity_1__c = 1;
            Scrap.Select_Item_2__c = Prod1.Id;
            Scrap.Quantity_2__c = 1;
            Scrap.Select_Item_3__c = Prod1.Id;
            Scrap.Quantity_3__c = 1;
            Scrap.Select_Item_4__c = Prod1.Id;
            Scrap.Quantity_4__c = 1;
            Scrap.Scrap_Approval_Status__c = 'Approved';
            Scrap.Purchaser_Name__c = 'PurName';
            Scrap.Purchaser_Address__c = 'PurAddress';
            Scrap.Rate_1__c = 100;
            Insert Scrap;
            
            Scrap_del__c Scrap2 = new Scrap_del__c();
            Scrap2.Select_Item_1__c = Prod1.Id;
            Scrap2.Quantity_1__c = 1;
            Scrap2.Select_Item_2__c = Prod1.Id;
            Scrap2.Quantity_2__c = 1;
            Scrap2.Select_Item_3__c = Prod1.Id;
            Scrap2.Quantity_3__c = 1;
            Scrap2.Select_Item_4__c = Prod1.Id;
            Scrap2.Quantity_4__c = 1;
            Scrap2.Scrap_Approval_Status__c = 'Rejected';
            Scrap2.Purchaser_Name__c = 'PurName';
            Scrap2.Purchaser_Address__c = 'PurAddress';
            Scrap2.Rate_1__c = 100;
            Insert Scrap2;
            
        }


        }catch(Exception e){}    



        
    
    } 
    
}