public class ComponentMovementLineItemTriggerUtil {
    
    public static void populateSalesPrice(List<Component_Movement_line_Item__c> cmtliList) {
        
        Set<Id> setProductIds = new Set<Id>();
        for(Component_Movement_line_Item__c cmtli :cmtliList) {
            setProductIds.add(cmtli.Select_Component__c);
        }
        
        List<Price_Book_Entry__c> pbeList = [select Product__c, Price_Book__r.Name, UnitPrice__c 
                         from Price_Book_Entry__c where Product__c = :setProductIds
                         and Price_Book__r.Name = 'Sale Price'];
        
        Map<Id, Decimal> mapProductPrice = new Map<Id, Decimal>();
        
        for(Price_Book_Entry__c pbe :pbeList) {
            mapProductPrice.put(pbe.Product__c, pbe.UnitPrice__c);
        }
        
        for(Component_Movement_line_Item__c cmtli :cmtliList) {
            if(mapProductPrice != null && mapProductPrice.containsKey(cmtli.Select_Component__c)) {
                cmtli.Stock_Transfer_Price_Unit__c = mapProductPrice.get(cmtli.Select_Component__c);
            }
        }
    }
    
    public static void deductQuantityFromStockPoint(List<Component_Movement_line_Item__c> cmtliList) {
        
        Set<String> productCode = new Set<String>();
        Map<Id, Map<String, Decimal>> mapStkPointProduct = new Map<Id, Map<String, Decimal>>();
        
        for(Component_Movement_line_Item__c cmtli :cmtliList) {
            Id stkPtId = cmtli.Service_Engineer_Assigned__c;
            productCode.add(cmtli.Select_Component_Code__c);
            Decimal quantity = 0;
            Map<String, Decimal> mapProductQuantity = new Map<String, Decimal>();
            
            if(mapStkPointProduct != null && mapStkPointProduct.containsKey(stkPtId)) {
                mapProductQuantity = mapStkPointProduct.get(stkPtId);
                if(mapProductQuantity != null && mapProductQuantity.containsKey(cmtli.Select_Component_Code__c)) {
                    quantity += mapProductQuantity.get(cmtli.Select_Component_Code__c);
                }
            }
            quantity += cmtli.Quantity__c;
            mapProductQuantity.put(cmtli.Select_Component_Code__c, quantity);
            mapStkPointProduct.put(stkPtId, mapProductQuantity);
        }
        System.debug('--productCode--'+ productCode);
        System.debug('--mapStkPointProduct--'+ mapStkPointProduct);
        List<Current_Inventory_Component__c> stockList = [Select Component_Code__c, Usable_Quantity_in_Hand__c, 
                        Defective_Quantity_in_Hand__c, Stock_Point__c 
                        from Current_Inventory_Component__c where Stock_Point__c in :mapStkPointProduct.keySet() 
                        and Component_Code__c in :productCode];
        
        if(stockList == null || stockList.size() == 0)
            trigger.new[0].addError('All component(s) that you are requesting is(are) not available in the Stock Point to complete the transaction');
        
        Map<Id, Map<String, Current_Inventory_Component__c>> mapStkPtProdStock = new Map<Id, Map<String, Current_Inventory_Component__c>>();
        for(Current_Inventory_Component__c stk :stockList) {
            Id stkPtId = stk.Stock_Point__c;
            Current_Inventory_Component__c stkRecord = new Current_Inventory_Component__c();
            Map<String, Current_Inventory_Component__c> mapProductStock = new Map<String, Current_Inventory_Component__c>();
            
            if(mapStkPtProdStock != null && mapStkPtProdStock.containsKey(stkPtId)) {
                mapProductStock = mapStkPtProdStock.get(stkPtId);
                if(mapProductStock != null && mapProductStock.containsKey(stk.Component_Code__c)) {
                    stkRecord = mapProductStock.get(stk.Component_Code__c);
                }
            }
            stkRecord = stk;
            mapProductStock.put(stk.Component_Code__c, stkRecord);
            mapStkPtProdStock.put(stkPtId, mapProductStock);
        }
                            
        for(Id stkid :mapStkPointProduct.keySet()) {
            Map<String, Decimal> mapProdQtyTemp = new Map<String, Decimal>();
            mapProdQtyTemp = mapStkPointProduct.get(stkid);
            for(String prod :mapProdQtyTemp.keySet()) {
                if(mapStkPtProdStock != null && mapStkPtProdStock.containsKey(stkid)) {
                    Map<String, Current_Inventory_Component__c> mapProdStkTemp = new Map<String, Current_Inventory_Component__c>();
                    mapProdStkTemp = mapStkPtProdStock.get(stkid);
                    if(mapProdStkTemp != null && mapProdStkTemp.containsKey(prod)) {
                        Current_Inventory_Component__c stk = mapProdStkTemp.get(prod);
                        Decimal qty = mapProdQtyTemp.get(prod);
                        if(stk.Usable_Quantity_in_Hand__c != null && stk.Usable_Quantity_in_Hand__c >= qty) {
                            stk.Usable_Quantity_in_Hand__c = stk.Usable_Quantity_in_Hand__c - qty;
                        } else {
                            trigger.new[0].addError('Insuffecient Usable quantity  for ' + prod + ' in the Stock Point to complete the transaction');
                        }
                    } else {
                        trigger.new[0].addError('The component '+ prod +' is not available in the Stock Point to complete the transaction');
                    }
                } else {
                    trigger.new[0].addError('Component is not available in stock point.');
                }
            }
        }
        
        try {
            if(stockList != null && stockList.size() > 0)
                update stockList;
        } catch(Exception e) {
            trigger.new[0].addError(e.getMessage());
        }
    }
    
    public static void populateVatOnLineItem(List<Component_Movement_line_Item__c> cmtliList) {
        User loggedInUser = [select State from User where id = :UserInfo.getUserId()];
    
        Set<String> setCategory = new Set<String>();
        for(Component_Movement_line_Item__c cmtli :cmtliList) {
            setCategory.add(cmtli.Product_Category__c);
        }
        
        List<VAT1__c> vatList = [select VAT_Percentage__c, Product_Category__c from VAT1__c 
                        where State__c = :loggedInUser.State and Product_Category__c in :setCategory];
        
        Map<String, Decimal> mapCategoryVat = new Map<String, Decimal>();
        
        for(VAT1__c vat :vatList) {
            mapCategoryVat.put(vat.Product_Category__c, vat.VAT_Percentage__c);
        }
        
        for(Component_Movement_line_Item__c cmtli :cmtliList) {
            if(mapCategoryVat != null && mapCategoryVat.containsKey(cmtli.Product_Category__c)) {
                cmtli.VAT_Percent__c = mapCategoryVat.get(cmtli.Product_Category__c);
            }
        }
    }
}