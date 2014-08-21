@isTest
public class Test_insertProductNameonCMT{
    public static testMethod void getCodeCoverage(){
        
        Schema.DescribeSObjectResult c = Schema.SObjectType.Component_Movement_Table__c;
        Map<String,Schema.RecordTypeInfo> cmtrtMap = c.getRecordTypeInfosByName();
        Schema.RecordTypeInfo cmtrtByName ;       
       
        Product__c Prod = new Product__c();
        Prod.Name = 'Test Product';
        Prod.Product_Code__c= '1234';
        Prod.Is_Active__c = true;
        Prod.UoM__c = 'Kg';
        insert Prod ;
        
        Product__c Prod1 = new Product__c();
        Prod1.name = 'Test1';
        Prod1.Product_Code__c = '10012';
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Insert Prod1;   
        
        Product__c Prod2 = new Product__c();
        Prod2.Name = 'Test Product1';
        Prod2.Product_Code__c= '12414';
        Prod2.Is_Active__c = true;
        Prod2.UoM__c = 'Kg';
        insert Prod2 ;  
        
        Product__c Prod3 = new Product__c();
        Prod3.Name = 'Test Product2';
        Prod3.Product_Code__c= '12400';
        Prod3.Is_Active__c = true;
        Prod3.UoM__c = 'Kg';
        insert Prod3 ;   
        
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
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Center');
        Id stockId = rtByName.getRecordTypeId();

        Stock_Point__c StockPt1 = new Stock_Point__c();
        StockPt1.RecordTypeId = stockId ;
        StockPt1.Service_Center_Description__c = 'TestCenter1';
        StockPt1.Service_Center_Address__c = 'Address1';
        StockPt1.OwnerId = u.Id;
        StockPt1.Service_Center_Location_Code__c = '033-';
        Insert StockPt1;
        
        Stock_Point__c StockPt2 = new Stock_Point__c();
        StockPt2.RecordTypeId = stockId ;
        StockPt2.Service_Center_Description__c = 'TestCenter2';
        StockPt2.Service_Center_Address__c = 'Address1';
        StockPt2.OwnerId = u.Id;
        StockPt2.Service_Center_Location_Code__c = '033-';
        Insert StockPt2;
        
        
        Current_Inventory_Component__c  cic = new Current_Inventory_Component__c ();
        cic.Component_code__c = '12400';
        cic.Name = 'test';
        cic.Usable_Quantity_in_Hand__c = 200;
        cic.Stock_Point__c = StockPt1.id;
        insert cic;
        
        
        Current_Inventory_Component__c  cic1 = new Current_Inventory_Component__c ();
        cic1.Component_code__c = '12345';
        cic1.Name = 'test';
        cic1.Usable_Quantity_in_Hand__c = 200;
        cic1.Stock_Point__c = StockPt2.id;
        insert cic1;
        
                    
        Component_Movement_Table__c CompMove = new Component_Movement_Table__c();
        CompMove.RecordTypeId = cmtrtMap.get('Inward Movement').getRecordTypeId();
        CompMove.Type_of_receipt__c = 'Service Center';
        CompMove.Component_Status__c = 'Usable';
        CompMove.Quantity__c = 10;
        CompMove.Quantity_2__c = 20;
        CompMove.Quantity_3__c = 30;
        CompMove.Quantity_4__c = 40;  
        CompMove.OwnerID=u.id;
        CompMove.Select_Component__c = prod.id;
        CompMove.Select_Component_2__c = prod1.id;
        CompMove.Select_Component_3__c = prod2.id;
        CompMove.Select_Component_4__c = prod3.id;
        compMove.Cancelled__c = False;
        CompMove.Received_from_Stock_Point__c = StockPt1.Id;
        CompMove.Stock_Point_Type__c = 'Service Engineer';
        CompMove.Product_Code_1__c ='1234';
        CompMove.Product_Code_2__c ='10012';
        CompMove.Product_Code_3__c ='12414';
        CompMove.Product_Code_4__c ='12400';
        Insert CompMove;
        
        
       
        
    }
    

}