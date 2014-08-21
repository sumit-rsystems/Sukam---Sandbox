public class errorPageCtr {
  
  public String orderNo{get; set;}
  
  public errorPageCtr()
  {
    orderNo=ApexPages.currentPage().getParameters().get('id');
  }
  
  public pagereference viewOrder()
  {
    PageReference pg=new PageReference('/apex/viewOrderPage?id='+orderNo);
    pg.setRedirect(true);
    return pg;
  }
  
}