global class ClassToSendEmail 
{
   
  public void send(String orderId,String orderName,List<String> toAddresses,String typeOfMail)
  {
      orderName=[select Id,Name from Order__c where Id=:orderId limit 1].Name;
      
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(toAddresses);
      mail.setSubject('Order');
      if(typeOfMail=='Submitted')
        mail.setHtmlBody('<html><body><p>Dear Sir/Madam,</p><p><b>Please find attached the details of the submitted order : '+orderName+'</b></p><br/><p>Regards</p><p><b>Su-Kam Power Systems Ltd.</b></p></body></html>');
      else if(typeOfMail=='Onhold')
        mail.setHtmlBody('<html><body><p>Dear Sir/Madam,</p><p><b>The order : '+orderName+' has been put On-hold</b></p><br/><p>Regards</p><p><b>Su-Kam Power Systems Ltd.</b></p></body></html>');
      else
        mail.setPlainTextBody('Invalid');
      //mail.setPlainTextBody('Your Order: ' + OrderName +' ');

      //attach the PDF 
      Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();     
      
      String pg;
      
      System.debug('sendmail order id>>>'+orderID);
      if(typeOfMail=='Onhold')
      { 
      	System.debug('onhold');     
        pg='/apex/orderPagePDF?id='+orderId+'&mail=true&type=pdf';
        //pg='/apex/viewOrderPage?id='+orderId+'&mail=true&type=pdf';
      }
      else 
        pg='/apex/orderPagePDF?id='+orderId+'&mail=true&type=pdf';
      PageReference pageRef1 = new PageReference(pg);  
      //pageRef1.setRedirect(true);
      
      Blob blobofpdf = Blob.valueOf('BLAHBLAH');
      
      if(toAddresses.size() > 0 && toAddresses[0] != 'aaa@bbb.ccc')
      {
      	 
           blobofpdf = pageRef1.getContent();
        
      }
      
      
      
      // Set name of PDF
      attach.setFileName('Order.pdf'); 
      
      attach.setBody(blobofpdf);         
      
      mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach}); 
   
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      
  }
  
}