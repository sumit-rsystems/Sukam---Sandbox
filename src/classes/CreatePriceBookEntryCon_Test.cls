@isTest
public class CreatePriceBookEntryCon_Test{
    public static testMethod void myunitTest(){
        Product__c prd = new Product__c(
            Category_Code__c = 'wer',
            Category_Description__c = 'cc',
            Product_Description__c = 'kk',
            name = 'ee'
        );
        insert prd;
        
        Price_Books__c  pb = new Price_Books__c (
            Description__c = 'test',
            IsActive__c = true,
            Name = 'Tests'
            //CurrencyIsoCode = 'USD'
         );
        insert pb;
        
        Price_Books__c  pb1 = new Price_Books__c (
            Description__c = 'test',
            IsActive__c = true,
            IsStandard__c = true,
            Name = 'Tests'
           // CurrencyIsoCode = 'USD'
         );
        insert pb1;
        
      Standard_Price__c spb = new Standard_Price__c (
           Products__c = prd.id,
           Conversion_Rate__c = 122,
           Standard_Price__c = 23
         //  CurrencyIsoCode = 'USD'
       );
       insert spb;
       
       Standard_Price__c spb1 = new Standard_Price__c (
           Products__c = prd.id,
           Conversion_Rate__c = 122,
           Standard_Price__c = 23
          // CurrencyIsoCode = 'INR'
       );
       insert spb1;
       
      Price_Book_Entry__c pbe = new Price_Book_Entry__c (
           Product__c = prd.id,
           Price_book__c = pb.id
           //CurrencyIsoCode = 'USD'
         );
       insert pbe;
       
       Price_Book_Entry__c pbe1 = new Price_Book_Entry__c (
           Product__c = prd.id,
           Price_book__c = pb1.id
           //CurrencyIsoCode = 'USD'
         );
       insert pbe1;
       
        ApexPages.currentPage().getParameters().put('id',prd.id);
        ApexPages.StandardController std = new ApexPages.StandardController(prd);
        CreatePriceBookEntryCon cpbec = new CreatePriceBookEntryCon(std);
        CreatePriceBookEntryCon.priceBookWrapper wrap = new CreatePriceBookEntryCon.priceBookWrapper(pb1,spb1,'test');
        CreatePriceBookEntryCon.priceBookWrapper wrap1 = new CreatePriceBookEntryCon.priceBookWrapper(pb1,true);
        cpbec.onSelect();
        cpbec.finalWrapperList = new List<CreatePriceBookEntryCon.priceBookWrapper>();
        cpBec.pbWrapperList = new List<CreatePriceBookEntryCon.priceBookWrapper>();
        cpbec.finalWrapperList.add(wrap1);
        wrap1.Selected = true;
        cpbec.onSelect();
        cpbec.doSave();
        cpbec.doCancel();
        cpbec.doSaveAndMore(); 
        
        ApexPages.currentPage().getParameters().put('pid',prd.id);
        editPriceBookEntryCon epbe = new editPriceBookEntryCon(std);
        editPriceBookEntryCon.priceBookWrapper wrap2= new editPriceBookEntryCon.priceBookWrapper(pbe, 100);
        epbe.pbeList = new List<editPriceBookEntryCon.priceBookWrapper>();
        epbe.doSave();
        wrap2.Selected = true;
        epbe.pbeList.add(wrap2);
        epbe.doSave();
               
        epbe.doCancel();
        
        
        priceBookEntryPageComponentCon pbecon = new priceBookEntryPageComponentCon(std); 
        ApexPages.currentPage().getParameters().put('pbeId',pbe1.id);
        pbecon.editPBE();
        pbecon.viewPBE();  
        pbecon.deletePBE();  
    
    }
}