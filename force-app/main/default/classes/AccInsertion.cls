public with sharing class AccInsertion {
    public static void insertRecord() {
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i <= 4; i++){
            accList.add(
                new Account(
                    Name = 'Test 44' + i, 
                    Phone = '912255640'+i
                )
            );
        }

        if(!accList.isEmpty()){
            insert accList;
        }
        System.debug('Working');
    }
}