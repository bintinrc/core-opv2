package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.GlobalInboundResponse;
import co.nvqa.operator_v2.selenium.page.ParcelSweeperPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ParcelSweeperSteps extends AbstractSteps {

  private ParcelSweeperPage parcelSweeperPage;

  public ParcelSweeperSteps() {
  }

  @Override
  public void init() {
    parcelSweeperPage = new ParcelSweeperPage(getWebDriver());
  }

  @Given("^Operator sweep created parcel using hub \"(.+)\"$")
  public void operatorGoToMenu(String hubName) {
    parcelSweeperPage.selectHub(hubName);
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    parcelSweeperPage.enterTrackingId(trackingId);
  }

  @Given("^Operator sweep parcel using data below:$")
  public void operatorSweepParcelUsingDataBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String hubName = mapOfData.get("hubName");
    parcelSweeperPage.selectHub(hubName);

    String trackingId = mapOfData.get("trackingId");
    parcelSweeperPage.enterTrackingId(trackingId);
  }

  @Then("^Operator verify Route ID on Parcel Sweeper page using data below:$")
  public void operatorVerifyRouteIDOnParcelSweeperPageUsingDataBelow(
      Map<String, String> mapOfData) {
    parcelSweeperPage.loadingSpinner.waitUntilInvisible();
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    String routeId = resolvedMapOfData.get("routeId");
    String driverName = resolvedMapOfData.get("driverName");
    String routeInfoColor = resolvedMapOfData.get("routeInfoColor");
    String routeDescriptionColor = resolvedMapOfData.get("routeDescriptionColor");
    String backgroundColor = resolvedMapOfData.get("backgroundColor");
    parcelSweeperPage
        .verifyRouteInfo(routeId, driverName, routeInfoColor, routeDescriptionColor,
            backgroundColor);
  }

  @Then("^Operator verify Zone on Parcel Sweeper page using data below:$")
  public void operatorVerifyZoneOnParcelSweeperPageUsingDataBelow(Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    String zoneName = finalMapOfData.get("zoneName");
    String zoneShortName = finalMapOfData.get("zoneShortName");
    String color = finalMapOfData.get("textColor");
    parcelSweeperPage.verifyZoneInfo(zoneShortName, zoneName, color);
  }

  @Then("^Operator verify Next Sorting Hub on Parcel Sweeper page using data below:$")
  public void operatorVerifyNextSortingHubOnParcelSweeperPageUsingDataBelow(
      Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    String nextSortingTask = finalMapOfData.get("nextSortingHub");

    if (StringUtils.isNotBlank(nextSortingTask)) {
      parcelSweeperPage.verifyNextSortingHubInfo(nextSortingTask);
    }
  }

  @Then("^Operator verify Destination Hub on Parcel Sweeper page using data below:$")
  public void operatorVerifyDestinationHubOnParcelSweeperPageUsingDataBelow(
      Map<String, String> mapOfData) {
    String hubName = mapOfData.get("hubName");
    if (StringUtils.equalsAnyIgnoreCase(hubName, "GLOBAL INBOUND")) {
      GlobalInboundResponse globalInboundResponse = get(KEY_GLOBAL_INBOUND_DATA);
      hubName = globalInboundResponse.getResponsibleHubName();
    }
    String color = mapOfData.get("color");
    parcelSweeperPage.verifyDestinationHub(hubName, color);
  }

  @When("^Operator sweep created parcel using prefix and hub \"([^\"]*)\"$")
  public void operatorSweepCreatedParcelUsingPrefixAndHub(String hubName) {
    parcelSweeperPage.selectHub(hubName);
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    String prefix = trackingId.substring(0, 5);
    trackingId = trackingId.substring(5);
    parcelSweeperPage.addPrefix(prefix);
    parcelSweeperPage.enterTrackingId(trackingId);
  }

}
