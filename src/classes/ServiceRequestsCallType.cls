public class ServiceRequestsCallType 
{
    private final ApexPages.StandardController theController; 
    
    public ServiceRequestsCallType(ApexPages.StandardController controller) 
    {
        theController = controller;
    }
    private String rtID;
    private String entVal;
    String prefix = Schema.SObjectType.Partner_Service_Request__c.getKeyPrefix(); 
    public ServiceRequestsCallType() 
    {
        
    }
   
    Public pagereference goToMarketingMaterialPage()
    {
        rtID = ApexPages.currentPage().getParameters().get('RecordType');
        entVal = ApexPages.currentPage().getParameters().get('ent');
        PageReference p1;
        
        //Querying the record type
        RecordType serReqsRecordType = [Select Id,Name from RecordType Where Id = : rtID limit 1];

        
        if(serReqsRecordType.Name == 'Marketing Material Request')
        {            
            p1=new PageReference('/apex/PartnerRequestPage?retURL=%2F'+prefix+'%2Fo&RecordType='+rtID+'&ent='+entVal);
            return p1;         
        }       
        else 
        {
            p1=new PageReference('/'+prefix+'/e?nooverride=1&retURL=%2F'+prefix+'%2Fo&RecordType='+rtID+'&ent='+entVal);
        }
        return p1;
            //https://tapp0.salesforce.com/a0P/e?retURL=%2Fa0P%2Fo&ent=01IT0000000975P
    }
}