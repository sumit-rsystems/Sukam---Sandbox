@isTest
public class ServiceEngineerTest{
    static testMethod void ServiceEngineerTestMethod(){ 
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
		Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
		Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Engineer');
		Id serectypeid = rtByName.getRecordTypeId();
		 
        Id RecId = serectypeid;  //[Select Id from RecordType where Name = 'Service Engineer' and SObjectType = 'Stock_Point__c'].Id;
        User u = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        
        Stock_Point__c SP = new Stock_Point__c();
        SP.Service_Engineer_Name__c = 'test';
        SP.RecordTypeId = RecId;
        SP.OwnerId = u.id;
        Insert SP;
        
        Service_Request__c Cas = new Service_Request__c();
        Cas.Service_Engineer_Assigned__c = SP.Id;
        Cas.Product_Serial_No__c = '0101';
        Cas.OwnerId = u.id;
       // Insert Cas;
           
    
    }
}