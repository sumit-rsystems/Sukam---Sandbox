/*
        -----------------------------------------
        CREATED BY      : Lister Technologies.
        CREATED ON      : 27/01/2010
        CREATED PURPOSE : Trigger(after insert) that makes a call to the future method sendSMS
                          of the class sendSMScls that makes the web service callout
                          which sends an SMS to the phone number of the Account
                          with the message in the description of the Case.
        -----------------------------------------
                                                   */

trigger trgSendSMS on Service_Request__c(after insert,after update)
{

  //declarations
  List<String> numList=new List<String>();
  List<String> msgList=new List<String>();
  List<String> FSRList =new List<String>();
  List<List<String>> mainNumList=new List<List<String>>();
  List<List<String>> mainMsgList=new List<List<String>>();
List<List<String>> mainFSRList=new List<List<String>>();
  Set<Id> accIdSet = new Set<ID>();
  Map<ID,Id> mapOfCasenAccount = new Map<ID,Id>();
  List<List<Id>> mainCaseIDList=new List<List<Id>>();
  List<Id> caseIdList=new List<Id>();
      
  try
  {
      //getting the set of all account Id's for trigger.new
      for(Integer i=0;i<trigger.new.size();i++)
      {
        accIdSet.add(trigger.new[i].Account__c);
        mapOfCasenAccount.put(trigger.new[i].Id,trigger.new[i].Account__c);
      }
      
      Map<Id,Account> mapAccount = new Map<Id,Account>([select Id,PersonMobilePhone,Phone,PersonDoNotCall from Account where Id in: accIdSet]);
      
      
      //the outer loop loops to a maximum of 10 times and the inner loop makes 10 loops, there by making a list of lists. (10 x 10=100) calls can be thus made.
      for(Integer i=0;i<10 && i<trigger.new.size();i++)
      {
          Integer j=0;
          Integer count= j+10;
          
          for(;j<count && j<trigger.new.size();j++)
          {
                String msg;
                Integer flag=0;
                Account thisAccount = new Account();
                thisAccount = mapAccount.get(mapOfCasenAccount.get(trigger.new[j].Id));
                System.debug('thisAccount ===='+thisAccount);   
                
                if(thisAccount !=null && thisAccount.PersonDoNotCall==true){
                        flag = 1 ;
                }            
                
                if(trigger.isupdate)
                {
                       System.debug('old>>>>'+trigger.old[i].Status__c);
                       System.debug('new>>>>'+trigger.new[j].Status__c);
                       
                       if(trigger.new[j].Status__c=='Closed' && trigger.old[i].Status__c!='Closed')
                       {
                          msg='19223';
                       }
                       else
                       {
                          flag=1;
                       }            
                }else if(trigger.isinsert){
                       msg='19224';
                }
                
        System.debug('msg===='+msg);
        if(flag==0)
        {
            System.debug('inside flag=0');
            msgList=new List<String>();
            numList=new List<String>();
            count=j+10;
            System.debug('inside inner for loop');
            
            if(thisAccount!=NULL && thisAccount.PersonMobilePhone!=NULL)
            {
                  System.debug('inside if');
                  //creating a sublist of 10 elements
                  numList.add(thisAccount.PersonMobilePhone);
                  msgList.add(msg);
                  caseIdList.add(trigger.new[j].Id);
                  FSRList.add(trigger.new[j].FSR_No__c);
            }
         }
         //creating a list of list that can take upto 10 lists(10x10=100)
         mainNumList.add(numList);
         mainMsgList.add(msgList);
         mainCaseIDList.add(caseIdList);
         mainFSRList.add(FSRList);
        }//if flag==0
      }//for trigger.new
      
      if(mainNumList.size()>0 && mainMsgList.size()>0 && mainNumList.size()==mainMsgList.size())
      {   
        //this can make upto a maximum of 10 future calls, each call passing an list of 10(max) values(number,msg and Case Id)
        if(staticClass.staticFlag==0)  
        { 
          for(Integer i=0;i<10 && i<mainNumList.size();i++)
          {
            System.debug('>>>>>>');
            System.debug(mainNumList[i]);
            System.debug(mainMsgList[i]);
            System.debug(mainCaseIdList[i]);
            sendSMScls.sendSMS(mainNumList[i],mainMsgList[i],mainCaseIdList[i],mainFSRList[i],TRUE);
          }
         
        }
        staticClass.staticFlag=1;
      }
    }//try
    catch(Exception e)
    {
      System.debug('caught the exception'+e);
    }

}