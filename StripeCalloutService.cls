// Abstract Service class which groups together Client classes based on similar functions, external systems, etc.
public with sharing class StripeCalloutService {
    public StripeCalloutService() {}
    public StripeChargeCardCalloutClient.CardResponse chargeCard(Integer chargeAmount, String chargeCurrency, String chargeSource) {
        return new StripeChargeCardCalloutClient().chargeCard(chargeAmount, chargeCurrency, chargeSource);
    }
    public StripeGetPriceCalloutClient.PriceResponse getPrice(String priceId) {
        return new StripeGetPriceCalloutClient().getPrice(priceId);
    }
}
