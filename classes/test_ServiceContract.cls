@isTest
(seeAllData=true)
public class test_ServiceContract {
    public static string getIntegrationId(BusinessHours bh){
        /*
        CONCAT( 
            CONCAT( 
                IIF( TimeZoneSidKey='America/New_York', '-05', 
                    IIF( TimeZoneSidKey='Europe/London', '+00', 
                        IIF( TimeZoneSidKey='Australia/Sydney', '+11', 
                            IIF( TimeZoneSidKey='Asia/Singapore', '+08', 
                                IIF( TimeZoneSidKey='Europe/Paris', '+01', 
                                    IIF( TimeZoneSidKey='Asia/Dubai', '+04', 
                                        IIF( TimeZoneSidKey='America/Denver', '-07', 
                                            IIF( TimeZoneSidKey='Europe/Dublin', '+00', 
                                                IIF( TimeZoneSidKey='America/Los_Angeles', '-08', '+xx' ) ) ) ) ) ) ) ) ), CONCAT( CONCAT( IIF(IsNULL(SundayStartTime),'N','Y'), IIF(IsNULL(MondayStartTime),'N','Y') ), CONCAT( IIF(IsNULL(TuesdayStartTime),'N','Y'), IIF(IsNULL(WednesdayStartTime),'N','Y') ) ) ), CONCAT( CONCAT( IIF(IsNULL(ThursdayStartTime),'N','Y'), IIF(IsNULL(FridayStartTime),'N','Y') ), CONCAT( IIF(IsNULL(SaturdayStartTime),'N','Y'), CONCAT( TO_CHAR(MondayStartTime,'HH24:MI'), TO_CHAR(MondayEndTime,'HH24:MI') ) ) ) )
		*/
        return '';
	}
    public static testmethod void testServiceContractTrigger(){
        Address__c add = [SELECT Id, Account__c FROM Address__c WHERE account__c != null and Oracle_Address_Id__c != null and active__c = true Limit 1];
        //cannot set businessHours in testcode 
        //setup BusinessHourTempStore__c 
        List<BusinessHours> bhs = [SELECT FridayStartTime,Id,IsActive,IsDefault,MondayEndTime,MondayStartTime,SaturdayStartTime,
                      SundayStartTime,ThursdayStartTime,Name,TimeZoneSidKey,TuesdayStartTime,WednesdayStartTime 
                      FROM BusinessHours WHERE IsActive = True];
        List<BusinessHourTempStore__c> bhTemps = new List<BusinessHourTempStore__c>();
        for(BusinessHours bh : bhs){
            BusinessHourTempStore__c bht = new BusinessHourTempStore__c();
            	bht.CoverageFriday__c = (bh.FridayStartTime!=null);
                bht.CoverageMonnday__c = (bh.MondayStartTime!=null);
                bht.CoverageSaturday__c = (bh.SaturdayStartTime!=null);
                bht.CoverageSunday__c = (bh.SundayStartTime!=null);
                bht.CoverageThursday__c = (bh.ThursdayStartTime!=null);
                bht.CoverageTuesday__c = (bh.TuesdayStartTime!=null);
                bht.CoverageWednesday__c = (bh.WednesdayStartTime!=null);
            	bht.EndTime__c = string.valueOf(bh.MondayEndTime);
            	bht.Integration_Id__c = null;
            	bht.IsDefault__c = bh.IsDefault;
            	bht.TimeZoneSIDKey__c = bh.TimeZoneSidKey;
                bht.Business_Hours_ID__c = bh.id;
            bhTemps.add(bht);
        }
        //setup business hours settings
        ServiceCloudSettings__c scSetting = new ServiceCloudSettings__c();
        scSetting.Name = 'DefaultBusinessHours';
        //scSetting.Value__c = bhId;
        list<ServiceContract> scs = new List<ServiceContract>();
        for(integer i = 0; i <51; i++){
            ServiceContract sc = new ServiceContract();
            	//Integer rand = Math.round(Math.random()*bhTemps.size())-1;
            	Integer rand = 0;
            	sc.Business_Hours_Integration__c = bhTemps[rand].Integration_Id__c;
            	sc.Name = 'test' + i;
                sc.AccountId = add.Account__c;
                sc.Service_Level__c = 'Standard';
                 sc.End_Customer_Account__c = add.Account__c;
                 sc.Bill_To_Account__c = add.Account__c;
                 sc.Ship_To_Account__c = add.Account__c;
                 sc.Bill_To_Address__c = add.id;
                 sc.Ship_To_Address__c = add.id;
                 sc.Oracle_Contract_Line_ID__c = 'ohid';
                 sc.Pricebook2Id = Test.getStandardPricebookId();
                 sc.Price_Book__c = Test.getStandardPricebookId();
            scs.add(sc);
        }
        insert scs;
        
    }
}