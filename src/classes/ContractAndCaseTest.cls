@isTest
public class ContractAndCaseTest{
    static testMethod void ContractAndCaseTestMethod(){ 
    
        User u = [Select Id from user where profile.name = 'Service Center' and IsActive = true limit 1];
        
        Product__c Prod = new Product__c();
        Prod.name = 'Test';
        Prod.Product_Code__c = '1001';
        Prod.CurrencyIsoCode = 'INR';
        Prod.Is_Active__c = True;
        Prod.UoM__c = 'Set';
        Insert Prod;
        
        Product__c Prod1 = new Product__c();
        Prod1.name = 'Test1';
        Prod1.Product_Code__c = '1002';
        Prod1.CurrencyIsoCode = 'INR';
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Insert Prod1;
        
        Price_Books__C PriceBk1 = new Price_Books__C();
        PriceBk1.Name = 'Carry In Service Charges';
        PriceBk1.Description__c = 'Carry In Service Charges';
        PriceBk1.IsActive__c = True;
        Insert PriceBk1;
        
        Price_Books__C PriceBk2 = new Price_Books__C();
        PriceBk2.Name = 'On Site Service Charges';
        PriceBk2.Description__c = 'On Site Service Charges';
        PriceBk2.IsActive__c = True;
        Insert PriceBk2;
        
        Price_Books__C PriceBk3 = new Price_Books__C();
        PriceBk3.Name = 'Visit Service Charges';
        PriceBk3.Description__c = 'Visit Service Charges';
        PriceBk3.IsActive__c = True;
        Insert PriceBk3;
        
        Price_Books__c PriceBk0 = new Price_Books__c();
        PriceBk0.Name = 'Standard Price Book';
        PriceBk0.Description__c = 'Standard Price Book';
        PriceBk0.IsActive__c = True;
        Insert PriceBk0;
        
        Price_Book_Entry__c StdPBEntry = new Price_Book_Entry__c();
        StdPBEntry.CurrencyIsoCode = Prod.CurrencyIsoCode;
        StdPBEntry.UnitPrice__c = 1000;
        StdPBEntry.IsActive__c = True;
        StdPBEntry.Product__c = Prod.Id;
        StdPBEntry.Price_Book__C = [Select Id from Price_Books__c where Name = 'Standard Price Book' Limit 1].Id;
        Insert StdPBEntry;
        
        Price_Book_Entry__c PBEntry1 = new Price_Book_Entry__c();
        PBEntry1.CurrencyIsoCode = Prod.CurrencyIsoCode;
        PBEntry1.UnitPrice__c = 100;
        PBEntry1.IsActive__c = True;
        PBEntry1.Product__c = Prod.Id;
        PBEntry1.Price_Book__C = PriceBk1.Id;
        Insert PBEntry1;
        
        Price_Book_Entry__c PBEntry2 = new Price_Book_Entry__c();
        PBEntry2.CurrencyIsoCode = Prod.CurrencyIsoCode;
        PBEntry2.UnitPrice__c = 100;
        PBEntry2.IsActive__c = True;
        PBEntry2.Product__c = Prod.Id;
        PBEntry2.Price_Book__C = PriceBk2.Id;
        Insert PBEntry2;
        
        Price_Book_Entry__c PBEntry3 = new Price_Book_Entry__c();
        PBEntry3.CurrencyIsoCode = Prod.CurrencyIsoCode;
        PBEntry3.UnitPrice__c = 100;
        PBEntry3.IsActive__c = True;
        PBEntry3.Product__c = Prod.Id;
        PBEntry3.Price_Book__C = PriceBk3.Id;
        Insert PBEntry3;
        
        //////////////TESTING FOR CASES////////////////////
        
        List<Service_Request__c> CaseList = new List<Service_Request__c>();
        
        /*for(Case CS: [Select Id from Case Limit 100])
        {
            CaseList.add(CS);
        }
        
        If(CaseList.size()>0)
            Delete CaseList;*/
        
       
       Account acct = new Account(
        name = 'test',
        Customer_ID__c = 'ACC-1001'
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
        
        Service_Request__c Cas = new Service_Request__c();
        Cas.Origin__c = 'Email';
        Cas.Service_Bill_No__c = 'ww';
        Cas.Products__c = Prod.Id;
        Cas.Product_Serial_No__c = '0101';
        Cas.Service_Charge_Type__c = 'Carry In';
        Cas.Products__c = Prod.Id;
        Cas.OwnerId = u.id;
        cas.Service_Bill_No__c = 'abc';
        Insert Cas;
        
        Cas.Service_Charge_Type__c = 'On Site';
        Update Cas;
        
        Service_Request__c Cas1 = new Service_Request__c();
        Cas1.Origin__c = 'Email';
        Cas1.Contact__c = cont.id;
        Cas1.Product_Serial_No__c = '0101';
        //Cas1.Service_Charge_Type__c = 'Visit';
        Cas1.Products__c = Prod.Id;
        Cas1.OwnerId = u.id;
        Cas.Service_Bill_No__c = '123';
        Cas.Products__c = Prod.Id;
        cas1.Service_Bill_No__c = 'abc';
        Insert Cas1;
        
        Cas1.Origin__c = 'Phone';
        Cas1.Status__c = 'Closed';
        Cas1.Payment_Mode__c = 'Cash';
        Cas1.Type_of_Service_Request__c = 'Others';
        //Cas1.Component_Bill_No__c = 'aaa';
        Cas1.Receiving_Date__c = System.today();
        Cas1.Cash_Amount__c = 100000;
        update Cas1;

        //////////////TESTING FOR CONTRACTS////////////////////
        
        Account Acc = new Account();
        Acc.Name = 'TestComp';
        acc.Customer_ID__c = 'ACC-1002';
        Insert Acc;
        
        Contracts__c Con = new Contracts__c();
        Con.Products__c = Prod.Id;
        Con.AMC_Type__c = 'Comprehensive';
        Con.Account_Name__c  = Acc.Id;
        Con.Product_Quantity__c = 100;
        Insert Con;
        
    }
}