trigger trgComponentRepair on Repair__c (before Insert) {

if(Trigger.new.size()==1)
{
    Repair__c Repair = Trigger.new[0];
    
    InventoryUpdate InvUpd = new InventoryUpdate();
    
    String ProdName = '';
    String ProdCode = '';
    
    Set<Id> ProdSet = new Set<Id>();
    Map<Id, Double> QtyMap = new Map<Id, Double>();
    If(Repair.Item_Repaired_1__c!=Null && Repair.Quantity_1__c!=Null){
        ProdSet.add(Repair.Item_Repaired_1__c);
        QtyMap.put(Repair.Item_Repaired_1__c, Repair.Quantity_1__c);} 
    If(Repair.Item_Repaired_2__c!=Null && Repair.Quantity_2__c!=Null){
        ProdSet.add(Repair.Item_Repaired_2__c);
        QtyMap.put(Repair.Item_Repaired_2__c, Repair.Quantity_2__c);}
    If(Repair.Item_Repaired_3__c!=Null && Repair.Quantity_3__c!=Null){
        ProdSet.add(Repair.Item_Repaired_3__c);
        QtyMap.put(Repair.Item_Repaired_3__c, Repair.Quantity_3__c);}
    If(Repair.Item_Repaired_4__c!=Null && Repair.Quantity_4__c!=Null){
        ProdSet.add(Repair.Item_Repaired_4__c);
        QtyMap.put(Repair.Item_Repaired_4__c, Repair.Quantity_4__c);}
        
    if(Trigger.IsInsert)
    {    
        Product__c[] Products = [SELECT Id, Name, Product_Code__c FROM Product__c where Id in :ProdSet];
        
        for(Product__c Prod : Products)
        {
            ProdName = prod.Name;
            ProdCode = Prod.Product_Code__c;
    
            InvUpd.RepairbyOwner(ProdName, Prodcode, Repair.OwnerId, QtyMap.get(Prod.Id));
        }
    }        


}

}