@IsTest
   public class TestOverrideCtrl{
     static testMethod void ContractOverrideCtrlTestMethod(){
        Contracts__c objCon = new Contracts__c(
           //LastName = 'ff'
           //Description__c = ' hghjg'
           Product_Quantity__c=488
         );
         insert objCon;
        
        ApexPages.StandardController cont = new ApexPages.StandardController(objCon);
        ContractOverrideCtrl actCOn = new ContractOverrideCtrl(cont);
        actCOn.srRedirect();
     }
     
    static testMethod void CaseOverrideCtrlTestMethod(){
        
       Profile c= [select Name from Profile  where Name = 'Standard User' limit 1];
        
        //list<Service_Request__c> srlst=new list<Service_Request__c>();
        Service_Request__c oljCon = new Service_Request__c(
           // Status__c = 'Closed'
          
         );
        try{
            insert oljCon;
            
           }catch(Exception e){} 
         System.debug('===oljCon===' +oljCon);
        // srlst.add(oljCon);
         
         
         ApexPages.StandardController cont = new ApexPages.StandardController(oljCon);
         CaseOverrideCtrl aactCOn = new CaseOverrideCtrl(cont);
         aactCOn.srRedirect();
     }
     
    
  }