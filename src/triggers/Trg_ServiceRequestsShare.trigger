/* Created By : Saranya.S.R
 *  Created On : April 05,2010
 *  Purpose    : To share the service requests records with specific users based on their record type                
*/

trigger Trg_ServiceRequestsShare on Partner_Service_Request__c (after insert, after update) 
{
    List<String> listOfSerReqRecTypeIds = new List<String>();
    List<Partner_Service_Request__Share> listOfSerReqShare = new List<Partner_Service_Request__Share>();
    Map<String,String> mapOfSerReqIdAndRecType = new Map<String,String>();
    Map<String,String> mapOfRecTypeIdAndName = new Map<String,String>();
    Map<String,String> mapOfGrpNameAndId = new Map<String,String>();
    
    //Adding all record type Id's to a list
    for(Partner_Service_Request__c serReq : Trigger.new)
    {
        listOfSerReqRecTypeIds.add(serReq.RecordTypeId);
    }
    
    //Creating map of record type Id's and Name
    for(RecordType rt : [Select Id,Name From RecordType Where Id in : listOfSerReqRecTypeIds])
    {
        mapOfRecTypeIdAndName.put(rt.Id,rt.Name);
    }
    
    //Creating map of group name and group Id's
    for(Group grp : [Select CreatedDate, Id, Name from Group where Name = : 'Finance' OR Name = :  'Service' Or Name = :  'Marketing'])
    {
        mapOfGrpNameAndId.put(grp.Name,grp.Id);
    }
    
    //Iterating over trigger.new,assigning service request records to the share table with the group corresponding to the record type
    for(Partner_Service_Request__c serReq : Trigger.new)
    {
        //Taking record type name from the map
        String recTypeName = mapOfRecTypeIdAndName.get(serReq.RecordTypeId);
        
        //Inserting a record in the share table with group 'Finance' for 'Financial Service Request' record types
        if(recTypeName == 'Financial Service Request')
        {
            Partner_Service_Request__Share serReqShare = new Partner_Service_Request__Share();
            
            serReqShare.AccessLevel = 'Edit';
            serReqShare.UserOrGroupId = mapOfGrpNameAndId.get('Finance');
            serReqShare.ParentId = serReq.Id;
            listOfSerReqShare.add(serReqShare);
        }
        
        //Inserting a record in the share table with group 'Marketing' for 'Marketing Material Request' record types
        if(recTypeName == 'Marketing Material Request')
        {
            Partner_Service_Request__Share serReqShare = new Partner_Service_Request__Share();
            
            serReqShare.AccessLevel = 'Edit';
            serReqShare.UserOrGroupId = mapOfGrpNameAndId.get('Marketing');
            serReqShare.ParentId = serReq.Id;
            listOfSerReqShare.add(serReqShare);
        }
        
        //Inserting a record in the share table with group 'Service' for 'General Complaints' and 'Product Complaints'record types
        if(recTypeName == 'General Information / Complaints' || recTypeName == 'Product Complaint')
        {
            Partner_Service_Request__Share serReqShare = new Partner_Service_Request__Share();
            
            serReqShare.AccessLevel = 'Edit';
            serReqShare.UserOrGroupId = mapOfGrpNameAndId.get('Service');
            serReqShare.ParentId = serReq.Id;
            listOfSerReqShare.add(serReqShare);
        }
    }
    
    if(listOfSerReqShare.size() > 0)
        insert listOfSerReqShare;
}