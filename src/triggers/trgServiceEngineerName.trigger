trigger trgServiceEngineerName on Service_Request__c(before Insert, before Update) {

    If(Trigger.new.size()==1)
    {
        If(Trigger.new[0].Service_Engineer_Assigned__c!=Null)
        Trigger.new[0].Service_Engineer_Name__c = [Select Service_Engineer_Name__c from Stock_Point__c where Id = :Trigger.new[0].Service_Engineer_Assigned__c].Service_Engineer_Name__c;
        
    }
}