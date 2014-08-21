@isTest
public class Test_trgUp{
    public static testMethod void getCoverage()
    {
      String State = '';
      List<User> recordowner = [Select ID,State From User Where ID =: '00590000000cIQJ'];  
       if (recordowner != null && recordowner.Size()>0)
          State = recordowner[0].State; 
          
      List<Component_Movement_Table__c> lstCMT = [Select Id,Service_Request__c,Select_Component__c from Component_Movement_Table__c where Service_Request__c =: 'a05O0000001EugQIAS'];
      
      Product__c objProduct = [select Product_Category__c from Product__c where id =: lstCMT[0].Select_Component__c];
      List<VAT1__c> vats = new List<VAT1__c>();
      vats = [ SELECT ID,VAT_Percentage__c,Start_Date__c,End_Date__c FROM VAT1__c where State__c =:State 
                         AND Product_Category__c =: objProduct.Product_Category__c
                         
                   ];
     
     
     Service_Request__c  objSR = new Service_Request__c(id='a05O0000001EugQIAS');
     objSR.Component_Tax_Rate_1__c = vats[0].VAT_Percentage__c;
     update objSR;
    }


}