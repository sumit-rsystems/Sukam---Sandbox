@isTest
private class MyTest
{ 
    private static testmethod void test1()
    {       
        Product__c prod = new Product__c();
        prod .Name = 'Test Product';
        prod .Product_Code__c= '12345';
        prod .Is_Active__c = true;
        prod .UoM__c = 'Kg';
        insert prod ;
        
        Indent_Request__c indentObj = new Indent_Request__c();
        indentObj.Requisition_Date__c = Date.today();
        indentObj.Dispatch_Sts__c = 'Pending';
        insert indentObj;
        
        Indent_Request_Detail__c det1 = new Indent_Request_Detail__c();
        det1.Requested_Quantity__c = 5;
        det1.Approved_Quantity__c = 5;
        det1.Products__c = prod.Id;
        det1.Indent_Request__c = indentObj.Id;
        insert det1; 
        
        
        Indent_Request_Dispatch_Detail__c dispatch1 = new Indent_Request_Dispatch_Detail__c();
        dispatch1.Indent_Request_Detail__c = det1.Id;
        dispatch1.Dispatch_Date__c = Date.today();
        dispatch1.Dispatch_Quantity__c = 1;
        insert dispatch1;
        
        
        Stock_Point__c spObj = new Stock_Point__c();
        spObj.Name = 'Sourav Trial';
        spObj.OwnerId = Userinfo.getUserId();
        insert spObj;
        
        ApexPages.StandardController stdcont = new ApexPages.StandardController(indentObj);
        IndentRequestController ircObj = new IndentRequestController(stdcont);
               
        PageReference page1 = new PageReference('/apex/IndentRequestForm?Id=' + indentObj.Id);
        test.setCurrentPage(page1);
        
        ircObj = new IndentRequestController(stdcont);
        
        ircObj.cancel();
        ircObj.addLineItems();
        ircObj.deletedItem = 0;
        ircObj.onDelete();
        ircObj.saveIndentRequest();
        
        det1 = new Indent_Request_Detail__c();
        det1.Requested_Quantity__c = 5;
        det1.Approved_Quantity__c = 5;
        det1.Products__c = prod.Id;
        det1.Indent_Request__c = indentObj.Id;
        insert det1;
        
        Indent_Request_Dispatch_Detail__c dispatch2 = new Indent_Request_Dispatch_Detail__c();        
        dispatch2.Indent_Request_Detail__c = det1.Id;
        dispatch2.Dispatch_Date__c = Date.today();
        dispatch2.Dispatch_Quantity__c = 3;
        insert dispatch2;
        
        Indent_Request_Dispatch_Detail__c dispatch3 = new Indent_Request_Dispatch_Detail__c();        
        dispatch3.Indent_Request_Detail__c = det1.Id;
        dispatch3.Dispatch_Date__c = Date.today();
        dispatch3.Dispatch_Quantity__c = 3;
        
        ViewIndentExtension vieObj = new ViewIndentExtension(stdcont);
        vieObj.itemIndex = 0;
        vieObj.handleCollapse();
        vieObj.editBtnHandler();
        vieObj.cancelBtnHandler();
        vieObj.pendingBtnHandler();
        vieObj.approveBtnHandler();
        vieObj.dispatchBtnHandler();
        vieObj.setFlags();
        
        vieObj.save();        
        
        vieObj.cancel();
        vieObj.createFilteredDetailList();
        
        ViewIndentExtension.ItemDetail obj = new ViewIndentExtension.ItemDetail();
        obj.detailObj = det1;
        obj.dispatchDetailObj = dispatch3;
        
        List<ViewIndentExtension.ItemDetail> filList = new List<ViewIndentExtension.ItemDetail>();
        filList.add(obj);
        vieObj.itemDetailFilteredList = filList;
        
        vieObj.saveDispatch();
        vieObj.cancelDispatch();      
        
    } 
   
}