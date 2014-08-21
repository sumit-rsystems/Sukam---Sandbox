public class CMTNewOverrideController {

    
    public CMTNewOverrideController(ApexPages.StandardController controller){
        this.controller=controller;
    }

    public pagereference redirt(){
        //string URL;
        PageReference pgref;
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Component_Movement_Table__c'];
        Map<Id,string> visualRecordTypes = new Map<Id,string>{};
        for(RecordType rt: rtypes){
            visualRecordTypes.put(rt.Id,rt.Name);
        }    
        
        string recid=Apexpages.currentPage().getparameters().get('Recordtype');
        
        if(visualRecordTypes.get(recid) == 'Product Sale'){
             return new pagereference('/apex/Create_Product_Sales?retURL='+objectKeyPrefix());
        } else{
             String srname = Apexpages.currentPage().getparameters().get('CF00N90000003PMGJ');
             String srid = Apexpages.currentPage().getparameters().get('CF00N90000003PMGJ_lkid');
             
             String url = '/'+objectKeyPrefix()+'/e?nooverride=1&RecordType='+Recid;
             
             if(srname != null && srid != null && !srname.equals('') && !srid.equals('')) {
                 String servReq = '&CF00N90000003PMGJ=' + srname + '&CF00N90000003PMGJ_lkid=' + srid;
                 url += servReq;
                 url += + '&retURL='+srid;
             } else {
                 url += '&retURL='+objectKeyPrefix();
             }
             return new pagereference(url);
        }
         
    }
          
      public String objectKeyPrefix() {
          String prefix = Component_Movement_Table__c.SObjectType.getDescribe().getKeyPrefix();
          return prefix;
      } 
    private final ApexPages.StandardController controller; 
    
}