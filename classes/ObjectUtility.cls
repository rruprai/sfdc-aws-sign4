/*
 * Mainly used to generate data for fields such as Picklist, Boolean, Text, etc. at random
 * There are many out in the community, but this is specifically for AWS classes
 */ 
public class ObjectUtility {
    
    public static string generateRandomString(Integer strLength) {
        String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        Integer charLength = chars.length();
        String randomStr = ''; 
        Integer randomIndex = 0;
        while(randomStr.length() < strLength) {
            //generate random number between 0-chars
            randomIndex = getRandomNumber(charLength);
            //concatenate character to string
            randomStr += chars.indexOfChar(randomIndex);
        }//end while
        
        return randomStr;
    }//end generateRandomString
    
    public static Integer getRandomNumber(Integer range){
        Double rand = Math.random() * range;
        return (rand.intValue());
    }//end getRandomNumber
    
    public static String generateRandomKey(Integer keyLength, Integer aesKeySize) {
        Blob key = Crypto.generateAesKey(aesKeySize);
        String randomKey = EncodingUtil.convertToHex(key);
        return randomKey.substring(0, keyLength);
    }//end generateRandomKey
    
    public static List<String> getPicklistValues(SObject sObj, String fieldName, Boolean getDefaultOnly) {
        List<String> picklistVals = new List<String>();
        //get the sObjectType, results, fieldmap, and finally the picklist values
        Schema.SObjectType sobjType = sObj.getSObjectType();
        Schema.DescribeSObjectResult sObjResult = sobjType.getDescribe();
        Map<String, Schema.SObjectField> sObjFieldMap = sObjResult.fields.getMap();
        //lowercase fieldName since the machine value will be used as key in map
        List<Schema.PicklistEntry> sObjPickListEntryList = sObjFieldMap.get(fieldName.toLowerCase()).getDescribe().getPickListValues();
        //only return default value if true is passed in. if no default value then return all
        for (Schema.PicklistEntry entry : sObjPickListEntryList) {
            if(entry.isDefaultValue() && getDefaultOnly) {
                picklistVals.clear();
                picklistVals.add(entry.getValue());
                break;
            }//end if
            else {
            	picklistVals.add(entry.getValue());    
            }//end else
        }//end for
        
        return picklistVals;
    }//end getPicklistValues
    
    public static String generateRandomUrl(String domain, String uri) {
        String randomUrl = 'https://' + domain + '/' + uri;
        return randomUrl;
    }//end getSalesforceBaseUrl
    
    public static String getAllPicklistValues(List<String> picklist, String separator) {
        String vals = '';
        for(String val : picklist) {
            vals+=val + separator;
        }
        return vals;
    }//end getAllPicklistValues

    public static List<String> getMultiSelectPicklistValues(String multiSelectList, String separator) {
        return (multiSelectList.split(separator));
    }//end getMultiPicklistValues
    
}//end ObjectUtility