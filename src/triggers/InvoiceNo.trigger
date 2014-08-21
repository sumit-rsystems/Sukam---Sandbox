trigger InvoiceNo on Component_Movement_Table__c (Before update) {
    Schema.DescribeSObjectResult d = Schema.SObjectType.Component_Movement_Table__c;
    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtByName =  rtMapByName.get('Product Sale');
    String recId = rtByName.getRecordTypeId();
    
    Component_Movement_Table__c rec = new Component_Movement_Table__c();
    Invoice_no InvNo = new Invoice_no();
    Id OldOwner;
    //rIId OldOwner = CompMove.Owned;
    //InvNo.SetSCCode(OldOwner); 
        for(Component_Movement_Table__c cmt :trigger.new){
            Component_Movement_Table__c cmtOld = System.trigger.oldMap.get(cmt.id);
            if(cmt.Generate_Invoice_Bill_No__c != cmtOld.Generate_Invoice_Bill_No__c && cmt.Generate_Invoice_Bill_No__c) {
                if(Cmt.RecordTypeID == recId){
                    OldOwner = Cmt.Ownerid;
                    InvNo.SetSCCode(OldOwner);
                    rec = cmt;
                }
            }
        }    
        
        if(rec != null) {
            InvNo.SetSCCode(OldOwner);
            InvNo.SetInvoiceno(rec,recid);
        }
}