trigger trgCheckProductCateg on Component_Movement_line_Item__c (before insert,before update) {
      //trigger.new[0].addError('trigger.new[0].Component_Movement_Table__c'+trigger.new[0].Component_Movement_Table__c);
      Set<Id> prodIds = new Set<Id>();
         if(trigger.new[0].Select_Component__c != null || trigger.new[0].Select_Component__c != '')
         {
          prodIds.add(trigger.new[0].Select_Component__c);
         }
          List<Product__c> lstProduct = [select Product_Category__c from Product__c where id in :prodIds];
          
          
         if(lstProduct != null)
         {
           if(trigger.new[0].Component_Movement_Table__c != null)
           {
             //Component_Movement_Table__c objCM = trigger.new[0];
             //trigger.new[0].addError('trigger.new[0].Component_Movement_Table__c'+trigger.new[0].Component_Movement_Table__c);
             Component_Movement_Table__c objSR = [select id,Product_Category__c from Component_Movement_Table__c where id =:trigger.new[0].Component_Movement_Table__c];
             
             for(Product__c p :lstProduct)
             {
                if(p.Product_Category__c != objSR.Product_Category__c)
                {
                    //trigger.new[0].addError('p.Product_Category__c'+p.Product_Category__c);
                    //trigger.new[0].addError('objSR.Product_Category__c'+objSR.Product_Category__c);
                  trigger.new[0].addError('Product category should be same.');
                }
             }
           }
         }

}