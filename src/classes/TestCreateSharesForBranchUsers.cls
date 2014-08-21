@isTest
public class TestCreateSharesForBranchUsers {
    
    static testmethod void testCrSharesBrUsersMethod() { 
       Profile p = [Select ID from PROFILE where name = 'Service Center'] ;
       
       User u1 = new User(alias = 'standt', email='standarduser@testorg.com',
           emailencodingkey='UTF-8', lastname='Testing',
           languagelocalekey='en_US',
           localesidkey='en_US', profileid  =  p.id,
           timezonesidkey='America/Los_Angeles',
           username='standarduser12@testorg.com');
           insert u1;
           
        ID stRecordType;
        ID stRecordType1;
        for(RecordType rt : [SELECT Id, Name  FROM RecordType  WHERE SObjectType = 'Stock_Point__c' AND Name =: 'Branch']) {
            stRecordType = rt.Id;            
        } 
        for(RecordType rt1 : [SELECT Id, Name  FROM RecordType  WHERE SObjectType = 'Stock_Point__c' AND Name =: 'Service Center']) {
            stRecordType1 = rt1.Id;            
        }       
        Stock_Point__c spObj = new Stock_Point__c(Name = 'AMIT KUMAR CHAURSIYA',Region__c = 'CENTRAL',
                                                    RecordTypeId = stRecordType );
        insert spObj;  
        spObj.OwnerId = u1.id;
        update spObj;
              
        Stock_Point__c spObj1 = new Stock_Point__c(Name = 'AMIT KUMAR ',Region__c = 'NORTH',
                                                    RecordTypeId = stRecordType );
        insert spObj1;
        spObj1.OwnerId = u1.id;
        update spObj1;
        
        Stock_Point__c spObj2 = new Stock_Point__c(Name = 'AMIT CHAURSIYA',Region__c = 'SOUTH',
                                                    RecordTypeId = stRecordType1, Related_To_Branch__c = spObj.Id);
        insert spObj2;
        spObj2.Related_To_Branch__c = spObj1.Id;
        //spObj2.Region__c = 'WEST';
        update spObj2;
        
              
    }
}