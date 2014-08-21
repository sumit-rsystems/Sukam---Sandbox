public with sharing class Paginate {
    public Integer pageNumber {get;set;}
    public Integer pageSize {get;set;} 
    public Integer totalPageNumber {get;set;}
    public String firstString {get;set;}
    public String lastString {get;set;}
          
    public boolean IsSearchResult {get;set;}
    public  List<searchEngineItem> pageResultItems {get;set;}
    public  List<searchEngineItem> searchResultItems {get;set;}
    
    public Paginate(){
        IsSearchResult = false;
        pageResultItems = new List<searchEngineItem>();
        searchResultItems = new List<searchEngineItem>();
        
        pageNumber = 0;
        pageSize = 100;           //CHANGE HERE
        totalPageNumber = 0;
        firstString = '<<First';
        lastString = 'Last>>';
    }               
        public void inititateBind(){                                            
            BindData(1);
            pageSize = 100;       //CHANGE HERE

            totalPageNumber = searchResultItems.size() / pageSize;
    
            Integer mod = searchResultItems.size() - (totalPageNumber * pageSize);
            if (mod > 0)
                totalPageNumber++;               
        }

            public pageReference firstBtnClick(){
                    BindData(1);
                    return null;        
            }

            public PageReference lastBtnClick(){
                BindData(totalPageNumber);
                return null;        
            }

            /*Decides if Previous button for paginations should be enabled or not.*/    
            public Boolean getPreviousButtonEnabled(){
                return (pageNumber > 1);
            }
            
            /*Decides if Next button for paginations should be enabled or not.*/    
            public Boolean getNextButtonEnabled(){       
                if (IsSearchResult && searchResultItems == null) 
                    return false;
                else
                    return ((pageNumber * pageSize) < searchResultItems.size());
            }
               
            public Boolean getFirstButtonEnabled(){       
                return (pageNumber > 1);
            }
            
            public Boolean getLastButtonEnabled(){
                if (IsSearchResult && searchResultItems == null) return false;
                else
                    return ((pageNumber * pageSize) < searchResultItems.size());
            }   
    
            /*helper method for pagination of the result records.*/
            public void BindData(Integer newPageIndex){
                try{           
                    if(IsSearchResult)
                        pageResultItems = new List<searchEngineItem>();
                            
                    Transient Integer counter = 0;
                    Transient Integer min = 0;
                    Transient Integer max = 0;
                    
                    if (newPageIndex > pageNumber && newPageIndex != totalPageNumber){                   
                        min = pageNumber * pageSize;
                        max = newPageIndex * pageSize;
                    }
                    else{                
                        max = newPageIndex * pageSize;
                        min = max - pageSize;
                    }                                 
                    
                    if (IsSearchResult){
                        for(searchEngineItem s : searchResultItems){
                            counter++;
                            if (counter > min && counter <= max)                                      
                                pageResultItems.add(s);
                                                               
                        }
                    }
                    
                               
                    pageNumber = newPageIndex;
                    
                }
                catch(Exception ex){
                    //Utilities.addPageMessage(ex.getMessage(),true);
                }
            }
         /*Prepares the pagination data on Next button click.*/
        public PageReference nextBtnClick() {
            BindData(pageNumber + 1);
            return null;
        }

        /*Prepares the pagination data on Next button click.*/
        public PageReference goToPage() {
            if(pageNumber > totalPageNumber)
                pageNumber=1;
            BindData(pageNumber);
            return null;
        }
   
        /*This method resets the default page size. Number of Products to be displayed on VF page.*/
        public PageReference resetPageSize() {
            totalPageNumber = searchResultItems.size() / pageSize;
            Integer mod = searchResultItems.size() - (totalPageNumber * pageSize);
            if (mod > 0)
                totalPageNumber++;  
            BindData(1);
            return null;
        }
        
        /*Prepares the pagination data on Next button click.*/
        public PageReference previousBtnClick() {
            BindData(pageNumber - 1);
            return null;
        }    
/************* Pagination code ENDS ******************************* */  
    
    
        
}