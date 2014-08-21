Public Class Sale_bill_no {

    Public Void SetSaleBillNo(Component_Movement_Table__c CompMove) {
        
        
        Component_Movement_Table__c[] comp = [Select Sale_Bill_Trig_No__c, Sale_Bill_No__c, ownerID from Component_Movement_Table__c
                                             where RecordTypeID = '012O00000008gSt' 
                                             and Sale_Bill_Trig_No__c != null
                                             order by Sale_Bill_Trig_No__c desc
                                             ]; 
         
                                                   
            if(comp.size() > 0) {
               
               //System.debug('++++++++comp[0].Sale_Bill_No__c+++++++++++'+comp[0].Sale_Bill_No__c);
               
               
               //compMove.Sale_Bill_Trig_No__c = integer.valueOf(comp[0].Sale_Bill_No__c.subString(5,9));
               compMove.Sale_Bill_Trig_No__c = comp[0].Sale_Bill_Trig_No__c + 1;
               String TempNo = String.Valueof(compMove.Sale_Bill_Trig_No__c);
               While(TempNo.length() < 6) {
                   TempNo = '0' + TempNo;
               }
               System.debug('++++++++comp[0].Sale_Bill_No__c+++++++++++ '+ comp[0].Sale_Bill_No__c);
               
               String strYear = '';

               String strMonth = String.ValueOf(DateTime.Now().month());

               Integer intMonth = Integer.valueOf(strMonth);
               System.debug('++++++++intMonth +++++++++++'+intMonth );

               if (intMonth >= 4) {

                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                System.debug('++++++++strYear +++++++++++'+strYear );
               } else {

                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            
                System.debug('++++++++strYear +++++++++++'+strYear );
               }                  

               compMove.Sale_Bill_No__c = 'SL-'+ strYear + TempNo;
          
               System.debug('++++++++compMove.Sale_Bill_No__c+++++++++++'+ compMove.Sale_Bill_No__c);
         
                 
           
         }
            
         else {
               
                compMove.Sale_Bill_Trig_No__c = 0;
               
               
               
                System.debug('++++++++compMove.Sale_Bill_No__c2+++++++++++'+ compMove.Sale_Bill_No__c);
               
                String strYear = '';

                String strMonth = String.ValueOf(DateTime.Now().month());
    
                Integer intMonth = Integer.valueOf(strMonth);
                System.debug('++++++++intMonth2 +++++++++++'+intMonth );
    
                if (intMonth >= 4) {
    
                    strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2, 4);
                    System.debug('++++++++strYear2 +++++++++++'+strYear );
                } else {
    
                    strYear = String.ValueOf(DateTime.Now().Year()).substring(2, 4);            
                    System.debug('++++++++strYear2 +++++++++++'+strYear );
                }                  
    
                compMove.Sale_Bill_No__c =  string.valueof('SL-' + strYear + '000000');
                System.debug('++++++++compMove.Sale_Bill_No__c2+++++++++++'+ compMove.Sale_Bill_No__c);
                //comp.add(compMove);
                     
        }
         
                          
     }
    
}