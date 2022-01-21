// An extension of the CalloutClient class built for the integration which handles the HTTP response
public with sharing class StripeChargeCardCalloutClient extends CalloutClient {
    private static final String BASE_ENDPOINT = 'callout:StripeBaseEndpoint';
    private static final String TOKEN = StripeConfig__mdt.getInstance('Token').Value__c;
    private static final String SUCCESS_CHARGE_STATUS = 'succeeded';
    private static String ENDPOINT = '/charges';
    private String chargeCardRequest;
    public StripeChargeCardCalloutClient() {}
    public CardResponse chargeCard(Integer chargeAmount, String chargeCurrency, String chargeSource) {
        generateRequest(chargeAmount, chargeCurrency, chargeSource);
        createRequest();
        doCallout();
        return handleResponse();
    }
    public override Object getResponseObject() {
        try {
            return JSON.deserialize(getResponseBody(), CardResponse.class);
        } catch (JSONException ex) {
            throw new JSONException('Response deserialization has failed.');
        }
    }
    private void generateRequest(Integer chargeAmount, String chargeCurrency, String chargeSource) {
        chargeCardRequest = 'amount=' + chargeAmount + 
                            '&currency=' + EncodingUtil.urlEncode(chargeCurrency, 'UTF-8') + 
                            '&source=' + EncodingUtil.urlEncode(chargeSource, 'UTF-8');
    }
    private void createRequest() {
        request = super.createRequest(HTTP_METHOD_POST);
        request.setEndpoint(BASE_ENDPOINT + ENDPOINT);
        request.setHeader(HEADER_AUTHORIZATION, HEADER_BEARER_AUTHORIZATION + ' ' + TOKEN);
        request.setBody(chargeCardRequest);
    }
    private CardResponse handleResponse() {
        if (isStatusCodeOk()) {
            return (CardResponse) getResponseObject();
        } else {
            throw new CalloutClientException('Invalid status code: ' + getResponseStatusCode());
        }
    }
    public class CardResponse {
        public String id;
        public String status;
    }
}
