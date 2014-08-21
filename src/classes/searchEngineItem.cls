public with sharing class searchEngineItem {
public Service_Request__c thisServiceReq {get;set;}
public boolean isSelected {get;set;}
	public searchEngineItem(Service_Request__c s){
		thisServiceReq = s ;
		isSelected = false;
	}
}