@isTest
    Public with sharing class test_CompanySkillAdmin{
        
        static testmethod void ProductSalesCtrlTest(){
             Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName ;
       
        
        Schema.DescribeSObjectResult c = Schema.SObjectType.Component_Movement_Table__c;
        Map<String,Schema.RecordTypeInfo> cmtrtMap = c.getRecordTypeInfosByName();
        Schema.RecordTypeInfo cmtrtByName ;
        
        User u = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        
        
        Stock_Point__c StockPt1 = new Stock_Point__c();
        
        StockPt1.RecordTypeId = rtMapByName.get('Service Center').getRecordTypeId();
        StockPt1.Service_Engineer_Name__c = 'TestEngineer1';
        StockPt1.ownerId = u.Id;
        StockPt1.Name = 'PARWEZ ALAM';
        StockPt1.Service_Center_Location_Code__c='051-SC-PATNA';
        StockPt1.Service_Engineer_Id__c = 'P900257';
        Insert StockPt1;
        
       
            
        Current_Inventory_Component__c CurrentStock = new Current_Inventory_Component__c();
        CurrentStock.Name = 'Test';
        CurrentStock.Defective_Quantity_in_Hand__c = 45;
        CurrentStock.Usable_Quantity_in_Hand__c = 20;
        CurrentStock.Component_Code__c = '1001';
        CurrentStock.Stock_Point__c= StockPt1.Id;
        CurrentStock.OwnerId = u.id;
        insert CurrentStock;
        
        
        Product__c Prod = new  Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        Set<Id> pid = new Set<Id>();
        pid.add(Prod.id);
        
         
            Stock_Point__c ServiceEngineer = new Stock_Point__c();
            
            serviceEngineer.RecordTypeId = rtMapByName.get('Service Engineer').getRecordTypeId();           
            ServiceEngineer.Service_Center_Description__c = 'TestEngineer';
            ServiceEngineer.Service_Center_Address__c = 'Address22';
            ServiceEngineer.Service_Center_Location_Code__c = '022';            
            Insert ServiceEngineer;
        
        Current_Inventory_Component__c CurrentStockEng = new Current_Inventory_Component__c();
        CurrentStockEng.Name = 'Test';
        CurrentStockEng.Defective_Quantity_in_Hand__c = 45;
        CurrentStockEng.Usable_Quantity_in_Hand__c = 20;
        CurrentStockEng.Component_Code__c = '1001';
        CurrentStockEng.Stock_Point__c= ServiceEngineer.Id;
        CurrentStockEng.OwnerId = u.id;
        insert CurrentStockEng;
        
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
            CompMove1.Quantity__c = 1;
            CompMove1.OwnerID=u.id;
          //  CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            //CompMove1.Service_Request__c = Cas.id;
            CompMove1.trgOldOwnerId__c = u.id;
            CompMove1.Mrn_No_Trig__c = 12;
            CompMove1.OwnerId = u.id;
            CompMove1.Challan_No_Trig__c = 12;
            CompMove1.Product_Code_1__c = '1001';
            compmove1.Service_Engineer_Assigned__c = ServiceEngineer.id;
           // compMove1.Mrn_No__c = '101010';
           // compMove1.Stock_Transfer_Sl_No__c = '1234';
            
            Insert CompMove1;
                /*List<Component_Movement_Table__c> compMoveLis = new Component_Movement_Table__c();
                compMoveLis.add(CompMove1);
                String LisSize = compMoveLis.Size();*/
            Component_Movement_Table__c cmtrecord;
            cmtRecord = new Component_Movement_Table__c();
            Schema.RecordTypeInfo rtByNames = Schema.SObjectType.Component_Movement_Table__c.getRecordTypeInfosByName().get('Product Sale');
            cmtRecord.RecordTypeId = rtByNames.getRecordTypeId(); 
            
            Component_Movement_line_Item__c cmli = new Component_Movement_line_Item__c();
                cmli.Select_Component__c = Prod.id;
                cmli.CurrencyIsoCode = 'INR';
                cmli.Component_Movement_Table__c = CompMove1.id;
                cmli.Quantity__c = 1;
                cmli.Stock_Transfer_Price_Unit__c = 560;
                cmli.VAT_Percent__c = 25;
            insert cmli;
            
            test.startTest();
                cmtRecord.RecordTypeId = rtByNames.getRecordTypeId(); 
                ProductSalesCtrl PSC = new ProductSalesCtrl();
                ProductSalesCtrl.LineItemWrapper wrap = new ProductSalesCtrl.LineItemWrapper(1, cmli);
                PSC.lineItemWrapList.add(wrap);
                //List<Component_Movement_line_Item__c> cmli = PSC.
                String indx = ApexPages.currentPage().getParameters().put('indx', '1');      
                PSC.removeRow();
                PSC.doSave();
                PSC.doCancel();
            //InventoryUpdate.AddbyOwner('AJDKDJK', 'SJDKFJK', u.Id, 'Usable',QtyMap.get(cmvt.Select_Component__c));
            test.StopTest();
        }
     }