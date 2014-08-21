@istest
private class Trg_ServiceRequestsShare_TestClass
{
    static testMethod void test1()
    {
        Map<String,String> rtMap = new Map<String,String>();
        List<RecordType> rtList = new List<RecordType>();
        
        rtList = [Select Id,Name From RecordType Where Name = : 'Financial Service Request' or Name = : 'Marketing Material Request' or Name = : 'General Information / Complaints' or Name = : 'Product Complaint'];
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
        
        Partner_Service_Request__c psr = new Partner_Service_Request__c();
        
        psr.Type_Of_Request__c = 'Bills';
        psr.Status__c = 'Open';
        psr.Remarks__c = 'test';
        psr.RecordTypeId = rtMap.get('Financial Service Request');
        insert psr;
        
        Partner_Service_Request__c psr1 = new Partner_Service_Request__c();
        
        psr1.Type_Of_Request__c = 'PoP-Leaflet';
        psr1.Quantity__c = 1;
        psr1.Remarks__c = 'test';
        psr1.RecordTypeId = rtMap.get('Marketing Material Request');
        insert psr1;
        
        Partner_Service_Request__c psr2 = new Partner_Service_Request__c();      
        
        psr2.Status__c = 'Open';
        psr2.Remarks__c = 'test';
        psr2.RecordTypeId = rtMap.get('General Information / Complaints');
        insert psr2;
        
        Partner_Service_Request__c psr3 = new Partner_Service_Request__c();      
        
        psr3.Status__c = 'Open';
        psr3.Remarks__c = 'test';
        psr3.RecordTypeId = rtMap.get('Product Complaint');
        insert psr3;
    }
}