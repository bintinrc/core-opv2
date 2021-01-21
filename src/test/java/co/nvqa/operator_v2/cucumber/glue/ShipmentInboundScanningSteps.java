package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.ShipmentInboundScanningPage;
import co.nvqa.operator_v2.util.KeyConstants;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.junit.platform.commons.util.StringUtils;

/**
 * Modified by Daniel Joi Partogi Hutapea.
 *
 * @author Lanang Jati
 */
@ScenarioScoped
public class ShipmentInboundScanningSteps extends AbstractSteps {

  private ShipmentInboundScanningPage scanningPage;

  public ShipmentInboundScanningSteps() {
  }

  @Override
  public void init() {
    scanningPage = new ShipmentInboundScanningPage(getWebDriver());
  }

  @When("^Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page$")
  public void inboundScanning(String label, String hub) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        final String finalHub = resolveValue(hub);

        scanningPage.inboundScanning(shipmentId, label, finalHub);
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        NvLogger.info("Element in Shipment inbound scanning not found, retrying...");
        scanningPage.refreshPage();
        throw ex;
      }
    }, 5);
  }
//
//  @When("Operator input hub data on Shipment Inbound Scanning page using data below:")
//  public void inputHubDataOnShipmentInboundScanningPageUsingDataBelow(Map<String, String> data) {
//    retryIfRuntimeExceptionOccurred(() ->
//    {
//      try {
//        Map<String, String> resolvedData = resolveKeyValues(data);
//        String label = resolvedData.get("label");
//        String hub = resolvedData.get("hub");
//
//        scanningPage.inboundHub.searchAndSelectValue(hub);
//        scanningPage.click(scanningPage.grabXpathButton(label));
//        scanningPage.startInboundButton.click();
//      } catch (Throwable ex) {
//        NvLogger.error(ex.getMessage());
//        NvLogger.info("Hub in Shipment inbound scanning not found, retrying...");
//        scanningPage.refreshPage();
//        throw ex;
//      }
//    }, 5);
//  }
//
//  @When("Operator scan created shipment and in Shipment Inbound Scanning page")
//  public void operatorScanCreatedShipmentInShipmentInboundScanningPage() {
//    Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
//    String shipmentIdAsString = String.valueOf(shipmentId);
//    scanningPage.fillShipmentId(shipmentId);
//    if (StringUtils.isNotBlank(shipmentIdAsString)) {
//      scanningPage.checkSessionScan(shipmentIdAsString);
//    }
//  }

  @When("^Operator inbound scanning Shipment on Shipment Inbound Scanning page using data below:$")
  public void inboundScanningUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);
    String label = data.get("label");
    String shipmentId = data.get("shipmentId");
    String hub = data.get("hub");
    String mawb = data.get("mawb");

    scanningPage.inboundHub.searchAndSelectValue(hub);
    scanningPage.click(scanningPage.grabXpathButton(label));
    scanningPage.startInboundButton.click();
    scanningPage.fillShipmentId(StringUtils.isNotBlank(mawb) ? mawb : shipmentId);
    if (StringUtils.isNotBlank(shipmentId)) {
      scanningPage.checkSessionScan(shipmentId);
    }
  }

  @When("^Operator check alert message on Shipment Inbound Scanning page using data below:$")
  public void checkAlertOnShipmentInboundScanningPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    String alert = data.get("alert");

    scanningPage.scanAlertMessage.waitUntilVisible();
    assertEquals("Inbound Scan Alert Message", alert, scanningPage.scanAlertMessage.getText());
  }

  @When("Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page using MAWB")
  public void operatorInboundScanningShipmentIntoVanInHubHubNameOnShipmentInboundScanningPageUsingMAWB(
      String label, String hub) {
    Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
    String mawb = get(KeyConstants.KEY_MAWB);
    hub = resolveValue(hub);

    if ("orderDestHubName".equalsIgnoreCase(hub)) {
      Order order = get(KEY_CREATED_ORDER);
      hub = order.getDestinationHub();
    }

    scanningPage.inboundScanningUsingMawb(shipmentId, mawb, label, hub);
  }

  @When("^Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page with ([^\"]*) alert$")
  public void inboundScanningNegativeScenario(String label, String hub, String condition) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        final String resolvedHub = resolveValue(hub);
        scanningPage.inboundScanningNegativeScenario(shipmentId, label, resolvedHub, condition);
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        scanningPage.refreshPage();
        throw ex;
      }
    }, 10);

  }

  @When("^Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page using MAWB with ([^\"]*) alert$")
  public void operatorInboundScanningShipmentIntoVanInHubHubNameOnShipmentInboundScanningPageUsingMAWBWithAlerts(
      String label, String hub, String condition) {
    Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
    String mawb = get(KeyConstants.KEY_MAWB);

    if ("orderDestHubName".equalsIgnoreCase(hub)) {
      Order order = get(KEY_CREATED_ORDER);
      hub = order.getDestinationHub();
    }

    scanningPage.inboundScanningUsingMawbWithAlerts(shipmentId, mawb, label, hub, condition);
  }

  @When("^Operator change End Date on Shipment Inbound Scanning page$")
  public void clickChangeEndDateButton() {
    Date next2DaysDate = TestUtils.getNextWorkingDay();
    List<String> mustCheckId = scanningPage.grabSessionIdNotChangedScan();
    scanningPage.clickEditEndDate();
    scanningPage.inputEndDate(next2DaysDate);
    scanningPage.clickChangeDateButton();
    scanningPage.checkEndDateSessionScanChange(mustCheckId, next2DaysDate);
  }

  @When("Operator click start inbound")
  public void clickStartInbound() {
    scanningPage.startInboundButton.waitUntilClickable();
    scanningPage.startInboundButton.click();
  }

  @When("Operator fill Shipment Inbound Scanning page with data below:")
  public void fillInboundScanningIntoVanValuesDataBelow(Map<String, String> data) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        final Map<String, String> finalData = resolveKeyValues(data);
        String inboundHub = finalData.get("inboundHub");
        String inboundType = finalData.get("inboundType");
        String driver = finalData.get("driver");
        String movementTripSchedule = finalData.get("movementTripSchedule");
        scanningPage.inboundScanningWithTripReturnMovementTrip(inboundHub, inboundType, driver,
            movementTripSchedule);
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        NvLogger.info("Element in Shipment inbound scanning not found, retrying...");
        scanningPage.refreshPage();
        throw ex;
      }
    }, getCurrentMethodName(), 5000, 10);
  }

  @Then("Operator verify start inbound button is {string}")
  public void verifyStartInboundButtonIs(String status) {
    if ("enabled".equals(status)) {
      assertThat("Inbound button enabled", scanningPage.startInboundButton.isEnabled(),
          equalTo(true));
      return;
    }
    if ("disabled".equals(status)) {
      assertThat("Inbound button disabled", scanningPage.startInboundButton.isEnabled(),
          equalTo(false));
    }
  }

  @Then("Operator verify small message {string} {string} in Start Inbound Box")
  public void verifySmallMessage(String message, String status) {
    if ("appears".equals(status)) {
      assertThat("Small message is equal", scanningPage.tripUnselectedWarning.getText(),
          equalTo(message));
      return;
    }
    if ("not appears".equals(status)) {
      assertThat("Small message is not shown", scanningPage.tripUnselectedWarning.isDisplayedFast(),
          equalTo(false));
    }
  }

  @Then("Operator verify driver and movement trip is cleared")
  public void verifyDriverAndMovementTripIsCleared() {
    assertThat("Driver place holder is equal", scanningPage.driver.getText(), equalTo("Driver"));
    assertThat("Movement trip place holder is equal", scanningPage.movementTrip.getText(),
        equalTo("Movement Trip"));
  }

  @When("Operator click proceed in trip completion dialog")
  public void clickProceedInTripCompletionDialog() {
    scanningPage.completeTrip();
  }

  @Then("Operator verify hub {string} not found on Shipment Inbound Scanning page")
  public void operatorVerifyHubNotFoundOnShipmentInboundScanningPage(String hubName) {
    String hubNameResolved = resolveValue(hubName);
    scanningPage.inboundHub.searchValue(hubNameResolved);
    assertThat("value does not exist", scanningPage.inboundHub.isValueExist(hubNameResolved),
        equalTo(false));
  }
}
