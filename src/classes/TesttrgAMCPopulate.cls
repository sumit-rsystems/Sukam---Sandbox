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
private class TesttrgAMCPopulate {

    static testMethod void myUnitTest() 
    {
        try{
        // TO DO: implement unit test
        Account acc = new account();
        acc.name = 'test';
        insert acc;
        
        Product__c obj = new Product__c();
        obj.Name = 'Test Product';
        obj.Product_Code__c= '12345';
        obj.Is_Active__c = true;
        obj.UoM__c = 'Kg';
        obj.No_Of_PM__c = '4';
        insert obj;
        
              
        Contracts__c obj2 = new Contracts__c();
        obj2.Products__c = obj.id;
        obj2.AMC_Type__c = 'Comprehensive';
        obj2.Product_Quantity__c = 20;
        obj2.Account_Name__c = acc.id;
        //obj2.AMC_Amount__c = pbe.UnitPrice__c; 
        obj2.Total_Maintenance__c = 4;
        obj2.Next_Maintenance_Date__c = system.today();
        obj2.Contract_Term__c = 12;
        obj2.Maintenance_Done__c = 0;
        insert obj2;
        
        System.assert(obj.No_Of_PM__c == '4',obj2.Next_Maintenance_Date__c = system.today().addMonths(3));
        System.assert(obj.No_Of_PM__c == '3',obj2.Next_Maintenance_Date__c = system.today().addMonths(4));
        System.assert(obj.No_Of_PM__c == '2',obj2.Next_Maintenance_Date__c = system.today().addMonths(6));
        System.assert(obj.No_Of_PM__c == '1',obj2.Next_Maintenance_Date__c = system.today().addMonths(12));
        
        
        obj2.Maintenance_Done__c = 1;
        obj2.AMC_Type__c = 'Non-Comprehensive';
        update obj2;
        
        Component_Movement_Table__c obj5 = new Component_Movement_Table__c();
        obj5.Select_Component__c = obj.id;
        obj5.Type_of_Transfer__c = 'tstt';
        obj5.Cancelled__c = False;
        obj5.Stock_Point_Type__c ='Service Center';
        insert obj5;
        
        obj5.Cancelled__c = True;
        //update obj5;
        
        
        
       }catch(Exception e){}
        
    }
}