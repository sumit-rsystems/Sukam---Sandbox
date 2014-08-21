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

trigger trgSendSMSOld on Case (after insert,after update)
{
    try
     {
      //declarations
      List<String> numList=new List<String>();
      List<String> msgList=new List<String>();
      List<List<String>> mainNumList=new List<List<String>>();
      List<List<String>> mainMsgList=new List<List<String>>();
      Set<Id> contId=new Set<ID>();
      Map<ID,Id> mapOfCasenCont=new Map<ID,Id>();
      Map<Id,Contact> mapOfContnCont=new Map<Id,Contact>();
      List<List<Id>> mainCaseIDList=new List<List<Id>>();
      List<Id> caseIdList=new List<Id>();
      
      //getting the set of all account Id's for trigger.new
      for(Integer i=0;i<trigger.new.size();i++)
      {
        contId.add(trigger.new[i].contactId);
      }
      
      //querying the accounts in the set of Account Id's
      List<Contact> conList=new List<Contact>();
      conList=[select Id,MobilePhone,DoNotCall from Contact where Id in: contId];
      
      //creating a map of Case Id and the corresponding Account Id
      for(Integer i=0;i<trigger.new.size();i++)
      {
        mapOfCasenCont.put(trigger.new[i].Id,trigger.new[i].ContactId);
      }
      
      //creating a map of Account Id and the corresponding Accounts
      for(Integer i=0;i<conList.size();i++)
      {
        mapOfContnCont.put(conList[i].Id,conList[i]);
      }
      
      Integer j=0;
      Integer count=0;
      
      //the outer loop loops to a maximum of 10 times and the inner loop makes 10 loops, there by making a list of lists. (10 x 10=100) calls can be thus made.
            
      for(Integer i=0;i<10 && i<trigger.new.size();i++)
      {
        String msg;
        Integer flag=0;
        Contact thiscont=new Contact();
        thiscont=mapOfContnCont.get(mapOfCasenCont.get(trigger.new[i].Id));
                
        if(thiscont.DoNotCall==true)
        {
            flag=1;
        }
        
        if(trigger.isupdate)
        {
           System.debug('old>>>>'+trigger.old[i].Status);
           System.debug('new>>>>'+trigger.new[i].Status);
           
           if(trigger.new[i].Status=='Closed' && trigger.old[i].Status!='Closed')
           {
              msg='Your complaint no.'+ trigger.new[i].FSR_No__c +' has been resolved. We wish you happy usage of Su-Kam product. For more details, pl log on to www.su-kam.com';
           }
           else
           {
              flag=1;
           }            

                       
        }
        
        if(trigger.isinsert)
        {
           msg='Thank you for calling Su-Kam. Your complaint has been registered with us vide no. '+ trigger.new[i].FSR_No__c +' date '+System.now().format('dd/MM/yyyy h:mm a');
        }
        
        if(flag==0)
        {
            System.debug('inside flag=0');
            msgList=new List<String>();
            numList=new List<String>();
            count=j+10;
            
            for(;j<count && j<trigger.new.size();j++)
            {
                System.debug('inside inner for loop');
                
                if(thiscont!=NULL && thiscont.MobilePhone!=NULL)
                {
                  System.debug('inside if');
                  //creating a sublist of 10 elements
                  numList.add(thiscont.MobilePhone);
                  msgList.add(msg);
                  caseIdList.add(trigger.new[i].Id);
                }
            }
            //creating a list of list that can take upto 10 lists(10x10=100)
            mainNumList.add(numList);
            mainMsgList.add(msgList);
            mainCaseIDList.add(caseIdList);
            
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
            sendSMScls.sendSMS(mainNumList[i],mainMsgList[i],mainCaseIdList[i],TRUE);
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