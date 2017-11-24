package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.RouteLogsPage;
import co.nvqa.operator_v2.util.ScenarioStorage;
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

import java.util.*;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteLogsSteps extends AbstractSteps
{
    private static final int ALERT_WAIT_TIMEOUT_IN_SECONDS = 15;
    private static final int MAX_RETRY = 10;

    @Inject private ScenarioStorage scenarioStorage;
    private RouteLogsPage routeLogsPage;
    private ScenarioManager scenarioManager;

    @Inject
    public RouteLogsSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
        this.scenarioManager = scenarioManager;
    }

    @Override
    public void init()
    {
        routeLogsPage = new RouteLogsPage(getWebDriver());
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
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.searchAndVerifyRouteExist(String.valueOf(routeId));
        routeLogsPage.clickActionButtonOnTable(1, RouteLogsPage.ACTION_BUTTON_EDIT_ROUTE);
        pause100ms();
        routeLogsPage.clickLoadWaypointsOfSelectedRoutesOnly();
        pause1s();
    }

    @Then("^op redirect to this page '([^\"]*)'$")
    public void verifyLoadWaypointsOfSelectedRoute(String redirectUrl)
    {
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);

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
                    scenarioManager.getCurrentScenario().write(String.format("Alert is not present after %ds.", ALERT_WAIT_TIMEOUT_IN_SECONDS));
                    scenarioManager.getCurrentScenario().write(TestUtils.convertExceptionStackTraceToString(ex));
                }

                pause100ms();
                actualCurrentUrl = getWebDriver().getCurrentUrl();
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

    @Then("^op close Edit Routes dialog$")
    public void opCloseEditRoutesDialog()
    {
        routeLogsPage.clickCancelOnEditRoutesDialog();
    }

    @When("^op click 'Edit Details'$")
    public void opClickEditDetails()
    {
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.searchAndVerifyRouteExist(String.valueOf(routeId));
        routeLogsPage.clickActionButtonOnTable(1, RouteLogsPage.ACTION_BUTTON_EDIT_DETAILS);
        pause100ms();
    }

    @When("^op edit 'Assigned Driver' to driver '([^\"]*)' and edit 'Comments'$")
    public void opEditAssignedDriverAndComments(String newDriverName)
    {
        routeLogsPage.editAssignedDriver(newDriverName);
        routeLogsPage.clickSaveButtonOnEditDetailsDialog();
    }

    @Then("^route's driver must be changed to '([^\"]*)' in table list$")
    public void verifyRouteDriverIsChanged(String newDriverName)
    {
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);

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
            writeToScenarioLog(String.format("%s Trying to click 'Edit Filter' button x%d.", level, counter++));

            routeLogsPage.clickEditFilter();
            loadSelectionButtonIsVisible = routeLogsPage.isLoadSelectionVisible();
        }
        while(!loadSelectionButtonIsVisible && counter<=MAX_RETRY);

        routeLogsPage.clickLoadSelection();
        routeLogsPage.searchAndVerifyRouteExist(String.valueOf(routeId));
        String actualDriverName = routeLogsPage.getTextOnTable(1, RouteLogsPage.COLUMN_CLASS_DATA_DRIVER_NAME);
        Assert.assertEquals("Driver is not change.", newDriverName, actualDriverName);
    }

    @When("^op add tag '([^\"]*)'$")
    public void opAddNewTagToRoute(String newTag)
    {
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.selectTag(String.valueOf(routeId), newTag);
    }

    @Then("^route's tag must contain '([^\"]*)'$")
    public void verifyNewTagAddedToRoute(String newTag)
    {
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);
        String tags = routeLogsPage.getRouteTag(String.valueOf(routeId));
        Assert.assertThat(String.format("Route does not contains tag '%s'.", newTag), tags, Matchers.containsString(newTag));
    }

    @When("^op delete route on Operator V2$")
    public void opDeleteDeleteRoute()
    {
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.deleteRoute(String.valueOf(routeId));
    }

    @Then("^route must be deleted successfully$")
    public void verifyRouteDeletedSuccessfully()
    {
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.searchTableByRouteId(String.valueOf(routeId));
        boolean isTableEmpty = routeLogsPage.isTableEmpty();
        Assert.assertTrue("Route still exist in table. Fail to delete route.", isTableEmpty);
        scenarioStorage.put("routeDeleted", true);
    }
}
