@isTest
public class Test_trgCaseSetOwner{
    public static testMethod void getCoverage(){
    
        User u = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        
        Product__c Prod = new Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        
        Service_Centre_City__c scc = new Service_Centre_City__c(
            Name = 'aa',
            Service_Centre_Name__c = u.id
        );
        insert scc;
        
        Service_Request__c caseobj = new Service_Request__c();
        caseobj.Origin__c = 'Email';
        caseobj.Product_Serial_No__c = '0101';
        caseobj.Service_Charge_Type__c = 'Carry In';
        caseobj.Products__c = Prod.Id;
        caseobj.OwnerId = u.id;
        caseobj.Service_Centre_City__c = scc.id;
        insert caseobj ;
        
        
    }
}