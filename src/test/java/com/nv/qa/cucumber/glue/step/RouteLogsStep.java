package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.api.client.operator_portal.OperatorPortalRoutingClient;
import com.nv.qa.model.operator_portal.authentication.AuthRequest;
import com.nv.qa.model.operator_portal.routing.CreateRouteRequest;
import com.nv.qa.model.operator_portal.routing.CreateRouteResponse;
import com.nv.qa.selenium.page.page.RouteLogsPage;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.JsonHelper;
import cucumber.api.DataTable;
import cucumber.api.java.After;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.Alert;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteLogsStep extends AbstractSteps
{
    private static final SimpleDateFormat CREATED_DATE_SDF = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
    private static final SimpleDateFormat ROUTE_DATE_SDF = new SimpleDateFormat("yyyy-MM-dd 16:00:00");

    private OperatorPortalRoutingClient operatorPortalRoutingClient;
    private CreateRouteResponse createRouteResponse;
    private boolean routeDeleted;

    private RouteLogsPage routeLogsPage;

    @Inject
    public RouteLogsStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        try
        {
            AuthRequest operatorAuthRequest = new com.nv.qa.model.operator_portal.authentication.AuthRequest();
            operatorAuthRequest.setClientId(APIEndpoint.OPERATOR_V1_CLIENT_ID);
            operatorAuthRequest.setClientSecret(APIEndpoint.OPERATOR_V1_CLIENT_SECRET);

            operatorPortalRoutingClient = new OperatorPortalRoutingClient(APIEndpoint.API_BASE_URL, APIEndpoint.API_BASE_URL+"/auth/login?grant_type=client_credentials");
            operatorPortalRoutingClient.login(operatorAuthRequest);

            routeLogsPage = new RouteLogsPage(getDriver());
        }
        catch(Exception ex)
        {
            throw new RuntimeException(ex);
        }
    }

    @After("@ArchiveRoute")
    public void archiveRoute() throws IOException
    {
        if(routeDeleted)
        {
           return;
        }

        int routeId = -1;

        if(createRouteResponse!=null)
        {
            routeId = createRouteResponse.getId();
        }

        if(routeId!=-1)
        {
            try
            {
                System.out.println("-----------------------------------------------------");
                System.out.println("DELETING ROUTE");
                System.out.println("Route : "+routeId);
                System.out.println("-----------------------------------------------------");

                operatorPortalRoutingClient.deleteRoute(routeId);
            }
            catch(Exception ex)
            {
                System.out.println("Fail deleting route. Trying to archive route.");
                System.out.println("-----------------------------------------------------");
                System.out.println("ARCHIVING ROUTE");
                System.out.println("Route : "+routeId);
                System.out.println("-----------------------------------------------------");

                operatorPortalRoutingClient.archiveRoute(routeId);
            }
        }
    }

    @Given("Operator V1 create new route using data below:")
    public void createNewRoute(DataTable dataTable) throws IOException
    {
        Calendar currentCalendar = Calendar.getInstance();

        Map<String,String> mapOfDynamicVariable = new HashMap();
        mapOfDynamicVariable.put("created_date", CREATED_DATE_SDF.format(new Date()));
        mapOfDynamicVariable.put("formatted_route_date", ROUTE_DATE_SDF.format(currentCalendar.getTime()));

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String createRouteRequestJson = CommonUtil.replaceParam(mapOfData.get("createRouteRequest"), mapOfDynamicVariable);

        CreateRouteRequest createRouteRequest = JsonHelper.fromJson(createRouteRequestJson, CreateRouteRequest.class);
        createRouteResponse = operatorPortalRoutingClient.createRoute(createRouteRequest);
    }

    @When("^op click 'Load Selection'$")
    public void loadSelection()
    {
        routeLogsPage.clickLoadSelection();
        CommonUtil.pause100ms();
    }

    @When("^op click 'Edit Route' and then click 'Load Waypoints of Selected Route\\(s\\) Only'$")
    public void loadWaypointsOfSelectedRoute()
    {
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
        routeLogsPage.selectTag(String.valueOf(createRouteResponse.getId()), newTag);
    }

    @Then("route's tag must contain '([^\\\"]*)'")
    public void verifyNewTagAddedToRoute(String newTag)
    {
        String tags = routeLogsPage.getRouteTag(String.valueOf(createRouteResponse.getId()));
        boolean isContainsNewTag = tags.contains(newTag);
        Assert.assertTrue(isContainsNewTag, String.format("Route does not contains tag '%s'.", newTag));
    }

    @When("^op delete route on Operator V2$")
    public void opDeleteDeleteRoute()
    {
        routeLogsPage.deleteRoute(String.valueOf(createRouteResponse.getId()));
    }

    @Then("^route must be deleted successfully$")
    public void verifyRouteDeletedSuccessfully()
    {
        routeLogsPage.searchTableByRouteId(String.valueOf(createRouteResponse.getId()));
        boolean isTableEmpty = routeLogsPage.isTableEmpty();
        Assert.assertTrue(isTableEmpty, "Route still exist in table. Fail to delete route.");
        routeDeleted = true;
    }
}
