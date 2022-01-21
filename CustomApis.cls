@RestResource(urlMapping='/getRecordType')
global class CustomApis {
	@HttpGet
  // Method gets record type name through a query string parameter and then using the getRecordTypeInfosByName method 
  // to return the corresponding ID against that record type. Using this method avoids a database call using a loop in the Mule flow.
    global static String getAccountRecordTypeId() {
        String recordTypeId;
        String recordTypeName = RestContext.request.params.get('recordType');
        System.debug('Record Type: ' + recordTypeName);
        if(recordTypeName==null || recordTypeName=='') {
            recordTypeName = 'Organization';
        }
        try {
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        }
        catch(Exception exp) {
            System.debug('Error: ' + exp.getMessage());
        }
        return recordTypeId;
    }
}
