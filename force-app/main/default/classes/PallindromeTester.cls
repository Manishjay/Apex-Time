public with sharing class PallindromeTester {
    // method for pallindrome logic
    public static Boolean isPallindrome(String str) {
        String cleanStr = str.replaceAll('[^a-zA-Z0-9]', '').toLowerCase();

        String reversedStr = '';
        for(Integer i = cleanStr.length() - 1; i >= 0; i--) {
            reversedStr += cleanStr.substring(i, i+1);
        }

        return reversedStr == cleanStr;

    }

    // Method to provide the output T/F
    public static void testPallindrome () {
        String testStr1 = 'Dam';
        Boolean result1 = isPallindrome(testStr1);
        System.debug('The Provided String is pallindrome: ' + result1);

        String testStr2 = 'MAdam';
        Boolean result2 = isPallindrome(testStr2);
        System.debug('The String MAdam is Pallindrome: ' + result2);
    }
}