global class ScheduleCreateCallOnContract implements Schedulable{ 
  /*
   *  execute the Schedule batch 
   */
  global void execute(SchedulableContext sc) {
     CreateCallOnContract cc = new CreateCallOnContract() ;
     Database.executeBatch(cc);
  }
}