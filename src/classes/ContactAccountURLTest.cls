@isTest
public class ContactAccountURLTest 
{
    public static testMethod void testingContactAccount() 
    {
        List<Account> AccUpdate = new List<Account>();
        
        /*for(Account Accts: [Select Id from Account where trgCustomerID__c != Null limit 100])
        {
            Accts.trgCustomerID__c = null;
            AccUpdate.add(Accts);
        }            
        Update AccUpdate;*/
        
        Account acct= new Account();
        acct.phone='01122120767';
        acct.name='testaccount';
        acct.Customer_ID__c = 'ACC-1001';
        acct.Billingstreet = 'Add1';
        acct.Billingcity = 'Add1';
        acct.Billingstate = 'Add1';
        acct.Billingpostalcode = '1234';
        acct.Billingcountry = 'Add1';
        insert acct;
        
        /*
        Account acct2= new Account();
        acct2.phone='01122450767';
        acct2.name='testaccount2';
        acct2.Billingstreet = 'Add1';
        acct2.Billingcity = 'Add1';
        acct2.Billingstate = 'Add1';
        acct2.Billingpostalcode = '1234';
        acct2.Billingcountry = 'Add1';
        insert acct2;
        */

        Contact con=new Contact();
        con.phone='09087654321';
        con.lastname='testcontact';
        insert con;
        
        Contact con1=new Contact();
        con1.phone='09087654321';
        con1.lastname='testcontact1';
        insert con1;

        Contact con2=new Contact();
        con2.phone='05344566335';
        con2.lastname='testcontact2';
        insert con2;

        ContactAccountUrl caurl=new ContactAccountUrl();
        ContactAccountUrl.getURL('01234567890','https://na2-api.salesforce.com/services/Soap/u/12.0/4c1300D4000000078xH');
        ContactAccountUrl.getURL('04567003232','https://na2-api.salesforce.com/services/Soap/u/12.0/4c1300D4000000078xH');
        ContactAccountUrl.getURL('09087654321','https://na2-api.salesforce.com/services/Soap/u/12.0/4c1300D4000000078xH');
        ContactAccountUrl.getURL('05344566335','https://na2-api.salesforce.com/services/Soap/u/12.0/4c1300D4000000078xH');
    }
}