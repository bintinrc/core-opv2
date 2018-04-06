package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.CreateRouteParams;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.Alert;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.stream.Stream;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteLogsSteps extends AbstractSteps
{
    private static final int ALERT_WAIT_TIMEOUT_IN_SECONDS = 15;
    private static final int MAX_RETRY = 10;

    private RouteLogsPage routeLogsPage;

    @Inject
    public RouteLogsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        routeLogsPage = new RouteLogsPage(getWebDriver());
    }

    @When("^Operator create new route using data below:$")
    public void operatorCreateNewRouteUsingDataBelow(Map<String,String> mapOfData)
    {
        try
        {
            String scenarioName = getScenarioManager().getCurrentScenario().getName();
            String createdDate = CREATED_DATE_SDF.format(new Date());

            Date routeDate = YYYY_MM_DD_SDF.parse(mapOfData.get("routeDate"));

            String routeTags = mapOfData.get("routeTags").replaceAll("\\[", "").replaceAll("]", "");
            String[] tags = Stream.of(routeTags.split(",")).map(String::trim).toArray(String[]::new);

            String zoneName = mapOfData.get("zoneName");
            String hubName = mapOfData.get("hubName");
            String ninjaDriverName = mapOfData.get("ninjaDriverName");
            String vehicleName = mapOfData.get("vehicleName");
            String comments = String.format("This route is created from OpV2 for testing purpose only. Ignore this route. Created at %s by scenario \"%s\".", createdDate, scenarioName);

            CreateRouteParams createRouteParams = new CreateRouteParams();
            createRouteParams.setRouteDate(routeDate);
            createRouteParams.setRouteTags(tags);
            createRouteParams.setZoneName(zoneName);
            createRouteParams.setHubName(hubName);
            createRouteParams.setNinjaDriverName(ninjaDriverName);
            createRouteParams.setVehicleName(vehicleName);
            createRouteParams.setComments(comments);
            long createdRouteId = routeLogsPage.createNewRoute(createRouteParams);

            Route route = new Route();
            route.setId(createdRouteId);
            route.setComments(comments);

            put("createRouteParams", createRouteParams);
            put(KEY_CREATED_ROUTE, route);
            put(KEY_CREATED_ROUTE_ID, createdRouteId);
            putInList(KEY_LIST_OF_ARCHIVED_ROUTE_IDS, createdRouteId);
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse date.", ex);
        }
    }

    @Then("^Operator verify the new route is created successfully$")
    public void operatorVerifyTheNewRouteIsCreatedSuccessfully()
    {
        CreateRouteParams createRouteParams = get("createRouteParams");
        Route route = get(KEY_CREATED_ROUTE);
        routeLogsPage.verifyNewRouteIsCreatedSuccessfully(createRouteParams, route);
    }

    @When("^Operator select route date filter and click 'Load Selection'$")
    public void loadSelection()
    {
        Calendar fromCalendar = Calendar.getInstance();
        fromCalendar.add(Calendar.DATE, -1);

        Calendar toCalendar = Calendar.getInstance();

        routeLogsPage.selectRouteDateFilter(fromCalendar.getTime(), toCalendar.getTime());
        routeLogsPage.clickLoadSelection();
    }

    @When("^Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route\\(s\\) Only'$")
    public void loadWaypointsOfSelectedRoute()
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.searchAndVerifyRouteExist(routeId);
        routeLogsPage.clickActionButtonOnTable(1, RouteLogsPage.ACTION_BUTTON_EDIT_ROUTE);
        pause100ms();
        routeLogsPage.clickLoadWaypointsOfSelectedRoutesOnly();
        pause1s();
    }

    @Then("^Operator redirect to this page '([^\"]*)'$")
    public void verifyLoadWaypointsOfSelectedRoute(String redirectUrl)
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);

        String primaryWindowHandle = getWebDriver().getWindowHandle();
        Set<String> windowHandles = getWebDriver().getWindowHandles();

        String actualCurrentUrl = null;

        for(String windowName : windowHandles)
        {
            if(!primaryWindowHandle.equals(windowName))
            {
                getWebDriver().switchTo().window(windowName);
                pause3s();

                try
                {
                    WebDriverWait webDriverWait = new WebDriverWait(getWebDriver(), ALERT_WAIT_TIMEOUT_IN_SECONDS);
                    Alert alert = webDriverWait.until(ExpectedConditions.alertIsPresent());
                    pause200ms();
                    alert.accept();
                }
                catch(Exception ex)
                {
                    getScenarioManager().writeToCurrentScenarioLog(String.format("Alert is not present after %ds.", ALERT_WAIT_TIMEOUT_IN_SECONDS));
                    getScenarioManager().writeToCurrentScenarioLog(TestUtils.convertExceptionStackTraceToString(ex));
                }

                pause100ms();
                actualCurrentUrl = getCurrentUrl();
                getWebDriver().close();
                pause100ms();
                getWebDriver().switchTo().window(primaryWindowHandle);
                pause500ms();
                break;
            }
        }

        Map<String,String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("route_id", String.valueOf(routeId));
        String expectedRedirectUrl = replaceParam(redirectUrl, mapOfDynamicVariable);

        Assert.assertEquals(String.format("Operator does not redirect to page %s", redirectUrl), expectedRedirectUrl, actualCurrentUrl);
    }

    @Then("^Operator close Edit Routes dialog$")
    public void opCloseEditRoutesDialog()
    {
        routeLogsPage.clickCancelOnEditRoutesDialog();
    }

    @When("^Operator click 'Edit Details'$")
    public void opClickEditDetails()
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.searchAndVerifyRouteExist(routeId);
        routeLogsPage.clickActionButtonOnTable(1, RouteLogsPage.ACTION_BUTTON_EDIT_DETAILS);
        pause100ms();
    }

    @When("^Operator edit 'Assigned Driver' to driver '([^\"]*)' and edit 'Comments'$")
    public void opEditAssignedDriverAndComments(String newDriverName)
    {
        routeLogsPage.editAssignedDriver(newDriverName);
        routeLogsPage.clickSaveButtonOnEditDetailsDialog();
    }

    @Then("^Operator verify route's driver must be changed to '([^\"]*)' in table list$")
    public void verifyRouteDriverIsChanged(String newDriverName)
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);

        boolean loadSelectionButtonIsVisible;
        int counter = 1;

        /**
         * Sometimes button "Edit Filter" is not clicked correctly
         * and it makes "Load Selection" button does not appear.
         * So we need to click that "Edit Filter" button over and over until
         * "Load Selection" button is appear.
         */
        do
        {
            String level = "[INFO]";

            if(counter>1)
            {
                level = "[WARNING]";
            }

            takesScreenshot();
            writeToCurrentScenarioLog(String.format("%s Trying to click 'Edit Filter' button x%d.", level, counter++));

            routeLogsPage.clickEditFilter();
            loadSelectionButtonIsVisible = routeLogsPage.isLoadSelectionVisible();
        }
        while(!loadSelectionButtonIsVisible && counter<=MAX_RETRY);

        routeLogsPage.clickLoadSelection();
        routeLogsPage.searchAndVerifyRouteExist(routeId);
        String actualDriverName = routeLogsPage.getTextOnTable(1, RouteLogsPage.COLUMN_CLASS_DATA_DRIVER_NAME);
        Assert.assertEquals("Driver is not change.", newDriverName, actualDriverName);
    }

    @When("^Operator add tag '([^\"]*)'$")
    public void opAddNewTagToRoute(String newTag)
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.selectTag(routeId, newTag);
    }

    @Then("^Operator verify route's tag must contain '([^\"]*)'$")
    public void verifyNewTagAddedToRoute(String newTag)
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        String tags = routeLogsPage.getRouteTag(routeId);
        Assert.assertThat(String.format("Route does not contains tag '%s'.", newTag), tags, Matchers.containsString(newTag));
    }

    @When("^Operator delete route on Operator V2$")
    public void opDeleteDeleteRoute()
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.deleteRoute(routeId);
    }

    @Then("^Operator verify route must be deleted successfully$")
    public void verifyRouteDeletedSuccessfully()
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.searchTableByRouteId(routeId);
        boolean isTableEmpty = routeLogsPage.isTableEmpty();
        put(KEY_ROUTE_IS_ALREADY_DELETED, true);
        Assert.assertTrue("Route still exist in table. Fail to delete route.", isTableEmpty);
    }
}
