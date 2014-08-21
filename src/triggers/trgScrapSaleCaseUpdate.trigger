trigger trgScrapSaleCaseUpdate on Scrap_del__c (before insert) {
    
    ScrapSalesClass.populatePrice(trigger.new);
    ScrapSalesClass.populateVatOrCst(trigger.new);
    
    Scrap_del__c scrpsale = Trigger.new[0];
    
    ScrapSalesClass scrpsaleupd = new ScrapSalesClass();

    scrpsaleupd.ScrapSalesUpdate(scrpsale);


}