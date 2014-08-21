trigger insertProductNameonCMT on Component_Movement_Table__c (before update,before insert) {

if(UtilClass.runOnce()) {
    List<Product__c> lstProduct = new List<Product__c>();
        lstProduct = [Select p.Product_Code__c, p.Name, p.Id From Product__c p];
        
        Map<String,Id> mapProduct = new Map<String,Id>();
        for(Product__c p : lstProduct){
            if(p.Product_Code__c != null ) {
                mapProduct.put(p.Product_Code__c.toUpperCase() , p.Id);
                System.debug(mapProduct.get(p.Product_Code__c));
            }
         }
         Schema.RecordTypeInfo rtByName = Schema.SObjectType.Component_Movement_Table__c.getRecordTypeInfosByName().get('Product Sale');
         String prodSaleRecTypeId = rtByName.getRecordTypeId();
           if(mapProduct != null && mapProduct.size() > 0){
            for( Component_Movement_Table__c sr : Trigger.new){
               if(prodSaleRecTypeId == sr.RecordTypeId) continue; // added by varsha 15-03-2013 to stop execution in case of product sales
               
               if(sr.Product_Code_1__c != null && sr.Product_Code_1__c != '' && mapProduct.containsKey(sr.Product_Code_1__c.toUppercase())){               
                        sr.Select_Component__c = mapProduct.get(sr.Product_Code_1__c.toUpperCase());  
               }
               else{
                    if(sr.Product_Code_1__c== null && sr.Select_Component__c == null){
                    trigger.new[0].addError('Either fill correct Product Code or select Product from Products ');
                    }
                    else if(sr.Product_Code_1__c != null && !mapProduct.containsKey(sr.Product_Code_1__c.toUpperCase())){
                    trigger.new[0].addError('Please Fill correct Product Code or select Product from Products ');
                    }
                  }
                  
                  
                if(sr.Product_Code_2__c != null && sr.Product_Code_2__c != '' && mapProduct.containsKey(sr.Product_Code_2__c.toUpperCase())){               
                        sr.Select_Component_2__c = mapProduct.get(sr.Product_Code_2__c.toUpperCase());    
                  }  
                   else if(sr.Product_Code_2__c != null && !mapProduct.containsKey(sr.Product_Code_2__c.toUpperCase())){
                    trigger.new[0].addError('Please Fill correct Product Code or select Product from Products ');
                    }
                    
                    
                if(sr.Product_Code_3__c != null && sr.Product_Code_3__c != '' && mapProduct.containsKey(sr.Product_Code_3__c.toUpperCase())){               
                        sr.Select_Component_3__c = mapProduct.get(sr.Product_Code_3__c.toUpperCase());    
                  }  
                   else if(sr.Product_Code_3__c != null && !mapProduct.containsKey(sr.Product_Code_3__c.toUpperCase())){
                    trigger.new[0].addError('Please Fill correct Product Code or select Product from Products ');
                    }
                        
              
                  if(sr.Product_Code_4__c != null && sr.Product_Code_4__c != '' && mapProduct.containsKey(sr.Product_Code_4__c.toUpperCase())){               
                        sr.Select_Component_4__c = mapProduct.get(sr.Product_Code_4__c.toUpperCase());    
                  }  
                   else if(sr.Product_Code_4__c != null && !mapProduct.containsKey(sr.Product_Code_4__c.toUpperCase())){
                    trigger.new[0].addError('Please Fill correct Product Code or select Product from Products ');
                    }   
                  
           }     
      }       
  } 
}