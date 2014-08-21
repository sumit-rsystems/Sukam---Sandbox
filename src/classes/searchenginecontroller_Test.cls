@isTest
 public with sharing class searchenginecontroller_Test {
     private static testMethod void searchEngineTestMethod(){

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
        
     Service_Request__c Cas1 = new Service_Request__c();
        Cas1.Origin__c = 'Email';
        Cas1.Account__c = acct.id;
        Cas1.Product_Serial_No__c = '0101';
        Cas1.Service_Charge_Type__c = 'Visit';
        Cas1.Products__c = Prod.Id;
        Cas1.FSR_No__c = '12345';
        Cas1.Type_of_Service_Request__c = 'Others';
        Cas1.Status__c ='New';
       
      
    Service_Request__c Cas2 = new Service_Request__c();
        Cas2.Origin__c = 'Email';
        cas2.Account__c = acct.id;
        cas2.Product_Serial_No__c = '0101';
        cas2.Service_Charge_Type__c = 'Visit';
        cas2.Products__c = Prod.Id;
        cas2.FSR_No__c = '56789';
        cas2.Type_of_Service_Request__c = 'Others';
        cas2.Status__c ='Pending';
        cas2.CALL_SUB_STATUS__c ='Part Pending';
        cas2.Sub_Status_Remark__c ='abcd';
            
   Service_Request__c cas3 = new Service_Request__c();
        cas3.Origin__c = 'Email';
        cas3.Account__c = acct.id;
        cas3.Product_Serial_No__c = '0101';
        cas3.Service_Charge_Type__c = 'Visit';
        cas3.Products__c = Prod.Id;
        cas3.FSR_No__c = '1010101';
        cas3.Type_of_Service_Request__c = 'Others';
        cas3.Status__c ='Pending';
        cas3.CALL_SUB_STATUS__c ='DOOR LOCKED';
        cas3.Sub_Status_Remark__c ='efgh';
        
        
   Service_Request__c cas4 = new Service_Request__c();
        cas4.Origin__c = 'Email';
        cas4.Account__c = acct.id;
        cas4.Product_Serial_No__c = '0101';
        cas4.Service_Charge_Type__c = 'Visit';
        cas4.Products__c = Prod.Id;
        cas4.FSR_No__c = '101345';
        cas4.Type_of_Service_Request__c = 'Others';
        cas4.Status__c ='Pending';
        cas4.CALL_SUB_STATUS__c ='NO POWER';
        cas4.Sub_Status_Remark__c ='ijkl';    
        
    Service_Request__c cas5 = new Service_Request__c();
        cas5.Origin__c = 'Email';
        cas5.Account__c = acct.id;
        cas5.Product_Serial_No__c = '0101';
        cas5.Service_Charge_Type__c = 'Visit';
        cas5.Products__c = Prod.Id;
        cas5.FSR_No__c = '101678';
        cas5.Type_of_Service_Request__c = 'Others';
        cas5.Status__c ='Pending';
        cas5.CALL_SUB_STATUS__c ='CUSTOMER NOT AVAILBLE';
        cas5.Sub_Status_Remark__c ='mnop';           
        
     Service_Request__c cas6 = new Service_Request__c();
        cas6.Origin__c = 'Email';
        cas6.Account__c = acct.id;
        cas6.Product_Serial_No__c = '0101';
        cas6.Service_Charge_Type__c = 'Visit';
        cas6.Products__c = Prod.Id;
        cas6.FSR_No__c = '101456';
        cas6.Type_of_Service_Request__c = 'Others';
        cas6.Status__c ='Pending';
        cas6.CALL_SUB_STATUS__c ='REFER TO TRC';
        cas6.Sub_Status_Remark__c ='qrst';   
        
     Service_Request__c cas7 = new Service_Request__c();
        cas7.Origin__c = 'Email';
        cas7.Account__c = acct.id;
        cas7.Product_Serial_No__c = '0101';
        cas7.Service_Charge_Type__c = 'Visit';
        cas7.Products__c = Prod.Id;
        cas7.FSR_No__c = '23456';
        cas7.Type_of_Service_Request__c = 'Others';
        cas7.Status__c ='Pending';
        cas7.CALL_SUB_STATUS__c ='PENDING FOR PJP';
        cas7.Sub_Status_Remark__c ='acgd';        
      
      Service_Request__c cas8 = new Service_Request__c();
        cas8.Origin__c = 'Email';
        cas8.Account__c = acct.id;
        cas8.Product_Serial_No__c = '0101';
        cas8.Service_Charge_Type__c = 'Visit';
        cas8.Products__c = Prod.Id;
        cas8.FSR_No__c = '8765';
        cas8.Type_of_Service_Request__c = 'Others';
        cas8.Status__c ='Pending';
        cas8.CALL_SUB_STATUS__c ='TECHANICAL PROBLEM';
        cas8.Sub_Status_Remark__c ='kjhg';
        
      Service_Request__c cas9 = new Service_Request__c();
        cas9.Origin__c = 'Email';
        cas9.Account__c = acct.id;
        cas9.Product_Serial_No__c = '0101';
        cas9.Service_Charge_Type__c = 'Visit';
        cas9.Products__c = Prod.Id;
        cas9.FSR_No__c = '678967';
        cas9.Type_of_Service_Request__c = 'Others';
        cas9.Status__c ='Pending';
        cas9.CALL_SUB_STATUS__c ='PENDING FOR REPLACEMENT';
        cas9.Sub_Status_Remark__c ='ghyt';  
        
      Service_Request__c cas10 = new Service_Request__c();
        cas10.Origin__c = 'Email';
        cas10.Account__c = acct.id;
        cas10.Product_Serial_No__c = '0101';
        cas10.Service_Charge_Type__c = 'Visit';
        cas10.Products__c = Prod.Id;
        cas10.FSR_No__c = '34566';
        cas10.Type_of_Service_Request__c = 'Others';
        cas10.Status__c ='Pending';
        cas10.CALL_SUB_STATUS__c ='APPROVAL ON HOLD';
        cas10.Sub_Status_Remark__c ='ghyt';     
          
List<Service_Request__c > srList = new List<Service_Request__c>();
srList.add(Cas1);
srList.add(Cas2);
srList.add(Cas3);
srList.add(Cas4);
srList.add(Cas5);
srList.add(Cas6);
srList.add(Cas7);
srList.add(Cas8);
srList.add(Cas9);
srList.add(Cas10);

insert srList;

apexPages.currentPage().getParameters().put('selectedStatus', 'New');
apexPages.currentPage().getParameters().put('selectedSubStatus', 'Part Pending');
//Create instance of class here and then start calling method.
searchenginecontroller objSrchClass = new searchenginecontroller();
objSrchClass.getCounts();
objSrchClass.refreshSearchResult();
objSrchClass.refreshSearchResult1();
objSrchClass.getRecordCount();
objSrchClass.SearchResult();

objSrchClass.fromSR.Preferred_Date_for_Visit__c   = System.Today();
objSrchClass.ToSR.Preferred_Date_for_Visit__c   = System.Today();

objSrchClass.fromSR.Created_Date__c = System.Today();
objSrchClass.ToSR.Created_Date__c = System.Today(); 

objSrchClass.fromSR.Attended_Date_Time__c = System.Today();
objSrchClass.ToSR.Attended_Date_Time__c = System.Today(); 

objSrchClass.fromSR.Completion_Date_Time__c = System.Today();
objSrchClass.ToSR.Completion_Date_Time__c = System.Today(); 

objSrchClass.fromSR.ClosedDate__c = System.Today();
objSrchClass.ToSR.ClosedDate__c = System.Today(); 

//objSrchClass.thisAccount.Mobile_No__c = '1234567890;
objSrchClass.thisAccount.State__c = 'Delhi';
objSrchClass.thisAccount.District__c= 'Delhi';


objSrchClass.thisProduct.Product_Code__c = 'Product';

objSrchClass.fromSr.Product_Category__c = 'Battery';
objSrchClass.fromSr.Group__c = 'Group1' ;
objSrchClass.fromSr.Sub_Group__c =  'Group2' ;
objSrchClass.fromSr.Category__c  = 'thiscategory';
objSrchClass.fromSr.Status__c= 'thiscategory';
objSrchClass.fromSr.Complain_Type__c = 'thiscategory';
objSrchClass.fromSr.Service_Type__c = 'thiscategory';
objSrchClass.fromSr.CALL_TYPE__c = 'thiscategory';
objSrchClass.fromSr.Product_Serial_No__c= '1234';
objSrchClass.fromSr.PROBLEM_OBSERVED__c = 'thisproblem';
objSrchClass.fromSr.CALL_SUB_STATUS__c = 'thissubstatus';
objSrchClass.fromSr.Warranty_Status__c = 'yes';

objSrchClass.SearchResult();
     }
}