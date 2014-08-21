public class successPageController {

  public String orderNo{get; set;}
  
  public successPageController ()
  {
    orderNo=[select Id,Name from Order__c where Id=:ApexPages.currentPage().getParameters().get('orderNo')].Name;
    
  }
  
  public PageReference back()
  {
    Schema.DescribeSObjectResult info = Order__c.SObjectType.getDescribe();
    String userPrfix = info.getKeyPrefix ();
    return (new PageReference('/'+userPrfix + '/o'));
  }
}