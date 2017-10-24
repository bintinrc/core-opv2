package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.ShipmentInboundScanningPage;
import com.nv.qa.selenium.page.ShipmentManagementPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
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
    public ShipmentInboundScanningSteps(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        shipmentManagementPage = new ShipmentManagementPage(getDriver());
        scanningPage = new ShipmentInboundScanningPage(getDriver());
    }

    @When("^inbound scanning shipment ([^\"]*) in hub ([^\"]*)$")
    public void inboundScanning(String label, String hub) throws Throwable
    {
        scanningPage.selectHub(hub);
        CommonUtil.clickBtn(getDriver(), scanningPage.grabXpathButton(label));
        CommonUtil.clickBtn(getDriver(), scanningPage.grabXpathButton("Start Inbound"));

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
