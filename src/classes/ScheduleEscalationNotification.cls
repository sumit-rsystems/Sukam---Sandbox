global class ScheduleEscalationNotification implements Schedulable{ 
  /*
   *  execute the Schedule batch 
   */
  global void execute(SchedulableContext sc) {
     SendEscalationNotification tb = new SendEscalationNotification() ;
     Database.executeBatch(tb);
  }
}