public class ContractOverrideCtrl {
    Contracts__c srRecord;
    
    public ContractOverrideCtrl(ApexPages.StandardController ctrl) {
        srRecord = (Contracts__c)ctrl.getRecord();
        
    }
    
    public PageReference srRedirect() {
        srRecord = [select Status__c from Contracts__c where id = :srRecord.id];
        User u = [select Profile.Name from User where id = :UserInfo.getUserId()];
        
        if(srRecord.Status__c != null && srRecord.Status__c.equals('Activated') && !u.Profile.Name.equals('System Administrator')) {
            PageReference pgRef = new PageReference('/apex/ContractDetail?id=' + srRecord.id);
            pgRef.setRedirect(true);
            return pgRef;
        } else {
            PageReference pgRef = new PageReference('/' + srRecord.id + '?nooverride=1');
            pgRef.setRedirect(true);
            return pgRef;
        }
    }
}