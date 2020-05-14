package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.pdf.ShipmentAirwayBill;
import co.nvqa.commons.util.PdfUtils;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.MovementEvent;
import co.nvqa.operator_v2.model.ShipmentEvent;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable.*;
import static org.hamcrest.Matchers.allOf;
import static org.hamcrest.Matchers.contains;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipmentManagementPage extends OperatorV2SimplePage
{
    public static final String LOCATOR_CREATE_SHIPMENT_CONFIRMATION_BUTTON = "Create";
    public static final String LOCATOR_SELCT_FILTERS_PRESET = "commons.preset.load-filter-preset";
    public static final String SHIPMENT_STATUS_DROPDOWN_XPATH = "//md-autocomplete[md-autocomplete-wrap[input[contains(@id,'input') and contains(@aria-label,'Search or Select')]]]/following-sibling::md-icon[i[text()='arrow_drop_down']]";
    public static final String TRANSIT_SELECTION_XPATH = "//span[text()='Transit']/ancestor::li";

    public static final String XPATH_EDIT_SEARCH_FILTER_BUTTON = "//button[contains(@aria-label, 'Edit Filter')]";
    public static final String XPATH_FORCE_SUCCESS_CONFIRMATION_BUTTON = "//button[span[text()='Confirm']]";
    public static final String XPATH_SHIPMENT_SCAN = "//div[contains(@class,'table-shipment-scan-container')]/table/tbody/tr";
    public static final String XPATH_CLOSE_SCAN_MODAL_BUTTON = "//button[@aria-label='Cancel']";
    public static final String XPATH_CLEAR_FILTER_BUTTON = "//button[@aria-label='Clear All Selections']";
    public static final String XPATH_CLEAR_FILTER_VALUE = "//button[@aria-label='Clear All']";
    public ShipmentsTable shipmentsTable;
    public ShipmentEventsTable shipmentEventsTable;
    public MovementEventsTable movementEventsTable;

    @FindBy(name = "Create Shipment")
    public NvIconTextButton createShipment;

    @FindBy(id = "shipment-ids")
    public TextBox shipmentIds;

    @FindBy(name = "container.shipment-management.search-by-shipment-ids")
    public NvApiTextButton searchByShipmentIds;

    @FindBy(css = "md-dialog")
    public CreateShipmentDialog createShipmentDialog;

    @FindBy(css = "md-dialog")
    public EditShipmentDialog editShipmentDialog;

    private static final String FILEPATH = TestConstants.TEMP_DIR;

    public ShipmentManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        shipmentsTable = new ShipmentsTable(webDriver);
        shipmentEventsTable = new ShipmentEventsTable(webDriver);
        movementEventsTable = new MovementEventsTable(webDriver);
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

    public void switchToOtherWindow()
    {
        waitUntilNewWindowOrTabOpened();
        Set<String> windowHandles = getWebDriver().getWindowHandles();

        for (String windowHandle : windowHandles)
        {
            getWebDriver().switchTo().window(windowHandle);
        }
    }

    public void searchByShipmentIds(List<Long> shipmentIds)
    {
        this.shipmentIds.setValue(StringUtils.join(shipmentIds, "\n"));
        searchByShipmentIds.clickAndWaitUntilDone();
    }

    public void addFilter(String filterLabel, String value, boolean isMawb)
    {
        selectValueFromNvAutocompleteByItemTypesAndDismiss("filters", filterLabel);
        if (!isMawb)
        {
            selectValueFromNvAutocompleteByItemTypesAndDismiss(filterLabel, value);
        } else
        {
            sendKeys("//input[@ng-model='search' and contains(@id,'input')]", value);
        }
        pause1s();
    }

    public void transitStatus()
    {
        selectValueFromNvAutocompleteByItemTypesAndDismiss("filters", "Shipment Status");
        click(SHIPMENT_STATUS_DROPDOWN_XPATH);
        pause1s();
        click(TRANSIT_SELECTION_XPATH);
        pause1s();
    }

    public void changeDate(String date, boolean isToday)
    {
        String datepickerXpath = "//md-datepicker[@name='%s']//input";
        if (isToday)
        {
            sendKeys(f(datepickerXpath, "fromDateField"), date);
        } else
        {
            sendKeys(f(datepickerXpath, "toDateField"), date);
        }
    }

    public long saveFiltersAsPreset(String presetName)
    {
        clickButtonByAriaLabel("Action");
        clickButtonByAriaLabel("Save Current as Preset");
        waitUntilVisibilityOfMdDialogByTitle("Save Preset");
        sendKeysById("preset-name", presetName);
        clickNvIconTextButtonByName("commons.save");
        waitUntilVisibilityOfToast("1 filter preset created");
        String presetId = getMdSelectValueById("commons.preset.load-filter-preset");
        Pattern p = Pattern.compile("(\\d+)(-)(.+)");
        Matcher m = p.matcher(presetId);
        if (m.matches())
        {
            presetId = m.group(1);
            assertThat("created preset is selected", m.group(3), equalTo(presetName));
        }
        return Long.parseLong(presetId);
    }

    public void deleteFiltersPreset(String presetName)
    {
        clickButtonByAriaLabel("Action");
        clickButtonByAriaLabel("Delete Preset");
        waitUntilVisibilityOfMdDialogByTitle("Delete Preset");
        selectValueFromMdSelectById("select-preset", presetName);
        clickNvIconTextButtonByName("commons.delete");
        waitUntilVisibilityOfToast("1 filter preset deleted");
    }

    public void verifyFiltersPresetWasDeleted(String presetName)
    {
        assertThat("Preset [" + presetName + "] exists in presets list", getMdSelectMultipleValuesById(LOCATOR_SELCT_FILTERS_PRESET), not(contains(presetName)));
    }

    public void selectFiltersPreset(String presetName)
    {
        selectValueFromMdSelectById(LOCATOR_SELCT_FILTERS_PRESET, presetName);
    }

    public void verifySelectedFilters(Map<String, String> filters)
    {
        filters.forEach((filter, expectedValue) ->
        {
            String actualValue = getAttribute("aria-label", "//nv-filter-box[@item-types='%s']//nv-icon-text-button[@ng-repeat]", filter);
            assertThat(filter + " filter selected value", actualValue, equalTo(expectedValue));
        });
    }

    public void shipmentScanExist(String source, String hub)
    {
        String xpath = XPATH_SHIPMENT_SCAN + "[td[text()='" + source + "']]" + "[td[text()='" + hub + "']]";
        WebElement scan = findElementByXpath(xpath);
        assertEquals("shipment(" + source + ") not exist", "tr", scan.getTagName());
    }

    public void createShipment(ShipmentInfo shipmentInfo, boolean isNextOrder)
    {
        createShipment.click();
        createShipmentDialog.waitUntilVisible();
        createShipmentDialog.type.selectValue("Air Haul");
        createShipmentDialog.startHub.searchAndSelectValue(shipmentInfo.getOrigHubName());
        createShipmentDialog.endHub.searchAndSelectValue(shipmentInfo.getDestHubName());
        createShipmentDialog.comments.setValue(shipmentInfo.getComments());

        if (isNextOrder)
        {
            createShipmentDialog.createAnother.click();
        } else
        {
            createShipmentDialog.create.click();
        }

        String toastMessage = getToastTopText();
        assertThat("Toast message not contains Shipment <SHIPMENT_ID> created", toastMessage, allOf(containsString("Shipment"), containsString("created")));
        long shipmentId = Long.parseLong(toastMessage.split(" ")[1]);
        confirmToast(toastMessage, false);
        shipmentInfo.setId(shipmentId);
    }

    public Long createAnotherShipment()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone(LOCATOR_CREATE_SHIPMENT_CONFIRMATION_BUTTON);
        String toastMessage = getToastTopText();
        assertThat("Toast message not contains Shipment <SHIPMENT_ID> created", toastMessage, allOf(containsString("Shipment"), containsString("created")));
        long shipmentId = Long.parseLong(toastMessage.split(" ")[1]);
        confirmToast(toastMessage, false);

        return shipmentId;
    }

    public void editShipment(ShipmentInfo shipmentInfo)
    {
        clickActionButton(shipmentInfo.getId(), ACTION_EDIT);

        editShipmentDialog.waitUntilVisible();
        editShipmentDialog.startHub.searchAndSelectValue(shipmentInfo.getOrigHubName());
        editShipmentDialog.endHub.searchAndSelectValue(shipmentInfo.getDestHubName());
        editShipmentDialog.comments.setValue(shipmentInfo.getComments());

        if (StringUtils.isBlank(shipmentInfo.getMawb()))
        {
            editShipmentDialog.saveChanges(shipmentInfo.getId());
        } else
        {
            editShipmentDialog.mawb.setValue(shipmentInfo.getMawb());
            editShipmentDialog.saveChangesWithMawb(shipmentInfo.getId());
        }
    }

    public void editCancelledShipment()
    {
        shipmentsTable.clickActionButton(1, ACTION_EDIT);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'shipment-edit')]");
        isElementExist("//textarea[@ng-readonly='readOnly']");
        click("//button[@aria-label='OK']");
    }

    public void clickActionButton(Long shipmentId, String actionButton)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
        shipmentsTable.clickActionButton(1, actionButton);
        pause200ms();
    }

    public void openShipmentDetailsPage(Long shipmentId)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
        pause3s();
        shipmentsTable.clickActionButton(1, ACTION_DETAILS);
        pause100ms();
        switchToOtherWindow();
    }

    public void forceSuccessShipment(Long shipmentId)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
        shipmentsTable.clickActionButton(1, ACTION_FORCE);
        click(XPATH_FORCE_SUCCESS_CONFIRMATION_BUTTON);
        waitUntilVisibilityOfToast(f("Success changed status to Force Success for Shipment ID %d", shipmentId));
    }

    public void cancelShipment(Long shipmentId)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
        shipmentsTable.clickActionButton(1, ACTION_CANCEL);
        clickButtonByAriaLabel("Cancel Shipment");
        waitUntilVisibilityOfToast(f("Success changed status to Cancelled for Shipment ID %d", shipmentId));
    }

    public void openAwb(Long shipmentId)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
        shipmentsTable.clickActionButton(1, ACTION_PRINT);
        pause100ms();
        switchToOtherWindow();
    }

    public void validateShipmentInfo(Long shipmentId, ShipmentInfo expectedShipmentInfo)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
        ShipmentInfo actualShipmentInfo = shipmentsTable.readEntity(1);
        expectedShipmentInfo.compareWithActual(actualShipmentInfo);
    }

    public void validateShipmentId(Long shipmentId)
    {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
        String expectedShipmentId = getText("//td[@nv-table-highlight='filter.id']");
        assertEquals("Shipment ID is not the same : ", expectedShipmentId, String.valueOf(shipmentId));
    }

    public void verifyOpenedShipmentDetailsPageIsTrue(Long shipmentId, String trackingId)
    {
        String expectedTextShipmentDetails = f("Shipment ID : %d", shipmentId);
        String actualTextShipmentDetails = getText("//md-content[contains(@class,'nv-shipment-details')]//h3");
        assertEquals("Shipment ID is not the same: ", expectedTextShipmentDetails, actualTextShipmentDetails);
        isElementExist(f("//td[contains(text(),'%s')]", trackingId));
    }

    public void verifyMasterAwbIsOpened()
    {
        String currentUrl = getCurrentUrl();
        assertTrue("Tab is not opened", currentUrl.startsWith("blob"));
        getWebDriver().close();
    }

    public void waitUntilForceToastDisappear(Long shipmentId)
    {
        waitUntilInvisibilityOfElementLocated(f("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Success changed status to Force Success for Shipment ID %d']", shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

    public void verifyInboundedShipmentExist(Long shipmentId)
    {
        retryIfAssertionErrorOccurred(() ->
        {
            try
            {
                List<ShipmentInfo> shipmentList = shipmentsTable.readAllEntities();
                shipmentList.stream()
                        .filter(shipment -> shipment.getId().equals(shipmentId))
                        .findFirst()
                        .orElseThrow(() -> new AssertionError(f("Shipment with ID = '%s' not exist.", shipmentId)));
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

    public void downloadPdfAndVerifyTheDataIsCorrect(ShipmentInfo shipmentInfo, byte[] shipmentAirwayBill)
    {
        ShipmentAirwayBill sab = PdfUtils.getShipmentFromShipmentAirwayBill(shipmentAirwayBill);
        assertEquals("Shipment ID is not the same: ", shipmentInfo.getId(), sab.getShipmentId());
        assertEquals("Start Hub is not the same: ", StandardTestConstants.COUNTRY_CODE + "-" + shipmentInfo.getOrigHubName(), sab.getStartHub());
        assertEquals("Destination Hub is not the same: ", StandardTestConstants.COUNTRY_CODE + "-" + shipmentInfo.getDestHubName(), sab.getDestinationHub());
        assertEquals("Contains has a different number: ", shipmentInfo.getOrdersCount(), sab.getContains());
    }

    public void forceSuccessShipment()
    {
        click("//button[contains(@aria-label,'Force')]");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@aria-describedby,'dialogContent')]");
        click("//button[contains(@aria-label,'Confirm')]");

        String toastMessage = getToastTopText();
        assertThat("Toast message not contains Shipment Completion", toastMessage, allOf(containsString("Force"), containsString("Success")));
    }

    public void createAndUploadCsv(List<Order> orders, String fileName, boolean isValid, boolean isDuplicated, int numberOfOrder, ShipmentInfo shipmentInfo) throws FileNotFoundException
    {
        StringBuilder bulkData = new StringBuilder();
        if (isValid)
        {
            for (int i = 0; i < orders.size(); i++)
            {
                bulkData.append(orders.get(i).getTrackingId());
                if (i + 1 < orders.size())
                {
                    bulkData.append("\n");
                }
            }
            if (isDuplicated)
            {
                bulkData.append("\n");
                bulkData.append(orders.get(0).getTrackingId());
            }
        }

        final String filePath = FILEPATH + fileName + ".csv";
        System.out.println("Upload CSV : " + filePath);
        PrintWriter writer = new PrintWriter(new FileOutputStream(filePath, false));

        if (isValid)
        {
            writer.print(bulkData);
        } else
        {
            writer.print("TS");
        }
        writer.close();

        uploadFile(fileName, numberOfOrder, isValid, isDuplicated, shipmentInfo);
        pause1s();
        click("//md-toolbar[@title='Upload Results']//button[@aria-label='Cancel']");
        pause1s();
        click("//md-toolbar[@title='Edit Shipment']//button[@aria-label='Cancel']");
    }

    public void createAndUploadCsv(List<Order> orders, String fileName, int numberOfOrder, ShipmentInfo shipmentInfo) throws FileNotFoundException
    {
        createAndUploadCsv(orders, fileName, true, false, numberOfOrder, shipmentInfo);
    }

    public void createAndUploadCsv(String fileName, ShipmentInfo shipmentInfo) throws FileNotFoundException
    {
        createAndUploadCsv(null, fileName, false, false, 0, shipmentInfo);
    }

    private void uploadFile(String fileName, int numberOfOrder, boolean isValid, boolean isDuplicated, ShipmentInfo shipmentInfo)
    {
        //-- click Choose File
        final String filePath = FILEPATH + fileName + ".csv";
        clickActionButton(shipmentInfo.getId(), ACTION_EDIT);
        findElementByXpath("//input[contains(@id,'file')]").sendKeys(filePath);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'shipment-upload-order-result')]");

        int actualNumberOfOrder = Integer.parseInt(getText("//input[contains(@id,'container.shipment-management.uploaded-orders')]/preceding-sibling::div"));
        int successfulOrder = Integer.parseInt(getText("//input[contains(@id,'container.shipment-management.successful')]/preceding-sibling::div"));
        int failedOrder = Integer.parseInt(getText("//input[contains(@id,'container.shipment-management.failed')]/preceding-sibling::div"));
        pause1s();
        if (isValid)
        {
            if (isDuplicated)
            {
                assertEquals("Number of Order is not the same", actualNumberOfOrder, numberOfOrder + 1);
                assertEquals("Failed Order(s) : ", failedOrder, 1);
                String actualFailedReason = getTextOnTableWithNgRepeat(1, "reason", "row in ctrl.uploadResult.failedUpload");
                assertEquals("Failure reason is different : ", actualFailedReason, "DUPLICATE");
            } else
            {
                assertEquals("Number of Order is not the same", actualNumberOfOrder, numberOfOrder);
                assertEquals("Failed Order(s) : ", failedOrder, 0);
            }
            assertEquals("Successful Order(s) : ", successfulOrder, numberOfOrder);

        } else
        {
            assertEquals("Number of Order is not the same", actualNumberOfOrder, 1);
            assertEquals("Successful Order(s) : ", successfulOrder, 0);
            assertEquals("Failed Order(s) : ", failedOrder, 1);
        }
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
        public static final String COLUMN_SLA_DATE_TIME = "sla";
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
                    .put(COLUMN_SLA_DATE_TIME, "sla_datetime")
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

    public static class CreateShipmentDialog extends MdDialog
    {
        public CreateShipmentDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "[id^='select-type']")
        public MdSelect type;

        @FindBy(css = "[id^='start-hub']")
        public MdSelect startHub;

        @FindBy(css = "[id^='end-hub']")
        public MdSelect endHub;

        @FindBy(id = "container.shipment-management.comments-optional")
        public TextBox comments;

        @FindBy(name = "Create")
        public NvApiTextButton create;

        @FindBy(name = "Create Another")
        public NvApiTextButton createAnother;

    }

    public static class EditShipmentDialog extends MdDialog
    {
        public EditShipmentDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "[id^='select-type']")
        public MdSelect type;

        @FindBy(css = "[id^='start-hub']")
        public MdSelect startHub;

        @FindBy(css = "[id^='end-hub']")
        public MdSelect endHub;

        @FindBy(id = "container.shipment-management.comments-optional")
        public TextBox comments;

        @FindBy(id = "master-awb")
        public TextBox mawb;

        @FindBy(id = "saveChangesButton")
        public NvIconTextButton saveChanges;

        public void saveChanges(Long shipmentId)
        {
            saveChanges.click();
            pause1s();
            waitUntilInvisibilityOfElementLocated(f("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Shipment %s updated']", shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
        }

        public void saveChangesWithMawb(Long shipmentId)
        {
            saveChanges.click();
            pause1s();

            waitUntilVisibilityOfElementLocated("//md-dialog[contains(@aria-describedby,'dialogContent') and not (contains(@class,'shipment-edit'))]");
            click("//button[@aria-label='Save']");

            waitUntilInvisibilityOfElementLocated(f("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Shipment %s updated']", shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
        }

    }

    public static class ShipmentEventsTable extends MdVirtualRepeatTable<ShipmentEvent>
    {
        public static final String MD_VIRTUAL_REPEAT = "p in getTableData()";
        public static final String SOURCE = "source";
        public static final String USER_ID = "userId";
        public static final String RESULT = "result";
        public static final String HUB = "hub";
        public static final String CREATED_AT = "createdAt";

        public ShipmentEventsTable(WebDriver webDriver)
        {
            super(webDriver);
            setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(SOURCE, "source")
                    .put(USER_ID, "user_id")
                    .put(RESULT, "result")
                    .put(HUB, "hub")
                    .put(CREATED_AT, "created_at")
                    .build());
            setEntityClass(ShipmentEvent.class);
            setNvTableParam("ctrl.tableParamScans");
        }
    }

    public static class MovementEventsTable extends MdVirtualRepeatTable<MovementEvent>
    {
        public static final String MD_VIRTUAL_REPEAT = "p in getTableData()";
        public static final String SOURCE = "source";
        public static final String STATUS = "status";
        public static final String CREATED_AT = "createdAt";
        public static final String COMMENTS = "comments";

        public MovementEventsTable(WebDriver webDriver)
        {
            super(webDriver);
            setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(SOURCE, "source")
                    .put(STATUS, "status")
                    .put(CREATED_AT, "created_at")
                    .put(COMMENTS, "comments")
                    .build());
            setEntityClass(MovementEvent.class);
            setNvTableParam("ctrl.tableParamEvents");
        }
    }
}