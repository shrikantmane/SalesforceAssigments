public with sharing class ApexAdvancedConcepts {
    
   public static void GetContactList(){
      List<Contact> cList = [SELECT AccountId,Email,FirstName,LastName FROM Contact];
      System.debug(cList);
      //Syste.debug(Clist.get(0));
   }
   
   public static void GetContactsByAccount(String AccountID){
      List<Contact> cList = [SELECT AccountId,Email,FirstName,LastName,LastModifiedDate FROM Contact Where Contact.AccountId = :AccountID];
      System.debug(cList);
      //Syste.debug(Clist.get(0));
   }
   
   /* public static void InsertSingleAccount(String AccountID){
       Account newAcct = new Account(name = 'TestAccount');
       insert newAcct;
    }*/
    // Create Accounts
    public static void InsertAccounts(Integer Count, String AccountInitialName){
    	List<Account> accountList = new List<Account>(); 
        for (Integer AccountNum =1; AccountNum <= Count; AccountNum++){
       		Account accountObj =new Account(name = AccountInitialName+ AccountNum );
       		accountList.add(accountObj);
       }
       insert accountList;
       System.debug('Created '+Count +' accounts!!');
       List<Contact> contactsObj =new List<Contact>();
       for(Account acc : accountList){
       	Contact newContact = new Contact (
										LastName = 'XyZLast',
										AccountId = acc.Id,
										Email = 'xyz@mail.com'
										);
		contactsObj.add(newContact);							
       	}
       	insert contactsObj;
       }    
}