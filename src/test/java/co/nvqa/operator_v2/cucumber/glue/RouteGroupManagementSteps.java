package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage;
import co.nvqa.operator_v2.selenium.page.TagManagementPage;
import com.google.inject.Inject;
import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;
import org.junit.Assert;

import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteGroupManagementSteps extends AbstractSteps
{
    private static final int MAX_RETRY = 10;
    private RouteGroupManagementPage routeGroupManagementPage;

    @Inject
    public RouteGroupManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeGroupManagementPage = new RouteGroupManagementPage(getWebDriver());
    }

    @Given("^Operator V2 create 'Route Group'$")
    public void createNewRouteGroupWithParam()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        /**
         * Create new Route Group.
         */
        String routeGroupName = "RG "+trackingId;
        put(KEY_ROUTE_GROUP_NAME, routeGroupName);
        routeGroupManagementPage.createRouteGroup(routeGroupName);
        pause500ms();

        /**
         * Verify the page is redirect to '/#/sg/transactions' after route group is created.
         */
        Assert.assertThat("Page not redirect to '/#/sg/transactions'.", getCurrentUrl(), Matchers.containsString("/#/sg/transactions"));
    }

    @When("^Operator create new 'route group' on 'Route Groups' using data below:$")
    public void createNewRouteGroup(DataTable dataTable)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        boolean generateName = Boolean.valueOf(mapOfData.get("generateName"));
        String routeGroupName;

        if(generateName || trackingId==null)
        {
            routeGroupName = "RG "+new Date().getTime();
        }
        else
        {
            routeGroupName = "RG "+trackingId;
        }

        routeGroupManagementPage.createRouteGroup(routeGroupName);
        put(KEY_ROUTE_GROUP_NAME, routeGroupName);
    }

    @When("^Operator wait until 'Route Group' page is loaded$")
    public void waitUntilRouteGroupIsLoaded()
    {
        routeGroupManagementPage.waitUntilRouteGroupPageIsLoaded();
    }

    @Then("^Operator verify new 'route group' on 'Route Groups' created successfully$")
    public void verifyNewRouteGroupCreatedSuccessfully()
    {
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        int counter = 0;
        String actualRouteGroupName;
        boolean retry;

        do
        {
            takesScreenshot();
            routeGroupManagementPage.searchTable(routeGroupName);
            actualRouteGroupName = routeGroupManagementPage.getTextOnTable(1, RouteGroupManagementPage.COLUMN_CLASS_NAME);

            retry = (actualRouteGroupName==null||actualRouteGroupName.isEmpty()) && counter++<=MAX_RETRY;

            if(retry)
            {
                writeToCurrentScenarioLog(String.format("[INFO] Retrying to load and search Route Group. [Route Group Name = '%s'] Retrying %dx ...", actualRouteGroupName, counter));
                takesScreenshot();
                reloadPage();
            }
        }
        while(retry);

        Assert.assertThat("Route Group name not matched.", actualRouteGroupName, Matchers.startsWith(routeGroupName)); //Route Group name is concatenated with description.
    }

    @When("^Operator update 'route group' on 'Route Group Management'$")
    public void updateRouteGroup()
    {
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        String oldRouteGroupName = routeGroupName;
        routeGroupName += " [EDITED]";
        routeGroupManagementPage.editRouteGroup(oldRouteGroupName, routeGroupName);
        put(KEY_ROUTE_GROUP_NAME, routeGroupName);
    }

    @Then("^Operator verify 'route group' on 'Route Group Management' updated successfully$")
    public void verifyRouteGroupUpdatedSuccessfully()
    {
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        routeGroupManagementPage.searchTable(routeGroupName);
        String actualName = routeGroupManagementPage.getTextOnTable(1, RouteGroupManagementPage.COLUMN_CLASS_NAME);
        Assert.assertTrue("Route Group name not matched.", actualName.startsWith(routeGroupName)); //Route Group name is concatenated with description.
    }

    @When("^Operator delete 'route group' on 'Route Group Management'$")
    public void deleteRouteGroup()
    {
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        routeGroupManagementPage.deleteRouteGroup(routeGroupName);
    }

    @Then("^Operator verify 'route group' on 'Route Group Management' deleted successfully$")
    public void verifyRouteGroupDeletedSuccessfully()
    {
        /**
         * Check the route group does not exists in table.
         */
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        String actualName = routeGroupManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertNotEquals(routeGroupName, actualName);
    }

    @Then("^Operator V2 clean up 'Route Groups'$")
    public void cleanUpRouteGroup()
    {
        try
        {
            String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
            routeGroupManagementPage.deleteRouteGroup(routeGroupName);
        }
        catch(Exception ex)
        {
            NvLogger.warn("Failed to delete 'Route Group'.");
        }
    }
}
