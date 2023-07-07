package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.ParcelSweeperLivePage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@ScenarioScoped
public class ParcelSweeperLiveSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(ParcelSweeperLiveSteps.class);

  private ParcelSweeperLivePage parcelSweeperLivePage;

  public ParcelSweeperLiveSteps() {
  }

  @Override
  public void init() {
    parcelSweeperLivePage = new ParcelSweeperLivePage(getWebDriver());
  }


  @Then("^Operator verifies data on Parcel Sweeper Live page using data below:$")
  public void operatorVerifiesWithInvalidTrackingIdProvidedErrorsDisplayed(
      Map<String, String> mapOfData) {
    String routeId = mapOfData.get("routeId");
    String routeIdColor = mapOfData.get("routeId_color");
    String zoneName = mapOfData.get("zoneName");
    String zoneNameColor = mapOfData.get("zoneName_color");
    String destinationHub = mapOfData.get("destinationHub");
    if (StringUtils.equalsIgnoreCase(destinationHub, "CREATED")) {
      Order order = get(KEY_CREATED_ORDER);
      destinationHub = order.getDestinationHub();
    }
    String destinationHubColor = mapOfData.get("destinationHub_color");

    if (Objects.nonNull(routeId) && Objects.nonNull(routeIdColor)) {
      parcelSweeperLivePage.verifyRoute(routeId, routeIdColor);
    }
    if (Objects.nonNull(zoneName) && Objects.nonNull(zoneNameColor)) {
      parcelSweeperLivePage.verifyZone(getExpectedZoneName(zoneName), zoneNameColor);
    }
    if (Objects.nonNull(destinationHub) && Objects.nonNull(destinationHubColor)) {
      parcelSweeperLivePage.verifyDestinationHub(destinationHub, destinationHubColor);
    }
  }

  @Then("^Operator provides data on Parcel Sweeper Live page:$")
  public void operatorProvidesDataOnParcelSweeperLivePage(Map<String, String> mapOfData) {
    doWithRetry(() ->
    {
      try {
        final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
        String task = finalMapOfData.get("task");
        String hubName = finalMapOfData.get("hubName");
          if (hubName != null && task != null) {
            parcelSweeperLivePage.selectHubToBeginWithTask(hubName, task);
          } else if (hubName != null && task == null) {
            parcelSweeperLivePage.selectHubToBegin(hubName);
          } else if (hubName == null && task != null) {
            parcelSweeperLivePage.selectTaskToBegin(task);
          } else if (hubName == null && task == null) {
            parcelSweeperLivePage.switchTo();
          }

        String trackingId = finalMapOfData.get("trackingId");
        if (StringUtils.equalsIgnoreCase(trackingId, "CREATED")) {
          trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        }
        parcelSweeperLivePage.scanTrackingId(trackingId);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        parcelSweeperLivePage.refreshPage();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, "Operator Parcel Sweeping");
  }

  @Then("^Operator selects hub on Parcel Sweeper Live page:$")
  public void operatorSelectedHubOnParcelSweeperLivePage(Map<String, String> mapOfData) {
    doWithRetry(() ->
    {
      try {
        final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
        parcelSweeperLivePage.selectHub(finalMapOfData.get("hubName"));
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Searched element is not found, retrying after 2 seconds...");
        parcelSweeperLivePage.refreshPage();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, "Operator Parcel Sweeping, selecting hub");
  }

  private String getExpectedZoneName(String zoneNameFromDataTable) {
    if (StringUtils.equalsIgnoreCase(zoneNameFromDataTable, "FROM CREATED ORDER")) {
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
      String zoneNameExpected = f("%s (%s)", routingZone.getShortName(), routingZone.getName());
      return zoneNameExpected;
    } else {
      return zoneNameFromDataTable;
    }
  }

  @When("^Operator verifies priority level dialog box shows correct priority level info using data below:$")
  public void operatorVerifiesPriorityLevel(Map<String, String> mapOfData) {
    int expectedPriorityLevel = Integer.parseInt(mapOfData.get("priorityLevel"));
    String expectedPriorityLevelColorAsHex = mapOfData.get("priorityLevelColorAsHex");
    parcelSweeperLivePage
        .verifiesPriorityLevel(expectedPriorityLevel, expectedPriorityLevelColorAsHex);
  }

  @Then("^Operator verify RTS label on Parcel Sweeper Live page$")
  public void operatorVerifyRtsLabelOnParcelSweeperByHubPage() {
    parcelSweeperLivePage.verifyRTSInfo(true);
  }

  @Then("Operator verifies tags on Parcel Sweeper Live page")
  public void operatorVerifiesTags(List<String> expectedOrderTags) {
    parcelSweeperLivePage.verifiesTags(expectedOrderTags);
  }

  @Then("^Operator verify Prior tag on Parcel Sweeper Live page$")
  public void operatorVerifyPriorTagOnParcelSweeperByHubPage() {
    parcelSweeperLivePage.verifyPriorTag();
  }

  @Then("^Operator verify access denied modal on Parcel Sweeper Live page with the data below:$")
  public void operatorVerifyAccessDeniedModalOnParcelSweeperByHubPage(
      Map<String, String> mapOfData) {
    parcelSweeperLivePage.verifyAccessDeniedModal(mapOfData);
  }

}
