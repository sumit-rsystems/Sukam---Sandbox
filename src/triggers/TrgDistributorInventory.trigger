trigger TrgDistributorInventory on Order_Despatch__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        
        List<Order_Despatch__c> list_orderDespatch = new List<Order_Despatch__c>();
        List<String> list_erpCode = new List<String>();
        Map<String,Inventory__c> map_inventory = new Map<String,Inventory__c>();
        Set<String> set_erpCodes = new Set<String>();
        Set<String> set_orderLineItemId = new Set<String>();
        Map<String, String> map_mapping = new Map<String, String>();  
        for (Order_Despatch__c oOrderDespatch : Trigger.new) {
            if (oOrderDespatch.Goods_Received__c) {
                list_orderDespatch.add(oOrderDespatch);
                System.debug(oOrderDespatch.ERP_Code__c + 'oOrderDespatch.ERP_Code__c' + oOrderDespatch.Order_Line_Item__r.Order__r.ownerId);
                if (!set_erpCodes.contains(oOrderDespatch.ERP_Code__c)) {
                    list_erpCode.add(oOrderDespatch.ERP_Code__c);
                    set_erpCodes.add(oOrderDespatch.ERP_Code__c);
                    System.debug(oOrderDespatch.Order_Line_Item__c + 'oOrderDespatch.Order_Line_Item__c');
                    set_orderLineItemId.add(oOrderDespatch.Order_Line_Item__c);
                }
                //list_erpCode.add();
            }
        }
        if (set_orderLineItemId != null && set_orderLineItemId.size() > 0) {
            
            for (Order_Line_Item__c oOrderLineItem : [SELECT ID, Order__r.OwnerId 
                                                      FROM Order_Line_Item__c 
                                                      WHERE ID IN :set_orderLineItemId]) {
                System.debug(oOrderLineItem.Id + '=========' + oOrderLineItem.Order__r.OwnerId);                                        
                map_mapping.put(oOrderLineItem.Id, oOrderLineItem.Order__r.OwnerId);                        
            } 
        } 
        
    if (list_orderDespatch.size() > 0 && set_erpCodes.size() > 0) {
            List<Inventory__c> list_updateInventory = new List<Inventory__c>();
            List<Inventory__c> list_createInventory = new List<Inventory__c>();
            for (Inventory__c oInventory : [SELECT Id, ERP_Code__c,Quantity__c, OwnerId  
                                            FROM Inventory__c 
                                            WHERE ERP_Code__c IN: set_erpCodes]) {
                  map_inventory.put(oInventory.ERP_Code__c,oInventory); 
            }
            set_erpCodes = new Set<String>();
            Set<String> set_createErpCodes = new Set<String>();
            Map<String,Inventory__c> map_newinventory = new Map<String,Inventory__c>();
            Map<String,Inventory__c> map_createinventory = new Map<String,Inventory__c>();
            String str_ownerIdNew = '';
            for (Order_Despatch__c oOrderDespatch : list_orderDespatch) {
                String str_ownerId = map_mapping.get(oOrderDespatch.Order_Line_Item__c);
                if (map_inventory.get(oOrderDespatch.ERP_Code__c) != null && map_inventory.get(oOrderDespatch.ERP_Code__c).OwnerId == str_ownerId) {
                    Inventory__c oInventory = null;
                    if (!set_erpCodes.contains(oOrderDespatch.ERP_Code__c)) {
                        set_erpCodes.add(oOrderDespatch.ERP_Code__c);
                        oInventory = map_inventory.get(oOrderDespatch.ERP_Code__c);
                        oInventory.Quantity__c = oInventory.Quantity__c + oOrderDespatch.Despatch_Quantity__c;
                        oInventory.OwnerId = str_ownerId;
                        map_newinventory.put(oOrderDespatch.ERP_Code__c,oInventory);
                        //list_updateInventory.add(oInventory);
                    } else {
                        oInventory = map_newinventory.get(oOrderDespatch.ERP_Code__c);
                        oInventory.Quantity__c = oInventory.Quantity__c + oOrderDespatch.Despatch_Quantity__c;
                        map_newinventory.put(oOrderDespatch.ERP_Code__c,oInventory);
                        //list_updateInventory.add(oInventory);
                    } 
                } else {
                    
                    if (map_createinventory.get(oOrderDespatch.ERP_Code__c + '-' + str_ownerId) == null) {
                        
                        System.debug(oOrderDespatch.ERP_Code__c + '=' + oOrderDespatch.Despatch_Quantity__c + '=' + str_ownerId);  
                        Inventory__c oInventory = new Inventory__c();
                        oInventory.Quantity__c = oOrderDespatch.Despatch_Quantity__c;
                        oInventory.Capacity__c = oOrderDespatch.Capacity__c;
                        oInventory.ERP_Code__c = oOrderDespatch.ERP_Code__c;
                        oInventory.Model__c = oOrderDespatch.Model__c;
                        oInventory.Product_Category__c = oOrderDespatch.Product_Category__c;
                        oInventory.OwnerId = str_ownerId;   
                        map_createinventory.put(oOrderDespatch.ERP_Code__c + '-' + str_ownerId, oInventory);
                        //list_createInventory.add(oInventory);
                    } else {
                        Inventory__c  oInventory = map_createinventory.get(oOrderDespatch.ERP_Code__c + '-' + str_ownerId);
                        Double qty = oInventory.Quantity__c + oOrderDespatch.Despatch_Quantity__c;
                        oInventory.Quantity__c = qty;
                        System.debug(oOrderDespatch.ERP_Code__c + '-' + qty + '-' + str_ownerId);
                        map_createinventory.put(oOrderDespatch.ERP_Code__c + '-' + str_ownerId, oInventory);
                    }
                    
                    
                }
            }
            System.debug('list_updateInventory' + list_updateInventory);
            System.debug('list_createInventory' + list_createInventory);
            Set<String> set_keySet = map_newinventory.keySet();
            for (String key : set_keySet) {
                Inventory__c invObj = (Inventory__c) map_newinventory.get(key);
                list_updateInventory.add(invObj);
            } 
            Set<String> set_createkeySet = map_createinventory.keySet();    
            for (String key : set_createkeySet) {
                Inventory__c invObj = (Inventory__c) map_createinventory.get(key);
                list_createInventory.add(invObj);
            } 

            if (list_updateInventory.size() > 0) update list_updateInventory;
            if (list_createInventory.size() > 0) insert list_createInventory;
        }       
    }

}