@isTest
public class testUpdateUserAddress
{
  static testmethod void testUpdateAddressMthd()
  {
   //Id UserId = '00590000000c9vE' ;
   User objUser = [SELECT LastName, City, Branch_State__c, Division, FirstName, Name FROM User where id =: '00590000000c9vE'];
   
   system.assert(objUser != null);
   //Component_Movement_Table__c obj = [select id,UserAddress__c from Component_Movement_Table__c  where id =:'a07O0000005FB6C'];
   //obj.id = 'a07O0000005FB6C';
   //system.Assert(obj != null);
   
   Component_Movement_Table__c obj = new Component_Movement_Table__c();
   obj.UserAddress__c  = 'Gurgaon ,Haryana' ;
   obj.CurrencyIsoCode = 'INR - Indian Rupee'; 
   obj.Service_Engineer_Assigned__c = 'a0bO0000000oZVU';
   obj.Quantity__c = 1;
   obj.Select_Component__c = 'a04O0000004na7Z';
   try
   {
     insert obj;
   }
   catch(System.DMLException e)
   {
     //System.assert(e.getMessage().contains('Record already exist '));
   }
   
  }

}