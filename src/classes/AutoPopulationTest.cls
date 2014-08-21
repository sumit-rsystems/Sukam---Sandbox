@isTest
public class AutoPopulationTest{
    static testMethod void AutoPopulationTestMethod(){   
    
        User u = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        
        Stock_Point__c StockPt1 = new Stock_Point__c();
        //StockPt1.RecordTypeId = [Select Id from RecordType where Name = 'Service Engineer' And SObjectType = 'Stock_Point__c'].Id;
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
		Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
		Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Engineer');
		StockPt1.RecordTypeId = rtByName.getRecordTypeId();

        StockPt1.Service_Engineer_Name__c = 'TestEngineer1';
        StockPt1.ownerId = u.Id;
        StockPt1.Name = 'PARWEZ ALAM';
        StockPt1.Service_Center_Location_Code__c='051-SC-PATNA';
        StockPt1.Service_Engineer_Id__c = 'P900257';
        Insert StockPt1;
        
        Current_Inventory_Component__c CurrentStock = new Current_Inventory_Component__c();
        CurrentStock.Name = 'Test';
        CurrentStock.Defective_Quantity_in_Hand__c = 5;
        CurrentStock.Usable_Quantity_in_Hand__c = 2;
        CurrentStock.Component_Code__c = '1001';
        CurrentStock.Stock_Point__c= StockPt1.Id;
        Insert CurrentStock;
        
        
        Product__c Prod = new Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        
        Price_Books__c PriceBk0 = new Price_Books__c();
        PriceBk0.Name = 'Standard Price Book';
        PriceBk0.Description__c = 'Standard Price Book';
        PriceBk0.IsActive__c = True;
        Insert PriceBk0;
        
        Price_Book_Entry__c StdPBEntry = new Price_Book_Entry__c();
        StdPBEntry.CurrencyIsoCode = Prod.CurrencyIsoCode;
        StdPBEntry.UnitPrice__c = 1000;
        StdPBEntry.IsActive__c = True;
        StdPBEntry.Product__c = Prod.Id;
        StdPBEntry.Price_book__c = [Select Id from Price_Books__c where Name = 'Standard Price Book' Limit 1].Id;
        Insert StdPBEntry;
        
        //////////1
        Price_Books__c PriceBk1 = new Price_Books__c();
        PriceBk1.Name = 'Comprehensive AMC Rate';
        PriceBk1.Description__c = 'Comprehensive AMC Rate';
        PriceBk1.IsActive__c = True;
        Insert PriceBk1;
        
        Price_Book_Entry__c PBEntry1 = new Price_Book_Entry__c();
        PBEntry1.CurrencyIsoCode = Prod.CurrencyIsoCode;
        PBEntry1.UnitPrice__c = 100;
        PBEntry1.IsActive__c = True;
        PBEntry1.Product__c = Prod.Id;
        PBEntry1.Price_book__c = PriceBk1.Id;
        Insert PBEntry1;
        
        //////////2
        Price_Books__c PriceBk2 = new Price_Books__c();
        PriceBk2.Name = 'Non-Comprehensive AMC Rate';
        PriceBk2.Description__c = 'Non-Comprehensive AMC Rate';
        PriceBk2.IsActive__c = True;
        Insert PriceBk2;
        
        Price_Book_Entry__c PBEntry2 = new Price_Book_Entry__c();
        PBEntry2.CurrencyIsoCode = Prod.CurrencyIsoCode;
        PBEntry2.UnitPrice__c = 100;
        PBEntry2.IsActive__c = True;
        PBEntry2.Product__c = Prod.Id;
        PBEntry2.Price_book__c = PriceBk2.Id;
        Insert PBEntry2;
        
        //////////3
        Price_Books__c PriceBk3 = new Price_Books__c();
        PriceBk3.Name = 'Carry In Service Charges';
        PriceBk3.Description__c = 'Carry In Service Charges';
        PriceBk3.IsActive__c = True;
        Insert PriceBk3;
        
        Price_Book_Entry__c PBEntry3 = new Price_Book_Entry__c();
        PBEntry3.CurrencyIsoCode = Prod.CurrencyIsoCode;
        PBEntry3.UnitPrice__c = 100;
        PBEntry3.IsActive__c = True;
        PBEntry3.Product__c = Prod.Id;
        PBEntry3.Price_book__C = PriceBk3.Id;
        Insert PBEntry3;
        
        //////////4
        Price_Books__c PriceBk4 = new Price_Books__c();
        PriceBk4.Name = 'On Site Service Charges';
        PriceBk4.Description__c = 'On Site Service Charges';
        PriceBk4.IsActive__c = True;
        Insert PriceBk4;
        
        Price_Book_Entry__c PBEntry4 = new Price_Book_Entry__c();
        PBEntry4.CurrencyIsoCode = Prod.CurrencyIsoCode;
        PBEntry4.UnitPrice__c = 100;
        PBEntry4.IsActive__c = True;
        PBEntry4.Product__c = Prod.Id;
        PBEntry4.Price_book__C = PriceBk4.Id;
        Insert PBEntry4;
        
        //////////5
        Price_Books__c PriceBk5 = new Price_Books__c();
        PriceBk5.Name = 'Visit Service Charges';
        PriceBk5.Description__c = 'Visit Service Charges';
        PriceBk5.IsActive__c = True;
        Insert PriceBk5;
        
        Price_Book_Entry__c PBEntry5 = new Price_Book_Entry__c();
        PBEntry5.CurrencyIsoCode = Prod.CurrencyIsoCode;
        PBEntry5.UnitPrice__c = 100;
        PBEntry5.IsActive__c = True;
        PBEntry5.Product__c = Prod.Id;
        PBEntry5.Price_book__C = PriceBk5.Id;
        Insert PBEntry5;
        
        /////////////////CASE
        
        Service_Request__c  Cas = new Service_Request__c ();
        //Cas.Service_Engineer_Assigned__c = StockPt1.Id;
        Cas.Service_Bill_No__c = 'ww';
        Cas.Products__c = Prod.Id;
        Cas.AMC_Created__c = 'Yes';
        Cas.AMC_Type__c = 'Comprehensive';
        Cas.Service_Charge_Type__c = 'Carry In';
        Cas.Origin__c = 'Web';
        Cas.Product_Serial_No__c = '0101';
        Cas.ownerId = u.Id;
        Cas.Warranty_Status__c = 'No';
        Cas.AMC_Status__c = 'No';
        Cas.Total_Defective_Quantity_Returned__c = 1;
        Cas.Total_Quantity_Issued__c = 1;
        cas.Product_Code__c = '1001';
        Insert Cas;
        
        Cas.AMC_Type__c = 'Non-Comprehensive'; 
        Cas.Service_Charge_Type__c = 'On Site';
        Update Cas;
        
        Cas.Service_Charge_Type__c = 'Visit';
        Update Cas;
        
    }
}