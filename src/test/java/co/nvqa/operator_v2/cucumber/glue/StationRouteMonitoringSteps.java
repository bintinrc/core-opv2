package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage;
import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage.InvalidFailedWP;
import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage.StationRouteMonitoring;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.junit.Assert;
import org.openqa.selenium.ElementNotInteractableException;
import org.openqa.selenium.InvalidArgumentException;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.NoSuchWindowException;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.TimeoutException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@SuppressWarnings("unused")
@ScenarioScoped
public class StationRouteMonitoringSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(StationRouteMonitoringSteps.class);
  private StationRouteMonitoringPage stationRouteMonitoringPage;

  public StationRouteMonitoringSteps() {
  }

  @Override
  public void init() {
    stationRouteMonitoringPage = new StationRouteMonitoringPage(getWebDriver());
  }

  @When("Operator loads Operator portal Station Route Monitoring page")
  public void operator_loads_Operator_portal_station_route_monitoring_page() {
    stationRouteMonitoringPage.loadStationRouteMonitoringPage();
  }

  @SuppressWarnings("unchecked")
  @And("Operator selects hub {string} and click load selection")
  public void operatorSelectsHubAndClickLoadSelection(String hubName) {
    doWithRetry(() -> stationRouteMonitoringPage.selectHub(hubName), "Select Hub and Click load");
    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @And("Operator enters routeID {string} in the Route filter")
  public void operatorEntersRouteIDInTheRouteFilter(String routeID) {
    routeID = resolveValue(routeID);
    String finalRouteID = routeID;
    doWithRetry(() -> stationRouteMonitoringPage.filterRoute(finalRouteID),
        "Filter route Id");
    takesScreenshot();

  }

  @Then("Operator verify value on Station Route Monitoring page for the {string} column is equal to {int}")
  public void operatorVerifyValueOnStationRouteMonitoringPageForTheColumnIsEqualTo(
      String columnName,
      int expectedValue) {
    StationRouteMonitoring columnValue = StationRouteMonitoring.valueOf(columnName);
    String actualColumnValue = stationRouteMonitoringPage.getColumnValue(columnValue);
    Assert.assertEquals(f("expected Value is not matching for column : %s", columnName),
        expectedValue, Integer.parseInt(actualColumnValue));
    takesScreenshot();
  }

  @Then("Operator verify value on Station Route Monitoring page for the {string} column is equal to {string}")
  public void operatorVerifyValueOnStationRouteMonitoringPageForTheColumnValueIsEqualTo(
      String columnName, String expectedValue) {
    expectedValue = resolveValue(expectedValue);
    StationRouteMonitoring columnValue = StationRouteMonitoring.valueOf(columnName);
    String actualColumnValue = stationRouteMonitoringPage.getColumnValue(columnValue);
    Assert.assertEquals(f("expected Value is not matching for column : %s", columnName),
        expectedValue, actualColumnValue);
    takesScreenshot();
  }

  @When("Operator clicks on the {string} column value link")
  public void operatorClicksOnTheColumnValueLink(String columnName) {
    StationRouteMonitoring columnValue = StationRouteMonitoring.valueOf(columnName);
    stationRouteMonitoringPage.click(columnValue.getXpath());

  }

  @Then("Operator verifies pop up modal is showing correct total parcels")
  public void operatorVerifiesPopUpModalIsShowingCorrectTotalParcels(
      Map<String, String> mapOfData) {
    stationRouteMonitoringPage.validateTotalParcelsCounts(mapOfData);
    takesScreenshot();
  }

  @Then("Operator verifies pop up modal is showing No Results Found")
  public void operatorVerifiesPopUpModalIsShowingNoResultFound(
      Map<String, String> mapOfData) {
    stationRouteMonitoringPage.validateNoResultsFoundText(mapOfData);
    takesScreenshot();
  }

  @When("Operator Filters the records in the {string} by applying the following filters:")
  public void operatorFiltersTheRecordsInTheByApplyingTheFollowingFilters(String table,
      DataTable searchParameters) {
    List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
    Map<String, String> filter = resolveKeyValues(filters.get(0));
    stationRouteMonitoringPage.applyFilters(table, filter);
    takesScreenshot();
  }

  @And("Operator selects the timeslot {string} in the table")
  public void operatorSeletsTimeSlotInTheTable(String filter) {
    stationRouteMonitoringPage.timeslot.selectValue(filter);
  }

//  @Then("Operator verify value in the {string} table for the {string} column contains {string}")
//  public void operatorVerifyValueValueInTheInvalidFailedWP(String tableName, String columnName,
//      String expectedValue) {
//    if (expectedValue.equalsIgnoreCase("{KEY_SHIPPER_ADDRESS}")) {
//      expectedValue = get("KEY_SHIPPER_ADDRESS").toString();
//    }
//    InvalidFailedWP columnValue = InvalidFailedWP.valueOf(columnName);
//    String actualColumnValue = stationRouteMonitoringPage.getColumnValueFromTable(tableName,
//        columnValue);
//    Assertions.assertThat(actualColumnValue).as("Assertion for %s value", columnName)
//        .isEqualTo(expectedValue);
//    takesScreenshot();
//  }

  @Then("Operator verify value in the {string} table for the Tags column value is equal to {string}")
  public void operatorVerifyValueInTheTagColumn(String tableName, String orderTag) {
    String actualColumnValue = stationRouteMonitoringPage.getColumnValueFromTagColumn(tableName);
    Assertions.assertThat(actualColumnValue).as("Assertion for Tag Column value")
        .isEqualTo(orderTag);
    takesScreenshot();
  }

  @Then("Operator verify value in the {string} table for the {string} column value is equal to {string}")
  public void operatorVerifyValueValueInTheInvalidFailedWPIsEqual(String tableName,
      String columnName, String expectedValue) {
    expectedValue = resolveValue(expectedValue);
    InvalidFailedWP columnValue = InvalidFailedWP.valueOf(columnName);
    String actualColumnValue = stationRouteMonitoringPage.getColumnValueFromTable(tableName,
        columnValue);
    Assertions.assertThat(actualColumnValue).as("Assertion for %s value", columnName)
        .isEqualTo(expectedValue);
    takesScreenshot();
  }

  @Then("Operator verifies that Shipper Pickup page is opened on clicking Reservation ID {string} table {string}")
  public void operator_verifies_that_Shipper_Pickup_page_is_opened_on_clicking_Reservation_ID(
      String reservationID, String tableName) {
    reservationID = resolveValue(reservationID);
    stationRouteMonitoringPage.validateNavigationOfReservationLink(tableName, reservationID);
    takesScreenshot();
  }

  @And("Operator verifies that Edit Order page is opened on clicking tracking id {string} in table {string}")
  public void operatorVerifiesThatEditOrderPageIsOpenedOnClickingTrackingIdFromTheRouteMonitoringPage(
      String trackingID,
      String tableName) {
    trackingID = resolveValue(trackingID);
    stationRouteMonitoringPage.validateNavigationOfTrackingIDLink(trackingID, tableName);
    takesScreenshot();
  }

  @And("Operator saves old route")
  public void operatorSavesOldRoute() {
    put(KEY_OLD_ROUTE_ID, get("KEY_CREATED_ROUTE_ID"));
  }
}



