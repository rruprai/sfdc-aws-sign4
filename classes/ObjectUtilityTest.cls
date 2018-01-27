/*
 * Test class for ObjectUtility
 * Goal is to generate higher than 90% code coverage
 */ 
@isTest
public class ObjectUtilityTest {
    static testmethod void generateRandomStringTest(){
        String foo = ObjectUtility.generateRandomString(10);
        String fooBar = ObjectUtility.generateRandomString(10);
        Boolean actual = (foo.equalsIgnoreCase(fooBar)) ? true : false;
        
        //should they be the same?
        System.assertNotEquals(true, actual);
    }//generateRandomStringTest
    
    static testmethod void getRandomNumberTest() {
        Integer numberRange = 100;
        Integer randomFoo = ObjectUtility.getRandomNumber(numberRange);
        Integer randomBar = ObjectUtility.getRandomNumber(numberRange);
        
        Boolean actual = ((randomFoo <= numberRange) | (randomBar <= numberRange)) ? true : false;
        System.assertEquals(true, actual);
    }//end getRandomNumberTest
    
    static testmethod void generateRandomKeyTest() {
        Integer keyLength = 20;
        Integer aesKeyLength = 128;
        
        String randomKey = ObjectUtility.generateRandomKey(keyLength, aesKeyLength);
        //since the key is going to be random we just need to ensure length > 0 so atleast we have something
        Boolean actual = (randomKey.length() > 0) ? true : false;
        System.assertEquals(true, actual);
    }//end generateRandomKeyTest
    
    static testmethod void getPicklistValuesTest() {
        SObject sObjAcnt = new Aws_Connection__c();
        String fieldName = 'Signature_Type__c';
        Boolean getDefaultOnly = false;
        List<String> signatureTypeList = ObjectUtility.getPicklistValues(sObjAcnt, fieldName, getDefaultOnly);
        //unless we want to check for certain values let's just check to make sure we get any values back
        Boolean actual = (signatureTypeList.size() > 0) ? true : false;
        System.assertEquals(true, actual);
    }//end getPicklistValues
    
    static testmethod void generateRandomUrlTest() {
        String domain = 'iam.amazonaws.com';
        String uri = '';
        String randomUrl = ObjectUtility.generateRandomUrl(domain, uri);
        //unless we want to validate against a particular domain, let's ensure we atleast get a value back
        Boolean actual = (randomUrl.length() > 0) ? true : false;
        System.assertEquals(true, actual);
    }//end generateRandomUrlTest
    
    static testmethod void getAllPicklistValuesTest() {
        AmzAwsWrapper awsWrapper = new AmzAwsWrapper(new Aws_Connection__c());
        Boolean actual = (awsWrapper.numOfSignHashAlg > 0) ? true : false;
        System.assertEquals(true, actual);
    }//end getAllPicklistValuesTest
    
    static testmethod void getMultiSelectPicklistValuesTest() {
        String separator = '|';
        AmzAwsWrapper awsWrapper = new AmzAwsWrapper(new Aws_Connection__c());
        String multiSelectPicklist = ObjectUtility.getAllPicklistValues(awsWrapper.signedHeaderList, separator);
        Boolean actual = (multiSelectPicklist.containsIgnoreCase(separator)) ? true : false;
        System.assertEquals(true, actual);
    }//end getMultSelectPickListValuesTest() 

}//end ObjectUtilityTest