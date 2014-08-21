@isTest
    public with sharing class test_PopulateVatOnLineItem{
    
    //PopulateVatOnLineItem
     
     public static testmethod void test_PopulateVatOnLineItem(){
         
         Recordtype rd;
            Recordtype rd1;
                  Service_Centre_City__c scc = new Service_Centre_City__c();
                  scc.State__c='Haryana';
                  scc.District__c='Panipat';
                  scc.Name='Panipat';
                  insert scc;
                
                Account acc = new Account();
                  acc.FirstName='Veena';
                  acc.LastName='Singh';
                  acc.Phone='00112234567';
                  acc.PersonMobilePhone='09991458765';
                  acc.State__c='Haryana';
                  acc.District__c='Panipat';
                  acc.City__c=scc.id;
                  String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account' LIMIT 1].Id;
                  system.debug('+++++++++strRecordTypeId++++++++'+strRecordTypeId);
                  insert acc;
            
            Stock_Point__c spt = new Stock_Point__c();  
                  spt.Name='123456';
                  spt.Region__c='CENTRAL';
                  spt.Branch__c ='LUCKNOW';
                  //spt.recordTypeId= [Select Id From RecordType Where SobjectType = 'Stock_Point__c ' and Name = 'Service Center' Limit 1].Id;
                  system.debug('+++++++++spt.recordTypeId++++++++'+spt.recordTypeId);
                  insert spt;
                  
            Component_Movement_Table__c cmt = new Component_Movement_Table__c();
                  
                  String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Component_Movement_Table__c' and Name = 'Product Sale' LIMIT 1].Id;
                  system.debug('+++++++++strRecordTypeId1++++++++'+strRecordTypeId1);                
                  cmt.Document_Invoice_No__c='1234567890';
                  cmt.Dispatched_Through__c='By Hand';
                  cmt.Road_Permit__c='NO';
                  cmt.Sale_Location_Type__c='Interstate';
                  //cmt.SFFlag__c=True;
                  cmt.Service_Engineer_Assigned__c= spt.id;
                  cmt.Account_Name__c=acc.id;
                  cmt.Component_Status__c ='Usable';
                  cmt.OPERATING_UNIT_NAME__c='SU-KAM POWER SYSTEMS LIMITED';   
                 // insert cmt;
        
         
     
     
     }
     
    
    
    
    
    
    
    
    }