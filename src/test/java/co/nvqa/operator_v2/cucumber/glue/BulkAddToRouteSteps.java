package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.BulkAddToRoutePage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.WebElement;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class BulkAddToRouteSteps extends AbstractSteps
{
    private BulkAddToRoutePage bulkAddToRoutePage;

    @Inject
    public BulkAddToRouteSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        bulkAddToRoutePage = new BulkAddToRoutePage(getWebDriver());
    }

    @When("^Operator choose route group, select tag \"([^\"]*)\" and submit$")
    public void submitOnAddParcelToRoute(String tag)
    {
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        takesScreenshot();
        bulkAddToRoutePage.selectCurrentDate();
        takesScreenshot();
        bulkAddToRoutePage.selectRouteGroup(routeGroupName);
        takesScreenshot();
        bulkAddToRoutePage.selectTag("FLT"); //Unselect tag FLT. Tag FLT is default tag on this page.
        takesScreenshot();
        bulkAddToRoutePage.selectTag(tag);
        takesScreenshot();
        bulkAddToRoutePage.clickSubmit();
        takesScreenshot();
    }

    @Then("^Operator verify parcel added to route$")
    public void verifyParcelAddedToRoute()
    {
        String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String xpath = String.format("//td[contains(@class, 'tracking_id') and contains(text(), '%s')]", expectedTrackingId);
        takesScreenshot();
        WebElement actualTrackingId = bulkAddToRoutePage.findElementByXpath(xpath);
        Assert.assertEquals("Order did not added to route.", expectedTrackingId, actualTrackingId.getText());
    }
}
