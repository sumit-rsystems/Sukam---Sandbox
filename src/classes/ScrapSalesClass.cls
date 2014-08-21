public class ScrapSalesClass { 
    
    public static void populatePrice(List<Scrap_del__c> scrapList) {
        Set<Id> prodIds = new Set<Id>();
        for(Scrap_del__c scrp :scrapList) {
            prodIds.add(scrp.Select_Item_1__c);
            prodIds.add(scrp.Select_Item_2__c);
            prodIds.add(scrp.Select_Item_3__c);
            prodIds.add(scrp.Select_Item_4__c);
        }
        
        List<Price_Book_Entry__c> pbeList = [select Product__c, Price_Book__r.Name, UnitPrice__c 
                         from Price_Book_Entry__c where Product__c = :prodIds
                         and Price_Book__r.Name = 'Scrap Price'];
                         
         Map<Id, Decimal> mapProductPrice = new Map<Id, Decimal>();
         
         for(Price_Book_Entry__c pbe :pbeList) {
             mapProductPrice.put(pbe.Product__c, pbe.UnitPrice__c);
         }
         
         for(Scrap_del__c scrp :scrapList) {
            if(mapProductPrice != null) {
                if(mapProductPrice.containsKey(scrp.Select_Item_1__c)) {
                    scrp.Rate_1__c = mapProductPrice.get(scrp.Select_Item_1__c);
                }
                if(mapProductPrice.containsKey(scrp.Select_Item_2__c)) {
                    scrp.Rate_2__c = mapProductPrice.get(scrp.Select_Item_2__c);
                }
                if(mapProductPrice.containsKey(scrp.Select_Item_3__c)) {
                    scrp.Rate_3__c = mapProductPrice.get(scrp.Select_Item_3__c);
                }
                if(mapProductPrice.containsKey(scrp.Select_Item_4__c)) {
                    scrp.Rate_4__c = mapProductPrice.get(scrp.Select_Item_4__c);
                }
            }
        }
    }
    
    public static void populateVatOrCst(List<Scrap_del__c> scrapList) {
        Set<Id> vendorIds = new Set<Id>();
        Set<Id> ownrIds = new Set<Id>();
        for(Scrap_del__c scrp :scrapList) {
            vendorIds.add(scrp.Service_Engineer_Assigned__c);
            ownrIds.add(scrp.OwnerId);
        }
        
        Map<Id, Stock_Point__c> mapStkPt = new Map<Id, Stock_Point__c>([select State__c, CST_Interstate__c, CST_within_State__c,
                    VAT_InterState__c, VAT_within_State__c, TCS__c from Stock_Point__c where id in :vendorIds]);
                    
        Map<Id, User> mapOwner = new Map<Id, User>([select State from User where id in :ownrIds]);
        
        for(Scrap_del__c scrp :scrapList) {
            if(mapStkPt != null && mapStkPt.containsKey(scrp.Service_Engineer_Assigned__c) 
                        && mapOwner != null && mapOwner.containsKey(scrp.OwnerId)) {
                 
                 Stock_Point__c stkPt = mapStkPt.get(scrp.Service_Engineer_Assigned__c);
                 User ownr = mapOwner.get(scrp.OwnerId);
                 if(stkPt.State__c != null && ownr.State != null && stkPt.State__c.equals(ownr.State)) {
                     if(stkPt.VAT_within_State__c != null)
                         scrp.VAT_CST__c = stkPt.VAT_within_State__c;
                     else
                         scrp.VAT_CST__c = stkPt.CST_within_State__c;
                 } else {
                     if(stkPt.VAT_Interstate__c != null)
                         scrp.VAT_CST__c = stkPt.VAT_Interstate__c;
                     else
                         scrp.VAT_CST__c = stkPt.CST_Interstate__c;
                 }   
                 scrp.TCS__c = stkPt.TCS__c;   
            }
        }
    }
    
    public void ScrapSalesUpdate(Scrap_del__c scrp)
    {
        String SC_Code = '';
        
        
        // -------START - Fetch the Stock Point's Service Center Location Code --------------
        List<Stock_Point__c> tempList = new List<Stock_Point__c>();
        tempList = [Select Id, Service_Center_Location_Code__c from Stock_Point__c where OwnerId = :scrp.OwnerId and RecordType.Name='Service Center' Limit 1];
        Stock_Point__c StockPt = new Stock_Point__c();
        
        if(tempList != null && tempList.size()>0){
            StockPt = tempList[0];
        }
       
       
        SC_Code = StockPt.Service_Center_Location_Code__c;
        
        
        // -------  END - Fetch the Stock Point's Service Center Location Code --------------
        
        
        // -------START - Fetch Current Financial Year --------------------------------------
        String strYear = '';
        String strMonth = String.ValueOf(DateTime.Now().month());
        Integer intMonth = Integer.valueOf(strMonth);
        
        if (intMonth >= 4) 
            {
                strYear = String.ValueOf(DateTime.Now().addYears(1).Year()).substring(2,4);
            } 
        else 
            {
                strYear = String.ValueOf(DateTime.Now().Year()).substring(2,4);            
            }                  
        // -------  END - Fetch Current Financial Year --------------------------------------
        
        //--------START - Update Scrap Sales Document Number -----------------
        
        //For Document/Invoice Numbers XXXXX63XXXXXX
        Integer count63 = 0;
        
        List<Scrap_del__c> Scrplist63 = [SELECT Id, Sale_Location_Type__c, Purchaser_Type__c, Document_Invoice_No__c FROM Scrap_del__c WHERE OwnerId = :scrp.OwnerId  AND Sale_Location_Type__c='Within State' AND Purchaser_Type__c='Registered' ORDER BY CreatedDate DESC LIMIT 1];
        
        if(Scrplist63.size()>0)
            {
                if(Scrplist63[0].Document_Invoice_No__c!=null && Scrplist63[0].Document_Invoice_No__c!='')
                {
                    count63 = Integer.valueOf(Scrplist63[0].Document_Invoice_No__c.substring(5,(Scrplist63[0].Document_Invoice_No__c.length())));
                }
            }
        
        //For Document/Invoice Numbers XXXXX64XXXXXX
        Integer count64 = 0;
        
        List<Scrap_del__c> Scrplist64 = [SELECT Id, Sale_Location_Type__c, Purchaser_Type__c, Document_Invoice_No__c FROM Scrap_del__c WHERE OwnerId = :scrp.OwnerId  AND (Sale_Location_Type__c!='Within State' OR Purchaser_Type__c!='Registered') ORDER BY CreatedDate DESC LIMIT 1];
        
        if(Scrplist64.size()>0)
            {
                if(Scrplist64[0].Document_Invoice_No__c!=null && Scrplist64[0].Document_Invoice_No__c!='')
                {
                    count64 = Integer.valueOf(Scrplist64[0].Document_Invoice_No__c.substring(5,(Scrplist64[0].Document_Invoice_No__c.length())));
                }
            }
        
        if(scrp.Sale_Location_Type__c == 'Within State' && scrp.Purchaser_Type__c == 'Registered')
        {
        
            if(Scrplist63.size()>0 && count63!=0)
            {
                String TempNo = String.valueOf(count63 + 1);
                scrp.Document_Invoice_No__c = strYear + SC_Code.subString(0,3) + TempNo;
            }
            else
            {
                scrp.Document_Invoice_No__c = strYear + SC_Code.subString(0,3) + '73' + '000000';
            }
        
        }
        else
        {
        
            if(Scrplist64.size()>0 && count64!=0)
            {
                    String TempNo = String.valueOf(count64 + 1);
                    if(SC_Code != null && SC_Code != '')
                        scrp.Document_Invoice_No__c = strYear + SC_Code.subString(0,3) + TempNo;
            }
            else
            {
                if(SC_Code != null && SC_Code != '')
                    scrp.Document_Invoice_No__c = strYear + SC_Code.subString(0,3) + '74' + '000000';
            }
        
        }
        
    }
}