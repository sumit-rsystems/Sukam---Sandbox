trigger SalesBillno on Component_Movement_Table__c (before update) {
       //Component_Movement_Table__c CompMove = Trigger.new[0];
    
    Schema.DescribeSObjectResult d = Schema.SObjectType.Component_Movement_Table__c;
    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtByName =  rtMapByName.get('Product Sale');
    String recId = rtByName.getRecordTypeId();

    //if(RunOnceCLass.runOnce()) {
        Sale_bill_no slBill = new  Sale_bill_no();
        Component_Movement_Table__c rec = new Component_Movement_Table__c();
        
        for(Component_Movement_Table__c cmt :trigger.new){
            Component_Movement_Table__c cmtOld = System.trigger.oldMap.get(cmt.id);
            if(cmt.Generate_Invoice_Bill_No__c != cmtOld.Generate_Invoice_Bill_No__c && cmt.Generate_Invoice_Bill_No__c) {
                if(Cmt.RecordTypeID == recId){
                    rec = cmt;
                }
            }
        }
        if(rec != null)
            slBill.SetSaleBillNo(rec);
    //}
  
}