public class Util {
    
    public static Escalation_Settings__c escSettings() {
        Escalation_Settings__c record = Escalation_Settings__c.getValues('Escalation');
        return record;
    }
    
    public static void sendNotification(List<String> toAddresses, List<String> ccAddresses, Id targetObjId) {
        Escalation_Settings__c record = Util.escSettings();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {toAddress};
        email.setTargetObjectId(targetObjId);
        email.setToAddresses(toAddresses);
        email.setCcAddresses(ccAddresses);
        List<EmailTemplate> templateList = [Select Name, Id From EmailTemplate where Name = :record.Template_Name__c]; 
        if(templateList != null && templateList.size() > 0)
            email.setTemplateId(templateList[0].id);  
         
        email.setSaveAsActivity(false);
        Messaging.SendEmailResult[] sendResult;
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }catch(Exception e){
        }
    }
}