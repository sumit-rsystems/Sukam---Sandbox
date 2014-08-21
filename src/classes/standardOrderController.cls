public class standardOrderController 
{
  public Order__c orderObj{get; set;}
  
  public List<Order_Line_Item__c> insertLineItem=new List<Order_Line_Item__c>();
  public List<Price_Book__C> categoryPriceBookList=new List<Price_Book__C>();
  public List<Price_Book__C> modelPriceBookList=new List<Price_Book__C>();
  public Integer hdnNumValue{get; set;}
  public String address{get; set;}
  public Map<String,Map<String,List<String>>> mapOFAllThree=new Map<String,Map<String,List<String>>>();
  public Map<String,Decimal> mapOfPriceBook=new Map<String,Decimal>(); 
  public List<String> toAddresses = new List<string>();
   
  public Boolean saveBtnRendered{get; set;}
  public Decimal grandTotal{get; set;}
  String userRegion;
  public String distributorName {get; set;}
  
 
  
  //inner class
  public class OrderDetail
  {
        public Order_line_item__c lineitemObj{get; set;}
        public List<String> categoryList=new List<String>();
        public List<String> modelList=new List<String>();
        public List<String> capacityList=new List<String>();
        public decimal price{get; set;}
           
        public List<selectOption> getcategoryNameList()
        {
          List<selectOption> options=new List<selectOption>();
        
          options.add(new selectOption('none','-- None --'));
          
          if(categoryList.size()>0)
          {
            for(Integer i=0;i<categoryList.size();i++)
            {
              if(categoryList[i]!=NULL)
                 options.add(new selectOption(categoryList[i],categoryList[i]));
            }
          }
          return options;
        }
        
        public List<SelectOption> getCapacityNameList()
        {
          List<selectOption> options=new List<selectOption>();
          
          options.add(new selectOption('none','-- None --'));
          if(capacityList!=NULL)
          {
            if(capacityList.size()>0)
            {
              for(Integer i=0;i<capacityList.size();i++)
              {
                if(capacityList[i]!=NULL)
                  options.add(new selectOption(capacityList[i],capacityList[i]));
              }
            }
          } 
          return options;
        }
        
        public List<selectOption> getModelNameList()
        {
          List<selectOption> options=new List<selectOption>();
          
          options.add(new selectOption('none','-- None --'));
          
          if(modelList.size()>0)
          {
            for(Integer i=0;i<modelList.size();i++)
            {
              if(modelList[i]!=NULL)
                 options.add(new selectOption(modelList[i],modelList[i]));
            }
          } 
          return options;
        }
  }//end of inner class
  
  //list of objects for the inner class
  public List<OrderDetail> orderLineItemList{get; set;}
  
  //constructor
  public standardOrderController(ApexPages.StandardController controller)
  {
    saveBtnRendered=true;
    grandTotal=0;
      
    orderLineItemList=new List<OrderDetail>();
    
    User thisUser=[select Id,Name,Price_Book_Name__c, Region__c,Email,State,City,Street,PostalCode,Country, ContactId from User where Id=:UserInfo.getUserId() limit 1];
    userRegion=thisUser.Price_Book_Name__c;
    //userRegion=thisUser.State;
    
    //for sending email
    
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
    
    if(userRegion!=NULL)
      categoryPriceBookList=[select Id,Category__c,Model__c,capacity__c,distributor__c,basic__c from Price_Book__c where price_book_name__c=:userRegion limit 500];
      
    //construction of the two maps    
    if(categoryPriceBookList.size()>0)
    { 
      Map<String,List<String>> tempMap=new Map<String,List<String>>();
      
      for(Integer i=0;i<categoryPriceBookList.size();i++)
      {
        if(mapOFAllThree.get(categoryPriceBookList[i].Category__c)==NULL)
           mapOfAllThree.put(categoryPriceBookList[i].Category__c,new Map<String,List<String>>());
        tempMap=mapOFAllThree.get(categoryPriceBookList[i].Category__c);
        if(tempMap.get(categoryPriceBookList[i].model__c)==NULL)
          tempMap.put(categoryPriceBookList[i].model__c,new List<String>());
        tempMap.get(categoryPriceBookList[i].model__c).add(categoryPriceBookList[i].capacity__c);
          
        
        if(categoryPriceBookList[i].capacity__c!=NULL)
        {
          //mapOFPriceBook.put(categoryPriceBookList[i].Category__c+','+categoryPriceBookList[i].Model__c+','+categoryPriceBookList[i].Capacity__c,categoryPriceBookList[i].basic__c);
            // Sourav April 9th , 2010
            mapOFPriceBook.put(categoryPriceBookList[i].Category__c+','+categoryPriceBookList[i].Model__c+','+categoryPriceBookList[i].Capacity__c,categoryPriceBookList[i].distributor__c);
        }
        else
        {
            //mapOfPriceBook.put(categoryPriceBookList[i].Category__c+','+categoryPriceBookList[i].Model__c,categoryPriceBookList[i].basic__c);
            // Sourav April 9th , 2010
            mapOfPriceBook.put(categoryPriceBookList[i].Category__c+','+categoryPriceBookList[i].Model__c,categoryPriceBookList[i].distributor__c);
        }
        
      }
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
    
    System.debug('state is>>>'+thisUser.state);
    if (thisUser.contactId != null) {
      Contact contactObj = [Select Id, Account.Name
                  , Account.BillingStreet, Account.BillingCity
                     , Account.BillingState, Account.BillingCountry
                     ,Account.BillingPostalCode   
                  From Contact 
                  Where Id=:thisUser.contactId];
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
      distributorName = thisUser.Name;
    }
    
    if(ApexPages.currentPage().getParameters().get('id')!=NULL)//for an existing order
    {
      
      List<order__c> orderObjList=new List<Order__c>();
      orderObjList=[select Id,Name,Order_Status__c,Order_Date__c,Dispatch_Status__c from Order__c where id=:ApexPages.currentPage().getParameters().get('id') limit 1];
      
      if(orderObjList.size()>0)
      {
        orderObj=orderObjList[0];
        
        if(orderObj.Order_Status__c=='Submitted')
          saveBtnRendered=false;
        else
          saveBtnRendered=true;
        orderObj.Order_Date_Time__c=System.now();
        List<Order_Line_Item__c> lineItems=new List<Order_Line_Item__c>();
        lineItems=[select Id,Product_Category__c,basic__c,capacity__c,model__c,order_line_price__c,order_quantity__c,ERP_Code__c from Order_line_Item__c where Order__c=:orderObj.Id limit 1000];
        
        if(lineItems.size()>0)
        {
            for(Integer i=0;i<lineItems.size();i++)
            {
                OrderDetail obj=new OrderDetail();
                Order_Line_Item__c item=new Order_Line_Item__c();
                
                item=lineItems[i];
                obj.lineItemObj=item;
                
                if(lineItems[i].order_line_price__c != null)
                    grandTotal+=Decimal.valueOf(lineItems[i].order_line_price__c);
                
                Set<String> tempSet=new Set<String>();
                tempSet=mapOfAllThree.keySet();
                for(String st:tempSet)
                {
                  obj.categoryList.add(st); 
                }
                
                if(mapOfAllThree.get(item.Product_Category__c)!=NULL)
                {
                    tempSet=mapOfAllThree.get(item.Product_Category__c).keySet();
                    if(tempSet.size()>0)
                    {
                      for(String st:tempSet)
                      {
                        obj.modelList.add(st); 
                      }
                    }
                }
                else
                  obj.modelList=new List<String>();
                
                if(mapOfAllThree.get(item.Product_Category__c)!=NULL)
                {
                    if(mapOfAllThree.get(item.Product_Category__c).get(item.model__c)!=NULL)
                       obj.capacityList=mapOfAllThree.get(item.Product_Category__c).get(item.model__c);
                    else
                       obj.capacityList=new List<string>();
                }   
                orderLineItemList.add(obj);
            }
        }
      } 
    }
    
    else//for a new order
    {
      orderObj=new Order__c();
      orderObj.Order_Date_Time__c=System.now();
      orderObj.Order_Status__c='Draft';
      
      
      for(Integer i=0;i<5;i++)
      {
        OrderDetail obj=new OrderDetail();
        obj.lineItemObj=new Order_Line_Item__c();
        Set<string> tempSet=new Set<String>();
        tempSet=mapOfAllThree.keySet();
        for(String str:tempSet)
        {
          obj.categoryList.add(str); 
        }
        orderLineItemList.add(obj);
      }  
      
    }
    
  }//end of constructor
  
  //method called after the constructor
  public PageReference editable()
  {
    Double temp,temp2;
        
    if(orderObj.submitted_time__c!=NULL)
      temp=orderObj.submitted_time__c.gettime();
    temp2=System.now().getTime();
        
    if(temp!=NULL)
    {
      if((Math.abs(temp2-temp))>14400000)
      {
         PageReference errorPg=new Pagereference('/apex/errorPage?id='+orderObj.Id);
         errorPg.setRedirect(true);
         return errorPg;
      }
      
    }
    
    if(orderObj.Order_Status__c=='Approved' || orderObj.Order_Status__c=='Rejected')
    {
         
         PageReference errorPg=new Pagereference('/apex/errorPage?id='+orderObj.Id);
         errorPg.setRedirect(true);
         return errorPg;
    }
    else
      return NULL;
  }
  
  //method called when the category is selected
  public pagereference populateModel()
  {
    if(hdnNumValue!=NULL)
    {
        if(orderLineItemList[hdnNumValue].lineitemObj.Product_Category__c!=NULL)
        {
          Set<String> tempSet=new Set<String>();
          if(mapOfALlThree.get(orderLineItemList[hdnNumValue].lineitemObj.Product_Category__c)!=NULL)
          {
              tempSet=mapOfALlThree.get(orderLineItemList[hdnNumValue].lineitemObj.Product_Category__c).keySet();
              if(tempSet.size()>0)
              {
                orderLineItemList[hdnNumValue].modelList=new List<String>();
                for(String str:tempSet){
                  orderLineItemList[hdnNumValue].modelList.add(str);
              }
              }
              else
              {
                orderLineItemList[hdnNumValue].modelList=new List<String>();
              }
              
          }   
        }
    }
    return NULL;
  }
  
  //method called once the model is selected
  public pagereference settingCapacity()
  {
    if(orderLineItemList[hdnNumValue].lineitemObj.Product_Category__c!=NULL && orderLineItemList[hdnNumValue].lineitemObj.Model__c!=NULL)
    {
      if(mapOfAllThree.get(orderLineItemList[hdnNumValue].lineItemObj.Product_Category__c)!=NULL)
      {
          if(mapOfAllThree.get(orderLineItemList[hdnNumValue].lineItemObj.Product_Category__c).get(orderLineItemList[hdnNumValue].lineitemObj.Model__c)!=NULL)
          {
            orderLineItemList[hdnNumValue].capacityList=mapOfAllThree.get(orderLineItemList[hdnNumValue].lineItemObj.Product_Category__c).get(orderLineItemList[hdnNumValue].lineitemObj.Model__c);
          }
          else
          {
            orderLineItemList[hdnNumValue].capacityList=new List<String>();
          }
      }
    }
    return NULL;
  }
  
  //method called when the capacity is selected
  public pagereference validateLineItem()
  {
    if(orderLineitemList.size()>0 && orderObj!=NULL)
    {
      for(Integer i=0;i<orderLineItemList.size();i++)
      {
        if(i!=hdnNumValue)
        {
        if(orderLineItemList[i].lineItemObj.product_Category__c!='none' && orderLineItemList[i].lineItemObj.model__c != 'none' && orderLineItemList[i].lineItemObj.capacity__c != 'none' && orderLineItemList[hdnNumValue].lineItemObj.product_Category__c!='none' && orderLineItemList[hdnNumValue].lineItemObj.model__c != 'none' && orderLineItemList[hdnNumValue].lineItemObj.capacity__c != 'none')
        {
          System.debug('none is none');
          if(orderLineItemList[i].lineItemObj.product_Category__c==orderLineItemList[hdnNumValue].lineItemObj.product_Category__c)
          {
            if(orderLineItemList[i].lineItemObj.model__c==orderLineItemList[hdnNumValue].lineItemObj.model__c)
            {
              if(orderLineItemList[i].lineItemObj.capacity__c==orderLineItemList[hdnNumValue].lineItemObj.capacity__c)
              {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The same line item cannot be ordered more than once');
                 ApexPages.addMessage(myMsg);
                 return NULL;
              } 
            }
          }
        }
       }
      }
    }
    if(orderLineitemList[hdnNumValue].lineItemObj.capacity__c=='none')
      orderLineitemList[hdnNumValue].lineItemObj.Basic__c=mapOfPriceBook.get(orderLineitemList[hdnNumValue].lineItemObj.Product_Category__c+','+orderLineitemList[hdnNumValue].lineItemObj.Model__c);
    else
      orderLineitemList[hdnNumValue].lineItemObj.Basic__c=mapOfPriceBook.get(orderLineitemList[hdnNumValue].lineItemObj.Product_Category__c+','+orderLineitemList[hdnNumValue].lineItemObj.Model__c+','+orderLineitemList[hdnNumValue].lineItemObj.capacity__c);
      
    
    return NULL;
  }
  
  //method called when the price is entered
  public pagereference calculatePrice()
  {
    validateLineItem();
    if(orderLineitemList[hdnNumValue].lineItemObj.Order_Quantity__c!=NULL && orderLineitemList[hdnNumValue].lineItemObj.Product_Category__c!=NULL && orderLineitemList[hdnNumValue].lineItemObj.model__c!=NULL)
    {
      Decimal price;
      
      if(orderLineitemList[hdnNumValue].lineItemObj.capacity__c=='none')
        price=mapOfPriceBook.get(orderLineitemList[hdnNumValue].lineItemObj.Product_Category__c+','+orderLineitemList[hdnNumValue].lineItemObj.Model__c);
      else
        price=mapOfPriceBook.get(orderLineitemList[hdnNumValue].lineItemObj.Product_Category__c+','+orderLineitemList[hdnNumValue].lineItemObj.Model__c+','+orderLineitemList[hdnNumValue].lineItemObj.capacity__c);
      if(price!=NULL)
      {
        orderLineitemList[hdnNumValue].lineItemObj.Basic__c=price;
        orderLineitemList[hdnNumValue].lineItemObj.Order_line_price__c=String.valueOf(orderLineitemList[hdnNumValue].lineItemObj.Order_Quantity__c*price);
      }
      if(orderLineitemList[hdnNumValue].lineItemObj.Order_line_price__c!=NULL)
        grandTotal+=Decimal.valueOf(orderLineitemList[hdnNumValue].lineItemObj.Order_line_price__c);
    }
    
    orderLineitemList[hdnNumValue].lineItemObj.ERP_Code__c=[select Id,ERP_Code__c from Price_Book__c where category__c=:orderLineitemList[hdnNumValue].lineItemObj.Product_Category__c and model__c=:orderLineitemList[hdnNumValue].lineItemObj.model__c and capacity__c=:orderLineitemList[hdnNumValue].lineItemObj.capacity__c limit 1].ERP_Code__c;
    return NULL;
  }
  
  //method called when the addmore button is clicked
  public PageReference addMore()
  {
     OrderDetail obj=new OrderDetail();
     obj.lineItemObj=new Order_Line_Item__c();
     Set<String> tempSet=new Set<String>();
     tempSet=mapOfAllThree.keySet();
     for(String str:tempSet)
     {
       obj.categoryList.add(str);
     }
     orderLineItemList.add(obj);
     
     return NULL;
  }
  
  //method called when the sve biutton is clicked
  public pagereference saveOrder()
  {
    validateLineItem();
    if(orderObj.Id==NULL)//new order
    {
      try
      {
        if(orderObj!=NULL)
          insert orderObj;
      }
      catch(Exception e)
      {
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'caught '+e);
       ApexPages.addMessage(myMsg);
       
       return NULL;
      }
    
      if(orderLineItemList.size()>0)
      {
        for(Integer i=0;i<orderLineItemList.size();i++)
        {
          if(orderLineItemList[i].lineItemObj.Product_Category__c!=NULL && orderLineItemList[i].lineItemObj.Product_Category__c!='none')
          {
            orderLineItemList[i].lineItemObj.Order__c=orderObj.Id;
            //orderLineItemList[i].lineItemObj.net_price__c=orderLineItemList[i].lineItemObj.Order_Quantity__c*orderLineItemList[i].Distributor__c;
            insertLineItem.add(orderLineItemList[i].lineItemObj);
          }    
        }
      }
        
      try
      {
        if(insertLineItem.size()>0)
          insert insertLineItem;
      }
      catch(Exception e)
      {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'caught ' + e);
       ApexPages.addMessage(myMsg);
          return NULL;
      }
    }
    else//updatng an existign order
    {
      try
      {
        if(orderObj!=NULL)
          update orderObj;
      }
      catch(Exception e)
      {
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'caught '+e);
       ApexPages.addMessage(myMsg);
       
        return NULL;
      }
      insertLineItem=new List<Order_Line_item__c>();
      List<Order_Line_item__c> updateLineItem=new List<Order_Line_item__c>();
      
      if(orderLineItemList.size()>0)
      {
        for(Integer i=0;i<orderLineItemList.size();i++)
        {
          if(orderLineItemList[i].lineItemObj.Product_Category__c!=NULL && orderLineItemList[i].lineItemObj.Product_Category__c!='none')
          {
            if(orderLineItemList[i].lineItemObj.Id==NULL)
            {
              orderLineItemList[i].lineItemObj.Order__c=orderObj.Id;
            //orderLineItemList[i].lineItemObj.net_price__c=orderLineItemList[i].lineItemObj.Order_Quantity__c*orderLineItemList[i].Distributor__c;
              insertLineItem.add(orderLineItemList[i].lineItemObj);
            }
            else
            {
              updateLineItem.add(orderLineItemList[i].lineItemObj);
            }
          }    
        }
      } 
      try
      {
         if(insertLineItem.size()>0)
            insert insertLineItem;
         if(updateLineItem.size()>0)
            update updateLineItem;
      }
      catch(Exception e)
      {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'caught '+e);
       ApexPages.addMessage(myMsg);
       
          return NULL;
      }
    }
    
    /*if(orderObj.order_status__c=='Submitted' && orderObj.dispatch_status__c=='Pending')
    {
      //orderObj=[select Id,Name from Order__c where Id=:orderObj.Id limit 1];
      if(toAddresses.size()>0)
      {
         ClassToSendEmail emailobj=new ClassToSendEmail();
         emailObj.send(orderObj.Id,orderObj.Name,toAddresses,'Submitted');
      }
    }*/
    
    /*if(toAddresses.size()>0)
    {
       ClassToSendEmail emailobj=new ClassToSendEmail();
       emailObj.send(orderObj.Id,orderObj.Name,toAddresses);
    }*/
    
   /* Schema.DescribeSObjectResult info = Order__c.SObjectType.getDescribe();
    String userPrfix = info.getKeyPrefix();
    return (new PageReference('/'+userPrfix + '/o'));*/
    
    System.debug('initial order id>>>'+orderObj.Id);
    return NULL;
  }//end of save order function

  //method called when submit button is clicked 
  public pagereference submitOrder()
  {
    validateLineItem();
    List<Order_Line_Item__c> updateLineItem=new List<Order_Line_ITem__c>();
    insertLineItem=new List<Order_Line_ITem__c>();
    
    System.debug('one>>');
    
    if(orderObj.Id!=NULL)
    {
         System.debug('one>>');
        Integer flag=0;
        if(orderLineItemList.size()>0)
        {
            for(Integer i=0;i<orderLineItemList.size();i++)
            {
              System.debug(orderLineItemList[i].lineItemObj.Product_Category__c);
              System.debug(flag);
              if(orderLineItemList[i].lineItemObj.Product_Category__c!=NULL && orderLineItemList[i].lineItemObj.Product_Category__c!='none')
              {
                if(orderLineItemList[i].lineItemObj.Product_Category__c!='none' && orderLineItemList[i].lineItemObj.model__c!='none' && orderLineItemList[i].lineItemObj.order_quantity__c!=NULL)
                {
                  flag++;
                }
                else
                {
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Complete order line item details');
                  ApexPages.addMessage(myMsg);
               
                  return NULL;
                }
              }
            }
        }
        if(flag==0)
        {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Order cannot be submitted with no line items');
          ApexPages.addMessage(myMsg);
       
          return NULL;
        }
        try
        {
          orderObj.Order_Status__c='Submitted';
          orderObj.dispatch_Status__c='Pending';
          update orderObj;
        }
        catch(Exception e)
        {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'caught '+e);
       ApexPages.addMessage(myMsg);
       
          return NULL;
        }
        
        
        if(orderLineItemList.size()>0)
        {
          for(Integer i=0;i<orderLineItemList.size();i++)
          {
           if(orderLineItemList[i].lineItemObj.Id==NULL)
           {
             if(orderLineItemList[i].lineItemObj.Product_Category__c!=NULL && orderLineItemList[i].lineItemObj.Product_Category__c!='none')
             {
               orderLineItemList[i].lineItemObj.Order__C=orderObj.Id;
               insertLineItem.add(orderLineItemList[i].lineItemObj);
             }    
           }
           else
           {
             if(orderLineItemList[i].lineItemObj.Product_Category__c!=NULL && orderLineItemList[i].lineItemObj.Product_Category__c!='none')
             {
               updateLineItem.add(orderLineItemList[i].lineItemObj);
             } 
           }
          }
        }
        
        try
        {
          if(insertLineItem.size()>0)
            insert insertLineItem;
          if(updateLineItem.size()>0)
            update updateLineItem;
        }
        catch(Exception e)
        {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'caught '+e);
       ApexPages.addMessage(myMsg);
       
          return NULL;
        }
    }
    else
    {
      
       System.debug('two>>');
      Integer flag=0;
        if(orderLineItemList.size()>0)
        {
            for(Integer i=0;i<orderLineItemList.size();i++)
            {
              System.debug(orderLineItemList[i].lineItemObj.Product_Category__c);
              System.debug(flag);
              if(orderLineItemList[i].lineItemObj.Product_Category__c!=NULL && orderLineItemList[i].lineItemObj.Product_Category__c!='none')
              {
                if(orderLineItemList[i].lineItemObj.Product_Category__c!='none' && orderLineItemList[i].lineItemObj.model__c!='none' && orderLineItemList[i].lineItemObj.order_quantity__c!=NULL)
                {
                  flag++;
                }
                else
                {
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Complete order line item details');
                  ApexPages.addMessage(myMsg);
               
                  return NULL;
                }
               
              }
            }
        }
        if(flag==0)
        {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Order cannot be submitted with no line items');
          ApexPages.addMessage(myMsg);
       
          return NULL;
        }
        
      orderObj.Order_status__c='Submitted';  
      orderObj.Dispatch_status__c='Pending';
       System.debug('one>>');
      return saveOrder();
      
       System.debug('one>>');
    }
    
   /* if(orderObj.order_status__c=='Submitted' && orderObj.dispatch_status__c=='Pending')
    {
      //orderObj=[select Id,Name from Order__c where Id=:orderObj.Id limit 1];
      if(toAddresses.size()>0)
      {
         ClassToSendEmail emailobj=new ClassToSendEmail();
         emailObj.send(orderObj.Id,orderObj.Name,toAddresses,'Submitted');
      }
    }*/
    
    System.Debug('Initial orderObj Id: ' + orderObj.Id);
    return NULL;
    
    /*Schema.DescribeSObjectResult info = Order__c.SObjectType.getDescribe();
    String userPrfix = info.getKeyPrefix();
    return (new PageReference('/'+userPrfix + '/o'));*/
    
 
  }
  
  public pagereference cancelAction()
  {
    Schema.DescribeSObjectResult info = Order__c.SObjectType.getDescribe();
    String userPrfix = info.getKeyPrefix ();
    return (new PageReference('/'+userPrfix + '/o'));
  }
  
  
  public pagereference sendMail()
  {
     
     System.Debug('Final orderObj Id: ' + orderObj.Id);
     
    if(orderObj.order_status__c=='Submitted' && orderObj.dispatch_status__c=='Pending')
    {
      //orderObj=[select Id,Name from Order__c where Id=:orderObj.Id limit 1];
      if(toAddresses.size()>0)
      {
         ClassToSendEmail emailobj=new ClassToSendEmail();
         emailObj.send(orderObj.Id,orderObj.Name,toAddresses,'Submitted');
      }
    }
    
    Schema.DescribeSObjectResult info = Order__c.SObjectType.getDescribe();
    String userPrfix = info.getKeyPrefix();
    return (new PageReference('/'+userPrfix + '/o'));
    
    
  }
  
}