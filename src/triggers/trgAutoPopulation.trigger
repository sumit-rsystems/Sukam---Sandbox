trigger trgAutoPopulation on Service_Request__c (before Insert, before Update) {

//Boolean AMCFlag = False;
//Boolean ServiceFlag = False;
    
    If(Trigger.new.size()==1)
    {
        If(Trigger.new[0].Service_Engineer_Assigned__c != Null)
            Trigger.new[0].Service_Engineer_Name__c = [Select Service_Engineer_Name__c from Stock_Point__c where Id = :Trigger.new[0].Service_Engineer_Assigned__c].Service_Engineer_Name__c;
  
        If(Trigger.new[0].Products__c!=Null)
        {
            //Below code is to auto-populate the Comprehensive AMC Charges
            If(Trigger.new[0].AMC_Created__c == 'Yes' && Trigger.new[0].AMC_Type__c == 'Comprehensive')
            {
                for(Price_Book_Entry__c PBE: [SELECT Name, UnitPrice__c , Price_Book__r.Name FROM Price_Book_Entry__c 
                where Price_Book__r.Name = 'Comprehensive AMC Rate' and Product__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].AMC_Amount__c = PBE.UnitPrice__c;
                    //AMCFlag = True;
                }
            } 
            
            //Below code is to auto-populate the Non-Comprehensive AMC Charges
            If(Trigger.new[0].AMC_Created__c == 'Yes' && Trigger.new[0].AMC_Type__c == 'Non-Comprehensive')
            {
                for(Price_Book_Entry__c  PBE: [SELECT Name, UnitPrice__c , Price_Book__r.Name FROM Price_Book_Entry__c 
                where Price_Book__r.Name = 'Non-Comprehensive AMC Rate' and Product__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].AMC_Amount__c = PBE.UnitPrice__c ;
                    //AMCFlag = True;
                }
            } 
            
            //Below code is to auto-populate the Carry-In Service Charges
            If(Trigger.new[0].Service_Charge_Type__c == 'Carry In')
            {
                for(Price_Book_Entry__c  PBE: [SELECT Name, UnitPrice__c , Price_Book__r.Name FROM Price_Book_Entry__c  
                //where Price_Book__r.Name = 'Carry In Service Charges' and Product__c = :Trigger.new[0].Products__c])
                where Price_Book__r.Name = 'Standard' and Product__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].Service_Charges__c = PBE.UnitPrice__c ;
                    //ServiceFlag = True;
                }
            } 
            
            //Below code is to auto-populate the On Site Service Charges
            If(Trigger.new[0].Service_Charge_Type__c == 'On Site')
            {
                for(Price_Book_Entry__c  PBE: [SELECT Name, UnitPrice__c , Price_Book__r.Name FROM Price_Book_Entry__c  
                where Price_Book__r.Name = 'On Site Service Charges' and Product__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].Service_Charges__c = PBE.UnitPrice__c ;
                    //ServiceFlag = True;
                }
            } 
            
            //Below code is to auto-populate the Visit Service Charges
            If(Trigger.new[0].Service_Charge_Type__c == 'Visit')
            {
                for(Price_Book_Entry__c  PBE: [SELECT Name, UnitPrice__c , Price_Book__r.Name FROM Price_Book_Entry__c  
                where Price_Book__r.Name = 'Visit Service Charges' and Product__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].Service_Charges__c = PBE.UnitPrice__c ;
                    //ServiceFlag = True;
                }
            }
            
                               
        }        
        
    }
}