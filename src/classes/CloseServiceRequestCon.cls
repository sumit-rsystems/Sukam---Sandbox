public class CloseServiceRequestCon{
    public Service_Request__c srObj {get;set;}
    public String selectedStatus{get;set;}
    String srId;
    
       
    public CloseServiceRequestCon(ApexPages.StandardController controller){
        srId = ApexPages.currentPage().getParameters().get('id');
        srObj  = new Service_Request__c();
        if(srId != null && srId != '')
            srObj = [Select s.Warranty_Status__c, s.Warranty_Card__c, s.Warranty_Card_Available__c,
                     s.Type_of_Service_Request__c, s.Type_of_Replacement__c, s.Type__c, s.Status__c, 
                     s.Service_Type__c, s.Service_Engineer_Name__c, s.Service_Engineer_Code__c, 
                     s.Service_Engineer_Assigned__c, s.Service_Charges__c, s.Service_Charge_Type__c, 
                     s.Service_Centre_City__c, s.Service_Bill_No__c, s.Receiving_Date__c, s.Reason__c, 
                     s.Purchase_State__c, s.Purchase_Invoice_No__c, s.Purchase_Date__c, 
                     s.Purchase_Date_Available__c, s.Purchase_Country__c, s.Purchase_City__c, s.Products__c, 
                     s.Product_Serial_No__c, s.Product_Category__c, s.Problem_Detected__c, s.Priority__c, 
                     s.Preferred_Time__c, s.Preferred_Date_for_Visit__c, s.Payment_Mode__c, 
                     s.PROBLEM_OBSERVED__c, s.Other_Expenses__c, s.Origin__c, s.Name, s.Invoice_No_Available__c,
                     s.Id, s.Grand_Total__c, s.FSR_Trig__c, s.FSR_No__c, s.Estimated_Value_of_Service_Request__c,
                     s.Description__c, s.Dealer_Name__c, s.Date_Time_Opened__c, s.CurrencyIsoCode, 
                     s.Component_Tax_Rate__c, s.Component_Tax_Amount__c, s.Component_Charges__c, 
                     s.Component_Bill_No__c, s.Completion_Date_Time__c, s.ClosedDate__c, s.Cheque_No__c, 
                     s.Cheque_Amount__c, s.Cash_Amount__c, s.CALL_TYPE__c, s.Bill_To_Cust__c, 
                     s.Battery_Approval_Date__c, s.Basic_Total__c, s.Bank_Name__c, s.Attended_Date_Time__c, 
                     s.Approval_Status__c, s.Approval_Request_Status__c, s.Alternate_FSR_No__c, s.Agent_Name__c,
                     s.Action_Taken__c, s.AMC_Type__c, s.AMC_Status__c, s.AMC_Created__c, s.AMC_Amount__c, 
                     s.Service_Request_Attended_Date__c,Service_Charges_Other__c  From Service_Request__c s where id =:srId ];
         
    }
    
    public List<SelectOption> getOptions(){
        List<SelectOption> option = new List<SelectOption>();
        option.add(new SelectOption('','None' ));
        option.add(new SelectOption('Closed', 'Closed'));
        return option;
    }
    
    public pageReference doSave(){
        system.debug('selectedStatus======'+selectedStatus);
        if(selectedStatus!= null && selectedStatus!= ''){
            srObj.Status__c = selectedStatus;
            srObj.ClosedDate__c = system.now();
        }else{
        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Please Select Status.');
        ApexPages.addMessage(message);
        return null;        
        }
        
        try{
            update srObj;
        }Catch(Exception e){
        system.debug('----error----'+ e.getMessage());
        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,e.getMessage());
        ApexPages.addMessage(message);
        return null;
        }
        pageReference page = new pageReference('/'+srObj.id);
        page.setRedirect(true);
        return page;
    }
    
    public pageReference doCancel(){
        pageReference page = new pageReference('/'+srObj.id);
        page.setRedirect(true);
        return page;
    }
}