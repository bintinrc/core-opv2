package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.List;

import static co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable.*;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipmentManagementPage extends OperatorV2SimplePage
{
    public static final String LOCATOR_CREATE_SHIPMENT_BUTTON = "Create Shipment";
    public static final String LOCATOR_FIELD_SELECT_TYPE = "select-type";
    public static final String LOCATOR_FIELD_START_HUB = "start-hub";
    public static final String LOCATOR_FIELD_END_HUB = "end-hub";
    public static final String LOCATOR_CREATE_SHIPMENT_CONFIRMATION_BUTTON = "Create";
    public static final String LOCATOR_COMMENT_TEXT_AREA = "container.shipment-management.comments-optional";
    public static final String XPATH_EDIT_SEARCH_FILTER_BUTTON = "//button[contains(@aria-label, 'Edit Filter')]";
    public static final String XPATH_FORCE_SUCCESS_CONFIRMATION_BUTTON = "//button[span[text()='Confirm']]";
    public static final String XPATH_SHIPMENT_SCAN = "//div[contains(@class,'table-shipment-scan-container')]/table/tbody/tr";
    public static final String XPATH_CLOSE_SCAN_MODAL_BUTTON = "//button[@aria-label='Cancel']";
    public static final String XPATH_CLEAR_FILTER_BUTTON = "//button[@aria-label='Clear All Selections']";
    public static final String XPATH_CLEAR_FILTER_VALUE = "//button[@aria-label='Clear All']";
    private ShipmentsTable shipmentsTable;

    public ShipmentManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        shipmentsTable = new ShipmentsTable(webDriver);
    }

    public void clickEditSearchFilterButton()
    {
        click(XPATH_EDIT_SEARCH_FILTER_BUTTON);
        pause1s();
    }

    public void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }

    public void clickButtonSaveChangesOnEditShipmentDialog(String shipmentId)
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("Save Changes");
        pause1s();
        waitUntilInvisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Shipment %s updated']", shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

    public void selectStartHub(String hubName)
    {
        selectValueFromMdSelectById(LOCATOR_FIELD_START_HUB, hubName);
        pause200ms();
    }

    public void selectEndHub(String hubName)
    {
        selectValueFromMdSelectById(LOCATOR_FIELD_END_HUB, hubName);
        pause200ms();
    }

    public void fillFieldComments(String comments)
    {
        sendKeysById(LOCATOR_COMMENT_TEXT_AREA, comments);
        pause200ms();
    }

    public void clickAddFilter(String filterLabel, String value)
    {
        click("//input[@placeholder='Select Filter']");
        click(grabXPathFilterDropdown(filterLabel));
        TestUtils.hoverMouseTo(getWebDriver(), "//md-virtual-repeat-container[@aria-hidden='false']/div/div/ul/li/md-autocomplete-parent-scope/span");
        click("//h4[text()='Select Search Filters']");

        sendKeys(String.format("//nv-autocomplete[@item-types='%s']//input[@aria-label='Search or Select...']", filterLabel), value);
        clickf("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", value);
        TestUtils.hoverMouseTo(getWebDriver(), "//md-virtual-repeat-container[@aria-hidden='false']/div/div/ul/li/md-autocomplete-parent-scope/span");
        click("//h4[text()='Select Search Filters']");

        pause1s();
    }

    public String grabXPathFilterDropdown(String value)
    {
        return "//md-virtual-repeat-container[@aria-hidden='false']/div/div/ul/li/md-autocomplete-parent-scope/span[text()='" + value + "']";
    }

    public void shipmentScanExist(String source, String hub)
    {
        String xpath = XPATH_SHIPMENT_SCAN + "[td[text()='" + source + "']]" + "[td[text()='" + hub + "']]";
        WebElement scan = findElementByXpath(xpath);
        Assert.assertEquals("shipment(" + source + ") not exist", "tr", scan.getTagName());
    }

    public void createShipment(ShipmentInfo shipmentInfo)
    {
        clickNvIconTextButtonByName(LOCATOR_CREATE_SHIPMENT_BUTTON);

        selectByIndexFromMdSelectById(LOCATOR_FIELD_SELECT_TYPE, 1);
        pause200ms();

        selectStartHub(shipmentInfo.getOrigHubName());
        selectEndHub(shipmentInfo.getDestHubName());
        fillFieldComments(shipmentInfo.getComments());

        clickNvApiTextButtonByNameAndWaitUntilDone(LOCATOR_CREATE_SHIPMENT_CONFIRMATION_BUTTON);

        String toastMessage = getToastTopText();
        Assert.assertThat("Toast message not contains Shipment <SHIPMENT_ID> created", toastMessage, Matchers.allOf(Matchers.containsString("Shipment"), Matchers.containsString("created")));
        String shipmentId = toastMessage.split(" ")[1];
        confirmToast(toastMessage, false);
        shipmentInfo.setId(shipmentId);
    }

    public void editShipment(ShipmentInfo shipmentInfo)
    {
        clickActionButton(shipmentInfo.getId(), ACTION_EDIT);

        selectStartHub(shipmentInfo.getOrigHubName());
        selectEndHub(shipmentInfo.getDestHubName());
        fillFieldComments(shipmentInfo.getComments());

        clickButtonSaveChangesOnEditShipmentDialog(shipmentInfo.getId());
    }

    public void clickActionButton(String shipmentId, String actionButton)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, shipmentId);
        shipmentsTable.clickActionButton(1, actionButton);
        pause200ms();
    }

    public void forceSuccessShipment(String shipmentId)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, shipmentId);
        shipmentsTable.clickActionButton(1, ACTION_FORCE);
        click(XPATH_FORCE_SUCCESS_CONFIRMATION_BUTTON);
        pause200ms();
    }

    public void cancelShipment(String shipmentId)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, shipmentId);
        shipmentsTable.clickActionButton(1, ACTION_CANCEL);
        clickButtonByAriaLabel("Cancel Shipment");
        pause200ms();
    }

    public void validateShipmentInfo(String shipmentId, ShipmentInfo expectedShipmentInfo)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, shipmentId);
        ShipmentInfo actualShipmentInfo = shipmentsTable.readEntity(1);
        expectedShipmentInfo.compareWithActual(actualShipmentInfo);
    }

    public void waitUntilForceToastDisappear(String shipmentId)
    {
        waitUntilInvisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Success changed status to Force Success for Shipment ID %s']", shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

    public void verifyInboundedShipmentExist(String shipmentId)
    {
        TestUtils.retryIfAssertionErrorOccurred(() ->
        {
            try
            {
                List<ShipmentInfo> shipmentList = shipmentsTable.readAllEntities();
                shipmentList.stream()
                        .filter(shipment -> shipment.getId().equalsIgnoreCase(shipmentId))
                        .findFirst()
                        .orElseThrow(() -> new AssertionError(String.format("Shipment with ID = '%s' not exist", shipmentId)));
            } catch (AssertionError ex)
            {
                clickEditSearchFilterButton();
                clickButtonLoadSelection();
                throw ex;
            }
        }, getCurrentMethodName());
    }

    public void clearAllFilters()
    {
        if (findElementByXpath(XPATH_CLEAR_FILTER_BUTTON).isDisplayed())
        {
            if (findElementByXpath(XPATH_CLEAR_FILTER_VALUE).isDisplayed())
            {
                List<WebElement> clearValueBtnList = findElementsByXpath(XPATH_CLEAR_FILTER_VALUE);

                for (WebElement clearBtn : clearValueBtnList)
                {
                    clearBtn.click();
                    pause1s();
                }
            }

            click(XPATH_CLEAR_FILTER_BUTTON);
        }

        pause2s();
    }

    public void closeScanModal()
    {
        click(XPATH_CLOSE_SCAN_MODAL_BUTTON);
        pause1s();
    }

    /**
     * Accessor for Shipments table
     */
    public static class ShipmentsTable extends MdVirtualRepeatTable<ShipmentInfo>
    {
        public static final String MD_VIRTUAL_REPEAT = "shipment in getTableData()";
        public static final String COLUMN_SHIPMENT_TYPE = "shipmentType";
        public static final String COLUMN_SHIPMENT_ID = "id";
        public static final String COLUMN_CREATION_DATE_TIME = "createdAt";
        public static final String COLUMN_TRANSIT_DATE_TIME = "transitAt";
        public static final String COLUMN_STATUS = "status";
        public static final String COLUMN_START_HUB = "origHubName";
        public static final String COLUMN_LAST_INBOUND_HUB = "currHubName";
        public static final String COLUMN_END_HUB = "destHubName";
        public static final String COLUMN_ETA_DATE_TIME = "arrivalDatetime";
        public static final String COLUMN_COMPLETION_DATE_TIME = "completedAt";
        public static final String COLUMN_TOTAL_PARCELS = "ordersCount";
        public static final String COLUMN_COMMENTS = "comments";
        public static final String COLUMN_MAWB = "mawb";
        public static final String ACTION_EDIT = "Edit";
        public static final String ACTION_DETAILS = "Details";
        public static final String ACTION_FORCE = "Force";
        public static final String ACTION_PRINT = "Print";
        public static final String ACTION_CANCEL = "Cancel";

        public ShipmentsTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_SHIPMENT_TYPE, "shipment_type")
                    .put(COLUMN_SHIPMENT_ID, "id")
                    .put(COLUMN_CREATION_DATE_TIME, "created_at")
                    .put(COLUMN_TRANSIT_DATE_TIME, "transit_at")
                    .put(COLUMN_STATUS, "status")
                    .put(COLUMN_START_HUB, "orig_hub_name")
                    .put(COLUMN_LAST_INBOUND_HUB, "curr_hub_name")
                    .put(COLUMN_END_HUB, "dest_hub_name")
                    .put(COLUMN_ETA_DATE_TIME, "arrival_datetime")
                    .put(COLUMN_COMPLETION_DATE_TIME, "completed_at")
                    .put(COLUMN_TOTAL_PARCELS, "orders_count")
                    .put(COLUMN_COMMENTS, "comments")
                    .put(COLUMN_MAWB, "mawb")
                    .build()
            );
            setEntityClass(ShipmentInfo.class);
            setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
            setActionButtonsLocators(ImmutableMap.of(
                    ACTION_EDIT, "Edit",
                    ACTION_DETAILS, "Details",
                    ACTION_FORCE, "Force",
                    ACTION_PRINT, "Print",
                    ACTION_CANCEL, "Cancel")
            );
        }
    }
}
