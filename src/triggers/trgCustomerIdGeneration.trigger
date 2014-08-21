trigger trgCustomerIdGeneration on Account (before Insert) {

    /*If(Trigger.IsInsert)
    {
        Account[] Acc = [Select trgCustomerID__c from Account where trgCustomerID__c != null order by trgCustomerID__c desc limit 1];
        
        If(Acc.size()>0)
        {
            Trigger.new[0].trgCustomerID__c = Acc[0].trgCustomerID__c + 1;
            String TempNo = String.Valueof(Trigger.new[0].trgCustomerID__c);
            While(TempNo.length() < 8)
                TempNo = '0' + TempNo;    
            String strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
            String strMonth = String.ValueOf(DateTime.Now().month());
            If(strMonth.length()==1)
                strMonth = '0' + strMonth;
            Trigger.new[0].Customer_ID__c = strYear + strMonth + TempNo.substring(0,6);
            
        }
        Else
        {
            Trigger.new[0].trgCustomerID__c = 0;
            String strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
            String strMonth = String.ValueOf(DateTime.Now().month());
            If(strMonth.length()==1)
                strMonth = '0' + strMonth;
            Trigger.new[0].Customer_ID__c = strYear + strMonth + '000000';
            
        }
    }*/
}