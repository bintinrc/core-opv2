package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.pricing.Param;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.RouteGroupManagementPage;
import co.nvqa.operator_v2.selenium.page.TagManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.cucumber.datatable.DataTable;
import org.hamcrest.Matchers;
import org.junit.Assert;

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

    @When("^Operator create new 'Route Group' on 'Route Groups Management' using data below:$")
    public void createNewRouteGroup(Map<String,String> dataTableAsMap)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        boolean generateName = Boolean.valueOf(dataTableAsMap.get("generateName"));
        String hubName = dataTableAsMap.get("hubName");
        String routeGroupName;

        if(generateName || trackingId==null)
        {
            routeGroupName = "ARG-"+generateDateUniqueString();
        }
        else
        {
            routeGroupName = "ARG-"+trackingId;
        }

        routeGroupManagementPage.createRouteGroup(routeGroupName, hubName);
        put(KEY_ROUTE_GROUP_NAME, routeGroupName);
    }

    @When("^Operator wait until 'Route Group Management' page is loaded$")
    public void waitUntilRouteGroupIsLoaded()
    {
        routeGroupManagementPage.waitUntilRouteGroupPageIsLoaded();
    }

    @Then("^Operator verify new 'Route Group' on 'Route Groups Management' created successfully$")
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
            actualRouteGroupName = routeGroupManagementPage.getTextOnTable(1, RouteGroupManagementPage.COLUMN_CLASS_DATA_NAME);

            retry = (actualRouteGroupName==null || actualRouteGroupName.isEmpty()) && counter++<=MAX_RETRY;

            if(retry)
            {
                writeToCurrentScenarioLog(f("[INFO] Retrying to load and search Route Group. [Route Group Name = '%s'] Retrying %dx ...", actualRouteGroupName, counter));
                takesScreenshot();
                reloadPage();
            }
        }
        while(retry);

        Assert.assertThat("Route Group name not matched.", actualRouteGroupName, Matchers.startsWith(routeGroupName)); //Route Group name is concatenated with description.
    }

    @When("^Operator update 'Route Group' on 'Route Group Management'$")
    public void updateRouteGroup()
    {
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        String oldRouteGroupName = routeGroupName;
        routeGroupName += " [EDITED]";
        routeGroupManagementPage.editRouteGroup(oldRouteGroupName, routeGroupName);
        put(KEY_ROUTE_GROUP_NAME, routeGroupName);
    }

    @Then("^Operator verify 'Route Group' on 'Route Group Management' updated successfully$")
    public void verifyRouteGroupUpdatedSuccessfully()
    {
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        routeGroupManagementPage.searchTable(routeGroupName);
        String actualName = routeGroupManagementPage.getTextOnTable(1, RouteGroupManagementPage.COLUMN_CLASS_DATA_NAME);
        Assert.assertTrue("Route Group name not matched.", actualName.startsWith(routeGroupName)); //Route Group name is concatenated with description.
    }

    @When("^Operator delete 'Route Group' on 'Route Group Management'$")
    public void deleteRouteGroup()
    {
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        routeGroupManagementPage.deleteRouteGroup(routeGroupName);
    }

    @Then("^Operator verify 'Route Group' on 'Route Group Management' deleted successfully$")
    public void verifyRouteGroupDeletedSuccessfully()
    {
        /*
          Check the route group does not exists in table.
         */
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);
        String actualName = routeGroupManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_DATA_TAG_NAME);
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

    @Given("test list")
    public void testList(DataTable dataTable)
    {
        java.util.List<Param> listOfParam = dataTable.asList(Param.class);
        System.out.println(listOfParam);
    }
}
