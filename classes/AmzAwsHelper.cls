/*
 * Generic AmzAwsHelper classes used as a helper class.
 * Use startArray and endArray if you want '[' in json 
 * Use startObject and endObject if you want to insert '{'
 * GenerateJsonBody fully depends on your implementation. 
 * * consider this more of a sample JSON you can send. 
 * * If you are sending data based on create, delete, or edit you can also pass in the object
 */ 
public class AmzAwsHelper {
    public static Aws_Connection__c getRecord(String awsName) {
        return [Select Name, Access_Key__c,Connection_Time_Out__c,AWS_Service_Name__c,Canonical_URI__c,Content_Types__c,Digest_Hashing_Algorithm__c,End_Point__c,Hashing_Algorithm__c,
                Secret_Key__c, Host__c, Host_Domain__c, HTTP_Method__c, Region__c, Signature_Hashing_Algorithm__c,Signature_Type__c, Signed_Headers__c
                from Aws_Connection__c
                Where Name =: awsName];
    }//end getRecord
    
    public static List<Aws_Connection__c> getAllRecords() {
        return [Select Name, Access_Key__c,Connection_Time_Out__c,AWS_Service_Name__c,Canonical_URI__c,Content_Types__c,Digest_Hashing_Algorithm__c,End_Point__c,Hashing_Algorithm__c,
                Secret_Key__c, Host__c, Host_Domain__c, HTTP_Method__c, Region__c, Signature_Hashing_Algorithm__c,Signature_Type__c, Signed_Headers__c
                from Aws_Connection__c];
    }//end getAllRecords
    
    /*
    * if you have a multi-select picklist, you can use a comma demiliter for ease of parsing
    * They are separate by ";", but we will use "|" delimiter as an example. 
    * Assumes you have a multi-select picklist, skip if not needed
    * Example: acntServices is a multi-select picklist in my org with values of IOT, Auditing, Security
    * Replace sampleValues with your multi-select picklist
    * You are more than welcome to put sender, receiver, type, etc into a config object, custom setting, custom metadata type, etc.
    */ 
    public static void generateJsonBody(JSONGenerator jsonGen, Account acnt) {
        //opening curly brace  
        jsonGen.writeStartObject();
        //some values that can be used for filtering once request is sent
        jsonGen.writeStringField('sender', 'Salesforce');
        jsonGen.writeStringField('receiver', 'receiverApplication');
        jsonGen.writeStringField('type', 'sometype');
        jsonGen.writeStringField('object', 'Account');
        
        //insert body so it can be traversed
        jsonGen.writeFieldName('body');
        jsonGen.writeStartObject();
        //for single values you can just use this
        jsonGen.writeStringField('action', 'create');
        jsonGen.writeStringField('AccountId', acnt.Id);
        jsonGen.writeStringField('AccountName', acnt.Name);
            
        //assumes you need to manipulate the delimiter for multi-select picklist
        String acntServices = '';
        String delimiter = '|';
        //<!-- replace with multi-select picklist -->
        String sampleValues = 'IOT;Auditing;';
        List<String> servicesList = ObjectUtility.getMultiSelectPicklistValues(sampleValues, ';');
        for(String service : servicesList) {
            acntServices += service + delimiter;
        }//end for        
        acntServices = '[' + acntServices.removeEnd(delimiter) + ']';
        //<!-- end -->        
        
        jsonGen.writeStringField('AccountServices', acntServices);
        //closing body brace
        jsonGen.writeEndObject();
        
        //close JSON
        jsonGen.writeEndObject();
    }//end generateJsonBody
    
}//end AmzAwsHelper