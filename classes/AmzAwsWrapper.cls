/*
 * AmzAws: contains necessary instances of fields
 * Updated whenever new fields are added/modified/deleted
 */ 
public class AmzAwsWrapper {
    //place field api names in variables in case someone wants to do anything with them before passing them into methods
    public final String serviceName = 'AWS_Service_Name__c';
    public final String contentTypes = 'Content_Types__c'; 
    public final String digHasAlg = 'Digest_Hashing_Algorithm__c';
    public final String hashingAlgorithm = 'Hashing_Algorithm__c';
    public final String httpMethod = 'HTTP_Method__c';
    public final String region = 'Region__c';
    public final String signHashAlg = 'Signature_Hashing_Algorithm__c';
    public final String signatureType = 'Signature_Type__c';
    public final String signedHeaders = 'Signed_Headers__c';
    
    //get sizes of picklist value list
    public Integer numOfServiceNames; 
    public Integer numOfContentTypes;
    public Integer numOfDigHasAlg;
    public Integer numOfHashAlg;
    public Integer numOfHttpMethods;
    public Integer numOfSignHashAlg;
    public Integer numOfSignType;
    public Integer numOfSignedHeaders;
    public Integer numOfRegions;
    
    //list of picklist values
    public List<String> serviceNameList;
    public List<String> contentTypeList;
    public List<String> digHashAlgList;
    public List<String> hashingAlgList;
    public List<String> httpMethodList;
    public List<String> regionsList;
    public List<String> signHashAlgList;
    public List<String> signatureTypeList;
    public List<String> signedHeaderList;
    
    public AmzAwsWrapper(SObject sObjAwsConn) {
        //set all of the picklist fields
        serviceNameList = ObjectUtility.getPicklistValues(sObjAwsConn, serviceName, false);
        contentTypeList = ObjectUtility.getPicklistValues(sObjAwsConn, contentTypes, false);
        digHashAlgList = ObjectUtility.getPicklistValues(sObjAwsConn, digHasAlg, true);
        hashingAlgList = ObjectUtility.getPicklistValues(sObjAwsConn, hashingAlgorithm, true);
        httpMethodList = ObjectUtility.getPicklistValues(sObjAwsConn, httpMethod, true);
        regionsList = ObjectUtility.getPicklistValues(sObjAwsConn, region, true);
        signHashAlgList = ObjectUtility.getPicklistValues(sObjAwsConn, signHashAlg, true);
        signatureTypeList = ObjectUtility.getPicklistValues(sObjAwsConn, signatureType, true);
        signedHeaderList = ObjectUtility.getPicklistValues(sObjAwsConn, signedHeaders, false);    
        
        //get size of lists
        numOfServiceNames = serviceNameList.size();
        numOfContentTypes = contentTypeList.size();
        numOfDigHasAlg = digHashAlgList.size();
        numOfHashAlg = hashingAlgList.size();
        numOfHttpMethods = httpMethodList.size();
        numOfSignHashAlg = signHashAlgList.size();
        numOfSignType = signatureTypeList.size();
        numOfSignedHeaders = signedHeaderList.size();
        numOfRegions = regionsList.size();
    }//end default constructor
    
}//end AmzAwsWrapper