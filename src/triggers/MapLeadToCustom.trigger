trigger MapLeadToCustom on Lead (after insert) {
    List<Enquiry__c> enquiries = new List<Enquiry__c>();
    List<Lead> delLead = new List<Lead>();
    set<Id> idSet = new Set<Id>();
    for(Lead l : Trigger.new){
        if(l.LeadSource != null && l.LeadSource == 'Web'){
            Enquiry__c enq = new Enquiry__c();
            String Salutation = '';
            String FirstName = '';
            String lastName = '';
            if(l.Salutation != null)
               Salutation = l.Salutation + ' ';
            if(l.FirstName != null) 
                FirstName = l.FirstName + ' '; 
            if(l.LastName != null)
                LastName = l.LastName;    
            enq.Name = Salutation + FirstName + LastName;
            enq.Salutation__c = l.Salutation;
            enq.FirstName__c = l.FirstName;
            enq.Company__c = l.Company;
            enq.LastName__c = l.LastName;
            enq.AnnualRevenue__c = l.AnnualRevenue;
            enq.Description__c = l.Description;
            enq.Email__c = l.Email;
            enq.Enquiry_Forward__c = l.Enquiry_Forward__c;
            enq.Fax__c = l.Fax;
            enq.Industry__c = l.Industry;
            enq.MobilePhone__c = l.MobilePhone;
            enq.NumberOfEmployees__c = l.NumberOfEmployees;
            enq.Phone__c = l.Phone;
            enq.Status__c = l.Status;
            enq.Title__c = l.Title;
            enq.Website__c = l.Website;
            enq.City__c = l.City;
            enq.Street__C = l.Street;
            enq.State__c = l.State;
            enq.Country__c = l.Country;
            enq.Product__c = l.Product__c;
            enq.Rating__c = l.Rating;
            enq.PostalCode__c = l.PostalCode;
            enq.LeadSource__c = l.LeadSource;
            enq.IsConverted__c = l.IsConverted;
            enq.HasOptedOutOfFax__c = l.HasOptedOutOfFax;
            enq.HasOptedOutOfEmail__c = l.HasOptedOutOfEmail;
            enq.EmailBouncedReason__c = l.EmailBouncedReason;
            enq.EmailBouncedDate__c = l.EmailBouncedDate;
            enq.DoNotCall__c = l.DoNotCall;
            enq.ConvertedOpportunityId__c = l.ConvertedOpportunityId;
            enq.ConvertedContactId__c = l.ConvertedContactId;
            enq.ConvertedAccountId__c = l.ConvertedAccountId;
            // New Fields 
            enq.AC__c = l.AC__c;
            enq.Backup_Requirement__c = l.Backup_Requirement__c;
            enq.BM_Name__c = l.BM_Name__c;
            enq.Budget__c = l.Budget__c;
            enq.Call_Feedback__c = l.Call_Feedback__c;
            enq.Customer_Enquiry_Notes__c = l.Customer_Enquiry_Notes__c;
            enq.Customer_Profile__c = l.Customer_Profile__c;
            enq.Customer_Segment__c = l.Customer_Segment__c;
            enq.Dealer_Name__c = l.Dealer_Name__c;
            enq.Dealership_Enquiry__c = l.Dealership_Enquiry__c;
            enq.Email_Sales_Rep__c = l.Email_Sales_Rep__c;
            //enq.Enquiry_Forward__c = l.Enquiry_Forward__c;
            enq.Enquiry_Type__c = l.Enquiry_Type__c;
            enq.Final_Status__c = l.Final_Status__c;
            enq.Lead_Entered_By__c = l.Lead_Entered_By__c;
            enq.Lead_Passed_To__c = l.Lead_Passed_To__c;
            enq.Lead_Transfer_Date__c = l.Lead_Transfer_Date__c;
            enq.Next_Followup_Date__c = l.Next_Followup_Date__c;
            enq.No_Of_Fans__c = l.No_Of_Fans__c;
            enq.No_Of_Lights__c = l.No_Of_Lights__c;
            enq.Presently_Using_Inverter__c = l.Presently_Using_Inverter__c;
            enq.Pricing_Requested__c = l.Pricing_Requested__c;
            //enq.Product__c = l.Product__c;
            
            enq.Product_Category__c = l.Product_Category__c;
            enq.Product_Manager__c = l.Product_Manager__c;
            enq.Product_Solution_Pitched__c = l.Product_Solution_Pitched__c;
            enq.Region__c = l.Region__c;
            enq.Revenue_Generated__c = l.Revenue_Generated__c;
            enq.Roof_Space_Available__c = l.Roof_Space_Available__c;
            enq.Sales_Lead_Owner__c = l.Sales_Lead_Owner__c;
            enq.Sales_Mobile_Number__c = l.Sales_Mobile_Number__c;
            enq.Sales_Rep_Name__c = l.Sales_Rep_Name__c;
            
            enq.Secondary_Source__c = l.Secondary_Source__c;
            enq.Television__c = l.Television__c;
            
            enq.Call_Owner_Name__c = l.Call_Owner_Name__c;
            enq.ASM_Genset__c = l.ASM_Genset__c;
            enq.Key_Account_Manager__c = l.Key_Account_Manager__c;
            enq.Sales_Feedback__c = l.Sales_Feedback__c;
            enq.Audit_Date__c = l.Audit_Date__c;
            enq.Audit_Response__c = l.Audit_Response__c;
            enq.Customer_Verbatim__c = l.Customer_Verbatim__c;
            enq.Happy_Feet__c = l.Happy_Feet__c;
            
            enquiries.add(enq);
            idSet.add(l.id);
        } 
    }
    try {
        if(enquiries != null && enquiries.size() > 0)
            insert enquiries;
        if(idSet != null && idSet.size() > 0)    
            delLead = [select id from lead where id in: idSet];
        if(delLead != null && delLead.size() > 0)
            delete delLead;
    } catch(Exception e) {
        
        System.debug('--- Error Message ---' + e.getMessage());
    }  
    
}