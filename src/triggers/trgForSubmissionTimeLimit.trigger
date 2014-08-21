trigger trgForSubmissionTimeLimit on Order__c (before update,before insert)
{
  if(trigger.isupdate)
  {
    if(trigger.new[0].Order_Status__c!=NULL && trigger.old[0].Order_Status__c!=NULL)
    {
      if(trigger.new[0].Order_Status__c=='Submitted' && trigger.old[0].Order_Status__c!='Submitted')
      {
        trigger.new[0].submitted_time__c=System.now();
      }
    }  
  }
  if(trigger.isinsert)
  {
    if(trigger.new[0].Order_Status__c!=NULL)
    {
      if(trigger.new[0].Order_Status__c=='Submitted')
      {
         trigger.new[0].submitted_time__c=System.now();
      }
    }
  }

}