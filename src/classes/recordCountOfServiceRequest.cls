public with  sharing class recordCountOfServiceRequest {

List<String> validStatusListCount1 = new List<String>{'New','Assigned','Allocated','Pending','Attended'};
List<String> validStatusListCount2 = new List<String>{'Closed','Rejected'};
List<Record_Count__c> recordsToInsert = new List<Record_Count__c>();
String ProfileID;

 public recordCountOfServiceRequest (){
       ProfileID = [Select ID from PROFILE where name = 'Service Center' ].ID ;    
       getCounts();
    }    

   public void getCounts(){
        AggregateResult[] groupedResults ;
                    groupedResults = [ Select OwnerId ,count(Id) 
                           FROM Service_Request__c  
                           Where FSR_No__c != null 
                           AND Status__c IN :validStatusListCount1
                           AND owner.profileid =: ProfileID                   
                           Group by OwnerId Limit 25000];
                           //Not adding a date condition here cause this will anyways fetch the records 
                           // craeated till date
       System.debug('#################'  + groupedResults.size() );
       
       AggregateResult[] groupedResults2 ;
                    groupedResults2 = [ Select OwnerId ,count(Id) 
                           FROM Service_Request__c  
                           Where FSR_No__c != null 
                           AND Status__c IN :validStatusListCount2                          
                           AND owner.profileid =: ProfileID
                           Group by OwnerId Limit 25000];          
          System.debug('##rrrrrrrrrr####'  + groupedResults2 .size() );
                           
          Map<ID,List<Integer>> mapUser_Counts = new Map<Id,List<Integer>>();
       
          for(AggregateResult ar : groupedResults){
              Integer i = Integer.valueOf(ar.get('expr0'));
              mapUser_Counts.put( String.valueOf(ar.get('OwnerId')) , new List<Integer>{i,0} );
          }

          for (AggregateResult ar : groupedResults2) {
              Integer i = Integer.valueOf(ar.get('expr0'));   
              String UserID = String.valueOf(ar.get('OwnerId'));
              String Count1 = String.valueOf(ar.get('expr0')) ;
              if (mapUser_Counts.containsKey(UserID))
                  mapUser_Counts.get(UserID)[1] = integer.valueOf(Count1);
              else
                  mapUser_Counts.put( UserID , new List<Integer>{0,i} );
          }
          
          for(String s : mapUser_Counts.keySet()){
                  Record_Count__c r = new Record_Count__c();
                  r.User__c =  s;
                  r.Total_Open_Cases__c = mapUser_Counts.get(s)[0];
                  r.Total_Closed_Cases__c = mapUser_Counts.get(s)[1];
                  r.Till_Date_Time__c = System.now();
                  recordsToInsert.add(r);                         
          }
          
          insert recordsToInsert;
          
}

}