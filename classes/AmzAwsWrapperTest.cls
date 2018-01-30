/*
 * Test Class for AmzAwsWrapper
 * We will keep it simple, but a future goal will be to make it more robust
 */ 
@isTest
public class AmzAwsWrapperTest {
    
    @testSetup
    static void setupData() {
        DataFactoryAws.createAwsConnector(1, 20, 'testAwsConnector');
        Account acnt = new Account (Name = ObjectUtility.generateRandomString(15));
        insert acnt;
    }//end setupData
    
    static testmethod void amzAwsWrapperTest() {
        AmzAwsWrapper awsWrapper = new AmzAwsWrapper(new Aws_Connection__c());
        //Let's make sure we can get the number of http methods from object
        Boolean actual = (awsWrapper.numOfHttpMethods > 0) ? true : false;
        System.assertEquals(true, actual);
    }
}//end AmzAwsWrapperTest