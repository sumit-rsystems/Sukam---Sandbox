public class ProductController {
    
    public Product__c prodRec { get; set; }
    public List<Price_Book_Entry__c> stdPriceList {get; set;}
    public String productName {get;set;}
    Standard_Price__c stdPrice ;
    String pbeid;
    String pid;
    String stdid;
    
   public productController(ApexPages.StandardController controller){
        stdPrice = new Standard_Price__c();
        stdid = ApexPages.currentPage().getParameters().get('id');
        if(stdid  != null && stdid != ''){    
            stdPrice = [Select id, Name, Price_Book_Entry__c, Products__c, Products__r.Name from Standard_Price__c where id=:stdid ];
            productName = stdPrice.Products__r.Name;
        }    
        pid = ApexPages.currentPage().getParameters().get('pid');
        String type = ApexPages.currentPage().getParameters().get('type');
        if(stdid != null && stdid != '' )
            type = 'edit';    
        stdPriceList = new List<Price_Book_Entry__c>();
        if(pid != null && pid != ''){
            prodRec = [select Name from Product__c where id = :pid];
            productName = prodRec.Name;
        }
        List<Price_Books__c> pbList = [select Name, isStandard__c from Price_Books__c where isStandard__c = true];
        if(pbList != null && pbList.size() == 0) {
            system.debug('pbList==='+pbList);
            Price_Books__c stdpb = new Price_Books__c(Name = 'Standard Price Book', isStandard__c = true);
            pbList.add(stdpb);
            insert pbList;
        }
        List<Price_Book_Entry__c> spList = new List<Price_Book_Entry__c>();
        if(stdPrice.Price_Book_Entry__c != null){
            
             spList = [select CurrencyIsoCode, Conversion_Rate__c, UnitPrice__c, IsActive__c , Product__r.Name
                       from Price_Book_Entry__c where id = :stdPrice.Price_Book_Entry__c];
                   
        }
       else  { 
             if(pid != null && pid != '' && pbList != null && pbList.size() > 0)             
                 spList = [select CurrencyIsoCode, Conversion_Rate__c, UnitPrice__c, IsActive__c, Product__r.Name 
                          from Price_Book_Entry__c where Product__c = :pid
                          and Price_Book__c =: pbList[0].id];
       } 
        if(type != null && type.equals('new')) {
            Set<String> curncySet = new Set<String>();
            for(Price_Book_Entry__c sp :spList) {
                curncySet.add(sp.CurrencyIsoCode);
            }
            
            for(CurrencyType ct :[Select c.IsoCode, c.IsActive, c.ConversionRate From CurrencyType c where isActive = true]) {
                if(!curncySet.contains(ct.IsoCode)) {
                    stdPriceList.add(new Price_Book_Entry__c(
                        CurrencyIsoCode = ct.IsoCode, 
                        Product__c = pid,
                        Conversion_Rate__c = ct.ConversionRate,
                        Price_Book__c = pbList[0].id,
                        UnitPrice__c = 0.0,
                        isActive__c = true
                    ));
                }
            }
        }
        
        if(type != null && type.equals('edit')) {
            stdPriceList.addAll(spList);
        }
   }
    
    public productController() {
        
    }
    
    public pageReference doCancel(){
        pageReference page;
        if(stdid != null && stdid  != '')
            page = new PageReference('/'+stdPrice.Products__c);    
        else
            page = new PageReference('/'+pid);
       
        page.setRedirect(true);
        return page;
    }
    
    public PageReference doSave() {
        List<Price_Book_Entry__c> listToInsert = new List<Price_Book_Entry__c>();
        for(Price_Book_Entry__c sp :stdPriceList) {
            
            if(sp.id == null && sp.UnitPrice__c!= null && sp.UnitPrice__c > 0) {
                listToInsert.add(sp);
            } else if(sp.id != null && (sp.UnitPrice__c == null || sp.UnitPrice__c <= 0)) {
                ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'Standard Price cannot be blank'));
                return null;
            }  else if(sp.id != null) {
                listToInsert.add(sp);
            }
        }
        if(listToInsert != null && listToInsert.size() > 0)
            upsert listToInsert;
        if(stdid != null && stdid != '')
            return new PageReference('/'+stdPrice.Products__c);    
        else
            return new PageReference('/'+pid);
    }
}