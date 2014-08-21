public class GenerateInvoiceComponentMovement{

   public wrapperInvoiceCompMov WObj{get;set;}
 
    public GenerateInvoiceComponentMovement() {
        
        
    }
    
    public void GetInvoiceDetails()
    {
      string InvId = ApexPages.CurrentPage().getParameters().get('id');
      Component_Movement_Table__c SRObj = [Select id,CreatedBy.City__c,Transferred_to_Stock_Point__r.Name from Component_Movement_Table__c where id =:InvId];
      List<Invoice_Component_Movement__c> lstInv = [SELECT id,Component_Movement_Table__c ,Invoive_Number__c,Full_Invoice_No__c  from Invoice_Component_Movement__c where Component_Movement_Table__c =: SRObj.id];
      if(lstInv.size()<=0)
      {
        Invoice_Component_Movement__c objINV = [SELECT id,Component_Movement_Table__c ,Invoive_Number__c,Full_Invoice_No__c from Invoice_Component_Movement__c ORDER BY Id DESC LIMIT 1];
        
        integer iNo = integer.valueof(objINV.Invoive_Number__c)+1;
        
        string sFullInvoiceNo = '13-14/CC/'+ SRObj.Transferred_to_Stock_Point__r.Name + '/' + iNo ;
       
        WObj = new wrapperInvoiceCompMov(SRObj ,sFullInvoiceNo );
        
        //Insert new record in invoice table
          Invoice_Component_Movement__c  objI = new Invoice_Component_Movement__c();
          objI.Component_Movement_Table__c  = InvId;
          objI.Full_Invoice_No__c = sFullInvoiceNo ;
          Insert objI ;
      }
      else
      {
        //Invoice already created
        // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Invoice already generated for this service request.');
        WObj = new wrapperInvoiceCompMov (SRObj ,lstInv[0].Full_Invoice_No__c);
        
      }
    }
    
    
    public class wrapperInvoiceCompMov {
       public Component_Movement_Table__c  SRObj{get;set;}
       public string InvoiceNo{get;set;}
       
       public wrapperInvoiceCompMov(Component_Movement_Table__c  sr,string sInvNo)
       {
         SRObj = sr;
         InvoiceNo = sInvNo;
         
       }
    
    }
}