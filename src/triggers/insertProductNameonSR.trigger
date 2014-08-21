trigger insertProductNameonSR on Service_Request__c (before update,before insert) {
    
    if(UtilClass.runOnce()) {    
        List<Product__c> lstProduct = new List<Product__c>();        
        lstProduct = [Select p.Product_Code__c, p.Name, p.Id From Product__c p];
        
        
        Map<String,Id> mapProduct = new Map<String,Id>();
        for(Product__c p : lstProduct){
            if(p.Product_Code__c != null && p.Product_Code__c != ''){
                mapProduct.put(p.Product_Code__c.toUpperCase() , p.Id);   
                System.debug('=============='+mapProduct.get(p.Product_Code__c));                             
            }
        }
        if(mapProduct != null && mapProduct.size() > 0){
            for(Service_Request__c  sr : Trigger.new){
                
                if(sr.Product_Code__c != null && sr.Product_Code__c != '' && mapProduct.containsKey(sr.Product_Code__c.toUpperCase())){               
                        sr.Products__c = mapProduct.get(sr.Product_Code__c.toUpperCase());
                }
                else{
                    if(sr.Product_Code__c == null && sr.Products__c == null){
                    trigger.new[0].addError('Either fill correct product code or select Product from Products ');
                    }
                    else if(sr.Product_Code__c != null && !mapProduct.containsKey(sr.Product_Code__c)){
                    trigger.new[0].addError('Fill correct product code or select Product from Products ');
                    }
                }
            }
        }   
    }     
}