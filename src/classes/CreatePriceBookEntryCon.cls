public class CreatePriceBookEntryCon {
    public Product__c product {get; set;}
    public List<priceBookWrapper> pbWrapperList {get;set;}
    public List<priceBookWrapper> finalWrapperList {get;set;}
    public List<Price_Book_Entry__c> lstPriceBookEntry{get;set;}
    String prodId ;
    public CreatePriceBookEntryCon(ApexPages.StandardController controller){
        //this.product = (Product__c)controller.getRecord();
        prodId = ApexPages.currentPage().getParameters().get('id');
        if(prodId != null){
            product = new Product__c();
            product = [SELECT Category_Code__c, Category_Description__c, CurrencyIsoCode, 
                              (SELECT id, name, Products__c ,Standard_Price__c, Active__c,
                               CurrencyIsoCode from  Standard_Price__r order by  CurrencyIsoCode),
                              Is_Active__c,  Product_Code__c, Product_Description__c, Family__c, 
                              Name, ProductUpsertId__c, Id, UoM__c FROM Product__c 
                       WHERE  id =:prodId ];
        }
        createPriceBookList();
            
        system.debug('product ======='+product );
    }
    
    public void createPriceBookList(){
        pbWrapperList = new List<priceBookWrapper>();
        List<Price_Books__c> pblist = new List<Price_Books__c>();
        
        pblist = [SELECT CreatedDate,(Select id, Name , Product__c, CurrencyIsoCode, Price_Book__c from Price_book_Entry__r 
                         where Product__c =:product.id order by CurrencyIsoCode), Description__c, CurrencyIsoCode,
                         IsActive__c, LastModifiedDate, IsStandard__c, Name, Id FROM Price_Books__c where IsStandard__c = false LIMIT 100];
        
        system.debug('pblist========'+pblist);
        if(pblist != null && pblist.size() > 0){
            String str = '';
            if(product.Standard_Price__r != null && product.Standard_Price__r.size() > 0){
                 for(Standard_Price__c sp : product.Standard_Price__r){
                     str += ';'+ sp.CurrencyIsoCode ;
                 }
                 if(str != '')
                     str = str.subString(1);
            }         
            
            system.debug('str====='+str);
            for(Price_Books__c p : pblist){
                String pbestr = '';
                for(Price_Book_Entry__c pbe : p.Price_book_Entry__r){
                    pbestr  +=  ';'+ pbe.CurrencyIsoCode;      
                }
                if(pbestr  != '')
                    pbestr  = pbestr.subString(1);
                system.debug('pbestr====='+pbestr  );
                if(pbestr  != '' && pbestr  == str)  
                    pbWrapperList.add(new priceBookWrapper(p, false));  
                else                    
                    pbWrapperList.add(new priceBookWrapper(p,true));
            }
           
        system.debug('pbWrapperList==='+pbWrapperList);
        }
    }
   
       
    public pageReference doCancel(){
        pageReference page = new PageReference('/'+product.Id);
        page.setRedirect(true);
        return page;
    }
    
    public pageReference doSave(){
        save();
        pageReference page = new pageReference('/'+product.id);
        page.setRedirect(true);
        return page;
    }
    
    public void save(){
        if(finalWrapperList!= null && finalWrapperList.size() > 0){
            List<Price_Book_Entry__c> pbeList = new List<Price_Book_Entry__c>();
            for(priceBookWrapper p: finalWrapperList){
                system.debug(p.unitPrice+ '============='+p.flag );
                if(p.flag || (p.unitPrice!= null && p.unitPrice!= 0) ){
                    Price_Book_Entry__c pbe = new Price_Book_Entry__c();
                    pbe.Product__c = product.id;
                    pbe.Price_Book__c = p.PriceBook.id;
                    pbe.UseStandardPrice__c = p.flag;
                    if(p.flag){
                       pbe.UnitPrice__c = p.stdPrice.Standard_Price__c;
                       } 
                    else
                        pbe.UnitPrice__c = p.unitPrice ;   
                    pbe.IsActive__c = p.selected ;
                    pbe.CurrencyIsoCode = p.stdPrice.CurrencyIsoCode;
                    pbeList.add(pbe);
                }
            }
            if(pbeList != null && pbeList.size() > 0){
                try{
                   system.debug('pbeList====='+pbeList);
                    insert pbeList;
                }catch(Exception e){
                 system.debug('error====='+e.getMessage());
                }
            }        
        }
    }
    
    public pageReference doSaveAndMore(){
        save();
        pageReference page = new pageReference('/apex/SelectPriceBook?id='+product.id);
        page.setRedirect(true);
        return page;
    }
    
    public pageReference onSelect(){
        system.debug('pbWrapperList======'+pbWrapperList);
        if(pbWrapperList != null && pbWrapperList.size() > 0){
            Set<ID> pbIds = new Set<ID>();            
            for(priceBookWrapper pw : pbWrapperList){
                if(pw.selected){
                    pbIds.add(pw.priceBook.Id);          
                }
            }
            system.debug('pbIds======'+pbIds);
            List<Standard_Price__c> priceList = new List<Standard_Price__c>();
            List<Price_Book_Entry__c> pbeTempList = new List<Price_Book_Entry__c>();
            priceList = [SELECT id, name, Products__c ,Standard_Price__c, Active__c,
                                CurrencyIsoCode from  Standard_Price__c  
                          WHERE Products__c =: this.product.id ];
            system.debug('priceList======'+priceList);
            Set<String> currencyIsoCodeString = new  Set<String>();
            if(priceList != null && priceList.size() != null){
                for(Standard_Price__c sp : priceList){
                    currencyIsoCodeString.add(sp.CurrencyIsoCode); 
                }
                system.debug('currencyIsoCodeString======'+currencyIsoCodeString);
            }  
                           
            if(pbIds != null && pbIds.size() > 0 && currencyIsoCodeString != null && currencyIsoCodeString.size() > 0 ){
                pbeTempList = [SELECT Name, CurrencyIsoCode, Price_Book__c, Product__c, Product_Code__c, Id, UnitPrice__c  
                              FROM   Price_Book_Entry__c 
                              WHERE  Product__c =: this.product.id AND  Price_Book__c IN: pbIds 
                                     AND CurrencyIsoCode IN : currencyIsoCodeString ];
                system.debug('pbeTempList '+ pbeTempList );
            }
            Set<ID> invalidIdSet = new Set<Id>();
            String uniqueString = '';
            if(pbeTempList != null){
               for(Price_Book_Entry__c c : pbeTempList){
                   uniqueString += ';'+ c.Price_Book__c + '-'+ c.CurrencyIsoCode;            
               }
               system.debug('uniqueString======'+uniqueString);
            } 
            if(priceList != null && priceList.size() > 0 ){
                finalWrapperList = new List<priceBookWrapper>();
                for(priceBookWrapper pw : pbWrapperList){
                    if(pw.selected){
                        for(Standard_Price__c sp : priceList){
                            string temp = pw.priceBook.id + '-'+ sp.CurrencyIsoCode ;
                            system.debug('temp======='+temp);
                            if(uniqueString==null ||uniqueString=='' || (!uniqueString.contains(temp))){
                                system.debug('uniqueString==inif====='+uniqueString);
                                system.debug('priceBook==='+pw.priceBook);
                                system.debug('product.name ==='+product.name );
                                finalWrapperList.add(new priceBookWrapper(pw.priceBook,sp,product.name ));    
                                system.debug('temp======='+temp);
                            }
                        }          
                    }
                }
            }
            return new pageReference('/apex/SelectedPriceBook');   
        } 
        return null; 
        
        
    }
    
    public class priceBookWrapper{
        public Price_Books__c priceBook {get;set;}
        public Boolean selected {get;set;}
        public Standard_Price__c stdPrice {get;set;}
        public String product{get;set;}
        public double unitPrice{get;set;}
        public Boolean flag {get;set;}
        
        
        public priceBookWrapper(Price_Books__c pb, Boolean fl){
            this.priceBook = pb;
            this.selected = false;
            this.flag = fl;
        }
        
        public priceBookWrapper(Price_Books__c pb,Standard_Price__c sp,String productName){
            this.priceBook = pb;
            this.stdPrice = sp;
            this.product = productName;
            this.selected = true;
            
        }
    }
}