package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.ShipmentManagementPage;
import co.nvqa.operator_v2.support.CommonUtil;
import co.nvqa.operator_v2.support.ScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.List;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipmentManagementSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;

    private ShipmentManagementPage shipmentManagementPage;
    private String start = "";
    private String end = "";
    private String comment = "";

    @Inject
    public ShipmentManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        shipmentManagementPage = new ShipmentManagementPage(getDriver());
    }

    @When("^create Shipment with Start Hub ([^\"]*), End hub ([^\"]*) and comment ([^\"]*)$")
    public void createShipment(String startHub, String endHub, String comment)
    {
        String id = shipmentManagementPage.createShipment(startHub, endHub, comment);
        scenarioStorage.put(ScenarioStorage.KEY_SHIPMENT_ID, id);
    }

    @When("^edit Shipment with Start Hub ([^\"]*), End hub ([^\"]*) and comment ([^\"]*)$")
    public void editShipment(String startHub, String endHub, String comment)
    {
        shipmentManagementPage.selectStartHub(startHub);
        CommonUtil.pause10ms();
        shipmentManagementPage.selectEndHub(endHub);
        CommonUtil.pause10ms();
        CommonUtil.inputText(getDriver(), ShipmentManagementPage.XPATH_COMMENT_TEXT_AREA, comment);

        start = startHub;
        end = endHub;
        this.comment = comment;

        CommonUtil.clickBtn(getDriver(), ShipmentManagementPage.XPATH_SAVE_CHANGES_BUTTON);
        CommonUtil.pause1s();
    }

    @Given("^op click Load All Selection$")
    public void listAllShipment()
    {
        CommonUtil.clickBtn(getDriver(), ShipmentManagementPage.XPATH_LOAD_ALL_SHIPMENT_BUTTON);
        CommonUtil.pause(3000);
    }

    @When("^shipment ([^\"]*) action button clicked$")
    public void clickActionButton(String actionButton)
    {
        List<ShipmentManagementPage.Shipment> shipments =shipmentManagementPage.getShipmentsFromTable();

        for(ShipmentManagementPage.Shipment shipment : shipments)
        {
            if(shipment.getId().equals(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID)))
            {
                shipment.clickShipmentActionButton(actionButton);
                break;
            }
        }

        CommonUtil.pause(3000);
    }

    @Then("^shipment edited$")
    public void shipmentEdited()
    {
        List<ShipmentManagementPage.Shipment> shipments =shipmentManagementPage.getShipmentsFromTable();
        String startHub = "";
        String endHub = "";
        String komen = "";

        for (ShipmentManagementPage.Shipment shipment : shipments)
        {
            String spId = shipment.getId();

            if(spId.equals(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID)))
            {
                startHub = shipment.getStartHub();
                endHub = shipment.getEndHub();
                komen = shipment.getComment();
            }
        }

        Assert.assertEquals("start hub value", start, startHub);
        Assert.assertEquals("end hub value", end, endHub);
        Assert.assertEquals("comment value", comment, komen);
    }

    @Then("^shipment status is ([^\"]*)$")
    public void checkStatus(String status)
    {
        List<ShipmentManagementPage.Shipment> shipments =shipmentManagementPage.getShipmentsFromTable();
        String actualStat = "";

        for(ShipmentManagementPage.Shipment shipment : shipments)
        {
            String spId = shipment.getId();

            if(spId.equals(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID)))
            {
                actualStat = shipment.getStatus();
                break;
            }
        }

        Assert.assertEquals("Shipment " + scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID) + " status", status, actualStat);
    }

    @When("^cancel shipment button clicked$")
    public void clickCancelShipmentButton()
    {
        CommonUtil.clickBtn(getDriver(), ShipmentManagementPage.XPATH_CANCEL_SHIPMENT_BUTTON);
        List<WebElement> toasts = CommonUtil.getToasts(getDriver());
        String text = "";

        for(WebElement toast : toasts)
        {
            text = toast.getText();
            if(text.contains("Success changed status to Cancelled for Shipment ID " + scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID)))
            {
                break;
            }
        }
        Assert.assertThat("toast message not contains Cancelled", text, Matchers.containsString("Success changed status to Cancelled for Shipment ID " + scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID)));
        CommonUtil.pause(5000);
    }

    @Then("^shipment deleted$")
    public void isShipmentDeleted()
    {
        String msg = "Success delete Shipping ID " + scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID);
        WebElement toast = CommonUtil.getToast(getDriver());
        Assert.assertThat("toast message not contains " + msg, toast.getText(), Matchers.containsString(msg));

        List<ShipmentManagementPage.Shipment> shipments = shipmentManagementPage.getShipmentsFromTable();
        boolean isRemoved = true;

        for(ShipmentManagementPage.Shipment shipment : shipments)
        {
            String spId = shipment.getId();

            if(spId.equals(scenarioStorage.get(ScenarioStorage.KEY_SHIPMENT_ID)))
            {
                isRemoved = false;
            }
        }

        Assert.assertTrue("is Shipment removed", isRemoved);
    }

    @When("^filter ([^\"]*) is ([^\"]*)$")
    public void fillSearchFilter(String filter, String value)
    {
        shipmentManagementPage.clickAddFilter(filter, value);

        //CommonUtil.clickBtn(getDriver(), shipmentManagementPage.grabXPathFilter(filter));
        //CommonUtil.pause1s();
        //CommonUtil.inputText(getDriver(), shipmentManagementPage.grabXPathFilterTF(filter), value);
        //CommonUtil.pause1s();
        //CommonUtil.clickBtn(getDriver(), shipmentManagementPage.grabXPathFilterDropdown(value));

        CommonUtil.pause1s();
    }

    @Given("^op click edit filter$")
    public void op_click_edit_filter()
    {
        shipmentManagementPage.clickEditSearchFilterButton();
        CommonUtil.pause1s();
    }

    @Then("^shipment scan with source ([^\"]*) in hub ([^\"]*)$")
    public void shipment_scan_with_source_VAN_INBOUND_in_hub_JKB(String source, String hub)
    {
        try
        {
            shipmentManagementPage.shipmentScanExist(source, hub);
        }
        finally
        {
            close_scan_modal();
        }
    }

    public void close_scan_modal()
    {
        CommonUtil.clickBtn(getDriver(), ShipmentManagementPage.XPATH_CLOSE_SCAN_MODAL_BUTTON);
        CommonUtil.pause1s();
    }

    @When("^clear filter$")
    public void clear_filter()
    {
        if(getDriver().findElement(By.xpath(ShipmentManagementPage.XPATH_CLEAR_FILTER_BUTTON)).isDisplayed())
        {
            if(getDriver().findElement(By.xpath(ShipmentManagementPage.XPATH_CLEAR_FILTER_VALUE)).isDisplayed())
            {
                List<WebElement> clearValueBtnList = getDriver().findElements(By.xpath(ShipmentManagementPage.XPATH_CLEAR_FILTER_VALUE));

                for(WebElement clearBtn : clearValueBtnList)
                {
                    clearBtn.click();
                    CommonUtil.pause1s();
                }
            }

            CommonUtil.clickBtn(getDriver(), ShipmentManagementPage.XPATH_CLEAR_FILTER_BUTTON);
        }

        CommonUtil.pause(2000);
    }
}
