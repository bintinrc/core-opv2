package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.page.RouteGroupTemplatesPage;
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
public class RouteGroupTemplatesStep extends AbstractSteps
{
    public static final String DEFAULT_FILTER_QUERY = "SELECT t FROM Transaction t INNER JOIN FETCH t.order o";
    public static final String EDITED_DEFAULT_FILTER_QUERY = DEFAULT_FILTER_QUERY + " [EDITED]";

    private RouteGroupTemplatesPage routeGroupTemplatesPage;
    private String routeGroupTemplateName;

    @Inject
    public RouteGroupTemplatesStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    public void init()
    {
        routeGroupTemplatesPage = new RouteGroupTemplatesPage(getDriver());
    }

    @When("^op create new 'route group template' on 'Route Group Templates'$")
    public void createNewRouteGroupTemplate()
    {
        routeGroupTemplateName = "Route Group Template "+new Date().getTime();
        routeGroupTemplatesPage.createRouteGroupTemplate(routeGroupTemplateName, DEFAULT_FILTER_QUERY);
    }

    @Then("^new 'route group template' on 'Route Group Templates' created successfully$")
    public void verifyNewRouteGroupTemplateCreatedSuccessfully()
    {
        routeGroupTemplatesPage.searchTable(routeGroupTemplateName);

        String actualName = routeGroupTemplatesPage.getTextOnTable(1, RouteGroupTemplatesPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(routeGroupTemplateName, actualName);

        String actualFilter = routeGroupTemplatesPage.getTextOnTable(1, RouteGroupTemplatesPage.COLUMN_CLASS_FILTER);
        Assert.assertEquals(DEFAULT_FILTER_QUERY, actualFilter);
    }

    @When("^op update 'route group template' on 'Route Group Templates'$")
    public void updateRouteGroupTemplate()
    {
        String filterRouteGroupTemplateName = routeGroupTemplateName;

        routeGroupTemplateName = routeGroupTemplateName + " [EDITED]";
        routeGroupTemplatesPage.editRouteGroupTemplate(filterRouteGroupTemplateName, routeGroupTemplateName, EDITED_DEFAULT_FILTER_QUERY);
    }

    @Then("^'route group template' on 'Route Group Templates' updated successfully$")
    public void verifyRouteGroupTemplateUpdatedSuccessfully()
    {
        routeGroupTemplatesPage.searchTable(routeGroupTemplateName);

        String actualName = routeGroupTemplatesPage.getTextOnTable(1, RouteGroupTemplatesPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(routeGroupTemplateName, actualName);

        String actualFilter = routeGroupTemplatesPage.getTextOnTable(1, RouteGroupTemplatesPage.COLUMN_CLASS_FILTER);
        Assert.assertEquals(EDITED_DEFAULT_FILTER_QUERY, actualFilter);
    }

    @When("^op delete 'route group template' on 'Route Group Templates'$")
    public void deleteRouteGroupTemplate()
    {
        routeGroupTemplatesPage.deleteRouteGroupTemplate(routeGroupTemplateName);
    }

    @Then("^'route group template' on 'Route Group Templates' deleted successfully$")
    public void verifyRouteGroupTemplateDeletedSuccessfully()
    {
        /**
         * Check the route group template does not exists in table.
         */
        String actualName = routeGroupTemplatesPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertNotEquals(routeGroupTemplateName, actualName);
    }
}
