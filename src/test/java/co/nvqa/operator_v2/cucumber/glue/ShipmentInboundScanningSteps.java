package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.ShipmentInboundScanningPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipmentInboundScanningSteps extends AbstractSteps
{
    private ShipmentInboundScanningPage scanningPage;

    @Inject
    public ShipmentInboundScanningSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        scanningPage = new ShipmentInboundScanningPage(getWebDriver());
    }

    @When("^Operator inbound scanning Shipment ([^\"]*) in hub ([^\"]*) on Shipment Inbound Scanning page$")
    public void inboundScanning(String label, String hub)
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        scanningPage.inboundScanning(shipmentId, label, hub);
    }

    @When("^Operator change End Date on Shipment Inbound Scanning page$")
    public void clickChangeEndDateButton()
    {
        Date next2DaysDate = TestUtils.getNextDate(2);
        List<String> mustCheckId = scanningPage.grabSessionIdNotChangedScan();
        scanningPage.clickEditEndDate();
        scanningPage.inputEndDate(next2DaysDate);
        scanningPage.clickChangeDateButton();
        scanningPage.checkEndDateSessionScanChange(mustCheckId, next2DaysDate);
    }
}
