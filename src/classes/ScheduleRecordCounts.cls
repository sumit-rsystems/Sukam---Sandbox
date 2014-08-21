global class ScheduleRecordCounts implements Schedulable{ 
  global void execute(SchedulableContext sc) {
     recordCountOfServiceRequest r = new recordCountOfServiceRequest();
     r.getCounts();
  }
}