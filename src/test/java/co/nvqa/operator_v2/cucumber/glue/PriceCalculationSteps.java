package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.shipper_support.PricedOrder;
import cucumber.api.java.en.Then;

public class PriceCalculationSteps extends AbstractSteps
{
    @Override
    public void init()
    {
    }

    @Then("Operator verifies dwh_qa_gl.priced_orders.marketplace_id is {string}")
    public void operatorVerifiesDwh_qa_glPriced_ordersMarketplace_idIs(String marketplaceId)
    {
        PricedOrder pricedOrder = get(KEY_ORDER_BILLING_PRICED_ORDER_DETAILS_DB);
        assertEquals(f("Marketplace_id is expected and actual mismatch gor tracking id  %s", pricedOrder.getTrackingId()),marketplaceId, String.valueOf(pricedOrder.getMarketplaceId()));
    }
}
