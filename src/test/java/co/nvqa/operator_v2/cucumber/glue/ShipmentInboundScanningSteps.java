package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.ShipmentInboundScanningPage;
import co.nvqa.operator_v2.selenium.page.ShipmentManagementPage;
import co.nvqa.operator_v2.util.TestUtils;
import co.nvqa.operator_v2.util.ScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.text.SimpleDateFormat;
import java.util.Calendar;
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
    private static final SimpleDateFormat DATE_FORMATTER = new SimpleDateFormat("yyyy-MM-dd");
    @Inject private ScenarioStorage scenarioStorage;

    private ShipmentManagementPage shipmentManagementPage;
    private ShipmentInboundScanningPage scanningPage;

    @Inject
    public ShipmentInboundScanningSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        shipmentManagementPage = new ShipmentManagementPage(getWebDriver());
        scanningPage = new ShipmentInboundScanningPage(getWebDriver());
    }

    @When("^inbound scanning shipment ([^\"]*) in hub ([^\"]*)$")
    public void inboundScanning(String label, String hub) throws Throwable
    {
        scanningPage.selectHub(hub);
        TestUtils.clickBtn(getWebDriver(), scanningPage.grabXpathButton(label));
        TestUtils.clickBtn(getWebDriver(), scanningPage.grabXpathButton("Start Inbound"));

        scanningPage.inputShipmentToInbound(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID));
        scanningPage.checkSessionScan(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID));
    }

    @Then("^inbounded shipment exist$")
    public void inbounded_shipment_exist() throws Throwable
    {
        List<ShipmentManagementPage.Shipment> shipmentList = shipmentManagementPage.getShipmentsFromTable();
        boolean isExist = false;

        for(ShipmentManagementPage.Shipment shipment : shipmentList)
        {
            if(shipment.getId().equalsIgnoreCase(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID)))
            {
                isExist = true;
                break;
            }
        }

        Assert.assertTrue("shipment(" + scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID) + ") not exist", isExist);
    }

    @When("^change end date$")
    public void click_change_end_date_button()
    {
        Calendar now = Calendar.getInstance();
        now.add(Calendar.DATE, 2);
        List<String> mustCheckId = scanningPage.grabSessionIdNotChangedScan();
        scanningPage.clickEditEndDate();
        String today = DATE_FORMATTER.format(now.getTime());
        scanningPage.inputEndDate(today);
        scanningPage.clickChangeDateButton();
        scanningPage.checkEndDateSessionScanChange(mustCheckId, today);
    }
}
