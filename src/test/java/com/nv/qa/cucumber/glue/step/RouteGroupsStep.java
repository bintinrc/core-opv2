package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.selenium.page.RouteGroupsPage;
import com.nv.qa.selenium.page.TagManagementPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteGroupsStep extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private RouteGroupsPage routeGroupsPage;

    @Inject
    public RouteGroupsStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        routeGroupsPage = new RouteGroupsPage(getDriver());
    }

    @Given("^Operator V2 create 'Route Group'$")
    public void createNewRouteGroupWithParam()
    {
        Order order = scenarioStorage.get("order");
        String trackingId = order.getTracking_id();

        /**
         * Create new Route Group.
         */
        String routeGroupName = "RG "+trackingId;
        scenarioStorage.put("routeGroupName", routeGroupName);
        routeGroupsPage.createRouteGroup(routeGroupName);
        CommonUtil.pause500ms();

        /**
         * Verify the page is redirect to '/#/sg/transactions' after route group is created.
         */
        Assert.assertTrue("Page not redirect to '/#/sg/transactions'.", getDriver().getCurrentUrl().contains("/#/sg/transactions"));
    }

    @When("^op create new 'route group' on 'Route Groups' using data below:$")
    public void createNewRouteGroup(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        boolean generateName = Boolean.valueOf(mapOfData.get("generateName"));
        String routeGroupName;
        Order order = scenarioStorage.get("order");

        if(generateName || order==null)
        {
            routeGroupName = "RG "+new Date().getTime();
        }
        else
        {
            routeGroupName = "RG "+order.getTracking_id();
        }

        scenarioStorage.put("routeGroupName", routeGroupName);
        routeGroupsPage.createRouteGroup(routeGroupName);
    }

    @Then("^new 'route group' on 'Route Groups' created successfully$")
    public void verifyNewRouteGroupCreatedSuccessfully()
    {
        String routeGroupName = scenarioStorage.get("routeGroupName");
        routeGroupsPage.searchTable(routeGroupName);

        String actualName = routeGroupsPage.getTextOnTable(1, RouteGroupsPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(routeGroupName, actualName);
    }

    @When("^op update 'route group' on 'Route Groups'$")
    public void updateRouteGroup()
    {
        String routeGroupName = scenarioStorage.get("routeGroupName");
        String oldRouteGroupName = routeGroupName;
        routeGroupName += " [EDITED]";
        scenarioStorage.put("routeGroupName", routeGroupName);
        routeGroupsPage.editRouteGroup(oldRouteGroupName, routeGroupName);
    }

    @Then("^'route group' on 'Route Groups' updated successfully$")
    public void verifyRouteGroupUpdatedSuccessfully()
    {
        String routeGroupName = scenarioStorage.get("routeGroupName");
        routeGroupsPage.searchTable(routeGroupName);
        String actualName = routeGroupsPage.getTextOnTable(1, RouteGroupsPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(routeGroupName, actualName);
    }

    @When("^op delete 'route group' on 'Route Groups'$")
    public void deleteRouteGroup()
    {
        String routeGroupName = scenarioStorage.get("routeGroupName");
        routeGroupsPage.deleteRouteGroup(routeGroupName);
    }

    @Then("^'route group' on 'Route Groups' deleted successfully$")
    public void verifyRouteGroupDeletedSuccessfully()
    {
        /**
         * Check the route group does not exists in table.
         */
        String routeGroupName = scenarioStorage.get("routeGroupName");
        String actualName = routeGroupsPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertNotEquals(routeGroupName, actualName);
    }

    @Then("^Operator V2 clean up 'Route Groups'$")
    public void cleanUpRouteGroup()
    {
        try
        {
            String routeGroupName = scenarioStorage.get("routeGroupName");
            routeGroupsPage.deleteRouteGroup(routeGroupName);
        }
        catch(Exception ex)
        {
            System.out.println("Failed to delete 'Route Group'.");
        }
    }
}
