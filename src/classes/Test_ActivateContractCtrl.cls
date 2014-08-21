@isTest
public class Test_ActivateContractCtrl{
    private static testMethod void unitTestActivateContractCtrl(){
        Account Acc = new Account();
        Acc.Name = 'TestComp';
        acc.Customer_ID__c = 'ACC-1001';
        Insert Acc;
        
        Product__c Prod = new Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        
        Contracts__c Con = new Contracts__c();
        Con.Products__c = Prod.Id;
        Con.AMC_Type__c = 'Comprehensive';
        Con.Account_Name__c  = Acc.Id;
        Con.Product_Quantity__c = 100;
        Insert Con;
        
        ApexPages.StandardController cont = new ApexPages.StandardController(con);
        ActivateContractCtrl actCOn = new ActivateContractCtrl(cont);
        actCOn .updateContract();
        
        Contracts__c contra = new Contracts__c();
        //contra = [Select id , Status__c from Contracts__c where id=:Con.id] ;
        //system.assertEquals('Activated',contra.Status__c);
    }
}