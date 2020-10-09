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
                navigateRefresh();
                pause2s();
                Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
                final String finalHub = resolveValue(hub);

                scanningPage.inboundScanning(shipmentId, label, finalHub);
            } catch (Throwable ex) {
                NvLogger.error(ex.getMessage());
                NvLogger.info("Element in Shipment inbound scanning not found, retrying...");
                throw ex;
            }
        }, 10);
    }

    @When("^Operator inbound scanning Shipment on Shipment Inbound Scanning page using data below:$")
    public void inboundScanningUsingDataBelow(Map<String, String> data) {
        data = resolveKeyValues(data);
        String label = data.get("label");
        String shipmentId = data.get("shipmentId");
        String hub = data.get("hub");

        scanningPage.inboundScanning(Long.valueOf(shipmentId), label, hub);
    }

    @When("Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page using MAWB")
    public void operatorInboundScanningShipmentIntoVanInHubHubNameOnShipmentInboundScanningPageUsingMAWB(String label, String hub) {
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
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        hub = resolveValue(hub);
        scanningPage.inboundScanningNegativeScenario(shipmentId, label, hub, condition);
    }

    @When("^Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page using MAWB with ([^\"]*) alert$")
    public void operatorInboundScanningShipmentIntoVanInHubHubNameOnShipmentInboundScanningPageUsingMAWBWithAlerts(String label, String hub, String condition) {
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
        scanningPage.clickStartInbound();

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
                scanningPage.inboundScanningWithTripReturnMovementTrip(inboundHub, inboundType, driver, movementTripSchedule);
            } catch (Throwable ex) {
                NvLogger.error(ex.getMessage());
                NvLogger.info("Element in Shipment inbound scanning not found, retrying...");
                navigateRefresh();
                pause2s();
                throw ex;
            }
        }, 10);
    }

    @Then("Operator verify start inbound button is {string}")
    public void verifyStartInboundButtonIs(String status) {
        if (status.equals("enabled")) {
            assertTrue( scanningPage.startInboundButton.isEnabled());
            return;
        }
        if (status.equals("disabled")) {
            assertFalse(scanningPage.startInboundButton.isEnabled());
        }
    }

    @Then("Operator verify small message {string} {string} in Start Inbound Box")
    public void verifySmallMessage(String message, String status) {
        if (status.equals("appears")) {
            assertEquals(message, scanningPage.tripUnselectedWarning.getText());
            return;
        }
        if (status.equals("not appears")) {
            assertFalse(scanningPage.tripUnselectedWarning.isDisplayedFast());
        }
    }

    @Then("Operator verify driver and movement trip is cleared")
    public void verifyDriverAndMovementTripIsCleared() {
        assertEquals("Driver", scanningPage.driver.getText());
        assertEquals("Movement Trip", scanningPage.movementTrip.getText());
    }

    @When("Operator click proceed in trip completion dialog")
    public void clickProceedInTripCompletionDialog() {
        scanningPage.completeTrip();
    }
}
