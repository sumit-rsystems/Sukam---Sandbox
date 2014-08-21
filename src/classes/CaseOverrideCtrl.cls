public class CaseOverrideCtrl {
    Service_Request__c srRecord;
    
    public CaseOverrideCtrl(ApexPages.StandardController ctrl) {
        srRecord = (Service_Request__c)ctrl.getRecord();
        
    }
    
    public PageReference srRedirect() {
        srRecord = [select Status__c from Service_Request__c where id = :srRecord.id];
        User u = [select Profile.Name from User where id = :UserInfo.getUserId()];
        
        if(srRecord.Status__c != null && srRecord.Status__c.equals('Closed') && !u.Profile.Name.equals('System Administrator')) {
            PageReference pgRef = new PageReference('/apex/CaseDetail?id=' + srRecord.id);
            pgRef.setRedirect(true);
            return pgRef;
        } else {
            PageReference pgRef = new PageReference('/' + srRecord.id + '?nooverride=1');
            pgRef.setRedirect(true);
            return pgRef;
        }
    }
}