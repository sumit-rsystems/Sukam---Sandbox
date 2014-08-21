@isTest
public class ProductController_Test{
    public static testMethod void getCoverage(){
    
        Product__c prd = new Product__c (
            Name = 'test',
            Category_Code__c = 'test1',
            Category_Description__c = 'test2',
            Product_Description__c = 'test3',    
            Product_Code__c = 'test4'
        );
        insert prd;
        
        Standard_Price__c sp = new Standard_Price__c(
            Products__c = prd.id,
            Standard_Price__c = 0,
            Active__c = true
        );
        insert sp;
        
    ApexPages.currentPage().getParameters().put('Id',sp.Id);
    ApexPages.StandardController con = new  ApexPages.StandardController(sp);
    ProductController pc = new ProductController(con);
    
    pc.doSave();
    pc.doCancel();
    
    ApexPages.currentPage().getParameters().put('Id',null);    
    ApexPages.currentPage().getParameters().put('pid',prd.id);
    ApexPages.currentPage().getParameters().put('type','new');
    pc = new ProductController(con);
    pc.doSave();
    pc.doCancel();
    
    
    
       
        
    }
}