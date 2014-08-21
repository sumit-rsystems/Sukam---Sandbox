public class test_MapLeadToCustom{
    private static testMethod void unitTestForMapLeadToCustom(){
        Lead ld = new Lead(
            Salutation ='Mr.',
            firstName = 'first',
            lastName = 'Last',
            City = 'gurgaon',
            State = 'Haryana',
            Country = 'India',
            LeadSource = 'Web',
            Phone = '12345678'
        );
        insert ld;
        /*List<Enquiry__c> enq = new List<Enquiry__c>();
        enq = [Select id , Name, firstName__c, LastName__C, City__c, State__C, Country__c, Phone__c from 
               Enquiry__c where  firstName__c =: ld.firstName and LastName__c =: ld.LastName and Phone__c =: ld.Phone and City__c =: ld.City];     
        system.debug('enq ==='+enq );
        system.assertNotEquals(null, enq);*/
    }
}