package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
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
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import io.opentelemetry.api.logs.LoggerBuilder;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.time.Duration;
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
import org.openqa.selenium.By;
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
import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.COLUMN_SHIPMENT_ID;

/**
 * @author Lanang Jati
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class NewShipmentManagementPage extends SimpleReactPage<NewShipmentManagementPage> {

  private static final String ADD_FILTER_XPATH = "//div[@data-testid='add-filter-select']";
  private static final String FILTER_DROPDOWN_LIST_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class,'ant-select-dropdown-hidden'))]//div[@title='%s'] ";
  private static final String XPATH_SEARCHBYSIDSUBMIT = "//button[@data-testid='search-by-sid-submit']";
  public static final String ADD_NEW_WEIGHT_DIMENSION_PAGE_XPATH = "//div/h4[contains(text(),'Add New Weight & Dimension')]";

  @FindBy(id = "search-by-sid_searchIds")
  public PageElement sidsTextArea;

  @FindBy(xpath = "//input[@class='ant-checkbox-input']")
  public CheckBox selectAllCheckbox;

  @FindBy(xpath = "//input[@id='updateMAWBForm_mawb']")
  public PageElement inputUpdateMawb;

  public String inputUpdateMawbOriginAirport = "//input[@id='updateMAWBForm_origin_airport_id']";

  public String inputUpdateMawbDestinationAirport = "//input[@id='updateMAWBForm_destination_airport_id']";

  public static ShipmentsTable shipmentsTable;
  public ShipmentEventsTable shipmentEventsTable;
  public MovementEventsTable movementEventsTable;

  @FindBy(css = "[data-testid='bulk-update-confirmation-section']")
  public ShipmentToBeUpdatedTable shipmentToBeUpdatedTable;

  @FindBy(xpath = ".//button[@data-testid='create-shipment-button']")
  public Button createShipment;

  @FindBy(css = "[data-testid='search-id-textarea']")
  public TextBox shipmentIds;

  @FindBy(css = "[data-testid='shipment-ids-unique-counter']")
  public PageElement enteredUniqueShipmentIds;

  @FindBy(css = "[data-testid='shipment-ids-duplicate-counter']")
  public PageElement enteredDuplicateShipmentIds;

  @FindBy(css = "[data-testid='search-by-sid-submit']")
  public Button searchByShipmentIds;

  @FindBy(xpath = ".//div[contains(@class,'ant-modal')][.//div[.='Upload Results']]")
  public UploadResultsDialog uploadResultsDialog;

  @FindBy(css = ".ant-modal")
  public SearchErrorDialog searchErrorDialog;

  @FindBy(css = ".ant-modal")
  public CreateShipmentDialog createShipmentDialog;

  @FindBy(css = ".ant-modal")
  public EditShipmentDialog editShipmentDialog;

  @FindBy(css = ".ant-modal")
  public CancelShipmentDialog cancelShipmentDialog;

  @FindBy(css = ".ant-modal")
  public SavePresetDialog savePresetDialog;

  @FindBy(css = ".ant-modal")
  public DeletePresetDialog deletePresetDialog;

  @FindBy(css = ".ant-modal")
  public BulkUpdateShipmentDialog bulkUpdateShipmentDialog;

  @FindBy(css = ".ant-modal")
  public ConfirmBulkUpdateDialog confirmBulkUpdateDialog;

  @FindBy(css = ".ant-checkbox-wrapper:not(.ant-checkbox-wrapper-checked)")
  private CheckBox uncheckedShipmentCheckBox;

  @FindBy(css = "[data-testid='load-selection-button']")
  public Button loadSelection;

  @FindBy(xpath = "//div[@data-testid='add-filter-select']")
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

  @FindBy(css = "[data-testid='preset-actions-button']")
  public AntMenu presetActionsMenu;

  @FindBy(css = "[data-testid='pick-preset-select']")
  public AntSelect3 selectFiltersPreset;

  @FindBy(xpath = ".//button[.='Edit Filters']")
  public Button editFilters;

  @FindBy(css = "[data-testid='clear-all-selections-button']")
  public Button clearAllFilters;

  @FindBy(css = "h1")
  public PageElement shipmentIdTitle;

  @FindBy(xpath = "//div[@data-testid='shipment_status-filter-card']//button")
  public Button showShipmentStatus;

  @FindBy(xpath = "//div[@data-testid='shipment_type-filter-card']//button")
  public Button showShipmentType;

  @FindBy(xpath = "//div[@data-testid='shipment_status-filter-card']//span[@class='ant-select-clear']")
  public Button clearShipmentStatus;

  @FindBy(xpath = "//div[@data-testid='shipment_type-filter-card']//span[@class='ant-select-clear']")
  public Button clearShipmentType;

  @FindBy(xpath = "//div[@data-testid='shipment_status-filter-card']//div[@role='alert']")
  public PageElement showErrorAlertShipmentStatus;

  @FindBy(xpath = "//div[@data-testid='shipment_type-filter-card']//div[@role='alert']")
  public PageElement showErrorAlertShipmentType;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement showErrorAlertShipmentDate;

  @FindBy(xpath = "//div[contains(@class,'footer-row')]")
  public PageElement showNoResultsFound;

  @FindBy(xpath = "//span[text()='Shipment ID']/parent::div/parent::div/following-sibling::div//input")
  public TextBox shipmentIdInputFieldOnShipmentManagementTable;

  private static final String FILEPATH = TestConstants.TEMP_DIR;
  private static final String FORM_SHIPMENT_TYPE_XPATH = "//div[@data-testid='shipment_type-filter-card']//div[@class='ant-select-selector']";
  private static final String FORM_SHIPMENT_STATUS_XPATH = "//div[@data-testid='shipment_status-filter-card']//div[@class='ant-select-selector']";

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

  public void hoverShipmentTypeForm() {
    moveToElementWithXpath(FORM_SHIPMENT_TYPE_XPATH);
  }

  public void hoverShipmentStatusForm() {
    moveToElementWithXpath(FORM_SHIPMENT_STATUS_XPATH);
  }

  public void createShipment(ShipmentInfo shipmentInfo, boolean isNextOrder) {
    createShipment.waitUntilClickable(2);
    createShipment.click();
    createShipmentDialog.waitUntilVisible(2);
    createShipmentDialog.type.click();
    click(f(".//div[contains(@class,'ant-select-item')]//div[text()='%s']", shipmentInfo.getShipmentType()));
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

  public void createShipmentWithoutConfirm(ShipmentInfo shipmentInfo, boolean isNextOrder) {
    createShipment.click();
    createShipmentDialog.waitUntilVisible();
    createShipmentDialog.type.selectValue("Air Haul");
    createShipmentDialog.startHub.selectValue(shipmentInfo.getOrigHubName());
    createShipmentDialog.endHub.selectValue(shipmentInfo.getDestHubName());
    createShipmentDialog.comments.setValue(shipmentInfo.getComments());
  }

  public long getNewShipperId() {
    String pattern = "Created new shipment (\\d+)";
    String toastMessage = waitAndGetNoticeText(pattern, true);
    Pattern p = Pattern.compile(pattern);
    Matcher m = p.matcher(toastMessage);
    m.find();
    return Long.parseLong(m.group(1));
  }

  public Long createAnotherShipment() {
    createShipmentDialog.createAnother.click();
    return getNewShipperId();
  }

  public void editCancelledShipment() {
    shipmentsTable.clickActionButton(1, ACTION_EDIT);
    editShipmentDialog.waitUntilVisible();
    Assertions.assertThat(editShipmentDialog.comments.isEnabled())
        .as("Comments field is enabled")
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

  public void cancelShipment(Long shipmentId) {
    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    shipmentsTable.clickActionButton(1, ACTION_CANCEL);
    cancelShipmentDialog.waitUntilVisible();
    cancelShipmentDialog.cancelShipment.click();
    waitAndGetNoticeText("Successfully changed status to Cancelled for Shipment ID " + shipmentId,
        false);
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

  public void verifyOpenedShipmentDetailsPageIsTrue(Long shipmentId, String trackingId) {
    String expectedTextShipmentDetails = f("Shipment ID : %d", shipmentId);
    String actualTextShipmentDetails = shipmentIdTitle.getText();
    Assertions.assertThat(actualTextShipmentDetails)
        .as("Shipment ID title").
        isEqualTo(expectedTextShipmentDetails);
    isElementExist(f("//td[contains(text(),'%s')]", trackingId));
    getWebDriver().close();
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
        Assertions.assertThat(numberOfOrder + 1).as("Number of Order is not the same")
            .isEqualTo(actualNumberOfOrder);
        Assertions.assertThat(1).as("Failed Order(s) : ").isEqualTo(failedOrder);
        String actualFailedReason = uploadResultsDialog.failedReasons.get(0).getText();
        Assertions.assertThat("DUPLICATE").as("Failure reason is different : ")
            .isEqualTo(actualFailedReason);
      } else {
        Assertions.assertThat(numberOfOrder).as("Number of Order is not the same")
            .isEqualTo(actualNumberOfOrder);
        Assertions.assertThat(0).as("Failed Order(s) : ").isEqualTo(failedOrder);
      }
      Assertions.assertThat(numberOfOrder).as("Successful Order(s) : ").isEqualTo(successfulOrder);

    } else {
      Assertions.assertThat(1).as("Number of Order is not the same").isEqualTo(actualNumberOfOrder);
      Assertions.assertThat(0).as("Successful Order(s) : ").isEqualTo(successfulOrder);
      Assertions.assertThat(1).as("Failed Order(s) : ").isEqualTo(failedOrder);
    }
  }

  public void inputFormBulkUpdateShipment(Map<String, String> resolvedMapOfData) {
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
  }

  public void bulkUpdateShipment(Map<String, String> resolvedMapOfData) {
    this.inputFormBulkUpdateShipment(resolvedMapOfData);
    bulkUpdateShipmentDialog.applyToSelected.click();
  }

  public void verifyShipmentToBeUpdatedData(List<Long> shipmentIds,
      Map<String, String> resolvedMapOfData) {
    shipmentToBeUpdatedTable.waitUntilVisible();
    String fieldToBeUpdated = shipmentToBeUpdatedTable.fieldToBeUpdated.getText()
        .split(":")[1].trim();
    if (resolvedMapOfData.get("shipmentType") != null) {
      Assertions.assertThat(fieldToBeUpdated).as("Field is the same").contains("Shipment Type");
    }
    if (resolvedMapOfData.get("startHub") != null) {
      Assertions.assertThat(fieldToBeUpdated).as("Field is the same").contains("Origin Hub");
    }
    if (resolvedMapOfData.get("endHub") != null) {
      Assertions.assertThat(fieldToBeUpdated).as("Field is the same").contains("Destination Hub");
    }
    if (resolvedMapOfData.get("eda") != null) {
      Assertions.assertThat(fieldToBeUpdated).as("Field is the same").contains("ETA (Date Time)");
    }
    if (resolvedMapOfData.get("eta") != null) {
      Assertions.assertThat(fieldToBeUpdated).as("Field is the same").contains("ETA (Date Time)");
    }
    if (resolvedMapOfData.get("mawb") != null) {
      Assertions.assertThat(fieldToBeUpdated).as("Field is the same").contains("MAWB");
    }
    if (resolvedMapOfData.get("comments") != null) {
      Assertions.assertThat(fieldToBeUpdated).as("Field is the same").contains("Comments");
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
      Assertions.assertThat(shipmentField).as("field is equal").contains("Shipment Type");
    }
    if (resolvedMapOfData.get("startHub") != null) {
      Assertions.assertThat(shipmentField).as("field is equal").contains("Origin Hub");
    }
    if (resolvedMapOfData.get("endHub") != null) {
      Assertions.assertThat(shipmentField).as("field is equal").contains("Destination Hub");
    }
    if (resolvedMapOfData.get("EDA") != null) {
      Assertions.assertThat(shipmentField).as("field is equal").contains("ETA (Date Time)");
    }
    if (resolvedMapOfData.get("ETA") != null) {
      Assertions.assertThat(shipmentField).as("field is equal").contains("ETA (Date Time)");
    }
    if (resolvedMapOfData.get("mawb") != null) {
      Assertions.assertThat(shipmentField).as("field is equal").contains("MAWB");
    }
    if (resolvedMapOfData.get("comments") != null) {
      Assertions.assertThat(shipmentField).as("field is equal").contains("Comments");
    }
    if (resolvedMapOfData.get("removeShipment") != null) {
      Assertions.assertThat(numberOfRecords).as("number of records is equal").isEqualTo(1L);
    } else {
      Assertions.assertThat(numberOfRecords).as("number of records is equal").isEqualTo(2L);
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

  public void selectAnotherShipmentAndVerifyCount() {
    uncheckedShipmentCheckBox.check();
    tableActionsMenu.selectOption("Show Only Selected");
    pause3s();

    Assertions.assertThat(shipmentsTable.getRowsCount())
        .as("Count of displayed shipments")
        .isEqualTo(3);
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

    @FindBy(xpath = ".//div[@data-testid='create-shipment-type-select']")
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

    @FindBy(xpath = "//div/a/span[contains(text(),'Shipment Weight & Dimension page')]")
    public Button mawbButtonLink;

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

    @FindBy(xpath = "(.//*[contains(@class,'ant-form-item-explain-error')])[1]")
    public PageElement startHubError;

    @FindBy(xpath = "(.//*[contains(@class,'ant-form-item-explain-error')])[2]")
    public PageElement endHubError;
  }

  public static class ShipmentEventsTable extends AntTableV3<ShipmentEvent> {

    public static final String SOURCE = "source";
    public static final String USER_ID = "userId";
    public static final String RESULT = "result";
    public static final String HUB = "hub";
    public static final String CREATED_AT = "createdAt";

    public ShipmentEventsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(SOURCE, "source")
          .put(USER_ID, "user")
          .put(RESULT, "result")
          .put(HUB, "hub")
          .put(CREATED_AT, "created-at")
          .build());
      setEntityClass(ShipmentEvent.class);
      setTableLocator("//div[@data-testid='shipment-events-table']");
    }
  }

  public static class MovementEventsTable extends AntTableV3<MovementEvent> {

    public static final String SOURCE = "source";
    public static final String STATUS = "status";
    public static final String CREATED_AT = "createdAt";
    public static final String COMMENTS = "comments";

    public MovementEventsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(SOURCE, "source")
          .put(STATUS, "status")
          .put(CREATED_AT, "created-at")
          .put(COMMENTS, "comments")
          .build());
      setEntityClass(MovementEvent.class);
      setTableLocator("//div[@data-testid='movement-events-table']");
    }
  }

  public static class CancelShipmentDialog extends AntModal {

    @FindBy(xpath = ".//button[.='Cancel Shipment']")
    public Button cancelShipment;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    public CancelShipmentDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class SearchErrorDialog extends AntModal {

    @FindBy(css = "div.ant-space-item")
    public List<PageElement> messageLines;

    @FindBy(xpath = ".//button[contains(.,'Show')]")
    public Button show;

    public SearchErrorDialog(WebDriver webDriver, WebElement webElement) {
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

    @FindBy(xpath = "(.//*[contains(@class,'ant-form-item-explain-error')])[1]")
    public PageElement originHubError;

    @FindBy(xpath = "(.//*[contains(@class,'ant-form-item-explain-error')])[2]")
    public PageElement destinationHubError;

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

    @FindBy(xpath = "(.//*[contains(@class,'ant-table-cell result')])[2]/span/b")
    public PageElement originDestinationHubError;

    public ShipmentToBeUpdatedTable(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }

  public static class ConfirmBulkUpdateDialog extends AntModal {

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

  public static class SavePresetDialog extends AntModal {

    public SavePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(id = "name")
    public TextBox name;

    @FindBy(xpath = ".//button[.='Save']")
    public Button save;

  }

  public static class DeletePresetDialog extends AntModal {

    public DeletePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = ".ant-select")
    public AntSelect3 name;

    @FindBy(xpath = ".//button[.='Delete']")
    public Button delete;

  }

  public void AddFilterWithValue(String value) {
    if (isElementEnabled(f(FILTER_DROPDOWN_LIST_XPATH, value))) {
      click(f(FILTER_DROPDOWN_LIST_XPATH, value));
    } else {
      click(ADD_FILTER_XPATH);
      waitUntilVisibilityOfElementLocated(f(FILTER_DROPDOWN_LIST_XPATH, value));
      click(f(FILTER_DROPDOWN_LIST_XPATH, value));
    }
    pause1s();
    click(ADD_FILTER_XPATH);

  }

  public void clickMAWBLinkButtonOnEditShipment() {
    editShipmentDialog.mawbButtonLink.click();
    switchToNewWindow();
    this.switchTo();
    waitUntilVisibilityOfElementLocated(ADD_NEW_WEIGHT_DIMENSION_PAGE_XPATH, 5);
  }
}