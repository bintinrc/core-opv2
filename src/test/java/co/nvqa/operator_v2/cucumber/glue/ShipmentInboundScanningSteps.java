package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.ShipmentInboundScanningPage;
import co.nvqa.operator_v2.util.KeyConstants;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Date;
import java.util.List;

/**
 * Modified by Daniel Joi Partogi Hutapea.
 *
 * @author Lanang Jati
 */
@ScenarioScoped
public class ShipmentInboundScanningSteps extends AbstractSteps
{
    private ShipmentInboundScanningPage scanningPage;

    public ShipmentInboundScanningSteps()
    {
    }

    @Override
    public void init()
    {
        scanningPage = new ShipmentInboundScanningPage(getWebDriver());
    }

    @When("^Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page$")
    public void inboundScanning(String label, String hub)
    {
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        hub = resolveValue(hub);
        scanningPage.inboundScanning(shipmentId, label, hub);
    }

    @When("Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page using MAWB")
    public void operatorInboundScanningShipmentIntoVanInHubHubNameOnShipmentInboundScanningPageUsingMAWB(String label, String hub)
    {
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        String mawb = get(KeyConstants.KEY_MAWB);

        if ("orderDestHubName".equalsIgnoreCase(hub))
        {
            Order order = get(KEY_CREATED_ORDER);
            hub = order.getDestinationHub();
        }

        scanningPage.inboundScanningUsingMawb(shipmentId, mawb, label, hub);
    }

    @When("^Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page with ([^\"]*) alert$")
    public void inboundScanningNegativeScenario(String label, String hub, String condition)
    {
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        hub = resolveValue(hub);
        scanningPage.inboundScanningNegativeScenario(shipmentId, label, hub, condition);
    }

    @When("^Operator change End Date on Shipment Inbound Scanning page$")
    public void clickChangeEndDateButton()
    {
        Date next2DaysDate = TestUtils.getNextWorkingDay();
        List<String> mustCheckId = scanningPage.grabSessionIdNotChangedScan();
        scanningPage.clickEditEndDate();
        scanningPage.inputEndDate(next2DaysDate);
        scanningPage.clickChangeDateButton();
        scanningPage.checkEndDateSessionScanChange(mustCheckId, next2DaysDate);
    }
}
