trigger trgCaseAutoPopulationold on Service_Request__c (before Insert, before Update) {

//Boolean AMCFlag = False;
//Boolean ServiceFlag = False; 
    
    If(Trigger.new.size()==1)
        
    {
            
        If(Trigger.new[0].Service_Engineer_Assigned__c != Null)
            Trigger.new[0].Service_Engineer_Name__c = [Select Service_Engineer_Name__c from Stock_Point__c where Id = :Trigger.new[0].Service_Engineer_Assigned__c].Service_Engineer_Name__c;
        
        If(Trigger.new[0].Products__c!=Null)
        {
            //Below code is to auto-populate the Comprehensive AMC Charges
            /*If(Trigger.new[0].AMC_Created__c == 'Yes' && Trigger.new[0].AMC_Type__c == 'Comprehensive')
            {
                for(Price_Book_Entry__c PBE: [SELECT Name, UnitPrice__c, Price_Book__r.Name FROM Price_Book_Entry__c 
                where Price_Book__r.Name = 'Comprehensive AMC Rate' and Product__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].AMC_Amount__c = PBE.UnitPrice__c;
                    //AMCFlag = True;
                }
            } 
            
            //Below code is to auto-populate the Non-Comprehensive AMC Charges
            If(Trigger.new[0].AMC_Created__c == 'Yes' && Trigger.new[0].AMC_Type__c == 'Non-Comprehensive')
            {
                for(Price_Book_Entry__c PBE: [SELECT Name, UnitPrice__c, Price_Book__r.Name FROM Price_Book_Entry__c 
                where Price_Book__r.Name = 'Non-Comprehensive AMC Rate' and Product__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].AMC_Amount__c = PBE.UnitPrice__c;
                    //AMCFlag = True;
                }
            }*/
            
            //Below code is to auto-populate the Carry-In Service Charges
            If(Trigger.new[0].Service_Charge_Type__c == 'Carry In')
            {
                for(Price_Book_Entry__c PBE: [SELECT Name, UnitPrice__c, Price_Book__r.Name FROM Price_Book_Entry__c 
                where Price_Book__r.Name = 'Carry In Service Charges' and Product_Code__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].Service_Charges__c = PBE.UnitPrice__c;
                    //ServiceFlag = True;
                }
            } 
            
            //Below code is to auto-populate the On Site Service Charges
            If(Trigger.new[0].Service_Charge_Type__c == 'On Site')
            {
                for(Price_Book_Entry__c PBE: [SELECT Name, UnitPrice__c, Price_Book__r.Name FROM Price_Book_Entry__c 
                where Price_Book__r.Name = 'On Site Service Charges' and Product_Code__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].Service_Charges__c = PBE.UnitPrice__c;
                    //ServiceFlag = True;
                }
            } 
            
            //Below code is to auto-populate the Visit Service Charges
            If(Trigger.new[0].Service_Charge_Type__c == 'Visit')
            {
                for(Price_Book_Entry__c PBE: [SELECT Name, UnitPrice__c, Price_Book__r.Name FROM Price_Book_Entry__c 
                where Price_Book__r.Name = 'Visit Service Charges' and Product_Code__c = :Trigger.new[0].Products__c])
                {
                    Trigger.new[0].Service_Charges__c = PBE.UnitPrice__c;
                    //ServiceFlag = True;
                }
            }
            
                               
        }
        
        If(Trigger.IsInsert)
        {
        DateTime Dt = DateTime.Now().addDays(-3);
            Service_Request__C[] Cas = [Select FSR_Trig__c from Service_Request__C where createddate > :Dt order by FSR_Trig__c desc limit 1];
            
            If(Cas.size()>0)
            {
                System.debug('################'+Cas[0].FSR_Trig__c);
                Trigger.new[0].FSR_Trig__c = Cas[0].FSR_Trig__c + 1;
                System.debug('################'+Trigger.new[0].FSR_Trig__c);
                String TempNo = String.Valueof(Trigger.new[0].FSR_Trig__c);
                System.debug('################'+TempNo);
                While(TempNo.length() < 8)
                    TempNo = '0' + TempNo;    
                String strYear = '';//String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                String strMonth = String.ValueOf(DateTime.Now().month());
                Integer intMonth = Integer.valueOf(strMonth);
                if (intMonth >= 4) {
                    strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                } else {
                    strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            
                }
                If(strMonth.length()==1)
                    strMonth = '0' + strMonth;
                System.debug('################'+strYear + strMonth + TempNo.substring(0,6));    
                String Temp = '';
                String[] xx = TempNo.split('\\.'); 
                try
                {
                    Temp = xx[0];
                }
                catch(exception ex33)
                {
                    Temp = TempNo;
                }
                Trigger.new[0].FSR_No__c = strYear + strMonth + Temp;
                
            }
            Else
            {
                Trigger.new[0].FSR_Trig__c = 0;
                String strYear = '';//String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                String strMonth = String.ValueOf(DateTime.Now().month());
                Integer intMonth = Integer.valueOf(strMonth);
                if (intMonth >= 4) {
                    strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                } else {
                    strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            
                }    
                If(strMonth.length()==1)
                    strMonth = '0' + strMonth;
                Trigger.new[0].FSR_No__c = strYear + strMonth + '000000';
                
            }
        }
    }
}