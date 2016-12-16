package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.operator_portal.routing.CreateRouteResponse;
import com.nv.qa.selenium.page.page.RouteLogsPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.Alert;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;

import java.util.*;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteLogsStep extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private RouteLogsPage routeLogsPage;

    @Inject
    public RouteLogsStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        routeLogsPage = new RouteLogsPage(getDriver());
    }

    @When("^op select route date filter and click 'Load Selection'$")
    public void loadSelection()
    {
        Calendar fromCalendar = Calendar.getInstance();
        fromCalendar.add(Calendar.DATE, -1);

        Calendar toCalendar = Calendar.getInstance();

        routeLogsPage.selectRouteDateFilter(fromCalendar.getTime(), toCalendar.getTime());
        routeLogsPage.clickLoadSelection();
    }

    @When("^op click 'Edit Route' and then click 'Load Waypoints of Selected Route\\(s\\) Only'$")
    public void loadWaypointsOfSelectedRoute()
    {
        CreateRouteResponse createRouteResponse = scenarioStorage.get("createRouteResponse");
        routeLogsPage.searchAndVerifyRouteExist(String.valueOf(createRouteResponse.getId()));
        routeLogsPage.clickActionButtonOnTable(1, RouteLogsPage.ACTION_BUTTON_EDIT_ROUTE);
        CommonUtil.pause100ms();
        routeLogsPage.clickLoadWaypointsOfSelectedRoutesOnly();
        CommonUtil.pause1s();
    }

    @Then("^op redirect to this page '([^\\\"]*)'$")
    public void verifyLoadWaypointsOfSelectedRoute(String redirectUrl)
    {
        String primaryWindowHandle = getDriver().getWindowHandle();
        Set<String> windowHandles = getDriver().getWindowHandles();

        String actualCurrentUrl = null;

        for(String windowName : windowHandles)
        {
            if(!primaryWindowHandle.equals(windowName))
            {
                getDriver().switchTo().window(windowName);
                CommonUtil.pause500ms();

                try
                {
                    WebDriverWait webDriverWait = new WebDriverWait(getDriver(), 10);
                    Alert alert = webDriverWait.until(ExpectedConditions.alertIsPresent());
                    alert.accept();
                }
                catch(Exception ex)
                {
                }

                CommonUtil.pause100ms();
                actualCurrentUrl = getDriver().getCurrentUrl();
                getDriver().close();
                CommonUtil.pause100ms();
                getDriver().switchTo().window(primaryWindowHandle);
                CommonUtil.pause500ms();
                break;
            }
        }

        Map<String,String> mapOfDynamicVariable = new HashMap();
        CreateRouteResponse createRouteResponse = scenarioStorage.get("createRouteResponse");
        mapOfDynamicVariable.put("route_id", String.valueOf(createRouteResponse.getId()));
        String expectedRedirectUrl = CommonUtil.replaceParam(redirectUrl, mapOfDynamicVariable);

        Assert.assertEquals(actualCurrentUrl, expectedRedirectUrl, String.format("Operator does not redirect to page %s", redirectUrl));
    }

    @Then("^op close Edit Routes dialog$")
    public void opCloseEditRoutesDialog()
    {
        routeLogsPage.clickCancelOnEditRoutesDialog();
    }

    @When("^op click 'Edit Details'$")
    public void opClickEditDetails()
    {
        CreateRouteResponse createRouteResponse = scenarioStorage.get("createRouteResponse");
        routeLogsPage.searchAndVerifyRouteExist(String.valueOf(createRouteResponse.getId()));
        routeLogsPage.clickActionButtonOnTable(1, RouteLogsPage.ACTION_BUTTON_EDIT_DETAILS);
        CommonUtil.pause100ms();
    }

    @When("^op edit 'Assigned Driver' to driver '([^\\\"]*)' and edit 'Comments'$")
    public void opEditAssignedDriverAndComments(String newDriverName)
    {
        routeLogsPage.editAssignedDriver(newDriverName);
        routeLogsPage.clickSaveButtonOnEditDetailsDialog();
    }

    @Then("^route's driver must be changed to '([^\\\"]*)' in table list$")
    public void verifyRouteDriverIsChanged(String newDriverName)
    {
        String actualDriverName = routeLogsPage.getTextOnTable(1, RouteLogsPage.COLUMN_CLASS_DATA_DRIVER_NAME);
        Assert.assertEquals(actualDriverName, newDriverName, "Driver is not change.");
    }

    @When("^op add tag '([^\\\"]*)'$")
    public void opAddNewTagToRoute(String newTag)
    {
        CreateRouteResponse createRouteResponse = scenarioStorage.get("createRouteResponse");
        routeLogsPage.selectTag(String.valueOf(createRouteResponse.getId()), newTag);
    }

    @Then("route's tag must contain '([^\\\"]*)'")
    public void verifyNewTagAddedToRoute(String newTag)
    {
        CreateRouteResponse createRouteResponse = scenarioStorage.get("createRouteResponse");
        String tags = routeLogsPage.getRouteTag(String.valueOf(createRouteResponse.getId()));
        boolean isContainsNewTag = tags.contains(newTag);
        Assert.assertTrue(isContainsNewTag, String.format("Route does not contains tag '%s'.", newTag));
    }

    @When("^op delete route on Operator V2$")
    public void opDeleteDeleteRoute()
    {
        CreateRouteResponse createRouteResponse = scenarioStorage.get("createRouteResponse");
        routeLogsPage.deleteRoute(String.valueOf(createRouteResponse.getId()));
    }

    @Then("^route must be deleted successfully$")
    public void verifyRouteDeletedSuccessfully()
    {
        CreateRouteResponse createRouteResponse = scenarioStorage.get("createRouteResponse");
        routeLogsPage.searchTableByRouteId(String.valueOf(createRouteResponse.getId()));
        boolean isTableEmpty = routeLogsPage.isTableEmpty();
        Assert.assertTrue(isTableEmpty, "Route still exist in table. Fail to delete route.");
        scenarioStorage.put("routeDeleted", true);
    }
}
