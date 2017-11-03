package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.selenium.page.AgedParcelManagementPage;
import com.nv.qa.support.ScenarioStorage;
import com.nv.qa.support.TestConstants;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AgedParcelManagementSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private AgedParcelManagementPage agedParcelManagementPage;

    @Inject
    public AgedParcelManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        agedParcelManagementPage = new AgedParcelManagementPage(getDriver());
    }

    @When("^operator load selection on page Aged Parcel Management$")
    public void operatorLoadSelectionOnPageAgedParcelManagement()
    {
        pause2s();
        agedParcelManagementPage.loadSelection(-1);
    }

    @Then("^Operator verify the aged parcel order is listed on Aged Parcel orders list$")
    public void operatorVerifyTheAgedParcelOrderIsListedOnAgedParcelOrdersList()
    {
        Order order = scenarioStorage.get("order");
        String trackingId = order.getTracking_id();
        String shippername = TestConstants.SHIPPER_V2_NAME;
        agedParcelManagementPage.verifyAgedParcelOrderIsListed(trackingId, shippername);
    }
}
