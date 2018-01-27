/*
 * Test Class for DataFactoryAws
 * Goal is to generate higher than 90% code coverage
 */ 
@isTest
public class DataFactoryAwsTest {
    static testmethod void createAwsConnectorTest() {
        DataFactoryAws.createAwsConnector(5, 20,'testConnection');
        List<Aws_Connection__c> conns = AmzAwsHelper.getAllRecords();
        Boolean actual = (conns.size() > 0) ? true : false;
        Boolean expected = true;
        
        System.assertEquals(expected, actual);
    }//end createAwsConnectorTest
}//end DataFactoryAwsTest