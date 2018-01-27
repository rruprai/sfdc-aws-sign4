/*
 * Test class for AmzAwsSender.
 * Ensure SeeAllData=false (default)
 * Use latest API Version for test classes
 * https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_testsetup_using.htm
 * Goal is to generate higher than 90% code coverage
 */
@isTest
public class AmzAwsSenderTest {
	@testSetup 
    static void setupData() {
        //we shall create one for now
        DataFactoryAws.createAwsConnector(1, 20, 'testawsSender');
        DataFactoryAws.createAccounts(10, 20);
    }//end setupData
    
    /*
     * This can also serve as a sample way to use the AmzAwsSender. 
     * You need to create your own class to send the data
     */ 
    static testmethod void amzAwsConnectorTest() {
        try {
            AmzAwsSender awsSender = new AmzAwsSender('testawsSender');
            //need to generate randomJson (for now we will use predefined)
            JSONGenerator jsonGen = JSON.createGenerator(TRUE);
            Account acnt = [Select Id, Name 
                           From Account
                           limit 1];
            AmzAwsHelper.generateJsonBody(jsonGen, acnt);
            String jsonBody = jsonGen.getAsString();
            String contentLength = String.valueOf(jsonBody.length());
            awsSender.generateAuthHeaders(jsonBody);
            
            //instantiate and set request headers
            HttpRequest awsReq = new HttpRequest();
            awsReq.setEndpoint(awsSender.getEndPoint());
            awsReq.setHeader('Authorization', awsSender.getAuthHdrs());
            awsReq.setHeader('content-length', contentLength);
            awsReq.setHeader('content-type', awsSender.getContType());
            awsReq.setHeader('host', awsSender.getDomainHost());             
            awsReq.setHeader('x-amz-content-sha256', awsSender.getHashPayload());
            awsReq.setHeader('x-amz-date', awsSender.getXAmzDate());
            awsReq.setMethod(awsSender.getHttpMethod()); 
            awsReq.setBody(jsonBody); 
            awsReq.setTimeout(awsSender.getTimeOut());
            
            try {
                HTTP httpSender = new HTTP();
                HttpResponse awsResponse = httpSender.send(awsReq);
                //let's log some simple information about the request we should make this asynchronous at some point
                Aws_Log_Entry__c logEntry = new Aws_Log_Entry__c();
                logEntry.Body__c = awsResponse.getBody();
                String[] awsResponseHeaderKeys = awsResponse.getHeaderKeys();
                for(String key : awsResponseHeaderKeys) {
                    //you need to modify to best fit what you need
                    logEntry.Header__c += 'Header: ' + key +'; Value: ' +awsResponse.getHeader(key) + '|';    
                }//end for
                logEntry.Status__c = awsResponse.getStatus();
                logEntry.Status_Code__c = String.valueOf(awsResponse.getStatusCode());
                insert logEntry;
                
                //you may not get an exception so you will need to your own handling of that scenario
                //make sure to always log as much as possible either on Salesforce or AWS 
                if(awsResponse.getStatusCode() != 200) {
                    //process if not desired status code
                }//end if
                else {
                    //do something else if it is 200
                }
            }catch(CalloutException calloutExc) {
                //perform some action when it fails
            }
        }catch(Exception exp) {
            //perform some action (i.e. send admins email using exp variable) like send an email to all admins
        }
    }//end amzAwsConnectorTest
}//end AmzAwsConnectorTest