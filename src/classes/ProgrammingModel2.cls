public with sharing class ProgrammingModel2 {
	public static void GetContactList(){
    	List < Contact > cList = [SELECT  Email, FirstName, LastName, LastModifiedDate FROM Contact];
    	System.debug(cList);
	}
	public static void GetActiveUsers(){
    	Map <Id, User > userMap =  new Map < Id, User > ([SELECT Id, Name FROM User WHERE IsActive = true]);
    	System.debug(userMap);
	}
	
	public static void MapObjectDemo(){
    	Map < String, String > map1AvvoutObj = new Map < String, String > ();
        List < Account > accList = new List < Account > ([SELECT Id, Name FROM Account LIMIT 10]);
        for (Account accountVar: accList) {
            map1AvvoutObj.put(accountVar.Name, accountVar.Id);
        }
        System.debug(map1AvvoutObj);
        
        Map < ID, Account > map2AccountObj = new Map < ID, Account > ([SELECT Id, Name FROM Account LIMIT 10]);
        //System.debug(map2AccountObj);
        
	}
	public static void PicklistDemo(){
    	List < Account > accList1 = [SELECT  Name,Id,Enrollment_Year__c FROM Account Where Enrollment_Year__c = '2010'];
    	//System.debug(accList1);
    	List < Account > accList2 = [SELECT  Name,Id,Enrollment_Year__c FROM Account Where Enrollment_Year__c = '2013;2014'];
    	System.debug(accList2);
	}
	public static void NotSyntexInDemo(){
    	List < Account > accList = [SELECT AccountNumber,BillingState,Name FROM Account WHERE BillingState NOT IN ('Maharashtra','kerala') ORDER BY BillingState DESC NULLS LAST LIMIT 10000];
    	System.debug(accList);
	}
	public static void OffsetDemo(){
    	List < Opportunity > opportunityList = [SELECT Name,Amount,CreatedDate FROM Opportunity WHERE Amount > 10000  ORDER BY CreatedDate ASC NULLS LAST  LIMIT 100 OFFSET 10 ALL ROWS];
    	System.debug(opportunityList);
	}
	
	//Aggregate Functions
	public static void SUMDemo(){
		//Integer CurrYear = Date.Today().Year();
		//System.debug(CurrYear);
		//AggregateResult[] groupedResults = [SELECT SUM(Amount), FISCAL FROM Opportunity WHERE IsClosed = true AND CALENDAR_YEAR(CloseDate) =: CurrYear GROUP BY FISCAL];
		Map<string, Integer> opportunityMap =new Map<string, Integer>();
    	AggregateResult[] groupedResults = [SELECT SUM(Amount), FISCAL FROM Opportunity WHERE IsClosed = true AND CloseDate = THIS_FISCAL_YEAR GROUP BY FISCAL];
    	for (AggregateResult ar : groupedResults){
 		opportunityMap.put(string.valueOf(ar.get('FISCAL')),integer.valueof(ar.get('expr0')));
    	} 
    	System.debug(opportunityMap);
	}
	public static void CountDemo(){
		Map<String, Integer> mapLeads =new Map<String,Integer>();
    	AggregateResult[] groupedResults = [SELECT LeadSource, COUNT(Name) FROM Lead  GROUP BY LeadSource Having COUNT(Name)>4];
    	for (AggregateResult ar : groupedResults){
 		mapLeads.put(string.valueOf(ar.get('LeadSource')),integer.valueof(ar.get('expr0')));
    	} 
    	System.debug(mapLeads);
	}
	
	public static void TotalLeadRecords(){

		Map<String, Map<String, Integer>> mapAllLeads = new Map<String, Map<String, Integer>>();
    	//AggregateResult[] groupedResults = [SELECT LeadSource, Status, COUNT(Name) FROM Lead  GROUP BY ROLLUP(Status,LeadSource) ];
    	//System.debug(groupedResults);    	
    	AggregateResult[] groupedResults = [SELECT Status FROM Lead Group By Status];
    	//System.debug(groupedResults);
    	for (AggregateResult ar : groupedResults){
        	Map<String, Integer> mapLeads =new Map<String,Integer>();
        	String status = (String)ar.get('Status');
            AggregateResult[] leadSourceWiseResults = [SELECT LeadSource, count(Name) FROM Lead WHERE Status =:status Group By LeadSource];
            for(AggregateResult leadSoruce : leadSourceWiseResults){
            	mapLeads.put(string.valueOf(leadSoruce.get('LeadSource')),integer.valueof(leadSoruce.get('expr0')));
            }
            mapAllLeads.put(status,mapLeads);
    	} 
    	System.debug(mapAllLeads);
	}
	
	//Child to Parent
	public static void ChildToParentDemo(){
    	List < Contact > contactList = [SELECT Id, Name, Account.Name FROM Contact WHERE Account.Industry = 'Media'];
    	System.debug(contactList);
	}
	
	public static void ChildToParentJuntionObjectDemo(){
    	List < C__c > cList = [SELECT Id,Name,  AName__r.Name,  AName__r.Short_Description__c FROM C__c WHERE Name = 'John'];
    	for (C__C cObject : cList){
    		System.debug('C Name: '+cObject.Name+' :::: A Description: '+ cObject.AName__r.Short_Description__c);
			}
    }
    
    //Parent to Child
    
	public static void ParentToChildDemo(){
    	List < Account > accList = [SELECT Id, Name, (Select Name From Contacts Where Name Like '%John%') FROM Account];
    	//System.debug(accList);
    	for (Account accountObject : accList){
    		System.debug('AccountName: '+accountObject.Name);
	    	for(Contact c : accountObject.Contacts){ 
	    		System.debug('Contacts: ' + c.Name);
	    	}
		}
	}
	
	public static void ParentToChild2Demo(){
    	List < Account > accList = [SELECT Id,Name FROM Account Where Id IN(Select AccountId from Opportunity Where StageName = 'Closed Won')  ];
    	System.debug(accList);
	}
	
	public static void ParentToChild3Demo(){
    	List < A__c > aList = [SELECT Id,Name FROM A__c Where Id IN(Select AName__c FROM C__c Where Name = 'John')  ];
    	System.debug(aList);
	}
	
	//SOSL
	public static void SOSLDemo(){
    	List<List<SObject>> searchList = [FIND 'test' IN ALL FIELDS RETURNING  Contact(Id, Name), Account(Id, Name), Opportunity(Id, Name), Lead(Id, Name), User];
    	Contact [] contacts = ((List<Contact>)searchList[0]);
    	Account [] accounts = ((List<Account>)searchList[1]);
    	
    	System.debug(contacts);
    	System.debug(accounts);
	}
	
	
	public static void DatabaseClassDemo(){
		Database.DMLOptions dmo = new Database.DMLOptions();
    	dmo.assignmentRuleHeader.useDefaultRule= true;
    	
    	Lead lead1 = new Lead();
	    lead1.LastName='Lead9';
	    lead1.Company='Company9';
	    lead1.City='Pune';
		lead1.setOptions(dmo);
		
		Lead lead2 = new Lead();
		lead2.LastName='Lead10';
	    //leads2.Company='Company10';
	    lead2.City='Mumbai';
		lead2.setOptions(dmo);
		
		Lead lead3 = new Lead();
		lead3.LastName='Lead11';
	    lead3.Company='Company11';
	    lead3.City='Nashik';
		lead3.setOptions(dmo);
		
		List<Lead> allLeads =new List<Lead>();
		allLeads.add(lead1);
		allLeads.add(lead2);
		allLeads.add(lead3);  
		
		Database.SaveResult[] srList = Database.insert(allLeads, false);
		List<Logs__c> logsList =new List<Logs__c>();
		for (Database.SaveResult sr : srList) {
		    if (!sr.isSuccess()) {               
		        for(Database.Error err : sr.getErrors()) {
		        	Logs__c newLog = new Logs__c();
		        	newLog.Error__c =err.getMessage();
		        	logsList.add(newLog);
		        }
		    }
		}
		insert logsList;
	}
	
	public static void DeleteLastNAccounts(){
		//Integer NoOfDays =Days;
    	List < Account > accList = [SELECT Id,Name From Account Where CreatedDate = LAST_N_DAYS: 90 ];
    	System.debug(accList);
	}
	
}