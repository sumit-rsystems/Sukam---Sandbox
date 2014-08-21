Public Class Invoice_no{
    String SC_Code;
    String stryear;
    Integer SC_No;
    Integer StYear;
    
    Public Void SetInvoiceno(Component_Movement_Table__c CompMove, Id RecID){
        System.debug('---CompMove---' + CompMove);
        SetSCCode(CompMove.OwnerId);
        if(SC_Code != null && SC_Code !=''){
        String tempSC_Code = SC_Code.subString(0,3);
        System.debug('++++++tempSC_Code+++++++'+ tempSC_Code);
        System.debug('++++++strYear+++++++'+strYear);
        Component_Movement_Table__c[] comp =[Select Invoice_No_Trig_No__c,Document_Invoice_No__c from Component_Movement_Table__c
                                             where RecordTypeID =: RecID and Document_Invoice_No__c like : '%' + tempSC_Code + '%' 
                                             and Document_Invoice_No__c like : strYear + '%'
                                             and Invoice_No_Trig_No__c != null
                                             order by Invoice_No_Trig_No__c desc limit 1];
                                           
        
    
    
    
         if(comp.size() > 0){
             
         
             System.debug('++++++++comp[0].Invoice_No_Trig_No__c +++++++++++'+comp[0].Invoice_No_Trig_No__c );
             compMove.Invoice_No_Trig_No__c = comp[0].Invoice_No_Trig_No__c + 1;
             System.debug('++++++++compMove.Invoice_No_Trig_No__c +++++++++++'+compMove.Invoice_No_Trig_No__c );
             String TempNo = String.Valueof(compMove.Invoice_No_Trig_No__c);
             
             While(TempNo.length() < 6) {
                 TempNo = '0' + TempNo;
               }
             String strYear = '';

             String strMonth = String.ValueOf(DateTime.Now().month());

             Integer intMonth = Integer.valueOf(strMonth);
             //System.debug('++++++++intMonth +++++++++++'+intMonth );

             if (intMonth >= 4) {

                 strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                 System.debug('++++++++strYear +++++++++++'+strYear );
               } 
             else {

                 strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            
                 System.debug('++++++++strYear +++++++++++'+strYear );
               }  
           SetSCCode(CompMove.OwnerId);
           
           StYear = Integer.valueof(strYear);
           System.debug('++++++++tempSC_Code+++++++++++'+tempSC_Code );
           System.debug('++++++++comp[0].Document_Invoice_No__c+++++++++++'+comp[0].Document_Invoice_No__c );
           Integer fiscalyr = Integer.valueOf(comp[0].Document_Invoice_No__c.subString(0,2));
           System.debug('++++++++comp[0].Document_Invoice_No__c.subString(2,4) +++++++++++'+comp[0].Document_Invoice_No__c.subString(2,5) );
           System.debug('++++++++fiscalyr+++++++++++'+fiscalyr );
           System.debug('++++++++StYear+++++++++++'+StYear);
           SC_No = Integer.valueof(SC_Code.subString(0,3));
           compMove.Document_Invoice_No__c = StYear + '' +SC_No + '75' + TempNo ;   
           System.debug('+++++compMove.Document_Invoice_No__c++++++++' + compMove.Document_Invoice_No__c);               
         
     }
         else{
             
             compMove.Invoice_No_Trig_No__c = 0;
             String strYear = '';
             String strMonth = String.ValueOf(DateTime.Now().month());
             Integer intMonth = Integer.valueOf(strMonth);
             if (intMonth >= 4) {
    
                    strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
                 } 
             else 
                 {
    
                    strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            
                    
                 }
             SetSCCode(CompMove.OwnerId);
             System.debug('+++++strYear++++++++' + strYear);
             StYear = Integer.valueof(strYear);
             System.debug('+++++StYear++++++++' + StYear);
             SC_No = Integer.valueof(SC_Code.subString(0,3));
             System.debug('+++++SC_No++++++++' + SC_No);
             compMove.Document_Invoice_No__c = StYear + '' +SC_No + '75' + '000000';                  
             }
        } 
    }
    public Void SetSCCode(Id OwnId)
        { 
        
        system.debug('===OwnId==='+OwnId);                     
        List<Stock_Point__c> StockPt = new List<Stock_Point__c>([Select Id, Name, Service_Center_Location_Code__c from Stock_Point__c 
                                  where OwnerId = :OwnId and RecordType.Name =  'Service Center' Limit 1]);
        if(Stockpt != null && Stockpt.size()>0){
            SC_Code = StockPt[0].Service_Center_Location_Code__c;
            System.debug('+++++SC_Code+++++++' + SC_Code);
        }
        strYear = '';
        String strMonth = String.ValueOf(DateTime.Now().month());
        Integer intMonth = Integer.valueOf(strMonth);
        if (intMonth >= 4) {
        
                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
             } 
        else 
             {
        
                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            
                
             }
        
        }

}