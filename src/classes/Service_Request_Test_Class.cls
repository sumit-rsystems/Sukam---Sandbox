@istest
private class Service_Request_Test_Class
{ 
	static Schema.DescribeSObjectResult d = Schema.SObjectType.Partner_Service_Request__c;
	static Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
	static Schema.RecordTypeInfo rtByName =  rtMapByName.get('Marketing Material Request');
	static Id mmrrectypeid = rtByName.getRecordTypeId();
		
    static testMethod void Service_Request_Test()
    {
        ApexPages.StandardController controller2;
        //Querying the record type
        //RecordType servReqsRecordType = [Select Id,Name from RecordType Where sObjectType = 'Partner_Service_Request__c' And Name = 'Marketing Material Request' limit 1];
 
        Marketing_Material__c mm = new Marketing_Material__c();
        mm.Name = 'test Brochure 001';
        mm.Contents__c = 'Contents 001';
        mm.Description__c = 'Description 001';
        mm.Language__c = 'Language 001';
        mm.Size__c = 'Size 001';
        mm.Type__c  = 'Brochure';
        insert mm;
        
        PageReference pageRef = Page.PartnerRequestPage;
        System.debug('=====pageRef ========'+pageRef);
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('mode', 'NEW');
        ApexPages.currentPage().getParameters().put('reqType', 'PoP-Brochure');
        ApexPages.currentPage().getParameters().put('RecordType', mmrrectypeid);
        ApexPages.currentPage().getParameters().put('reqType','Brochure');
        PartnerRequestController prController = new PartnerRequestController();
        
        prController.save();
        
        
        pageRef = Page.PartnerRequestPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('mode', 'NEW');
        ApexPages.currentPage().getParameters().put('reqType', 'DealerCertificate');
        ApexPages.currentPage().getParameters().put('RecordType', mmrrectypeid);
        
        prController = new PartnerRequestController();
        prController.save();
        prController.getPartnerRequest();
        prController.getReqDetails();
        prController.getPartnerReqs();
        
       // Partner_Service_Request__c  psr = [Select Id From Partner_Service_Request__c ];
        Partner_Service_Request__c psr1 = new Partner_Service_Request__c(
            Type_Of_Request__c = 'Bills',
            Status__c = 'open',
            Remarks__c = 'a'
        );
        insert psr1;
        
        MM_Request_Details__c mmObj =  new MM_Request_Details__c(
            Approved_Quantity__c = 1000,
            Service_Requests__c = psr1.id
        );
        insert mmObj;
        
        pageRef = Page.PartnerRequestPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('mode', 'EDIT');
        ApexPages.currentPage().getParameters().put('reqType', 'PoP-Brochure');
        ApexPages.currentPage().getParameters().put('RecordType', mmrrectypeid);
        ApexPages.currentPage().getParameters().put('prId', psr1.Id);
        
        prController = new PartnerRequestController();
        prController.save();
        
        pageRef = Page.PartnerRequestPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('mode', 'EDIT');
        ApexPages.currentPage().getParameters().put('reqType', 'PoP-Brochure');
        ApexPages.currentPage().getParameters().put('RecordType', mmrrectypeid);
        ApexPages.currentPage().getParameters().put('prId', psr1.Id);
        
        //prController = new PartnerRequestController();
        prController.save();
        
        prController.getMode();
        prController.getDisplayType();
      //prController.getMmType();
        prController.getPrId();
        prController.cancel();
        prController.cancelEdit();
        prController.addRows();
        
        PartnerRequestController.ReqDetail reqDet = new PartnerRequestController.ReqDetail();
        PartnerRequestController.PartnerRequest parReq = new PartnerRequestController.PartnerRequest();
        prController.getPartnerRequest();
    }
    
    static testMethod void Service_Request_Call_Type_Test()
    {
        ApexPages.StandardController controller2;
        
        ServiceRequestsCallType srCallTyp2 = new ServiceRequestsCallType(controller2);
        //Querying the record type
        //RecordType servReqsRecordType = [Select Id,Name from RecordType Where sObjectType = 'Partner_Service_Request__c' And Name = 'Marketing Material Request' limit 1];
        
        ServiceRequestsCallType srCalltyp = new ServiceRequestsCallType();
        
        PageReference pageRef = Page.PartnerRequestPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('RecordType', mmrrectypeid);
        
        srCalltyp.goToMarketingMaterialPage();
 
    }
    public static testMethod void getCoverage(){
           Product__c prd = new Product__c(
            Category_Code__c = 'wer',
            Category_Description__c = 'cc',
            Product_Description__c = 'kk',
            name = 'ee'
        );
        insert prd;
        ApexPages.currentPage().getParameters().put('prId',prd.id);
        ApexPages.currentPage().getParameters().put('mode','EDIT');
       
        PartnerRequestController.ReqDetail  objwrp = new PartnerRequestController.ReqDetail();  
        List<PartnerRequestController.PartnerRequest> lstPart ;
       // prController.setReqDetails(lstPart);
    }
}