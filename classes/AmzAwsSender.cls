/*
 * Auth Header should be <accesskey>/<date>/<aws-region>/<aws-service>/aws4_request
 * Based on https://docs.aws.amazon.com/apigateway/api-reference/signing-requests/
 * http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-auth-using-authorization-header.html
 */
public class AmzAwsSender {
    private String accKey;
    private String secKey;
    private String region;
    private final String ymdFormat = 'YYYYMMDD';
    private final String hmsFormat = 'HHMMSS';
    //the gmt format is case sensitive. 
    private final String gmtFormat = 'yyyyMMdd\'T\'HHmmss\'Z\'';
    //date for credential header in ymd Format
    private String ymdDate;
    //date for credential header in hms format
    private String hmsDate;
    private String hashAlg;
    private String signHashAlg;
    private String digHasAlg;
    private String awsService;
    private String domainHost;
    private String signType;
    private String endPoint;
    private String uri;
    private String signedHdrs;
    private String contType;
    private String xAmzDate;
    private String canQryStr;
    private String httpMethod;
    private String hashPayload;
    private String credScope;
    private String authHdrs;
    private Integer timeOut;
    private Aws_Connection__c awsConn{get; set;}
    private Map<String, String> hdrParams;
    
    public AmzAwsSender(String awsName) {
        awsConn = AmzAwsHelper.getRecord(awsName);
        accKey = String.valueOf(awsConn.Access_Key__c);
        secKey = String.valueOf(awsConn.Secret_Key__c);
        region = awsConn.Region__c;
        hashAlg = awsConn.Hashing_Algorithm__c;
        signHashAlg = awsConn.Signature_Hashing_Algorithm__c;
        digHasAlg = awsConn.Digest_Hashing_Algorithm__c;
        awsService = awsConn.AWS_Service_Name__c;
        domainHost = awsConn.Host_Domain__c;
        signType = awsConn.Signature_Type__c;
        endPoint = awsConn.End_Point__c;
        uri = awsConn.Canonical_URI__c;
        signedHdrs = awsConn.Signed_Headers__c;
        contType = awsConn.Content_Types__c;
        httpMethod = awsConn.HTTP_Method__c;
        timeOut = Integer.valueOf(awsConn.Connection_Time_Out__c);
        DateTime nowDt = DateTime.now();
        String gmtDate = String.valueOf(nowDt.dateGMT());
        ymdDate = gmtDate.replace('-', '');
        credScope = generateCredentialScope();
    }//end AmzAwsConnector

    public void generateAuthHeaders(String json) {
       setXAmzDate();
       String canonReq = generateCanonicalRequest(json);
       String strToSign = createStrToSign(canonReq);
       String strSign = generateSignature(strToSign);
       authHdrs = hashAlg + ' ';
       authHdrs += 'Credential=' + accKey + '/'+ credScope +', ';
       authHdrs += 'SignedHeaders='+signedHdrs+', ';
       authHdrs += 'Signature='+strSign;
    }//end generateAuthHeaders

    private String generateCanonicalRequest(String json){
        String canReq='';
        String canonHdrs = generateCanonicalHeaders();
        canReq += httpMethod +'\n';
        canReq += uri + '\n';
        canReq += canQryStr + '\n';
        canReq += canonHdrs + '\n';
        canReq += signedHdrs + '\n';
        String payloadHash = EncodingUtil.convertToHex(Crypto.generateDigest(digHasAlg, Blob.valueOf(json)));
        canReq += payloadHash.toLowerCase();
        hashPayload = payloadHash.toLowerCase();
        return canReq;
    }//end genCanReq

    private String generateCanonicalHeaders() {
        String canHdrs = '';
        canHdrs += 'content-type:'+contType + '\n';
        canHdrs += 'host:'+domainHost+'\n';
        canHdrs += 'x-amz-date:'+xAmzDate+'\n';
        return canHdrs;
    }//end getCanonicalHdrs

    private void setXAmzDate() {
        DateTime requestDate = System.now();
        String formattedDateString = DateTime.now().formatGMT(gmtFormat);
        xAmzDate = formattedDateString;
    }//end setXAmzDate

    private String createStrToSign(String canReq) {
        String sign='';
        sign += hashAlg+'\n';
        sign += xAmzDate+'\n';
        sign += credScope +'\n';
        String canHash = EncodingUtil.convertToHex(Crypto.generateDigest(digHasAlg, Blob.valueOf(canReq)));
        sign += canHash.toLowerCase();
        return sign;
    }//end createStrToSign

    private String generateCredentialScope() {
        String credScp ='';
        credScp += ymdDate + '/' + region + '/' + awsService +'/'+signType;
        return credScp;
    }//end getCredScope

    //ksecret will need AWS4 or AWS4-HMAC-SHA256
    private String generateSignature(String signedStr) {
        String signature='';
        String kSecret = 'AWS4' + secKey;
        Blob kDate = Crypto.generateMac(signHashAlg,Blob.valueOf(ymdDate),Blob.valueOf(kSecret));
        Blob kRegion = Crypto.generateMac(signHashAlg, Blob.valueOf(region),kDate);
        Blob kService = Crypto.generateMac(signHashAlg, Blob.valueOf(awsService),kRegion);
        Blob kSigning = Crypto.generateMac(signHashAlg, Blob.valueOf('aws4_request'),kService);
        signature = EncodingUtil.convertToHex(Crypto.generateMac(signHashAlg, Blob.valueOf(signedStr),(kSigning)));
        return signature;
    }//end genSignature

    public String getEndPoint() {
        return endPoint;
    }//end getEndPoint

    public String getAuthHdrs() {
        return authHdrs;
    }//end getAuthHdrs

    public String getContType() {
        return contType;
    }//end getContType

    public String getDomainHost() {
        return domainHost;
    }//end getDomainHost

    public String getHashPayload() {
        return hashPayload;
    }//end getHashPayload

    public String getXAmzDate() {
        return xAmzDate;
    }//end getXAmzDate

    public String getHttpMethod() {
        return httpMethod;
    }//end getHttpMethod

    public Integer getTimeOut() {
        return timeOut;
    }//end getTimeOut
}//end AmzAwsSender