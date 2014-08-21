/*
        -----------------------------------------
        CREATED BY      : Lister Technologies.
        CREATED ON      : 27/01/2010
        CREATED PURPOSE : Test class for the trigger trgSendSMS and class sendSMScls
        -----------------------------------------
                                                     */
                                                     
@isTest
private class sendSMSclsTWOTest
{
 
  
  public static testMethod void testing()
  {
     try
     {
          //Creating an account
          
          Account testAcc=new Account();
          testAcc.Name='test';
          testAcc.BillingStreet='11';
          testAcc.BillingCity='22';
          testAcc.BillingState='33';
          testAcc.BillingPostalCode='44';
          testAcc.BillingCountry='55';
          testAcc.Phone='09884504501';
          testAcc.ShippingStreet='11';
          testAcc.ShippingCity='22';
          testAcc.ShippingState='33';
          testAcc.ShippingPostalCode='44';
          testAcc.ShippingCountry='55';
         
          insert testAcc;
          
          //creating a contact
          Contact testContact=new Contact();
          testContact.FirstName='testFirst';
          testContact.LastName='testLast'; 
          testContact.AccountId=testAcc.Id;
          testContact.mobilePhone='09884504501';
          testContact.Email='jayashree.ramamoorthy@listertechnologies.com';
          
          insert testContact;
           
          //creating a case
          Service_Request__c testCase=new Service_Request__c();
          testCase.ownerId='00520000000qStb';
          testCase.account__c=testAcc.Id;
          testCase.Status__c='Assigned';
          testCase.origin__c='Email';
          testCase.Contact__c=testContact.ID;
          testCase.Description__c='sending test sms';
          testCase.FSR_No__c='a';
          testCase.FSR_Trig__c=1111;
          
          insert testCase;
          
          
          sendSMScls.sendSMS(new List<String>{'09884504501'},new List<String>{'hello'},new List<ID>{testCase.Id},new List<String>{'14111111111'},FALSE);
          
          testCase.Type_of_Service_Request__c='Warranty';
          testCase.Status__c='Closed';
          testCase.Reason__c='SYSTEM DEAD';
          testCase.Type_of_Replacement__c='Component Replacement';
          testCase.Warranty_Status__c='Yes';
          testCase.Product_Serial_No__c='12';
          testCase.Estimated_Value_of_Service_Request__c='Upto INR 50,000';
          
          
          
          update testCase;
      }//try
      catch(Exception e)
      {
        System.debug('caught the exception'+e);
      }
     
  }//test method

}//test class