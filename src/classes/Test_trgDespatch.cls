/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_trgDespatch {

    static testMethod void trgDespatchUnitTest() {
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
      
      Profile oProfile = [SELECT Id 
	   					   FROM profile 
	   					   WHERE name='System Administrator']; 
      
      User oUser = new User(alias = 'standt', 
      	email='standarduser@testorg.com1', 
        emailencodingkey='UTF-8',
        lastname='Testing',
        languagelocalekey='en_US', 
        localesidkey='en_US', 
        profileid = oProfile.Id,
        timezonesidkey='America/Los_Angeles',
        username='standarduser209@testorg.com');
      insert oUser;
      
      Order__c ord = new Order__c();
      ord.Order_Date_Time__c=System.now();
      ord.Order_Status__c='Draft';
      ord.OwnerId = oUser.Id;
      insert ord;
      
      Order_Line_Item__c ordLineItem = new  Order_Line_Item__c();
      ordLineItem.Product_Category__c=priceBookEntry.category__c;
      ordLineItem.model__c=priceBookEntry.model__c;
      ordLineItem.capacity__c=priceBookEntry.capacity__c;
      ordLineItem.order_quantity__c=10;
      ordLineItem.ERP_Code__c = '1245898';
      ordLineItem.Order__c = ord.Id; 
      insert ordLineItem;
      
      Order_Despatch__c orderDespatch = new Order_Despatch__c();
      orderDespatch.Despatch_Date__c = Date.today();
      orderDespatch.Despatch_Quantity__c = 15;
      orderDespatch.Goods_Received__c = true;
      orderDespatch.Order_Line_Item__c = ordLineItem.Id; 
      insert orderDespatch;
      
      orderDespatch = [SELECT ID, Despatch_Quantity__c, Goods_Received__c FROM Order_Despatch__c Where Id =: orderDespatch.Id];
      orderDespatch.Despatch_Quantity__c = 150;
      update orderDespatch;
      
      orderDespatch = [SELECT ID, Despatch_Quantity__c, Goods_Received__c FROM Order_Despatch__c Where Id =: orderDespatch.Id];
      orderDespatch.Despatch_Quantity__c = 160;
      update orderDespatch;  
      
      
      
      /*List<Inventory__c> invObj = [Select Id from Inventory__c Where 
      							ERP_Code__c =: ordLineItem.ERP_Code__c];
      System.debug(orderDespatch.ERP_Code__c + 'inventroyDetails' + invObj);
      
      orderDespatch = new Order_Despatch__c();
      orderDespatch.Despatch_Date__c = Date.today();
      orderDespatch.Despatch_Quantity__c = 15;
      orderDespatch.Goods_Received__c = true;
      orderDespatch.Order_Line_Item__c = ordLineItem.Id; 
      insert orderDespatch;  
      
       
      orderDespatch = [SELECT ID, Despatch_Quantity__c, Goods_Received__c FROM Order_Despatch__c Where Id =: orderDespatch.Id];
      orderDespatch.Despatch_Quantity__c = 150;
      update orderDespatch;
      
      orderDespatch = new Order_Despatch__c();
      orderDespatch.Despatch_Date__c = Date.today();
      orderDespatch.Despatch_Quantity__c = 15;
      orderDespatch.Goods_Received__c = true;
      orderDespatch.Order_Line_Item__c = ordLineItem.Id; 
      insert orderDespatch;    	

	  invObj = [Select Id, Quantity__c from Inventory__c Where 
      							ERP_Code__c =: ordLineItem.ERP_Code__c];
      System.debug(orderDespatch.ERP_Code__c + 'inventroyDetails' + invObj);*/
	  	      						
      
      
    }
}