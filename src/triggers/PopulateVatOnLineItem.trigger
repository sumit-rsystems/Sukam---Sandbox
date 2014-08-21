trigger PopulateVatOnLineItem on Component_Movement_line_Item__c (before insert, before update) {
    
    ComponentMovementLineItemTriggerUtil.populateSalesPrice(trigger.new);
    
    ComponentMovementLineItemTriggerUtil.populateVatOnLineItem(trigger.new);

    ComponentMovementLineItemTriggerUtil.deductQuantityFromStockPoint(trigger.new);
}