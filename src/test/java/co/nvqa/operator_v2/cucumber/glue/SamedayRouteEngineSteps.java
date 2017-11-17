package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.SamedayRouteEnginePage;
import co.nvqa.operator_v2.util.ScenarioStorage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import com.nv.qa.integration.client.operator.BulkyTrackingClient;
import com.nv.qa.integration.model.core.BulkyOrder;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.utils.NvLogger;
import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class SamedayRouteEngineSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private SamedayRouteEnginePage samedayRouteEnginePage;
    private BulkyTrackingClient bulkyTrackingClient;

    @Inject
    public SamedayRouteEngineSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        samedayRouteEnginePage = new SamedayRouteEnginePage(getWebDriver());
        bulkyTrackingClient = new BulkyTrackingClient(TestConstants.API_BASE_URL);
    }

    @When("^op 'Run Route Engine' on Same-Day Route Engine menu using data below:$")
    public void runRouteEngine(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String hubName = mapOfData.get("hub");
        String routingAlgorithm = mapOfData.get("routingAlgorithm");
        String fleetType1OperatingHoursStart = mapOfData.get("fleetType1OperatingHoursStart");
        String fleetType1OperatingHoursEnd = mapOfData.get("fleetType1OperatingHoursEnd");
        String fleetType1BreakingDurationStart = mapOfData.get("fleetType1BreakingDurationStart");
        String fleetType1BreakingDurationEnd = mapOfData.get("fleetType1BreakingDurationEnd");
        String fleetType1Capacity = Optional.ofNullable(mapOfData.get("fleetType1Capacity")).orElse("10");

        String routeGroupName = scenarioStorage.get("routeGroupName");

        samedayRouteEnginePage.selectRouteGroup(routeGroupName);
        samedayRouteEnginePage.selectHub(hubName);
        samedayRouteEnginePage.selectRoutingAlgorithm(routingAlgorithm);
        samedayRouteEnginePage.setFleetType1Capacity(fleetType1Capacity);
        samedayRouteEnginePage.selectFleetType1OperatingHoursStart(fleetType1OperatingHoursStart);
        samedayRouteEnginePage.selectFleetType1OperatingHoursEnd(fleetType1OperatingHoursEnd);

        if(fleetType1BreakingDurationStart!=null)
        {
            samedayRouteEnginePage.selectFleetType1BreakDurationStart(fleetType1BreakingDurationStart);
        }

        if(fleetType1BreakingDurationEnd!=null)
        {
            samedayRouteEnginePage.selectFleetType1BreakDurationEnd(fleetType1BreakingDurationEnd);
        }

        takesScreenshot();
        samedayRouteEnginePage.clickRunRouteEngineButton();
        takesScreenshot();
    }

    @When("^op 'Run Route Engine' without break on Same-Day Route Engine menu using data below:$")
    public void runRouteEngineWithoutBreak(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String hubName = mapOfData.get("hub");
        String routingAlgorithm = mapOfData.get("routingAlgorithm");
        String fleetType1OperatingHoursStart = mapOfData.get("fleetType1OperatingHoursStart");
        String fleetType1OperatingHoursEnd = mapOfData.get("fleetType1OperatingHoursEnd");
        String fleetType1BreakingDurationStart = mapOfData.get("fleetType1BreakingDurationStart");
        String fleetType1BreakingDurationEnd = mapOfData.get("fleetType1BreakingDurationEnd");
        String fleetType1Capacity = Optional.ofNullable(mapOfData.get("fleetType1Capacity")).orElse("10");

        String routeGroupName = scenarioStorage.get("routeGroupName");

        samedayRouteEnginePage.selectRouteGroup(routeGroupName);
        samedayRouteEnginePage.selectHub(hubName);
        samedayRouteEnginePage.selectRoutingAlgorithm(routingAlgorithm);
        samedayRouteEnginePage.setFleetType1Capacity(fleetType1Capacity);
        samedayRouteEnginePage.selectFleetType1OperatingHoursStart(fleetType1OperatingHoursStart);
        samedayRouteEnginePage.selectFleetType1OperatingHoursEnd(fleetType1OperatingHoursEnd);
        takesScreenshot();
        samedayRouteEnginePage.clickRunRouteEngineButton();
        takesScreenshot();
    }

    @Then("^op create the suggested route")
    public void createRoute()
    {
        samedayRouteEnginePage.selectDriverOnRouteSettingsPage("OpV2No.1");
        takesScreenshot();
        samedayRouteEnginePage.clickCreate1RoutesButton();
        takesScreenshot();
    }

    @Then("^op open same day route engine waypoint detail dialog")
    public void openWaypointDetailsDeialog()
    {
        samedayRouteEnginePage.openWaypointDetail();
    }

    @Then("^op download same day route engine waypoint detail dialog")
    public void downloadWaypointDetail()
    {
        try
        {
            Order order = scenarioStorage.get("order");
            samedayRouteEnginePage.downloadCsvOnWaypointDetails(order.getTracking_id());
        }
        catch(IOException ex)
        {
            NvLogger.warnf("Error on method 'downloadWaypointDetail'. Cause: %s", ex.getMessage());
        }
    }

    @When("^op open unrouted detail dialog")
    public void openUnroutedDetailDialog()
    {
        samedayRouteEnginePage.openUnroutedDetailDialog();
    }

    @Then("^op verify the unrouted detail dialog")
    public void verifyUnroutedDetailDialog()
    {
        samedayRouteEnginePage.verifyUnroutedDetailDialog();
    }

    @When("^op update timeslot on same day route engine")
    public void updateTimeslot()
    {
        Calendar cal = Calendar.getInstance();
        cal.setTimeZone(TimeZone.getTimeZone(Optional.ofNullable(TestUtils.getOperatorTimezone(getWebDriver())).orElse("UTC")));
        cal.add(Calendar.DATE, 1);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        scenarioStorage.put("new-suggested-date", sdf.format(cal.getTime()));
        samedayRouteEnginePage.changeTheSuggestedDate(sdf.format(cal.getTime()));
        scenarioStorage.put("bulky-tracking-id", samedayRouteEnginePage.getWaypointTrackingIds());
        samedayRouteEnginePage.clickUpdateTimeslotBtn();
    }

    @Then("^op verify the updated timeslot")
    public void verifyBulkyOrderTimeslotUpdated()
    {
        String suggestedDate = scenarioStorage.get("new-suggested-date");
        String asyncIdString = scenarioStorage.get("orderAsyncId");
        String trackingIdsString = scenarioStorage.get("bulky-tracking-id");
        List<String> trackingIds = Arrays.asList(trackingIdsString.split(","));
        trackingIds.forEach((String trId) ->
        {
            BulkyOrder order = bulkyTrackingClient.getBulkyOrderDetail(trId, asyncIdString);
            Assert.assertEquals(suggestedDate,order.getSuggested_timeslot().getDate());
        });
    }
}
