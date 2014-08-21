public with sharing class PartnerRequestController 
{   
    public class ReqDetail 
    {
        public String Id {get; set;}
        public String name {get; set;}
        public String mmId {get; set;}
        public String mmName {get; set;}
        public String language {get; set;}
        public String size {get; set;}
        public String description {get; set;}
        public String contents {get; set;}
        public String dcArea {get; set;}
        public String dcDistrict {get; set;}
        public String dcPhone {get; set;}
        public String dcProduct {get; set;}
        public String board {get; set;}
        public Double quantity {get; set;}
        public String remarks {get; set;}
        public Double apprQty {get; set;}
        public String apprRemarks {get; set;}
        public String parentId {get; set;}
        public String docId {get; set; }
        public String thumbId {get; set; }

        public ReqDetail(){}
    }
    
    public class PartnerRequest
    {
        public String Id {get; set;}
        public String name {get; set;}
        public String mmType {get; set;} 
        public String mmStatus {get; set;} 
        public List<ReqDetail> details {get; set;}
        
        public PartnerRequest(){} 
    } 
    
    public String req{get; set;}

    private String mmType = '';
    private String mode = '';
    private String rtID = '';
    private String prId = '';
    private String displayType = '';
    
    private List<ReqDetail> reqDetails = new List<ReqDetail>();
    private List<PartnerRequest> partnerReqs = new List<PartnerRequest>();
    private Partner_Service_Request__c partnerRequest = new Partner_Service_Request__c();
    
    String prefix = Schema.SObjectType.Partner_Service_Request__c.getKeyPrefix(); 
    
    //private List<Selectoption> boards = new List<Selectoption>();   

    public PartnerRequestController()
    {
        //account = [select id, name, site from Account where id =:ApexPages.currentPage().getParameters().get('id')];
        mode = ApexPages.currentPage().getParameters().get('mode');
        rtID = ApexPages.currentPage().getParameters().get('RecordType');
        system.debug('rtID ################# : '+ rtID);
         system.debug('mode ################# : '+ mode);
        //String userTyp = UserInfo.getUserType();
        //if(userTyp == 'Partner' && mode == 'EDIT')
            //mode = 'VIEW';
        if (mode==null) 
            mode='SELECT';
        
        //List<Board__c> dbBoards = [Select id, name from Board__c];
        
        //for(Board__c dbBoard:dbBoards)
        //{
        //    boards.add(new Selectoption(dbBoard.id, dbBoard.name));
        //}
        
        /*if (mode.equals('VIEW'))
        {
            List<Partner_Service_Request__c> requests = new List<Partner_Service_Request__c>(); 
            requests = [Select Id, Name, Type_Of_Request__c from Partner_Service_Request__c limit 1000];
            
            for(Partner_Service_Request__c request:requests)
            {
                PartnerRequest mmRequest = new PartnerRequest();
                mmRequest.id = request.id;
                mmRequest.name = request.name;
                mmRequest.mmType = request.Type_Of_Request__c;
                partnerReqs.add(mmRequest);
            }
        }
        else */
        if (mode.equals('NEW'))
        {
            mmType = ApexPages.currentPage().getParameters().get('reqType');
            if (mmType.equals('DealerCertificate'))
            {
                for (Integer i=1; i<=5; i++)
                {
                    ReqDetail reqDetail = new ReqDetail();
                    reqDetail.mmName = '';
                    reqDetail.language = '';
                    reqDetail.size = '';
                    reqDetail.description = '';
                    reqDetail.contents = '';
                    reqDetail.dcArea = '';
                    reqDetail.dcDistrict = '';
                    reqDetail.dcPhone = '';
                    reqDetail.dcProduct = '';
                    reqDetail.board = '';
                    reqDetail.quantity = 0;
                    reqDetail.remarks = '';
                    reqDetail.apprQty = 0;
                    reqDetail.apprRemarks = '';
                    reqDetails.add(reqDetail);
                }
            }
            else 
            {
                List<Marketing_Material__c> mms = [Select id, Name, Description__c, Contents__c, Language__c, Size__c,Thumbnail_Id__c ,Document_Id__c from Marketing_Material__c where Type__c=:mmType limit 1000];
                for (Marketing_Material__c mm : mms)
                {
                    ReqDetail reqDetail = new ReqDetail();
                    reqDetail.mmId = mm.id;
                    reqDetail.mmName = mm.Name;
                    reqDetail.description = mm.Description__c;
                    reqDetail.contents = mm.Contents__c;
                    reqdetail.docId = mm.Document_Id__c;
                    reqDetail.language = mm.Language__c;
                    reqdetail.thumbId = mm.Thumbnail_Id__c;
                    reqDetail.size = mm.Size__c;
                    reqDetail.dcArea = '';
                    reqDetail.dcDistrict = '';
                    reqDetail.dcPhone = '';
                    reqDetail.dcProduct = '';
                    reqDetail.board = mm.Name;
                    reqDetail.quantity = 0;
                    reqDetail.remarks = '';
                    reqDetail.apprQty = 0;
                    reqDetail.apprRemarks = '';
                    reqDetails.add(reqDetail);
                }
            }
        }
        else if (mode.equals('EDIT') || mode.equals('VIEW'))
        {
            prId = ApexPages.currentPage().getParameters().get('prId');
            partnerRequest = [Select Id, Name, Type_Of_Request__c, 
                                (Select Marketing_Material_Name__c, Dealer_Area__c, Dealer_District__c, Dealer_Name__c, Quantity__c, Remarks__c, Approved_Quantity__c, Approver_Remarks__c from MM_Request_Details__r) 
                             from Partner_Service_Request__c where id=:prId ];
            mmType = partnerRequest.Type_Of_Request__c;
            for(MM_Request_Details__c prDetail:partnerRequest.MM_Request_Details__r)
            {
                ReqDetail reqDetail = new ReqDetail();
                reqDetail.Id = prDetail.Id;
                reqDetail.parentId = partnerRequest.Id;
                //Board__c board = [Select name from Board__c where id=:prDetail.Board__c];
                //reqDetail.board = board.name;
                //reqDetail.size = prDetail.Board_Size__c;
                reqDetail.mmName = prDetail.Dealer_Name__c;
                reqDetail.dcArea = prDetail.Dealer_Area__c;
                reqDetail.dcDistrict = prDetail.Dealer_District__c;
                //reqDetail.dcPhone = prDetail.DC_Phone__c;
                //reqDetail.dcProduct = prDetail.DC_Product__c;
                reqDetail.quantity = prDetail.quantity__c;
                reqDetail.remarks = prDetail.remarks__c;
                reqDetail.apprQty = prDetail.approved_quantity__c;
                reqDetail.apprRemarks = prDetail.approver_remarks__c;
                
                if (!mmType.equals('DealerCertificate') /*&& !mmType.equals('Board')*/)
                {   
                    List<Marketing_Material__c> temp = new List<Marketing_Material__c>();
                    temp =[Select name, language__c, size__c,  Thumbnail_Id__c, Document_Id__c, description__c, contents__c, type__c from Marketing_Material__c where id=:prDetail.Marketing_Material_Name__c limit 1];
                    if(temp != null && temp.size() > 0){
                    
                        Marketing_Material__c mm= new  Marketing_Material__c(); 
                        mm = temp[0]; 
                        reqDetail.mmId = mm.Id;
                        reqDetail.mmName = mm.name;
                        reqDetail.language = mm.Language__c;
                        reqDetail.size = mm.Size__c;
                        reqDetail.description = mm.Description__c;
                        reqDetail.contents = mm.Contents__c;
                        reqdetail.docId = mm.Document_Id__c;
                        reqdetail.thumbId = mm.Thumbnail_Id__c;
                    }
                }
                reqDetails.add(reqDetail);
            }
        }
        displayType = mmType;
        if(displayType != null)
        {
            if (!displayType.equals('PoP-CD') && !displayType.equals('PoP-Brochure')&& displayType.startsWith('PoP-')) 
                displayType='PoP';
        }
    }
    
    public String getMmType()
    {
        return mmType;
    }    
    
    public String getDisplayType()
    {
        return displayType;
    }
    
    public String getMode()
    {
        return mode;
    }  

    public void setMode(String mode)
    {
        this.mode = mode;
    } 
    
    public String getPrId()
    {
        return prId;
    }   
    
    /*public List<Selectoption> getBoards()
    {
        return boards;
    }*/

    public Partner_Service_Request__c getPartnerRequest()
    {
        return partnerRequest;
    }   

    public List<ReqDetail> getReqDetails()
    {
        return reqDetails;
    }

    public void setReqDetails(List<ReqDetail> reqDetails)
    {
        this.reqDetails = reqDetails;
    }

    public List<PartnerRequest> getPartnerReqs()
    {
        return partnerReqs;
    }

    public void setPartnerReqs(List<PartnerRequest> partnerReqs)
    {
        this.partnerReqs = partnerReqs;
    }

    public PageReference save() 
    {
        partnerRequest.Remarks__c = '-';
        if (mode.equals('NEW'))
        {
            partnerRequest.RecordTypeId = rtID;
            partnerRequest.Type_Of_Request__c = mmType;
            partnerRequest.Status__c = 'Open';
        }
        
        List<MM_Request_Details__c> requests = new List<MM_Request_Details__c>(); 
        
        for (ReqDetail reqDetail : reqDetails)
        {
            system.debug('mmType>>>'+mmType);
            system.debug('reqDetail>>>'+reqDetail);
            
            if (mmType.equals('DealerCertificate') && reqDetail.mmName.length()==0) 
                continue;
                
            if (!(mmType.equals('DealerCertificate')) && reqDetail.quantity == 0) 
                continue;
                            
            /*if (!(mmType.equals('DealerCertificate')) && reqDetail.quantity > 999)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Quantity must be less than 1000'));                      
                return new pageReference('/apex/PartnerRequestPage');
                break;
            }*/
            MM_Request_Details__c request = new MM_Request_Details__c();
            
            if (mode.equals('NEW'))
            {
                try{
                    Database.upsert(partnerRequest);
                }
                catch(DmlException ee)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ee.getDmlMessage(0)));                                  
                    return null;
                }
                request.Marketing_Material_Name__c = reqDetail.mmId;
                request.Dealer_Name__c = reqDetail.mmName;
                request.Dealer_District__c = reqDetail.dcDistrict;
                request.Dealer_Area__c = reqDetail.dcArea;
                //request.DC_Phone__c = reqDetail.dcPhone;
                //request.DC_Product__c = reqDetail.dcProduct;
                //request.Board__c = reqDetail.board;
                //request.Board_Size__c = reqDetail.size;
                request.Quantity__c = reqDetail.quantity;
                //request.Remarks__c = reqDetail.remarks;
                request.Service_Requests__c = partnerRequest.Id;
                //request.Status__c = 'NEW';
                request.Remarks__c = '-';

            }
            else if (mode.equals('EDIT')) 
            {
                request = new MM_Request_Details__c(Id=reqDetail.Id);
                request.Approved_Quantity__c = reqDetail.apprQty;
                request.Approver_Remarks__c = reqDetail.apprRemarks;
                //request.Status__c = 'APPROVED';
                request.Remarks__c = '-';
            }
            requests.add(request);
        }
        system.debug('requests>>>'+requests);
        try{
            Database.upsert(requests);
            
            system.debug('requests>>>'+requests);
            String pageURL = '/' + partnerRequest.Id;
            //pageURl = pageURL.substring(0, pageURL.indexOf('?'));
            Pagereference page = new Pagereference(pageURL);
            page.setRedirect(true);
            return page;
        }
        
        catch(DmlException ee)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ee.getDmlMessage(0)));                                  
            return null;
        }
        
    }
    
    public pageReference cancel()
    {
        PageReference pageRef = new PageReference('/'+prefix+'/o');             
        return pageRef;
    }
    
    public pageReference cancelEdit()
    {
        PageReference pageRef = new PageReference('/'+prId);             
        return pageRef;
    }
    public pageReference addRows(){
        for (Integer i=1; i<=5; i++)
        {
            ReqDetail reqDetail = new ReqDetail();
            reqDetail.mmName = '';
            reqDetail.language = '';
            reqDetail.size = '';
            reqDetail.description = '';
            reqDetail.contents = '';
            reqDetail.dcArea = '';
            reqDetail.dcDistrict = '';
            reqDetail.dcPhone = '';
            reqDetail.dcProduct = '';
            reqDetail.board = '';
            reqDetail.quantity = 0;
            reqDetail.remarks = '';
            reqDetail.apprQty = 0;
            reqDetail.apprRemarks = '';
            reqDetails.add(reqDetail);
        }
        return null;
    }
    
}