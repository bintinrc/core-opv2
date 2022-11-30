package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commonauth.utils.TokenUtils;
import co.nvqa.commons.client.core.BulkyTrackingClient;
import co.nvqa.commons.model.core.RouteGroup;
import co.nvqa.commons.model.core.bukly.BulkyOrder;
import co.nvqa.operator_v2.selenium.page.SamedayRouteEnginePage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.TimeZone;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
@ScenarioScoped
public class SamedayRouteEngineSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(SamedayRouteEngineSteps.class);

  private SamedayRouteEnginePage samedayRouteEnginePage;
  private BulkyTrackingClient bulkyTrackingClient;

  public SamedayRouteEngineSteps() {
  }

  @Override
  public void init() {
    samedayRouteEnginePage = new SamedayRouteEnginePage(getWebDriver());
  }

  public BulkyTrackingClient getBulkyTrackingClient() {
    if (bulkyTrackingClient == null) {
      bulkyTrackingClient = new BulkyTrackingClient(TestConstants.API_BASE_URL,
          TokenUtils.getOperatorAuthToken());
    }
    return bulkyTrackingClient;
  }

  @When("^Operator 'Run Route Engine' on Same-Day Route Engine menu using data below:$")
  public void runRouteEngine(DataTable dataTable) {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);

    Map<String, String> mapOfData = dataTable.asMap(String.class, String.class);
    String hubName = mapOfData.get("hub");
    String routingAlgorithm = mapOfData.get("routingAlgorithm");
    String fleetType1OperatingHoursStart = mapOfData.get("fleetType1OperatingHoursStart");
    String fleetType1OperatingHoursEnd = mapOfData.get("fleetType1OperatingHoursEnd");
    String fleetType1BreakingDurationStart = mapOfData.get("fleetType1BreakingDurationStart");
    String fleetType1BreakingDurationEnd = mapOfData.get("fleetType1BreakingDurationEnd");
    String fleetType1Capacity = Optional.ofNullable(mapOfData.get("fleetType1Capacity"))
        .orElse("10");

    samedayRouteEnginePage.selectRouteGroup(routeGroup.getName());
    samedayRouteEnginePage.selectRoutingAlgorithm(routingAlgorithm);
    samedayRouteEnginePage.selectHub(hubName);
    samedayRouteEnginePage.setFleetType1Capacity(fleetType1Capacity);
    samedayRouteEnginePage.selectFleetType1OperatingHoursStart(fleetType1OperatingHoursStart);
    samedayRouteEnginePage.selectFleetType1OperatingHoursEnd(fleetType1OperatingHoursEnd);

    if (fleetType1BreakingDurationStart != null) {
      samedayRouteEnginePage.selectFleetType1BreakDurationStart(fleetType1BreakingDurationStart);
    }

    if (fleetType1BreakingDurationEnd != null) {
      samedayRouteEnginePage.selectFleetType1BreakDurationEnd(fleetType1BreakingDurationEnd);
    }

    takesScreenshot();
    samedayRouteEnginePage.clickRunRouteEngineButton();
    takesScreenshot();
  }

  @When("^op 'Run Route Engine' without break on Same-Day Route Engine menu using data below:$")
  public void runRouteEngineWithoutBreak(DataTable dataTable) {
    final RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);

    final Map<String, String> mapOfData = dataTable.asMap(String.class, String.class);
    String hubName = mapOfData.get("hub");
    String routingAlgorithm = mapOfData.get("routingAlgorithm");
    String fleetType1OperatingHoursStart = mapOfData.get("fleetType1OperatingHoursStart");
    String fleetType1OperatingHoursEnd = mapOfData.get("fleetType1OperatingHoursEnd");
    String fleetType1Capacity = Optional.ofNullable(mapOfData.get("fleetType1Capacity"))
        .orElse("10");

    samedayRouteEnginePage.selectRouteGroup(routeGroup.getName());
    samedayRouteEnginePage.selectHub(hubName);
    samedayRouteEnginePage.selectRoutingAlgorithm(routingAlgorithm);
    samedayRouteEnginePage.setFleetType1Capacity(fleetType1Capacity);
    samedayRouteEnginePage.selectFleetType1OperatingHoursStart(fleetType1OperatingHoursStart);
    samedayRouteEnginePage.selectFleetType1OperatingHoursEnd(fleetType1OperatingHoursEnd);
    takesScreenshot();
    samedayRouteEnginePage.clickRunRouteEngineButton();
    takesScreenshot();
  }

  @Then("^Operator create the suggested route with driver name = \"([^\"]*)\"$")
  public void createRoute(String driverName) {
    samedayRouteEnginePage.selectDriverOnRouteSettingsPage(driverName);
    takesScreenshot();
    samedayRouteEnginePage.clickCreate1RoutesButton();
    takesScreenshot();
  }

  @Then("^op open same day route engine waypoint detail dialog$")
  public void openWaypointDetailsDeialog() {
    samedayRouteEnginePage.openWaypointDetail();
  }

  @Then("^op download same day route engine waypoint detail dialog$")
  public void downloadWaypointDetail() {
    try {
      String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
      samedayRouteEnginePage.downloadCsvOnWaypointDetails(trackingId);
    } catch (IOException ex) {
      LOGGER.warn("Error on method 'downloadWaypointDetail'. Cause: {}", ex.getMessage());
    }
  }

  @When("op open unrouted detail dialog")
  public void openUnroutedDetailDialog() {
    samedayRouteEnginePage.openUnroutedDetailDialog();
  }

  @Then("op verify the unrouted detail dialog")
  public void verifyUnroutedDetailDialog() {
    samedayRouteEnginePage.verifyUnroutedDetailDialog();
  }

  @When("op update timeslot on same day route engine")
  public void updateTimeslot() {
    Calendar cal = Calendar.getInstance();
    cal.setTimeZone(TimeZone.getTimeZone(
        Optional.ofNullable(TestUtils.getOperatorTimezone(getWebDriver())).orElse("UTC")));
    cal.add(Calendar.DATE, 1);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String newSuggestedDate = sdf.format(cal.getTime());
    samedayRouteEnginePage.changeTheSuggestedDate(newSuggestedDate);
    samedayRouteEnginePage.clickUpdateTimeslotBtn();
    put("new-suggested-date", newSuggestedDate);
    put("bulky-tracking-id", samedayRouteEnginePage.getWaypointTrackingIds());
  }

  @Then("op verify the updated timeslot")
  public void verifyBulkyOrderTimeslotUpdated() {
    String asyncIdString = get(KEY_CREATED_ORDER_ASYNC_ID);
    String suggestedDate = get("new-suggested-date");
    String trackingIdsString = get("bulky-tracking-id");
    List<String> trackingIds = Arrays.asList(trackingIdsString.split(","));
    trackingIds.forEach(trId ->
    {
      BulkyOrder order = getBulkyTrackingClient().getBulkyOrderDetail(trId, asyncIdString);
      Assertions.assertThat(order.getSuggestedTimeslot().getDate()).isEqualTo(suggestedDate);
    });
  }
}
