trigger CreateStandardPrice on Price_Book_Entry__c (after insert, after update) {
    
    
    Map<Id, Price_Book_Entry__c> mapPbe = new Map<Id, Price_Book_Entry__c>([select Conversion_Rate__c, IsActive__c, 
                                        Product__c, UnitPrice__c, CurrencyIsoCode,Price_Book__r.Tax__c from Price_Book_Entry__c where 
                                        id in :trigger.new and Price_Book__r.IsStandard__c = true]);
    
    List<Standard_Price__c> stdPrice = [select Active__c, Conversion_Rate__c, Price_Book_Entry__c, Products__c,
                                        Standard_Price__c, CurrencyIsoCode from Standard_Price__c
                                        where Price_Book_Entry__c in :mapPbe.keySet()];

    
    //system.debug('+++stdPrice '+trigger.new);

    /*//if standard price is not available then update tax in original price book
     List<Price_Book_Entry__c> lstP = new List<Price_Book_Entry__c >();
     if(stdPrice.size()==0)
     {
        for(Price_Book_Entry__c obj : mapPbe.values())
        {
          Price_Book_Entry__c ob = new Price_Book_Entry__c(id=obj.id);
          system.debug('+++priceeee'+obj.UnitPrice__c + (obj.UnitPrice__c * .7) * obj.Price_Book__r.Tax__c/100);
          ob.UnitPrice__c = obj.UnitPrice__c + (obj.UnitPrice__c * .7) * obj.Price_Book__r.Tax__c/100;
          lstP.add(ob);
        } 
     }
     system.debug('+++lstP'+lstP);
     update lstP;*/

    
    for(Standard_Price__c sp :stdPrice) {
        Price_Book_Entry__c pbe = mapPbe.get(sp.Price_Book_Entry__c);
        //system.debug('+++PriceB+++'+pbe.Price_Book__r.Tax__c);
        
        sp.Active__c = pbe.isActive__c;
        sp.Conversion_Rate__c = pbe.Conversion_Rate__c;
        
        //Calculate Tax on Product
        sp.Standard_Price__c = pbe.UnitPrice__c + (pbe.UnitPrice__c * .7) * pbe.Price_Book__r.Tax__c/100;
        //system.debug('+++sp+++'+sp.Standard_Price__c);
        
        //sp.Standard_Price__c = pbe.UnitPrice__c;
        mapPbe.remove(sp.Price_Book_Entry__c);
    }
    
    
    
    
    for(Id pid :mapPbe.keySet()) {
        Price_Book_Entry__c pbe = mapPbe.get(pid);
        Standard_Price__c sp = new Standard_Price__c(
            Active__c = pbe.isActive__c,
            Conversion_Rate__c = pbe.Conversion_Rate__c,
            Standard_Price__c = pbe.UnitPrice__c,
            Products__c = pbe.Product__c,
            Price_Book_Entry__c = pid,
            CurrencyIsoCode  = pbe.CurrencyIsoCode 
        );
        
        system.debug('+++sp2+++'+sp.Standard_Price__c);
        stdPrice.add(sp);
    }
    
    if(stdPrice != null && stdPrice.size() > 0)
        upsert stdPrice;
}