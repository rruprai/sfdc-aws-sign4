/*
 * Test class for AmzAwsHelper class.
 * May not be needed since you may call these method in other classes, but good practice to have.
 * Goal is to generate higher than 90% code coverage
 */ 
@isTest
public class AmzAwsHelperTest {
	@testSetup 
    static void setupData() {
        //we shall create one for now
        DataFactoryAws.createAwsConnector(1, 20, 'testAwsConnector');
        Account acnt = new Account (Name = ObjectUtility.generateRandomString(20));
        insert acnt;
    }//end setupData
    
    static testmethod void getRecordTest() {
        Aws_Connection__c testConn = AmzAwsHelper.getRecord('testAwsConnector');
        Boolean actual = (testConn != null) ? true : false;
        Boolean expected = true;
        System.assertEquals(expected, actual);
    }//end getRecordTest
    
    static testmethod void getAllRecordsTest() {
        DataFactoryAws.createAwsConnector(2, 10, 'awsConnections');
        List<Aws_Connection__c> conns = AmzAwsHelper.getAllRecords();
        Boolean actual = (conns.size() > 0) ? true : false;
        Boolean expected = true;
        System.assertEquals(expected, actual);
    }//end getAllRecordsTest
    
    static testmethod void generateJsonBodyTest() {
        Account testAcnt = [Select Id, Name
                           From Account Limit 1];
        JSONGenerator jsonGen = JSON.createGenerator(TRUE);
        AmzAwsHelper.generateJsonBody(jsonGen, testAcnt);
        Boolean actual = (jsonGen.getAsString().length() > 0 ) ? true : false;
        System.assertEquals(true, actual);
    }//end generateJsonBodyTest
}//end AmzAwsHelperTest