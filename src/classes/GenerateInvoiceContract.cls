public class GenerateInvoiceContract{

   public wrapperInvoiceContract WObj{get;set;}
   //public integer iCount{get;set;}
 
    public GenerateInvoiceContract() {
        
        
    }
    
    
    public void GetInvoiceDetails()
    {
      string InvId = ApexPages.CurrentPage().getParameters().get('id');
      try
      {
        
        //string asa = 'Select id,Stock_Point_Name__c ,Activated_Date__c,RecordTypeId  from Contracts__c where id = '+InvId+' and RecordTypeId in (SELECT Id FROM RecordType WHERE Name = \'Service Center\')';
        //system.debug('aaaaaaa'+asa);
        Contracts__c SRObj = [Select id,Stock_Point_Name__c ,Activated_Date__c,RecordTypeId  from Contracts__c where id =:InvId ];
        //Contracts__c SRObj = [Select id,Stock_Point_Name__c ,Activated_Date__c,RecordTypeId  from Contracts__c where id =:InvId and RecordTypeId in (SELECT Id FROM RecordType WHERE Name =: 'Service Center')];
        //Contracts__c SRObj = [Select id,CreatedBy.City__c,Stock_Point__c,Stock_Point__r.Name,Activated_Date__c,RecordTypeId  from Contracts__c where id =:InvId ];
          if(SRObj != null)
           {
             system.debug('hi');
              if(SRObj.Activated_Date__c != null)
              {
                      List<Invoice_Contract__c> lstInv = [SELECT id,Contracts__c,Invoive_Number__c,Full_Invoice_No__c  from Invoice_Contract__c where Contracts__c =: SRObj.id];
                      if(lstInv.size()<=0)
                      {
                        Invoice_Contract__c objINV = [SELECT id,Contracts__c,Invoive_Number__c,Full_Invoice_No__c from Invoice_Contract__c ORDER BY Id DESC LIMIT 1];
                        
                        integer iNo = integer.valueof(objINV.Invoive_Number__c)+1;
                        
                        string sStockPoint = '';
                        if(SRObj.Stock_Point_Name__c  != '')
                        {
                           sStockPoint = SRObj.Stock_Point_Name__c.SubString(0,3);
                        }
                        
                        string strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4) + '-' + String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                        
                        string sFullInvoiceNo = strYear + '/AMC/'+ sStockPoint  + '/' + iNo ;
                       
                        WObj = new wrapperInvoiceContract(SRObj ,sFullInvoiceNo );
                        
                        //Insert new record in invoice table
                          Invoice_Contract__c objI = new Invoice_Contract__c();
                          objI.Contracts__c = InvId;
                          objI.Full_Invoice_No__c = sFullInvoiceNo ;
                          Insert objI ;
                      }
                      else
                      {
                        //Invoice already created
                        // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Invoice already generated for this service request.');
                        WObj = new wrapperInvoiceContract(SRObj ,lstInv[0].Full_Invoice_No__c);
                        
                      }
              }
               
           }
        
       }
       catch(Exception e)
       {
         System.debug('--- Error Message ---' + e.getMessage());
       }
    }
    
    
    public class wrapperInvoiceContract{
       public Contracts__c  SRObj{get;set;}
       public string InvoiceNo{get;set;}
       
       public wrapperInvoiceContract(Contracts__c  sr,string sInvNo)
       {
        
         SRObj = sr;
         InvoiceNo = sInvNo;
        
       }
    
    }
}