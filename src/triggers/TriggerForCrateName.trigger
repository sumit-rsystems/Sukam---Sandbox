trigger TriggerForCrateName on Enquiry__c(before insert) {
    
    for(Enquiry__c c : trigger.new){
        if(c.Salutation__c != null && !(c.Name.contains(c.Salutation__c))){
            c.Name = c.Salutation__c +' '+ c.Name ;
        }
    }
}