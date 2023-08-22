package co.nvqa.operator_v2.cucumber.glue;


import co.nvqa.operator_v2.selenium.page.RouteInboundNewPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;

/**
 * @author SathishKumar
 */
@ScenarioScoped/**/
public class RouteInboundNewSteps extends AbstractSteps {

  private RouteInboundNewPage routeInboundNewPage;

  public RouteInboundNewSteps() {
  }

  @Override
  public void init() {
    routeInboundNewPage = new RouteInboundNewPage(getWebDriver());
  }

  @When("Station operator get Route Summary Details on Route Inbound page with multiple routes using data below:")
  public void operatorGetRouteDetailsOnRouteInboundPageWithMultipleRoutesUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String hubName = mapOfData.get("hubName");
    String fetchBy = mapOfData.get("fetchBy");
    String routeId = mapOfData.get("routeId");
    String trackingId = mapOfData.get("trackingId");
    String driverName = mapOfData.get("driverName");

    if (StringUtils.isNotBlank(routeId) && fetchBy.equalsIgnoreCase("RouteId")) {
      routeInboundNewPage.fetchRouteByRouteId(hubName, routeId);
    }
    if (StringUtils.isNotBlank(trackingId) && fetchBy.equalsIgnoreCase("TrackingId")) {
      routeInboundNewPage.fetchRouteByTrackingId(hubName, trackingId);
    }
    if (StringUtils.isNotBlank(driverName) && fetchBy.equalsIgnoreCase("DriverName")) {
      routeInboundNewPage.fetchRouteByDriver(hubName, driverName);
    }
    pause2s();
    if (routeInboundNewPage.chooseRouteModal.size() > 0) {
      routeInboundNewPage.chooseRoute(routeId);
    }
  }

  @When("Station operator get Route Summary Details on Route Inbound page using data below:")
  public void operatorGetRouteDetailsOnRouteInboundPageUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String hubName = mapOfData.get("hubName");
    String fetchBy = mapOfData.get("fetchBy");
    String routeId = mapOfData.get("routeId");
    String trackingId = mapOfData.get("trackingId");
    String driverName = mapOfData.get("driverName");

    if (StringUtils.isNotBlank(routeId) && fetchBy.equalsIgnoreCase("RouteId")) {
      routeInboundNewPage.fetchRouteByRouteId(hubName, routeId);
    }
    if (StringUtils.isNotBlank(trackingId) && fetchBy.equalsIgnoreCase("TrackingId")) {
      routeInboundNewPage.fetchRouteByTrackingId(hubName, trackingId);
    }
    if (StringUtils.isNotBlank(driverName) && fetchBy.equalsIgnoreCase("DriverName")) {
      routeInboundNewPage.fetchRouteByDriver(hubName, driverName);
    }
  }

  @When("Station operator get Route Summary Details on Route Inbound page using trackingId with multiple routes:")
  public void operatorGetRouteDetailsOnRouteInboundPageUsingTrackingIdWithMultipleRoutesDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String hubName = mapOfData.get("hubName");
    String routeId = mapOfData.get("routeId");
    String trackingId = mapOfData.get("trackingId");

    if (StringUtils.isNotBlank(trackingId)) {
      routeInboundNewPage.fetchRouteByTrackingId(hubName, trackingId);
    }
  }

  @Then("operator verifies the toast message {string} is displayed")
  public void operatorVerifiesTheToastMessageIsDisplayed(String message) {
    message = resolveValue(message);
    routeInboundNewPage.validationOfErrorToastMessage(message);
    takesScreenshot();
  }

  @And("Operator confirms the driver attendance")
  public void operatorConfirmsTheDriverAttendance() {
    routeInboundNewPage.confirmDriverAttendance();
  }

  @Then("Operator verifies that Driver Attendance confirmation modal is displayed")
  public void operatorVerifiesThatDriverAttendanceConfirmationModalIsDisplayed() {
    routeInboundNewPage.validateDriverAttendanceDialogMessage();
  }

  @Then("Operator is redirected to Route Inbound - Route Summary page")
  public void operatorIsRedirectedToRouteInboundRouteSummaryPage() {
    routeInboundNewPage.validateRouteSummaryText();
    takesScreenshot();
  }

  @Then("Operator verifies Route Summary details are dispayed correctly")
  public void operatorVerifiesRouteSummaryDetailsAreDispayedCorrectly(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String routeId = mapOfData.get("routeId");
    String driverName = mapOfData.get("driverName");
    String hubName = mapOfData.get("hubName");
    String date = mapOfData.get("date");
    routeInboundNewPage.validateDriverRouteSummary(routeId, driverName, hubName, date);
    takesScreenshot();
  }

  @Then("Operator verifies waypoint performance details are dispayed correctly")
  public void operatorVerifiesWaypointPerformanceDetailsAreDispayedCorrectly(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String pending = mapOfData.get("pending");
    String partial = mapOfData.get("partial");
    String failed = mapOfData.get("failed");
    String completed = mapOfData.get("completed");
    String total = mapOfData.get("total");
    String successRate = mapOfData.get("successRate");
    routeInboundNewPage.validateWaypointPeformance(pending, partial, failed, completed, total,
        successRate);
    takesScreenshot();
  }

  @Then("Operator verifies Collection summary details are dispayed correctly")
  public void operatorVerifiesCollectionSummaryDetailsAreDispayedCorrectly(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String cash = mapOfData.get("cash");
    String failedParcels = mapOfData.get("failedParcels");
    String c2cplusReturn = mapOfData.get("c2cplusReturn");
    String reservations = mapOfData.get("reservations");
    routeInboundNewPage.validateCollectionSummary(cash, failedParcels, c2cplusReturn, reservations);
    takesScreenshot();
  }

  @Then("Operator verifies problematic parcels details are displayed correctly in the row {int}")
  public void operatorVerifiesProblematicParcelsDetailsAreDisplayedCorrectlyInTheRow(int row,
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String trackingId = mapOfData.get("trackingId");
    String shipperName = mapOfData.get("shipperName");
    String location = mapOfData.get("location");
    String type = mapOfData.get("type");
    String issue = mapOfData.get("issue");
    String rowNumber = String.valueOf(row);
    routeInboundNewPage.validateProblematicParcelDetails(rowNumber, trackingId, shipperName,
        location, type, issue);
    takesScreenshot();
  }
}
