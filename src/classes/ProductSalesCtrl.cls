public class ProductSalesCtrl {
    
    public Component_Movement_Table__c cmtRecord {get; set;}
    public List<LineItemWrapper> lineItemWrapList {get; set;}
    public Integer numberOfRows {get; set;}
    public Boolean showTable {get; set;}
    
    public productSalesCtrl() {
        cmtRecord = new Component_Movement_Table__c();
        Schema.RecordTypeInfo rtByName = Schema.SObjectType.Component_Movement_Table__c.getRecordTypeInfosByName().get('Product Sale');
        cmtRecord.RecordTypeId = rtByName.getRecordTypeId();
        lineItemWrapList = new List<LineItemWrapper>();
        numberOfRows = 1;
        addRow();
    }
    
    public void GetProductCategory()
    {
    
        Set<Id> prodIds = new Set<Id>();
        prodIds.add(lineItemWrapList[0].cmtliRecord.Select_Component__c);
        system.debug('GetCateg++++++'+lineItemWrapList[0].cmtliRecord.Select_Component__c);
        
        //Map<Id, Product__c> mapProduct = new Map<Id, Product__c>([select Product_Category__c from Product__c where id in :prodIds]);        
        Product__c objProduct = [select Product_Category__c from Product__c where id in :prodIds];
            
        if( objProduct != null ) {
          cmtRecord.Product_Category__c = objProduct.Product_Category__c;
             //ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, objProduct.Product_Category__c));              
          
                           }
                           
    }
    
    public PageReference addRow() {
        
        Integer rownum = lineItemWrapList.size();
        Integer endlimit = 1;
        if(numberOfRows != null && numberOfRows != 0) {
            endlimit = numberOfRows;
            for(Integer i = (rownum + 1); i <= (rownum + endlimit); i++) {
                lineItemWrapList.add(new LineItemWrapper(i, new Component_Movement_line_Item__c()));
            }
        }
        if(lineItemWrapList != null && lineItemWrapList.size() > 0) {
            showTable = true;
        }
        numberOfRows = 1;
        return null;
    }
    
    public PageReference removeRow(){
        String indx = ApexPages.currentPage().getParameters().get('indx');      
        Integer indxnum = Integer.valueOf(indx);
        lineItemWrapList.remove(indxnum - 1);
        
        if(indxnum - 1 < lineItemWrapList.size()){
            for(Integer i = (indxnum - 1); i < lineItemWrapList.size(); i++) {
               lineItemWrapList[i].index = i + 1; 
            } 
        }
        if(lineItemWrapList == null || lineItemWrapList.size() == 0) {
            showTable = false;
        }
        return null;
    }
    
    public PageReference doSave() {
      
        if(lineItemWrapList == null || lineItemWrapList.size() == 0) {
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'Please add atleast one Product.'));
            return null;
        }
            
        try {
            if(cmtRecord != null)
                upsert cmtRecord;
        } catch(Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        Set<Id> prodIds = new Set<Id>();
        for(LineItemWrapper wrap :lineItemWrapList) {
            if(prodIds != null && prodIds.contains(wrap.cmtliRecord.Select_Component__c)) {
                ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'Product should not be repeated in line items.'));  
                return null;
            } else {
                prodIds.add(wrap.cmtliRecord.Select_Component__c);
            }
        }
        
        Map<Id, Product__c> mapProduct = new Map<Id, Product__c>([select Product_Category__c from Product__c where id in :prodIds]);
        
        List<Component_Movement_line_Item__c> lineItemList = new List<Component_Movement_line_Item__c>();
        
        for(LineItemWrapper wrap :lineItemWrapList) {
            if(wrap.cmtliRecord.Component_Movement_Table__c == null)
                wrap.cmtliRecord.Component_Movement_Table__c = cmtRecord.id;
            
           if( mapProduct != null && mapProduct.containsKey(wrap.cmtliRecord.Select_Component__c) && 
                   cmtRecord.Product_Category__c == mapProduct.get(wrap.cmtliRecord.Select_Component__c).Product_Category__c) {
               lineItemList.add(wrap.cmtliRecord);
           } else {
               ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'Product Category of all products should be "' + cmtRecord.Product_Category__c + '" as selected in Information section.'));  
               return null;
           }
              
        }
        try {
            if(lineItemList != null && lineItemList.size() > 0) {
                insert lineItemList;
                cmtRecord.Generate_Invoice_Bill_No__c = true;
                update cmtRecord;
            }    
            
        } catch(Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        return new PageReference('/' + cmtRecord.id);
    }
    
    public PageReference doCancel() {
        return new PageReference('/' + objectKeyPrefix());
    }
    
    public String objectKeyPrefix() {
      String prefix = Component_Movement_Table__c.SObjectType.getDescribe().getKeyPrefix();
      return prefix;
  } 
      
    public class LineItemWrapper {       
        public Component_Movement_line_Item__c cmtliRecord {get;set;}
        public Integer index {get;set;}
        
        public LineItemWrapper(Integer index, Component_Movement_line_Item__c cmtliRecord) {           
            this.index = index;
            this.cmtliRecord = cmtliRecord;
        }   
    }   
}