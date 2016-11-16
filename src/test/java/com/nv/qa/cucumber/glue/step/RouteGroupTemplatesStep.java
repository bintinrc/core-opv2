package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.page.RouteGroupTemplatesPage;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteGroupTemplatesStep extends AbstractSteps
{
    private RouteGroupTemplatesPage routeGroupTemplatesPage;

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
        String routeGroupTemplateName = "Route Group Template "+new Date().getTime();
        String filterQuery = "SELECT t FROM Transaction t INNER JOIN FETCH t.order o";
        routeGroupTemplatesPage.createRouteGroupTemplate(routeGroupTemplateName, filterQuery);
    }
}
