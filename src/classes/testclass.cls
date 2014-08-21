public class testclass{



    String ErrMsg;

    String ErrMail;

    String SC_Code;

    Id TempAddSPId;

    Current_Inventory_Component__c NewCurInv = new Current_Inventory_Component__c();

    Map<String, Double> StockTransferPriceMap = new Map<String, Double>();

    

    public void AddbyOwner(String ProdName, String ProdCode, Id OwnId, String CompStatus, Double Qty){

        //The below query retrieves the Inventory record to which

        //quantity has to be added
		Component_Movement_Table__Share Share = new Component_Movement_Table__Share();   
        Current_Inventory_Component__c[] RecordToAdd = [Select Name, Usable_Quantity_in_Hand__c, 

        Defective_Quantity_in_Hand__c, Stock_Point__r.Id, Stock_Point__r.Service_Center_Location_Code__c from Current_Inventory_Component__c where

        Stock_Point__r.OwnerId = :OwnId and Stock_Point__r.RecordType.Name = 'Service Center' and Component_code__c = :ProdCode];              

        If(RecordToAdd.size()>0)

        {   
            SC_Code = RecordToAdd[0].Stock_Point__r.Service_Center_Location_Code__c;
        }
         Else

        {
        	  
        	  Stock_Point__c StockPt = [Select Id, Service_Center_Location_Code__c 
        	  from Stock_Point__c where 
        	  OwnerId = :OwnId and 
        	  RecordType.Name='Service Center' Limit 1];             
        	
        
        }

    }

    static testMethod void dotest(){
        testclass obj = new testclass();
        List<RecordType> rt = [select id,name from recordtype where name =: 'Service Center'];        
        Stock_Point__c s = new Stock_Point__c(recordtypeid=rt[0].id);
        insert s;
        
		obj.AddbyOwner('abc', 'acv', Userinfo.getUserId(), '', 2);  
    }         

}