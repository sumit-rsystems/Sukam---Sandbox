public class OpenServiceRequest{
    public Service_Request__c srObj {get;set;}
    public String selectedStatus{get;set;}
    String srId;
    
       
    public OpenServiceRequest(ApexPages.StandardController controller){
        srId = ApexPages.currentPage().getParameters().get('id');
        srObj  = new Service_Request__c();
        if(srId != null && srId != '')
            srObj = [Select s.id, s.Status__c,ClosedDate__c,Product_Serial_No__c  
                     From Service_Request__c s where id =:srId ];
         
    }
    
    public List<SelectOption> getOptions(){
        List<SelectOption> option = new List<SelectOption>();
        option.add(new SelectOption('','None' ));
        option.add(new SelectOption('ReOpen', 'ReOpen'));
        return option;
    }
    
    public pageReference doSave(){
        system.debug('selectedStatus======'+selectedStatus);
       DateTime dt = srObj.ClosedDate__c.addDays(3);
       // system.debug('+++HI'+dt);
       if(dt>=system.now())
       { 
         // system.debug('+++in If'+dt);
            if(selectedStatus!= null && selectedStatus!= ''){
                srObj.Status__c = selectedStatus;
                srObj.ClosedDate__c = system.now();
            }
            else
            {
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Please Select Status.');
                ApexPages.addMessage(message);
                return null;        
            }
        
            try{
                update srObj;
            }Catch(Exception e){
            system.debug('----error----'+ e.getMessage());
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,e.getMessage());
            ApexPages.addMessage(message);
            return null;
            }
        }
        pageReference page = new pageReference('/'+srObj.id);
        page.setRedirect(true);
        return page;
    }
    
    public pageReference doCancel(){
        pageReference page = new pageReference('/'+srObj.id);
        page.setRedirect(true);
        return page;
    }
}