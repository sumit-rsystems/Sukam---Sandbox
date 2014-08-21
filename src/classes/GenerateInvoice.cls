public class GenerateInvoice{

   public wrapperInvoice  WObj{get;set;}
 
    public GenerateInvoice() {
        
        //GetInvoiceDetails(InvId);
    }
    
    public void GetInvoiceDetails()
    {
      string InvId = ApexPages.CurrentPage().getParameters().get('id');
      Service_Request__c  SRObj = [Select id,Status__c,Service_Centre_City__r.Code__c,Component_Bill_No__c,Component_Charges__c,Discount_in_Component_Charges__c,Misc_Component_Charges__c,Misc_Component_Charges_Remark__c,Net_Basic_CC_Amount__c,Component_Tax_Rate_1__c,Total_Component_Amount_After_Tax__c,Grand_Total__c,Receiving_Date__c,Service_Bill_No__c,Service_Charge_Type__c,Service_Charges__c,Service_Charges_Other__c,Misc_Service_Charges_Remark__c,Discount_in_Service_Charges__c,Net_Basic_SC_Amount__c,Service_Charges_After_Tax__c from Service_Request__c where id =:InvId];
      if(SRObj.Status__c == 'Closed')
      {
          List<Invoice_No__c> lstInv = [SELECT id,Invoive_Number__c,Service_Request__c,Full_Invoice_No__c from Invoice_No__c where Service_Request__c =: SRObj.id];
          if(lstInv.size()<=0)
          {
            Invoice_No__c objINV = [SELECT id,Invoive_Number__c,Service_Request__c,Full_Invoice_No__c from Invoice_No__c ORDER BY Id DESC LIMIT 1];
            integer iNo = integer.valueof(objINV.Invoive_Number__c)+1;
            
            
            //Get logged in user stock point
              List<Stock_Point__c> lstSP = [select id,name from Stock_Point__c where CreatedById =: Userinfo.getUserId()];
            
            //string sFullInvoiceNo = '13-14/SC/'+ SRObj.Service_Centre_City__r.Code__c + '/' + iNo ;
            string sStockPoint = '';
            if(lstSP.size()>0)
            {
               sStockPoint = lstSP[0].Name.SubString(0,3);
            }
            
            string sFullInvoiceNo = '13-14/SC/'+ sStockPoint + '/' + iNo ;
            //WObj = new wrapperInvoice(SRObj ,integer.valueof(objINV.Invoive_Number__c)+1);
            WObj = new wrapperInvoice(SRObj ,sFullInvoiceNo);
            
            //Insert new record in invoice table
            Invoice_No__c objI = new Invoice_No__c();
            objI.Service_Request__c = InvId;
            objI.Full_Invoice_No__c = sFullInvoiceNo ;
            Insert objI ;
          }
          else
          {
            //Invoice already created
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Invoice already generated for this service request.');
             WObj = new wrapperInvoice(SRObj ,lstInv[0].Full_Invoice_No__c);
          }
      }
    }
    
    
    public class wrapperInvoice{
       public Service_Request__c SRObj{get;set;}
       public string InvoiceNo{get;set;}
       
       public wrapperInvoice(Service_Request__c sr,string sInvNo)
       {
         SRObj = sr;
         InvoiceNo = sInvNo;
       }
    
    }
}