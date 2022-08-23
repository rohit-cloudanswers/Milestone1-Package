@isTest
public with sharing class TimeViewTest {  
    public static TestMethod void timeViewTest(){
      Milestone1_Project__c tempproject = new Milestone1_Project__c();
      tempproject.Name = 'Temp';
      insert tempproject;
      Milestone1_Milestone__c tempmilestone = new Milestone1_Milestone__c();
      tempmilestone.Project__c = tempproject.Id;
      insert tempmilestone;
      Milestone1_Task__c temptask = new Milestone1_Task__c();
      temptask.Project_Milestone__c = tempmilestone.Id;
      insert temptask;
      Milestone1_Time__c temp = new Milestone1_Time__c();
      temp.Project_Task2__c = temptask.Id;
      temp.Date__c = Date.today();
      insert temp;
      WeeklyTimecards timeCards = new WeeklyTimecards();
      timeCards.WeekStartDate = Date.today();
      WeeklyTimecards.Timecard c = timeCards.getNewTimecard();
      c.SelectedTask = temp.Project_Task2__c;
      System.debug(c);
      c.getTotalHours();
      c.getMileStones();
      c.getTasks();
      timeCards.DoLoad();
      timeCards.SelectedIndex = 0;
      timeCards.getNewTimecard();
      System.debug(c);
      System.assertEquals(Null ,timeCards.DoNothing());
      System.assertEquals(Null ,timeCards.DoAddRow());
      System.assertEquals(Null ,timeCards.DoCancel());
      System.assertEquals(Null ,timeCards.DoPreviousWeek());
      System.assertEquals(Null ,timeCards.DoNextWeek());
      System.assertEquals(Null ,timeCards.DoDelete());
      System.assertEquals(Null ,timeCards.DoSave());
      System.debug(c);
   }
 public static TestMethod void timeViewTest2(){
      Milestone1_Project__c tempproject = new Milestone1_Project__c();
      tempproject.Name = 'Temp';
      insert tempproject;
      Milestone1_Milestone__c tempmilestone = new Milestone1_Milestone__c();
      tempmilestone.Project__c = tempproject.Id;
      insert tempmilestone;
      Milestone1_Task__c temptask = new Milestone1_Task__c();
      temptask.Project_Milestone__c = tempmilestone.Id;
      insert temptask;
      Milestone1_Time__c temp = new Milestone1_Time__c();
      temp.Project_Task2__c = temptask.Id;
      temp.Date__c = Date.today().addDays(1);
//      temp.WeekStartDate = Date.today();
      insert temp;
      WeeklyTimecards timeCards = new WeeklyTimecards();
      timeCards.WeekStartDate = Date.today();
      WeeklyTimecards.Timecard c = timeCards.getNewTimecard();
      c.SelectedTask = temp.Project_Task2__c;
      System.debug(c);
      c.getTotalHours();
      c.getMileStones();
      c.getTasks();
      timeCards.DoLoad();
      timeCards.SelectedIndex = 0;
      timeCards.getNewTimecard();
      System.assertEquals(Null ,timeCards.DoNothing());
      System.assertEquals(Null ,timeCards.DoAddRow());
      System.assertEquals(Null ,timeCards.DoCancel());
      System.assertEquals(Null ,timeCards.DoPreviousWeek());
      System.assertEquals(Null ,timeCards.DoNextWeek());
      System.assertEquals(Null ,timeCards.DoDelete());
      System.assertEquals(Null ,timeCards.DoSave());
   }
    public static TestMethod void timeViewTest3(){
      Milestone1_Project__c tempproject = new Milestone1_Project__c();
      tempproject.Name = 'Temp';
      insert tempproject;
      Milestone1_Milestone__c tempmilestone = new Milestone1_Milestone__c();
      tempmilestone.Project__c = tempproject.Id;
      insert tempmilestone;
      Milestone1_Task__c temptask = new Milestone1_Task__c();
      temptask.Project_Milestone__c = tempmilestone.Id;
      insert temptask;
      System.assertEquals(tempmilestone.Id, temptask.Project_Milestone__c);
      Milestone1_Time__c temp = new Milestone1_Time__c();
      temp.Project_Task2__c = temptask.Id;
      temp.Date__c = Date.today().addDays(2);
      insert temp;
      System.assertEquals(temptask.Id, temp.Project_Task2__c);
      WeeklyTimecards timeCards = new WeeklyTimecards();
      timeCards.WeekStartDate = Date.today();
      WeeklyTimecards.Timecard c = timeCards.getNewTimecard();
      c.SelectedTask = temp.Project_Task2__c;
      System.debug(c);
      c.getTotalHours();
      c.getMileStones();
      c.getTasks();
      timeCards.DoLoad();
      timeCards.SelectedIndex = 0;
      timeCards.getNewTimecard();
      System.assertEquals(Null ,timeCards.DoNothing());
      System.assertEquals(Null ,timeCards.DoAddRow());
      System.assertEquals(Null ,timeCards.DoCancel());
      System.assertEquals(Null ,timeCards.DoPreviousWeek());
      System.assertEquals(Null ,timeCards.DoNextWeek());
      System.assertEquals(Null ,timeCards.DoDelete());
      System.assertEquals(Null ,timeCards.DoSave());

   }
    public static TestMethod void timeViewTest4(){
      Milestone1_Project__c tempproject = new Milestone1_Project__c();
      tempproject.Name = 'Temp';
      insert tempproject;
      Milestone1_Milestone__c tempmilestone = new Milestone1_Milestone__c();
      tempmilestone.Project__c = tempproject.Id;
      insert tempmilestone;
      Milestone1_Task__c temptask = new Milestone1_Task__c();
      temptask.Project_Milestone__c = tempmilestone.Id;
      insert temptask;
      Milestone1_Time__c temp = new Milestone1_Time__c();
      temp.Project_Task2__c = temptask.Id;
      temp.Date__c = Date.today().addDays(3);
//      temp.WeekStartDate = Date.today();
      insert temp;
      WeeklyTimecards timeCards = new WeeklyTimecards();
      timeCards.WeekStartDate = Date.today();
      WeeklyTimecards.Timecard c = timeCards.getNewTimecard();
      c.SelectedTask = temp.Project_Task2__c;
      System.debug(c);
      c.getTotalHours();
      c.getMileStones();
      c.getTasks();
      timeCards.DoLoad();
      timeCards.SelectedIndex = 0;
      timeCards.getNewTimecard();
      System.assertEquals(Null ,timeCards.DoNothing());
      System.assertEquals(Null ,timeCards.DoAddRow());
      System.assertEquals(Null ,timeCards.DoCancel());
      System.assertEquals(Null ,timeCards.DoPreviousWeek());
      System.assertEquals(Null ,timeCards.DoNextWeek());
      System.assertEquals(Null ,timeCards.DoDelete());
      System.assertEquals(Null ,timeCards.DoSave());

   }
    public static TestMethod void timeViewTest5(){
      Milestone1_Project__c tempproject = new Milestone1_Project__c();
      tempproject.Name = 'Temp';
      insert tempproject;
      Milestone1_Milestone__c tempmilestone = new Milestone1_Milestone__c();
      tempmilestone.Project__c = tempproject.Id;
      insert tempmilestone;
      Milestone1_Task__c temptask = new Milestone1_Task__c();
      temptask.Project_Milestone__c = tempmilestone.Id;
      insert temptask;
      Milestone1_Time__c temp = new Milestone1_Time__c();
      temp.Project_Task2__c = temptask.Id;
      temp.Date__c = Date.today().addDays(4);
//      temp.WeekStartDate = Date.today();
      insert temp;
      WeeklyTimecards timeCards = new WeeklyTimecards();
      timeCards.WeekStartDate = Date.today();
      WeeklyTimecards.Timecard c = timeCards.getNewTimecard();
      c.SelectedTask = temp.Project_Task2__c;
      System.debug(c);
      c.getTotalHours();
      c.getMileStones();
      c.getTasks();
      timeCards.DoLoad();
      timeCards.SelectedIndex = 0;
      timeCards.getNewTimecard();
      System.assertEquals(Null ,timeCards.DoNothing());
      System.assertEquals(Null ,timeCards.DoAddRow());
      System.assertEquals(Null ,timeCards.DoCancel());
      System.assertEquals(Null ,timeCards.DoPreviousWeek());
      System.assertEquals(Null ,timeCards.DoNextWeek());
      System.assertEquals(Null ,timeCards.DoDelete());
      System.assertEquals(Null ,timeCards.DoSave());

   }
    public static TestMethod void timeViewTest6(){
      Milestone1_Project__c tempproject = new Milestone1_Project__c();
      tempproject.Name = 'Temp';
      insert tempproject;
      Milestone1_Milestone__c tempmilestone = new Milestone1_Milestone__c();
      tempmilestone.Project__c = tempproject.Id;
      insert tempmilestone;
      Milestone1_Task__c temptask = new Milestone1_Task__c();
      temptask.Project_Milestone__c = tempmilestone.Id;
      insert temptask;
      Milestone1_Time__c temp = new Milestone1_Time__c();
      temp.Project_Task2__c = temptask.Id;
      temp.Date__c = Date.today().addDays(5);
//      temp.WeekStartDate = Date.today();
      insert temp;
      WeeklyTimecards timeCards = new WeeklyTimecards();
      timeCards.WeekStartDate = Date.today();
      WeeklyTimecards.Timecard c = timeCards.getNewTimecard();
      c.SelectedTask = temp.Project_Task2__c;
      System.debug(c);
      c.getTotalHours();
      c.getMileStones();
      c.getTasks();
      timeCards.DoLoad();
      timeCards.SelectedIndex = 0;
      timeCards.getNewTimecard();
      System.assertEquals(Null ,timeCards.DoNothing());
      System.assertEquals(Null ,timeCards.DoAddRow());
      System.assertEquals(Null ,timeCards.DoCancel());
      System.assertEquals(Null ,timeCards.DoPreviousWeek());
      System.assertEquals(Null ,timeCards.DoNextWeek());
      System.assertEquals(Null ,timeCards.DoDelete());
      System.assertEquals(Null ,timeCards.DoSave());

   }
    public static TestMethod void timeViewTest7(){
      Milestone1_Project__c tempproject = new Milestone1_Project__c();
      tempproject.Name = 'Temp';
      insert tempproject;
      Milestone1_Milestone__c tempmilestone = new Milestone1_Milestone__c();
      tempmilestone.Project__c = tempproject.Id;
      insert tempmilestone;
      Milestone1_Task__c temptask = new Milestone1_Task__c();
      temptask.Project_Milestone__c = tempmilestone.Id;
      temptask.Task_Type__c = 'Billable';
      temptask.Name = 'temp';
      temptask.Complete__c = false;
      insert temptask;
      Milestone1_Time__c temp = new Milestone1_Time__c();
      temp.Project_Task2__c = temptask.Id;
      temp.Date__c = Date.today().addDays(6);
      insert temp;
      WeeklyTimecards timeCards = new WeeklyTimecards();
      timeCards.WeekStartDate = Date.today();
      WeeklyTimecards.Timecard c = timeCards.getNewTimecard();
      c.SelectedTask = temp.Project_Task2__c;
      System.debug(c);
      c.getTotalHours();
      c.getMileStones();
      c.getTasks();
      timeCards.DoLoad();
      timeCards.DoSave();
      System.assertEquals(temptask.Task_Type__c, c.getTaskType());
      System.assertEquals(temptask.Name, c.selectedTaskName);
      System.assertEquals(temptask.Complete__c, c.isComplete);
   }
      public static TestMethod void timeViewTest8(){
      Milestone1_Project__c tempproject = new Milestone1_Project__c();
      tempproject.Name = 'Temp';
      insert tempproject;
      Milestone1_Milestone__c tempmilestone = new Milestone1_Milestone__c();
      tempmilestone.Project__c = tempproject.Id;
      insert tempmilestone;
      Milestone1_Task__c temptask = new Milestone1_Task__c();
      temptask.Project_Milestone__c = tempmilestone.Id;
      temptask.Task_Type__c = 'Billable';
      temptask.Name = 'temp';
      temptask.Complete__c = false;
      insert temptask;

      List<Milestone1_Time__c> times = new List<Milestone1_Time__c>{
            new Milestone1_Time__c(
                  Project_Task2__c = temptask.Id,
                  Date__c = Date.today().addDays(0),
                  Hours__c = 5
            ),
            new Milestone1_Time__c(
                  Project_Task2__c = temptask.Id,
                  Date__c = Date.today().addDays(1),
                  Hours__c = 5
            ),
            new Milestone1_Time__c(
                  Project_Task2__c = temptask.Id,
                  Date__c = Date.today().addDays(2),
                  Hours__c = 5
            ),
            new Milestone1_Time__c(
                  Project_Task2__c = temptask.Id,
                  Date__c = Date.today().addDays(3),
                  Hours__c = 5
            ),
            new Milestone1_Time__c(
                  Project_Task2__c = temptask.Id,
                  Date__c = Date.today().addDays(4),
                  Hours__c = 5
            ),
            new Milestone1_Time__c(
                  Project_Task2__c = temptask.Id,
                  Date__c = Date.today().addDays(5),
                  Hours__c = 5
            ),
            new Milestone1_Time__c(
                  Project_Task2__c = temptask.Id,
                  Date__c = Date.today().addDays(6),
                  Hours__c = 5
            ),
            new Milestone1_Time__c(
                  Project_Task2__c = temptask.Id,
                  Date__c = Date.today().addDays(7),
                  Hours__c = 5
            )
      };
      insert times;

      Test.startTest();
      WeeklyTimecards timeCards = new WeeklyTimecards();
      timeCards.WeekStartDate = Date.today();
      WeeklyTimecards.Timecard c = timeCards.getNewTimecard();
      c.SelectedTask = times.get(0).Project_Task2__c;
      System.debug(c);
      c.TimeSun = times.get(1);
      c.TimeMon = times.get(2);
      c.TimeTue = times.get(3);
      c.TimeWed = times.get(4);
      c.TimeThu = times.get(5);
      c.TimeFri = times.get(6);
      c.TimeSat = times.get(7);
      c.getTotalHours();
      c.getMileStones();
      c.getTasks();
   }
}