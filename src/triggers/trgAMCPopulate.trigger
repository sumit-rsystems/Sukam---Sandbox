trigger trgAMCPopulate on Contracts__c (before Insert, before Update) {

    If(Trigger.new.size()==1)
    {
        If(Trigger.new[0].Products__c !=Null)
        {
            
            if(Trigger.IsInsert)
            {
            //Update Maintenance Date
                    Product__c objP = [Select id,No_Of_PM__c from Product__c where id =: Trigger.new[0].Products__c];
                     Integer  NoOfPM =  Integer.valueOf(objP.No_Of_PM__c);
                    
                     //Update total maintenance 
                      /*integer TMaintenance  = Integer.valueOf(Trigger.new[0].Contract_Term__c);
                      if(TMaintenance > 0)
                      {
                        TMaintenance = Integer.valueOf(Trigger.new[0].Contract_Term__c / 12);
                        Trigger.new[0].Total_Maintenance__c = TMaintenance*NoOfPM ; 
                      }*/
                      Trigger.new[0].Total_Maintenance__c = NoOfPM;
                    
                     if(NoOfPM == 1)
                      Trigger.new[0].Next_Maintenance_Date__c = Trigger.new[0].Start_Date__c.addmonths(12);
                     if(NoOfPM == 2)
                      Trigger.new[0].Next_Maintenance_Date__c = Trigger.new[0].Start_Date__c.addmonths(6);
                     if(NoOfPM == 3)
                      Trigger.new[0].Next_Maintenance_Date__c= Trigger.new[0].Start_Date__c.addmonths(4);
                     if(NoOfPM == 4)
                      Trigger.new[0].Next_Maintenance_Date__c = Trigger.new[0].Start_Date__c.addmonths(3);  
                }

            //Below code is to auto-populate the Comprehensive AMC Charges
            If(Trigger.new[0].AMC_Type__c == 'Comprehensive')
            {
                
                
                for(Price_Book_Entry__c PBE: [SELECT Name, UnitPrice__c, Price_Book__r.Name FROM Price_Book_Entry__c 
                where Price_Book__r.Name = 'Comprehensive AMC Rate' and Product__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].AMC_Amount__c = PBE.UnitPrice__c;
                    //AMCFlag = True;
                }
            } 
            
            //Below code is to auto-populate the Non-Comprehensive AMC Charges
            If(Trigger.new[0].AMC_Type__c == 'Non-Comprehensive')
            {
                for(Price_Book_Entry__c PBE: [SELECT Name, UnitPrice__c, Price_Book__r.Name FROM Price_Book_Entry__c 
                where Price_Book__r.Name = 'Non-Comprehensive AMC Rate' and Product__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].AMC_Amount__c = PBE.UnitPrice__c;
                    //AMCFlag = True;
                }
            } 
            
            //Create call for service engineer on the basis of AMC duration
        }            
    }

}