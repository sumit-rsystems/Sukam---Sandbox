trigger trgCheckStockPointOwner on Stock_Point__c (before Insert, before Update) {

/*
    for(Stock_Point__c StockPt: Trigger.new)
    {   
        
        String RecTypeName = [Select Name from RecordType where Id = :StockPt.REcordTypeId].Name;
        
        If(RecTypeName == 'Service Center')
        {
            If(StockPt.Service_Center_Description__c != 'In Transit' && StockPt.Service_Center_Description__c != 'TRC')
            {
                String Profile = [Select Profile.Name from User where Id = :StockPt.OwnerId].Profile.Name;
                
                If(Profile == 'System Administrator')
                {
                    Trigger.new[0].addError('System Administrator cannot create/own any Service Centers');
                }
                
                Stock_Point__c[] StkPt = [Select Id from Stock_Point__c where OwnerId = :StockPt.OwnerId and RecordType.Name='Service Center'];
                
                If(StkPt.size()>0)
                {
                    Trigger.new[0].addError('This User already owns another Service Center. One user cannot own two Service Centers');
                }    
            }                
        }            
    }
*/    
}