public with sharing class StripeGetPriceCalloutClient extends CalloutClient {
    
    private static final String BASE_ENDPOINT = 'callout:StripeBaseEndpoint';
    private static final String TOKEN = StripeConfig__mdt.getInstance('Token').Value__c;
    
    private static String ENDPOINT = '/prices/';
    
    private PriceResponse priceResponse;
    
    public StripeGetPriceCalloutClient() {}

    public PriceResponse getPrice(String priceId) {
        generateRequest(priceId);
        createRequest();
        doCallout();
        return handleResponse();
    }

    public override Object getResponseObject() {
        try {
            return JSON.deserialize(getResponseBody(), PriceResponse.class);
        } catch (JSONException ex) {
            throw new JSONException('Response deserialization has failed.');
        }
    }

    private void generateRequest(String priceId) {
        ENDPOINT += priceId;
    }

    private void createRequest() {
        request = super.createRequest(HTTP_METHOD_POST);
        request.setEndpoint(BASE_ENDPOINT + ENDPOINT);
        request.setHeader(HEADER_AUTHORIZATION, HEADER_BEARER_AUTHORIZATION + ' ' + TOKEN);
    }

    private PriceResponse handleResponse() {
        if (isStatusCodeOk()) {
            priceResponse = (PriceResponse) getResponseObject();
            if (priceResponse.active) {
                return priceResponse;
            }
            return null;
        } else {
            throw new CalloutClientException('Invalid status code: ' + getResponseStatusCode());
        }
    }

    public class PriceResponse {
        public String id;
        public Boolean active;
        public String product;
        public Integer unit_amount;
    }
}
