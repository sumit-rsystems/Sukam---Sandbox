@isTest
//@isTest(SeeAllData=true)
Public Class test_InvoiceContract{

    public static testmethod void Invoice_no()
    {
        User u = new User(
             Alias =  'alia', 
             Email = 'test@sk.com',
             EmailEncodingKey = 'UTF-8', 
             LanguageLocaleKey = 'en_US', 
             LocalesIdKey = 'en_US', 
             TimeZonesIdKey = 'America/Los_Angeles',
             Username = 'test@sk.com',
             LastName = 'lname',
             CommunityNickname = 'cname',
             Stock_Point__c = '033-',
             ProfileId = [select id, Name from Profile where Name = 'CRM Branch User'].id
         );       
        
        insert u; 
        system.runas(u){

        Product__c Prod1 = new Product__c();
        Prod1.name = 'Test1';
        Prod1.Product_Code__c = '12345';
        Prod1.Is_Active__c = True;
        Prod1.UoM__c = 'Set';
        Prod1.CurrencyIsoCode = null;
        insert Prod1;
       
        Price_Books__c objPB = new Price_Books__c();
             objPB.Name='Standard Price Book';
             insert objPB;
         
       Price_Book_Entry__c objPBE =new Price_Book_Entry__c();
       objPBE.Product__c=Prod1.id;
       objPBE.Price_Book__c=objPB.id;
       objPBE.UnitPrice__c=200;
       insert objPBE;
       
       Schema.DescribeSObjectResult d = Schema.SObjectType.Stock_Point__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Service Engineer');
        Id stockId = rtByName.getRecordTypeId();
        
              
      Stock_Point__c objSP = new Stock_Point__c();
      objSP.RecordTypeId = stockId;
      objSP.OwnerId = u.Id;
      objSP.Name = 'XYZ';
      objSP.Service_Center_Description__c = 'TestCenter1';
      objSP.Service_Center_Address__c = 'Address1';
      objSP.Service_Center_Location_Code__c = '033-';
      objSP.DESIGNATION__c = 'HELPER';
      objSP.Service_Engineer_Id__c = 'H900113';
      objSP.Region__c = 'CENTRAL';
      objSP.Branch__c ='LUCKNOW';
      objSP.Active__c = true;
      insert objSP;
         
         Contracts__c SRObj = new Contracts__c();
         SRObj.Stock_Point_Name__c = '113-SC-JALANDHAR';
         SRObj.Activated_Date__c = datetime.newInstance(2008, 12, 1);
         SRObj.AMC_Bill_No__c='CON123';
         SRObj.Products__c = Prod1.id;
         SRObj.Product_Quantity__c = 1;
         SRObj.Product_Serial_No__c = 'NA';
         SRObj.AMC_Type__c = 'Comprehensive';
         SRObj.Payment_Option__c = 'Single Advance Payment';
         SRObj.Contract_Term__c = 12;
         SRObj.Service_Engineer_Ass__c = objSP.id;
         SRObj.Start_Date__c = date.newInstance(2008, 12, 1);//date.parse('2013-04-10');
         SRObj.Stock_Point_Name__c = '113-SC-JALANDHAR';
         insert SRObj;
         
         System.assert(SRObj != null);
      
         apexpages.currentpage().getparameters().put('id' , SRObj.id);
           
         /*List<Invoice_Contract__c>lstInv = new List<Invoice_Contract__c>();
         for(integer i =2;i<7;i++)
         {
           Invoice_Contract__c objINV = new Invoice_Contract__c();
           objINV.Contracts__c = SRObj.id ;
           objINV.Full_Invoice_No__c = '13-14/AMC/'+i ;
           lstInv.add(objINV);
         }        
         insert lstInv;*/
                
                           
         //Invoice_Contract__c objINV2 = [SELECT id,Contracts__c,Invoive_Number__c,Full_Invoice_No__c from Invoice_Contract__c ORDER BY Id DESC LIMIT 1];                 
         //System.assert(objINV2 != null);
         
         Invoice_Contract__c objINV = new Invoice_Contract__c();
         objINV.Contracts__c = SRObj.id ;
         objINV.Full_Invoice_No__c = '13-14/AMC/0067' ;
         insert objINV;
         //update objINV;
      
         GenerateInvoiceContract objgetInvoice = new GenerateInvoiceContract();
         objgetInvoice.GetInvoiceDetails();
         GenerateInvoiceContract.wrapperInvoiceContract objwrapperInvoiceContract = new GenerateInvoiceContract.wrapperInvoiceContract(SRObj,'13-14/AMC/0067');
         //objgetInvoice.WObj = objwrapperInvoiceContract ;
       
       }
    }  
}