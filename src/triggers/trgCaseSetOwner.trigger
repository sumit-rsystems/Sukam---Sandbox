/**
* 
*  To set the owner for the case based on the Service Center City selected.
* 
*  Author              |Author-Email                             |Date        |Comment
*  --------------------|---------------------------------------- |------------|----------------------------------------------------
*  Balaji Prabhakaran  |balaji.prabakaran@listertechnologies.com |06.30.2010  |First Draft
* 
*/

trigger trgCaseSetOwner on Service_Request__c (before insert, before update) {

    //List of ServiceCenterCity Ids
    List<Id> list_ServiceCenterCityId = new List<Id>();
    for (Service_Request__c oCase : Trigger.new){
        if (oCase.Service_Centre_City__c != null)
            list_ServiceCenterCityId.add(oCase.Service_Centre_City__c);
    }

    //Map of ServiceCenterCity Id and the respective User
    Map<Id, Id> map_ServiceCenterCityId_UserId = new Map<Id, Id>();
    for (Service_Centre_City__c scc : [Select Id, Service_Centre_Name__c From Service_Centre_City__c Where Id in :list_ServiceCenterCityId]){
        map_ServiceCenterCityId_UserId.put(scc.Id, scc.Service_Centre_Name__c);
    }

    //To Set the Owner based on the Service Center City selected for each case.
    for (Service_Request__c oCase : Trigger.new){
        if (oCase.Service_Centre_City__c != null){
            Id userId = map_ServiceCenterCityId_UserId.get(oCase.Service_Centre_City__c);
            oCase.OwnerId = userid; 
        }
    }
}