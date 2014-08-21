trigger MapCaseToCustom on Case (after update) {
    if(UtilClass.runOnce()) {
        List<Service_Request__c> serviceRequest = new List<Service_Request__c>();
        
        for(Case c :trigger.new) {
            if(c.Origin != null && c.Origin.equals('Email')) {
                Service_Request__c sr = new Service_Request__c(
                    Account__c = c.AccountId,   
                    AMC_Amount__c = c.AMC_Amount__c,
                    AMC_Created__c = c.AMC_Created__c,
                    AMC_Status__c = c.AMC_Status__c, 
                    AMC_Type__c = c.AMC_Type__c,
                    Action_Taken__c = c.Action_Taken__c,            
                    Agent_Name__c = c.Agent_Name__c, 
                    Alternate_FSR_No__c = c.Alternate_FSR_No__c,        
                    Approval_Request_Status__c = c.Approval_Request_Status__c, 
                    Approval_Status__c = c.Approval_Status__c,         
                    Attended_Date_Time__c = c.Attended_Date_Time__c, 
                    Bank_Name__c = c.Bank_Name__c,               
                    Battery_Approval_Date__c = c.Battery_Approval_Date__c,   
                    CALL_TYPE__c = c.CALL_TYPE__c, 
                    Cash_Amount__c = c.Cash_Amount__c, 
                    Category__c =c.Category__c,
                    Cheque_Amount__c = c.Cheque_Amount__c, 
                    Cheque_No__c = c.Cheque_No__c, 
                    Close_Case__c = c.Close_Case__c, 
                    Completion_Date_Time__c = c.Completion_Date_Time__c, 
                    Component_Bill_No__c = c.Component_Bill_No__c, 
                    Component_Charges__c = c.Component_Charges__c, 
                    Component_Tax_Rate_1__c = c.Component_Tax_Rate_1__c, 
                    Contact__c = c.ContactID, 
                    ClosedDate__c =  c.ClosedDate, 
                    Dealer_Name__c= c.Dealer_Name__c, 
                    Description__c = c.Description, 
                    Estimated_Value_of_Service_Request__c = c.Estimated_Value_of_Service_Request__c, 
                    FSR_No__c = c.FSR_No__c, 
                    FSR_Trig__c = c.FSR_Trig__c, 
                    Interim_Approval__c =  c.Interim_Approval__c, 
                   // Comments__c = c.Comments, 
                    Invoice_No_Available__c = c.Invoice_No_Available__c, 
                    Origin__c = c.Origin,
                    Other_Expenses__c = c.Other_Expenses__c, 
                    Payment_Mode__c = c.Payment_Mode__c, 
                    Preferred_Date_for_Visit__c = c.Preferred_Date_for_Visit__c, 
                    Preferred_Time__c = c.Preferred_Time__c, 
                    Priority__c = c.Priority, 
                    Problem_Detected__c = c.Problem_Detected__c, 
                    PROBLEM_OBSERVED__c = c.PROBLEM_OBSERVED__c, 
                    Product_Category__c = c.Product_Category__c, 
                    Product_Serial_No__c = c.Product_Serial_No__c, 
                    Purchase_City__c = c.Purchase_City__c, 
                    Purchase_Country__c = c.Purchase_Country__c, 
                    Purchase_Date__c = c.Purchase_Date__c, 
                    Purchase_Date_Available__c = c.Purchase_Date_Available__c, 
                    Purchase_Invoice_No__c = c.Purchase_Invoice_No__c, 
                    Purchase_State__c = c.Purchase_State__c, 
                    Receiving_Date__c = c.Receiving_Date__c, 
                    Recommended_Visit_Date_Time__c = c.Recommended_Visit_Date_Time__c, 
                    SFFLAG__c = c.SFFLAG__c, 
                    Serial_No_Available__c = c.Serial_No_Available__c, 
                    Service_Bill_No__c = c.Service_Bill_No__c, 
                    Service_Centre_City__c = c.Service_Centre_City__c,
                    Service_Charge_Type__c = c.Service_Charge_Type__c, 
                    Service_Charges__c = c.Service_Charges__c, 
                    Service_Charges_Other__c = c.Service_Charges_Other__c, 
                    Service_Engineer_Assigned__c= c.Service_Engineer_Assigned__c, 
                    Service_Request_Attended_Date__c = c.Service_Request_Attended_Date__c, 
                    Service_Type__c = c.Service_Type__c, 
                    Status__c = c.Status, 
                    Subject__c = c.Subject, 
                    Total_Defective_Quantity_Returned__c = c.Total_Defective_Quantity_Returned__c,
                    Total_Quantity_Issued__c = c.Total_Quantity_Issued__c, 
                    Type__c =  c.Type, 
                    Type_of_Replacement__c = c.Type_of_Replacement__c, 
                    Type_of_Service_Request__c = c.Type_of_Service_Request__c, 
                    Warranty_Status__c = c.Warranty_Status__c, 
                    Warranty_Card__c = c.Warranty_Card__c, 
                    Warranty_Card_Available__c = c.Warranty_Card_Available__c, 
                    SuppliedCompany__c = c.SuppliedCompany, 
                    SuppliedEmail__c = c.SuppliedEmail, 
                    SuppliedName__c = c.SuppliedName, 
                    SuppliedPhone__c = c.SuppliedPhone,
                    Email_To_Case__c = True,
                    OwnerID = c.OwnerID
               );
                serviceRequest.add(sr);
            }
        }
        
        try {
            if(serviceRequest != null && serviceRequest.size() > 0)
                insert serviceRequest;
        } catch(Exception e) {
            System.debug('--- Error Message ---' + e.getMessage());
        }
    }
}