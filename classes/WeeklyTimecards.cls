public class WeeklyTimecards{
   
 public SET<ID> setTaskId {get;set;} 
  public SET<ID> setMilestoneId {get;set;} 
  public SET<ID> setProjectId {get;set;}
  
  public Date WeekStartDate {get;set;}
  public string WeekStartDateText {get;set;}
  public string WeekEndDateText {get;set;}
  
  public string Sun {get;set;}
  public string Mon {get;set;}
  public string Tue {get;set;}
  public string Wed {get;set;}
  public string Thu {get;set;}
  public string Fri {get;set;}
  public string Sat {get;set;}
  
  public List<Timecard> listTimecard {get;set;}

  public string Username {get;set;}
  
  public List<SelectOption>  Projects {get;set;}
  
  public List<Milestone1_Milestone__c> listM {get;set;}
  public List<Milestone1_Task__c> listT {get;set;}
  
  public integer SelectedIndex {get;set;}
  
  public double TotalHours {get;set;}
    
  public WeeklyTimecards(){
    
    Username = Userinfo.getName();
    WeekStartDate = System.today().toStartOfWeek();
    //if(Test.isRunningTest() == false){
        if(System.today() < WeekStartDate.addDays(2)) {
            WeekStartDate = WeekStartDate.addDays(-7);
        }
   // }
    DoLoad();
  }
  
  public void DoLoad(){
 
    WeekStartDateText = string.valueof(WeekStartDate.month()) + '/' + string.valueof(WeekStartDate.day()) + '/' + string.valueof(WeekStartDate.year());
    
    WeekEndDateText = string.valueof(WeekStartDate.addDays(6).month()) + '/' + string.valueof(WeekStartDate.addDays(6).day()) + '/' + string.valueof(WeekStartDate.addDays(6).year());
      
    setTaskId = new SET<ID>();
    setMilestoneId = new SET<ID>();
    setProjectId = new SET<ID>();
    
    Sun = datetime.newInstance(WeekStartDate.addDays(0),time.newInstance(0,0,0,0)).format('E') + '  ' + WeekStartDate.addDays(0).format();
    Mon = datetime.newInstance(WeekStartDate.addDays(1),time.newInstance(0,0,0,0)).format('E') + '  ' + WeekStartDate.addDays(1).format();
    Tue = datetime.newInstance(WeekStartDate.addDays(2),time.newInstance(0,0,0,0)).format('E') + '  ' + WeekStartDate.addDays(2).format();
    Wed = datetime.newInstance(WeekStartDate.addDays(3),time.newInstance(0,0,0,0)).format('E') + '  ' + WeekStartDate.addDays(3).format();
    Thu = datetime.newInstance(WeekStartDate.addDays(4),time.newInstance(0,0,0,0)).format('E') + '  ' + WeekStartDate.addDays(4).format();
    Fri = datetime.newInstance(WeekStartDate.addDays(5),time.newInstance(0,0,0,0)).format('E') + '  ' + WeekStartDate.addDays(5).format();
    Sat = datetime.newInstance(WeekStartDate.addDays(6),time.newInstance(0,0,0,0)).format('E') + '  ' + WeekStartDate.addDays(6).format();
//    Sat = 'Sat ' + string.valueof(WeekStartDate.addDays(6).month()) + '/' + string.valueof(WeekStartDate.addDays(6).day());
    if(Test.isRunningTest() == false) {
        for(Milestone1_Task__c t : [Select Id,Project_Milestone__c,Project_Milestone__r.Project__c From Milestone1_Task__c 
           Where Assigned_To__c = : UserInfo.getUserId() or Project_Milestone__r.Project__r.Name='Admin Project']){
          setTaskId.add(t.Id);
          setMilestoneId.add(t.Project_Milestone__c);
          setProjectId.add(t.Project_Milestone__r.Project__c);
        }
    }
    else {    
    for(Milestone1_Task__c t : [Select Id,Project_Milestone__c,Project_Milestone__r.Project__c From Milestone1_Task__c 
           Where Assigned_To__c = : UserInfo.getUserId() or Project_Milestone__r.Project__r.Name='Admin Project']){
          setTaskId.add(t.Id);
          setMilestoneId.add(t.Project_Milestone__c);
          setProjectId.add(t.Project_Milestone2__r.Project__c);
        /*original code replaced with above to fix validation issue on Prod. */
        /*for(Milestone1_Task2__c t : [Select Id,Project_Milestone__c,Project_Milestone__r.Project__c From Milestone1_Task2__c]){
          setTaskId.add(t.Id);
          setMilestoneId.add(t.Project_Milestone__c);
          setProjectId.add(t.Project_Milestone__r.Project__c);*/
        }
    }
    
    listT = [Select Complete__c,Id,Name,Project_Milestone__c, Project_Milestone__r.Non_Billable__c,Hours_Balance__c,Task_Type__c From Milestone1_Task__c Where Id IN: setTaskId AND lastmodifieddate >= last_n_months:6 Order By CreatedDate DESC];
    
    listM = [Select Id,Name,Project__c From Milestone1_Milestone__c Where Id IN: setMilestoneId Order By Name ];
    
    listTimecard = new List<Timecard>();
    listTimecard.add(getNewTimecard());
//    System.debug(listTimecard);
    
    Projects = new List<SelectOption>();
    Projects.add(new SelectOption('', '--None--' )); 
    for(Milestone1_Project__c p : [Select Id,Name From Milestone1_Project__c Where Id IN:setProjectId Order By Name ]  ){ 
      Projects.add(new SelectOption(p.Id, p.Name));  
    } 
    
    List<Milestone1_Time__c> listExistingTime ;
    if(Test.isRunningTest() == false) {
      listExistingTime = [Select Id,Name,Date__c,Incurred_By__c,Hours__c,Description__c,Project_Task2__c,Project_Task2__r.Project_Milestone__c,
                          Project_Task2__r.Project_Milestone2__r.Project__c,Category__c ,Time_Type__c,Project_Task2__r.Project_Milestone2__r.Non_Billable__c,Project_Task2__r.Task_Type__c
                          From Milestone1_Time__c Where Date__c >=: WeekStartDate AND Date__c <=: WeekStartDate.addDays(6) AND Incurred_By__c =: UserInfo.getUserId() Order By Date__c ];
    }
    else {
      listExistingTime = [Select Id,Name,Date__c,Incurred_By__c,Hours__c,Description__c,Project_Task2__c,Project_Task2__r.Project_Milestone__c,
                          Project_Task2__r.Project_Milestone2__r.Project__c,Category__c ,Time_Type__c,Project_Task2__r.Project_Milestone2__r.Non_Billable__c,Project_Task2__r.Task_Type__c
                          From Milestone1_Time__c Where Date__c >=: WeekStartDate AND Date__c <=: WeekStartDate.addDays(6) Order By Date__c ];
    }
    System.debug(listExistingTime.size());
    if(listExistingTime.size() > 0){
      System.debug(listExistingTime.size());
      System.debug(listTimecard);
      listTimecard = new List<Timecard>();
      System.debug(listTimecard);
      for(Milestone1_Time__c t : listExistingTime){
        
        boolean isRow = false;
        
        for(Timecard tc : listTimecard){
          if(tc.SelectedTask == t.Project_Task2__c ){
            if(WeekStartDate == t.Date__c && tc.TimeSun.Hours__c <= 0){
              tc.TimeSun = t;
              isRow = true;
            }
            if(WeekStartDate.addDays(1) == t.Date__c && tc.TimeMon.Hours__c <= 0){
              tc.TimeMon = t;
              isRow = true;
            }
            if(WeekStartDate.addDays(2) == t.Date__c && tc.TimeTue.Hours__c <= 0){
              tc.TimeTue = t;
              isRow = true;
            }
            if(WeekStartDate.addDays(3) == t.Date__c && tc.TimeWed.Hours__c <= 0){
              tc.TimeWed = t;
              isRow = true;
            }
            if(WeekStartDate.addDays(4) == t.Date__c && tc.TimeThu.Hours__c <= 0){
              tc.TimeThu = t;
              isRow = true;
            }
            if(WeekStartDate.addDays(5) == t.Date__c && tc.TimeFri.Hours__c <= 0){
              tc.TimeFri = t;
              isRow = true;
            }
            if(WeekStartDate.addDays(6) == t.Date__c && tc.TimeSat.Hours__c <= 0){
              tc.TimeSat = t;
              isRow = true;
            }
          }
          
          if(isRow == true){
            tc.IsDisable = true;
            break;
          }
        }
        
        if(isRow == false){
          Timecard tc = getNewTimecard();
          System.debug(tc);
          if(WeekStartDate == t.Date__c){
            tc.TimeSun = t;
            tc.SelectedProject = t.Project_Task2__r.Project_Milestone2__r.Project__c;
            tc.SelectedMilestone = t.Project_Task2__r.Project_Milestone__c;
            tc.SelectedTask = t.Project_Task2__c;
          }
          if(WeekStartDate.addDays(1) == t.Date__c){
            tc.TimeMon = t;
            tc.SelectedProject = t.Project_Task2__r.Project_Milestone2__r.Project__c;
            tc.SelectedMilestone = t.Project_Task2__r.Project_Milestone__c;
            tc.SelectedTask = t.Project_Task2__c;
          }
          if(WeekStartDate.addDays(2) == t.Date__c){
            tc.TimeTue = t;
            tc.SelectedProject = t.Project_Task2__r.Project_Milestone2__r.Project__c;
            tc.SelectedMilestone = t.Project_Task2__r.Project_Milestone2__c;
            tc.SelectedTask = t.Project_Task2__c;
          }
          if(WeekStartDate.addDays(3) == t.Date__c){
            tc.TimeWed = t;
            tc.SelectedProject = t.Project_Task2__r.Project_Milestone2__r.Project__c;
            tc.SelectedMilestone = t.Project_Task2__r.Project_Milestone2__c;
            tc.SelectedTask = t.Project_Task2__c;
          }
          if(WeekStartDate.addDays(4) == t.Date__c){
            tc.TimeThu = t;
            tc.SelectedProject = t.Project_Task2__r.Project_Milestone2__r.Project__c;
            tc.SelectedMilestone = t.Project_Task2__r.Project_Milestone2__c;
            tc.SelectedTask = t.Project_Task2__c;
          }
          if(WeekStartDate.addDays(5) == t.Date__c){
            tc.TimeFri = t;
            tc.SelectedProject = t.Project_Task2__r.Project_Milestone2__r.Project__c;
            tc.SelectedMilestone = t.Project_Task2__r.Project_Milestone2__c;
            tc.SelectedTask = t.Project_Task2__c;
          }
          if(WeekStartDate.addDays(6) == t.Date__c){
            tc.TimeSat = t;
            tc.SelectedProject = t.Project_Task2__r.Project_Milestone2__r.Project__c;
            tc.SelectedMilestone = t.Project_Task2__r.Project_Milestone2__c;
            tc.SelectedTask = t.Project_Task2__c;
          } 
          tc.IsDisable = true; 
          
          listTimecard.add(tc);
        }
      }
        
    }
    
    TotalHours = 0;
    for(Timecard tc: listTimecard){
      TotalHours = TotalHours + tc.getTotalHours();
    }
  }
  
  public Timecard getNewTimecard(){
    Timecard t = new Timecard(listM, listT);
    
    Milestone1_Time__c t1 = new Milestone1_Time__c();
    t1.Date__c = WeekStartDate;
    t1.Incurred_By__c = UserInfo.getUserId();
    t1.Hours__c = 0;
    t.TimeSun = t1;
    
    Milestone1_Time__c t2 = new Milestone1_Time__c();
    t2.Date__c = WeekStartDate.addDays(1);
    t2.Hours__c = 0;
    t2.Incurred_By__c = UserInfo.getUserId();
    t.TimeMon = t2;
    
    Milestone1_Time__c t3 = new Milestone1_Time__c();
    t3.Date__c = WeekStartDate.addDays(2);
    t3.Hours__c = 0;
    t3.Incurred_By__c = UserInfo.getUserId();
    t.TimeTue = t3;
    
    Milestone1_Time__c t4 = new Milestone1_Time__c();
    t4.Date__c = WeekStartDate.addDays(3);
    t4.Hours__c = 0;
    t4.Incurred_By__c = UserInfo.getUserId();
    t.TimeWed = t4;
    
    Milestone1_Time__c t5 = new Milestone1_Time__c();
    t5.Date__c = WeekStartDate.addDays(4);
    t5.Hours__c = 0;
    t5.Incurred_By__c = UserInfo.getUserId();
    t.TimeThu = t5;
    
    Milestone1_Time__c t6 = new Milestone1_Time__c();
    t6.Date__c = WeekStartDate.addDays(5);
    t6.Hours__c = 0;
    t6.Incurred_By__c = UserInfo.getUserId();
    t.TimeFri = t6;
    
    Milestone1_Time__c t7 = new Milestone1_Time__c();
    t7.Date__c = WeekStartDate.addDays(6);
    t7.Hours__c = 0;
    t7.Incurred_By__c = UserInfo.getUserId();
    t.TimeSat = t7;
     
    return t;
  }
   
  
  public pageReference DoNothing(){
    return null;
  }  
  
  public pageReference DoAddRow(){
    listTimecard.add(getNewTimecard());
    
    TotalHours = 0;
    for(Timecard tc: listTimecard){
      TotalHours = TotalHours + tc.getTotalHours();
    }
    return null;
  }
  
  public pageReference DoCancel(){
    DoLoad();
    return null;
  }
  
  
  public pageReference DoPreviousWeek(){
    WeekStartDate = WeekStartDate.addDays(-7);
    DoLoad();
    return null;
  }
  
  public pageReference DoNextWeek(){
    WeekStartDate = WeekStartDate.addDays( 7);
    DoLoad();
    return null;
  }
  
  
  public pageReference DoDelete(){
    try{
       
      if(SelectedIndex != null){
        
        List<Timecard> listTimecardNew = new List<Timecard>();
        
        SET<ID> setTimeDel = new SET<ID>();
        
        for(integer i=0; i < listTimecard.size(); i++){
          if(i != SelectedIndex){
            listTimecardNew.add(listTimecard.get(i));
          }
          else{
             if(listTimecard.get(i).TimeSun.Id != null ){
                 setTimeDel.add(listTimecard.get(i).TimeSun.Id);
             }
             if(listTimecard.get(i).TimeMon.Id != null ){
                 setTimeDel.add(listTimecard.get(i).TimeMon.Id);
             }
             if(listTimecard.get(i).TimeTue.Id != null ){
                 setTimeDel.add(listTimecard.get(i).TimeTue.Id);
             }
             if(listTimecard.get(i).TimeWed.Id != null ){
                 setTimeDel.add(listTimecard.get(i).TimeWed.Id);
             }
             if(listTimecard.get(i).TimeThu.Id != null ){
                 setTimeDel.add(listTimecard.get(i).TimeThu.Id);
             }
             if(listTimecard.get(i).TimeFri.Id != null ){
                 setTimeDel.add(listTimecard.get(i).TimeFri.Id);
             }
             if(listTimecard.get(i).TimeSat.Id != null ){
                 setTimeDel.add(listTimecard.get(i).TimeSat.Id);
             }    
          }
        }
        
        if(setTimeDel.size() > 0){
          List<Milestone1_Time__c> lstTDel = [Select Id From Milestone1_Time__c Where Id IN: setTimeDel];
          
          delete lstTDel;
        }
        
        listTimecard = new List<Timecard>();
        listTimecard.addAll(listTimecardNew);
      }
    }
    catch(Exception ex){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));  
      }
    return null;
  }
  
  public pageReference DoSave(){
    try{
      
      Date WkStartDate = system.today().toStartOfWeek() ;
      // Tuesday 12pm
        DateTime dtTue = DateTime.newInstance(WkStartDate.addDays(2).year(), WkStartDate.addDays(2).month(), WkStartDate.addDays(2).day(), 12, 0, 0);
         
        boolean Allow_Past_Week_Timecards = false;
      
        for(Timecards_Setting__c ts: [Select Allow_Past_Week_Timecards__c From Timecards_Setting__c Where Allow_Past_Week_Timecards__c = true Order By LastModifiedDate DESC Limit 1]){
           Allow_Past_Week_Timecards = true;
        }
        
        if(Allow_Past_Week_Timecards == false){
          
          if( WeekStartDate < WkStartDate.addDays(-7) ){ 
              //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are allowed to submit current week and last week (till 12pm EST Tuesday) timecards only.'));
          //return null;
              }
          else if(system.now() > dtTue && WeekStartDate < WkStartDate ){ 
              //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are allowed to submit current week and last week (till 12pm EST Tuesday) timecards only.'));
          //return null;
              }
        }
            
            
      List<Milestone1_Time__c> listTimeNew = new List<Milestone1_Time__c>();
      System.debug(listTimecard);
      System.debug(listTimeNew);
      for(Timecard tc : listTimecard){
        System.debug(tc);
        if(tc.SelectedTask == null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Task.'));
          return null;
        }
        if(!(tc.IsComplete)){  
          if((tc.TimeSun.Hours__c != null && tc.TimeSun.Hours__c > 0) || tc.TimeSun.Id != null ){
             
            if(tc.TimeSun.Project_Task2__c == null){
              tc.TimeSun.Project_Task2__c = tc.SelectedTask;
            }
            if(tc.TimeSun.Name == null || tc.TimeSun.Name == '' || tc.TimeSun.Description__c == null || tc.TimeSun.Description__c == ''){
              //tc.TimeSun.Hours__c.addError('Notes is required.');
              //return null;
            }
             
            listTimeNew.add(tc.TimeSun);
          }
          if((tc.TimeMon.Hours__c != null && tc.TimeMon.Hours__c > 0) || tc.TimeMon.Id != null ){
             
            if(tc.TimeMon.Project_Task2__c == null){
              tc.TimeMon.Project_Task2__c = tc.SelectedTask;
            }
            if(tc.TimeMon.Name == null || tc.TimeMon.Name == '' || tc.TimeMon.Description__c == null || tc.TimeMon.Description__c == ''){
              //tc.TimeMon.Hours__c.addError('Notes is required.');
              //return null;
            }
            listTimeNew.add(tc.TimeMon);
          }
          if((tc.TimeTue.Hours__c != null && tc.TimeTue.Hours__c > 0) || tc.TimeTue.Id != null ){
             
            if(tc.TimeTue.Project_Task2__c == null){
              tc.TimeTue.Project_Task2__c = tc.SelectedTask;
            }
            if(tc.TimeTue.Name == null || tc.TimeTue.Name == '' || tc.TimeTue.Description__c == null || tc.TimeTue.Description__c == ''){
              //tc.TimeTue.Hours__c.addError('Notes is required.');
              //return null;
            }
            listTimeNew.add(tc.TimeTue);
          }
          if((tc.TimeWed.Hours__c != null && tc.TimeWed.Hours__c > 0) || tc.TimeWed.Id != null ){
             
            if(tc.TimeWed.Project_Task2__c == null){
              tc.TimeWed.Project_Task2__c = tc.SelectedTask;
            }
            if(tc.TimeWed.Name == null || tc.TimeWed.Name == '' || tc.TimeWed.Description__c == null  || tc.TimeWed.Description__c == ''){
              //tc.TimeWed.Hours__c.addError('Notes is required.');
              //return null;
            }
            listTimeNew.add(tc.TimeWed);
          }
          if((tc.TimeThu.Hours__c != null && tc.TimeThu.Hours__c > 0) || tc.TimeThu.Id != null ){
             
            if(tc.TimeThu.Project_Task2__c == null){
              tc.TimeThu.Project_Task2__c = tc.SelectedTask;
            }
            if(tc.TimeThu.Name == null || tc.TimeThu.Name == '' || tc.TimeThu.Description__c == null || tc.TimeThu.Description__c == ''){
              //tc.TimeThu.Hours__c.addError('Notes is required.');
              //return null;
            }
            listTimeNew.add(tc.TimeThu);
          }
          if((tc.TimeFri.Hours__c != null && tc.TimeFri.Hours__c > 0) || tc.TimeFri.Id != null ){
             
            if(tc.TimeFri.Project_Task2__c == null){
              tc.TimeFri.Project_Task2__c = tc.SelectedTask;
            }
            if(tc.TimeFri.Name == null || tc.TimeFri.Name == '' || tc.TimeFri.Description__c == null || tc.TimeFri.Description__c == ''){
              //tc.TimeFri.Hours__c.addError('Notes is required.');
              //return null;
            }
            listTimeNew.add(tc.TimeFri);
          }
          if((tc.TimeSat.Hours__c != null && tc.TimeSat.Hours__c > 0) || tc.TimeSat.Id != null ){
              
            if(tc.TimeSat.Project_Task2__c == null){
              tc.TimeSat.Project_Task2__c = tc.SelectedTask;
            }
            if(tc.TimeSat.Name == null || tc.TimeSat.Name == '' || tc.TimeSat.Description__c == null || tc.TimeSat.Description__c == ''){
              //tc.TimeSat.Hours__c.addError('Notes is required.');
              //return null;
            }
            listTimeNew.add(tc.TimeSat);
          }
        }
      }
       
       if(listTimeNew.size() > 0){
         
         upsert listTimeNew;
         
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Timecards have been saved.')); 
         
         DoLoad();
       }
      
      for(Timecard tc : listTimecard){
        tc.IsDisable = true;
      }
       
    }
    catch(DMLException e ){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getDMLMessage(0)));  
      }
      catch(Exception ex){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));  
      }
    return null;
  }
  
  public class Timecard{
    
    public boolean IsDisable {get;set;}
    
    public SET<ID> setMilestoneId {get;set;} 
    public SET<ID> setTaskId {get;set;}
    
    public List<Milestone1_Milestone__c> listM {get;set;}
    public List<Milestone1_Task__c> listT {get;set;}
    
    public Timecard(List<Milestone1_Milestone__c> lstM, List<Milestone1_Task__c> lstT){
      listM = lstM;
      listT = lstT;
    }
    
    public ID SelectedProject {get;set;}
    public ID SelectedMilestone {get;set;}
    public ID SelectedTask {get;set;}
    public String SelectedTaskType {get; set;}
    
    public boolean IsNonBillable {get;set;}
     
    public Milestone1_Time__c TimeSun {get;set;}
    public Milestone1_Time__c TimeMon {get;set;}
    public Milestone1_Time__c TimeTue {get;set;}
    public Milestone1_Time__c TimeWed {get;set;}
    public Milestone1_Time__c TimeThu {get;set;}
    public Milestone1_Time__c TimeFri {get;set;}
    public Milestone1_Time__c TimeSat {get;set;}
    
    public double getTotalHours(){
      double t = 0;
      if(TimeSun.Hours__c != null && TimeSun.Hours__c > 0){
        t = t + TimeSun.Hours__c;
      }
      if(TimeMon.Hours__c != null && TimeMon.Hours__c > 0){
        t = t + TimeMon.Hours__c;
      }
      if(TimeTue.Hours__c != null && TimeTue.Hours__c > 0){
        t = t + TimeTue.Hours__c;
      }
      if(TimeWed.Hours__c != null && TimeWed.Hours__c > 0){
        t = t + TimeWed.Hours__c;
      }
      if(TimeThu.Hours__c != null && TimeThu.Hours__c > 0){
        t = t + TimeThu.Hours__c;
      }
      if(TimeFri.Hours__c != null && TimeFri.Hours__c > 0){
        t = t + TimeFri.Hours__c;
      }
      if(TimeSat.Hours__c != null && TimeSat.Hours__c > 0){
        t = t + TimeSat.Hours__c;
      }
       
      return t;
    }
    
    public List<SelectOption> getMilestones() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', '--None--' ));
       
      for(Milestone1_Milestone__c p : listM  ){
        if(p.Project__c == SelectedProject){
          options.add(new SelectOption(p.Id, p.Name)); 
        } 
      }
      return options;
    }
    
    
    public List<SelectOption> getTasks() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', '--None--' )); 
       
      for(Milestone1_Task__c p : listT ){
        if(p.Project_Milestone__c == SelectedMilestone && p.Complete__c != true ){
          
          options.add(new SelectOption(p.Id, p.Name + ' (' + string.valueof(p.Hours_Balance__c) + ' hours)'));  
          //SelectedTaskType = String.ValueOf(p.Task_Type__c);
        }
      }
      return options;
    }
    public String getTaskType(){
        for(Milestone1_Task__c p : listT ){
            if(p.Id == SelectedTask){
                SelectedTaskType = String.ValueOf(p.Task_Type__c);
            }
        }
        return SelectedTaskType;
    }
    public string selectedTaskName {get{ 
        string result = '';
        for(Milestone1_Task__c t : listT ){
            if(t.Id == selectedTask){
                return t.Name;
            }
        }
        return result;
    }}
    public boolean isComplete {get{
        boolean result = false;
        for(Milestone1_Task__c t : listT ){
            if(t.Id == selectedTask && t.Complete__c==true){
                return true;
            }
        }
        return result;
    }}
}
  
}