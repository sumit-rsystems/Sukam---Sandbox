public class priceBookEntryPageComponentCon{
    public List<Price_Book_Entry__c> pbeList {get;set;}
    public Product__c product {get;set;}
    
    public priceBookEntryPageComponentCon(ApexPages.StandardController controller){
        this.product = (Product__c)controller.getRecord();
        
        system.debug('Product======'+product);
        generatePBEList() ;   
    }  
    
    public void generatePBEList(){
        pbeList = new List<Price_Book_Entry__c>();
        if(product!= null)
            pbeList = [SELECT IsActive__c,  Name__c, Name, OwnerId,Price_Book__r.Name, Price_Book__r.IsStandard__c, PriceBook__c, Price_Book__c, 
                       Product__c, Product_Code__c, Id, UnitPrice__c, UseStandardPrice__c FROM Price_Book_Entry__c
                       WHERE Product__c =:product.Id  and Price_Book__c!= null and Price_Book__r.IsStandard__c = false];
        system.debug('pbeList==='+pbeList);           
    }
    
    public pageReference editPBE(){
        String pbeId = ApexPages.currentPage().getParameters().get('pbeId');   
        pageReference page = new pageReference('/apex/editPricBookEntryList?pid='+product.id+'&pbeId='+pbeId);
        page.setRedirect(true);
        return page;
    }
    public pageReference viewPBE(){
        String pbeId = ApexPages.currentPage().getParameters().get('pbeId');   
        pageReference page = new pageReference('/'+pbeId);
        page.setRedirect(true);
        return page;    
    }
    
    public pageReference deletePBE(){
        String pbeId = ApexPages.currentPage().getParameters().get('pbeId');  
        Price_Book_Entry__c pbe = new Price_Book_Entry__c();
        if(pbeId != null && pbeId != '')
            pbe = [Select id from Price_Book_Entry__c where id=:pbeId] ;
        if(pbe != null){
            try{
                delete pbe;
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                return null;
            }
        }    
        return null;
    }
    
}