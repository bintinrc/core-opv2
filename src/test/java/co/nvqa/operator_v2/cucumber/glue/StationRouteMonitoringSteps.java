package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage;
import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage.StationRouteMonitoring;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.junit.Assert;
import org.openqa.selenium.ElementNotInteractableException;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.NoSuchWindowException;
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
    retryIfExpectedExceptionOccurred(() -> {
          stationRouteMonitoringPage.selectHub(hubName);
        }, null, LOGGER::warn, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, 3,
        NoSuchElementException.class, NoSuchWindowException.class,
        ElementNotInteractableException.class, ElementNotInteractableException.class,
        TimeoutException.class);
    takesScreenshot();
  }

  @And("Operator enters routeID in the Route filter")
  public void operatorEntersRouteIDInTheRouteFilter() {
    Long routeID = get(KEY_CREATED_ROUTE_ID);
    stationRouteMonitoringPage.filterRoute(routeID.toString());
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

}



