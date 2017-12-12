package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.ShipmentManagementPage;
import co.nvqa.operator_v2.util.TestUtils;
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
    private ShipmentManagementPage shipmentManagementPage;
    private String start = "";
    private String end = "";
    private String comment = "";

    @Inject
    public ShipmentManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        shipmentManagementPage = new ShipmentManagementPage(getWebDriver());
    }

    @When("^create Shipment with Start Hub ([^\"]*), End hub ([^\"]*) and comment ([^\"]*)$")
    public void createShipment(String startHub, String endHub, String comment)
    {
        String id = shipmentManagementPage.createShipment(startHub, endHub, comment);
        put(KEY_SHIPMENT_ID, id);
    }

    @When("^edit Shipment with Start Hub ([^\"]*), End hub ([^\"]*) and comment ([^\"]*)$")
    public void editShipment(String startHub, String endHub, String newComment)
    {
        shipmentManagementPage.selectStartHub(startHub);
        pause200ms();
        shipmentManagementPage.selectEndHub(endHub);
        pause200ms();
        shipmentManagementPage.fillFieldComments(newComment);
        pause200ms();
        shipmentManagementPage.clickButtonSaveChangesOnEditShipmentDialog();
        pause200ms();

        start = startHub;
        end = endHub;
        comment = newComment;
    }

    @Given("^op click Load All Selection$")
    public void listAllShipment()
    {
        shipmentManagementPage.clickButtonLoadSelection();
    }

    @When("^shipment ([^\"]*) action button clicked$")
    public void clickActionButton(String actionButton)
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        List<ShipmentManagementPage.Shipment> shipments = shipmentManagementPage.getShipmentsFromTable();

        for(ShipmentManagementPage.Shipment shipment : shipments)
        {
            if(shipment.getId().equals(shipmentId))
            {
                shipment.clickShipmentActionButton(actionButton);
                break;
            }
        }

        pause3s();
    }

    @Then("^shipment edited$")
    public void shipmentEdited()
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        List<ShipmentManagementPage.Shipment> shipments = shipmentManagementPage.getShipmentsFromTable();
        String startHub = "";
        String endHub = "";
        String komen = "";

        for (ShipmentManagementPage.Shipment shipment : shipments)
        {
            String spId = shipment.getId();

            if(spId.equals(shipmentId))
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
        String shipmentId = get(KEY_SHIPMENT_ID);
        List<ShipmentManagementPage.Shipment> shipments = shipmentManagementPage.getShipmentsFromTable();
        String actualStat = "";

        for(ShipmentManagementPage.Shipment shipment : shipments)
        {
            String spId = shipment.getId();

            if(spId.equals(shipmentId))
            {
                actualStat = shipment.getStatus();
                break;
            }
        }

        Assert.assertEquals("Shipment " + shipmentId + " status", status, actualStat);
    }

    @When("^cancel shipment button clicked$")
    public void clickCancelShipmentButton()
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        TestUtils.clickBtn(getWebDriver(), ShipmentManagementPage.XPATH_CANCEL_SHIPMENT_BUTTON);
        List<WebElement> toasts = TestUtils.getToasts(getWebDriver());
        String text = "";

        for(WebElement toast : toasts)
        {
            text = toast.getText();
            if(text.contains("Success changed status to Cancelled for Shipment ID " + shipmentId))
            {
                break;
            }
        }

        Assert.assertThat("Toast message not contains Cancelled", text, Matchers.containsString("Success changed status to Cancelled for Shipment ID " + shipmentId));
        pause5s();
    }

    @Then("^shipment deleted$")
    public void isShipmentDeleted()
    {
        String shipmentId = get(KEY_SHIPMENT_ID);
        String msg = "Success delete Shipping ID " + shipmentId;
        WebElement toast = TestUtils.getToast(getWebDriver());
        Assert.assertThat("toast message not contains " + msg, toast.getText(), Matchers.containsString(msg));

        List<ShipmentManagementPage.Shipment> shipments = shipmentManagementPage.getShipmentsFromTable();
        boolean isRemoved = true;

        for(ShipmentManagementPage.Shipment shipment : shipments)
        {
            String spId = shipment.getId();

            if(spId.equals(shipmentId))
            {
                isRemoved = false;
            }
        }

        Assert.assertTrue("Shipment is not removed.", isRemoved);
    }

    @When("^filter ([^\"]*) is ([^\"]*)$")
    public void fillSearchFilter(String filter, String value)
    {
        shipmentManagementPage.clickAddFilter(filter, value);

        //TestUtils.clickBtn(getDriver(), shipmentManagementPage.grabXPathFilter(filter));
        //pause1s();
        //TestUtils.inputText(getDriver(), shipmentManagementPage.grabXPathFilterTF(filter), value);
        //pause1s();
        //TestUtils.clickBtn(getDriver(), shipmentManagementPage.grabXPathFilterDropdown(value));

        pause1s();
    }

    @Given("^op click edit filter$")
    public void op_click_edit_filter()
    {
        shipmentManagementPage.clickEditSearchFilterButton();
        pause1s();
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
            closeScanModal();
        }
    }

    private void closeScanModal()
    {
        TestUtils.clickBtn(getWebDriver(), ShipmentManagementPage.XPATH_CLOSE_SCAN_MODAL_BUTTON);
        pause1s();
    }

    @When("^clear filter$")
    public void clearFilter()
    {
        if(getWebDriver().findElement(By.xpath(ShipmentManagementPage.XPATH_CLEAR_FILTER_BUTTON)).isDisplayed())
        {
            if(getWebDriver().findElement(By.xpath(ShipmentManagementPage.XPATH_CLEAR_FILTER_VALUE)).isDisplayed())
            {
                List<WebElement> clearValueBtnList = getWebDriver().findElements(By.xpath(ShipmentManagementPage.XPATH_CLEAR_FILTER_VALUE));

                for(WebElement clearBtn : clearValueBtnList)
                {
                    clearBtn.click();
                    pause1s();
                }
            }

            TestUtils.clickBtn(getWebDriver(), ShipmentManagementPage.XPATH_CLEAR_FILTER_BUTTON);
        }

        pause2s();
    }
}
