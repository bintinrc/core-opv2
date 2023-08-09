package co.nvqa.operator_v2.selenium.page.recovery;

import co.nvqa.common.recovery.constants.TicketingConstants;
import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.page.AntTableV2;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.Arrays;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class RecoveryTicketsPage extends SimpleReactPage<RecoveryTicketsPage> {

  @FindBy(css = "[data-testid='btn-create-new-ticket-csv']")
  public Button createByCsv;

  @FindBy(css = "[data-testid='btn-bulk-update']")
  public Button bulkUpdate;

  @FindBy(xpath = "//div[@class='ant-modal-content']")
  public creatByCSVDialog creatByCSVDialog;

  @FindBy(css = "[data-testid='btn-find-ticket-csv']")
  public Button findByCsv;

  @FindBy(xpath = "//div[@class='ant-modal-content']")
  public FindTicketsByCSVDialog findTicketsByCSVDialog;

  public ResultsTable resultsTable;

  @FindBy(css = "[data-testid='btn-create-new-ticket']")
  public Button createNewTicket;

  @FindBy(xpath = "//div[@class='ant-modal-content']")
  public CreateTicketDialog createTicketDialog;

  @FindBy(xpath = "//div[@class='ant-modal-title' and .='Create Ticket']")
  public PageElement createTicketDialogBox;

  @FindBy(css = "[data-testid='btn-clear-all-filters']")
  public Button clearAllSelections;

  @FindBy(xpath = "//div[@data-testid='select-tracking_ids']//input")
  public PageElement trackingIdFilter;

  @FindBy(xpath = "//div[@data-testid='select-ticket_statuses']//input")
  public PageElement ticketStatusFilter;

  @FindBy(xpath = "//div[@data-testid='add-filter-select']//input")
  public PageElement addFilter;

  @FindBy(css = "[data-testid='btn-load-selection']")
  public Button loadSelection;

  @FindBy(xpath = "//div[@class='ant-modal-title' and .='Edit Ticket']")
  public EditTicketDialog editTicketDialog;

  @FindBy(xpath = "//div[@class='ant-modal-title' and .='Bulk Edit']")
  public BulkEditDialog bulkEditDialog;

  @FindBy(css = "[data-testid='btn-edit-filter']")
  public Button editFilter;

  public static final String TICKET_TYPE_DAMAGED = "DAMAGED";
  public static final String TICKET_TYPE_MISSING = "MISSING";
  public static final String TICKET_TYPE_PARCEL_ON_HOLD = "PARCEL ON HOLD";
  public static final String TICKET_TYPE_PARCEL_EXCEPTION = "PARCEL EXCEPTION";
  public static final String TICKET_TYPE_SHIPPER_ISSUE = "SHIPPER ISSUE";
  public static final String TICKET_TYPE_SELF_COLLECTION = "SELF COLLECTION";
  public static final String TICKET_TYPE_SLA_BREACH = "SLA BREACH";

  private final List<String> TICKET_TYPE_WITH_SHIPPER_CLAIMS_CONFIRMATION = Arrays.asList(
      "DAMAGED",
      "SLA BREACH",
      "MISSING",
      "SHIPPER ISSUE");

  private final List<String> ORDER_OUTCOME_WITH_SHIPPER_CLAIMS_CONFIRMATION = Arrays.asList(
      "NV LIABLE - PARCEL DISPOSED",
      "NV LIABLE - RETURN PARCEL",
      "NV LIABLE - FULL - PARCEL DELIVERED",
      "NV LIABLE - PARTIAL - PARCEL DELIVERED",
      "LOST - DECLARED",
      "LOST - NO RESPONSE - DECLARED",
      "DAMAGED - NV LIABLE",
      "MISSING - NV LIABLE",
      "SLA BREACH - NV LIABLE");

  public RecoveryTicketsPage(WebDriver webDriver) {
    super(webDriver);
    resultsTable = new ResultsTable(webDriver);
  }

  public void createTicket(RecoveryTicket recoveryTicket) {
    waitUntilPageLoaded();
    String trackingId = recoveryTicket.getTrackingId();
    String ticketType = recoveryTicket.getTicketType();

    createNewTicket.click();
    waitUntilVisibilityOfElementLocated(createTicketDialogBox.getWebElement());
    createTicketDialog.trackingId.sendKeys(trackingId);
    createTicketDialog.entrySource.selectValue(recoveryTicket.getEntrySource());
    createTicketDialog.investigatingDept.selectValue(recoveryTicket.getInvestigatingDepartment());
    createTicketDialog.investigatingHub.fillSearchTermAndEnter(
        recoveryTicket.getInvestigatingHub());
    createTicketDialog.ticketType.selectValue(ticketType);

    switch (ticketType) {
      case TICKET_TYPE_DAMAGED: {
        createTicketDialog.orderOutcome.waitUntilVisible();
        createTicketDialog.orderOutcome
            .selectValue(recoveryTicket.getOrderOutcomeDamaged());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.waitUntilVisible();
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.parcelLocation.selectValue(recoveryTicket.getParcelLocation());
        createTicketDialog.liability.selectValue(recoveryTicket.getLiability());
        createTicketDialog.damageDescription.sendKeys(recoveryTicket.getDamageDescription());
        break;
      }
      case TICKET_TYPE_MISSING: {
        createTicketDialog.orderOutcome.waitUntilVisible();
        createTicketDialog.orderOutcome
            .selectValue(recoveryTicket.getOrderOutcomeMissing());
        createTicketDialog.parcelDescription.waitUntilVisible();
        createTicketDialog.parcelDescription.sendKeys(recoveryTicket.getParcelDescription());
        break;
      }
      case TICKET_TYPE_PARCEL_EXCEPTION: {
        createTicketDialog.ticketSubtype.waitUntilVisible();
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        createTicketDialog.orderOutcome.waitUntilVisible();
        createTicketDialog.orderOutcome
            .selectValue(recoveryTicket.getOrderOutcomeInaccurateAddress());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.waitUntilVisible();
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.exceptionReason.waitUntilVisible();
        createTicketDialog.exceptionReason.sendKeys(recoveryTicket.getExceptionReason());
        break;
      }
      case TICKET_TYPE_SHIPPER_ISSUE: {
        createTicketDialog.ticketSubtype.waitUntilVisible();
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        String outcome = recoveryTicket.getOrderOutcome();
        if (StringUtils.isEmpty(outcome)) {
          outcome = recoveryTicket.getOrderOutcomeDuplicateParcel();
        }
        createTicketDialog.orderOutcome.waitUntilVisible();
        createTicketDialog.orderOutcome.selectValue(outcome);
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.waitUntilVisible();
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.issueDescription.waitUntilVisible();
        createTicketDialog.issueDescription.sendKeys(recoveryTicket.getIssueDescription());
        break;
      }
      case TICKET_TYPE_SELF_COLLECTION: {
        createTicketDialog.orderOutcome.waitUntilVisible();
        createTicketDialog.orderOutcome
            .selectValue(recoveryTicket.getOrderOutcomeDuplicateParcel());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.waitUntilVisible();
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        break;
      }
      case TICKET_TYPE_SLA_BREACH: {
        createTicketDialog.orderOutcome.waitUntilVisible();
        createTicketDialog.orderOutcome.selectValue(recoveryTicket.getOrderOutcome());
        if (StringUtils.isNotBlank(recoveryTicket.getBreachReason())) {
          createTicketDialog.breachReason.waitUntilVisible();
          createTicketDialog.breachReason.sendKeys(recoveryTicket.getBreachReason());
        }
        if (StringUtils.isNotBlank(recoveryTicket.getBreachLeg())) {
          createTicketDialog.breachLeg.waitUntilVisible();
          createTicketDialog.breachLeg.selectValue(recoveryTicket.getBreachLeg());
        }
        break;
      }
      case TICKET_TYPE_PARCEL_ON_HOLD: {
        createTicketDialog.ticketSubtype.waitUntilVisible();
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        createTicketDialog.orderOutcome.waitUntilVisible();
        createTicketDialog.orderOutcome.selectValue(recoveryTicket.getOrderOutcome());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.waitUntilVisible();
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.exceptionReason.waitUntilVisible();
        createTicketDialog.exceptionReason.sendKeys(recoveryTicket.getExceptionReason());
        pause3s();
      }
    }

    createTicketDialog.customerZendeskId.sendKeys(recoveryTicket.getCustZendeskId());
    createTicketDialog.shipperZendeskId.sendKeys(recoveryTicket.getShipperZendeskId());
    createTicketDialog.ticketNotes.sendKeys(recoveryTicket.getTicketNotes());

    createTicketDialog.createTicket.click();
    waitUntilVisibilityOfNotification("Ticket has been created!");
  }

  public void editTicket(RecoveryTicket recoveryTicket) {
    editTicketDialog.ticketSettings.get(0).selectValue(recoveryTicket.getInvestigatingDepartment());
    editTicketDialog.ticketSettings.get(1).selectValue(recoveryTicket.getInvestigatingHub());
    editTicketDialog.ticketStatus.selectValue(recoveryTicket.getTicketStatus());
    editTicketDialog.ticketSettings.get(4).selectValue(recoveryTicket.getAssignTo());
    editTicketDialog.ticketSettings.get(3).selectValue(recoveryTicket.getOrderOutcome());
    editTicketDialog.newInstructions.clearAndSendkeysV2(recoveryTicket.getEnterNewInstruction());
    editTicketDialog.ticketComments.clearAndSendkeysV2(recoveryTicket.getTicketComments());
    editTicketDialog.customerZendeskId.forceClear();
    editTicketDialog.customerZendeskId.sendKeys(recoveryTicket.getCustZendeskId());
    editTicketDialog.shipperZendeskId.forceClear();
    editTicketDialog.shipperZendeskId.sendKeys(recoveryTicket.getShipperZendeskId());
    editTicketDialog.updateTicket.click();
  }

  public void bulkUpdate(RecoveryTicket recoveryTicket) {
    waitUntilVisibilityOfElementLocated(bulkEditDialog.getWebElement());

    //Update All fields
    bulkEditDialog.bulkEditTicketDetails.get(0).selectValue(recoveryTicket.getTicketStatus());
    bulkEditDialog.bulkEditTicketDetails.get(1)
        .selectValueWithoutSearch(recoveryTicket.getOrderOutcome());

    if (TicketingConstants.OUTCOME_WITH_RTS_FIELD.contains(recoveryTicket.getOrderOutcome())) {
      bulkEditDialog.bulkEditTicketDetails.get(2).selectByIndex(1);
      bulkEditDialog.bulkEditTicketDetails.get(3)
          .selectValue(recoveryTicket.getInvestigatingDepartment());
      bulkEditDialog.bulkEditTicketDetails.get(4).selectValue(recoveryTicket.getInvestigatingHub());
      bulkEditDialog.bulkEditTicketDetails.get(5)
          .selectValueWithoutSearch(recoveryTicket.getAssignTo());
    } else {
      bulkEditDialog.bulkEditTicketDetails.get(2)
          .selectValue(recoveryTicket.getInvestigatingDepartment());
      bulkEditDialog.bulkEditTicketDetails.get(3).selectValue(recoveryTicket.getInvestigatingHub());
      bulkEditDialog.bulkEditTicketDetails.get(4)
          .selectValueWithoutSearch(recoveryTicket.getAssignTo());
    }
    bulkEditDialog.newInstruction.sendKeys(recoveryTicket.getEnterNewInstruction());
    bulkEditDialog.comments.sendKeys(recoveryTicket.getTicketComments());

    if (bulkEditDialog.suspiciousReason.isDisplayed()) {
      bulkEditDialog.bulkEditTicketDetails.get(5)
          .selectValueWithoutSearch("Ambiguous address");
      bulkEditDialog.bulkEditTicketDetails.get(6)
          .selectValueWithoutSearch("Not Suspicious");
    }

    bulkEditDialog.updateTickets.click();
    if (TICKET_TYPE_WITH_SHIPPER_CLAIMS_CONFIRMATION.contains(
        bulkEditDialog.recoveryIssue.getText())
        && ORDER_OUTCOME_WITH_SHIPPER_CLAIMS_CONFIRMATION.contains(
        recoveryTicket.getOrderOutcome())) {
      waitUntilVisibilityOfElementLocated(bulkEditDialog.dialogHeader.getWebElement());
      verifyConfirmationPopup();
      bulkEditDialog.confirmationUpdate.click();
    }
    waitUntilVisibilityOfNotification("Success 2 tickets updated.");
  }

  public void filterByField(String field, List<String> values) {
    switch (field) {
      case "Tracking ID":
        values.forEach(e -> {
          trackingIdFilter.waitUntilVisible();
          trackingIdFilter.sendKeys(e);
          trackingIdFilter.sendKeys(Keys.RETURN);
        });
        break;
      case "Ticket Status":
        values.forEach(e -> {
          ticketStatusFilter.sendKeys(e);
          ticketStatusFilter.sendKeys(Keys.RETURN);
        });
    }
    loadSelection.click();
    resultsTable.waitUntilPageLoaded();
  }

  public void closeEditTicketModal() {
    Actions actions = new Actions(getWebDriver());
    actions.sendKeys(Keys.ESCAPE).build().perform();
  }

  public static class creatByCSVDialog extends AntModal {

    @FindBy(xpath = "//div[@class='ant-modal-title']")
    public PageElement title;

    @FindBy(xpath = "//input[@placeholder='Search' and @class='ant-input']")
    public List<PageElement> search;

    @FindBy(xpath = "//input[@type='file']")
    public FileInput fileUpload;

    @FindBy(xpath = "//button/span[.='Upload File']")
    public Button uploadFile;

    @FindBy(xpath = "//div[@class='ant-modal-body']/div[@class='ant-row']")
    public List<PageElement> message;

    @FindBy(xpath = "//div[@data-testid='inner-element']//div[@role='gridcell']//span[@class]")
    public List<PageElement> failureReason;

    @FindBy(xpath = "//div[@class='ant-modal-footer']//h4")
    public PageElement displayedUploadedFileName;

    @FindBy(xpath = "//button/span[.='Download Template']")
    public Button downloadTemplate;

    @FindBy(xpath = "//button/span[.='Done']")
    public Button done;

    @FindBy(xpath = "//button/span[.='Download Error Data']")
    public Button downloadErrorData;

    @FindBy(xpath = "//button/span[.='Upload Another File']")
    public Button uploadAnotherFile;

    @FindBy(xpath = "//button/span[.='Proceed With Valid Data']")
    public Button proceedWithValidData;

    public String typeRowResult = "//tbody//tr//td[contains(.,'%s')]";
    public static final String SAMPLE_CSV_FILENAME_PATTERN = "ticketing-csv-template.csv";
    public static final String ERROR_DATA_CSV_FILE_NAME = "invalid-data.csv";

    public creatByCSVDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void searchByTicketType(String value) {
      search.get(0).sendKeys(value);
      Assertions.assertThat(findElement(By.xpath(f(typeRowResult, value))).getText())
          .as("correct search results - ticket type").isEqualToIgnoringCase(value);
    }

    public void searchByEntrySource(String value) {
      search.get(1).sendKeys(value);
      Assertions.assertThat(findElement(By.xpath(f(typeRowResult, value))).getText())
          .as("correct search results - entry source").isEqualToIgnoringCase(value);
    }

    public void searchByInvestigationDept(String value) {
      search.get(2).sendKeys(value);
      Assertions.assertThat(findElement(By.xpath(f(typeRowResult, value))).getText())
          .as("correct search results - Investigation dept").isEqualToIgnoringCase(value);
    }

    public void generateNoHeadersFile() {
      String csvContents = "NV012345,MI,FLT-LM,1";
      File csvFile = createFile("No Headers File.csv", csvContents);
      fileUpload.setValue(csvFile);
    }
  }

  public static class FindTicketsByCSVDialog extends AntModal {

    @FindBy(xpath = "//div[@class='ant-modal-title']")
    public PageElement title;

    @FindBy(xpath = "//input[@type='file']")
    public FileInput uploadComponent;

    @FindBy(css = "[data-testid='btn-find-search']")
    public Button search;

    @FindBy(xpath = "//div[@class='ant-row error-desc']")
    public PageElement errorMessage;

    @FindBy(xpath = "//div[@class='ant-row']/ul/li")
    public List<PageElement> invalidTrackingId;

    @FindBy(xpath = "//button[@class='ant-btn ant-btn-default']")
    public Button loadSelection;

    @FindBy(css = "[data-testid='download-sample']")
    public PageElement downloadSample;

    @FindBy(xpath = "//span[@class='ant-upload-list-item-name']")
    public PageElement uploadedFileName;

    public static final String SEARCH_SAMPLE_CSV_FILENAME_PATTERN = "search-sample.csv";

    public FindTicketsByCSVDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ResultsTable extends AntTableV2<RecoveryTicket> {

    @FindBy(css = "[data-datakey='trackingId']")
    public PageElement trackingId;

    @FindBy(css = "[data-datakey='orderGranularStatus']")
    public PageElement orderGranularStatus;

    @FindBy(css = "[data-datakey='ticketTypeSubType']")
    public PageElement ticketType;

    @FindBy(css = "[data-datakey='ticketCreator']")
    public PageElement ticketCreator;

    @FindBy(css = "[data-datakey='shipper']")
    public PageElement shipper;

    @FindBy(css = "[data-datakey='isRedTicket']")
    public PageElement redTickets;

    @FindBy(css = "[data-datakey='_investigatingHubName']")
    public PageElement investigatingHub;

    @FindBy(css = "[data-datakey='investigatingParty']")
    public PageElement InvestigatingDept;

    @FindBy(css = "[data-datakey='status']")
    public PageElement status;

    @FindBy(css = "[data-datakey='assigneeName']")
    public PageElement assignee;

    @FindBy(css = "[data-datakey='daysDue']")
    public PageElement daysSince;

    @FindBy(css = "[data-datakey='createdAt']")
    public PageElement created;

    @FindBy(css = "[data-testid='virtual-table.ticketTypeSubType.header.filter']")
    public PageElement ticketTypeSubtypeFilter;

    @FindBy(css = "[data-testid='virtual-table.status.header.filter']")
    public PageElement statusFilter;

    @FindBy(css = "[data-testid='virtual-table.assigneeName.header.filter']")
    public PageElement assigneeNameFilter;

    @FindBy(css = "[data-testid='virtual-table.investigatingParty.header.filter']")
    public PageElement investigatingPartyFilter;

    @FindBy(css = "[data-testid='virtual-table._investigatingHubName.header.filter']")
    public PageElement investigatingHubFilter;

    @FindBy(css = "[data-testid='virtual-table.trackingId.header.filter']")
    public PageElement trackingIdFilter;

    @FindBy(xpath = "//span[@class='anticon anticon-close-circle ant-input-clear-icon']")
    public PageElement clearFilterButton;

    @FindBy(xpath = "//button[@class='ant-btn ant-btn-sm ant-btn-icon-only']")
    public PageElement actionButton;

    @FindBy(css = "[data-testid='virtual-table.select-all-shown']")
    public PageElement selectAll;

    public static final String ACTION_EDIT = "Edit";

    public ResultsTable(WebDriver webDriver) {
      super(webDriver);
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("daysSince", "daysSince")
          .put("created", "created")
          .put("redTickets", "redTickets")
          .put("ticketType/subType", "ticketType/subType")
          .put("status", "status")
          .put("assignee", "assignee")
          .put("investigationDept", "investigationDept")
          .put("investigationHub", "investigationHub")
          .put("investigationName", "investigationName")
          .put("trackingId", "trackingId")
          .put("shipper", "shipper")
          .put("orderGranularStatus", "orderGranularStatus")
          .put("ticketCreator", "ticketCreator")
          .build()
      );
      setEntityClass(RecoveryTicket.class);
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT, "//button[starts-with(@data-testid,'edit-recovery-')]"
      ));
    }

    public void filterByField(String field, String value) {
      switch (field) {
        case "Ticket Type":
          ticketTypeSubtypeFilter.sendKeys(value);
          break;
        case "Status":
          statusFilter.sendKeys(value);
          break;
        case "Assignee":
          assigneeNameFilter.sendKeys(value);
          break;
        case "Investigating Party":
          investigatingPartyFilter.sendKeys(value);
          break;
        case "Investigating Hub":
          investigatingHubFilter.sendKeys(value);
          break;
        case "Tracking ID":
          trackingIdFilter.scrollIntoView();
          trackingIdFilter.sendKeys(value);
          break;
      }
    }
  }

  public static class CreateTicketDialog extends AntModal {

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.tracking-id.input']")
    public PageElement trackingId;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.entry-source.single-select']")
    public AntSelect3 entrySource;
    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.inv-dept.single-select']")
    public AntSelect3 investigatingDept;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.inv-hub.single-select']")
    public AntSelect3 investigatingHub;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.ticket-type.single-select']")
    public AntSelect3 ticketType;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.sub-type.single-select']")
    public AntSelect3 ticketSubtype;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.order-outcome.custom-field']")
    public AntSelect3 orderOutcome;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.rts-reason.single-select']")
    public AntSelect3 rtsReason;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.parcel-location.custom-field']")
    public AntSelect3 parcelLocation;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.liability.custom-field']")
    public AntSelect3 liability;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.description.custom-field']")
    public PageElement damageDescription;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.description.custom-field']")
    public PageElement parcelDescription;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.exception-reason.custom-field']")
    public PageElement exceptionReason;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.description.custom-field']")
    public PageElement issueDescription;

    @FindBy(css = "[id^='customer_zendesk_id']")
    public PageElement customerZendeskId;

    @FindBy(css = "[id^='shipper_zendesk_id']")
    public PageElement shipperZendeskId;

    @FindBy(id = "ticket_notes")
    public PageElement ticketNotes;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.breach-reason.custom-field']")
    public PageElement breachReason;

    @FindBy(css = "[data-testid='recovery-ticket-testid.create-ticket-dialogue.breach-leg.custom-field']")
    public AntSelect3 breachLeg;

    @FindBy(css = "[data-testid='btn-create']")
    public PageElement createTicket;

    public CreateTicketDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class EditTicketDialog extends AntModal {

    @FindBy(xpath = "//div[@class='ant-select ant-select-in-form-item ant-select-single ant-select-show-arrow']")
    public AntSelect ticketStatus;

    @FindBy(xpath = "//div[@class='ant-select-selector']")
    public List<AntSelect3> ticketSettings;

    @FindBy(xpath = "//input[@id='new_instruction']")
    public PageElement newInstructions;

    @FindBy(xpath = "//input[@id='comments']")
    public PageElement ticketComments;

    @FindBy(xpath = "//input[@id='customer_zendesk_id']")
    public ForceClearTextBox customerZendeskId;

    @FindBy(xpath = "//input[@id='shipper_zendesk_id']")
    public ForceClearTextBox shipperZendeskId;

    @FindBy(xpath = "//span[starts-with(.,'Status change')]")
    public PageElement changesAndComments;

    @FindBy(xpath = "//button[@class='ant-btn ant-btn-link btn-keep']")
    public Button keep;

    @FindBy(xpath = "//button/span[.='Update Ticket']")
    public Button updateTicket;
    @FindBy(xpath = "//h4[@id='last_instruction']")
    public PageElement lastInstruction;


    public EditTicketDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void verifyTicketStatus(String expectedStatus) {
      String statusUpdate = f("//span[@title='%s']", expectedStatus);
      assertEquals(expectedStatus.toLowerCase(), statusUpdate.toLowerCase());
    }
  }

  public static class BulkEditDialog extends AntModal {

    @FindBy(xpath = "//div[@class='ant-select-selector']")
    public List<AntSelect3> bulkEditTicketDetails;

    @FindBy(xpath = "//h4[@id='ticket_status']")
    public PageElement recoveryIssue;

    @FindBy(xpath = "//input[@id='new_instruction']")
    public PageElement newInstruction;

    @FindBy(xpath = "//input[@id='comments']")
    public PageElement comments;

    @FindBy(xpath = "//label[.='Suspicious Reason']")
    public PageElement suspiciousReason;

    @FindBy(xpath = "//button/span[.='Update Tickets']")
    public Button updateTickets;

    @FindBy(xpath = "//span[@class='ant-modal-confirm-title']")
    public PageElement dialogHeader;

    @FindBy(xpath = "//div[@class='ant-modal-confirm-content']")
    public PageElement dialogBody;

    @FindBy(xpath = "//button/span[.='Update']")
    public Button confirmationUpdate;

    public BulkEditDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public void verifyConfirmationPopup() {
    final String actualHeader = bulkEditDialog.dialogHeader.getText();
    final String actualBody = bulkEditDialog.dialogBody.getText();
    Assertions.assertThat(actualHeader).as("Confirmation header is match")
        .isEqualTo("Confirm Update For 2 Ticket(s)");
    Assertions.assertThat(actualBody).as("Confirmation message is match")
        .isEqualTo("Resolving tickets with this order outcome will result in shipper claims");
  }
}