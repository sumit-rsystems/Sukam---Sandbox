@isTest
public class TestsuccessPageController{
    public static testMethod void getCodeCoverage(){
        Order__c order = new Order__c(
            Order_Status__c = 'draft'
            
        );
        insert order ;      
        ApexPages.currentPage().getParameters().put('orderNo', order.id);
        successPageController  spc = new successPageController();
        spc.back();
    }
}