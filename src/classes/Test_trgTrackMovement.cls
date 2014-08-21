/*************************************************************
   Created By : Amit Singh                                   
   Date 27/9/2012  
   
   Description : Test Class of Trigger - 'trgTrackMovement'                                                                                
*************************************************************/    


@isTest
public class Test_trgTrackMovement{
    public static testMethod void getCoverage(){
        Schema.DescribeSObjectResult c = Schema.SObjectType.Component_Movement_Table__c;
        Map<String,Schema.RecordTypeInfo> cmtrtMap = c.getRecordTypeInfosByName();
        Schema.RecordTypeInfo cmtrtByName ;
       
       
       Account acct = new Account(
        name = 'test',
        Customer_ID__c = 'ACC-1001'
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
        
        List<Product__c> prodList = new List<Product__c>();
        Product__c Prod = new Product__c();
        Prod.Name = 'Test Product';
        Prod.Product_Code__c= '12345';
        Prod.Is_Active__c = true;
        Prod.UoM__c = 'Kg';
        Prod.CurrencyIsoCode = null;
        insert Prod; 
        //prodList.add(Prod); 
        
        
        Product__c Prod1 = new Product__c();
        Prod1.name = 'Test1';
        Prod1.Product_Code__c = '10012';
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Prod1.CurrencyIsoCode = null;
        insert Prod1;
        //prodList.add(Prod1);   
        
        Product__c Prod2 = new Product__c();
        Prod2.Name = 'Test Product1';
        Prod2.Product_Code__c= '12414';
        Prod2.Is_Active__c = true;
        Prod2.UoM__c = 'Kg';
        Prod2.CurrencyIsoCode = null;
        insert Prod2;
        //prodList.add(Prod2);  
        
        Product__c Prod3 = new Product__c();
        Prod3.Name = 'Test Product2';
        Prod3.Product_Code__c= '12400';
        Prod3.Is_Active__c = true;
        Prod3.UoM__c = 'Kg';
        Prod3.CurrencyIsoCode = null;
        insert Prod3;
        //prodList.add(Prod3);   
        
        //insert prodList;
        
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
        
        //Id stockId = [Select Id from RecordType where Name = 'Service Center' And SObjectType = 'Stock_Point__c'].Id;    
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Center');
        Id stockId = rtByName.getRecordTypeId();
        
        Schema.RecordTypeInfo rtByName1 =  rtMapByName.get('Service Engineer');
        Id sestockId = rtByName1.getRecordTypeId();
        
        List<Stock_Point__c> stkPtList = new List<Stock_Point__c>();
        Stock_Point__c StockPt1 = new Stock_Point__c();
        StockPt1.RecordTypeId = stockId ;
        StockPt1.Service_Center_Description__c = 'TestCenter1';
        StockPt1.Service_Center_Address__c = 'Address1';
        StockPt1.OwnerId = u.Id;
        StockPt1.Service_Center_Location_Code__c = '033-';
        stkPtList.add(StockPt1);
        
        Stock_Point__c StockPt2 = new Stock_Point__c();
        StockPt2.RecordTypeId = sestockId;
        StockPt2.Service_Center_Description__c = 'TestCenter2';
        StockPt2.Service_Center_Address__c = 'Address2';
        StockPt2.OwnerId = u.Id;
        StockPt2.Service_Center_Location_Code__c = '033-';
        stkPtList.add(StockPt2);
        insert stkPtList;
        
        List<Current_Inventory_Component__c> compList = new List<Current_Inventory_Component__c>();
        Current_Inventory_Component__c  cic = new Current_Inventory_Component__c ();
        cic.Component_code__c = '12400';
        cic.Name = 'test';
        cic.Usable_Quantity_in_Hand__c = 200;
        cic.Stock_Point__c = StockPt1.id;
        compList.add(cic);
        
        
        Current_Inventory_Component__c  cic1 = new Current_Inventory_Component__c ();
        cic1.Component_code__c = '12345';
        cic1.Name = 'test';
        cic1.Usable_Quantity_in_Hand__c = 200;
        cic1.Stock_Point__c = StockPt2.id;
        compList.add(cic1);
        
        insert compList;
        
        Service_Request__c Cas1 = new Service_Request__c();
        Cas1.Origin__c = 'Email';
        Cas1.Contact__c = cont.id;
        Cas1.Product_Serial_No__c = '0101';
        Cas1.Service_Charge_Type__c = 'Visit';
        Cas1.Products__c = Prod.Id;
        Cas1.OwnerId = u.id;
        Cas1.Service_Engineer_Assigned__c = StockPt2 .id;
        Cas1.Type_of_Service_Request__c = 'Others';
        Cas1.Product_Category__c = 'COMPONENT';
        
        //Insert Cas1;
        Component_Movement_Table__c CompMove = new Component_Movement_Table__c();
             
        
        CompMove.RecordTypeId = cmtrtMap.get('Inward Movement').getRecordTypeId();
        CompMove.Type_of_receipt__c = 'Service Center';
        CompMove.Component_Status__c = 'Usable';
        CompMove.Select_Component__c =prod.id;
        CompMove.Quantity__c = 1;
        CompMove.Quantity_2__c = 2;
        CompMove.Quantity_3__c = 3;
        CompMove.Quantity_4__c = 4;  
        CompMove.OwnerID=u.id;
        CompMove.Select_Component_2__c = prod1.id;
        CompMove.Select_Component_3__c = prod2.id;
        CompMove.Select_Component_4__c = prod3.id;
        compMove.Cancelled__c = False;
        CompMove.Received_from_Stock_Point__c = StockPt1.Id;
        CompMove.Stock_Point_Type__c = 'Service Engineer'; 
        CompMove.UserAddress__c = StockPt2.Service_Center_Address__c;
        try
        {
          Insert CompMove; 
          if(CompMove.Select_Component__c == null)  throw new BaseException ('This is bad');
        }
        catch(System.DMLException e)
        {
           Boolean expectedExceptionThrown =  e.getMessage().contains('You added duplicate product.') ? true : false;
           System.AssertEquals(expectedExceptionThrown, true);
        }
        
        
        Component_Movement_Table__c CompMove5 = new Component_Movement_Table__c();
        CompMove5.RecordTypeId = cmtrtMap.get('Stock Received').getRecordTypeId();
        CompMove5.Type_of_receipt__c = 'Service Center';
        CompMove5.Component_Status__c = 'Usable';
        CompMove5.Select_Component__c =prod.id;
        CompMove5.Quantity__c = 1;
        CompMove5.Quantity_2__c = 2;
        CompMove5.Quantity_3__c = 3;
        CompMove5.Quantity_4__c = 4;  
        
        CompMove5.Received_Quantity1__c = 1;
        CompMove5.Received_Quantity2__c = 2;
        CompMove5.Received_Quantity3__c = 3;
        CompMove5.Received_Quantity4__c = 4;
        
        CompMove5.OwnerID=u.id;
        CompMove5.Select_Component_2__c = prod1.id;
        CompMove5.Select_Component_3__c = prod2.id;
        CompMove5.Select_Component_4__c = prod3.id;
        compMove5.Cancelled__c = False;
        CompMove5.Received_from_Stock_Point__c = StockPt1.Id;
        CompMove5.Stock_Point_Type__c = 'Service Engineer'; 
        CompMove5.UserAddress__c = StockPt2.Service_Center_Address__c;
        try{
        Insert CompMove5;
        if(CompMove5.Select_Component__c == null)  throw new BaseException ('This is bad');
        }
        catch(System.DMLException e)
        {
           Boolean expectedExceptionThrown =  e.getMessage().contains('You added duplicate product.') ? true : false;
           System.AssertEquals(expectedExceptionThrown, true);
        }   
        
        
        Component_Movement_Table__c CompMove6 = new Component_Movement_Table__c();
        CompMove6.RecordTypeId = cmtrtMap.get('Inward Movement').getRecordTypeId();
        CompMove6.Type_of_receipt__c = 'Service Center';
        CompMove6.Component_Status__c = 'Usable';
        CompMove6.Select_Component__c =prod.id;
        CompMove6.Quantity__c = 1;
        CompMove6.Quantity_2__c = 2;
        CompMove6.Quantity_3__c = 3;
        CompMove6.Quantity_4__c = 4;  
        CompMove6.OwnerID=u.id;
        CompMove6.Select_Component_2__c = prod1.id;
        CompMove6.Select_Component_3__c = prod2.id;
        CompMove6.Select_Component_4__c = prod3.id;
        CompMove6.Cancelled__c = False;
        CompMove6.Received_from_Stock_Point__c = StockPt1.Id;
        CompMove6.Stock_Point_Type__c = 'Service Engineer'; 
        CompMove6.UserAddress__c = StockPt2.Service_Center_Address__c;
        CompMove6.OwnerId = StockPt2.OwnerId;
        try{
        Insert CompMove6;
        if(CompMove6.Select_Component__c == null)  throw new BaseException ('This is bad');
        }
        catch(System.DMLException e)
        {
           Boolean expectedExceptionThrown =  e.getMessage().contains('You added duplicate product.') ? true : false;
           System.AssertEquals(expectedExceptionThrown, true);
        } 
        
        
        Component_Movement_Table__c CompMove7 = new Component_Movement_Table__c();
        CompMove7.RecordTypeId = cmtrtMap.get('Short Receipt').getRecordTypeId();
        CompMove7.Type_of_receipt__c = 'Service Center';
        CompMove7.Component_Status__c = 'Usable';
        CompMove7.Select_Component__c =prod.id;
        CompMove7.Quantity__c = 1;
        CompMove7.Quantity_2__c = 2;
        CompMove7.Quantity_3__c = 3;
        CompMove7.Quantity_4__c = 4;  
        CompMove7.OwnerID=u.id;
        CompMove7.Select_Component_2__c = prod1.id;
        CompMove7.Select_Component_3__c = prod2.id;
        CompMove7.Select_Component_4__c = prod3.id;
        CompMove7.Cancelled__c = False;
        CompMove7.Received_from_Stock_Point__c = StockPt1.Id;
        CompMove7.Stock_Point_Type__c = 'Service Engineer'; 
        CompMove7.UserAddress__c = StockPt2.Service_Center_Address__c;
        CompMove7.OwnerId = StockPt2.OwnerId;
        try{
        Insert CompMove7; 
        if(CompMove7.Select_Component__c == null)  throw new BaseException ('This is bad');
        }
        catch(System.DMLException e)
        {
           Boolean expectedExceptionThrown =  e.getMessage().contains('You added duplicate product.') ? true : false;
           System.AssertEquals(expectedExceptionThrown, true);
        }
       
        //compMove.Cancelled__c = true;
        //update compMove;
        
        Component_Movement_Table__c CompMove2 = new Component_Movement_Table__c();
        CompMove2.RecordTypeId = cmtrtMap.get('Reconciliation').getRecordTypeId();
        CompMove2.Type_of_receipt__c = 'Service Center';
        CompMove2.Type_of_Entry__c = 'Add';
        CompMove2.Component_Status__c = 'Usable';
        CompMove2.Select_Component__c =prod.id;
        CompMove2.Quantity__c = 1;
        CompMove2.Quantity_2__c = 2;
        CompMove2.Quantity_3__c = 3;
        CompMove2.Quantity_4__c = 4;  
        CompMove2.OwnerID=u.id;
        CompMove2.Select_Component_2__c = prod1.id;
        CompMove2.Select_Component_3__c = prod2.id;
        CompMove2.Select_Component_4__c = prod3.id;
        CompMove2.Received_from_Stock_Point__c = StockPt1.Id;
        CompMove2.Stock_Point_to_be_Reconciled__c = StockPt2.Id;
        CompMove2.Cancelled__c = false;
        CompMove2.Stock_Point_Type__c = 'Service Engineer'; 
        CompMove2.UserAddress__c = StockPt2.Service_Center_Address__c;
        try{
        Insert CompMove2; 
         if(CompMove2.Select_Component__c == null) throw new BaseException ('This is bad');
        }
        catch(System.DMLException e)
        {
           Boolean expectedExceptionThrown =  e.getMessage().contains('You added duplicate product.') ? true : false;
           System.AssertEquals(expectedExceptionThrown, true);
        }
        
        //CompMove2.Cancelled__c = true;
        //update CompMove2;
        
          try{     
        Component_Movement_Table__c CompMove3 = new Component_Movement_Table__c();
        CompMove3.RecordTypeId = cmtrtMap.get('Components Used in Service Request').getRecordTypeId();
        CompMove3.Type_of_receipt__c = 'Service Center';
        CompMove3.Component_Status__c = 'Usable';
        CompMove3.Select_Component__c =prod.id;
        CompMove3.Quantity__c = 1;
        CompMove3.OwnerID=u.id;
        CompMove3.Service_Request__c = cas1.id;
        CompMove3.Stock_Point_Type__c = 'Service Engineer'; 
        CompMove3.Cancelled__c = false;
        CompMove3.UserAddress__c = StockPt2.Service_Center_Address__c;
        //Insert CompMove3;  
        
        if(CompMove3.Select_Component__c == null)  throw new BaseException ('This is bad');
        }
        catch(System.DMLException e)
        {
           Boolean expectedExceptionThrown =  e.getMessage().contains('You added duplicate product.') ? true : false;
           System.AssertEquals(expectedExceptionThrown, true);
        }
        
        //CompMove3.Cancelled__c = true;
        //update compMove3;
        
        Component_Movement_Table__c CompMove1 = new Component_Movement_Table__c();
        CompMove1.RecordTypeId = cmtrtMap.get('Outward Movement').getRecordTypeId();
        CompMove1.Type_of_receipt__c = 'Service Center';
        CompMove1.Component_Status__c = 'Usable';
        CompMove1.Select_Component__c =prod.id;
        CompMove1.Quantity__c = 1;
        CompMove1.OwnerID = u.id;
        CompMove1.Transferred_to_Stock_Point__c = StockPt2.Id; 
        CompMove1.Stock_Point_Type__c = 'Service Engineer'; 
        CompMove1.UserAddress__c = StockPt2.Service_Center_Address__c;
        try{
        Insert CompMove1; 
         if(CompMove1.Select_Component__c == null) throw new BaseException ('This is bad');
        }
        catch(System.DMLException e)
        {
           Boolean expectedExceptionThrown =  e.getMessage().contains('You added duplicate product.') ? true : false;
           System.AssertEquals(expectedExceptionThrown, true);
        }
        
      
        //CompMove1.Type_of_receipt__c = 'Transfer to Service Engineer';
        //update compMove1;
        
        compMove.RecordTypeId = cmtrtMap.get('Stock Inward').getRecordTypeId();
        compMove.Stock_Transfer_Status__c = 'Received';
        compMove.Transferred_to_Stock_Point__c = StockPt1.Id;
        compMove.From_Org__c ='019-SC-GGN';
        //update compMove;
        
        //CompMove3.RecordTypeId = cmtrtMap.get('Components Used in Service Request').getRecordTypeId();
        //update CompMove3;
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        Schema.DescribeSObjectResult dd = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByNamee = dd.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByNamee ;
       
        
        Schema.DescribeSObjectResult cc = Schema.SObjectType.Component_Movement_Table__c;
        Map<String,Schema.RecordTypeInfo> cmtrtMapp = cc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo cmtrtByNamee ;
        
        User uu = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        User use = [Select Id from user where  IsActive = true limit 1];
        
        Stock_Point__c StockPt11 = new Stock_Point__c();
        
        StockPt11.RecordTypeId = rtMapByNamee.get('Service Center').getRecordTypeId();
        StockPt11.Service_Engineer_Name__c = 'TestEngineer1';
        StockPt11.ownerId = uu.Id;
        StockPt11.Name = 'PARWEZ ALAM';
        StockPt11.Service_Center_Location_Code__c='051-SC-PATNA';
        StockPt11.Service_Engineer_Id__c = 'P900257';
        Insert StockPt11;
        
        Stock_Point__c StockPt22 = new Stock_Point__c();
        
        
        StockPt22.Service_Engineer_Name__c = 'TestEngineer1';
        StockPt22.ownerId = uu.Id;
        StockPt22.Name = 'PARWEZ ALAM';
        StockPt22.Service_Center_Location_Code__c='051-SC-PATNA';
        StockPt22.Service_Engineer_Id__c = 'P900257';
        Insert StockPt22;
       
            
        Current_Inventory_Component__c CurrentStockk = new Current_Inventory_Component__c();
        CurrentStockk.Name = 'Test';
        CurrentStockk.Defective_Quantity_in_Hand__c = 45;
        CurrentStockk.Usable_Quantity_in_Hand__c = 20;
        CurrentStockk.Component_Code__c = '1001';
        CurrentStockk.Stock_Point__c= StockPt1.Id;
        CurrentStockk.OwnerId = uu.id;
        insert CurrentStockk;
        
        Current_Inventory_Component__c CurrentStock11 = new Current_Inventory_Component__c();
        CurrentStock11.Name = 'Test';
        CurrentStock11.Component_Code__c = '1001';
        CurrentStock11.Stock_Point__c= StockPt1.Id;
        CurrentStock11.OwnerId = uu.id;
        insert CurrentStock11;
        
        Current_Inventory_Component__c CurrentStock22 = new Current_Inventory_Component__c();
        CurrentStock22.Name = 'Test';
        CurrentStock22.Component_Code__c = '1001';
        CurrentStock22.Stock_Point__c= StockPt2.Id;
        CurrentStock22.OwnerId = uu.id;
        insert CurrentStock22;
        
        
        Product__c Prodd = new  Product__c();
        Prodd.name = 'Test';
        Prodd.Product_Code__c = '1001';
        Prodd.CurrencyIsoCode = 'INR';
        Prodd.Is_Active__c = True;
        Prodd.UoM__c = 'Set';
        Insert Prodd;
        Set<Id> pid = new Set<Id>();
        pid.add(Prod.id);
        
         //Rajni jain
            Stock_Point__c ServiceEngineer = new Stock_Point__c();
            
            serviceEngineer.RecordTypeId = rtMapByNamee.get('Service Engineer').getRecordTypeId();           
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
            
            
            
         Component_Movement_Table__c CompMove11 = new Component_Movement_Table__c();
             
            CompMove11.RecordTypeId = cmtrtMapp.get('Inward Movement').getRecordTypeId();
            CompMove11.Type_of_receipt__c = 'Stock Transfer';
            CompMove11.Component_Status__c = 'Usable';
            CompMove11.Select_Component__c = Prod.Id;
            CompMove11.Quantity__c = 10;
            CompMove11.OwnerID=uu.id;
          //  CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            //CompMove1.Service_Request__c = Cas.id;
            CompMove11.trgOldOwnerId__c = u.id;
            CompMove11.Mrn_No_Trig__c = 12;
            CompMove11.OwnerId = uu.id;
            CompMove11.Challan_No_Trig__c = 12;
            CompMove11.Product_Code_1__c = '1001';
           // compMove1.Mrn_No__c = '101010';
           // compMove1.Stock_Transfer_Sl_No__c = '1234';
            
            Insert CompMove11;
            //}catch(Exception e){}
            
             Price_Books__c pb = new Price_Books__c();
             pb.Name='Standard Price Book';
             insert pb;
         
           Price_Book_Entry__c pbe =new Price_Book_Entry__c();
           pbe.Product__c=prod.id;
           pbe.Price_Book__c=pb.id;
           pbe.UnitPrice__c=200;
           
           insert pbe;
            
        Component_Movement_Table__c CompMove22 = new Component_Movement_Table__c();
             
            CompMove22.RecordTypeId = cmtrtMapp.get('Inward Movement').getRecordTypeId();
            CompMove22.Type_of_receipt__c = 'Stock Transfer';
            CompMove22.Component_Status__c = 'Usable';
            CompMove22.Select_Component__c = Prod.Id;
            CompMove22.Quantity__c = 10;
            CompMove22.OwnerID=CompMove1.id;
          //  CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            //CompMove1.Service_Request__c = Cas.id;
            CompMove22.trgOldOwnerId__c = uu.id;
            CompMove22.Mrn_No_Trig__c = 12;
            CompMove22.OwnerId = u.id;
            CompMove22.Challan_No_Trig__c = 12;
            CompMove22.Product_Code_1__c = '1001';
           // compMove1.Mrn_No__c = '101010';
           // compMove1.Stock_Transfer_Sl_No__c = '1234';
            
            Insert CompMove22;    
            
             Component_Movement_Table__c CompMove33 = new Component_Movement_Table__c();
             
            CompMove33.RecordTypeId = cmtrtMapp.get('Inward Movement').getRecordTypeId();
            CompMove33.Type_of_receipt__c = 'Stock Transfer';
            CompMove33.Component_Status__c = 'Usable';
            CompMove33.Select_Component__c = Prod.Id;
            CompMove33.Quantity__c = 10;
            CompMove33.OwnerID=CompMove1.id;
          //  CompMove1.Received_from_Stock_Point__c = StockPt1.Id;
            //CompMove1.Service_Request__c = Cas.id;
            CompMove33.trgOldOwnerId__c = uu.id;
            
            CompMove33.OwnerId =uu.id;
            CompMove33.Challan_No_Trig__c = 12;
            CompMove33.Product_Code_1__c = '1001';
           // compMove1.Mrn_No__c = '101010';
           // compMove1.Stock_Transfer_Sl_No__c = '1234';
            
            Insert CompMove33;  
        
                    Component_Movement_Table__Share Share = new Component_Movement_Table__Share();       

            Share.parentId = CompMove1.Id;

            Share.UserorGroupId = uu.id;

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
           ownerId = uu.Id,
           TCS__c = 2,
           Bill_Date__c = System.today() 
        );
        insert sd;
        
        InventoryUpdate inv = new InventoryUpdate();
        inv.AddbyStockPointId('Test', '1001',ServiceEngineer.id, 'Usable',5); 
        inv.SubtractbyStockPointId(StockPt11.id, '1001','Usable', 10 );
        
        //inv.SubtractExistingRecord(CurrentStock,'Usable', 5);
        inv.SubtractbyOwner(uu.id,'1001','Usable', 10 );
        inv.CheckScrapStockAvailability('Test','1001', u.id, 20 );
        //inv.SetTRCMrnNo(CompMove1);
        inv.SetChallanNo(CompMove11);
        //inv.SetMrnNo(CompMove1);
        inv.SetStockTransferSlNo(CompMove11,uu.id);
        inv.SetStockTransferSlNo (CompMove11,use.id);
        //inv.PopulateStockTransferPrice(CompMove1,pid);
        ///inv.SendTRCReceiptEmail();
        Map<Id, Double> testMap = new  Map<Id, Double>();
        testMap.put(Prod.id ,1199);
        List<Product__c> products = new List<Product__c>();
        products.add(prod);
        //inv.SendTRCReceiptEmail(testMap, CompMove1, products);
        inv.ReceivebyStockPointId('test', '1001', StockPt11.id, 'Usable', 10,10 );
        inv.ReceivebyStockPointId('test', '2002', StockPt11.id, 'Usable', 10,10 );
        inv.SetTRCMrnNo(CompMove22);
        inv.SetTRCMrnNo(CompMove33);
        inv.SetNewOwner(CompMove22);
        //inv.SetSharing(Share);
    //}

        
       
    }
    
}