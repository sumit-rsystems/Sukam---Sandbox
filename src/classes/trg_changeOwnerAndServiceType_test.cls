@isTest
private class trg_changeOwnerAndServiceType_test {

    static testMethod void myUnitTest() {
      
        Product__c Prod = new Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';    
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;      
        
        
        Service_Centre_City__c scc = new Service_Centre_City__c ();
        scc.State__c = 'Haryana';
        scc.District__c = 'Gurgaon';
        scc.Name = 'Gurgaon';
        scc.Service_Center__c = 'Gurgaon';
        scc.Local_Upcountry__c = 'Local';
        insert scc ;
        
        List<User> lstUsers= new List<User>();
        lstUsers =[select Id ,city__c, name from user where city__c != null limit 1];
        lstUsers[0].city  = 'Gurgaon';   
        update lstUsers;
        
        
        Account acct = new Account(
        name = 'test',
        Customer_ID__c = '0007',
        State__c  = 'Haryana',
        District__c = 'Gurgaon',
        City__c = scc.id 
        );
       insert acct;   
        
        
     Service_Request__c Cas1 = new Service_Request__c();
        Cas1.Origin__c = 'Email';
        Cas1.Account__c = acct.id;
        Cas1.Product_Serial_No__c = '0101';
        Cas1.Service_Charge_Type__c = 'Visit';
        Cas1.Products__c = Prod.Id;
        Cas1.FSR_No__c = '12345';
        Cas1.Type_of_Service_Request__c = 'Others';
        Cas1.service_type__c = 'complain';
        Cas1.Service_Charge_Type__c = 'onsite';
        Cas1.Status__c ='New';
        cas1.CALL_TYPE__c='COMPLAIN END USER';
        cas1.Warranty_Status__c='No';
        cas1.FSR_Trig__c = 123;
    insert cas1;

    cas1.CALL_TYPE__c='TRC REPAIR';
    update cas1;
    
    try{
        cas1.Status__c='Pending';
        cas1.CALL_SUB_STATUS__c=null;
        update cas1;    
    }
    catch(Exception e){
        Boolean expectedExceptionThrown =  e.getMessage().contains('Fill Call Sub Status if status is either Pending Or Reject') ? true : false;
        //System.AssertEquals(expectedExceptionThrown, true);
    }   
     
    Service_Request__c Cas2 = new Service_Request__c();
        Cas1.Origin__c = 'Email';
        Cas1.Account__c = acct.id;
        Cas1.Product_Serial_No__c = '0101';
        Cas1.Service_Charge_Type__c = 'Visit';
        Cas1.Products__c = Prod.Id;
        Cas1.FSR_No__c = '1234567';
        Cas1.Type_of_Service_Request__c = 'Others';
        Cas1.service_type__c = 'complain';
        Cas1.Service_Charge_Type__c = 'onsite';
        Cas1.Status__c ='Assigned';
    //insert Cas2;
    
    Service_Request__c Cas3 = new Service_Request__c();
        Cas1.Origin__c = 'Email';
        Cas1.Account__c = acct.id;
        Cas1.Product_Serial_No__c = '0101';
        Cas1.Service_Charge_Type__c = 'Visit';
        Cas1.Products__c = Prod.Id;
        Cas1.FSR_No__c = '12345789';
        Cas1.Type_of_Service_Request__c = 'Others';
        Cas1.service_type__c = 'complain';
        Cas1.Service_Charge_Type__c = 'onsite';
        Cas1.Status__c ='Allocated';
    //insert Cas3;
   
        
    }
}