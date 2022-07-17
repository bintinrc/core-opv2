package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.pdf.ShipmentAirwayBill;
import co.nvqa.commons.util.PdfUtils;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.MovementEvent;
import co.nvqa.operator_v2.model.ShipmentEvent;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterDateTimeRange;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenu;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.time.Duration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;

import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.ACTION_CANCEL;
import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.ACTION_DETAILS;
import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.ACTION_FORCE;
import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.ACTION_PRINT;
import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.COLUMN_SHIPMENT_ID;
import static org.hamcrest.Matchers.allOf;
import static org.hamcrest.Matchers.contains;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class NewShipmentManagementPage extends SimpleReactPage<NewShipmentManagementPage> {

  private static final String LOCATOR_SELCT_FILTERS_PRESET = "commons.preset.load-filter-preset";
  private static final String XPATH_SHIPMENT_SCAN = "//div[contains(@class,'table-shipment-scan-container')]/table/tbody/tr";
  private static final String XPATH_CLOSE_SCAN_MODAL_BUTTON = "//button[@aria-label='Cancel']";
  private static final String XPATH_CLEAR_FILTER_BUTTON = "//button[@aria-label='Clear All Selections']";
  private static final String XPATH_CLEAR_FILTER_VALUE = "//button[@aria-label='Clear All']";
  private static final String XPATH_CHECKBOX_ON_SHIPMENT_TABLE = "//td[@class='id']/following-sibling::td[@class='column-checkbox']//md-checkbox[@ng-checked='table.isSelected(shipment)']//div[@class='md-icon']";
  private static final String XPATH_SECOND_CHECKBOX_ON_SHIPMENT_TABLE = "(//md-checkbox)[2]";
  private static final String XPATH_APPLY_ACTION_BUTTON = "//button[@ng-click='$mdOpenMenu($event)' and @aria-label='Action']";
  private static final String XPATH_REOPEN_SHIPMENT_OPTION = "//button[@ng-click='ctrl.reopenShipment($event, ctrl.tableParam.getSelection())']";
  private static final String XPATH_SEARCH_BY_SHIPMENT_ID = "//textarea[@id='shipment-ids']";
  private static final String XPATH_SEARCH_SHIPMENT_BUTTON = "//button[contains(@class,'shipment-search-btn')]";
  private static final String XPATH_SEARCH_SHIPMENT_ID_FILTER = "//th[@class='id']//input[@ng-model='searchText']";
  private static final String XPATH_SHIPMENT_ID_RESULT_TABLE = "//td[@nv-table-highlight='filter.id']";
  private static final String XPATH_SHIPMENT_ID_DUPLICATED = "//span[@ng-if='ctrl.duplicateCount!==0']";
  private static final String XPATH_SHIPMENT_SEARCH_ERROR_MODAL = "//md-dialog[contains(@class,'shipment-search-error')]";
  private static final String XPATH_SHIPMENT_SEARCH_ERROR_MODAL_OK_BUTTON = "//nv-icon-text-button[@on-click='ctrl.onCancel($event)']/button";
  private static final String XPATH_SHIPMENT_SEARCH_ERROR_MODAL_SHOW_SHIPMENT_BUTTON = "//nv-icon-text-button[@on-click='ctrl.onOk($event)']/button";

  private static final String XPATH_SHIPMENTWEIGHTANDDIMENSION = "//button[.='Shipment Weight & Dimension page']";

  private static final String XPATH_SEARCHBYSIDSUBMIT = "//button[@data-testid='search-by-sid-submit']";

  @FindBy(id = "search-by-sid_searchIds")
  public PageElement sidsTextArea;

  @FindBy(xpath = "//input[@class='ant-checkbox-input']")
  public CheckBox selectAllCheckbox;

  @FindBy(xpath = "//input[@id='updateMAWBForm_mawb']")
  public PageElement inputUpdateMawb;

  @FindBy(xpath = "//input[@id='updateMAWBForm_vendor_id']")
  public PageElement inputUpdateMawbVendor;

  public String inputUpdateMawbOriginAirport = "//input[@id='updateMAWBForm_origin_airport_id']";

  public String inputUpdateMawbDestinationAirport = "//input[@id='updateMAWBForm_destination_airport_id']";

  public ShipmentsTable shipmentsTable;
  public ShipmentEventsTable shipmentEventsTable;
  public MovementEventsTable movementEventsTable;

  @FindBy(css = "[data-testid='bulk-update-confirmation-section']")
  public ShipmentToBeUpdatedTable shipmentToBeUpdatedTable;

  @FindBy(css = "[data-testid='create-shipment-button']")
  public Button createShipment;

  @FindBy(css = "[data-testid='search-id-textarea']")
  public TextBox shipmentIds;

  @FindBy(css = "[data-testid='search-by-sid-submit']")
  public Button searchByShipmentIds;

  @FindBy(xpath = ".//div[contains(@class,'ant-modal')][.//div[.='Upload Results']]")
  public UploadResultsDialog uploadResultsDialog;

  @FindBy(css = ".ant-modal")
  public CreateShipmentDialog createShipmentDialog;

  @FindBy(css = ".ant-modal")
  public EditShipmentDialog editShipmentDialog;

  @FindBy(css = "md-dialog")
  public ForceCompleteDialog forceCompleteDialog;

  @FindBy(css = ".ant-modal")
  public CancelShipmentDialog cancelShipmentDialog;

  @FindBy(css = ".ant-modal")
  public BulkUpdateShipmentDialog bulkUpdateShipmentDialog;

  @FindBy(css = ".ant-modal")
  public ConfirmBulkUpdateDialog confirmBulkUpdateDialog;

  @FindBy(css = "[id^='commons.preset.load-filter-preset']")
  public MdSelect filterPresetSelector;

  @FindBy(css = ".ant-checkbox-wrapper:not(.ant-checkbox-wrapper-checked)")
  private CheckBox uncheckedShipmentCheckBox;

  @FindBy(css = "[data-testid='load-selection-button']")
  public Button loadSelection;

  @FindBy(css = "[data-testid='add-filter-select']")
  public AntSelect3 addFilter;

  @FindBy(css = "[data-testid='created_date-filter-card']")
  public AntFilterDateTimeRange shipmentDateFilter;

  @FindBy(css = "[data-testid='shipment_status-filter-card']")
  public AntFilterSelect3 shipmentStatusFilter;

  @FindBy(css = "[data-testid='shipment_type-filter-card']")
  public AntFilterSelect3 shipmentTypeFilter;

  @FindBy(css = "[data-testid='orig_hub-filter-card']")
  public AntFilterSelect3 originHubFilter;

  @FindBy(css = "[data-testid='curr_hub-filter-card']")
  public AntFilterSelect3 lastInboundHubFilter;

  @FindBy(css = "[data-testid='dest_hub-filter-card']")
  public AntFilterSelect3 destinationHubFilter;

  @FindBy(css = "[data-testid='transit_date-filter-card']")
  public AntFilterDateTimeRange transitDateTimeFilter;

  @FindBy(css = "[data-testid='arrival_date-filter-card']")
  public AntFilterDateTimeRange etaDateTimeFilter;

  @FindBy(css = "[data-testid='completed_date-filter-card']")
  public AntFilterDateTimeRange shipmentCompletionDateFilter;

  @FindBy(css = "[data-testid='mawb-filter-card']")
  public AntFilterSelect3 mawbFilter;

  @FindBy(css = "th .ant-dropdown-trigger")
  public AntMenu tableActionsMenu;

  @FindBy(css = "[data-testid='apply-action-button']")
  public AntMenu actionsMenu;

  @FindBy(xpath = ".//button[.='Edit Filters']")
  public Button editFilters;

  private static final String FILEPATH = TestConstants.TEMP_DIR;

  public NewShipmentManagementPage(WebDriver webDriver) {
    super(webDriver);
    shipmentsTable = new ShipmentsTable(webDriver);
    shipmentEventsTable = new ShipmentEventsTable(webDriver);
    movementEventsTable = new MovementEventsTable(webDriver);
  }

  public void switchToOtherWindow() {
    waitUntilNewWindowOrTabOpened();
    Set<String> windowHandles = getWebDriver().getWindowHandles();

    for (String windowHandle : windowHandles) {
      getWebDriver().switchTo().window(windowHandle);
    }
  }

  public void addFilter(String filterLabel, String value, boolean isMawb) {

    if (!isMawb) {
      selectValueFromNvAutocompleteByItemTypesAndDismiss(filterLabel, value);
    } else {
      sendKeysAndEnter("//input[@ng-model='search' and contains(@id,'input')]", value);
    }
    pause1s();
  }


  public void changeDate(String field, String date, boolean isFromDate) {
    String datepickerXpath = "//div//p[contains(.,'" + field
        + "')]//parent::div//parent::div//md-datepicker[@ng-model='%s']//input";
    if (isFromDate) {
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
    pause2s();
    clickButtonByAriaLabel("Action");
    clickButtonByAriaLabel("Delete Preset");
    waitUntilVisibilityOfElementLocated("//md-dialog-content//div[.='Select a preset to delete']");
    waitUntilElementIsClickable("//md-select[contains(@aria-label,'Select preset')]");
    selectValueFromMdSelectByAriaLabel("Select preset", presetName);
    clickNvIconTextButtonByName("commons.delete");
    waitUntilVisibilityOfToast("1 filter preset deleted");
  }

  public void verifyFiltersPresetWasDeleted(String presetName) {
    assertThat("Preset [" + presetName + "] exists in presets list",
        getMdSelectMultipleValuesById(LOCATOR_SELCT_FILTERS_PRESET), not(contains(presetName)));
  }

  public void verifySelectedFilters(Map<String, String> filters) {
    filters.forEach((filter, expectedValue) -> {
      String actualValue = getAttribute("aria-label",
          "//nv-filter-box[@item-types='%s']//nv-icon-text-button[@ng-repeat]", filter);
      assertThat(filter + " filter selected value", actualValue, equalTo(expectedValue));
    });
  }

  public void checkErrorMessageShipmentCreation() {
    Assertions.assertThat(createShipmentDialog.startHubError.isDisplayedFast())
        .withFailMessage("Error Message in Origin Hub Form is not displayed").isTrue();
    Assertions.assertThat(createShipmentDialog.endHubError.isDisplayedFast())
        .withFailMessage("Error Message in Destination Hub Form is not displayed").isTrue();
  }

  public boolean checkErrMsgExist() {
    return createShipmentDialog.startHubError.isDisplayedFast()
        || createShipmentDialog.endHubError.isDisplayedFast();
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
    createShipmentDialog.startHub.selectValue(shipmentInfo.getOrigHubName());
    createShipmentDialog.endHub.selectValue(shipmentInfo.getDestHubName());
    createShipmentDialog.comments.setValue(shipmentInfo.getComments());

    if (isNextOrder) {
      createShipmentDialog.createAnother.click();
    } else {
      createShipmentDialog.create.click();
    }
    shipmentInfo.setId(getNewShipperId());
  }

  public long getNewShipperId() {
    String pattern = "Created new shipment (\\d+)";
    String toastMessage = waitAndGetNoticeText(pattern, true);
    Pattern p = Pattern.compile(pattern);
    Matcher m = p.matcher(toastMessage);
    m.find();
    return Long.parseLong(m.group(1));
  }

  public void createNewShipment(ShipmentInfo shipmentInfo) {
    createShipment.click();
    createShipmentDialog.waitUntilVisible();
    createShipmentDialog.type.selectValue(shipmentInfo.getShipmentDialogType());
    createShipmentDialog.startHub.selectValue(shipmentInfo.getOrigHubName());
    createShipmentDialog.endHub.selectValue(shipmentInfo.getDestHubName());
    createShipmentDialog.comments.setValue(shipmentInfo.getComments());
  }

  public void submitNewShipment(boolean isNextOrder) {
    if (isNextOrder) {
      createShipmentDialog.createAnother.click();
    } else {
      createShipmentDialog.create.click();
    }
  }

  public Long createAnotherShipment() {
    createShipmentDialog.createAnother.click();
    return getNewShipperId();
  }

  public void editShipment(ShipmentInfo shipmentInfo) {
    clickActionButton(shipmentInfo.getId(), ACTION_EDIT);

    editShipmentDialog.waitUntilVisible();
    editShipmentDialog.startHub.selectValue(shipmentInfo.getOrigHubName());
    editShipmentDialog.endHub.selectValue(shipmentInfo.getDestHubName());
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
    editShipmentDialog.waitUntilVisible();
    Assertions.assertThat(editShipmentDialog.comments.isEnabled())
        .as("Comments field is emabled")
        .isFalse();
    editShipmentDialog.ok.click();
  }

  public void clickActionButton(Long shipmentId, String actionButton) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    shipmentsTable.clickActionButton(1, actionButton);
    pause200ms();
  }

  public void openShipmentDetailsPage(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    pause3s();
    shipmentsTable.clickActionButton(1, ACTION_DETAILS);
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
    waitAndGetNoticeText("Successfully changed status to Cancelled for Shipment ID " + shipmentId,
        false);
  }

  public void openAwb(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    shipmentsTable.clickActionButton(1, ACTION_PRINT);
    pause100ms();
    switchToOtherWindow();
  }

  public void validateShipmentInfo(Long shipmentId, ShipmentInfo expectedShipmentInfo) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    waitWhileTableIsLoading();
    ShipmentInfo actualShipmentInfo = shipmentsTable.readEntity(1);
    expectedShipmentInfo.compareWithActual(actualShipmentInfo);
  }

  private void waitWhileTableIsLoading() {
    Wait<ShipmentsTable> fWait = new FluentWait<>(shipmentsTable)
        .withTimeout(Duration.ofSeconds(20))
        .pollingEvery(Duration.ofSeconds(1))
        .ignoring(NoSuchElementException.class);
    fWait.until(table -> table.getRowsCount() > 0);
  }

  public void validateShipmentStatusPending(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    ShipmentInfo actualShipmentInfo = shipmentsTable.readEntity(1);
    assertThat("shipment Id is the same", actualShipmentInfo.getId(), equalTo(shipmentId));
    assertThat("shipment status is the same", actualShipmentInfo.getStatus(), equalTo("Pending"));
  }

  public void validateShipmentId(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    ShipmentInfo actual = shipmentsTable.readEntity(1);
    Assertions.assertThat(actual.getId())
        .withFailMessage("Shipment with ID %s " + shipmentId + " was not found")
        .isEqualTo(shipmentId);
  }

  public void verifyOpenedShipmentDetailsPageIsTrue(Long shipmentId, String trackingId) {
    String expectedTextShipmentDetails = f("Shipment ID : %d", shipmentId);
    String actualTextShipmentDetails = getText(
        "//md-content[contains(@class,'nv-shipment-details')]//h3");
    Assertions.assertThat(actualTextShipmentDetails)
        .as("Shipment ID is same: ", expectedTextShipmentDetails);
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
    retryIfAssertionErrorOccurred(() -> {
      try {
        shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
        Assertions.assertThat(shipmentsTable.readEntity(1).getId()).as("Shipment Id:")
            .isEqualTo(shipmentId);
      } catch (AssertionError ex) {
        editFilters.click();
        loadSelection.click();
        throw ex;
      }
    }, "retry Inbounded Shipment Exist", 500, 10);
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

  public void editShipmentBy(String editType, ShipmentInfo shipmentInfo,
      Map<String, String> resolvedMapOfData) {
    clickActionButton(shipmentInfo.getId(), ACTION_EDIT);
    editShipmentDialog.waitUntilVisible();
    if ("Start Hub".equals(editType)) {
      editShipmentDialog.startHub.selectValue(shipmentInfo.getOrigHubName());
    }
    if ("End Hub".equals(editType)) {
      editShipmentDialog.endHub.selectValue(shipmentInfo.getDestHubName());
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
      editShipmentDialog.startHub.selectValue(shipmentInfo.getOrigHubName());
      editShipmentDialog.endHub.selectValue(shipmentInfo.getDestHubName());
      editShipmentDialog.comments.setValue(shipmentInfo.getComments());
    }
    if ("mawb".equals(editType)) {
      editMawbInShipmentManagement(shipmentInfo, resolvedMapOfData, "");
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
    waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'shipment-search-error')]");
    Assertions.assertThat(getToastText(XPATH_SHIPMENT_SEARCH_ERROR_MODAL + "//p[1]"))
        .as("toast message is the same").matches("We cannot find following .* shipment ids:");
    Assertions.assertThat(getToastText(XPATH_SHIPMENT_SEARCH_ERROR_MODAL + "//p[2]"))
        .as("toast message is the same").contains("");
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
    uploadResultsDialog.close();
    editShipmentDialog.saveChanges.click();
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
    final String filePath = FILEPATH + fileName + ".csv";
    clickActionButton(shipmentInfo.getId(), ACTION_EDIT);
    editShipmentDialog.waitUntilVisible();
    editShipmentDialog.uploadFile.setValue(filePath);
    uploadResultsDialog.waitUntilVisible();

    int actualNumberOfOrder = Integer.parseInt(
        uploadResultsDialog.uploadedOrders.getText().replace("Uploaded Orders", "").trim());
    int successfulOrder = Integer.parseInt(
        uploadResultsDialog.successful.getText().replace("Successful", "").trim());
    int failedOrder = Integer.parseInt(
        uploadResultsDialog.failed.getText().replace("Failed", "").trim());
    pause1s();
    if (isValid) {
      if (isDuplicated) {
        assertEquals("Number of Order is not the same", actualNumberOfOrder, numberOfOrder + 1);
        assertEquals("Failed Order(s) : ", failedOrder, 1);
        String actualFailedReason = uploadResultsDialog.failedReasons.get(0).getText();
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

  public void bulkUpdateShipment(Map<String, String> resolvedMapOfData, List<Long> shipmentIds) {
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
    if (resolvedMapOfData.get("comments") != null) {
      String comments = resolvedMapOfData.get("comments");
      bulkUpdateShipmentDialog.commentsEnable.check();
      bulkUpdateShipmentDialog.commentsInput.sendKeys(comments);
    }
    bulkUpdateShipmentDialog.applyToSelected.click();
  }

  public void bulkMawbUpdateShipment(Map<String, String> resolvedMapOfData,
      List<Long> shipmentIds) {
    if (resolvedMapOfData.get("mawb") != null) {
      ShipmentInfo shipmentInfo = new ShipmentInfo();
      String ids = "";
      for (Long shipmentId : shipmentIds) {
        ids = ids + shipmentId + "\n";
      }
      shipmentInfo.setMawb(
          "12" + resolvedMapOfData.get("mawb").substring(0, 1) + "-" + resolvedMapOfData.get("mawb")
              .substring(1));
      editMawbInShipmentManagement(shipmentInfo, resolvedMapOfData, ids.trim());
    }
  }

  public void verifyShipmentToBeUpdatedData(List<Long> shipmentIds,
      Map<String, String> resolvedMapOfData) {
    shipmentToBeUpdatedTable.waitUntilVisible();
    String fieldToBeUpdated = shipmentToBeUpdatedTable.fieldToBeUpdated.getText()
        .split(":")[1].trim();
    if (resolvedMapOfData.get("shipmentType") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("Shipment Type"));
    }
    if (resolvedMapOfData.get("startHub") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("Origin Hub"));
    }
    if (resolvedMapOfData.get("endHub") != null) {
      assertThat("Field is the same", fieldToBeUpdated, containsString("Destination Hub"));
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
        .map(PageElement::getText).collect(Collectors.toList());

    if (resolvedMapOfData.get("removeShipment") != null) {
      String whichShipment = resolvedMapOfData.get("removeShipment");
      if ("second".equals(whichShipment)) {
        int count = shipmentToBeUpdatedTable.shipmentIds.size();
        int index = 0;
        List<String> shipIds = shipmentIds.stream().map(Objects::toString)
            .collect(Collectors.toList());
        String shipmentId = shipIds.remove(1);
        for (int i = 0; i < count; i++) {
          if (StringUtils.equals(shipmentId,
              shipmentToBeUpdatedTable.shipmentIds.get(i).getText())) {
            index = i;
            break;
          }
        }
        shipmentToBeUpdatedTable.removeButtons.get(index).click();
        pause1s();
        actualShipmentIds = shipmentToBeUpdatedTable.shipmentIds.stream().map(PageElement::getText)
            .collect(Collectors.toList());
        Assertions.assertThat(actualShipmentIds).as("List of displayed shipment ids")
            .containsExactlyElementsOf(shipIds);
        return;
      }
    }

    Assertions.assertThat(actualShipmentIds).as("List of displayed shipment ids")
        .containsExactlyInAnyOrderElementsOf(
            shipmentIds.stream().map(Objects::toString).collect(Collectors.toList()));
  }

  public void confirmUpdateBulk(Map<String, String> resolvedMapOfData) {
    if (resolvedMapOfData.get("abort") != null) {
      shipmentToBeUpdatedTable.abortUpdates.click();
      pause1s();
      return;
    }
    if (resolvedMapOfData.get("modifySelection") != null) {
      shipmentToBeUpdatedTable.modifySelectionButton.click();
      pause1s();
      return;
    }
    shipmentToBeUpdatedTable.confirmUpdates.click();

    confirmBulkUpdateDialog.waitUntilVisible();
    String[] confirmUpdateContent = confirmBulkUpdateDialog.confirmDialogContent.getText()
        .split("\n");
    String shipmentField = confirmUpdateContent[0].split(":")[1].trim();
    Long numberOfRecords = Long.valueOf(confirmUpdateContent[1].split(":")[1].trim());
    if (resolvedMapOfData.get("shipmentType") != null) {
      assertThat("field is equal", shipmentField, containsString("Shipment Type"));
    }
    if (resolvedMapOfData.get("startHub") != null) {
      assertThat("field is equal", shipmentField, containsString("Origin Hub"));
    }
    if (resolvedMapOfData.get("endHub") != null) {
      assertThat("field is equal", shipmentField, containsString("Destination Hub"));
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

    pause3s();
    String fieldInfo = shipmentToBeUpdatedTable.fieldToBeUpdated.getText().split(": ")[0];
    SoftAssertions assertions = new SoftAssertions();
    assertions.assertThat(fieldInfo).as("Update status").isEqualTo("Field successfully updated");
    assertions.assertThat(shipmentToBeUpdatedTable.checkLists).as("Number of checked shipments")
        .hasSize(2);
    shipmentToBeUpdatedTable.done.click();
  }

  public void validateShipmentUpdated(Long shipmentId, Map<String, String> resolvedMapOfData) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    ShipmentInfo actualShipmentInfo = shipmentsTable.readEntity(1);
    assertThat("Shipment id is the same", actualShipmentInfo.getId(), equalTo(shipmentId));
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
      assertThat("EDA is the same", eda, equalTo(resolvedMapOfData.get("EDA").toLowerCase()));
    }
    if (resolvedMapOfData.get("ETA") != null) {
      String eta = actualShipmentInfo.getArrivalDatetime().toLowerCase().split(" ")[1];
      assertThat("ETA is the same", eta, equalTo(resolvedMapOfData.get("ETA").toLowerCase()));
    }
    if (resolvedMapOfData.get("mawb") != null) {
      String mawb = actualShipmentInfo.getMawb().toLowerCase();
      String expected =
          "12" + resolvedMapOfData.get("mawb").substring(0, 1) + "-" + resolvedMapOfData.get("mawb")
              .substring(1);
      assertThat("MAWB is the same", mawb, equalTo(expected));
    }
    if (resolvedMapOfData.get("comments") != null) {
      String comments = actualShipmentInfo.getComments().toLowerCase();
      assertThat("Comments is the same", comments,
          equalTo(resolvedMapOfData.get("comments").toLowerCase()));
    }
  }

  public void selectAnotherShipmentAndVerifyCount() {
    uncheckedShipmentCheckBox.check();
    tableActionsMenu.selectOption("Show Only Selected");
    pause3s();

    Assertions.assertThat(shipmentsTable.getRowsCount())
        .as("Count of displayed shipments")
        .isEqualTo(3);
  }

  public void editMawbInShipmentManagement(ShipmentInfo shipmentInfo,
      Map<String, String> resolvedMapOfData, String bulkIds) {
    waitUntilVisibilityOfElementLocated(XPATH_SHIPMENTWEIGHTANDDIMENSION);
    click(XPATH_SHIPMENTWEIGHTANDDIMENSION);
    waitUntilNewWindowOrTabOpened();
    switchToOtherWindow();
    switchTo();
    if (bulkIds.equals("")) {
      searchMawbByShipmentId(String.valueOf(shipmentInfo.getId()));
    } else {
      searchMawbByShipmentId(bulkIds);
    }
    updateMawbDetails(shipmentInfo, resolvedMapOfData);
    closeShipmentDimentionAndMoveToShipmentManagement();
  }

  public void searchMawbByShipmentId(String shipmentId) {
    waitUntilVisibilityOfElementLocated("//textarea[@id='search-by-sid_searchIds']");
    sidsTextArea.sendKeys(shipmentId);
    waitUntilVisibilityOfElementLocated(XPATH_SEARCHBYSIDSUBMIT);
    click(XPATH_SEARCHBYSIDSUBMIT);
    waitUntilVisibilityOfElementLocated("//div[contains(@class,'ant-modal-content')]");
    click("//button[@data-testid='result-error-close-button']");
  }

  public void updateMawbDetails(ShipmentInfo shipmentInfo, Map<String, String> resolvedMapOfData) {
    selectAllCheckbox.click();
    pause2s();
    click("//button[contains(.,'Update MAWB')]");
    inputUpdateMawb.sendKeys(shipmentInfo.getMawb());
    TestUtils.findElementAndClick("//input[@id='updateMAWBForm_vendor_id']", "xpath",
        getWebDriver());
    sendKeysAndEnter("//input[@id='updateMAWBForm_vendor_id']",
        resolvedMapOfData.get("mawbVendor"));
    TestUtils.findElementAndClick(inputUpdateMawbOriginAirport, "xpath", getWebDriver());
    sendKeysAndEnter(inputUpdateMawbOriginAirport, resolvedMapOfData.get("MawbOrigin"));
    TestUtils.findElementAndClick(inputUpdateMawbDestinationAirport, "xpath", getWebDriver());
    sendKeysAndEnter(inputUpdateMawbDestinationAirport, resolvedMapOfData.get("MawbDestination"));
    click("//button[@data-testid='mawb-update-submit-button']");
    waitUntilVisibilityOfElementLocated("//div[@class='ant-message-notice'][last()]");
  }

  public void closeShipmentDimentionAndMoveToShipmentManagement() {
    getWebDriver().close();
    for (String handle1 : getWebDriver().getWindowHandles()) {
      getWebDriver().switchTo().window(handle1).switchTo();
    }
  }

  /**
   * Accessor for Shipments table
   */
  public static class ShipmentsTable extends AntTableV3<ShipmentInfo> {

    public static final String COLUMN_SHIPMENT_TYPE = "shipmentType";
    public static final String COLUMN_SHIPMENT_ID = "id";
    public static final String COLUMN_USER_ID = "userId";
    public static final String COLUMN_ENTRY_SOURCE = "entrySource";
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

    public ShipmentsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder().put(COLUMN_SHIPMENT_TYPE, "shipment_type")
              .put(COLUMN_SHIPMENT_ID, "id").put(COLUMN_USER_ID, "user_id")
              .put(COLUMN_ENTRY_SOURCE, "shipment_entry_source")
              .put(COLUMN_CREATION_DATE_TIME, "created_at")
              .put(COLUMN_TRANSIT_DATE_TIME, "transit_at").put(COLUMN_STATUS, "status")
              .put(COLUMN_START_HUB, "orig_hub_name").put(COLUMN_LAST_INBOUND_HUB, "curr_hub_name")
              .put(COLUMN_END_HUB, "dest_hub_name").put(COLUMN_ETA_DATE_TIME, "arrival_datetime")
              .put(COLUMN_SLA_DATE_TIME, "sla").put(COLUMN_COMPLETION_DATE_TIME, "completed_at")
              .put(COLUMN_TOTAL_PARCELS, "orders_count").put(COLUMN_COMMENTS, "comments")
              .put(COLUMN_MAWB, "mawb").build());
      setEntityClass(ShipmentInfo.class);
      setActionButtonLocatorTemplate(
          "//tbody/tr[%d]//td[contains(@class,'actions')]//*[contains(@data-testid,'%s')]");
      setActionButtonsLocators(
          ImmutableMap.of(
              ACTION_EDIT, "edit-shipment-icon",
              ACTION_DETAILS, "view-details-icon",
              ACTION_PRINT, "print-icon",
              "Print Label", "print-label-icon",
              ACTION_CANCEL, "cancel-shipment-icon"));
    }
  }

  public static class CreateShipmentDialog extends AntModal {

    public CreateShipmentDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='create-shipment-type-select']")
    public AntSelect3 type;

    @FindBy(css = "[data-testid='create-shipment-origin-hub-select']")
    public AntSelect3 startHub;

    @FindBy(css = "[data-testid='create-shipment-destination-hub-select']")
    public AntSelect3 endHub;

    @FindBy(css = "[data-testid='create-shipment-comment-input']")
    public TextBox comments;

    @FindBy(css = "[data-testid='confirm-create-shipment-button']")
    public Button create;

    @FindBy(css = "[data-testid='confirm-create-another-shipment-button']")
    public Button createAnother;

    @FindBy(xpath = "(.//*[contains(@class,'ant-form-item-explain-error')])[1]")
    public PageElement startHubError;

    @FindBy(xpath = "(.//*[contains(@class,'ant-form-item-explain-error')])[2]")
    public PageElement endHubError;

  }

  public static class EditShipmentDialog extends AntModal {

    public EditShipmentDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='edit-shipment-type-select']")
    public AntSelect3 type;

    @FindBy(css = "[data-testid='edit-shipment-origin-hub-select']")
    public AntSelect3 startHub;

    @FindBy(css = "[data-testid='edit-shipment-destination-hub-select']")
    public AntSelect3 endHub;

    @FindBy(css = "[data-testid='edit-shipment-comment-input']")
    public TextBox comments;

    @FindBy(id = "master-awb")
    public TextBox mawb;

    @FindBy(css = "[data-testid='confirm-edit-shipment-button']")
    public Button saveChanges;

    @FindBy(css = "[data-testid='viewonly-ok-edit-shipment-button']")
    public Button ok;

    @FindBy(css = "[data-testid='upload-orders-file']")
    public FileInput uploadFile;

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
    public static final String XPATH_TABLE_DATA = "//div[contains(@id,'shipment-events')]//tr[./td[.='%s']]//td";

    public ShipmentEventsTable(WebDriver webDriver) {
      super(webDriver);
      setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
      setColumnLocators(
          ImmutableMap.<String, String>builder().put(SOURCE, "source").put(USER_ID, "user_id")
              .put(RESULT, "result").put(HUB, "hub").put(CREATED_AT, "created_at").build());
      setEntityClass(ShipmentEvent.class);
      setNvTableParam("ctrl.tableParamScans");
    }

    public Map<String, String> readShipmentEventsTable(String source) {
      waitUntilVisibilityOfElementLocated(f(XPATH_TABLE_DATA, source));
      List<String> list = getTextOfElements(f(XPATH_TABLE_DATA, source));
      Assertions.assertThat(list.size())
          .as(f("There is no [%s] shipment event on Shipment Details page", source))
          .isNotEqualTo(0);
      Map<String, String> eventsTable = new HashMap<>();
      eventsTable.put(SOURCE, list.get(0));
      eventsTable.put(USER_ID, list.get(1));
      eventsTable.put(RESULT, list.get(2));
      eventsTable.put(HUB, list.get(3));
      eventsTable.put(CREATED_AT, list.get(4));
      return eventsTable;
    }
  }

  public static class MovementEventsTable extends MdVirtualRepeatTable<MovementEvent> {

    public static final String MD_VIRTUAL_REPEAT = "p in getTableData()";
    public static final String SOURCE = "source";
    public static final String STATUS = "status";
    public static final String CREATED_AT = "createdAt";
    public static final String COMMENTS = "comments";
    public static final String XPATH_TABLE_DATA = "//div[contains(@id,'movement-events')]//tr[./td[.='%s']]//td";

    public MovementEventsTable(WebDriver webDriver) {
      super(webDriver);
      setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
      setColumnLocators(
          ImmutableMap.<String, String>builder().put(SOURCE, "source").put(STATUS, "status")
              .put(CREATED_AT, "created_at").put(COMMENTS, "comments").build());
      setEntityClass(MovementEvent.class);
      setNvTableParam("ctrl.tableParamEvents");
    }

    public Map<String, String> readMovementEventsTable(String source) {
      waitUntilVisibilityOfElementLocated(f(XPATH_TABLE_DATA, source));
      List<String> list = getTextOfElements(f(XPATH_TABLE_DATA, source));
      Assertions.assertThat(list.size())
          .as(f("There is no [%s] movement event on Shipment Details page", source))
          .isNotEqualTo(0);
      Map<String, String> eventsTable = new HashMap<>();
      eventsTable.put(SOURCE, list.get(0));
      eventsTable.put(STATUS, list.get(1));
      eventsTable.put(CREATED_AT, list.get(2));
      eventsTable.put(COMMENTS, list.get(3));
      return eventsTable;
    }
  }

  public static class CancelShipmentDialog extends MdDialog {

    @FindBy(xpath = ".//button[.='Cancel Shipment']")
    public Button cancelShipment;

    @FindBy(xpath = ".//button[.='Cancel']")
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

  public static class BulkUpdateShipmentDialog extends AntModal {

    @FindBy(xpath = ".//button[.='Apply To Selected']")
    public Button applyToSelected;

    @FindBy(css = "input[value='shipment_type']")
    public CheckBox shipmentTypeEnable;

    @FindBy(css = "input[value='orig_hub_id']")
    public CheckBox startHubEnable;

    @FindBy(css = "input[value='dest_hub_id']")
    public CheckBox destHubEnable;

    @FindBy(css = "input[value='comments']")
    public MdCheckbox commentsEnable;

    @FindBy(xpath = ".//div[contains(@class,'ant-select')][.//input[@id='shipment_type']]")
    public AntSelect3 shipmentType;

    @FindBy(xpath = ".//div[contains(@class,'ant-select')][.//input[@id='orig_hub_id']]")
    public AntSelect3 startHub;

    @FindBy(xpath = ".//div[contains(@class,'ant-select')][.//input[@id='dest_hub_id']]")
    public AntSelect3 endHub;
    @FindBy(id = "comments")
    public TextBox commentsInput;

    public BulkUpdateShipmentDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ShipmentToBeUpdatedTable extends PageElement {

    @FindBy(css = "span.ant-typography")
    public TextBox fieldToBeUpdated;

    @FindBy(css = "td > button")
    public List<Button> removeButtons;

    @FindBy(css = "tr > td.ant-table-cell:nth-child(3)")
    public List<PageElement> shipmentIds;

    @FindBy(css = "span[aria-label='check']")
    public List<PageElement> checkLists;

    @FindBy(xpath = ".//button[.='Confirm Updates']")
    public Button confirmUpdates;

    @FindBy(xpath = ".//button[.='Abort Updates']")
    public Button abortUpdates;

    @FindBy(xpath = ".//button[.='Done']")
    public Button done;

    @FindBy(xpath = ".//button[.='Modify Selection']")
    public Button modifySelectionButton;

    public ShipmentToBeUpdatedTable(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }

  public static class ConfirmBulkUpdateDialog extends MdDialog {

    @FindBy(css = ".ant-space-item")
    public TextBox confirmDialogContent;

    @FindBy(xpath = ".//button[.='Proceed']")
    public Button proceed;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    public ConfirmBulkUpdateDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class UploadResultsDialog extends AntModal {

    public UploadResultsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[./div/span[.='Uploaded Orders']]")
    public PageElement uploadedOrders;

    @FindBy(xpath = ".//div[./div/span[.='Successful']]")
    public PageElement successful;

    @FindBy(xpath = ".//div[./div/span[.='Failed']]")
    public PageElement failed;

    @FindBy(xpath = ".//div[./h5[.='Successful']]//table/tbody//tr[@data-row-key]/td")
    public List<PageElement> successfulTrackingIds;

    @FindBy(xpath = ".//div[./h5[.='Failed']]//table/tbody//tr[@data-row-key]/td[1]")
    public List<PageElement> failedTrackingIds;

    @FindBy(xpath = ".//div[./h5[.='Failed']]//table/tbody//tr[@data-row-key]/td[2]")
    public List<PageElement> failedReasons;

  }
}