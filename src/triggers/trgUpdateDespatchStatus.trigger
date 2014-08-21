trigger trgUpdateDespatchStatus on Order_Despatch__c (after insert)
{
  List<Order_despatch__c> dispatchList=new List<Order_despatch__c>();
  
  if(trigger.new[0].Order_line_Item__c!=NULL)
  {
    System.debug('trg>>>>>>>>>>>'+trigger.new[0].Order_line_Item__c);
    System.debug('trg>>>>>>>>>>>'+trigger.new[0].Order_line_Item__r.Order__c);
    
    Order_Line_Item__c thisOrderLineItem=[select Id,Order__c from Order_Line_Item__c where Id=:trigger.new[0].Order_line_item__c limit 1];
    
    if(thisOrderLineItem!=NULL)
    {
      if(thisOrderLineItem.Order__c!=NULL)
      {
         Order__c thisOrder=[select Id,dispatch_Status__c from Order__c where Id=:thisOrderLineItem.Order__c limit 1];
         dispatchList=[select Id from Order_Despatch__c where Order_Line_Item__r.Order__c =: thisOrder.Id];
         System.debug(dispatchList.size());
         if(dispatchList.size()>0)
         {
           System.debug('>>>>>>>>>>>>>.');
           if(thisOrder.dispatch_status__c=='Pending')
           {
             System.debug('here');
              thisOrder.Dispatch_Status__c='In-Transit';
              update thisOrder;
           }
           
         }
      }
    }  
  }
  

}