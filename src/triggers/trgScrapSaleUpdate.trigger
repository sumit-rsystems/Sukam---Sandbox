trigger trgScrapSaleUpdate on Scrap_del__c (before Insert, before Update) {

If(Trigger.new.size()==1)
{
    boolean flag = false;
    
    if(Trigger.Isinsert)
        if(Trigger.new[0].Scrap_Approval_Status__c == 'Approved')
            flag = true;
    
    If(Trigger.isUpdate)
        if(Trigger.old[0].Scrap_Approval_Status__c != 'Approved' && Trigger.new[0].Scrap_Approval_Status__c == 'Approved')
            flag = true;
    
    
    Scrap_del__c Scrap = Trigger.new[0];

    InventoryUpdate InvUpd = new InventoryUpdate();
    
    String ProdName = '';
    String ProdCode = '';
    
    Set<Id> ProdSet = new Set<Id>();
    Map<Id, Double> QtyMap = new Map<Id, Double>();
    If(Scrap.Select_Item_1__c!=Null && Scrap.Quantity_1__c!=Null)
    {
        if(QtyMap.containsKey(Scrap.Select_Item_1__c))
        {
          trigger.new[0].addError('You added duplicate product.');
        }
        ProdSet.add(Scrap.Select_Item_1__c);
        QtyMap.put(Scrap.Select_Item_1__c, Scrap.Quantity_1__c);
    } 
    If(Scrap.Select_Item_2__c!=Null && Scrap.Quantity_2__c!=Null)
    {
        if(QtyMap.containsKey(Scrap.Select_Item_2__c))
        {
          trigger.new[0].addError('You added duplicate product.');
        }
        ProdSet.add(Scrap.Select_Item_2__c);
        QtyMap.put(Scrap.Select_Item_2__c, Scrap.Quantity_2__c);
    }
    If(Scrap.Select_Item_3__c!=Null && Scrap.Quantity_3__c!=Null)
    {
        if(QtyMap.containsKey(Scrap.Select_Item_3__c))
        {
          trigger.new[0].addError('You added duplicate product.');
        }
        ProdSet.add(Scrap.Select_Item_3__c);
        QtyMap.put(Scrap.Select_Item_3__c, Scrap.Quantity_3__c);
    }
    If(Scrap.Select_Item_4__c!=Null && Scrap.Quantity_4__c!=Null)
    {
        if(QtyMap.containsKey(Scrap.Select_Item_4__c))
        {
          trigger.new[0].addError('You added duplicate product.');
        }
        ProdSet.add(Scrap.Select_Item_4__c);
        QtyMap.put(Scrap.Select_Item_4__c, Scrap.Quantity_4__c);
    }
    
    if(flag==true)
    {     
        Product__c[] Products = [SELECT Id, Name, Product_Code__c FROM Product__c where Id in :ProdSet];
        
        for(Product__c Prod : Products)
        {
        ProdName = prod.Name;
        ProdCode = Prod.Product_Code__c;

        InvUpd.ScrapSalebyOwner(ProdName, Prodcode, Scrap.OwnerId, QtyMap.get(Prod.Id));
        }
                
    }
    Else if(Trigger.isInsert)
    {
        Product__c[] Products = [SELECT Id, Name, Product_Code__c FROM Product__c where Id in :ProdSet];
        
        for(Product__c Prod : Products)
        {
        ProdName = prod.Name;
        ProdCode = Prod.Product_Code__c;

        InvUpd.CheckScrapStockAvailability(ProdName, Prodcode, Scrap.OwnerId, QtyMap.get(Prod.Id));
        }
    }
}

}