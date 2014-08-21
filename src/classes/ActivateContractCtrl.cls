public class ActivateContractCtrl {

    public Contracts__c contractObj;
    
    public activateContractCtrl(ApexPages.StandardController ctrl) {
        contractObj = (Contracts__c)ctrl.getRecord();
    }
    
    public PageReference updateContract() {
        contractObj.Status__c = 'Activated';
        contractObj.Activated_By__c = UserInfo.getUserId();
        contractObj.Activated_Date__c = System.now();
        update contractObj;
        return new PageReference('/' + contractObj.id);
    }
}