/**
* 
*  Test class to test the Case trigger trgCaseSetOwner.
* 
*  Author              |Author-Email                             |Date        |Comment
*  --------------------|---------------------------------------- |------------|----------------------------------------------------
*  Balaji Prabhakaran  |balaji.prabakaran@listertechnologies.com |06.30.2010  |First Draft
* 
*/

@isTest
private class trgCaseSetOwner_Test {

    static testMethod void myUnitTest() {
        //To get the id of the Call Center Profile.
        Id callcenterProfileId = [Select Id From Profile Where Name='Call Center'].Id;

        //To get the id of the Call Center Agent Role.
        Id callcenterAgentRoleId = [Select Id From UserRole Where Name = 'Call Center Agent'].Id;
        
        //Create a test user record for Delhi
        User testUserDelhi = new User();
        testUserDelhi.FirstName = 'Test';
        testUserDelhi.LastName = 'Call Center User Delhi';
        testUserDelhi.Username = 'test.call.center.user.delhi@sukam.com';
        testUserDelhi.Email = 'test.call.center.user.delhi@sukam.com';
        testUserDelhi.Alias = 'testdel';
        testUserDelhi.EmailEncodingKey = 'UTF-8';
        testUserDelhi.LanguageLocaleKey = 'en_US';
        testUserDelhi.LocaleSidKey = 'en_US';
        testUserDelhi.TimeZoneSidKey = 'America/Los_Angeles';
        testUserDelhi.ProfileId = callcenterProfileId;
        testUserDelhi.UserRoleId = callcenterAgentRoleId;
        insert testUserDelhi;
        
        //Create a test city record for Delhi
        Service_Centre_City__c sccDelhi = new Service_Centre_City__c();
        sccDelhi.Name = 'Test City';
        sccDelhi.Service_Centre_Name__c = testUserDelhi.Id;
        //insert sccDelhi;
        
        //Create a test user record for Chennai
        User testUserChennai = new User();
        testUserChennai.FirstName = 'Test';
        testUserChennai.LastName = 'Call Center User Chennai';
        testUserChennai.Username = 'test.call.center.user.chennai@sukam.com';
        testUserChennai.Email = 'test.call.center.user.chennai@sukam.com';
        testUserChennai.Alias = 'testmal';
        testUserChennai.EmailEncodingKey = 'UTF-8';
        testUserChennai.LanguageLocaleKey = 'en_US';
        testUserChennai.LocaleSidKey = 'en_US';
        testUserChennai.TimeZoneSidKey = 'America/Los_Angeles';
        testUserChennai.ProfileId = callcenterProfileId;
        testUserChennai.UserRoleId = callcenterAgentRoleId;
        insert testUserChennai;
        
        //Create a test city record for Chennai
        Service_Centre_City__c sccChennai = new Service_Centre_City__c();
        sccChennai.Name = 'Test City';
        sccChennai.Service_Centre_Name__c = testUserChennai.Id;
        //insert sccChennai;
        
        //Create the case to test the trigger.
        Service_Request__c case1 = new Service_Request__c();
        
        case1.Service_Centre_City__c = sccDelhi.Id;
        //insert case1;

        case1.Service_Centre_City__c = sccChennai.Id;
        //update case1;
        
        
    }
}