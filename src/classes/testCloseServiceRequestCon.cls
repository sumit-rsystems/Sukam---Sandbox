@isTest
public class testCloseServiceRequestCon{
    private static testMethod void myUnitTestForCloseServiceRequest(){
        User u = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        
        Product__c Prod = new Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        
        
       Account acct = new Account(
        name = 'test',
        Customer_ID__c = '0007'
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
        
        Service_Request__c Cas1 = new Service_Request__c();
        Cas1.Origin__c = 'Email';
        Cas1.Contact__c = cont.id;
        Cas1.Product_Serial_No__c = '0101';
        Cas1.Service_Charge_Type__c = 'Visit';
        Cas1.Products__c = Prod.Id;
        Cas1.OwnerId = u.id;
        Cas1.Type_of_Service_Request__c = 'Others';
        Insert Cas1;
        ApexPages.currentPage().getParameters().put('id',cas1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(cas1);
        CloseServiceRequestCon csr = new CloseServiceRequestCon(con);
        
        csr.srObj.Completion_Date_Time__c = system.now();
        csr.srObj.Attended_Date_Time__c =  system.now();   
        csr.srObj.Reason__c =  'SYSTEM DEAD';  
        csr.srObj.Service_Type__c = 'LOCAL - ON SITE';
        csr.srObj.CALL_TYPE__c = 'COMPLAIN END USER';
        csr.srObj.Preferred_Date_for_Visit__c = Date.Today();
        csr.srObj.Warranty_Status__c = 'No';
        csr.getOptions();
        csr.SelectedStatus = 'Closed';
        csr.doSave();
        csr.doCancel();
        Service_Request__c Cas = new Service_Request__c();
        Cas = [Select id, Status__c from Service_Request__c where id=:Cas1.id];
        //system.assertEquals('Closed', cas.Status__c);       
    }

}