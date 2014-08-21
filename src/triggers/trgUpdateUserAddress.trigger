trigger trgUpdateUserAddress on Component_Movement_Table__c (after insert) {

  Id UserId = trigger.new[0].CreatedById ;
  
  //trigger.new[0].addError('ABC    '+UserId);
  
  User objUser = [SELECT LastName, City,  Branch_State__c, Division, FirstName, Name FROM User where id =: UserId ];
  //trigger.new[0].UserAddress__c = objUser.City + ' ' + objUser.Branch_State__c  ; 
  
  
  Component_Movement_Table__c obj = [select id,UserAddress__c from Component_Movement_Table__c  where id =:trigger.new[0].id];
  obj.UserAddress__c  = objUser.City + ' ' + objUser.Branch_State__c  ; 
  
  //Component_Movement_Table__c obj = new Component_Movement_Table__c(id= trigger.new[0].id);
  //obj.UserAddress__c = objUser.City + ' ' + objUser.Branch_State__c  ; 
  update obj;
}