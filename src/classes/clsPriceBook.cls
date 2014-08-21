//Price book controller for the pages 
public class clsPriceBook {
    
    //Price book custom object with a list
    private list<Price_Book__c> pbs = new list<Price_Book__c>() ; 
    
    //Aggregate Result that will be used to find the distinct values
    private List<AggregateResult> catData = new List<AggregateResult>();
    
    //User Object which specifies the state
    private User usrData = new User();  
    
    //Customer Price Book class that contains the data for the pages
    public class custPriceBook{
        //Price book object
        public Price_Book__c pb {get; set;}
        
        public String strEffDate {get; set;}
        
        //The the last field's value (might be a dealer price, MRP, etc.,)
        public Decimal currFieldValue {get; set;}
        
        //The Serial number for the list
        public Integer sno {get; set;}
        
        //A constructor for the price book
        public custPriceBook() {
            pb = new Price_Book__c(); 
        }
    }
    
    //If any individual price is selected or all the prices are selected
    //Design Impact. A very late request
    //public boolean IndivSelect {get; set;}
    
    //Change of design as per the request from Ronjay
    public boolean blevel1Sel {get; set;}
    public boolean blevel2Sel {get; set;}
    public boolean blevel3Sel {get; set;}
    
    //Boolean that sets when the selected product category is 'All'
    public boolean allProdCatSelected {get;set;}
    
    //If the product category is required for the display
    public boolean bwantProd {get; set;}

    //If the IO Param is required for the display
    public boolean bIOParam {get; set;}
    
    //All the catalogues that need to be added which are distinct       
    public List<SelectOption> getAllCats() {
        
        //Selection options that will return the value
        List<SelectOption> options = new List<SelectOption>();
        
        try {
            //Bring in all the Product details
            options.add(new SelectOption('All','All'));         
            
            //Aggregate Result that will be pooled      
            for(AggregateResult agr: catData) {
                
                //Aggregate Result that will be pooled  
                String tmpString =  (String) agr.get('cat');
                
                //All the categories that need to be displayed
                options.add(new SelectOption(tmpString, tmpString));
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL,'Error occurred - '+e.getMessage()));
        }
        return options;
    }
    //All the price types that need to be displayed
    public List<SelectOption> getAllPriceTypes() {
        //selection options that will return the value
        List<SelectOption> options = new List<SelectOption>();
        try{        
            //Options currently hardcoded so that it can be changed in the near future
            options.add(new SelectOption('All','All'));
            options.add(new SelectOption('DiP','Distributor Price'));
            options.add(new SelectOption('DP','Dealer Price'));
            
            //  Commenting as per the mail by Ronjay on 3rd March 2010
            //  Adding back on 29th March 2010 on request by Ronjay
            options.add(new SelectOption('MP','MRP'));
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL,'Error occurred - '+e.getMessage()));
        }
        
        return options;
    }
    //The selected product catalogue
    public String SelProdCats {get; set;}
    //The selected Price Type
    public String SelPriceType {get; set;}
    //The The Selected Price List line that will be used in the PDF
    public String SelPriceListLine {get; set;}
    
    //The Selected field which says what kind of the price type selected
    public String SelFieldLabel {get; set;}
    
    //The Selected record's Reference code
    public String SelRefCode {get; set;}  
    
    public String SelEffDate {get; set;}
    
    //The List of the custom price book controller class
    public List<custPriceBook> custPBooks {get; set;}
    
    //The Constructor  
    public clsPriceBook() {
        try {
            //The List is kept clear at all times
            clearCustPriceBook();
            //The Reference code is empty during the start
            SelRefCode = '';
            
            //We assume that the allow is false in the begining
            //All the other booleans are also false
            Boolean bAllow = false;
            bwantProd = false;
            blevel1Sel = false;
            blevel2Sel = false;
            blevel3Sel = false;
            
            //The below parameters will be used for the PDF Pages
            String skip = ApexPages.currentPage().getParameters().get('skip');
            String cat = ApexPages.currentPage().getParameters().get('cat');
            String pType = ApexPages.currentPage().getParameters().get('Pty');
            
            //Skip to specify this is a pdf; Cat and Ptype to check if it is not a manual URL
            if(skip!='1' && (cat==null || pType==null)) {
                bAllow = true;
            }
            
            //The current User Data
            usrData = [SELECT
                            Id,
                            Price_Book_Name__c
                        FROM
                            User
                        Where
                            ID = :UserInfo.getUserId()
                        limit 1];
                            
            //Can I allow this?
            if(bAllow) {                        
            
                //Get all the unique catalogues 
                catData = [SELECT
                            p.Category__c cat
                        FROM
                            Price_Book__c p
                        WHERE
                            Price_Book_Name__c = :usrData.Price_Book_Name__c  
                        GROUP BY
                            p.Category__c
                        HAVING
                            COUNT(p.Category__c) >=1];
                
                //Set the field label as empty          
                SelFieldLabel = ' ';
            }
            else {
                //The product catalogue is assigned from the URL
                SelProdCats = cat;
                
                //The price type is assigned from the URL
                SelPriceType = pType;
                
                //Just need to execute the HitGo Function so flush the data
                PageReference tmpPage = this.HitGO();
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL,'Error occurred - '+e.getMessage()));
        }
                            
    }
    //Create the PDF URL
    public String getPDFUrl() {
        
        //The URL is passed with Skip as 1 to recognise the PDF
        PageReference pgRef = new PageReference('/apex/PriceBook_PDF?skip=1&cat='+SelProdCats+'&Pty='+SelPriceType);
        
        //Return the URL
        return pgRef.getUrl(); 
    }
    //Clear the Custom price book controller class
    private void clearCustPriceBook() {
        try{        
            //Clear the Custom price book controller class
            custPBooks = new List<custPriceBook>();
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL,'Error occurred - '+e.getMessage()));
        }
        
    }
    //The Go Button takes to this page
    public PageReference HitGO() {
        try { 
            //Clear the Custom price book controller class
            clearCustPriceBook();
            
            //Want to show IO Param?    
            bIOParam =false;
            
            //For filling the serial number
            Integer Counter = 1;
            //For filling the Reference code
            SelRefCode = '';
            
            //The date for the price List
            Date dtToAdd;
            
            //If More changes come, the below query will be
            //Made into a dynamic SOQL.
            if(SelProdCats=='All') {
                //Show the product categories
                bwantProd = true;   
                            
                
                //Select the data from the Price book based on the
                //chosen product catalogue and User's state         
                pbs = [SELECT
                            p.Price_Book_Name__c, 
                            p.basic__c, 
                            p.Warranty__c, 
                            p.Reference_Code__c, 
                            //p.Rating__c,                    
                            p.Name, 
                            p.Model__c, 
                            p.MRP__c, 
                            p.Id, 
                            p.Distributor__c, 
                            p.Dealer__c, 
                            //p.DC_BUS__c, 
                            p.Category__c,
                            p.Capacity__c,
                            p.Input_Output_PARAMETER__c,
                            p.Effective_Date__c
                        FROM
                            Price_Book__c p
                        WHERE
                                Price_Book_Name__c  = :usrData.Price_Book_Name__c        
                        limit 5000];                
            }
            else {
                //Do not show the product categories
                bwantProd = false;                  
                //Select the data from the Price book based on the
                //chosen product catalogue and User's state         
                pbs = [SELECT
                            p.Price_Book_Name__c, 
                            p.basic__c, 
                            p.Warranty__c, 
                            p.Reference_Code__c, 
                            //p.Rating__c,                    
                            p.Name, 
                            p.Model__c, 
                            p.MRP__c, 
                            p.Id, 
                            p.Distributor__c, 
                            p.Dealer__c, 
                            //p.DC_BUS__c, 
                            p.Category__c,
                            p.Capacity__c,
                            p.Input_Output_PARAMETER__c,
                            p.Effective_Date__c
                        FROM
                            Price_Book__c p
                        WHERE
                                Price_Book_Name__c  = :usrData.Price_Book_Name__c        
                            AND Category__c         = :SelProdCats
                        limit 5000];
            }
            
            //Loop through every list of it
            for(Price_Book__c pbTemp :pbs) {
                //New Cust Price Book
                custPriceBook cPbook = new custPriceBook();
                
                //Assign the price book object
                cPbook.pb = pbTemp;
                if(pbTemp.Effective_Date__c != null){
                    cPbook.strEffDate= pbTemp.Effective_Date__c.day()+'.'+pbTemp.Effective_Date__c.month()+'.'+pbTemp.Effective_Date__c.year();
                }
                //Assing the conter to the sno
                cPbook.sno = Counter;

                //Check for the price type and assign the respective price to the 
                //FieldValue
                if(SelPriceType=='DiP') {
                    cPbook.currFieldValue = pbTemp.Distributor__c;
                }           
                if(SelPriceType=='DP') {
                    cPbook.currFieldValue = pbTemp.Dealer__c;
                }
                if(SelPriceType=='MP'){
                    cPbook.currFieldValue = pbTemp.MRP__c;
                }
                
                //If Input Output param is not null then Input output param will be displayed
                //As per the email by Ronjay on 22 March 2010
                if(bIOParam !=true && pbTemp.Input_Output_PARAMETER__c != null) {
                        bIOParam = true;
                }
                
                //Collect each and every custom price book controller class into a list
                custPBooks.add(cPbook);
                
                //Iterate the counter so that the next serial number is got
                Counter++;
            }   
            //Check and set the Individual select boolean or reset it accordingly
            //Set the Field Label accordingly 
            if(SelPriceType=='DiP') {
                //SelFieldLabel = 'Distributor Price'; 
                //IndivSelect = true;
                blevel1Sel = true;
                blevel2Sel = true;
                blevel3Sel = false;

            }
            if(SelPriceType=='DP') {
                //SelFieldLabel = 'Dealer Price'; 
                blevel1Sel = false;
                blevel2Sel = true;
                blevel3Sel = false;

            }
            if(SelPriceType=='MP') {
                SelFieldLabel = 'MRP'; 
                blevel1Sel = false;
                blevel2Sel = false;
                blevel3Sel = false;


            }
            if(SelPriceType=='All') {
                blevel1Sel = true;
                blevel2Sel = true;
                blevel3Sel = true;
            }
            
            if(SelProdCats == 'All') 
                allProdCatSelected = true;
            else 
                allProdCatSelected = false;            

            //The Reference code for the first item
            SelRefCode = pbs[0].Reference_Code__c;
            
            //Effective date for first item
            if(pbs[0].Effective_Date__c != null)    {
                SelEffDate = pbs[0].Effective_Date__c.day()+'.'+pbs[0].Effective_Date__c.month()+'.'+pbs[0].Effective_Date__c.year();
                
                dtToAdd = pbs[0].Effective_Date__c;
            
                //The Price List line is added
                SelPriceListLine = 'PRICE LIST OF ' + pbs[0].Category__c +' FOR ' + pbs[0].Price_Book_Name__c + ' W.E.F ' + dtToAdd.day()+'.'+dtToAdd.month()+'.'+dtToAdd.year();
            }
            
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL,'Error occurred - '+e.getMessage()));
        }
        return null;
    }
    
    static testMethod void PriceBookTest()
    {
    
        clsPriceBook.custPriceBook custPB = new clsPriceBook.custPriceBook();
        
        PageReference pageRef = Page.PRm_PriceBook;
        
        Price_Book__c pb = new Price_Book__c();
        
        pb.Warranty__c = 'test warr';
        pb.Reference_Code__c = 'test ref code';
        pb.Model__c= 'test model';
        pb.MRP__c = 10000.00;
        pb.basic__c = 1000.00;
        pb.Distributor__c = 1500.00;
        pb.Dealer__c = 2000.00;
        pb.Category__c = 'All';
        pb.Capacity__c = 'test capacity';
        pb.Input_Output_PARAMETER__c = 'test IO';
        pb.Effective_Date__c = system.today();                    
        pb.ERP_Code__c='TEST'; 
        
        insert pb;
        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cat', 'Battery Equalizer');
        ApexPages.currentPage().getParameters().put('skip', '1');
        ApexPages.currentPage().getParameters().put('Pty', '1');
        
        clsPriceBook cpb = new clsPriceBook();
        cpb.getAllCats();
        cpb.getAllPriceTypes();
        cpb.getPDFUrl();
        
        cpb.HitGO();
        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cat', 'Battery Equalizer');
        ApexPages.currentPage().getParameters().put('skip', '0');
        ApexPages.currentPage().getParameters().put('Pty', '1');
        
        clsPriceBook cpb1 = new clsPriceBook();
        cpb1.getAllCats();
        cpb1.getAllPriceTypes();
        cpb1.getPDFUrl();
        
        cpb1.HitGO();       
        
        
    }
    
    static testMethod void PriceBookTest1()
    {
    
        clsPriceBook.custPriceBook custPB = new clsPriceBook.custPriceBook();
        
        PageReference pageRef = Page.PRm_PriceBook;
        
        Price_Book__c pb = new Price_Book__c();
        
        pb.Warranty__c = 'test warr';
        pb.Reference_Code__c = 'test ref code';
        pb.Model__c= 'test model';
        pb.MRP__c = 10000.00;
        pb.basic__c = 1000.00;
        pb.Distributor__c = 1500.00;
        pb.Dealer__c = 2000.00;
        pb.Category__c = 'All';
        pb.Capacity__c = 'test capacity';
        pb.Input_Output_PARAMETER__c = 'test IO';
        pb.Effective_Date__c = system.today();                    
        pb.ERP_Code__c='Test';
        
        insert pb;
        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cat', 'All');
        ApexPages.currentPage().getParameters().put('skip', '1');
        ApexPages.currentPage().getParameters().put('Pty', 'DiP');
        
        clsPriceBook cpb2 = new clsPriceBook();
        cpb2.getAllCats();
        cpb2.getAllPriceTypes();
        
        cpb2.HitGO();
        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cat', 'All');
        ApexPages.currentPage().getParameters().put('skip', '1');
        ApexPages.currentPage().getParameters().put('Pty', 'DP');
        
        /*clsPriceBook cpb3 = new clsPriceBook();
        cpb3.getAllCats();
        cpb3.getAllPriceTypes();
        
        cpb3.HitGO();*/
    }
}