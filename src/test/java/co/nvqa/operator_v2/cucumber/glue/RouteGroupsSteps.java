package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.RouteGroupsPage;
import co.nvqa.operator_v2.selenium.page.TagManagementPage;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.NvLogger;
import com.nv.qa.commons.utils.StandardScenarioStorage;
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
public class RouteGroupsSteps extends AbstractSteps
{
    private static final int MAX_RETRY = 10;
    private RouteGroupsPage routeGroupsPage;

    @Inject
    public RouteGroupsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeGroupsPage = new RouteGroupsPage(getWebDriver());
    }

    @Given("^Operator V2 create 'Route Group'$")
    public void createNewRouteGroupWithParam()
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);

        /**
         * Create new Route Group.
         */
        String routeGroupName = "RG "+trackingId;
        getScenarioStorage().put(KEY_ROUTE_GROUP_NAME, routeGroupName);
        routeGroupsPage.createRouteGroup(routeGroupName);
        pause500ms();

        /**
         * Verify the page is redirect to '/#/sg/transactions' after route group is created.
         */
        Assert.assertThat("Page not redirect to '/#/sg/transactions'.", getWebDriver().getCurrentUrl(), Matchers.containsString("/#/sg/transactions"));
    }

    @When("^op create new 'route group' on 'Route Groups' using data below:$")
    public void createNewRouteGroup(DataTable dataTable)
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);

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

        routeGroupsPage.createRouteGroup(routeGroupName);
        getScenarioStorage().put(KEY_ROUTE_GROUP_NAME, routeGroupName);
    }

    @When("^op wait until 'Route Group' page is loaded$")
    public void waitUntilRouteGroupIsLoaded()
    {
        routeGroupsPage.waitUntilRouteGroupPageIsLoaded();
    }

    @Then("^new 'route group' on 'Route Groups' created successfully$")
    public void verifyNewRouteGroupCreatedSuccessfully()
    {
        String routeGroupName = getScenarioStorage().get(KEY_ROUTE_GROUP_NAME);
        int counter = 0;
        String actualRouteGroupName;
        boolean retry;

        do
        {
            takesScreenshot();
            routeGroupsPage.searchTable(routeGroupName);
            actualRouteGroupName = routeGroupsPage.getTextOnTable(1, RouteGroupsPage.COLUMN_CLASS_NAME);

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

    @When("^op update 'route group' on 'Route Groups'$")
    public void updateRouteGroup()
    {
        String routeGroupName = getScenarioStorage().get(KEY_ROUTE_GROUP_NAME);
        String oldRouteGroupName = routeGroupName;
        routeGroupName += " [EDITED]";
        routeGroupsPage.editRouteGroup(oldRouteGroupName, routeGroupName);
        getScenarioStorage().put(KEY_ROUTE_GROUP_NAME, routeGroupName);
    }

    @Then("^'route group' on 'Route Groups' updated successfully$")
    public void verifyRouteGroupUpdatedSuccessfully()
    {
        String routeGroupName = getScenarioStorage().get(KEY_ROUTE_GROUP_NAME);
        routeGroupsPage.searchTable(routeGroupName);
        String actualName = routeGroupsPage.getTextOnTable(1, RouteGroupsPage.COLUMN_CLASS_NAME);
        Assert.assertTrue("Route Group name not matched.", actualName.startsWith(routeGroupName)); //Route Group name is concatenated with description.
    }

    @When("^op delete 'route group' on 'Route Groups'$")
    public void deleteRouteGroup()
    {
        String routeGroupName = getScenarioStorage().get(KEY_ROUTE_GROUP_NAME);
        routeGroupsPage.deleteRouteGroup(routeGroupName);
    }

    @Then("^'route group' on 'Route Groups' deleted successfully$")
    public void verifyRouteGroupDeletedSuccessfully()
    {
        /**
         * Check the route group does not exists in table.
         */
        String routeGroupName = getScenarioStorage().get(KEY_ROUTE_GROUP_NAME);
        String actualName = routeGroupsPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertNotEquals(routeGroupName, actualName);
    }

    @Then("^Operator V2 clean up 'Route Groups'$")
    public void cleanUpRouteGroup()
    {
        try
        {
            String routeGroupName = getScenarioStorage().get(KEY_ROUTE_GROUP_NAME);
            routeGroupsPage.deleteRouteGroup(routeGroupName);
        }
        catch(Exception ex)
        {
            NvLogger.warn("Failed to delete 'Route Group'.");
        }
    }
}
