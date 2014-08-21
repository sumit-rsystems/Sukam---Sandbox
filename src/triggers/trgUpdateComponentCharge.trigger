trigger trgUpdateComponentCharge on Component_Movement_line_Item__c (before insert, before update) {
    
    //If stock transfer not defined then pick standard sale price
     if(trigger.new[0].Stock_Transfer_Price_Unit__c == null)
     {
        Price_Book_Entry__c objPBE = [Select id,Product__c,UnitPrice__c,Price_Book__r.Name from Price_Book_Entry__c where Price_Book__r.Name =: 'Standard' and  Product__c =: trigger.new[0].Select_Component__c];
        trigger.new[0].Stock_Transfer_Price_Unit__c = objPBE.UnitPrice__c ;
     }
       
    
    Component_Movement_Table__c objCMT = [select id,Discount_in_component_charge__c,Misc_Component_Charges__c  from Component_Movement_Table__c  where id =:trigger.new[0].Component_Movement_Table__c];
    //trigger.new[0].addError('ABC   -->'+objCMT.Product_Category__c);
    
    if(objCMT.Discount_in_component_charge__c != null)
    {
      //trigger.new[0].addError('ABC'+trigger.new[0].Component_Movement_Table__r.Discount_in_component_charge__c);
      trigger.new[0].Component_discount__c = objCMT.Discount_in_component_charge__c ; 
    }
    if(objCMT.Misc_Component_Charges__c  != null)
    {
      trigger.new[0].Misc_Component_Charges__c = objCMT.Misc_Component_Charges__c ; 
    }
}