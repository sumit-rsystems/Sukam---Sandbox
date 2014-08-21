trigger trgGetProductCategory on Service_Request__c (before insert,before update)
{
  //Save Product category on the basis of Product selection
  string Prod = trigger.new[0].Products__c ;
  Product__c objProduct = [select Product_Category__c from Product__c where id =: Prod];
  trigger.new[0].Product_Category__c = objProduct.Product_Category__c;
}