package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.page.RouteGroupsPage;
import com.nv.qa.selenium.page.page.TagManagementPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteGroupsStep extends AbstractSteps
{
    private RouteGroupsPage routeGroupsPage;
    private String routeGroupName;

    @Inject
    public RouteGroupsStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    public void init()
    {
        routeGroupsPage = new RouteGroupsPage(getDriver());
    }

    @When("^op create new 'route group' on 'Route Groups'$")
    public void createNewRouteGroup()
    {
        routeGroupName = "Route Group "+new Date().getTime();
        routeGroupsPage.createRouteGroup(routeGroupName);
    }

    @Then("^new 'route group' on 'Route Groups' created successfully$")
    public void verifyNewRouteGroupCreatedSuccessfully()
    {
        routeGroupsPage.searchTable(routeGroupName);

        String actualName = routeGroupsPage.getTextOnTable(1, RouteGroupsPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(routeGroupName, actualName);
    }

    @When("^op update 'route group' on 'Route Groups'$")
    public void updateRouteGroup()
    {
        String filterRouteGroupName = routeGroupName;

        routeGroupName = routeGroupName + " [EDITED]";
        routeGroupsPage.editRouteGroup(filterRouteGroupName, routeGroupName);
    }

    @Then("^'route group' on 'Route Groups' updated successfully$")
    public void verifyRouteGroupUpdatedSuccessfully()
    {
        routeGroupsPage.searchTable(routeGroupName);
        String actualName = routeGroupsPage.getTextOnTable(1, RouteGroupsPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(routeGroupName, actualName);
    }

    @When("^op delete 'route group' on 'Route Groups'$")
    public void deleteRouteGroup()
    {
        routeGroupsPage.deleteRouteGroup(routeGroupName);
    }

    @Then("^'route group' on 'Route Groups' deleted successfully$")
    public void verifyRouteGroupDeletedSuccessfully()
    {
        /**
         * Check the route group does not exists in table.
         */
        String actualName = routeGroupsPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertNotEquals(routeGroupName, actualName);
    }
}
