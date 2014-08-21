trigger trgSetSharing on Component_Movement_Table__c (after Insert) {

    InventoryUpdate InvUpd = new InventoryUpdate();
    
    If(Trigger.new.size()==1 && Trigger.isInsert)
    {
        If(Trigger.new[0].Type_of_Transfer__c  == 'Stock Transfer')
        {
            InvUpd.SetSharing(Trigger.new[0]);
        }
    }

}