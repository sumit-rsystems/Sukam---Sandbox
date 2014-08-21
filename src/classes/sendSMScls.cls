/*
        -----------------------------------------
        CREATED BY      : Lister Technologies.
        CREATED ON      : 27/01/2010
        CREATED PURPOSE : Class sendSMScls that makes the web service callout
                          which sends an SMS to the phone number of the Account
                          with the message in the description of the Case.
        -----------------------------------------
                                                   */

global class sendSMScls
{
  
  //declaring the future method                                                 
  @future (callout=true)
  global static void sendSMS(List<String> numArray,List<String> msgArray,List<Id> caseIdList,List<String>FSRList,Boolean flag)
  {
      //declarations
      HTTPRequest req=new HTTPRequest();
      Http http=new HTTP();
      HTTPResponse res=new HTTPResponse();
      
      System.debug('numArray======'+numArray);
      
        for(Integer i=0;i<numArray.size() && i<10;i++)
        {
         //try is only for this loop so that even if one callout fails the rest get executed
         try
         {
                 
              String newmsgArray;
              String FSRArray;
              newmsgArray = msgArray[i].replace('(','').replace(')','');
              FSRArray=FSRList[i].replace('(','').replace(')','');
             // if(msgArray[i].contains(' '))
             // {
                 //for displaying spaces, the spaces are replaced by %20 which is the equivalent for space in a URL
               //  newmsgArray=msgArray[i].replaceAll(' ','%20');
             // }
              
               
              if(flag)
              { 
                   //making the web service callout
                   //String URL='http://cosmos.air2web.co.in/failsafe/HttpPublishLink?pcode=HTMEDIA&acode=HTSUKAM&mnumber='+numArray[i]+'&message='+newmsgArray+'&pin=hsk49';
                   // New URL : 10-01-2010 (dd-mm-yyyy)
                                      
                   //String URL='http://124.153.79.194:13007/cgi-bin/sendsms?username=sukam&password=01clP5G&to='+numArray[i]+'&text='+newmsgArray+'&dlr-mask=31';
                   
                   //New URL : 17-02-2011 (dd-mm-yyyy)
                   //String URL='http://sendsms.htmobiles.in/cgi-bin/sendsms?username=sukam&password=01clP5G&to='+numArray[i]+'&text='+newmsgArray+'&dlr-mask=31';
                   
                   //New URL: 9-10-2012
                   //String URL= 'http://124.153.79.193/smsapi/smsproducer.php?username=sukam&password=01clP5G&to='+numArray[i]+'&from=SUKAMC&text='+newmsgArray;
                    //String URL= 'http://www.smsjust.com/blank/sms/user/urlsmstemp.php?username=sukam&pass=123456&senderid=SUKAMP&dest_mobileno='+numArray[i]+'&tempid='+newmsgArray+'&F1='+FSRList+'&response=Y';
                                        String URL= 'http://www.smsjust.com/blank/sms/user/urlsmstemp.php?username=sukamtrans&pass=123456&senderid=SUKAMP&dest_mobileno='+numArray[i]+'&tempid='+newmsgArray+'&F1='+FSRArray+'&F2='+System.now().format('dd/MM/yyyy h:mm a')+'&response=Y';
                                        system.debug('URL@@@'+URL);
                   req.setEndpoint(URL);
                   req.setMethod('GET');
                   req.setTimeout(60000);
                   System.debug('req======'+req);
                   res = http.send(req);
                   system.debug('---Response: ' + res + '---');
                   system.debug('BODY: '+res.getBody());   
              }
              
               //creating a task for the Case upon sending the msg to the number
               Task taskForCase=new Task();
               taskForCase.Status='Completed';
               taskForCase.Subject='Other';
               taskForCase.WhatId=caseIdList[i];
               String comments='An sms was sent to the number '+numArray[i]+' with content '+msgArray[i];
               taskForCase.Description=comments;
               
               insert taskForCase;                
                          
           }//try
           catch(Exception e)
           {
              System.debug('Caught the exception'+e);
           }
        }//for 
  }//future method
   
      
  
}//main class