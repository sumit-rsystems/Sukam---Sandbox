@isTest
public class testForOrderClasses
{
   static testMethod void testMethod1()
   {
      //creating a new price book item
      User thisUser=[select Id,Region__c,State,City,Street,PostalCode,Country,Email from User where Id=:UserInfo.getUserId() limit 1];      
      thisUser.State = 'Delhi';
      thisUser.Street = 'Indralok Colony';
      thisUser.City = 'Ghaziabad';
      thisUser.Country = 'India';
      thisUser.Email = 'abc@gmail.com';
      thisUser.Price_Book_Name__c='Andhra Pradesh';
      update thisUser;
      
      Price_Book__c priceBookEntry=new Price_Book__c();
      
      priceBookEntry.Category__c='testCategory';
      priceBookEntry.model__c='testModel';
      priceBookEntry.Capacity__c='testCapacity';
      priceBookEntry.basic__c=1000.0;
      priceBookEntry.Reference_Code__c='testRefCode';
      priceBookEntry.price_book_name__c='Andhra Pradesh';
      priceBookEntry.ERP_Code__c='ERPcodeTest';
      
      insert priceBookEntry;
      
      State__c thisState=new State__c();
      
      thisState.State_Name__c='Delhi';
      thisState.Branch_Accountant_Email_Id__c='abc@gmail.com';
      thisState.Branch_Manager_Email_Id__c='abc@gmail.com';
      
      insert thisState;
      
       
      
      System.debug('thisState in test class>'+thisState);
          
      
      // ------------------ SAVE ORDER - NEW ORDER ---------------------
      
      //Define Standard Controller of Type Account
      Order__c ord=new Order__c();
      
      //ord.submitted_time__c='(2012, 9, 1)';
      ord.Order_Status__c='Approved';
       
      insert ord;
      
      
      ApexPages.StandardController stdCont = new ApexPages.StandardController(ord);

      //creating obj for the extension class of the /apex/orderPage-- SAVE ORDER
      standardOrderController obj=new standardOrderController(stdCont);
      
      obj.hdnNumValue=0;
      
      obj.orderLineItemList[obj.hdnNumValue].lineitemObj.Product_Category__c=priceBookEntry.category__c;
      obj.orderLineItemList[obj.hdnNumValue].lineitemObj.model__c=priceBookEntry.model__c;
      obj.orderLineItemList[obj.hdnNumValue].lineitemObj.capacity__c=priceBookEntry.capacity__c;
      obj.orderLineItemList[obj.hdnNumValue].lineitemObj.order_quantity__c=10;
     
      obj.editable();
      obj.populateModel();
      obj.settingCapacity();
      obj.validateLineItem();
      obj.calculatePrice();
      obj.addMore();
      obj.saveOrder();
      
      // --------------  SAVE ORDER - EXISTING ORDER --------------------------
      
      PageReference currentPage = new PageReference('/apex/OrderPage?id='+obj.OrderObj.Id);
      Test.setCurrentPage(currentPage);
      
      Order__c ord1=new Order__c();
      //insert ord1;
      ApexPages.StandardController stdCont1 = new ApexPages.StandardController(ord1);

      //creating obj for the extension class of the /apex/orderPage-- SUBMIT ORDER
      standardOrderController obj1=new standardOrderController(stdCont1);
      
      obj1.hdnNumValue=0;
      
      obj1.orderLineItemList[obj1.hdnNumValue].lineitemObj.Product_Category__c=priceBookEntry.category__c;
      obj1.orderLineItemList[obj1.hdnNumValue].lineitemObj.model__c=priceBookEntry.model__c;
      obj1.orderLineItemList[obj1.hdnNumValue].lineitemObj.capacity__c=priceBookEntry.capacity__c;
      obj1.orderLineItemList[obj1.hdnNumValue].lineitemObj.order_quantity__c=10;
      obj1.orderLineItemList[obj1.hdnNumValue].getcategoryNameList();
      obj1.orderLineItemList[obj1.hdnNumValue].getmodelNameList();
      obj1.orderLineItemList[obj1.hdnNumValue].getcapacityNameList();
      
      obj1.editable();
      obj1.populateModel();
      obj1.settingCapacity();
      obj1.validateLineItem();
      obj1.calculatePrice();
      obj1.addMore();
      
      obj1.saveOrder();
      
      obj.cancelAction();
      
     
   }
   
   static testMethod void testMethod2()
   {
      Price_Book__c priceBookEntry=new Price_Book__c();
      
      priceBookEntry.Category__c='testCategory';
      priceBookEntry.model__c='testModel';
      priceBookEntry.Capacity__c='testCapacity';
      priceBookEntry.basic__c=1000.0;
      priceBookEntry.Reference_Code__c='testRefCode';
      priceBookEntry.price_book_name__c='Andhra Pradesh';
      priceBookEntry.ERP_Code__c='ERPcodeTest';
      
      insert priceBookEntry;
      
      State__c thisState=new State__c();
      
      thisState.State_Name__c='Andhra Pradesh';
      
      insert thisState;
      
       // ------------------ SAVE ORDER - NEW ORDER ---------------------
      
      //Define Standard Controller of Type Account
      Order__c ord=new Order__c();
      ApexPages.StandardController stdCont = new ApexPages.StandardController(ord);

      //creating obj for the extension class of the /apex/orderPage-- SAVE ORDER
      standardOrderController obj=new standardOrderController(stdCont);
      
      obj.hdnNumValue=0;
      
      obj.orderLineItemList[obj.hdnNumValue].lineitemObj.Product_Category__c=priceBookEntry.category__c;
      obj.orderLineItemList[obj.hdnNumValue].lineitemObj.model__c=priceBookEntry.model__c;
      obj.orderLineItemList[obj.hdnNumValue].lineitemObj.capacity__c=priceBookEntry.capacity__c;
      obj.orderLineItemList[obj.hdnNumValue].lineitemObj.order_quantity__c=10;
     
      obj.editable();
      obj.populateModel();
      obj.settingCapacity();
      obj.validateLineItem();
      obj.calculatePrice();
      obj.addMore();
      obj.saveOrder();
      
       // ------------------ SUBMIT ORDER -- EXISTING ORDER --------------
      
      PageReference currentPage1 = new PageReference('/apex/OrderPage?id='+obj.OrderObj.Id);
      Test.setCurrentPage(currentPage1);
          
      Order__c ord2=new Order__c();
      ApexPages.StandardController stdCont2 = new ApexPages.StandardController(ord2);

      standardOrderController obj2=new standardOrderController(stdCont2);
      
      obj2.hdnNumValue=0;
      
      obj2.toAddresses = new List<String>{'aaa@bbb.ccc'};
     
      obj2.submitOrder();
   
   
   }
   
   static testMethod void testMethod3()
   {
       User thisUser=[select Id,Region__c,State,City,Street,PostalCode,Country,Email from User where Id=:UserInfo.getUserId() limit 1];      
      thisUser.State = 'Andhra Pradesh';
      thisUser.Street = 'Indralok Colony';
      thisUser.City = 'Ghaziabad';
      thisUser.Country = 'India';
      thisUser.Email = 'abc@gmail.com';
      thisUser.Price_Book_Name__c='Andhra Pradesh';
      update thisUser;
      
       Price_Book__c priceBookEntry=new Price_Book__c();
      
      priceBookEntry.Category__c='testCategory';
      priceBookEntry.model__c='testModel';
      priceBookEntry.Capacity__c='testCapacity';
      priceBookEntry.basic__c=1000.0;
      priceBookEntry.Reference_Code__c='testRefCode';
      priceBookEntry.price_book_name__c='Andhra Pradesh';
      priceBookEntry.ERP_Code__c='ERPcodeTest';
      
      insert priceBookEntry;
      
      State__c thisState=new State__c();
      
      thisState.State_Name__c='Andhra Pradesh';
      
      insert thisState;
      
          // ------------------ SUBMIT ORDER - NEW ORDER ---------------------
      
      PageReference currentPage3 = new PageReference('/apex/OrderPage');
      Test.setCurrentPage(currentPage3);
          
      //Define Standard Controller of Type Account
      Order__c ord3=new Order__c();
      ApexPages.StandardController stdCont3 = new ApexPages.StandardController(ord3);

      //creating obj for the extension class of the /apex/orderPage-- SAVE ORDER
      standardOrderController obj3=new standardOrderController(stdCont3);
      
      obj3.hdnNumValue=0;
      //obj3.OrderObj=new Order__C();
      
      System.debug('order is>>>>>>>>>'+obj3.orderObj);
      
      obj3.orderLineItemList[obj3.hdnNumValue].lineitemObj.Product_Category__c=priceBookEntry.category__c;
      obj3.orderLineItemList[obj3.hdnNumValue].lineitemObj.model__c=priceBookEntry.model__c;
      obj3.orderLineItemList[obj3.hdnNumValue].lineitemObj.capacity__c=priceBookEntry.capacity__c;
      obj3.orderLineItemList[obj3.hdnNumValue].lineitemObj.order_quantity__c=10;
      obj3.orderLineItemList[obj3.hdnNumValue].lineitemObj.Basic__c=100.0;
      obj3.orderLineItemList[obj3.hdnNumValue].lineitemObj.Order_Line_Price__c='10000.0';
            
      obj3.toAddresses = new List<String>{'aaa@bbb.ccc'};
      obj3.submitOrder();
      
      obj3.sendMail();
       
      Order_Despatch__c desObj=new Order_Despatch__c();
      desObj.Order_Line_Item__c=obj3.orderLineItemList[0].lineItemObj.Id;
      insert desObj;
      
      // ----- VIEW ORDER PAGE -------------
      
      
      PageReference currentPage2 = new PageReference('/apex/viewOrderPage?id='+obj3.OrderObj.Id);
      Test.setCurrentPage(currentPage2);
      
      Order__c ord4 = new Order__c();
      ApexPages.standardController stdCont4 = new ApexPages.standardController(ord4);

      //creating obj for the extension class of the /apex/orderPage-- SAVE ORDER
      viewOrderController obj4=new viewOrderController(stdCont4);
      
      
      obj4.orderDetailList[0].despatchList[0].goods_received__c=true;
      
      obj4.toAddresses=new List<String>{'jayashree.ramamoorthy@listertechnologies.com'};
      
      obj4.orderObj.order_status__c='On-hold';
      obj4.orderObj.dispatch_status__c='Pending';
      
      obj4.handleCollapse();
      obj4.getCategoryList();
      obj4.getModelList();
      obj4.submitToEdit();
      obj4.updatingGoodsReceived();
      obj4.updatingGoodsReceived();
      obj4.onHoldStatusChange();
      obj4.getDistributorName();
      obj4.editAction();
      obj4.cancelAction();   
   }
}