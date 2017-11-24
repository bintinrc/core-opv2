package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.AddParcelToRoutePage;
import co.nvqa.operator_v2.util.ScenarioStorage;
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
public class AddParcelToRouteSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private AddParcelToRoutePage addParcelToRoutePage;

    @Inject
    public AddParcelToRouteSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        addParcelToRoutePage = new AddParcelToRoutePage(getWebDriver());
    }

    @When("^Operator V2 choose route group, select tag \"([^\"]*)\" and submit$")
    public void submitOnAddParcelToRoute(String tag)
    {
        String routeGroupName = scenarioStorage.get(KEY_ROUTE_GROUP_NAME);
        takesScreenshot();
        addParcelToRoutePage.selectCurrentDate();
        takesScreenshot();
        addParcelToRoutePage.selectRouteGroup(routeGroupName);
        takesScreenshot();
        addParcelToRoutePage.selectTag("FLT"); //Unselect tag FLT. Tag FLT is default tag on this page.
        takesScreenshot();
        addParcelToRoutePage.selectTag(tag);
        takesScreenshot();
        addParcelToRoutePage.clickSubmit();
        takesScreenshot();
    }

    @Then("^verify parcel added to route$")
    public void verifyParcelAddedToRoute()
    {
        String expectedTrackingId = scenarioStorage.get(KEY_CREATED_ORDER_TRACKING_ID);
        String xpath = String.format("//td[contains(@class, 'tracking_id') and contains(text(), '%s')]", expectedTrackingId);
        takesScreenshot();
        WebElement actualTrackingId = addParcelToRoutePage.findElementByXpath(xpath);
        Assert.assertEquals("Order did not added to route.", expectedTrackingId, actualTrackingId.getText());
    }
}
