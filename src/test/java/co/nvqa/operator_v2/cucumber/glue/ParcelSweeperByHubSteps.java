package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.GlobalInboundResponse;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.operator_v2.selenium.page.ParcelSweeperByHubPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ParcelSweeperByHubSteps extends AbstractSteps {

  private ParcelSweeperByHubPage parcelSweeperByHubPage;

  public ParcelSweeperByHubSteps() {
  }

  @Override
  public void init() {
    parcelSweeperByHubPage = new ParcelSweeperByHubPage(getWebDriver());
  }

  @Given("^Operator sweep parcel on Parcel Sweeper By Hub page using data below:$")
  public void operatorSweepParcelUsingDataBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);

    String hubName = mapOfData.get("hubName");
    parcelSweeperByHubPage.selectHub(hubName);

    String destinationHubName = mapOfData.get("destinationHubName");
    if (StringUtils.equalsAnyIgnoreCase(destinationHubName, "GLOBAL INBOUND")) {
      GlobalInboundResponse globalInboundResponse = get(KEY_GLOBAL_INBOUND_DATA);
      destinationHubName = globalInboundResponse.getDestinationHub();
    } else if (StringUtils.equalsIgnoreCase(destinationHubName, "FROM CREATED ORDER")) {
      Order order = get(KEY_CREATED_ORDER);
      destinationHubName = order.getDestinationHub();
    }
    parcelSweeperByHubPage.syncOrdersByDestinationHub(destinationHubName);

    String trackingId = mapOfData.get("trackingId");

    parcelSweeperByHubPage.enterTrackingId(trackingId);
  }

  @Then("^Operator verify RTS label on Parcel Sweeper By Hub page$")
  public void operatorVerifyRtsLabelOnParcelSweeperByHubPage() {
    parcelSweeperByHubPage.verifyRTSInfo(true);
  }

  @Then("^Operator verify Parcel route different date label on Parcel Sweeper By Hub page$")
  public void operatorVerifyParcelRouteDifferentDateLabelOnParcelSweeperByHubPage() {
    parcelSweeperByHubPage.verifyParcelRouteDifferentDateInfo(true);
  }

  @Then("^Operator verify Route ID on Parcel Sweeper By Hub page using data below:$")
  public void operatorVerifyRouteIDOnParcelSweeperPageUsingDataBelow(
      Map<String, String> mapOfData) {
    String routeId = null;
    String value = mapOfData.get("routeId");
    if (StringUtils.isNotBlank(value)) {
      routeId = value.equalsIgnoreCase("GENERATED") ?
          String.valueOf((Long) get(KEY_CREATED_ROUTE_ID)) :
          value;
    }

    String driverName = mapOfData.get("driverName");
    String color = mapOfData.get("color");
    parcelSweeperByHubPage.verifyRouteInfo(routeId, driverName, color);
  }

  @Then("^Operator verify Zone on Parcel Sweeper By Hub page using data below:$")
  public void operatorVerifyZoneOnParcelSweeperPageUsingDataBelow(Map<String, String> mapOfData) {
    String zoneName = mapOfData.get("zoneName");
    if (StringUtils.equalsIgnoreCase(zoneName, "FROM CREATED ORDER")) {
      Order order = get(KEY_CREATED_ORDER);
      Transaction deliveryTransaction = order.getTransactions().stream()
          .filter(transaction -> "DELIVERY".equalsIgnoreCase(transaction.getType()))
          .findFirst()
          .orElseThrow(() -> new RuntimeException(
              "Could not find DELIVERY transaction for order [" + order.getId() + "]"));
      List<Zone> zones = get(KEY_LIST_OF_ZONE_PREFERENCES);
      Zone routingZone = zones.stream().filter(
          zone -> Objects.equals(zone.getLegacyZoneId(), deliveryTransaction.getRoutingZoneId()))
          .findFirst()
          .orElseThrow(() -> new RuntimeException(
              "Could not find zone with ID = " + deliveryTransaction.getRoutingZoneId()));
      zoneName = f("%s (%s)", routingZone.getShortName(), routingZone.getName());
    }
    String color = mapOfData.get("color");
    parcelSweeperByHubPage.verifyZoneInfo(zoneName, color);
  }

  @Then("^Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:$")
  public void operatorVerifyDestinationHubOnParcelSweeperPageUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String hubName = mapOfData.get("hubName");
    String color = mapOfData.get("textColor");
    parcelSweeperByHubPage.verifyDestinationHub(hubName, color);
  }

  @When("^Operator sweep created parcel on Parcel Sweeper By Hub page using prefix and hub \"([^\"]*)\"$")
  public void operatorSweepCreatedParcelUsingPrefixAndHub(String hubName) {
    parcelSweeperByHubPage.selectHub(hubName);
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    String prefix = trackingId.substring(0, 5);
    trackingId = trackingId.substring(5);
    parcelSweeperByHubPage.addPrefix(prefix);
    parcelSweeperByHubPage.enterTrackingId(trackingId);
  }
}
