public class InventoryUpdate{



    String ErrMsg;

    String ErrMail;

    String SC_Code;

    Id TempAddSPId;

    Current_Inventory_Component__c NewCurInv = new Current_Inventory_Component__c();

    Map<String, Double> StockTransferPriceMap = new Map<String, Double>();

    

    public void AddbyOwner(String ProdName, String ProdCode, Id OwnId, String CompStatus, Double Qty){

    

        //The below query retrieves the Inventory record to which

        //quantity has to be added

        Current_Inventory_Component__c[] RecordToAdd = [Select Name, Usable_Quantity_in_Hand__c, 

        Defective_Quantity_in_Hand__c, Stock_Point__r.Id, Stock_Point__r.Service_Center_Location_Code__c from Current_Inventory_Component__c where

        Stock_Point__r.OwnerId = :OwnId and Stock_Point__r.RecordType.Name = 'Service Center' and Component_code__c = :ProdCode]; 

        

        //If a record to add is found, then we either add the quantity

        //to the usable quantity or the defective quantity depending on the 

        //status of the component 

        If(RecordToAdd.size()>0)

        {   

            AddtoExistingRecord(RecordToAdd[0], CompStatus, Qty);

            SC_Code = RecordToAdd[0].Stock_Point__r.Service_Center_Location_Code__c;
            system.debug('SC_Code===1===='+SC_Code);

        }

        //If a record is not found, then it means that this is the

        //first time that this component is being received

        //by the stock point and a new record has to be created

        Else

        {

            System.Debug('++++++++++++++++++++++++Step7');

            If(TempAddSPId == null){

                Stock_Point__c StockPt = [Select Id, Service_Center_Location_Code__c from Stock_Point__c where OwnerId = :OwnId and RecordType.Name='Service Center' Limit 1];

                TempAddSPId = StockPt.Id;

                SC_Code = StockPt.Service_Center_Location_Code__c;}
                system.debug('SC_Code===2===='+SC_Code);
            CreateAndAdd(TempAddSPId, ProdName, ProdCode, CompStatus, Qty);

            

        }

    

    }

    

    public void AddbyStockPointId(String ProdName, String ProdCode, Id SPId, String CompStatus, Double Qty){

   

        //Now we will have to Add the quantity to the 

        //Inventory of the Service Engineer

        Current_Inventory_Component__c[] RecordToAdd = [Select Name, Usable_Quantity_in_Hand__c, 

        Defective_Quantity_in_Hand__c, Stock_Point__r.Service_Center_Location_Code__c from Current_Inventory_Component__c where

        Stock_Point__r.Id = :SPId and Component_Code__c = :ProdCode];

        

        //If a record to add is found, then we either add the quantity

        //to the usable quantity or the defective quantity depending on the 

        //status of the component 

        If(RecordToAdd.size()>0)

        {   

            AddtoExistingRecord(RecordToAdd[0], CompStatus, Qty);

            SC_Code = RecordToAdd[0].Stock_Point__r.Service_Center_Location_Code__c;                      
            system.debug('SC_Code===3===='+SC_Code);
        }

        //If a record is not found, then it means that this is the

        //first time that this component is being received

        //by the stock point and a new record has to be created

        Else

        {

            System.Debug('++++++++++++++++++++++++Step7');

            If(TempAddSPId == null){

                Stock_Point__c StockPt = [Select Id, Service_Center_Location_Code__c from Stock_Point__c where Id = :SPId];

                TempAddSPId = StockPt.Id;

                SC_Code = StockPt.Service_Center_Location_Code__c;}
                system.debug('SC_Code===4===='+SC_Code);
                

            CreateAndAdd(TempAddSPId, ProdName, ProdCode, CompStatus, Qty);



        }

    

    }

    

    Public Void AddtoExistingRecord(Current_Inventory_Component__c CurInv, String CompStatus, Double Qty)

    {

        System.Debug('++++++++++++++++++++++++Step4');                 

        If(CompStatus == 'Usable')

        {

            System.Debug('++++++++++++++++++++++++Step5');

            If(CurInv.Usable_Quantity_in_Hand__c == Null)

                CurInv.Usable_Quantity_in_Hand__c = Qty;

            Else                                                        

                CurInv.Usable_Quantity_in_Hand__c = CurInv.Usable_Quantity_in_Hand__c + Qty;

        }

        Else

        {

            System.Debug('++++++++++++++++++++++++Step6');

            If(CurInv.Defective_Quantity_in_Hand__c == Null)

                CurInv.Defective_Quantity_in_Hand__c = Qty;

            Else                            

                CurInv.Defective_Quantity_in_Hand__c = CurInv.Defective_Quantity_in_Hand__c + Qty;

        }

        

        If(StockTransferPriceMap.containsKey(CurInv.Component_Code__c))

            CurInv.Cost_Unit__c = StockTransferPriceMap.get(CurInv.Component_Code__c);

            

        Update CurInv;   

    }

    

    Public Void CreateAndAdd(Id StockPtId, String ProdName, String Prodcode, String CompStatus, Double Qty)

    {

        Current_Inventory_Component__c CurInv = new Current_Inventory_Component__c();

            

        CurInv.Name = ProdName;

        CurInv.CurrencyIsoCode = 'INR';

        CurInv.Component_Code__c = ProdCode;

        CurInv.Stock_Point__c = StockPtId;

        

        If(CompStatus == 'Usable')

        {

            System.Debug('++++++++++++++++++++++++Step8');

            CurInv.Usable_Quantity_in_Hand__c = Qty;

            CurInv.Defective_Quantity_in_Hand__c = 0;

        }

        Else

        {

            System.Debug('++++++++++++++++++++++++Step9');

            CurInv.Defective_Quantity_in_Hand__c = Qty;                        

            CurInv.Usable_Quantity_in_Hand__c = 0;

        }

        

        If(StockTransferPriceMap.containsKey(ProdCode))

            CurInv.Cost_Unit__c = StockTransferPriceMap.get(ProdCode);

        

        Insert CurInv;

        NewCurInv = CurInv;

    }

    

    Public Void SubtractbyStockPointId(Id SPId, String ProdCode, String CompStatus, Double Qty)

    {

        Current_Inventory_Component__c[] RecordToSubtract = [Select Id, Name, Usable_Quantity_in_Hand__c, 

        Defective_Quantity_in_Hand__c from Current_Inventory_Component__c where

        Stock_Point__r.Id = :SPId and Component_code__c = :ProdCode];                         



        //We always assume that there is a record for this component

        //in the Service Engineer stockpoint. Thats the reason why we do not 

        //handle the fact that there will not be a record.

        If(RecordToSubtract.size()>0)

        {   SubtractExistingRecord(RecordToSubtract[0], CompStatus, Qty); 

                               

        }

        Else

        {

            ErrMsg = 'The component '+ ProdCode +' is not available in the Stock Point to complete the transaction';

            Trigger.new[0].addError(ErrMsg);

        }

    

    }

    

    Public Void SubtractbyOwner(Id OwnId, String ProdCode, String CompStatus, Double Qty)

    {

       /*string strrr = 'Select Name, Usable_Quantity_in_Hand__c,Defective_Quantity_in_Hand__c, Stock_Point__r.Id from Current_Inventory_Component__c where Stock_Point__r.OwnerId = '+OwnId+' and Component_Code__c = '+ProdCode+' and (Stock_Point__r.RecordType.Name = \'Service Center\' or Stock_Point__r.RecordType.Name = \'Branch\')';
        
        system.debug('Strrrr+++++'+strrr);*/
        


        Current_Inventory_Component__c[] RecordToSubtract = [Select Name, Usable_Quantity_in_Hand__c, 

        Defective_Quantity_in_Hand__c, Stock_Point__r.Id from Current_Inventory_Component__c where

        Stock_Point__r.OwnerId = :OwnId and Component_Code__c = :ProdCode 
        
        //and
        
        //(Stock_Point__r.RecordType.Name = 'Service Center' or Stock_Point__r.RecordType.Name = 'Branch')
        ];                          



        //We always assume that there is a record for this component

        //in the Service Engineer stockpoint. Thats the reason why we do not 

        //handle the fact that there will not be a record.

        If(RecordToSubtract.size()>0)

        {   

             SubtractExistingRecord(RecordToSubtract[0], CompStatus, Qty);                      

        }

        Else

        {

            ErrMsg = 'The component '+ ProdCode +' is not available in the Stock Point to complete the transaction';

            Trigger.new[0].addError(ErrMsg);

        }

    

    }

    

    Public Void SubtractExistingRecord(Current_Inventory_Component__c CurInv, String CompStatus, Double Qty)

    {

        System.Debug('++++++++++++++++++++++++Step10');

        If(CompStatus == 'Usable')

        {

            System.Debug('++++++++++++++++++++++++Step11');

            If(CurInv.Usable_Quantity_in_Hand__c >= Qty)

                CurInv.Usable_Quantity_in_Hand__c = CurInv.Usable_Quantity_in_Hand__c - Qty;

            Else{                                                        

                ErrMsg = 'Insuffecient Usable quantity  for '+ CurInv.Name +' in the Stock Point to complete the transaction';

                Trigger.new[0].addError(ErrMsg);}

        }

        Else

        {

            System.Debug('++++++++++++++++++++++++Step12');

            If(CurInv.Defective_Quantity_in_Hand__c >= Qty)

                CurInv.Defective_Quantity_in_Hand__c = CurInv.Defective_Quantity_in_Hand__c - Qty;

            Else{                            

                ErrMsg = 'Insuffecient Defective quantity  for '+ CurInv.Name +' in Stock Point to complete the transaction';

                Trigger.new[0].addError(ErrMsg);}

        }

        Update CurInv;   

    }

    

    Public Void CheckExistingRecordQty(Current_Inventory_Component__c CurInv, String CompStatus, Double Qty)

    {    

        If(CompStatus == 'Usable')

        {

            If(CurInv.Usable_Quantity_in_Hand__c >= Qty)

            {}

            Else{                                                        

                ErrMsg = 'Insuffecient Usable quantity  for '+ CurInv.Name +' in the Stock Point to complete the transaction';

                Trigger.new[0].addError(ErrMsg);}

        }

        Else

        {

            If(CurInv.Defective_Quantity_in_Hand__c >= Qty)

            {}

            Else{                            

                ErrMsg = 'Insuffecient Defective quantity  for '+ CurInv.Name +' in Stock Point to complete the transaction';

                Trigger.new[0].addError(ErrMsg);}

        }

    }

    

    public void SetMrnNo(Component_Movement_Table__c CompMove)

    {    
        system.debug('compMove========='+compMove);
        Component_Movement_Table__c[] Comp = [Select Mrn_No_Trig__c , ownerID from Component_Movement_Table__c where Mrn_No_Trig__c != null and OwnerId = :CompMove.OwnerId order by Mrn_No_Trig__c desc limit 1];

        system.debug('Comp ========='+Comp );

        If(Comp.size()>0)

        {

            CompMove.Mrn_No_Trig__c = Comp[0].Mrn_No_Trig__c + 1;

            String TempNo = String.Valueof(CompMove.Mrn_No_Trig__c);

            While(TempNo.length() < 6)    //    TempNo.length() <8  changed by amit 24/8/12

                TempNo = '0' + TempNo;  

            String strYear = '';

            String strMonth = String.ValueOf(DateTime.Now().month());

            Integer intMonth = Integer.valueOf(strMonth);

            if (intMonth >= 4) {

                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

            } else {

                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            

            }                  

            //strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
            SetSCCode(CompMove.OwnerId);//  changed by Amit Singh 24-8-12
            system.debug('SC_Code===='+SC_Code);
            CompMove.Mrn_No__c = strYear + SC_Code + '72' + TempNo.substring(0,6);

            

        }

        Else

        {

            CompMove.Mrn_No_Trig__c = 0;

            String strYear = '';

            String strMonth = String.ValueOf(DateTime.Now().month());

            Integer intMonth = Integer.valueOf(strMonth);

            if (intMonth >= 4) {

                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

            } else {

                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            

            }   

           // strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
            SetSCCode(CompMove.OwnerId);//  changed by Amit Singh 24-8-12
            
            CompMove.Mrn_No__c = strYear + SC_Code + '72' + '000000';

            

        }

        

    }

    

    public void SetTRCMrnNo(Component_Movement_Table__c CompMove)

    {   

        Component_Movement_Table__c[] PrevComp = [Select Mrn_No__c from Component_Movement_Table__c where Mrn_No__c!=Null and Stock_Transfer_Sl_No__c = :CompMove.Stock_Transfer_Sl_No__c and OwnerId = :CompMove.OwnerId limit 1];
        system.debug('Comp=====for TRCMrnNo== in if==='+PrevComp ) ; 
        

        If(PrevComp.size()>0)

        {

            CompMove.Mrn_No__c = PrevComp[0].Mrn_No__c;

                                   

        }

        Else

        { 
            Component_Movement_Table__c[] Comp = [Select Mrn_No_Trig__c from Component_Movement_Table__c where Mrn_No_Trig__c != null and OwnerId = :CompMove.OwnerId order by Mrn_No_Trig__c desc limit 1];
            system.debug('Comp=====for TRCMrnNo====='+comp ) ;   
            

            If(Comp.size()>0)

            {

                CompMove.Mrn_No_Trig__c = Comp[0].Mrn_No_Trig__c + 1;

                String TempNo = String.Valueof(CompMove.Mrn_No_Trig__c);

                While(TempNo.length() < 6)    //    TempNo.length() <8  changed by amit 24/8/12

                    TempNo = '0' + TempNo;

                String strYear = '';

                String strMonth = String.ValueOf(DateTime.Now().month());

                Integer intMonth = Integer.valueOf(strMonth);

                if (intMonth >= 4) {

                    strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

                } else {

                    strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            

                }       

                //strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                SetSCCode(CompMove.OwnerId);//  changed by Amit Singh 24-8-12
           
                CompMove.Mrn_No__c = strYear + SC_Code + '72' + TempNo.substring(0,6);

                

            }

            Else

            {

                CompMove.Mrn_No_Trig__c = 0;

                String strYear = '';

                String strMonth = String.ValueOf(DateTime.Now().month());

                Integer intMonth = Integer.valueOf(strMonth);

                if (intMonth >= 4) {

                    strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

                } else {

                    strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            

                }   
                SetSCCode(CompMove.OwnerId);//  changed by Amit Singh 24-8-12
           
                //strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                system.debug('SC_Code===SetTRCMrnNo===='+SC_Code);
                CompMove.Mrn_No__c = strYear + SC_Code + '72' + '000000';

                

            }

        }

    }

    

    public void SetChallanNo(Component_Movement_Table__c CompMove)

    {    

        Component_Movement_Table__c[] Comp = [Select Challan_No_Trig__c,ownerId from Component_Movement_Table__c where Challan_No_Trig__c != null and OwnerId = :CompMove.OwnerId order by Challan_No_Trig__c desc limit 1];
        system.debug('Comp=====for Challan no====='+comp ) ; 
       

        If(Comp.size()>0)

        {
                
            CompMove.Challan_No_Trig__c = Comp[0].Challan_No_Trig__c + 1;

            String TempNo = String.Valueof(CompMove.Challan_No_Trig__c);

            While(TempNo.length() < 6)    //    (TempNo.length() <8)  changed by amit 24/8/12

                TempNo = '0' + TempNo;  

            String strYear = '';

            String strMonth = String.ValueOf(DateTime.Now().month());

            Integer intMonth = Integer.valueOf(strMonth);

            if (intMonth >= 4) {

                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

            } else {

                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            

            }                     
            SetSCCode(CompMove.OwnerId);//  changed by Amit Singh 24-8-12
           //strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
            system.debug('TempNo======'+TempNo);
            CompMove.Challan_No__c = strYear + SC_Code + '71' + TempNo.substring(0,6);
            
            

        }

        Else 
         {
            system.debug('Comp=====for Challan no=== in else=='+CompMove) ; 
            CompMove.Challan_No_Trig__c = 0;
            system.debug(' CompMove.Challan_No_Trig__c======'+ CompMove.Challan_No_Trig__c);
            String strYear = '';

            String strMonth = String.ValueOf(DateTime.Now().month());

            Integer intMonth = Integer.valueOf(strMonth);

            if (intMonth >= 4) {
                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

            } else {
                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            

            }   

            //strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
            SetSCCode(CompMove.OwnerId); //changed by Amit Singh 24-8-12
            system.debug('SC_Code===else==='+ SC_Code);
            CompMove.Challan_No__c = strYear + SC_Code + '71' + '000000';

            

        }

        

    }

    

    public void SetStockTransferSlNo(Component_Movement_Table__c CompMove, Id OldOwner)

    {    

        //Component_Movement_Table__c[] Comp = [Select Stock_Transfer_Sl_No_Trig__c from Component_Movement_Table__c where Stock_Transfer_Sl_No_Trig__c != null and OwnerId = :OldOwner order by Stock_Transfer_Sl_No_Trig__c desc limit 1];

        

        //Get Series No from Stock Point - Added By Suri 

        Stock_Point__c[] Comp = [SELECT STN_Series__c FROM Stock_Point__c WHERE OwnerId=:OldOwner AND RecordType.Name = 'Service Center' LIMIT 1];

        

        

        If(Comp.size()>0)

        {

            //CompMove.Stock_Transfer_Sl_No_Trig__c = Comp[0].Stock_Transfer_Sl_No_Trig__c + 1;
            if(Comp[0].STN_Series__c==null)
                Comp[0].STN_Series__c = 0;
                     
            //update Comp[0];
            String TempNo = String.Valueof(Comp[0].STN_Series__c + 1);
            
            While(TempNo.length() < 6)   // replaced to (TempNo.length() < 8)   
                TempNo = '0' + TempNo; 
            
            String strYear = '';
            String strMonth = String.ValueOf(DateTime.Now().month());
            Integer intMonth = Integer.valueOf(strMonth);
            if (intMonth >= 4) {
                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
            } else {
                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            
            }                                   

            //strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

            String stockTransferSlNo = strYear + SC_Code + '70' + TempNo.substring(0,6);
            String firstStockTransferSlNo = strYear + SC_Code + '70' + '000001';
            Integer invCount = -1;
            system.debug('firstStockTransferSlNo' + firstStockTransferSlNo);
            system.debug('stockTransferSlNo' + stockTransferSlNo);
            if(Date.today().month() == 4) //If its the month of April, check if an invoice has already been entered for the month 
            {    
                invCount = [SELECT COUNT() FROM Component_Movement_Table__c WHERE Stock_Transfer_Sl_No__c = :firstStockTransferSlNo];
            }
            if(invCount == 0) // if none, then reset STN series to 0 
            {
                Comp[0].STN_Series__c = 0;
                CompMove.Stock_Transfer_Sl_No_Trig__c = Comp[0].STN_Series__c + 1;
            }else {// else, continue series
                CompMove.Stock_Transfer_Sl_No_Trig__c = Comp[0].STN_Series__c + 1;
                Comp[0].STN_Series__c = CompMove.Stock_Transfer_Sl_No_Trig__c;
            }
            update Comp[0];
            system.debug('Comp[0].STN_Series__c' + Comp[0].STN_Series__c);
            TempNo = String.Valueof(CompMove.Stock_Transfer_Sl_No_Trig__c);
            While(TempNo.length() < 6)  // TempNo.length() < 8
                TempNo = '0' + TempNo; 
                
            stockTransferSlNo = strYear + SC_Code + '70' + TempNo.substring(0,6);
            system.debug('stockTransferSlNo' + stockTransferSlNo);
            CompMove.Stock_Transfer_Sl_No__c = stockTransferSlNo;
            

        }

        Else

        { 
        
        Stock_Point__c[] Comp1 = [SELECT STN_Series__c FROM Stock_Point__c WHERE OwnerId=:OldOwner AND RecordType.Name = 'Branch' 
            order by CreatedDate Desc LIMIT 1];
           if (Comp1.size()>0)      
           {system.debug('=======in if========'+Comp1);
           
            //CompMove.Stock_Transfer_Sl_No_Trig__c = Comp[0].Stock_Transfer_Sl_No_Trig__c + 1;
            if(Comp1[0].STN_Series__c==null)
                Comp1[0].STN_Series__c = 0;
                     
            //update Comp[0];
            String TempNo1 = String.Valueof(Comp1[0].STN_Series__c + 1);
            
            While(TempNo1.length() < 6)   // replaced to (TempNo1.length() < 8)   
                TempNo1 = '0' + TempNo1; 
            
            String strYear = '';
            String strMonth = String.ValueOf(DateTime.Now().month());
            Integer intMonth = Integer.valueOf(strMonth);
            if (intMonth >= 4) {
                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
            } else {
                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            
            }                                   

            //strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

            String stockTransferSlNo = strYear + SC_Code + '70' + TempNo1.substring(0,6);
            String firstStockTransferSlNo = strYear + SC_Code + '70' + '000001';
            Integer invCount = -1;
            system.debug('firstStockTransferSlNo' + firstStockTransferSlNo);
            system.debug('stockTransferSlNo' + stockTransferSlNo);
            if(Date.today().month() == 4) //If its the month of April, check if an invoice has already been entered for the month 
            {    
                invCount = [SELECT COUNT() FROM Component_Movement_Table__c WHERE Stock_Transfer_Sl_No__c = :firstStockTransferSlNo];
            }
            if(invCount == 0) // if none, then reset STN series to 0 
            {
                Comp1[0].STN_Series__c = 0;
                CompMove.Stock_Transfer_Sl_No_Trig__c = Comp1[0].STN_Series__c + 1;
            }else {// else, continue series
                CompMove.Stock_Transfer_Sl_No_Trig__c = Comp1[0].STN_Series__c + 1;
                Comp1[0].STN_Series__c = CompMove.Stock_Transfer_Sl_No_Trig__c;
            }
            update Comp1[0];
            system.debug('Comp1[0].STN_Series__c' + Comp1[0].STN_Series__c);
            TempNo1 = String.Valueof(CompMove.Stock_Transfer_Sl_No_Trig__c);
            While(TempNo1.length() < 6)  // TempNo1.length() < 8
                TempNo1 = '0' + TempNo1; 
                
            stockTransferSlNo = strYear + SC_Code + '70' + TempNo1.substring(0,6);
            system.debug('stockTransferSlNo' + stockTransferSlNo);
            CompMove.Stock_Transfer_Sl_No__c = stockTransferSlNo;
           
        
        
        }
             Else {  
            CompMove.Stock_Transfer_Sl_No_Trig__c = 0;

            String strYear = '';

            String strMonth = String.ValueOf(DateTime.Now().month());

            Integer intMonth = Integer.valueOf(strMonth);

            if (intMonth >= 4) {

                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

            } else {

                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            

            }   

            //strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

            CompMove.Stock_Transfer_Sl_No__c = strYear + SC_Code + '70' + '000000';

            

        }

        

    }
}
    

    /*public void SetTRCStockTransferSlNo(Component_Movement_Table__c CompMove)

    {    

        Component_Movement_Table__c[] PrevComp = [Select Stock_Transfer_Sl_No__c from Component_Movement_Table__c where Ora_Id__c = :CompMove.Ora_Id__c limit 1];

        

        If(PrevComp.size()>0)

            CompMove.Stock_Transfer_Sl_No__c = PrevComp[0].Stock_Transfer_Sl_No__c;

        Else

        {

            Component_Movement_Table__c[] Comp = [Select Stock_Transfer_Sl_No_Trig__c from Component_Movement_Table__c where Stock_Transfer_Sl_No_Trig__c != null order by Stock_Transfer_Sl_No_Trig__c desc limit 1];

            

            If(Comp.size()>0)

            {

                CompMove.Stock_Transfer_Sl_No_Trig__c = Comp[0].Stock_Transfer_Sl_No_Trig__c + 1;

                String TempNo = String.Valueof(CompMove.Stock_Transfer_Sl_No_Trig__c);

                While(TempNo.length() < 8)

                    TempNo = '0' + TempNo;    

                String strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

                CompMove.Stock_Transfer_Sl_No__c = strYear + SC_Code + '70' + TempNo.substring(0,6);

                

            }

            Else

            {

                CompMove.Stock_Transfer_Sl_No_Trig__c = 0;

                String strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);

                CompMove.Stock_Transfer_Sl_No__c = strYear + SC_Code + '70' + '000000';

                

            }

        }

    }*/

    

    /*public void SendShortReceiptEmail(Map<Id, Double> QtyMap, Component_Movement_Table__c CompMove, Product__c[] Products)

    {

        String StockPtName = [Select Id, Name from Stock_Point__c where OwnerId = :CompMove.OwnerId and RecordType.Name='Service Center' Limit 1].Name;

        

        String htmlBody;

        htmlBody = '<p>Dear Sir,</p><p><o:p> </o:p></p>';

        htmlBody = htmlBody + 'Please be informed that a Short Receipt transaction (via MRN No.';

        htmlBody = htmlBody + String.ValueOf(CompMove.Mrn_No__c);

        htmlBody = htmlBody + ' has taken place to ';

        htmlBody = htmlBody + StockPtName;

        htmlBody = htmlBody + '<p>The list of items is as follows</p>';

        htmlBody = htmlBody + '<table border="1"><tr><td>Component Code</td>';

        htmlBody = htmlBody + '<td>Component Description</td>';

        htmlBody = htmlBody + '<td>Quantity</td></tr>';

        

        for(Product__c Prod :Products)

        {

            htmlBody = htmlBody + '<tr><td>' + Prod.ProductCode + '</td>';

            htmlBody = htmlBody + '<td>' + Prod.Name + '</td>';

            htmlBody = htmlBody + '<td>' + String.valueOf(QtyMap.get(Prod.Id)) + '</td></tr>';

        }

        htmlBody = htmlBody + '</table>';

                        

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String[] toAddresses = new String[] {'arun.david@listertechnologies.com', 'ameen.rahim@listertechnologies.com', 'saurav.bharadwaj@listertechnologies.com', 'bhuvaneswari.rajasekaran@listertechnologies.com'}; 

        mail.setToAddresses(toAddresses);

        //mail.setReplyTo('support@verbatim.com');

        mail.setSenderDisplayName('Sukam Support');

        mail.setSubject('Short Receipt Notification');

        mail.setBccSender(false);

        mail.setUseSignature(false);

        mail.setHtmlBody(htmlBody);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }*/

    

    public void SendTRCReceiptEmail ( Map<Id, Double> QtyMap, Component_Movement_Table__c CompMove, Product__c[] Products)

    {

        String StockPtName = [Select Id, Name from Stock_Point__c where OwnerId = :CompMove.OwnerId and RecordType.Name='Service Center' Limit 1].Name;

        

        String htmlBody;

        htmlBody = '<p>Dear Sir,</p><p><o:p> </o:p></p>';

        htmlBody = htmlBody + 'Please be informed that an Inward receipt transaction (via MRN No.';

        htmlBody = htmlBody + String.ValueOf(CompMove.Mrn_No__c);

        htmlBody = htmlBody + ') has taken place from TRC to ';

        htmlBody = htmlBody + StockPtName;

        htmlBody = htmlBody + '<p>The list of items is as follows</p>';

        htmlBody = htmlBody + '<table border="1"><tr><td>Component Code</td>';

        htmlBody = htmlBody + '<td>Component Description</td>';

        htmlBody = htmlBody + '<td>Quantity</td></tr>';

        

        for(Product__c Prod :Products)

        {

            htmlBody = htmlBody + '<tr><td>' + Prod.Product_Code__c + '</td>';

            htmlBody = htmlBody + '<td>' + Prod.Name + '</td>';

            htmlBody = htmlBody + '<td>' + String.valueOf(QtyMap.get(Prod.Id)) + '</td></tr>';

        }

        htmlBody = htmlBody + '</table>';

                        

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String[] toAddresses = new String[] {'sukamadmin@su-kam.com'}; 

        mail.setToAddresses(toAddresses);

        //mail.setReplyTo('');

        mail.setSenderDisplayName('Sukam Support');

        mail.setSubject('TRC Receipt Notification');

        mail.setBccSender(false);

        mail.setUseSignature(false);

        mail.setHtmlBody(htmlBody);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }

    

    public void CalculateTotalComponentCharges(Component_Movement_Table__c CompMove)

    {

        If(CompMove.Service_Request__c!=null)

        {
              system.debug('+++++ABC'+CompMove);
            Double TotalCharges;

            Double TotalUsed;

            Double TotalDefective;
            
            //Lister changes begin
            If(CompMove.Sale_Price_Unit__c == Null)

                TotalCharges = 0;

            //Else if(CompMove.Discount__c!=NULL)

            //    TotalCharges = (CompMove.Actual_Sale_Price__c - (CompMove.Actual_Sale_Price__c * CompMove.Discount__c) ) * CompMove.Quantity__c;
            Else
                TotalCharges = CompMove.Sale_Price_Unit__c * CompMove.Quantity__c;
            
            /*If(CompMove.Sale_Price_Unit__c==Null)

                TotalCharges = 0;

            Else

                TotalCharges = CompMove.Sale_Price_Unit__c * CompMove.Quantity__c;     */                                           
            //Lister changes end
            
            //multiplied quantity and sale price to get total charges

            

            If(CompMove.Quantity__c==Null)

                TotalUsed = 0;

            Else

                TotalUsed = CompMove.Quantity__c;  

                

            If(CompMove.Defective_Quantity_Returned__c==Null)

                TotalDefective = 0;

            Else

                TotalDefective = CompMove.Defective_Quantity_Returned__c;  

                

            for(Component_Movement_Table__c ServiceComponent :[Select Sale_Price_Unit__c, Defective_Quantity_Returned__c, Quantity__c from Component_Movement_Table__c where Service_Request__c = :CompMove.Service_Request__c])

            {         
                //Lister changes begin
                /*If(ServiceComponent.Sale_Price_Unit__c != null && ServiceComponent.Quantity__c!= Null)

                    TotalCharges = TotalCharges + (ServiceComponent.Sale_Price_Unit__c * ServiceComponent.Quantity__c);*/                    
                    
                //If(ServiceComponent.Actual_Sale_Price__c != null && ServiceComponent.Quantity__c!= Null && CompMove.Discount__c !=Null)

                //    TotalCharges = TotalCharges + (ServiceComponent.Actual_Sale_Price__c - (ServiceComponent.Actual_Sale_Price__c * ServiceComponent.Discount__c) ) * ServiceComponent.Quantity__c;
                //else
                if(ServiceComponent.Sale_Price_Unit__c != NULL && ServiceComponent.Quantity__c != NULL)
                    TotalCharges = TotalCharges + (ServiceComponent.Sale_Price_Unit__c * ServiceComponent.Quantity__c);

                //Lister changes end

                If(ServiceComponent.Quantity__c!= Null)

                    TotalUsed = TotalUsed + ServiceComponent.Quantity__c;

                

                If(ServiceComponent.Defective_Quantity_Returned__c!= Null)

                    TotalDefective = TotalDefective + ServiceComponent.Defective_Quantity_Returned__c;                    

            }

            system.debug('+++++TotalChargee++'+TotalCharges);

            Service_Request__c Cas = [Select Total_Defective_Quantity_Returned__c, Total_Quantity_Issued__c, Component_Charges__c,Warranty_Status__c,AMC_Status__c from Service_Request__c where Id =:CompMove.Service_Request__c];
            IF(cas.Warranty_Status__c == 'No' && cas.AMC_Status__c == 'No')//(cas.Warranty_Status__c == 'Yes' && cas.AMC_Status__c == 'Yes') || (cas.Warranty_Status__c == 'No' && cas.AMC_Status__c == 'No') || (cas.Warranty_Status__c == 'Yes' && cas.AMC_Status__c == 'No') changed by amit Singh 28/2/13
                Cas.Component_Charges__c = TotalCharges;

            Cas.Total_Defective_Quantity_Returned__c = TotalDefective;

            Cas.Total_Quantity_Issued__c = TotalUsed;

            Update Cas;

        }                        

    }

    

    public void CalculateTotalUsedAndDefective(Component_Movement_Table__c CompMove, Double Difference)

    {

        If(CompMove.Service_Request__c!=null)

        {

            Double TotalDefective = Difference;

            

            for(Component_Movement_Table__c ServiceComponent :[Select Defective_Quantity_Returned__c, Quantity__c from Component_Movement_Table__c where Service_Request__c = :CompMove.Service_Request__c])

            {         

                

                If(ServiceComponent.Defective_Quantity_Returned__c!= Null)

                    TotalDefective = TotalDefective + ServiceComponent.Defective_Quantity_Returned__c;

                                       

            }

            

            Service_Request__c Cas = [Select Total_Defective_Quantity_Returned__c, Total_Quantity_Issued__c from Service_Request__c where Id =:CompMove.Service_Request__c];

            Cas.Total_Defective_Quantity_Returned__c = TotalDefective;

            Update Cas;

        }                        

    }

    public Void PopulateStockTransferPrice(Component_Movement_Table__c CompMove, Set<Id> ProdSet)
    {

        for(Price_Book_Entry__c PriceBkEntry: [SELECT Product__r.Product_Code__c, Name, UnitPrice__c, Product__c, Product__r.Name FROM Price_Book_Entry__c 

        //where Price_Book__r.Name = 'Standard Price Book' And Product__c in:ProdSet])
        where Price_Book__r.Name = 'Standard' And Product__c in:ProdSet])
        {   
           StockTransferPriceMap.put(PriceBkEntry.Product__r.Product_Code__c, PriceBkEntry.UnitPrice__c);

           If(CompMove.Select_Component__c==PriceBkEntry.Product__c)

                CompMove.Stock_Transfer_Price_Unit_1__c = PriceBkEntry.UnitPrice__c;

            If(CompMove.Select_Component_2__c==PriceBkEntry.Product__c)

                CompMove.Stock_Transfer_Price_Unit_2__c = PriceBkEntry.UnitPrice__c;

            If(CompMove.Select_Component_3__c==PriceBkEntry.Product__c)

                CompMove.Stock_Transfer_Price_Unit_3__c = PriceBkEntry.UnitPrice__c;

            If(CompMove.Select_Component_4__c==PriceBkEntry.Product__c)

                CompMove.Stock_Transfer_Price_Unit_4__c = PriceBkEntry.UnitPrice__c;

            /*If(CompMove.Select_Component_5__c==PriceBkEntry.Product__c)

                CompMove.Stock_Transfer_Price_Unit_5__c = PriceBkEntry.UnitPrice;*/

        }

    }

    public void RepairbyOwner(String ProdName, String ProdCode, Id OwnId, Double Qty)
   {

        //The below query retrieves the Inventory record to which

        //quantity has to be added

        Current_Inventory_Component__c[] RecordToAdjust = [Select Name, Usable_Quantity_in_Hand__c, 

        Defective_Quantity_in_Hand__c, Stock_Point__r.Id, Stock_Point__r.Service_Center_Location_Code__c from Current_Inventory_Component__c where

        Stock_Point__r.OwnerId = :OwnId and Stock_Point__r.RecordType.Name = 'Service Center' and Component_Code__c = :ProdCode]; 

        //If a record to add is found, then we either add the quantity

        //to the usable quantity or the defective quantity depending on the 

        //status of the component 

        If(RecordToAdjust.size()>0)
        {   
            SubtractExistingRecord(RecordToAdjust[0], 'Defective', Qty); 
            AddtoExistingRecord(RecordToAdjust[0], 'Usable', Qty);
        }

        //If a record is not found, then it means that this is the

        //first time that this component is being received

        //by the stock point and a new record has to be created

        Else
        {

            ErrMsg = 'Insuffecient Defective quantity  for '+ ProdName +' in Stock Point to complete the transaction';

                Trigger.new[0].addError(ErrMsg);
        }
    }

    public void ScrapSalebyOwner(String ProdName, String ProdCode, Id OwnId, Double Qty)
    {
        //The below query retrieves the Inventory record to which

        //quantity has to be added

        Current_Inventory_Component__c[] RecordToAdjust = [Select Name, Usable_Quantity_in_Hand__c, 

        Defective_Quantity_in_Hand__c, Stock_Point__r.Id, Stock_Point__r.Service_Center_Location_Code__c from Current_Inventory_Component__c where

        Stock_Point__r.OwnerId = :OwnId and Stock_Point__r.RecordType.Name = 'Service Center' and Component_Code__c = :ProdCode]; 

        //If a record to add is found, then we either add the quantity

        //to the usable quantity or the defective quantity depending on the 

        //status of the component 

        If(RecordToAdjust.size()>0)
        {   
            SubtractExistingRecord(RecordToAdjust[0], 'Defective', Qty); 
        }

        //If a record is not found, then it means that this is the

        //first time that this component is being received

        //by the stock point and a new record has to be created

        Else
        {
            ErrMsg = 'Insuffecient Defective quantity  for '+ ProdName +' in Stock Point to complete the transaction';

                Trigger.new[0].addError(ErrMsg);
        }
    }

    public void CheckScrapStockAvailability(String ProdName, String ProdCode, Id OwnId, Double Qty)
    {
        //The below query retrieves the Inventory record to which

        //quantity has to be added

        Current_Inventory_Component__c[] RecordToAdjust = [Select Name, Usable_Quantity_in_Hand__c, 

        Defective_Quantity_in_Hand__c, Stock_Point__r.Id, Stock_Point__r.Service_Center_Location_Code__c from Current_Inventory_Component__c where

        Stock_Point__r.OwnerId = :OwnId and Stock_Point__r.RecordType.Name = 'Service Center' and Component_Code__c = :ProdCode]; 
 
        //If a record to add is found, then we either add the quantity

        //to the usable quantity or the defective quantity depending on the 

        //status of the component 

        If(RecordToAdjust.size()>0)
        {   
          CheckExistingRecordQty(RecordToAdjust[0], 'Defective', Qty); 
        }

        //If a record is not found, then it means that this is the

        //first time that this component is being received

        //by the stock point and a new record has to be created

        Else
        {
            ErrMsg = 'Insuffecient Defective quantity  for '+ ProdName +' in Stock Point to complete the transaction';

                Trigger.new[0].addError(ErrMsg);
        }
   }

    public void SetSCCode(Id OwnId)
    {
        Stock_Point__c StockPt = [Select Id, Name, Service_Center_Location_Code__c, RecordType.Name 
                        from Stock_Point__c where OwnerId = :OwnId and 
                        (RecordType.Name = 'Service Center' or RecordType.Name = 'Branch') Limit 1];  // added Branch rectype condition by varsha 14-3-2013
        
        SC_Code = StockPt.Service_Center_Location_Code__c;
        if(SC_Code != null && SC_Code != '') {
            if(StockPt.RecordType.Name == 'Service Center')
                SC_Code = SC_Code.substring(0,3);
            else if(StockPt.RecordType.Name == 'Branch')
                SC_Code = SC_Code.substring(0,4);
        }
        system.debug('SC_Code==SetSCCode=='+SC_Code);
    }

    public void SetSharing(Component_Movement_Table__c CompMove)
    {
       If(CompMove.trgOldOwnerId__c != Null && CompMove.trgOldOwnerId__c != '')
       {
            Component_Movement_Table__Share Share = new Component_Movement_Table__Share();       

            Share.parentId = CompMove.Id;

            Share.UserorGroupId = CompMove.trgOldOwnerId__c;

            Share.AccessLevel = 'Read';

            Insert Share;   

        }            
    }

    public void SetNewOwner(Component_Movement_Table__c CompMove)
    {
        If(CompMove.Transferred_to_Stock_Point__c!= Null)
        {
            CompMove.trgOldOwnerId__c = CompMove.OwnerId;
            Id NewOwnId = [Select OwnerId from Stock_Point__c where Id = :CompMove.Transferred_to_Stock_Point__c].OwnerId;
            CompMove.OwnerId = NewOwnId;
        }            
    }
   

    public void ReceivebyStockPointId(String ProdName, String ProdCode, Id SPId, String CompStatus, Double UseQty, Double DefQty){
   

        //Now we will have to Add the quantity to the 

        //Inventory of the Service Engineer

        Current_Inventory_Component__c[] RecordToAdd = [Select Name, Usable_Quantity_in_Hand__c, 

        Defective_Quantity_in_Hand__c, Stock_Point__r.Service_Center_Location_Code__c from Current_Inventory_Component__c where

        Stock_Point__r.Id = :SPId and Component_Code__c = :ProdCode];

        //If a record to add is found, then we either add the quantity

        //to the usable quantity or the defective quantity depending on the 

        //status of the component 

        If(RecordToAdd.size()>0)
        {   
            AddtoExistingRecord(RecordToAdd[0], 'Usable', UseQty);
            AddtoExistingRecord(RecordToAdd[0], 'Defective', DefQty);
            SC_Code = RecordToAdd[0].Stock_Point__r.Service_Center_Location_Code__c;   
            system.debug('SC_Code====ReceivebyStockPointId====='+SC_Code) ;                  
        }

        //If a record is not found, then it means that this is the

        //first time that this component is being received

        //by the stock point and a new record has to be created

        Else
        {
            System.Debug('++++++++++++++++++++++++Step7');
            If(TempAddSPId == null){

                Stock_Point__c StockPt = [Select Id, Service_Center_Location_Code__c from Stock_Point__c where Id = :SPId];

                TempAddSPId = StockPt.Id;

                SC_Code = StockPt.Service_Center_Location_Code__c;
                system.debug('SC_Code====ReceivebyStockPointId==else==='+SC_Code) ; 
                }
            CreateAndAdd(TempAddSPId, ProdName, ProdCode, CompStatus, useQty);
            AddtoExistingRecord(NewCurInv, 'Defective', DefQty);
        }
    }

    public void subtractStockFromServiceEngineer(Component_Movement_Table__c CompMove) {
    
    }
}