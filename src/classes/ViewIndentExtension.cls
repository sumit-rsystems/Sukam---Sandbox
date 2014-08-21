public class ViewIndentExtension
{

   


    public Indent_Request__c indentRequestObj {get; set;}
    String requestId;
    public Double itemIndex {get; set;}
    public String scName {get; private set;}
    
    // ------ Button flags --------
    
    public Boolean editFlag {get; set;}  // screen 2 
    public Boolean cancelFlag {get; set;} // screen 2 
    public Boolean pendingApprovalFlag {get; set;} // screen 2 
    public Boolean approveRejectFlag {get; set;} // screen 2 
    public Boolean dispatchFlag {get; set;} // screen 2 
    
    public Boolean saveFlag {get; set;} // screen 3
    
    public Boolean saveDispatchFlag {get; set;}  // screen 4
    
    public Boolean itemsExistFlag {get; set;}  // screen 4
    
    //-----------------------------
    
    public List<Indent_Request_Detail__c> detailList {get; set;}

    public class ItemDetail
    {
        public Indent_Request_Detail__c detailObj {get; set;}
        public Boolean dispatchExists {get; set;}
        public Boolean isClicked {get; set;}
        public Indent_Request_Dispatch_Detail__c dispatchDetailObj{get; set;}
    }
    
    
    public List<ItemDetail> itemDetailList {get; set;}
    public List<ItemDetail> itemDetailFilteredList {get; set;}
    
    
    
    public ViewIndentExtension(ApexPages.StandardController stdcont)
    {
        //this.indentRequestObj = (Indent_Request__c)stdcont.getRecord();
        indentRequestObj = new Indent_Request__c();
        //detailList = new List<Indent_Request_Detail__c>();
        requestId = ApexPages.currentPage().getParameters().get('id');
  
        editFlag = cancelFlag = pendingApprovalFlag = approveRejectFlag = dispatchFlag = saveFlag = saveDispatchFlag = false;

        if(requestId != '' && requestId != null)
        {
            indentRequestObj = [SELECT Name, 
                                       Requisition_Date__c,
                                       Indent_Request_Status__c,
                                       OwnerId,
                                       Approval_Date__c,
                                       Dispatch_Status__c,
                                       Approval_Submission_Date__c,
                                       Address__c,
                                       City__c,
                                       Pincode__c,
                                       Dispatch_Sts__c,
                                       State__c                                         
                                  FROM Indent_Request__c 
                                 WHERE Id = :requestId];
                                 
            List<Stock_Point__c> spList = [SELECT Name FROM Stock_Point__c WHERE OwnerId =: indentRequestObj.OwnerId AND RecordType.Name = 'Service Center' LIMIT 1];
            if(spList.size() > 0)
            {
                scName = spList[0].Name;
            }
            
            setFlags();
            
            itemDetailList = new List<ItemDetail>();
            
            detailList = [SELECT Products__c,
                                 Product_Code__c,
                                 Requested_Quantity__c,
                                 Item_Priority__c,
                                 Line_Status__c,
                                 Approved_Quantity__c,
                                 Pending_Quantity__c,
                                 Remarks__c,
                                 Reason__c,
                                 (SELECT Dispatch_Quantity__c,Dispatch_Date__c,Remarks__c FROM Indent_Request_Dispatch_Details__r ORDER BY Dispatch_Date__c)
                            FROM Indent_Request_Detail__c 
                           WHERE Indent_Request__c = :requestId LIMIT 1000];
            
            for(Indent_Request_Detail__c detail: detailList)
            {
                ItemDetail obj = new ItemDetail();
                obj.isClicked = false;
                obj.detailObj = detail;
                
                obj.dispatchDetailObj = new Indent_Request_Dispatch_Detail__c();
                obj.dispatchDetailObj.Indent_Request_Detail__c = detail.Id;
                
                if(detail.Line_Status__c == 'Rejected')
                obj.dispatchDetailObj.Remarks__c = 'Rejected';
                
                if(detail.Indent_Request_Dispatch_Details__r.size() > 0)
                obj.dispatchExists = true;
                
                else
                obj.dispatchExists = false;
                
                itemDetailList.add(obj);
            }
            
        }   
        
    }
    
    public void handleCollapse()
    {
        Integer index = itemIndex.intValue();
        System.Debug('@@@@@@@@ index = ' + index);
        if(itemDetailList.size() > index)
        {
            if(itemDetailList[index].isClicked)
            itemDetailList[index].isClicked = false;
            
            else
            itemDetailList[index].isClicked = true;
        }
        System.Debug('@@@@@@@@ itemDetailList = ' + itemDetailList); 
    }
    
    public PageReference editBtnHandler()
    {
        return (new PageReference('/apex/IndentRequestForm?Id=' + requestId));
    }
    
    public PageReference cancelBtnHandler()
    {
        indentRequestObj.Indent_Request_Status__c = 'Cancelled';
        
        if(requestId != '' && requestId != null)
        update indentRequestObj;
        
        //setFlags();
        return (new PageReference('/' + requestId));
    }
    
    public PageReference pendingBtnHandler()
    {
        indentRequestObj.Indent_Request_Status__c = 'Pending Approval';
        indentRequestObj.Approval_Submission_Date__c = Date.Today();
        if(requestId != '' && requestId != null)
        update indentRequestObj;
        
        //setFlags();
        return (new PageReference('/' + requestId));
    }
    
    public PageReference approveBtnHandler()
    {
        //indentRequestObj.Indent_Request_Status__c = 'Approved';
        
        //if(requestId != '' && requestId != null)
        //update indentRequestObj;
        
        //setFlags();
        return (new PageReference('/apex/ApproveIndentPage?Id=' + requestId));
    }
    
    public PageReference dispatchBtnHandler()
    {
        // Dispatch actions are written here
        return (new PageReference('/apex/DispatchItems?Id=' + requestId));
    }
    
    public void setFlags()
    {
          // --------- Start : setting of button flags-------------
            
            if(requestId != '' && requestId != null)
            {
                User userObj = [SELECT Id,Enable_Dispatch_Authority__c,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
                
                if(indentRequestObj.Indent_Request_Status__c == 'Requisition' && indentRequestObj.OwnerId == userObj.Id)
                editFlag = cancelFlag = pendingApprovalFlag = true;
    
                if(userObj.Enable_Dispatch_Authority__c)
                {
                    
                    saveFlag = saveDispatchFlag = true;
                    
                    //***** Commented out to give Admin rights to change rejected to accepted and vice versa***
                    
                    if(indentRequestObj.Indent_Request_Status__c == 'Pending Approval')
                    approveRejectFlag = true;
                    
                    if(indentRequestObj.Indent_Request_Status__c != 'Requisition')
                    {
                        if(indentRequestObj.Dispatch_Sts__c != 'Closed')
                        {
                            approveRejectFlag = true;
                        }
                        if(userObj.Profile.Name == 'System Administrator')
                        {
                            approveRejectFlag = true;
                        }
                    }
                    
                    if(indentRequestObj.Indent_Request_Status__c == 'Approved')
                    dispatchFlag = true;
                }
            }
                      
            // --------- End : setting of button flags-------------
    }
    
    // --------------Start: Screen 3 ---------------------
    
   
    
    public PageReference save()
    {
        
        Boolean accepted = false;
        
        for(Indent_Request_Detail__c detail:detailList)
        {
            if(detail.Approved_Quantity__c > detail.Requested_Quantity__c)
            {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'<b>' + [SELECT Name FROM Product__c WHERE Id = :detail.Products__c].Name + '</b> : Approved Quantity Cannot Exceed Requested Quantity');
                ApexPages.addMessage(errorMsg);
                return null;
            }
            
            if(detail.Line_Status__c == 'Rejected' || detail.Approved_Quantity__c == 0)
            {
                if(detail.Reason__c == '' || detail.Reason__c == null)
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'<b>' + [SELECT Name FROM Product__c WHERE Id = :detail.Products__c].Name + '</b> : Please Specify Reason For Rejection');
                    ApexPages.addMessage(errorMsg);
                    return null;
                }
            }
            
            
            if(detail.Line_Status__c == 'Accepted' && detail.Approved_Quantity__c > 0)
            {
                indentRequestObj.Indent_Request_Status__c = 'Approved';
                //update indentRequestObj;
                accepted = true;
                //break;
            }
        }
        
        if(detailList.size() > 0)
        update detailList;
        
        if(!accepted)
        {
            indentRequestObj.Indent_Request_Status__c = 'Rejected';
            update indentRequestObj;
            return (new PageReference('/' + requestId));
        }
        
        update indentRequestObj; // Updating request status set to 'Approved'
        
        PageReference ref = new PageReference('/apex/ViewIndentRequest?Id=' + requestId);
        ref.setRedirect(true);
        return ref;
    }
    
    public PageReference cancel()
    {
        return (new PageReference('/' + requestId));
    }
    
    // --------------End: Screen 3 ---------------------
    
    // --------------Start: Screen 4 ---------------------
    
    // action method for page
    public void createFilteredDetailList()
    {
        itemDetailFilteredList = new List<ItemDetail>();
            
        List<Indent_Request_Detail__c> tempList =[SELECT Products__c,
                                                         Product_Code__c,
                                                         Requested_Quantity__c,
                                                         Item_Priority__c,
                                                         Line_Status__c,
                                                         Approved_Quantity__c,
                                                         Pending_Quantity__c 
                                                    FROM Indent_Request_Detail__c 
                                                   WHERE Indent_Request__c = :requestId and Pending_Quantity__c > 0 AND 
                                                         Line_Status__c != 'Rejected' LIMIT 1000];
                                                          
            if(tempList.size() > 0)
            {
                itemsExistFlag = true;
                for(Indent_Request_Detail__c detail: tempList )
                {
                    ItemDetail obj = new ItemDetail();
                    obj.detailObj = detail;
                    
                    obj.dispatchDetailObj = new Indent_Request_Dispatch_Detail__c();
                    obj.dispatchDetailObj.Indent_Request_Detail__c = detail.Id;
                     
                    itemDetailFilteredList.add(obj);
                }
            }
            else
            itemsExistFlag = false;
        
    }
    
    public PageReference saveDispatch()
    {
        
        List<Indent_Request_Dispatch_Detail__c> dispatchInsertList = new List<Indent_Request_Dispatch_Detail__c>();
        
        Boolean isPending = false;
        
        for(ItemDetail obj:itemDetailFilteredList)
        {
            //if(obj.detailObj.Line_Status__c != 'Rejected')
            //{
                if(obj.dispatchDetailObj.Dispatch_Quantity__c > obj.detailObj.Pending_Quantity__c)
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'<b>' + [SELECT Name FROM Product__c WHERE Id = :obj.detailObj.Products__c].Name + '</b> : Dispatch Quantity Cannot Exceed Pending Quantity');
                    ApexPages.addMessage(errorMsg);
                    return null;
                }
                
                else
                dispatchInsertList.add(obj.dispatchDetailObj); 
                
                if(obj.dispatchDetailObj.Dispatch_Quantity__c != obj.detailObj.Pending_Quantity__c)
                isPending = true;
                
           // }
        }
        
        if(!isPending)
        {
            indentRequestObj.Dispatch_Sts__c = 'Closed';
            update indentRequestObj;
        }
        
        if(dispatchInsertList.size() > 0)
        insert dispatchInsertList;
        
        return (new PageReference('/' + requestId));
    }
    
    public PageReference cancelDispatch()
    {
        return (new PageReference('/apex/ViewIndentRequest?Id=' + requestId));
    }
    
    // --------------End: Screen 4 ---------------------
}