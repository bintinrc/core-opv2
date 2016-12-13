package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.selenium.page.page.RouteGroupTemplatesPage;
import com.nv.qa.selenium.page.page.TagManagementPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteGroupTemplatesStep extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private RouteGroupTemplatesPage routeGroupTemplatesPage;

    @Inject
    public RouteGroupTemplatesStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        routeGroupTemplatesPage = new RouteGroupTemplatesPage(getDriver());
    }

    @When("^op create new 'route group template' on 'Route Group Templates' using data below:$")
    public void createNewRouteGroupTemplate(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        boolean generateName = Boolean.valueOf(mapOfData.get("generateName"));
        String routeGroupTemplateFilter = mapOfData.get("routeGroupTemplateFilter");

        String routeGroupTemplateName;
        Order order = scenarioStorage.get("order");

        if(generateName || order==null)
        {
            routeGroupTemplateName = "RGT "+new Date().getTime();
        }
        else
        {
            routeGroupTemplateName = "RGT "+order.getTracking_id();
        }

        /**
         * Replace "{{tracking_id}}" with order.getTracking_id()).
         */
        if(order!=null)
        {
            Map<String,String> mapOfDynamicVariable = new HashMap();
            mapOfDynamicVariable.put("tracking_id", order.getTracking_id());
            routeGroupTemplateFilter = CommonUtil.replaceParam(routeGroupTemplateFilter, mapOfDynamicVariable);
        }

        scenarioStorage.put("routeGroupTemplateName", routeGroupTemplateName);
        scenarioStorage.put("routeGroupTemplateFilter", routeGroupTemplateFilter);

        routeGroupTemplatesPage.createRouteGroupTemplate(routeGroupTemplateName, routeGroupTemplateFilter);
    }

    @Then("^new 'route group template' on 'Route Group Templates' created successfully$")
    public void verifyNewRouteGroupTemplateCreatedSuccessfully()
    {
        verifyRouteGroupTemplate();
    }

    @When("^op update 'route group template' on 'Route Group Templates'$")
    public void updateRouteGroupTemplate()
    {
        String routeGroupTemplateName = scenarioStorage.get("routeGroupTemplateName");
        String routeGroupTemplateFilter = scenarioStorage.get("routeGroupTemplateFilter");

        String oldRouteGroupTemplateName = routeGroupTemplateName;
        routeGroupTemplateName += " [EDITED]";
        routeGroupTemplateFilter += " [EDITED]";

        scenarioStorage.put("routeGroupTemplateName", routeGroupTemplateName);
        scenarioStorage.put("routeGroupTemplateFilter", routeGroupTemplateFilter);

        routeGroupTemplatesPage.editRouteGroupTemplate(oldRouteGroupTemplateName, routeGroupTemplateName, routeGroupTemplateFilter);
    }

    @Then("^'route group template' on 'Route Group Templates' updated successfully$")
    public void verifyRouteGroupTemplateUpdatedSuccessfully()
    {
        verifyRouteGroupTemplate();
    }

    private void verifyRouteGroupTemplate()
    {
        String routeGroupTemplateName = scenarioStorage.get("routeGroupTemplateName");
        String routeGroupTemplateFilter = scenarioStorage.get("routeGroupTemplateFilter");

        routeGroupTemplatesPage.searchTable(routeGroupTemplateName);

        String actualName = routeGroupTemplatesPage.getTextOnTable(1, RouteGroupTemplatesPage.COLUMN_CLASS_NAME);
        Assert.assertEquals(routeGroupTemplateName, actualName);

        String actualFilter = routeGroupTemplatesPage.getTextOnTable(1, RouteGroupTemplatesPage.COLUMN_CLASS_FILTER);
        Assert.assertEquals(routeGroupTemplateFilter, actualFilter);
    }

    @When("^op delete 'route group template' on 'Route Group Templates'$")
    public void deleteRouteGroupTemplate()
    {
        String routeGroupTemplateName = scenarioStorage.get("routeGroupTemplateName");
        routeGroupTemplatesPage.deleteRouteGroupTemplate(routeGroupTemplateName);
    }

    @Then("^'route group template' on 'Route Group Templates' deleted successfully$")
    public void verifyRouteGroupTemplateDeletedSuccessfully()
    {
        /**
         * Check the route group template does not exists in table.
         */
        String routeGroupTemplateName = scenarioStorage.get("routeGroupTemplateName");
        String actualName = routeGroupTemplatesPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertNotEquals(routeGroupTemplateName, actualName);
    }

    @Then("^Operator V2 clean up 'Route Group Templates'$")
    public void cleanUpRouteGroupTemplates()
    {
        try
        {
            String routeGroupTemplateName = scenarioStorage.get("routeGroupTemplateName");
            routeGroupTemplatesPage.deleteRouteGroupTemplate(routeGroupTemplateName);
        }
        catch(Exception ex)
        {
            System.out.println("Failed to delete 'Route Group Template'.");
        }
    }
}
