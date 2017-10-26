package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.selenium.page.FailedDeliveryManagementPage;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.Then;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class FailedDeliveryManagementSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private FailedDeliveryManagementPage failedDeliveryManagementPage;

    @Inject
    public FailedDeliveryManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        failedDeliveryManagementPage = new FailedDeliveryManagementPage(getDriver());
    }

    @Then("^Operator verify the failed delivery order is listed on Failed Delivery orders list$")
    public void operatorVerifyTheFailedDeliveryOrderIsListedOnFailedDeliveryOrderList()
    {
        Order order = scenarioStorage.get("order");
        String trackingId = order.getTracking_id();
        String orderType = order.getType();
        failedDeliveryManagementPage.verifyFailedDeliveryOrderIsListed(trackingId, orderType);
    }
}
