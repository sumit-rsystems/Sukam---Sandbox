public class IndentRequestController
{

    //Indent indent = new Indent();
    public Indent_Request__c indentRequestObj {get;set;}
    //public Indent_Request_Detail__c indentRequestDetailObj{get;set;}
    public List<Indent_Request_Detail__c> indentRequestDetailList {get; set;}
    public boolean block = false;
    String requestId;
    public Double deletedItem {get; set;}
    List<Indent_Request_Detail__c> detailList;
    public String scName {get; private set;}
    
    public IndentRequestController(ApexPages.StandardController stdcont)
    {
        requestId = ApexPages.currentPage().getParameters().get('id');
        List<Stock_Point__c> spList;
        System.debug('requestIdrequestId' +  requestId);
        if(requestId != '' && requestId != null)
        {
            indentRequestObj = [SELECT Name, 
                                       Requisition_Date__c,
                                       Indent_Request_Status__c,
                                       OwnerId,
                                       Dispatch_Sts__c,
                                       Address__c,
                                       Pincode__c,
                                       Approval_Date__c,
                                       City__c
                                  FROM Indent_Request__c 
                                 WHERE Id = :requestId];
                                 
            spList = [SELECT Name FROM Stock_Point__c WHERE OwnerId =: indentRequestObj.OwnerId LIMIT 1];           
        }
        
        else
        {
            this.indentRequestObj = (Indent_Request__c)stdcont.getRecord();
            requestId = stdcont.getId();
            indentRequestObj.name = createIndentNumber();
            indentRequestObj.Requisition_Date__c = Date.today();
            
            System.debug('indentRequestObj.nameindentRequestObj.name' +  indentRequestObj.name + ' --');
             
            spList = [SELECT Name FROM Stock_Point__c WHERE OwnerId =: UserInfo.getUserId() AND RecordType.Name = 'Service Center' LIMIT 1];
        }
        
        if(spList.size() > 0)
        {
            scName = spList[0].Name;
        }
     
        indentRequestDetailList = new List<Indent_Request_Detail__c>();
        
        if(requestId != '' && requestId != null)
        {
            detailList = [SELECT Products__c,
                                 Requested_Quantity__c,
                                 Item_Priority__c
                            FROM Indent_Request_Detail__c 
                           WHERE Indent_Request__c = :requestId LIMIT 1000];
            
            if(detailList.size() > 0)
            {
                indentRequestDetailList = detailList.deepClone(false);
            }
        }
        
        for(Integer i = indentRequestDetailList.size() ; i< 5 ; i++)
        {
            Indent_Request_Detail__c indentRequestDetailObj = new Indent_Request_Detail__c();
            indentRequestDetailList.add(indentRequestDetailObj);
        } 
        
    }
    
    public PageReference saveIndentRequest()
    {
        List<Indent_Request_Detail__c> insertList = new List<Indent_Request_Detail__c>();
        
        for(Indent_Request_Detail__c detail:indentRequestDetailList)
        {
            if(detail.Products__c == null)
            continue;
            
            if(detail.Requested_Quantity__c == null)
            {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'<b>' + [SELECT Name FROM Product__c WHERE Id = :detail.Products__c].Name + '</b> : Requested Quantity cannot be empty');
                ApexPages.addMessage(errorMsg);
                return null;
            }
            
            insertList.add(detail);
        }
        
        if(requestId != '' && requestId != null)
        {
            if(detailList.size() > 0)
            delete detailList;
        }

        upsert indentRequestObj;
        
        for(Indent_Request_Detail__c detail:insertList)
        {
            detail.Indent_Request__c = indentRequestObj.Id;
        }
        
        if(insertList.size() > 0)
        insert insertList;
        
        return (new PageReference('/apex/ViewIndentRequest?Id=' + indentRequestObj.Id));
    }
    
    public PageReference cancel()
    {
        if(requestId != '' && requestId != null)
        {
            return (new PageReference('/' + requestId));
        }
        
        Schema.DescribeSObjectResult info = Indent_Request__c.SObjectType.getDescribe();
        String userPrfix = info.getKeyPrefix ();
        return (new PageReference('/' + userPrfix + '/o'));
    }
    
    public void addLineItems()
    {
        Indent_Request_Detail__c indentRequestDetailObj = new Indent_Request_Detail__c();
        //indentRequestDetailObj.Indent_Request__c = requestId;
        indentRequestDetailList.add(indentRequestDetailObj);
    }

    public void onDelete()
    {
        Integer index = deletedItem.intValue();
      
        if(indentRequestDetailList.size() > index)
        indentRequestDetailList.remove(index);
    }
            
    public String createIndentNumber()
    {
        String indentNo = '';
        List<Stock_Point__c> stockPointOwnerIDList = [select ownerid, Service_Center_Location_Code__c from Stock_Point__c where ownerid = : UserInfo.getUserId() and RecordType.Name = 'Service Center' limit 1];
        String strYear = String.ValueOf(Date.today().year()).substring(2,4);
        
        // Financial year
        Organization org = [SELECT FiscalYearStartMonth FROM Organization];
        //Integer year = Integer.valueOf(strYear);
        Integer year = Integer.valueOf(strYear) + 1;
        //Date startDate,endDate;
        //System.Debug('<<<<<<<< Month = ' + org.FiscalYearStartMonth); 
        if(Date.today().month() < org.FiscalYearStartMonth)
        {
            year =year -1;
        }
        
        if(year < 10)
            strYear = '0' + String.valueOf(year);
        else
            strYear = String.valueOf(year);

        
        Integer transfersCount = [SELECT count() FROM Indent_Request__c WHERE OwnerId = :UserInfo.getUserId() AND CreatedDate = THIS_FISCAL_YEAR];
        transfersCount++;
        String countStr = String.valueOf(transfersCount);
        
        while(countStr.length() < 5)
        {
            countStr = '0' + countStr;
        }
        if(stockPointOwnerIDList.size() > 0)
        {
            if(stockPointOwnerIDList[0].Service_Center_Location_Code__c != null && stockPointOwnerIDList[0].Service_Center_Location_Code__c != '')
            indentNo = strYear + stockPointOwnerIDList[0].Service_Center_Location_Code__c.substring(0,3) + countStr;

            return indentNo;
        }
        else
        {
            indentNo = strYear + '00000000';
            return indentNo;
        }
    }

    //INNER CLASS - Contains Indent Request and Indent Request Detail
    public class Indent {
  
        Indent_Request__c indentRequestObj = null;
        List<Indent_Request_Detail__c> indentRequestDetailListObj = null;

        public void setindentRequestObj(Indent_Request__c iRequest){
            indentRequestObj = iRequest;
        }

        public Indent_Request__c getindentRequestObj(){
            return indentRequestObj;
        }

        public void setindentRequestDetailListObj(List<Indent_Request_Detail__c> iRequestDetailList){
            indentRequestDetailListObj = iRequestDetailList;
        }

        public List<Indent_Request_Detail__c> getindentRequestDetailListObj(){
            return indentRequestDetailListObj;
        }
      
    }

}