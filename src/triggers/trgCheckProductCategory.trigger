trigger trgCheckProductCategory on Component_Movement_Table__c (before insert,before update) 
{
        
          
         Set<Id> prodIds = new Set<Id>();
         if(trigger.new[0].Select_Component__c != null || trigger.new[0].Select_Component__c != '')
         {
          prodIds.add(trigger.new[0].Select_Component__c);
         }
         if(trigger.new[0].Select_Component_2__c != null || trigger.new[0].Select_Component_2__c != '')
         {
          prodIds.add(trigger.new[0].Select_Component_2__c);
         }
         if(trigger.new[0].Select_Component_3__c != null || trigger.new[0].Select_Component_3__c != '')
         {
          prodIds.add(trigger.new[0].Select_Component_3__c);
         }
         if(trigger.new[0].Select_Component_4__c != null || trigger.new[0].Select_Component_4__c != '')
         {
          prodIds.add(trigger.new[0].Select_Component_4__c);
         }
         
         List<Product__c> lstProduct = [select Product_Category__c from Product__c where id in :prodIds];
         //Set<Product__c> lstProduct = [select Product_Category__c from Product__c where id in :prodIds];
         
         if(lstProduct != null)
         {
           if(trigger.new[0].Service_Request__c != null)
           {
             //Component_Movement_Table__c objCM = trigger.new[0];
             Service_Request__c objSR = [select id,Product_Category__c from Service_Request__c where id =:trigger.new[0].Service_Request__c];
             
             for(Product__c p : lstProduct)
             {
             
                //if(p.Product_Category__c != trigger.new[0].Service_Request__r.Product_Category__c)
                if(p.Product_Category__c != objSR.Product_Category__c)
                {
                  trigger.new[0].addError('Product category should be same.');
                  //trigger.new[0].addError('list......+++'+objSR.Product_Category__c );
                  //trigger.new[0].addError('list......+++'+p.Product_Category__c );
                }
             }
           }
         }
         
        /* // Check Component movement line item if whole Product is already added then u can't add their component
            string ProductCatg = lstProduct[0].Product_Category__c;
            List<Component_Movement_Table__c> lstCMT = [Select id,Service_Request__c,Select_Component__c,Select_Component__r.Product_Category__c from  Component_Movement_Table__c where Service_Request__c =: trigger.new[0].Service_Request__c];
  
              if(lstCMT.size()>0)
              {
                                
                for(Component_Movement_Table__c obj : lstCMT)
                {
                   if(ProductCatg == 'Component' && obj.Select_Component__r.Product_Category__c != 'Component')
                   //if(lstProduct.contains('Component') && obj.Select_Component__r.Product_Category__c != 'Component')
                   {
                     trigger.new[0].addError('You can not make that transaction.You already added the Product.');
                   }
                   if(ProductCatg != 'Component' && obj.Select_Component__r.Product_Category__c == 'Component')
                   //if(!lstProduct.contains('Component') && obj.Select_Component__r.Product_Category__c == 'Component')
                   {
                     trigger.new[0].addError('You can not make that transaction.You already added the component');
                   }
                }
              }*/
}