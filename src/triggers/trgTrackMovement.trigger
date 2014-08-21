trigger trgTrackMovement on Component_Movement_Table__c (before Insert, before Update) {
    
         
    List<Product__c> lstProduct = new List<Product__c>();
        lstProduct = [Select p.Product_Code__c, p.Name, p.Id From Product__c p];
        
        Map<String,Id> mapProduct = new Map<String,Id>();
        for(Product__c p : lstProduct){
            if(p.Product_Code__c != null ) {
                mapProduct.put(p.Product_Code__c.toUpperCase() , p.Id);
                System.debug(mapProduct.get(p.Product_Code__c));
            }
         }
         
         Schema.RecordTypeInfo rtByName = Schema.SObjectType.Component_Movement_Table__c.getRecordTypeInfosByName().get('Product Sale');
         String prodSaleRecTypeId = rtByName.getRecordTypeId();
           if(mapProduct != null && mapProduct.size() > 0 && !Test.isRunningTest()){
            for( Component_Movement_Table__c sr : Trigger.new){
               if(prodSaleRecTypeId == sr.RecordTypeId) continue; // added by varsha 15-03-2013 to stop execution in case of product sales
               
               if(sr.Product_Code_1__c != null && sr.Product_Code_1__c != '' && mapProduct.containsKey(sr.Product_Code_1__c.toUppercase())){               
                        sr.Select_Component__c = mapProduct.get(sr.Product_Code_1__c.toUpperCase());  
               }
               else{
                    if(sr.Product_Code_1__c== null && sr.Select_Component__c == null){
                    trigger.new[0].addError('Either fill correct Product Code or select Product from Products ');
                    }
                    else if(sr.Product_Code_1__c != null && !mapProduct.containsKey(sr.Product_Code_1__c.toUpperCase())){
                    trigger.new[0].addError('Please Fill correct Product Code or select Product from Products ');
                    }
                  }
                  
                  
                if(sr.Product_Code_2__c != null && sr.Product_Code_2__c != '' && mapProduct.containsKey(sr.Product_Code_2__c.toUpperCase())){               
                        sr.Select_Component_2__c = mapProduct.get(sr.Product_Code_2__c.toUpperCase());    
                  }  
                   else if(sr.Product_Code_2__c != null && !mapProduct.containsKey(sr.Product_Code_2__c.toUpperCase())){
                    trigger.new[0].addError('Please Fill correct Product Code or select Product from Products ');
                    }
                    
                    
                if(sr.Product_Code_3__c != null && sr.Product_Code_3__c != '' && mapProduct.containsKey(sr.Product_Code_3__c.toUpperCase())){               
                        sr.Select_Component_3__c = mapProduct.get(sr.Product_Code_3__c.toUpperCase());    
                  }  
                   else if(sr.Product_Code_3__c != null && !mapProduct.containsKey(sr.Product_Code_3__c.toUpperCase())){
                    trigger.new[0].addError('Please Fill correct Product Code or select Product from Products ');
                    }
                        
              
                  if(sr.Product_Code_4__c != null && sr.Product_Code_4__c != '' && mapProduct.containsKey(sr.Product_Code_4__c.toUpperCase())){               
                        sr.Select_Component_4__c = mapProduct.get(sr.Product_Code_4__c.toUpperCase());    
                  }  
                   else if(sr.Product_Code_4__c != null && !mapProduct.containsKey(sr.Product_Code_4__c.toUpperCase())){
                    trigger.new[0].addError('Please Fill correct Product Code or select Product from Products ');
                    }   
                  
           }     
      }       
      
//if(UtilClass.runOnce()) {
    if(Trigger.new.size()==1)
    {

        Map<Id, String> RecTypeMap = new Map<Id, String>();
        Set<Id> StockPtIds = new Set<Id>();
        String ErrMsg;
        String ErrMail;
        InventoryUpdate InvUpd = new InventoryUpdate();
        
        Component_Movement_Table__c CompMove = Trigger.new[0];
            
        System.Debug('++++++++++++++++++++++++Step1');
        String RecTypeName = [Select name from RecordType where Id = :CompMove.RecordTypeId].Name;
        
        System.Debug('++++++++++++++++++++++++Step2');
            
        for(Stock_Point__c StockPoint :[Select RecordType.Name, Service_Center_Description__c, 
                Service_Center_Address__c, Telephone__c, Service_Engineer_Name__c, OwnerId, Id from Stock_Point__c 
                where (OwnerId = :CompMove.OwnerId and RecordType.Name='Service Center')
                Or Id = :CompMove.Transferred_to_Stock_Point__c 
                Or Id = :CompMove.Received_from_Stock_Point__c Or Service_Center_Description__c = 'TRC'])
        { 
            
            If(RecTypeName == 'Inward Movement' && CompMove.Received_from_Stock_Point__c == StockPoint.Id)
                {
                CompMove.Issuing_Service_Center_Address__c = StockPoint.Service_Center_Address__c;
                CompMove.Stock_Point_Type__c = StockPoint.RecordType.Name;
                CompMove.Stock_Point_Owner_Id__c = String.valueof(StockPoint.OwnerId).subString(0,15);
                
                }
            Else If(RecTypeName == 'Inward Movement' && CompMove.OwnerId == StockPoint.OwnerId)
            {    
                CompMove.Receiving_Service_Center_Address__c = StockPoint.Service_Center_Address__c;
                
            }
                
            If(RecTypeName == 'Outward Movement' && CompMove.Transferred_to_Stock_Point__c == StockPoint.Id)
                {
                CompMove.Receiving_Service_Center_Address__c = StockPoint.Service_Center_Address__c;
                CompMove.Name_of_Service_Engineer__c = StockPoint.Service_Engineer_Name__c;
                CompMove.Phone_No__c = StockPoint.Telephone__c;
                CompMove.Stock_Point_Type__c = StockPoint.RecordType.Name;
                CompMove.Stock_Point_Owner_Id__c = String.valueof(StockPoint.OwnerId).subString(0,15);
                
                }
            Else If(RecTypeName == 'Outward Movement' && CompMove.OwnerId == StockPoint.OwnerId)
            {    
                CompMove.Issuing_Service_Center_Address__c = StockPoint.Service_Center_Address__c;
                
            }
                
            If(RecTypeName == 'Short Receipt' && CompMove.Received_from_Stock_Point__c == StockPoint.Id)
            {
                CompMove.Issuing_Service_Center_Address__c = StockPoint.Service_Center_Address__c;
                
             }
            Else If(RecTypeName == 'Short Receipt' && CompMove.OwnerId == StockPoint.OwnerId) 
            {   
                CompMove.Receiving_Service_Center_Address__c = StockPoint.Service_Center_Address__c;
                
             }
                
            If(CompMove.From_Org__c =='019-SC-GGN' && StockPoint.Service_Center_Description__c == 'TRC')
            {
                CompMove.Issuing_Service_Center_Address__c = StockPoint.Service_Center_Address__c;
                
             }                        
        //CompMove.UserAddress__c = StockPoint.Service_Center_Address__c;
        }       
        String ProdName = '';
        String ProdCode = '';
        
        Set<Id> ProdSet = new Set<Id>();
        Map<Id, Double> QtyMap = new Map<Id, Double>();
       
        
        System.Debug('Select_Component__c: ' + CompMove.Select_Component__c);
        System.Debug('Quantity__c: ' + CompMove.Select_Component__c);
        
        If(CompMove.Select_Component__c!=Null && CompMove.Quantity__c!=Null){
            ProdSet.add(CompMove.Select_Component__c);
            QtyMap.put(CompMove.Select_Component__c, CompMove.Quantity__c);} 
      
        If(CompMove.Select_Component_2__c!=Null && CompMove.Quantity_2__c!=Null){
            ProdSet.add(CompMove.Select_Component_2__c);
            QtyMap.put(CompMove.Select_Component_2__c, CompMove.Quantity_2__c);}
      
        If(CompMove.Select_Component_3__c!=Null && CompMove.Quantity_3__c!=Null){
            ProdSet.add(CompMove.Select_Component_3__c);
            QtyMap.put(CompMove.Select_Component_3__c, CompMove.Quantity_3__c);}
            
        If(CompMove.Select_Component_4__c!=Null && CompMove.Quantity_4__c!=Null){
            ProdSet.add(CompMove.Select_Component_4__c);
            QtyMap.put(CompMove.Select_Component_4__c, CompMove.Quantity_4__c);}
        
       
            
        /*If(CompMove.Select_Component_5__c!=Null && CompMove.Quantity_5__c!=Null){
            ProdSet.add(CompMove.Select_Component_5__c);
            QtyMap.put(CompMove.Select_Component_5__c, CompMove.Quantity_5__c);}*/                               
    
        InvUpd.PopulateStockTransferPrice(CompMove, ProdSet);
        
        
        //Add Tax on Product 
           //Get Tax 
           TAX__c objTax  = [SELECT id,End_Date__c, Start_Date__c, TAX_State__c, Name,TAX_Percentage__c FROM TAX__c];
           if(CompMove.Select_Component__c !=Null)
              CompMove.Stock_Transfer_Price_Unit_1__c = CompMove.Stock_Transfer_Price_Unit_1__c + ((CompMove.Stock_Transfer_Price_Unit_1__c*70/100) * objTax.TAX_Percentage__c/100) ;  
           if(CompMove.Select_Component_2__c !=Null)
              CompMove.Stock_Transfer_Price_Unit_2__c = CompMove.Stock_Transfer_Price_Unit_2__c + ((CompMove.Stock_Transfer_Price_Unit_2__c*70/100) * objTax.TAX_Percentage__c/100) ;  
           if(CompMove.Select_Component_3__c !=Null)
              CompMove.Stock_Transfer_Price_Unit_3__c = CompMove.Stock_Transfer_Price_Unit_3__c + ((CompMove.Stock_Transfer_Price_Unit_3__c*70/100) * objTax.TAX_Percentage__c/100) ;  
           if(CompMove.Select_Component_4__c !=Null)
              CompMove.Stock_Transfer_Price_Unit_4__c = CompMove.Stock_Transfer_Price_Unit_4__c + ((CompMove.Stock_Transfer_Price_Unit_4__c*70/100) * objTax.TAX_Percentage__c/100) ;    
        
        
        if(Trigger.IsInsert)
        {    
            If(RecTypeName == 'Inward Movement')
            {
                System.Debug('++++++++++++++++++++++++Step3');
                Product__c[] Products = [SELECT Id, Name, Product_Code__c FROM Product__c where Id in :ProdSet];
                
                for(Product__c  Prod : Products)
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c;
                    
                    InvUpd.AddbyOwner(ProdName, Prodcode, CompMove.OwnerId, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                                    
                    If(CompMove.Type_of_Receipt__c  == 'Stock Returned by Service Engineer')
                    {
                        //Now we will have to subtract the quantity from the 
                        //Inventory of the Service Engineer
                        InvUpd.SubtractbyStockPointId(CompMove.Received_from_Stock_Point__c ,ProdCode, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                }
                    
                If(CompMove.Type_of_Receipt__c  != 'Stock Transfer')
                    {                
                        
                        InvUpd.SetMrnNo(CompMove);
                        
                    }
                    
                If(CompMove.Received_from_Stock_Point__c != Null)
                {
                    String ServiceCenterName = [Select Service_Center_Description__c from Stock_Point__c 
                            where Id = :CompMove.Received_from_Stock_Point__c].Service_Center_Description__c;
                    If(CompMove.Type_of_Receipt__c  == 'Stock Transfer' && ServiceCenterName == 'TRC')
                        InvUpd.SendTRCReceiptEmail(QtyMap, CompMove, Products); 
                }                      
            }
            
            If(RecTypeName == 'Outward Movement')
            {
                System.Debug('++++++++++++++++++++++++Step16');
                
                for(Product__c  Prod :[SELECT Id, Name, Product_Code__c FROM Product__c  where Id in :ProdSet])
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c;
                    
                    //The below query retrieves the Inventory record to which
                    //quantity has to be Subtracted
                    If(CompMove.From_Org__c !='019-SC-GGN')
                        InvUpd.SubtractbyOwner(CompMove.OwnerId ,ProdCode, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    
                    If(CompMove.Type_of_Transfer__c  == 'Stock Transfer')
                    {
                        //Now we will have to add the quantity to the 
                        //Inventory of the In Transit Stock Point
                        
                        //InvUpd.AddInTransit(ProdName, ProdCode, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                        
                        
                    }
                    
                    If(CompMove.Type_of_Transfer__c  == 'Transferred to Service Engineer')
                    {
                        InvUpd.AddbyStockPointId(ProdName, ProdCode, CompMove.Transferred_to_Stock_Point__c, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                }
                
                If(CompMove.Type_of_Transfer__c  == 'Stock Transfer')
                {
                    //InvUpd.SetSharingAndNewOwner(CompMove);
                    Id OldOwner = CompMove.OwnerId;
                    InvUpd.SetNewOwner(CompMove);
                    InvUpd.SetSCCode(OldOwner);
                    If(CompMove.From_Org__c !='019-SC-GGN')
                        InvUpd.SetStockTransferSlNo(CompMove, OldOwner);
                                                          
                }
                
                If(CompMove.Type_of_Transfer__c  == 'Transferred to Service Engineer')
                {
                    InvUpd.SetChallanNo(CompMove);
                }            
            }
            
            // added by Varsha - 14 march - start
            If(RecTypeName == 'Stock Inward')
            {
                
                If(CompMove.Type_of_Transfer__c  == 'Stock Transfer')
                {
                    InvUpd.SetNewOwner(CompMove);
                                                       
                }
                           
            }
            // added by Varsha - 14 march - end
            
            If(RecTypeName == 'Reconciliation')
            {
                
                System.Debug('++++++++++++++++++++++++Step17');
                
                for(Product__c Prod :[SELECT Id, Name, Product_Code__c FROM Product__c where Id in :ProdSet])
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c;
                    
                    
                    If(CompMove.Type_of_Entry__c == 'Add')
                    {
                        InvUpd.AddbyStockPointId(ProdName, ProdCode, CompMove.Stock_Point_to_be_Reconciled__c, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                    
                    If(CompMove.Type_of_Entry__c == 'Deduct')        
                    {
                        //Now we will have to subtract the quantity from the 
                        //Inventory of the Service Engineer
                        InvUpd.SubtractbyStockPointId(CompMove.Stock_Point_to_be_Reconciled__c ,ProdCode, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                }                                            
            }
                   
            
            If(RecTypeName == 'Components Used in Service Request')
            {
            try
            {
                Service_Request__c Cas = [Select Total_Defective_Quantity_Returned__c, Total_Quantity_Issued__c, 
                                            Component_Charges__c,Warranty_Status__c,AMC_Status__c from Service_Request__c
                                            where Id =:CompMove.Service_Request__c];
                 If (CompMove.Type_of_Service_Request__c != 'Warranty' && 
                         ((cas.Warranty_Status__c == 'Yes' && cas.AMC_Status__c == 'Yes') 
                             || (cas.Warranty_Status__c == 'No' && cas.AMC_Status__c == 'No') 
                             || (cas.Warranty_Status__c == 'Yes' && cas.AMC_Status__c == 'No')))
                     CompMove.Sale_Price_Unit__c = CompMove.Stock_Transfer_Price_Unit_1__c;
                     
                System.Debug('Coming for insertion: ' + ProdSet);
                for(Product__c Prod :[SELECT Id, Name, Product_Code__c  FROM Product__c where Id in :ProdSet])
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c ;
                    
                    If(QtyMap.get(Prod.Id) != Null && QtyMap.get(Prod.Id) != 0)               
                    InvUpd.SubtractbyStockPointId(CompMove.Used_by_Service_Engineer__c ,ProdCode, 'Usable', QtyMap.get(Prod.Id));
    
                    If(CompMove.Defective_Item_is_different__c == true && CompMove.Defective_Quantity_Returned__c != Null)
                    {
                        Product__c[] DefectiveProduct = [SELECT Id, Name, Product_Code__c FROM Product__c 
                                where Id = :CompMove.Defective_Item_Returned__c];
                        //InvUpd.AddbyOwner(DefectiveProduct[0].Name, DefectiveProduct[0].ProductCode, CompMove.OwnerId, 'Defective', CompMove.Defective_Quantity_Returned__c);
                        InvUpd.AddbyStockPointId(DefectiveProduct[0].Name, DefectiveProduct[0].Product_Code__c, 
                            CompMove.Used_by_Service_Engineer__c, 'Defective', (Double)CompMove.Defective_Quantity_Returned__c);
                    }
                    Else If(CompMove.Defective_Quantity_Returned__c != Null)
                        InvUpd.AddbyStockPointId(ProdName, ProdCode,(ID)CompMove.Used_by_Service_Engineer__c, 'Defective', (Double)CompMove.Defective_Quantity_Returned__c);
                        //InvUpd.AddbyOwner(ProdName, ProdCode, CompMove.OwnerId, 'Defective', CompMove.Defective_Quantity_Returned__c);
                    //InvUpd.AddbyStockPointId(ProdName, Prodcode, CompMove.Stock_Point_Owner_Id__c, 'Defective', QtyMap.get(Prod.Id));        
                    If(QtyMap.get(Prod.Id) != Null && QtyMap.get(Prod.Id) != 0)               
    
                    InvUpd.CalculateTotalComponentCharges(CompMove);
                    
                }
            }
            catch(exception ex32)
            {
                
            }
            }
            
            
            
        }
        
        
     
        if(Trigger.IsUpdate)
        {
          if(Trigger.Old[0].Cancelled__c==False && Trigger.New[0].Cancelled__c==True)
          {
            CompMove = Trigger.old[0];  
            If(RecTypeName == 'Inward Movement')
            {
                System.Debug('++++++++++++++++++++++++Step3');
                for(Product__c Prod :[SELECT Id, Name, Product_Code__c  FROM Product__c where Id in :ProdSet])
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c ;
                    
                    InvUpd.SubtractbyOwner(CompMove.OwnerId ,ProdCode, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    
                    If(CompMove.Type_of_Receipt__c  == 'Stock Transfer')
                    {                
                        //Now we will have to subtract the quantity from the 
                        //Inventory of the In Transit Stock Point
                        //InvUpd.AddInTransit(ProdName, ProdCode, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                    
                    If(CompMove.Type_of_Receipt__c  == 'Stock Returned by Service Engineer')
                    {
                        //Now we will have to subtract the quantity from the 
                        //Inventory of the Service Engineer
                        InvUpd.AddbyStockPointId(ProdName, ProdCode, CompMove.Received_from_Stock_Point__c, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                }        
            }
            
            If(RecTypeName == 'Outward Movement')
            {
                System.Debug('++++++++++++++++++++++++Step16');
                
                for(Product__c Prod :[SELECT Id, Name, Product_Code__c  FROM Product__c where Id in :ProdSet])
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c ;
                    
                    //The below query retrieves the Inventory record to which
                    //quantity has to be Subtracted
                    InvUpd.AddbyOwner(ProdName, Prodcode, CompMove.OwnerId, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    
                    If(CompMove.Type_of_Transfer__c  == 'Stock Transfer')
                    {
                        //Now we will have to add the quantity to the 
                        //Inventory of the In Transit Stock Point
                        //InvUpd.SubtractInTransit(ProdName, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                    
                    If(CompMove.Type_of_Transfer__c  == 'Transfer to Service Engineer')
                    {
                        InvUpd.SubtractbyStockPointId(CompMove.Transferred_to_Stock_Point__c ,ProdCode, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                }            
            }
            
            If(RecTypeName == 'Reconciliation')
            {
                
                System.Debug('++++++++++++++++++++++++Step17');
                
                for(Product__c Prod :[SELECT Id, Name, Product_Code__c FROM Product__c where Id in :ProdSet])
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c;
                    
                    
                    If(CompMove.Type_of_Entry__c == 'Add')
                    {
                        InvUpd.SubtractbyStockPointId(CompMove.Stock_Point_to_be_Reconciled__c ,ProdCode, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                    
                    If(CompMove.Type_of_Entry__c == 'Deduct')        
                    {
                        //Now we will have to subtract the quantity from the 
                        //Inventory of the Service Engineer
                        InvUpd.AddbyStockPointId(ProdName, ProdCode, CompMove.Stock_Point_to_be_Reconciled__c, CompMove.Component_Status__c, QtyMap.get(Prod.Id));
                    }
                }                                            
            }
            
           
            If(RecTypeName == 'Components Used in Service Request')
            {
                for(Product__c Prod :[SELECT Id, Name, Product_Code__c FROM Product__c where Id in :ProdSet])
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c;
                    
                    InvUpd.AddbyStockPointId(ProdName, ProdCode, CompMove.Used_by_Service_Engineer__c, 'Usable', QtyMap.get(Prod.Id));
                }
            }
          }
          Else If(RecTypeName == 'Stock Inward' && Trigger.New[0].Stock_Transfer_Status__c == 'Received')
          {
              //Trigger.new[0].addError('A Component Movement can only be cancelled. The other fields cannot be updated.');
          
                Map<Id, Double> ReceivedQtyMap = new Map<Id, Double>();
                Map<Id, Double> DefectiveQtyMap = new Map<Id, Double>();
               
               
               
               
                
               If(CompMove.Select_Component__c!=Null)
                {
                    If(CompMove.Received_Quantity1__c != Null)
                        ReceivedQtyMap.put(CompMove.Select_Component__c, CompMove.Received_Quantity1__c);
                    Else
                        ReceivedQtyMap.put(CompMove.Select_Component__c, 0);
                    If(CompMove.Defective_Quantity1__c != Null)                        
                        DefectiveQtyMap.put(CompMove.Select_Component__c, CompMove.Defective_Quantity1__c);
                    Else
                        DefectiveQtyMap.put(CompMove.Select_Component__c, 0);
                }   
                
                
             
                                                              
              If(CompMove.Select_Component_2__c!=Null)
                {
                    If(CompMove.Received_Quantity2__c != Null)
                        ReceivedQtyMap.put(CompMove.Select_Component_2__c, CompMove.Received_Quantity2__c);
                    Else
                        ReceivedQtyMap.put(CompMove.Select_Component_2__c, 0);
                    If(CompMove.Defective_Quantity2__c != Null)        
                        DefectiveQtyMap.put(CompMove.Select_Component_2__c, CompMove.Defective_Quantity2__c);
                    Else
                        DefectiveQtyMap.put(CompMove.Select_Component_2__c, 0);
                }
                
                If(CompMove.Select_Component_3__c!=Null)
                {
                    If(CompMove.Received_Quantity3__c != Null)
                        ReceivedQtyMap.put(CompMove.Select_Component_3__c, CompMove.Received_Quantity3__c);
                    Else
                        ReceivedQtyMap.put(CompMove.Select_Component_3__c, 0);
                    If(CompMove.Defective_Quantity3__c != Null)
                        DefectiveQtyMap.put(CompMove.Select_Component_3__c, CompMove.Defective_Quantity3__c);
                    Else
                        DefectiveQtyMap.put(CompMove.Select_Component_3__c, 0);
                }
               
                
                If(CompMove.Select_Component_4__c!=Null)
                {
                    If(CompMove.Received_Quantity4__c != Null)
                        ReceivedQtyMap.put(CompMove.Select_Component_4__c, CompMove.Received_Quantity4__c);
                    Else
                        ReceivedQtyMap.put(CompMove.Select_Component_4__c, 0);
                    If(CompMove.Defective_Quantity4__c != Null)
                        DefectiveQtyMap.put(CompMove.Select_Component_4__c, CompMove.Defective_Quantity4__c);
                    Else   
                        DefectiveQtyMap.put(CompMove.Select_Component_4__c, 0);
                }
            
            
                                   
                Product__c[] Products = [SELECT Id, Name, Product_Code__c FROM Product__c where Id in :ProdSet];
            
                for(Product__c Prod : Products)
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c;
                    
                    InvUpd.ReceivebyStockPointId(ProdName, ProdCode, CompMove.Transferred_to_Stock_Point__c, CompMove.Component_Status__c, ReceivedQtyMap.get(Prod.Id), DefectiveQtyMap.get(Prod.Id));
                    
                }
                
                
                If(CompMove.From_Org__c =='019-SC-GGN')
                {
                    InvUpd.SetTRCMrnNo(CompMove);
                    InvUpd.SendTRCReceiptEmail(QtyMap, CompMove, Products);  
                }
                Else
                InvUpd.SetMrnNo(CompMove);                                          
          }
          Else If(RecTypeName == 'Components Used in Service Request')
          {
                Double Difference = 0;
                for(Product__c Prod :[SELECT Id, Name, Product_Code__c FROM Product__c where Id in :ProdSet])
                {
                    ProdName = prod.Name;
                    ProdCode = Prod.Product_Code__c;
                    
                    
                    If(Trigger.old[0].Defective_Quantity_Returned__c != Null && Trigger.new[0].Defective_Quantity_Returned__c != Null)
                    {
                        //InvUpd.AddbyOwner(ProdName, Prodcode, CompMove.OwnerId, 'Defective', Trigger.new[0].Defective_Quantity_Returned__c - Trigger.old[0].Defective_Quantity_Returned__c);
                        Difference = Trigger.new[0].Defective_Quantity_Returned__c - Trigger.old[0].Defective_Quantity_Returned__c;
                    }                                        
                    Else If(Trigger.new[0].Defective_Quantity_Returned__c != Null)  
                    {
                        //InvUpd.AddbyOwner(ProdName, Prodcode, CompMove.OwnerId, 'Defective', Trigger.new[0].Defective_Quantity_Returned__c);      
                        Difference = Trigger.new[0].Defective_Quantity_Returned__c;
                    }                                                            
          
                }
                
                If(CompMove.Defective_Item_is_different__c == true)
                    {
                        //Product__c[] DefectiveProduct = [SELECT Id, Name, Product_Code__c FROM Product__c where Id = :CompMove.Defective_Item_Returned__c];
                        //InvUpd.AddbyOwner(DefectiveProduct[0].Name, DefectiveProduct[0].ProductCode, CompMove.OwnerId, 'Defective', CompMove.Defective_Quantity_Returned__c);
                       // InvUpd.AddbyStockPointId(DefectiveProduct[0].Name, DefectiveProduct[0].ProductCode, CompMove.Used_by_Service_Engineer__c, 'Defective', Difference);
                    }
                    Else
                        InvUpd.AddbyStockPointId(ProdName, ProdCode, CompMove.Used_by_Service_Engineer__c, 'Defective', Difference);
                //InvUpd.AddbyOwner(ProdName, ProdCode, CompMove.OwnerId, 'Defective', Difference);
                //InvUpd.AddbyStockPointId(ProdName, Prodcode, CompMove.Stock_Point_Owner_Id__c, 'Defective', Difference);
                InvUpd.CalculateTotalUsedAndDefective(CompMove, Difference);   
          }    
                
        }
    
    }
//}
}