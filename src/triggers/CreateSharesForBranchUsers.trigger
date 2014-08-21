trigger CreateSharesForBranchUsers on Stock_Point__c (after insert, after update) {
    
    Boolean isServiceCenter = false;
    Set<Id> branchSpIds = new Set<Id>();
    Set<Id> oldBranchSpIds = new Set<Id>();
    
    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Stock_Point__c.getRecordTypeInfosByName();
    String scRecId = rtMapByName.get('Service Center').getRecordTypeId();
    String brnchRecId = rtMapByName.get('Branch').getRecordTypeId();
    
    Map<Id, Id> mapBrnchOldOwner = new Map<Id, Id>();
    Map<Id, Id> mapBrnchNewOwner = new Map<Id, Id>();
    
    for(Stock_Point__c sp :trigger.new) {
        if(sp.RecordTypeId == scRecId) {
            isServiceCenter = true;
            if(Trigger.isInsert)
                branchSpIds.add(sp.Related_To_Branch__c);
            if(Trigger.isUpdate) {
                Stock_Point__c spOld = System.trigger.oldMap.get(sp.id);
                if(sp.Related_To_Branch__c != spOld.Related_To_Branch__c) {
                    branchSpIds.add(sp.Related_To_Branch__c);
                    oldBranchSpIds.add(spOld.Related_To_Branch__c);
                }
                if(sp.OwnerId != spOld.OwnerId) {
                    branchSpIds.add(sp.Related_To_Branch__c);
                }
            }
        } else if(sp.RecordTypeId == brnchRecId) {
            if(Trigger.isUpdate) {
                Stock_Point__c spOld = System.trigger.oldMap.get(sp.id);
                if(sp.OwnerId != spOld.OwnerId) {
                    mapBrnchOldOwner.put(sp.id, spOld.OwnerId);
                    mapBrnchNewOwner.put(sp.id, sp.OwnerId);
                }
            }
        }
    }
    
    if(isServiceCenter) {
        Map<Id, Stock_Point__c> mapBranchOwner = new Map<Id, Stock_Point__c>([select OwnerId 
                                                    from Stock_Point__c where id in :branchSpIds]);
                                                    
        List<Stock_Point__c> oldBranchList;
        if(oldBranchSpIds != null && oldBranchSpIds.size() > 0)
            oldBranchList = new List<Stock_Point__c>([select OwnerId from Stock_Point__c where id in :oldBranchSpIds]);
        
        Map<Id, Id> mapBranchOwnerOld = new Map<Id, Id>();
        if(oldBranchList != null && oldBranchList.size() > 0) {
            for(Stock_Point__c sp :oldBranchList) {
                mapBranchOwnerOld.put(sp.id, sp.OwnerId);
            }
        }
        
        List<Stock_Point__share> spSharesToCreate = new List<Stock_Point__share>();
        for(Stock_Point__c sp :trigger.new) {
            if(Trigger.isUpdate) {
                Stock_Point__c spOld = System.trigger.oldMap.get(sp.id);
                if(mapBranchOwnerOld != null && mapBranchOwnerOld.containsKey(spOld.Related_To_Branch__c)) {
                    Id ownrId = mapBranchOwnerOld.get(spOld.Related_To_Branch__c);
                    mapBranchOwnerOld.put(sp.id, ownrId);
                    mapBranchOwnerOld.remove(sp.Related_To_Branch__c);
                }
            }
            
            if(mapBranchOwner != null && mapBranchOwner.containsKey(sp.Related_To_Branch__c)) {
                Stock_Point__share spShare = new Stock_Point__share(
                    ParentId = sp.id,
                    UserOrGroupId = mapBranchOwner.get(sp.Related_To_Branch__c).OwnerId,
                    AccessLevel = 'Read'
                );
                spSharesToCreate.add(spShare);
            }
        }
        System.debug('--mapBranchOwnerOld----' + mapBranchOwnerOld);
        List<Stock_Point__share> spSharesToDelete = [select id from Stock_Point__share 
                                        where ParentId in :mapBranchOwnerOld.keySet() 
                                        and UserOrGroupId in :mapBranchOwnerOld.values()
                                        and RowCause = 'Manual'];
        
        if(spSharesToDelete != null && spSharesToDelete.size() > 0)                                
            delete spSharesToDelete;
        if(spSharesToCreate != null && spSharesToCreate.size() > 0)
            insert spSharesToCreate;
    
    } else {
        
        // In case of Branch
        List<Stock_Point__c> stkPntList = [select Related_To_Branch__c from Stock_Point__c 
                        where Related_To_Branch__c in :mapBrnchNewOwner.keySet()];
                        
        Set<Id> spId = new Set<Id>();
        List<Stock_Point__share> sharesToCreate = new List<Stock_Point__share>();
        
        for(Stock_Point__c sp :stkPntList) {
            spId.add(sp.id);
            if(mapBrnchNewOwner != null && mapBrnchNewOwner.containsKey(sp.Related_To_Branch__c)) {
                Stock_Point__share spShare = new Stock_Point__share(
                    ParentId = sp.id,
                    UserOrGroupId = mapBrnchNewOwner.get(sp.Related_To_Branch__c),
                    AccessLevel = 'Read'
                );
                sharesToCreate.add(spShare);
            }
        }
        
        List<Stock_Point__share> sharesToDelete = [select id from Stock_Point__share 
                                        where ParentId in :spId 
                                        and UserOrGroupId in :mapBrnchOldOwner.values()
                                        and RowCause = 'Manual'];
                                        
        if(sharesToDelete != null && sharesToDelete.size() > 0)                                
            delete sharesToDelete;
        if(sharesToCreate != null && sharesToCreate.size() > 0)
            insert sharesToCreate;
            
    }
}