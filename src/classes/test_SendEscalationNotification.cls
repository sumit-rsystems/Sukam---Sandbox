@isTest
public class test_SendEscalationNotification{
    private static testMethod void unitTestSendEscalationNotification(){
        
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
        
        Service_Request__c Cas1 = new Service_Request__c();
        Cas1.Origin__c = 'Email';
        Cas1.Contact__c = cont.id;
        Cas1.Product_Serial_No__c = '0101';
        Cas1.Service_Charge_Type__c = 'Visit';
        Cas1.Products__c = Prod.Id;
        Cas1.OwnerId = u.id;
         Cas1.Type_of_Service_Request__c = 'Others';
        Insert Cas1;
        
        Escalation_Settings__c  record= new Escalation_Settings__c();
        record.Name = 'Escalation';
        record.Additional_Emails_1__c = 'abc@gmail.com';
        record.Escalation_Age_Over_1__c = 0;
        record.Escalation_Age_Over_2__c = 30;
        record.Template_Name__c = 'AMC Amount Details';
        insert record;
        
        
        Test.StartTest();
        DateTime days48strt = System.now().addDays(-3);
        DateTime days48end = System.now().addDays(3);
        DateTime days72strt = System.now().addDays(-Integer.valueOf(record.Escalation_Age_Over_2__c + 2));
        DateTime days72end = System.now().addDays(-Integer.valueOf(record.Escalation_Age_Over_2__c - 2));
        SendEscalationNotification batch= new SendEscalationNotification ();
        ID batchprocessid = Database.executeBatch(batch);
        Database.BatchableContext a;
            batch.start(a);
            batch.execute(a, [Select Owner.Email, OwnerId, CreatedDate, Status__c 
                                            from Service_Request__c where
                                            ((CreatedDate >= :days48strt and CreatedDate <= :days48end) or
                                            (CreatedDate >= :days72strt and CreatedDate <= :days72end)) and
                                            Status__c != 'Closed']);
        batch.finish(a);
         
        scheduleescalationnotification batch1 = new scheduleescalationnotification(); 
        SchedulableContext SCt ;
        batch1.execute(SCt);
        Test.StopTest(); 
    }
}