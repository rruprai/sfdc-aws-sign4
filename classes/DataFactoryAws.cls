/*
 * DataFactoryAws is mainly used for test classes to generate records.
 * You can have one large DataFactory or split DataFactory by applications so it is smaller chunks.
 * Smaller chunks also can be less overhead and easier to troubleshoot.
 */ 
public class DataFactoryAws {
    public static void createAwsConnector(integer numOfRecs, Integer nameLength, String awsName) {
        //instantiate variables
        List<Aws_Connection__c> awsConnectionsList = new List<Aws_Connection__c>();
        Aws_Connection__c awsConn = null;
        SObject sObjAwsConn = new Aws_Connection__c();
        Integer randomNumber = 0; 
        String domain = 'iam.amazonaws.com';
		AmzAwsWrapper awsWrapper = new AmzAwsWrapper(sObjAwsConn);        
        
        for(integer i = 0; i < numOfRecs; i++) { 
            awsConn = new Aws_Connection__c();
            awsConn.Name = awsName; 
            awsConn.Access_Key__c = ObjectUtility.generateRandomKey(25, 128);
            awsConn.AWS_Service_Name__c = awsWrapper.serviceNameList.get(ObjectUtility.getRandomNumber(awsWrapper.numOfServiceNames));
            awsConn.Canonical_URI__c = ObjectUtility.generateRandomUrl(domain, ObjectUtility.generateRandomString(nameLength));
            awsConn.Connection_Time_Out__c = 3600;
            awsConn.Digest_Hashing_Algorithm__c = awsWrapper.digHashAlgList.get(ObjectUtility.getRandomNumber(awsWrapper.numOfDigHasAlg));
            awsConn.End_Point__c = ObjectUtility.generateRandomUrl(domain, ObjectUtility.generateRandomString(nameLength));
            awsConn.Hashing_Algorithm__c = awsWrapper.hashingAlgList.get(ObjectUtility.getRandomNumber(awsWrapper.numOfHashAlg));
            awsConn.Host__c = ObjectUtility.generateRandomUrl(domain, ObjectUtility.generateRandomString(nameLength));
            awsConn.Host_Domain__c = ObjectUtility.generateRandomUrl(domain, '');
            awsConn.HTTP_Method__c = awsWrapper.httpMethodList.get(ObjectUtility.getRandomNumber(awsWrapper.numOfHttpMethods));
            awsConn.Region__c = awsWrapper.regionsList.get(ObjectUtility.getRandomNumber(awsWrapper.numOfRegions));
            awsConn.Secret_Key__c = ObjectUtility.generateRandomKey(nameLength, 128);
            //remember to review AWS documentation 
            awsConn.Signature_Hashing_Algorithm__c = awsWrapper.signHashAlgList.get(ObjectUtility.getRandomNumber(awsWrapper.numOfSignHashAlg));
            awsConn.Signature_Type__c = awsWrapper.signatureTypeList.get(ObjectUtility.getRandomNumber(awsWrapper.numOfSignType));
            //you need this to be all (remember to review AWS documentation to see what are needed)
            awsConn.Signed_Headers__c = ObjectUtility.getAllPicklistValues(awsWrapper.signedHeaderList, ';');
            awsConnectionsList.add(awsConn);
        }//end for
        
        if(awsConnectionsList.size() > 0) {
            insert awsConnectionsList;
        }//end if
    }//end createAwsConnector
    
    public static void createAccounts(Integer numOfAccnts, Integer lengthOfNames) {
        List<Account> newAcnts = new List<Account>();
        Account newAcnt = null;
        for(Integer num = 0; num < numOfAccnts; num++) {
            newAcnt = new Account();
            newAcnt.Name = ObjectUtility.generateRandomString(lengthOfNames);
            newAcnts.add(newAcnt);
        }//end for
        
        if(newAcnts.size() > 0) {
            insert newAcnts;
        }//end if
    }//createAccount
}//end DataFactoryAws