public with sharing class ApexAdvancedConcepts {

    public static void GetContactList() {
        List < Contact > cList = [SELECT AccountId, Email, FirstName, LastName FROM Contact];
        System.debug(cList);
        //Syste.debug(Clist.get(0));
    }

    public static void GetContactsByAccount(String AccountID) {
        List < Contact > cList = [SELECT AccountId, Email, FirstName, LastName, LastModifiedDate FROM Contact Where Contact.AccountId =: AccountID];
        System.debug(cList);
        //Syste.debug(Clist.get(0));
    }

    /* public static void InsertSingleAccount(String AccountID){
        Account newAcct = new Account(name = 'TestAccount');
        insert newAcct;
     }*/

    // Create Accounts # Test comments
    public static void InsertAccounts(Integer Count, String AccountInitialName) {
        List < Account > accountList = new List < Account > ();
        for (Integer AccountNum = 1; AccountNum <= Count; AccountNum++) {
            Account accountObj = new Account(name = AccountInitialName + AccountNum);
            accountList.add(accountObj);
        }
        insert accountList;
        System.debug('Created ' + Count + ' accounts!!');
        List < Contact > contactsObj = new List < Contact > ();
        for (Account acc: accountList) {
            Contact newContact = new Contact(
                LastName = 'XyZLast',
                AccountId = acc.Id,
                Email = 'xyz@mail.com'
            );
            contactsObj.add(newContact);
        }
        insert contactsObj;
    }

    //Show Parent child relationship
    // 1- Parent to child
    public static void ShowParentChildRelationship() {
        List < Account > aList = [SELECT Name, (SELECT LastName FROM Contacts) FROM Account];
        //System.debug(aList);


        Contact cList = [Select LastName, Account.Name from contact where id = '0037F00000FYDlx'];

        //System.debug(cList);

        Map < ID, User > userMap = new Map < ID, User > ([SELECT Id, Name FROM User WHERE IsActive = true]);
        //System.debug(userMap);

        Map < String, String > map1AvvoutObj = new Map < String, String > ();
        List < Account > accList = new List < Account > ([SELECT Id, Name FROM Account LIMIT 10]);
        for (Account accountVar: accList) {
            map1AvvoutObj.put(accountVar.Name, accountVar.Id);
        }
        //System.debug(map1AvvoutObj);



        Map < ID, Account > map2AccountObj = new Map < ID, Account > ([SELECT Id, Name FROM Account LIMIT 10]);
        System.debug(map2AccountObj);

    }

    public static void DataBaseClassDemo() {
        // Create the list of sObjects to insert
        List < Account > acctList = new List < Account > ();
        acctList.add(new Account(Name = 'Acme100'));
        acctList.add(new Account(Name = 'Acme101'));

        // DML statement
        Database.SaveResult[] srList = Database.insert(acctList, false);

        // Iterate through each returned result
        for (Database.SaveResult sr: srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            } else {
                // Operation failed, so get all errors                
                for (Database.Error err: sr.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
}