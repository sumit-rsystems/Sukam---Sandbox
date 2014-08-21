@isTest
Public Class test_Invoice_No{
    public static testmethod void Invoice_no(){
            RecordType RecordTypeID;
    Invoice_no inv = new Invoice_no();
    String strMonth = String.ValueOf(DateTime.Now().month());
    Integer intMonth=4;
    
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.isActive = true;
        testSM1.Email = 'testSM1@test.com.testuser';
        testSM1.Username = 'testSM1@test.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
        insert testSM1;   
    
    
        Stock_Point__c StockPt = new Stock_Point__c();
        StockPt.Name = 'ABC';
        StockPt.Service_Center_Location_Code__c = '000hi5858';
        StockPt.Region__c = 'CENTRAL';
        String recid = Schema.SObjectType.Stock_Point__c.getRecordTypeInfosByName().get('Service Center').getRecordTypeId();
        StockPt.RecordTypeID = recid; //[Select id from RecordType where Sobjecttype = 'Stock_Point__c' and name = 'Service Center'].Id;
        StockPt.ownerID = testSM1.id;
        System.debug('++++++RecordTypeID +++++++'+StockPt.RecordTypeID);
        insert StockPt;
    
        Product__c prod = new Product__c();
        prod.Name = 'prod';
        prod.Product_Code__c = 'ABC';
        prod.CurrencyIsoCode = 'INR';
        prod.Is_Active__c = True ;
        insert prod;
    
       system.debug('=====testSM1======='+testSM1);
        Component_Movement_Table__c  cmvt = new Component_Movement_Table__c();
        cmvt.Dispatched_Through__c = 'By Hand';
        cmvt.Date__c = System.today();
        cmvt.Road_Permit__c = 'No';
        cmvt.Select_Component__c = prod.id;
        cmvt.Invoice_No_Trig_No__c = 123;
        cmvt.Document_Invoice_No__c = '1315675000003';
        cmvt.ownerID = testSM1.id;
        system.debug('=====cmvt.ownerID======='+cmvt.ownerID);
        
    
    Schema.DescribeSObjectResult d = Schema.SObjectType.Component_Movement_Table__c;
    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtByName =  rtMapByName.get('Product Sale');
    cmvt.RecordTypeID = rtByName.getRecordTypeId();
    insert cmvt;
    system.debug('=====cmvt.ownerID 222======='+cmvt.ownerID);
    cmvt.Generate_Invoice_Bill_No__c = true;
    update cmvt;
    system.debug('=====cmvt.ownerID 333======='+cmvt.ownerID);
    
    
    Component_Movement_Table__c  cmt = new Component_Movement_Table__c();
        cmt.Dispatched_Through__c = 'By Hand';
        cmt.Date__c = System.today();
        cmt.Road_Permit__c = 'No';
        cmt.Select_Component__c = prod.id;
        cmt.Invoice_No_Trig_No__c = 123;
        cmt.Document_Invoice_No__c = '1315675000003';
        cmt.ownerID = testSM1.id;
        system.debug('=====cmt.ownerID======='+cmt.ownerID);
        
    
    
    cmt.RecordTypeID = rtByName.getRecordTypeId();
    insert cmt;
    system.debug('=====cmt.ownerID 222======='+cmt.ownerID);
    cmt.Generate_Invoice_Bill_No__c = true;
    update cmt;
    
    
    }  
}