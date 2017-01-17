package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.selenium.page.page.AddParcelToRoutePage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.junit.Assert;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class AddParcelToRouteStep extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private AddParcelToRoutePage addParcelToRoutePage;

    @Inject
    public AddParcelToRouteStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        addParcelToRoutePage = new AddParcelToRoutePage(getDriver());
    }

    @When("Operator V2 choose route group, select tag BB4 and submit")
    public void submitOnAddParcelToRoute()
    {
        String routeGroupName = scenarioStorage.get("routeGroupName");
        addParcelToRoutePage.selectRouteGroup(routeGroupName);
        addParcelToRoutePage.selectTag("FLT"); //Unselect tag FLT. Tag FLT is default tag on this page.
        addParcelToRoutePage.selectTag("BB4");
        addParcelToRoutePage.clickSubmit();
        CommonUtil.pause1s();
    }

    @Then("verify parcel added to route")
    public void verifyParcelAddedToRoute()
    {
        Order order = scenarioStorage.get("order");
        String actualTrackingIdOnTable = addParcelToRoutePage.getTextOnTable(1, AddParcelToRoutePage.COLUMN_CLASS_TRACKING_ID);
        String expectedTrackingId = order.getTracking_id();

        Assert.assertEquals("Order did not added to route.", expectedTrackingId, actualTrackingIdOnTable);
    }
}
