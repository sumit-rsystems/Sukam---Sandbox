public class editPriceBookEntryCon{
    String pid;
    String pbeid;
    public List<priceBookWrapper> pbeList {get;set;}
    Map<String, Double> stPriceMap ;
    
    public editPriceBookEntryCon(ApexPages.StandardController controller){
        pid = ApexPages.CurrentPage().getParameters().get('pid'); 
        pbeid = ApexPages.CurrentPage().getParameters().get('pbeid'); 
        createPiceMap();
        createPriceBookList();
          
    }
    
    public void createPiceMap(){
        stPriceMap = new Map<String, Double>();
        if(pid != null && pid != ''){
            for(Standard_Price__c s : [SELECT Active__c, Conversion_Rate__c,CurrencyIsoCode, Products__c, 
                                        Id, Standard_Price__c, Name FROM Standard_Price__c where Products__c=: pid]){
                stPriceMap.Put(s.CurrencyIsoCode,s.Standard_Price__c);                                
            }
            if(stPriceMap == null || stPriceMap.size()== 0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is no standard price record.');
                ApexPages.addMessage(myMsg);
            }
        }
    }
    
    public void createPriceBookList(){
          pbeList =   new List<priceBookWrapper>();
          if(pid != null && pid != ''){
              List<Price_Book_Entry__c> pbeTempList = new List<Price_Book_Entry__c>();
              if(pbeid != null && pbeid != ''){
                  pbeTempList = [SELECT CurrencyIsoCode, IsActive__c, LastModifiedDate, Name__c, 
                                OwnerId, PriceBook__c, Price_Book__r.Name, Price_Book__c, Product__c , Product__r.Name, Product_Code__c, 
                                Id, UnitPrice__c, UseStandardPrice__c FROM Price_Book_Entry__c where id =:pbeid ];
              }
              else{
                  pbeTempList = [SELECT CurrencyIsoCode, IsActive__c, LastModifiedDate, Name__c, 
                                OwnerId, PriceBook__c, Price_Book__r.Name, Price_Book__c, Product__c , Product__r.Name, Product_Code__c, 
                                Id, UnitPrice__c, UseStandardPrice__c FROM Price_Book_Entry__c where id =:pid
                                and Price_Book__r.IsStandard__c = false];
              }
              if(pbeTempList != null && pbeTempList.size() > 0){
                  for(Price_Book_Entry__c  p : pbeTempList){
                      if(stPriceMap != null && stPriceMap.size() > 0 ) {
                          if(stPriceMap.containsKey(p.CurrencyIsoCode))
                              pbeList.add(new priceBookWrapper(p,stPriceMap.get(p.CurrencyIsoCode)));    
                      }
                  }   
              }     
          }
    }
    
     public pageReference doCancel(){
        pageReference page = new PageReference('/'+pId);
        page.setRedirect(true);
        return page;
    }

    
    public pageReference doSave(){
        if(pbeList != null && pbeList.size() > 0){
            List<Price_Book_Entry__c> pbeTempList = new List<Price_Book_Entry__c>();
            Boolean flag = false;
            for(priceBookWrapper p : pbeList){
                p.pbe.UseStandardPrice__c = p.Selected;
                if(p.pbe.UnitPrice__c == null || p.pbe.UnitPrice__c == 0)
                    if(!p.Selected){
                        flag = true;
                        break;
                    }
                
                if(p.Selected)
                    p.pbe.UnitPrice__c = p.stdPrice ;
                   
                pbeTempList.add(p.pbe);
        }    
        
        if(flag){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'UnitPrice can not be blank .');
            ApexPages.addMessage(myMsg);
            return null;
        }
        else{
            if(pbeTempList != null ){
                try{
                    update pbeTempList ; 
                }Catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                    ApexPages.addMessage(myMsg);
                    return null;   
                }   
            }
        }
        PageReference page =  new PageReference('/'+pid);
        page.setRedirect(true);
        return page;
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'There is no record.');
            ApexPages.addMessage(myMsg);
            return null; 
        }
     }
       
    
    
     public class priceBookWrapper{
        public Price_Book_Entry__c pbe{get;set;}
        public Boolean selected {get;set;}
        public Double stdPrice {get;set;}    
        
        public priceBookWrapper(Price_Book_Entry__c pb,Double sp){
            this.pbe= pb;
            this.selected = false;
            this.stdPrice = sp;
        }
    }    
}