package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common_selenium.page.SimplePage;
import co.nvqa.commons.model.DataEntity;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.hub.Shipment;
import co.nvqa.commons.model.pdf.ShipmentAirwayBill;
import co.nvqa.commons.util.PdfUtils;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.MovementEvent;
import co.nvqa.operator_v2.model.ShipmentEvent;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import static co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable.ACTION_CANCEL;
import static co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable.ACTION_DETAILS;
import static co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable.ACTION_FORCE;
import static co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable.ACTION_PRINT;
import static co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable.COLUMN_SHIPMENT_ID;
import static org.hamcrest.Matchers.allOf;
import static org.hamcrest.Matchers.contains;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipmentManagementPage extends OperatorV2SimplePage {

  private static final String LOCATOR_CREATE_SHIPMENT_CONFIRMATION_BUTTON = "Create";
  private static final String LOCATOR_SELCT_FILTERS_PRESET = "commons.preset.load-filter-preset";
  private static final String SHIPMENT_STATUS_INPUT_XPATH = "//input[contains(@id,'input') and contains(@aria-label,'Search or Select')]";
  private static final String TRANSIT_SELECTION_XPATH = "//span[text()='Transit']/ancestor::li";

  private static final String XPATH_EDIT_SEARCH_FILTER_BUTTON = "//button[contains(@aria-label, 'Edit Filter')]";
  private static final String XPATH_FORCE_SUCCESS_CONFIRMATION_BUTTON = "//button[span[text()='Confirm']]";
  private static final String XPATH_SHIPMENT_SCAN = "//div[contains(@class,'table-shipment-scan-container')]/table/tbody/tr";
  private static final String XPATH_CLOSE_SCAN_MODAL_BUTTON = "//button[@aria-label='Cancel']";
  private static final String XPATH_CLEAR_FILTER_BUTTON = "//button[@aria-label='Clear All Selections']";
  private static final String XPATH_CLEAR_FILTER_VALUE = "//button[@aria-label='Clear All']";
  private static final String XPATH_CHECKBOX_ON_SHIPMENT_TABLE = "//td[@class='id']/following-sibling::td[@class='column-checkbox']//md-checkbox[@ng-checked='table.isSelected(shipment)']//div[@class='md-icon']";
  private static final String XPATH_SECOND_CHECKBOX_ON_SHIPMENT_TABLE = "(//md-checkbox)[2]";
  private static final String XPATH_APPLY_ACTION_BUTTON = "//button[@ng-click='$mdOpenMenu($event)' and @aria-label='Action']";
  private static final String XPATH_REOPEN_SHIPMENT_OPTION = "//button[@ng-click='ctrl.reopenShipment($event, ctrl.tableParam.getSelection())']";
  private static final String XPATH_BULK_UPDATE_SHIPMENT_OPTION = "//button[@aria-label='Bulk Update']";
  private static final String XPATH_REOPEN_SHIPMENT_OPTION_DISABLED = "//button[@ng-click='ctrl.reopenShipment($event, ctrl.tableParam.getSelection())' and @disabled='disabled']";
  private static final String XPATH_SEARCH_BY_SHIPMENT_ID = "//textarea[@id='shipment-ids']";
  private static final String XPATH_SEARCH_SHIPMENT_BUTTON = "//button[contains(@class,'shipment-search-btn')]";
  private static final String XPATH_SEARCH_SHIPMENT_ID_FILTER = "//th[@class='id']//input[@ng-model='searchText']";
  private static final String XPATH_SHIPMENT_ID_RESULT_TABLE = "//td[@nv-table-highlight='filter.id']";
  private static final String XPATH_SHIPMENT_ID_DUPLICATED = "//span[@ng-if='ctrl.duplicateCount!==0']";
  private static final String XPATH_SHIPMENT_SEARCH_ERROR_MODAL = "//md-dialog[contains(@class,'shipment-search-error')]";
  private static final String XPATH_SHIPMENT_SEARCH_ERROR_MODAL_OK_BUTTON = "//nv-icon-text-button[@on-click='ctrl.onCancel($event)']/button";
  private static final String XPATH_SHIPMENT_SEARCH_ERROR_MODAL_SHOW_SHIPMENT_BUTTON = "//nv-icon-text-button[@on-click='ctrl.onOk($event)']/button";

  public ShipmentsTable shipmentsTable;
  public ShipmentEventsTable shipmentEventsTable;
  public MovementEventsTable movementEventsTable;

  @FindBy(xpath = "//div[@class='shipment-bulk-container']")
  public ShipmentToBeUpdatedTable shipmentToBeUpdatedTable;

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

  @FindBy(css = "md-dialog")
  public ForceCompleteDialog forceCompleteDialog;

  @FindBy(css = "md-dialog")
  public CancelShipmentDialog cancelShipmentDialog;

  @FindBy(css = "md-dialog")
  public BulkUpdateShipmentDialog bulkUpdateShipmentDialog;

  @FindBy(css = "md-dialog")
  public ConfirmBulkUpdateDialog confirmBulkUpdateDialog;

  @FindBy(xpath = "//button[@aria-label='Cancel']")
  public Button cancelShipmentButton;

  @FindBy(css = "[id^='commons.preset.load-filter-preset']")
  public MdSelect filterPresetSelector;

  @FindBy(name = "Confirm Updates")
  public NvApiTextButton confirmUpdateButton;

  @FindBy(name = "Abort Updates")
  public NvApiTextButton abortUpdateButton;

  @FindBy(name = "Modify Selection")
  public NvIconTextButton modifySelectionButton;

  @FindBy(xpath = "//md-checkbox[@aria-checked='false']")
  private PageElement uncheckedShipmentCheckBox;

  @FindBy(xpath = "//button[contains(@ng-class,'show-selected')]")
  private PageElement showSelectedShipmentsDropdown;

  @FindBy(xpath = "//button[@aria-label='Show Only Selected']")
  private PageElement showSelectedShipments;

  private static final String FILEPATH = TestConstants.TEMP_DIR;

  public ShipmentManagementPage(WebDriver webDriver) {
    super(webDriver);
    shipmentsTable = new ShipmentsTable(webDriver);
    shipmentEventsTable = new ShipmentEventsTable(webDriver);
    movementEventsTable = new MovementEventsTable(webDriver);
  }

  public void clickEditSearchFilterButton() {
    click(XPATH_EDIT_SEARCH_FILTER_BUTTON);
    pause1s();
  }

  public void clickButtonLoadSelection() {
    clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
  }

  public void switchToOtherWindow() {
    waitUntilNewWindowOrTabOpened();
    Set<String> windowHandles = getWebDriver().getWindowHandles();

    for (String windowHandle : windowHandles) {
      getWebDriver().switchTo().window(windowHandle);
    }
  }

  public void searchByShipmentIds(List<Long> shipmentIds) {
    this.shipmentIds.setValue(StringUtils.join(shipmentIds, "\n"));
    searchByShipmentIds.clickAndWaitUntilDone();
  }

  public void addFilter(String filterLabel, String value, boolean isMawb) {
    selectValueFromNvAutocompleteByItemTypesAndDismiss("filters", filterLabel);
    if (!isMawb) {
      selectValueFromNvAutocompleteByItemTypesAndDismiss(filterLabel, value);
    } else {
      sendKeys("//input[@ng-model='search' and contains(@id,'input')]", value);
    }
    pause1s();
  }

  public void transitStatus() {
    selectValueFromNvAutocompleteByItemTypesAndDismiss("filters", "Shipment Status");
    click(SHIPMENT_STATUS_INPUT_XPATH);
    click(TRANSIT_SELECTION_XPATH);
    sendKeys(SHIPMENT_STATUS_INPUT_XPATH, Keys.ESCAPE);
    pause1s();
  }

  public void changeDate(String date, boolean isToday) {
    String datepickerXpath = "//md-datepicker[@ng-model='%s']//input";
    if (isToday) {
      clear(f(datepickerXpath, "container.fromDate"));
      pause1s();
      sendKeys(f(datepickerXpath, "container.fromDate"), date);
    } else {
      clear(f(datepickerXpath, "container.toDate"));
      pause1s();
      sendKeys(f(datepickerXpath, "container.toDate"), date);
    }
  }

  public long saveFiltersAsPreset(String presetName) {
    clickButtonByAriaLabel("Action");
    clickButtonByAriaLabel("Save Current as Preset");
    waitUntilVisibilityOfMdDialogByTitle("Save Preset");
    sendKeysByAriaLabel("Preset Name", presetName);
    clickNvIconTextButtonByName("commons.save");
    waitUntilVisibilityOfToast("1 filter preset created");
    String presetId = getMdSelectValueById("commons.preset.load-filter-preset");
    Pattern p = Pattern.compile("(\\d+) (-) (.+)");
    Matcher m = p.matcher(presetId);
    if (m.matches()) {
      presetId = m.group(1);
      assertThat("created preset is selected", m.group(3), equalTo(presetName));
    }
    return Long.parseLong(presetId);
  }

  public void deleteFiltersPreset(String presetName) {
    clickButtonByAriaLabel("Action");
    clickButtonByAriaLabel("Delete Preset");
    waitUntilVisibilityOfMdDialogByTitle("Delete Preset");
    selectValueFromMdSelectByAriaLabel("Select preset", presetName);
    clickNvIconTextButtonByName("commons.delete");
    waitUntilVisibilityOfToast("1 filter preset deleted");
  }

  public void verifyFiltersPresetWasDeleted(String presetName) {
    assertThat("Preset [" + presetName + "] exists in presets list",
        getMdSelectMultipleValuesById(LOCATOR_SELCT_FILTERS_PRESET), not(contains(presetName)));
  }

  public void selectFiltersPreset(String presetName) {
    selectValueFromMdSelectById(LOCATOR_SELCT_FILTERS_PRESET, presetName);
  }

  public void verifySelectedFilters(Map<String, String> filters) {
    filters.forEach((filter, expectedValue) ->
    {
      String actualValue = getAttribute("aria-label",
          "//nv-filter-box[@item-types='%s']//nv-icon-text-button[@ng-repeat]", filter);
      assertThat(filter + " filter selected value", actualValue, equalTo(expectedValue));
    });
  }

  public void shipmentScanExist(String source, String hub) {
    String xpath =
        XPATH_SHIPMENT_SCAN + "[td[text()='" + source + "']]" + "[td[text()='" + hub + "']]";
    WebElement scan = findElementByXpath(xpath);
    assertEquals("shipment(" + source + ") not exist", "tr", scan.getTagName());
  }

  public void createShipment(ShipmentInfo shipmentInfo, boolean isNextOrder) {
    createShipment.click();
    createShipmentDialog.waitUntilVisible();
    createShipmentDialog.type.selectValue("Air Haul");
    createShipmentDialog.startHub.searchAndSelectValue(shipmentInfo.getOrigHubName());
    createShipmentDialog.endHub.searchAndSelectValue(shipmentInfo.getDestHubName());
    createShipmentDialog.comments.setValue(shipmentInfo.getComments());

    if (isNextOrder) {
      createShipmentDialog.createAnother.click();
    } else {
      createShipmentDialog.create.click();
    }

    String toastMessage = getToastTopText();
    assertThat("Toast message not contains Shipment <SHIPMENT_ID> created", toastMessage,
        allOf(containsString("Shipment"), containsString("created")));
    long shipmentId = Long.parseLong(toastMessage.split(" ")[1]);
    confirmToast(toastMessage, false);
    shipmentInfo.setId(shipmentId);
  }

  public Long createAnotherShipment() {
    clickNvApiTextButtonByNameAndWaitUntilDone(LOCATOR_CREATE_SHIPMENT_CONFIRMATION_BUTTON);
    String toastMessage = getToastTopText();
    assertThat("Toast message not contains Shipment <SHIPMENT_ID> created", toastMessage,
        allOf(containsString("Shipment"), containsString("created")));
    long shipmentId = Long.parseLong(toastMessage.split(" ")[1]);
    confirmToast(toastMessage, false);

    return shipmentId;
  }

  public void editShipment(ShipmentInfo shipmentInfo) {
    clickActionButton(shipmentInfo.getId(), ACTION_EDIT);

    editShipmentDialog.waitUntilVisible();
    editShipmentDialog.startHub.searchAndSelectValue(shipmentInfo.getOrigHubName());
    editShipmentDialog.endHub.searchAndSelectValue(shipmentInfo.getDestHubName());
    editShipmentDialog.comments.setValue(shipmentInfo.getComments());

    if (StringUtils.isBlank(shipmentInfo.getMawb())) {
      editShipmentDialog.saveChanges(shipmentInfo.getId());
    } else {
      editShipmentDialog.mawb.setValue(shipmentInfo.getMawb());
      editShipmentDialog.saveChangesWithMawb(shipmentInfo.getId());
    }
  }

  public void editCancelledShipment() {
    shipmentsTable.clickActionButton(1, ACTION_EDIT);
    waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'shipment-edit')]");
    isElementExist("//textarea[@ng-readonly='readOnly']");
    click("//button[@aria-label='OK']");
  }

  public void clickActionButton(Long shipmentId, String actionButton) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    shipmentsTable.clickActionButton(1, actionButton);
    pause200ms();
  }

  public void openShipmentDetailsPage(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    pause3s();
    TestUtils.findElementAndClick(f(ACTION_DETAILS, 1), "xpath", getWebDriver());
    pause100ms();
    switchToOtherWindow();
  }

  public void forceSuccessShipment(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    shipmentsTable.clickActionButton(1, ACTION_FORCE);
    forceCompleteDialog.waitUntilVisible();
    forceCompleteDialog.confirm.click();
    waitUntilVisibilityOfToast(
        f("Successfully changed status to Force Success for Shipment ID %d", shipmentId));
    pause5s();
  }

  public void cancelShipment(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    shipmentsTable.clickActionButton(1, ACTION_CANCEL);
    cancelShipmentDialog.waitUntilVisible();
    cancelShipmentDialog.cancelShipment.click();
    waitUntilVisibilityOfToast(
        f("Successfully changed status to Cancelled for Shipment ID %d", shipmentId));
    pause5s();
  }

  public void openAwb(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    shipmentsTable.clickActionButton(1, ACTION_PRINT);
    pause100ms();
    switchToOtherWindow();
  }

  public void validateShipmentInfo(Long shipmentId, ShipmentInfo expectedShipmentInfo) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    ShipmentInfo actualShipmentInfo = shipmentsTable.readEntity(1);
    expectedShipmentInfo.compareWithActual(actualShipmentInfo);
  }

  public void validateShipmentStatusPending(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    ShipmentInfo actualShipmentInfo = shipmentsTable.readEntity(1);
    assertThat("shipment Id is the same", actualShipmentInfo.getId(), equalTo(shipmentId));
    assertThat("shipment status is the same", actualShipmentInfo.getStatus(), equalTo("Pending"));
  }

  public void validateShipmentId(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    String expectedShipmentId = getText("//td[@nv-table-highlight='filter.id']");
    assertEquals("Shipment ID is not the same : ", expectedShipmentId, String.valueOf(shipmentId));
  }

  public void verifyOpenedShipmentDetailsPageIsTrue(Long shipmentId, String trackingId) {
    String expectedTextShipmentDetails = f("Shipment ID : %d", shipmentId);
    String actualTextShipmentDetails = getText(
        "//md-content[contains(@class,'nv-shipment-details')]//h3");
    assertEquals("Shipment ID is same: ", expectedTextShipmentDetails,
        actualTextShipmentDetails);
    isElementExist(f("//td[contains(text(),'%s')]", trackingId));
    getWebDriver().close();
  }

  public void verifyMasterAwbIsOpened() {
    String currentUrl = getCurrentUrl();
    assertTrue("Tab is not opened", currentUrl.startsWith("blob"));
    getWebDriver().close();
  }

  public void waitUntilForceToastDisappear(Long shipmentId) {
    waitUntilInvisibilityOfElementLocated(
        f("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Success changed status to Force Success for Shipment ID %d']",
            shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
  }

  public void verifyInboundedShipmentExist(Long shipmentId) {
    retryIfAssertionErrorOccurred(() ->
    {
      try {
        List<ShipmentInfo> shipmentList = shipmentsTable.readAllEntities();
        shipmentList.stream()
            .filter(shipment -> shipment.getId().equals(shipmentId))
            .findFirst()
            .orElseThrow(
                () -> new AssertionError(f("Shipment with ID = '%s' not exist.", shipmentId)));
      } catch (AssertionError ex) {
        clickEditSearchFilterButton();
        clickButtonLoadSelection();
        throw ex;
      }
    }, getCurrentMethodName());
  }

  public void clearAllFilters() {
    if (findElementByXpath(XPATH_CLEAR_FILTER_BUTTON).isDisplayed()) {
      if (findElementByXpath(XPATH_CLEAR_FILTER_VALUE).isDisplayed()) {
        List<WebElement> clearValueBtnList = findElementsByXpath(XPATH_CLEAR_FILTER_VALUE);

        for (WebElement clearBtn : clearValueBtnList) {
          clearBtn.click();
          pause1s();
        }
      }

      click(XPATH_CLEAR_FILTER_BUTTON);
    }

    pause2s();
  }

  public void closeScanModal() {
    click(XPATH_CLOSE_SCAN_MODAL_BUTTON);
    pause1s();
  }

  public void downloadPdfAndVerifyTheDataIsCorrect(ShipmentInfo shipmentInfo,
      byte[] shipmentAirwayBill) {
    ShipmentAirwayBill sab = PdfUtils.getShipmentFromShipmentAirwayBill(shipmentAirwayBill);
    assertEquals("Shipment ID is not the same: ", shipmentInfo.getId(), sab.getShipmentId());
    assertEquals("Start Hub is not the same: ",
        StandardTestConstants.COUNTRY_CODE + "-" + shipmentInfo.getOrigHubName(),
        sab.getStartHub());
    assertEquals("Destination Hub is not the same: ",
        StandardTestConstants.COUNTRY_CODE + "-" + shipmentInfo.getDestHubName(),
        sab.getDestinationHub());
    assertEquals("Contains has a different number: ", shipmentInfo.getOrdersCount(),
        sab.getContains());
  }

  public void forceSuccessShipment() {
    click("//button[contains(@aria-label,'Force')]");
    waitUntilVisibilityOfElementLocated("//md-dialog[contains(@aria-describedby,'dialogContent')]");
    click("//button[contains(@aria-label,'Confirm')]");

    String toastMessage = getToastTopText();
    assertThat("Toast message not contains Shipment Completion", toastMessage,
        allOf(containsString("Force"), containsString("Success")));
  }

  public void clickReopenShipmentButton(boolean isValid) {
    click(XPATH_CHECKBOX_ON_SHIPMENT_TABLE);
    click(XPATH_APPLY_ACTION_BUTTON);
    if (isValid) {
      waitUntilVisibilityOfElementLocated(XPATH_REOPEN_SHIPMENT_OPTION);
      click(XPATH_REOPEN_SHIPMENT_OPTION);
    }
  }

  public void clickReopenShipmentButton() {
    clickReopenShipmentButton(true);
  }

  public void selectAllAndClickReopenShipmentButton() {
    click(XPATH_CHECKBOX_ON_SHIPMENT_TABLE);
    click(XPATH_SECOND_CHECKBOX_ON_SHIPMENT_TABLE);

    click(XPATH_APPLY_ACTION_BUTTON);
    waitUntilVisibilityOfElementLocated(XPATH_REOPEN_SHIPMENT_OPTION);
    click(XPATH_REOPEN_SHIPMENT_OPTION);
  }

  public void selectAllAndClickBulkUpdateButton() {
    // temporary close /aaa error alert if exist
    if (isElementExist("//button[.='close']")) {
      pause7s();
    }
    click(XPATH_CHECKBOX_ON_SHIPMENT_TABLE);
    click(XPATH_SECOND_CHECKBOX_ON_SHIPMENT_TABLE);

    click(XPATH_APPLY_ACTION_BUTTON);
    waitUntilVisibilityOfElementLocated(XPATH_BULK_UPDATE_SHIPMENT_OPTION);
    click(XPATH_BULK_UPDATE_SHIPMENT_OPTION);
  }

  public void verifiesShipmentIsReopened() {
    waitUntilVisibilityOfToast("Success reopen shipments");
    waitUntilInvisibilityOfToast("Success reopen shipments");
  }

  public void verifiesReopenShipmentIsDisabled() {
    isElementExistFast(XPATH_REOPEN_SHIPMENT_OPTION_DISABLED);
  }

  public void bulkSearchShipmentIds(List<Long> shipmentIds, boolean isDuplicated) {
    click(XPATH_SEARCH_BY_SHIPMENT_ID);
    for (int i = 0; i < shipmentIds.size(); i++) {
      if (i != shipmentIds.size() - 1) {
        if (isDuplicated && (i % 2 == 0)) {
          sendKeysWithoutClear(XPATH_SEARCH_BY_SHIPMENT_ID, shipmentIds.get(i).toString() + "\n");
        }
        sendKeysWithoutClear(XPATH_SEARCH_BY_SHIPMENT_ID, shipmentIds.get(i).toString() + "\n");
      } else {
        sendKeysWithoutClear(XPATH_SEARCH_BY_SHIPMENT_ID, shipmentIds.get(i).toString());
      }
    }
    pause3s();
    if (isDuplicated) {
      verifiesShipmentIdIsDuplicated();
    }

    click(XPATH_SEARCH_SHIPMENT_BUTTON);
  }

  public void verifyCannotParseParameterIdAsLongToastExist() {
    waitUntilVisibilityOfToast("Network Request Error");
    assertThat("toast message is the same", getToastBottomText(),
        containsString("Cannot parse parameter id as Long: For input string:"));
  }

  public void bulkSearchShipmentIds(List<Long> shipmentIds) {
    bulkSearchShipmentIds(shipmentIds, false);
  }

  public void bulkSearchShipmentIdsWithCondition(List<Long> shipmentIds, String condition) {
    switch (condition) {
      case "invalid":
        sendKeysWithoutClear(XPATH_SEARCH_BY_SHIPMENT_ID, generatePhoneNumber() + "\n");
        break;
    }

    for (int i = 0; i < shipmentIds.size(); i++) {
      if (i != shipmentIds.size() - 1) {
        switch (condition) {
          case "invalid":
            sendKeysWithoutClear(XPATH_SEARCH_BY_SHIPMENT_ID, shipmentIds.get(i).toString() + "\n");
            break;

          case "comma":
            sendKeysWithoutClear(XPATH_SEARCH_BY_SHIPMENT_ID, shipmentIds.get(i).toString() + ",");
            break;

          case "space":
            sendKeysWithoutClear(XPATH_SEARCH_BY_SHIPMENT_ID, shipmentIds.get(i).toString() + " ");
            break;

          case "empty line":
            sendKeysWithoutClear(XPATH_SEARCH_BY_SHIPMENT_ID, shipmentIds.get(i).toString() + "\n");
            if (i == shipmentIds.size() / 2) {
              sendKeysWithoutClear(XPATH_SEARCH_BY_SHIPMENT_ID, "\n");
            }
            break;

        }
      }
    }
    click(XPATH_SEARCH_SHIPMENT_BUTTON);
  }

  public void editShipmentBy(String editType, ShipmentInfo shipmentInfo) {
    clickActionButton(shipmentInfo.getId(), ACTION_EDIT);
    editShipmentDialog.waitUntilVisible();
    if ("Start Hub".equals(editType)) {
      editShipmentDialog.startHub.searchAndSelectValue(shipmentInfo.getOrigHubName());
    }
    if ("End Hub".equals(editType)) {
      editShipmentDialog.endHub.searchAndSelectValue(shipmentInfo.getDestHubName());
    }
    if ("Comments".equals(editType)) {
      editShipmentDialog.comments.setValue(shipmentInfo.getComments());
    }
    if ("EDA & ETA".equals(editType)) {
      String updatedEDA = shipmentInfo.getArrivalDatetime().split(" ")[0];
      String updatedETA = shipmentInfo.getArrivalDatetime().split(" ")[1].split(":")[0];
      editShipmentDialog.datePickerInput.clear();
      editShipmentDialog.datePickerInput.sendKeys(updatedEDA);
      editShipmentDialog.selectHour.selectValue(updatedETA);
    }
    if ("non-mawb".equals(editType)) {
      editShipmentDialog.startHub.searchAndSelectValue(shipmentInfo.getOrigHubName());
      editShipmentDialog.endHub.searchAndSelectValue(shipmentInfo.getDestHubName());
      editShipmentDialog.comments.setValue(shipmentInfo.getComments());
    }
    if ("mawb".equals(editType)) {
      editShipmentDialog.mawb.sendKeys(shipmentInfo.getMawb());
      editShipmentDialog.saveChangesWithMawb(shipmentInfo.getId());
      return;
    }
    if ("cancelled".equals(editType)) {
      editShipmentDialog.saveChanges.click();
      pause1s();
      return;
    }
    if ("completed".equals(editType)) {
      editShipmentDialog.forceSuccessButton.click();
      return;
    }
    editShipmentDialog.saveChanges(shipmentInfo.getId());
  }

  public void verifiesSearchErrorModalIsShown(boolean isValidShipmentExist) {
    isElementExist(XPATH_SHIPMENT_SEARCH_ERROR_MODAL);
    pause2s();

    if (isValidShipmentExist) {
      click(XPATH_SHIPMENT_SEARCH_ERROR_MODAL_SHOW_SHIPMENT_BUTTON);
    } else {
      click(XPATH_SHIPMENT_SEARCH_ERROR_MODAL_OK_BUTTON);
    }
  }

  public void searchedShipmentVerification(Long shipmentId) {
    click(XPATH_SEARCH_SHIPMENT_ID_FILTER);
    pause1s();
    String shipmentIdAsString = shipmentId.toString();
    sendKeys(XPATH_SEARCH_SHIPMENT_ID_FILTER, shipmentIdAsString);
    pause1s();
    waitUntilVisibilityOfElementLocated(XPATH_SHIPMENT_ID_RESULT_TABLE);
    String actualShipmentId = getText(XPATH_SHIPMENT_ID_RESULT_TABLE);
    assertEquals("Shipment ID", shipmentIdAsString, actualShipmentId);
  }

  public void moreThan30WarningToastShown() {
    waitUntilVisibilityOfToast("We cannot process more than 30 shipments");
    waitUntilInvisibilityOfToast("We cannot process more than 30 shipments");
  }

  public void verifyEmptyLineParsingErrorToastExist() {
    waitUntilVisibilityOfToast("Network Request Error");
    assertThat("toast message is the same", getToastBottomText(),
        containsString("Cannot parse parameter id as Long: For input string: \"\""));
  }

  public void verifyUnableToEditCompletedShipmentToastExist() {
    waitUntilVisibilityOfToast("Network Request Error");
    assertThat("toast message is the same", getToastBottomText(),
        containsString("unable to edit completed/cancelled shipments"));
    click("//button[.='close']");
  }

  public void createAndUploadCsv(List<Order> orders, String fileName, boolean isValid,
      boolean isDuplicated, int numberOfOrder, ShipmentInfo shipmentInfo)
      throws FileNotFoundException {
    StringBuilder bulkData = new StringBuilder();
    if (isValid) {
      for (int i = 0; i < orders.size(); i++) {
        bulkData.append(orders.get(i).getTrackingId());
        if (i + 1 < orders.size()) {
          bulkData.append("\n");
        }
      }
      if (isDuplicated) {
        bulkData.append("\n");
        bulkData.append(orders.get(0).getTrackingId());
      }
    }

    final String filePath = FILEPATH + fileName + ".csv";
    System.out.println("Upload CSV : " + filePath);
    PrintWriter writer = new PrintWriter(new FileOutputStream(filePath, false));

    if (isValid) {
      writer.print(bulkData);
    } else {
      writer.print("TS");
    }
    writer.close();

    uploadFile(fileName, numberOfOrder, isValid, isDuplicated, shipmentInfo);
    pause1s();
    click("//md-toolbar[@title='Edit Shipment']");
    pause1s();
    click("//button[@aria-label='Save Changes']");
    pause1s();
  }

  public void createAndUploadCsv(List<Order> orders, String fileName, int numberOfOrder,
      ShipmentInfo shipmentInfo) throws FileNotFoundException {
    createAndUploadCsv(orders, fileName, true, false, numberOfOrder, shipmentInfo);
  }

  public void createAndUploadCsv(String fileName, ShipmentInfo shipmentInfo)
      throws FileNotFoundException {
    createAndUploadCsv(null, fileName, false, false, 0, shipmentInfo);
  }

  private void verifiesShipmentIdIsDuplicated() {
    isElementExistFast(XPATH_SHIPMENT_ID_DUPLICATED);
  }

  private void uploadFile(String fileName, int numberOfOrder, boolean isValid, boolean isDuplicated,
      ShipmentInfo shipmentInfo) {
    //-- click Choose File
    final String filePath = FILEPATH + fileName + ".csv";
    clickActionButton(shipmentInfo.getId(), ACTION_EDIT);
    findElementByXpath("//input[contains(@id,'file')]").sendKeys(filePath);
    waitUntilVisibilityOfElementLocated(
        "//md-dialog[contains(@class,'shipment-upload-order-result')]");

    int actualNumberOfOrder = Integer.parseInt(getText(
        "//input[contains(@id,'container.shipment-management.uploaded-orders')]/preceding-sibling::div"));
    int successfulOrder = Integer.parseInt(getText(
        "//input[contains(@id,'container.shipment-management.successful')]/preceding-sibling::div"));
    int failedOrder = Integer.parseInt(getText(
        "//input[contains(@id,'container.shipment-management.failed')]/preceding-sibling::div"));
    pause1s();
    if (isValid) {
      if (isDuplicated) {
        assertEquals("Number of Order is not the same", actualNumberOfOrder, numberOfOrder + 1);
        assertEquals("Failed Order(s) : ", failedOrder, 1);
        String actualFailedReason = getTextOnTableWithNgRepeat(1, "reason",
            "row in ctrl.uploadResult.failedUpload");
        assertEquals("Failure reason is different : ", actualFailedReason, "DUPLICATE");
      } else {
        assertEquals("Number of Order is not the same", actualNumberOfOrder, numberOfOrder);
        assertEquals("Failed Order(s) : ", failedOrder, 0);
      }
      assertEquals("Successful Order(s) : ", successfulOrder, numberOfOrder);

    } else {
      assertEquals("Number of Order is not the same", actualNumberOfOrder, 1);
      assertEquals("Successful Order(s) : ", successfulOrder, 0);
      assertEquals("Failed Order(s) : ", failedOrder, 1);
    }
  }

  public void bulkUpdateShipment(Map<String, String> resolvedMapOfData) {
    if (resolvedMapOfData.get("shipmentType") != null) {
      String shipmentType = resolvedMapOfData.get("shipmentType");
      bulkUpdateShipmentDialog.shipmentTypeEnable.check();
      bulkUpdateShipmentDialog.shipmentType.selectValue(shipmentType);
    }
    if (resolvedMapOfData.get("startHub") != null) {
      String startHub = resolvedMapOfData.get("startHub");
      bulkUpdateShipmentDialog.startHubEnable.check();
      bulkUpdateShipmentDialog.startHub.selectValue(startHub);
    }
    if (resolvedMapOfData.get("endHub") != null) {
      String endHub = resolvedMapOfData.get("endHub");
      bulkUpdateShipmentDialog.destHubEnable.check();
      bulkUpdateShipmentDialog.endHub.selectValue(endHub);
    }
    if (resolvedMapOfData.get("EDA") != null) {
      String eda = resolvedMapOfData.get("EDA");
      bulkUpdateShipmentDialog.edaEnable.check();
      bulkUpdateShipmentDialog.edaInput.sendKeys(eda);
    }
    if (resolvedMapOfData.get("ETA") != null) {
      String eta = resolvedMapOfData.get("ETA");
      String etaHour = eta.split(":")[0];
      String etaMinute = eta.split(":")[1];
      bulkUpdateShipmentDialog.etaEnable.check();
      bulkUpdateShipmentDialog.etaSelectHour.selectValue(etaHour);
      bulkUpdateShipmentDialog.etaSelectMinute.selectValue(etaMinute);
    }
    if (resolvedMapOfData.get("mawb") != null) {
      String mawb = resolvedMapOfData.get("mawb");
      bulkUpdateShipmentDialog.mawbEnable.check();
      bulkUpdateShipmentDialog.mawbInput.sendKeys(mawb);
    }
    if (resolvedMapOfData.get("comments") != null) {
      String comments = resolvedMapOfData.get("comments");
      bulkUpdateShipmentDialog.commentsEnable.check();
      bulkUpdateShipmentDialog.commentsInput.sendKeys(comments);
    }
    bulkUpdateShipmentDialog.applyToSelected.click();
  }

  public void verifyShipmentToBeUpdatedData(List<Long> shipmentIds,
      Map<String, String> resolvedMapOfData) {
    shipmentToBeUpdatedTable.waitUntilVisible();
    shipmentToBeUpdatedTable.fieldToBeUpdated.waitUntilVisible();
    String fieldToBeUpdated = shipmentToBeUpdatedTable.fieldToBeUpdated.getText().split(":")[1]
        .trim();
    if (resolvedMapOfData.get("shipmentType") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("Shipment Type"));
    }
    if (resolvedMapOfData.get("startHub") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("Start Hub"));
    }
    if (resolvedMapOfData.get("endHub") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("End Hub"));
    }
    if (resolvedMapOfData.get("eda") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("ETA (Date Time)"));
    }
    if (resolvedMapOfData.get("eta") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("ETA (Date Time)"));
    }
    if (resolvedMapOfData.get("mawb") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("MAWB"));
    }
    if (resolvedMapOfData.get("comments") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("Comments"));
    }
    List<String> actualShipmentIds = shipmentToBeUpdatedTable.shipmentIds.stream()
        .map(TextBox::getText).collect(
            Collectors.toList());

    if (resolvedMapOfData.get("removeShipment") != null) {
      String whichShipment = resolvedMapOfData.get("removeShipment");
      if ("second".equals(whichShipment)) {
        shipmentToBeUpdatedTable.removeButtons.get(1).click();
        pause1s();
        assertThat(f("shipment id %d is contained", shipmentIds.get(0)),
            actualShipmentIds.contains(String.valueOf(shipmentIds.get(0))), equalTo(true));
        return;
      }
    }

    for (Long shipmentId : shipmentIds) {
      assertThat(f("shipment id %d is contained", shipmentId),
          actualShipmentIds.contains(String.valueOf(shipmentId)), equalTo(true));
    }
  }

  public void confirmUpdateBulk(Map<String, String> resolvedMapOfData) {
    if (resolvedMapOfData.get("abort") != null) {
      abortUpdateButton.click();
      pause1s();
      return;
    }
    if (resolvedMapOfData.get("modifySelection") != null) {
      modifySelectionButton.click();
      pause1s();
      return;
    }
    confirmUpdateButton.click();

    confirmBulkUpdateDialog.waitUntilVisible();
    String[] confirmUpdateContent = confirmBulkUpdateDialog.confirmDialogContent.getText()
        .split("\n");
    String shipmentField = confirmUpdateContent[0].split(":")[1].trim();
    Long numberOfRecords = Long.valueOf(confirmUpdateContent[1].split(":")[1].trim());
    if (resolvedMapOfData.get("shipmentType") != null) {
      assertThat("field is equal", shipmentField, containsString("Shipment Type"));
    }
    if (resolvedMapOfData.get("startHub") != null) {
      assertThat("field is equal", shipmentField, containsString("Start Hub"));
    }
    if (resolvedMapOfData.get("endHub") != null) {
      assertThat("field is equal", shipmentField, containsString("End Hub"));
    }
    if (resolvedMapOfData.get("EDA") != null) {
      assertThat("field is equal", shipmentField, containsString("ETA (Date Time)"));
    }
    if (resolvedMapOfData.get("ETA") != null) {
      assertThat("field is equal", shipmentField, containsString("ETA (Date Time)"));
    }
    if (resolvedMapOfData.get("mawb") != null) {
      assertThat("field is equal", shipmentField, containsString("MAWB"));
    }
    if (resolvedMapOfData.get("comments") != null) {
      assertThat("field is equal", shipmentField, containsString("Comments"));
    }
    if (resolvedMapOfData.get("removeShipment") != null) {
      assertThat("number of records is equal", numberOfRecords, equalTo(1L));
    } else {
      assertThat("number of records is equal", numberOfRecords, equalTo(2L));
    }
    confirmBulkUpdateDialog.proceed.click();
    confirmBulkUpdateDialog.waitUntilInvisible();

    pause1s();
    String fieldInfo = shipmentToBeUpdatedTable.fieldToBeUpdated.getText().split(": ")[0];
    assertThat("Field info is correct", fieldInfo, equalTo("Field successfully updated"));
    for (PageElement checkListExistence : shipmentToBeUpdatedTable.checkLists) {
      assertThat("checklists is shown", checkListExistence.getText(), equalTo("check"));
    }
    shipmentToBeUpdatedTable.backButton.click();
  }

  public void validateShipmentUpdated(Long shipmentId, Map<String, String> resolvedMapOfData) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    ShipmentInfo actualShipmentInfo = shipmentsTable.readEntity(1);
    assertThat("Shipment id is the same", actualShipmentInfo.getId(),
        equalTo(shipmentId));
    if (resolvedMapOfData.get("shipmentType") != null) {
      assertThat("Shipment Type is the same", actualShipmentInfo.getShipmentType().toLowerCase(),
          equalTo(resolvedMapOfData.get("shipmentType").toLowerCase()));
    }
    if (resolvedMapOfData.get("startHub") != null) {
      assertThat("Start Hub is the same", actualShipmentInfo.getOrigHubName().toLowerCase(),
          equalTo(resolvedMapOfData.get("startHub").toLowerCase()));
    }
    if (resolvedMapOfData.get("endHub") != null) {
      assertThat("End Hub is the same", actualShipmentInfo.getDestHubName().toLowerCase(),
          equalTo(resolvedMapOfData.get("endHub").toLowerCase()));
    }
    if (resolvedMapOfData.get("EDA") != null) {
      String eda = actualShipmentInfo.getArrivalDatetime().toLowerCase().split(" ")[0];
      assertThat("EDA is the same", eda,
          equalTo(resolvedMapOfData.get("EDA").toLowerCase()));
    }
    if (resolvedMapOfData.get("ETA") != null) {
      String eta = actualShipmentInfo.getArrivalDatetime().toLowerCase().split(" ")[1];
      assertThat("ETA is the same", eta,
          equalTo(resolvedMapOfData.get("ETA").toLowerCase()));
    }
    if (resolvedMapOfData.get("mawb") != null) {
      String mawb = actualShipmentInfo.getMawb().toLowerCase();
      assertThat("MAWB is the same", mawb,
          equalTo(resolvedMapOfData.get("mawb").toLowerCase()));
    }
    if (resolvedMapOfData.get("comments") != null) {
      String comments = actualShipmentInfo.getComments().toLowerCase();
      assertThat("Comments is the same", comments,
          equalTo(resolvedMapOfData.get("comments").toLowerCase()));
    }
  }

  public void selectAnotherShipmentAndVerifyCount() {
    uncheckedShipmentCheckBox.click();
    showSelectedShipmentsDropdown.click();
    showSelectedShipments.click();

    List<ShipmentInfo> shipmentList = shipmentsTable.readAllEntities();
    assertThat("Selected shipments count is true", shipmentList.size(), equalTo(3));
  }

  /**
   * Accessor for Shipments table
   */
  public static class ShipmentsTable extends MdVirtualRepeatTable<ShipmentInfo> {

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
    public static final String ACTION_DETAILS = "//tr[%s]//td//nv-icon-button[@name='Details']";
    public static final String ACTION_FORCE = "Force";
    public static final String ACTION_PRINT = "Print";
    public static final String ACTION_CANCEL = "Cancel";

    public ShipmentsTable(WebDriver webDriver) {
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

  public static class CreateShipmentDialog extends MdDialog {

    public CreateShipmentDialog(WebDriver webDriver, WebElement webElement) {
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

  public static class EditShipmentDialog extends MdDialog {

    public EditShipmentDialog(WebDriver webDriver, WebElement webElement) {
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

    @FindBy(xpath = "//input[@class='md-datepicker-input']")
    public PageElement datePickerInput;

    @FindBy(id = "select-hour")
    public MdSelect selectHour;

    @FindBy(css = "button[aria-label='Force Success']")
    public Button forceSuccessButton;

    public void saveChanges(Long shipmentId) {
      saveChanges.click();
      pause1s();

      waitUntilVisibilityOfElementLocated(
          f("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Shipment %s updated']",
              shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
      waitUntilInvisibilityOfElementLocated(
          f("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Shipment %s updated']",
              shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

    public void saveChangesWithMawb(Long shipmentId) {
      saveChanges.click();
      pause1s();

      waitUntilVisibilityOfElementLocated(
          "//md-dialog[contains(@aria-describedby,'dialogContent') and not (contains(@class,'shipment-edit'))]");
      click("//button[@aria-label='Save']");

      waitUntilVisibilityOfElementLocated(
          f("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Shipment %s updated']",
              shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
      waitUntilInvisibilityOfElementLocated(
          f("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Shipment %s updated']",
              shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

  }

  public static class ShipmentEventsTable extends MdVirtualRepeatTable<ShipmentEvent> {

    public static final String MD_VIRTUAL_REPEAT = "p in getTableData()";
    public static final String SOURCE = "source";
    public static final String USER_ID = "userId";
    public static final String RESULT = "result";
    public static final String HUB = "hub";
    public static final String CREATED_AT = "createdAt";

    public ShipmentEventsTable(WebDriver webDriver) {
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

  public static class MovementEventsTable extends MdVirtualRepeatTable<MovementEvent> {

    public static final String MD_VIRTUAL_REPEAT = "p in getTableData()";
    public static final String SOURCE = "source";
    public static final String STATUS = "status";
    public static final String CREATED_AT = "createdAt";
    public static final String COMMENTS = "comments";

    public MovementEventsTable(WebDriver webDriver) {
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

  public static class CancelShipmentDialog extends MdDialog {

    @FindBy(xpath = "//Button//span[.='Cancel Shipment']")
    public Button cancelShipment;

    @FindBy(xpath = "//Button//span[.='Cancel']")
    public Button cancel;

    public CancelShipmentDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ForceCompleteDialog extends MdDialog {

    @FindBy(xpath = "//Button//span[.='Confirm']")
    public Button confirm;

    @FindBy(xpath = "//Button//span[.='Cancel']")
    public Button cancel;

    public ForceCompleteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class BulkUpdateShipmentDialog extends MdDialog {

    @FindBy(xpath = "//button[@aria-label='Apply to Selected']")
    public Button applyToSelected;

    @FindBy(xpath = "//md-input-container[contains(@model,'shipment_type')]//md-checkbox")
    public MdCheckbox shipmentTypeEnable;

    @FindBy(xpath = "//md-input-container[contains(@model,'orig_hub_id')]//md-checkbox")
    public MdCheckbox startHubEnable;

    @FindBy(xpath = "//md-input-container[contains(@model,'dest_hub_id')]//md-checkbox")
    public MdCheckbox destHubEnable;

    @FindBy(xpath = "//md-input-container[contains(@model,'eda')]//md-checkbox")
    public MdCheckbox edaEnable;

    @FindBy(xpath = "//md-input-container[contains(@model,'eta')]//md-checkbox")
    public MdCheckbox etaEnable;

    @FindBy(xpath = "//md-input-container[contains(@model,'mawb')]//md-checkbox")
    public MdCheckbox mawbEnable;

    @FindBy(xpath = "//md-input-container[contains(@model,'comments')]//md-checkbox")
    public MdCheckbox commentsEnable;

    @FindBy(css = "[aria-label='Shipment Type']")
    public MdSelect shipmentType;

    @FindBy(css = "[aria-label='Start Hub']")
    public MdSelect startHub;

    @FindBy(css = "[aria-label='End Hub']")
    public MdSelect endHub;

    @FindBy(xpath = "//md-datepicker[@name='EDA']//div//input")
    public PageElement edaInput;

    @FindBy(css = "[aria-label='select-hour']")
    public MdSelect etaSelectHour;

    @FindBy(css = "[aria-label='select-minute']")
    public MdSelect etaSelectMinute;

    @FindBy(css = "[aria-label='MAWB']")
    public PageElement mawbInput;

    @FindBy(css = "[aria-label='Comments']")
    public PageElement commentsInput;

    public BulkUpdateShipmentDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ShipmentToBeUpdatedTable extends PageElement {

    @FindBy(xpath = "//div[contains(@class,'shipment-bulk-description')]//div")
    public TextBox fieldToBeUpdated;

    @FindBy(xpath = "//nv-icon-button[@name='Remove']")
    public List<NvIconButton> removeButtons;

    @FindBy(xpath = "//td[contains(@class,'shipment-id')]")
    public List<TextBox> shipmentIds;

    @FindBy(xpath = "//i[.='check']")
    public List<PageElement> checkLists;

    @FindBy(css = "[aria-label='Back to Shipment Management']")
    public Button backButton;

    public ShipmentToBeUpdatedTable(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }

  public static class ConfirmBulkUpdateDialog extends MdDialog {

    @FindBy(xpath = "//div[@class='md-dialog-content-body']")
    public TextBox confirmDialogContent;

    @FindBy(css = "[aria-label='Proceed']")
    public Button proceed;

    @FindBy(css = "[aria-label='Cancel']")
    public Button cancel;

    public ConfirmBulkUpdateDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}