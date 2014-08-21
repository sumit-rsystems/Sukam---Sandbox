global class BatchAccUpdate implements Database.Batchable<sObject> {
   public String query;

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
      List<Account> updAcc = new List<Account>();

      for(sObject s : scope) {
        Account a = (Account)s;
        if(a.phone != null && a.Phone.length() > 0 && a.phone.indexof('0') != 0)   
          a.phone = '0' +  a.phone;
        if(a.Alternate_Phone_No__c != null && a.Alternate_Phone_No__c.length() > 0 && a.Alternate_Phone_No__c.indexof('0') != 0)   
          a.Alternate_Phone_No__c = '0' +  a.Alternate_Phone_No__c;
        if(a.PersonMobilePhone != null && a.PersonMobilePhone.length() > 0 && a.PersonMobilePhone.indexof('0') != 0)
          a.PersonMobilePhone = '0' +  a.PersonMobilePhone;
        if(a.PersonHomePhone != null && a.PersonHomePhone.length() > 0 && a.PersonHomePhone.indexof('0') != 0)
          a.PersonHomePhone = '0' +  a.PersonHomePhone; 
        if(a.PersonOtherPhone != null && a.PersonOtherPhone.length() > 0 && a.PersonOtherPhone.indexof('0') != 0)
          a.PersonOtherPhone = '0' +  a.PersonOtherPhone;

        updAcc.add(a);

      }

      update updAcc;
   }

   global void finish(Database.BatchableContext BC){

   }
}