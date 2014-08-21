@isTest
public class Test_MapCaseToCustom {
    
    private static testMethod void myUnitTest(){
      
      
    Account acc = new Account(
        name = 'test',
        Customer_ID__c = 'ACC-1001'
        );
        insert acc; 
   

    Contact con = new Contact(
            LastName = 'Test Contact1',
            phone = '01122120767',
            email = 'a@b.com',
            AccountId = acc.id
            );
        insert con;
        
        Product__c Prod1 = new Product__c();
        Prod1.name = 'Testt1';
        Prod1.Product_Code__c = '10022';
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Insert Prod1; 
        
      
       Case cas = new Case(
           AccountId = acc.id,
           ContactId = con.id,
           Origin = 'Email',
           Priority='P1',
           Status = 'Assigned',
           CALL_TYPE__c = 'COMPLAIN END USER',
           Reason = 'SYSTEM NOT WORKING ON MAINS',
           Warranty_Status__c = 'Yes',
           Preferred_Date_for_Visit__c = Date.today(),
           Product_Category__c = 'BATTERY',
           CurrencyIsoCode  = 'INR'
      );
       insert cas; 
       update cas;
       system.assert(cas.id != null);
    }    
}