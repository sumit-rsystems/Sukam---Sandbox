public class viewOrderController
{
  public Order__c orderObj{get; set;}
  public List<Order_Line_Item__c> orderLineItemList{get; set;}
  public List<Order_Line_Item__C> insertLineItem=new List<Order_Line_Item__C>();
  public List<Order_Line_Item__c> updateLineItemList=new List<Order_Line_Item__c>();
  public List<Order_Despatch__c> despatchItemList=new List<Order_Despatch__c>();
  public List<Price_Book__C> categoryPriceBookList=new List<Price_Book__C>();
  public List<Price_Book__C> modelPriceBookList=new List<Price_Book__C>();
  public List<String> toAddresses=new List<String>();
  public String status{get;set;}
  
  public Integer hdnNumValue{get; set;}
  String userRegion;
  public String address{get; set;}
  public Boolean crmUserRendered{get; set;}
  public Boolean draftOrder{get; set;}
  public Boolean closedRendered{get; set;}
  public Boolean orderReceived{get; set;}
  public Boolean showTableHeader{get; set;}
  public Boolean goodsReceivedDisplay{get; set;}
  public Decimal grandTotal{get; set;}
  public Boolean PRMUser{get; set;}
  public Boolean PRMgoodsReceived{get; set;}
  public Boolean mailRendered{get; set;}
  public String distributorName {get; set;}
  public String selectedDispatchId {get; set;} 
    
  Map<Id,Decimal> mapOfProdnPrice=new Map<Id,Decimal>();
  Map<Id,List<Order_Despatch__c>> mapOfItemnDespatch=new Map<Id,List<Order_Despatch__c>>();
  //inner class
  public class orderDetail
  {
    public Order_Line_Item__c lineItemObj{get; set;} 
    public Boolean dispatchExists {get; set;}
    public Boolean isClicked {get; set;}
    public List<Order_Despatch__c> despatchList{get; set;}
   
    
  }
  
  public List<OrderDetail> orderDetailList{get; set;}
  
  //constructor
  public viewOrderController(ApexPages.StandardController controller)
  {
    crmUserRendered=false;
    draftOrder=false;
    //closeRendered=true;
    orderReceived=false;
    showTableHeader = true;
    grandTotal=0;
    PRMUser=false;
    PRMgoodsReceived=false;
    mailRendered=false;
    status = '';
    
    User thisUser=[select Id,Region__c,State,City,Street,PostalCode,Country,Email from User where Id=:UserInfo.getUserId() limit 1];

    if(thisUser!=NULL && thisUser.State!=NULL)
    {
        List<State__c> thisState=new List<State__c>();
        thisState=[select Id,Branch_Accountant_Email_Id__c,Branch_Manager_Email_Id__c from State__c where State_Name__c=:thisUser.State limit 1];
        
        
        if(thisState.size()>0)
        {
          if(thisState[0].Branch_Accountant_Email_Id__c!=NULL)
            toAddresses.add(thisState[0].Branch_Accountant_Email_Id__c);
          if(thisState[0].Branch_Manager_Email_Id__c!=NULL)
            toAddresses.add(thisState[0].Branch_Manager_Email_Id__c);
        }
        
        if(thisUser.Email!=NULL)
          toAddresses.add(thisUser.Email);
                
         
               
    }
      
    address='';
    if(thisUser.Street!=NULL)
      address+=thisUser.Street;
    if(thisUser.City!=NULL)
      address+=','+thisUser.City;
    if(thisUser.State!=NULL)
      address+=','+thisUser.State;
    if(thisUser.Country!=NULL)
      address+=','+thisUser.Country;

    
    orderObj = new Order__c();
    
    System.debug('mail parameter id>>>>>>'+ApexPages.currentPage().getParameters().get('mail'));
    
    if(ApexPages.currentPage().getParameters().get('mail')!=NULL)
    {
      if(ApexPages.currentPage().getParameters().get('mail')=='true')
        mailRendered=true;
      else 
        mailRendered=false;
    }
    
    System.debug('mailRendered'+mailRendered);
    List<Order__c> tempList = new List<Order__c>();
    
    if(ApexPages.currentPage().getParameters().get('id')!=NULL)
       tempList = [select Id,Order_Status__c,Order_Date_Time__c,Dispatch_Status_indicator__c,submitted_time__c,Name,Dispatch_Status__c,Order_Date__c, OwnerId from Order__c where Id=:ApexPages.currentPage().getParameters().get('id') limit 1];
      
    if(tempList.size()>0)
      orderObj=tempList[0];
    
    orderDetailList=new List<OrderDetail>();
    
    getDistributorName();
    
    if(orderObj.Order_Status__c == 'Draft')
        showTableHeader = false;
    
    //status = orderObj.Order_Status__c;
    
    
    if(orderObj!=NULL)
    {
      if(orderObj.Order_Status__c=='Draft')
      {
        draftOrder=true;
      }
      else
      {
        draftOrder=false;
      }
      
      String profileName=[select Id,Name from Profile where Id=:UserInfo.getProfileId() limit 1].Name;
      
      if((profileName == 'Sukam Partner User' || profileName == 'Dummy - Partner Profile'))
          showTableHeader = false;
      
       
       if(profileName == 'Sukam Partner User' || profileName == 'Dummy - Partner Profile')
       {
         goodsReceivedDisplay=false;
       }
       else
       {
         goodsReceivedDisplay=true;
       }  
      
      if(profileName=='Sales User PRM' || profileName=='System Administrator')
      {
        PRMUser=true;
        if(orderObj.Dispatch_Status__c!='Closed')
        {
           
           PRMgoodsReceived=true;
        }
        else
        {
            PRMgoodsReceived=false;
            
        }
        if(orderObj.Order_Status__c=='Submitted')
        {
          crmUserRendered=true;
        }
        else
        {
          //error msg
        }
      }         
      else
      {
        PRMUser=false;
        crmUserRendered=false;
      }  
      orderLineItemList=[select Id,capacity__c,Order_Quantity__c,approved_Remarks__c,Product_Category__c,Approved_quantity__c,Model__c,basic__c,Order_Line_Price__c from Order_Line_Item__c where Order__c=:orderObj.Id];
      despatchItemList=[select Id,Despatch_Quantity__c,Order_line_Item__c,Goods_Received__c,Despatch_Date__c,Despatch_Remarks__c,invoice_date__c,Invoice_No__c from Order_Despatch__c where Order_Line_Item__r.Order__c=:orderObj.Id];
      for(Integer i=0;i<despatchItemList.size();i++)
      {
        if(mapOfItemnDespatch.get(despatchItemList[i].Order_Line_Item__c)==NULL)
          mapOfItemnDespatch.put(despatchItemList[i].Order_Line_Item__c,new List<Order_despatch__c>());
        mapOfItemnDespatch.get(despatchItemList[i].Order_Line_Item__c).add(despatchItemList[i]);
        
      }
    }
    
    if(crmUserRendered==false)
    {
      orderReceived=true;
    }
    
    if(orderLineItemList.size()>0)
    {
      for(Integer i=0;i<orderLineItemList.size();i++)
      {
        OrderDetail obj=new OrderDetail();
        obj.lineItemObj=orderLineItemList[i];
        if(orderLineItemList[i].Order_Line_Price__c!=NULL)
        {
          if(Decimal.valueOf(orderLineItemList[i].Order_Line_Price__c)!=NULL)
            grandTotal+=Decimal.valueOf(orderLineItemList[i].Order_Line_Price__c);
        }
        obj.isClicked=false;
        
        if(mapOfItemnDespatch.get(orderLineItemList[i].Id)!=NULL)
        {
          obj.despatchList=new List<Order_despatch__c>();
          obj.despatchList=mapOfItemnDespatch.get(orderLineItemList[i].Id);
          obj.dispatchExists = true;
          
          
        }
        orderDetailList.add(obj);
      }
      //update orderObj;
    }
    
     
       System.debug('Goods>>> '+goodsReceivedDisplay);
       System.debug('PRM USER>>> '+PRMUser);
    
    
  }
  
  public void handleCollapse()
  {
     Integer index = hdnNumValue;
     System.Debug('@@@@@@@@ index = ' + index);
   
     if(orderDetailList.size() > index)
     {
        if(orderDetailList[index].isClicked)
          orderDetailList[index].isClicked = false;
        else
          orderDetailList[index].isClicked = true;
     }
     System.Debug('@@@@@@@@ orderDetailList= ' + orderDetailList); 
  }

  
  public List<selectOption> getcategoryList()
  {
    List<selectOption> options=new List<selectOption>();
    
    options.add(new selectOption('none','-- None --'));
    
    for(Integer i=0;i<categoryPriceBookList.size();i++)
    {
      options.add(new selectOption(categoryPriceBookList[i].Category__c,categoryPriceBookList[i].Category__c));
    }
    return options;
  }
  
  public List<selectOption> getModelList()
  {
    List<selectOption> options=new List<selectOption>();
    
    options.add(new selectOption('none','-- None --'));
    
    for(Integer i=0;i<modelPriceBookList.size();i++)
    {
      options.add(new selectOption(modelPriceBookList[i].Model__c,modelPriceBookList[i].Model__c));
    }
    return options;
  }
  
  public pageReference onHoldStatusChange()
  {
    if(orderObj.Order_Status__c=='On-hold' && orderObj.dispatch_status__c=='Pending')
    {
      try
      {
        update orderObj;
      }
      catch(Exception e)
      {
        //error msg         
      }
      if(toAddresses.size()>0)
      {
         ClassToSendEmail emailobj=new ClassToSendEmail();
         emailObj.send(orderObj.Id,orderObj.Name,toAddresses,'Onhold');
      }
    }
    return NULL;    
  }
  
  
  public PageReference submitToEdit()
  {
    Double temp,temp2;
        
    if(orderObj.submitted_time__c!=NULL)
      temp=orderObj.submitted_time__c.gettime();
    temp2=System.now().getTime();
    
    System.debug('submitted time>>'+orderObj.submitted_time__c);
   
    if(orderObj.Order_Status__c=='Submitted' || orderObj.Order_Status__c=='On-hold')
    {
    
      if(orderObj.Dispatch_status__c!='In-Transit' && orderObj.Dispatch_status__c!='closed' && orderObj.Dispatch_status__c!='Part-Shipment Received')   
      {
        if(temp!=NULL)
        {
          System.debug('here');
          if((Math.abs(temp2-temp))>14400000)
          {
             //PageReference errorPg=new Pagereference('/apex/errorPage?id='+orderObj.Id);
             //errorPg.setRedirect(true);
             
             //return errorPg;
          }
          else
          {
            System.debug('edit');
            draftOrder=true;
          }
        }
       }
    }
    return NULL;
  }
  
  
 
   
  public pagereference updatingGoodsReceived()
  {
    try
    {
       orderObj=[select Id,Order_Status__c,Dispatch_Status_indicator__c,submitted_time__c,Name,Dispatch_Status__c,Order_Date__c,Order_Date_Time__c, OwnerId from Order__c where Id=:orderObj.Id limit 1];
       
        List<Order_Despatch__c> updateList=new List<Order_Despatch__c>();
        Integer count=0;
        Integer noOfDespatches=0;
        if(orderDetailList.size()>0)
        {
            for(Integer i=0;i<orderDetailList.size();i++)
            {
              if(orderDetailList[i].despatchList!=NULL && orderDetailList[i].despatchList.size()>0)
              {
                  for(Integer j=0;j<orderDetailList[i].despatchList.size();j++)
                  {
                    if(orderDetailList[i].despatchList[j].goods_received__c == true && orderDetailList[i].despatchList[j].Id == selectedDispatchId)  {
                      updateList.add(orderDetailList[i].despatchList[j]);     
                    }
                    if(orderDetailList[i].despatchList[j].goods_received__c == true)  {
                    count++;
                    }
                    noOfDespatches++;
                  }
              }
            }
        }
        try
        {
          System.debug(updateList + 'updateList');  
          if(updateList.size()>0)
            update updateList;
        }
        catch(Exception e)
        {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'exception' + e);
          ApexPages.addMessage(myMsg);
          return NULL;
        }
        
        System.debug('jksdhfjksdhfasdhjkfhdjk');
        
        if(count>0)
        {
          System.debug('count=noOfDespatches'+count);
          System.debug('count=noOfDespatches'+noOfDespatches);
         
          System.debug('orderObj.Dispatch_status_Indicator__c'+orderObj.Dispatch_status_Indicator__c);
          System.debug('orderObj.Dispatch_Status__c'+orderObj.Dispatch_Status__c);
          if(count==noOfDespatches && orderObj.Dispatch_Status__c=='Part-Shipment received' && orderObj.Dispatch_status_Indicator__c==1)
          {
            orderObj.Dispatch_Status__c='Closed';
            try
            {
              update orderObj;
            }
            catch(Exception e)
            {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'exception '+e);
              ApexPages.addMessage(myMsg);
            }
          }
          
          if(orderObj.Dispatch_Status__c=='In-Transit')
          {
            orderObj.Dispatch_Status__c='Part-Shipment received';
            try
            {
              update orderObj;
              
            }
            catch(Exception e)
            {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'exception '+e);
              ApexPages.addMessage(myMsg);
            }            
          }
          
          else
          {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Order can be received only once dispatched');
             ApexPages.addMessage(myMsg);
             return NULL;
          }
        }
        else
        {
          //orderObj.Dispatch_Status__c='In-Transit';
          
        }
        
        
         
         showTableHeader = true;
       
       
        
     }
     catch(Exception e)
    {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'exception '+e);
      ApexPages.addMessage(myMsg);
    }
     return NULL;
  }
  
  public pagereference editAction()
  {
    PageReference orderPg=new PageReference('/apex/orderPage?id='+orderObj.Id);
    orderPg.setRedirect(true);
    return orderPg;
  }
   
  public pagereference cancelAction()
  {
    Schema.DescribeSObjectResult info = Order__c.SObjectType.getDescribe();
    String userPrfix = info.getKeyPrefix ();
    return (new PageReference('/'+userPrfix + '/o'));
  }
  
  public void getDistributorName() {
      User userObj = [Select Id, Name, contactId from User Where Id=:orderObj.OwnerId];
      if (userObj.contactId != null) {
        Contact contactObj = [Select Id, Account.Name
                     , Account.BillingStreet, Account.BillingCity
                     , Account.BillingState,Account.BillingCountry
                     ,Account.BillingPostalCode  
                     From Contact 
                     Where Id=:userObj.contactId];
    distributorName = contactObj.Account.Name;
    address = '';
      if (contactObj.Account.BillingStreet != NULL)
        address += contactObj.Account.BillingStreet;
      if (contactObj.Account.BillingCity != NULL)
        address += ','+ contactObj.Account.BillingCity;
      if(contactObj.Account.BillingState!= NULL)
        address += ',' + contactObj.Account.BillingState;
      if(contactObj.Account.BillingCountry != NULL)
        address+=','+contactObj.Account.BillingCountry;          
      } else {
        distributorName = userObj.Name; 
      }  
  }
}