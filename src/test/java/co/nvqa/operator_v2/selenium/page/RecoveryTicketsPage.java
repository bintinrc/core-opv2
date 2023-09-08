package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBooleanBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterFreeTextBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage.TicketsTable.ACTION_EDIT;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class RecoveryTicketsPage extends OperatorV2SimplePage {

  private static final String MD_VIRTUAL_REPEAT = "ticket in getTableData()";

  public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking-id";

  public static final String TICKET_TYPE_DAMAGED = "DAMAGED";
  public static final String TICKET_TYPE_MISSING = "MISSING";
  public static final String TICKET_TYPE_PARCEL_ON_HOLD = "PARCEL ON HOLD";
  public static final String TICKET_TYPE_PARCEL_EXCEPTION = "PARCEL EXCEPTION";
  public static final String TICKET_TYPE_SHIPPER_ISSUE = "SHIPPER ISSUE";
  public static final String TICKET_TYPE_SELF_COLLECTION = "SELF COLLECTION";
  public static final String XPATH_REMOVE_TRACKINGID_FILTER = "//p[text()='Tracking IDs']/../following-sibling::div//button[@aria-label='Clear All']";

  public TicketsTable ticketsTable;

  @FindBy(xpath = "//nv-filter-free-text-box[@main-title='Tracking IDs']")
  public NvFilterFreeTextBox trackingIdFilter;

  @FindBy(xpath = "//nv-filter-box[@main-title='Ticket Status']")
  public NvFilterBox ticketStatusFilter;

  @FindBy(xpath = "//nv-filter-box[@main-title='Entry Source']")
  public NvFilterBox entrySourceFilter;

  @FindBy(xpath = "//nv-filter-box[@main-title='Investigating Hub']")
  public NvFilterBox investigationHubFilter;

  @FindBy(xpath = "//nv-filter-box[@main-title='Investigating Dept.']")
  public NvFilterBox investigationDeptFilter;

  @FindBy(xpath = "//nv-filter-boolean-box[@main-title='Show Unassigned']")
  public NvFilterBooleanBox showUnassignedFilter;

  @FindBy(xpath = "//nv-filter-boolean-box[@main-title='Resolved Tickets']")
  public NvFilterBooleanBox resolverTicketsFilter;

  @FindBy(xpath = "//md-datepicker[@name='filter.fieldKey']")
  public MdDatepicker createdAtFilter;

  @FindBy(xpath = "//nv-autocomplete[@placeholder='filter.select-filter']")
  public NvAutocomplete addFilter;

  @FindBy(name = "commons.load-selection")
  public NvApiTextButton loadSelection;

  @FindBy(name = "Clear All Selections")
  public NvIconTextButton clearAllSelections;

  @FindBy(name = "Create New Ticket")
  public NvIconTextButton createNewTicket;

  @FindBy(css = "md-dialog")
  public CreateTicketDialog createTicketDialog;

  @FindBy(css = "md-dialog")
  public EditTicketDialog editTicketDialog;

  @FindBy(xpath = "//md-input-container[@label='Last Instruction']/div[@class='readonly']")
  public PageElement lastInstructionText;

  @FindBy(xpath = "//md-toolbar[@title='Create Ticket']")
  public PageElement createTicketDialogBox;


  public RecoveryTicketsPage(WebDriver webDriver) {
    super(webDriver);
    ticketsTable = new TicketsTable(webDriver);
  }

  public void createTicket(RecoveryTicket recoveryTicket) {
    waitUntilPageLoaded();
    String trackingId = recoveryTicket.getTrackingId();
    String ticketType = recoveryTicket.getTicketType();

    createNewTicket.click();
    waitUntilVisibilityOfElementLocated(createTicketDialogBox.getWebElement());
    createTicketDialog.trackingId.setValue(trackingId
        + " "); // Add 1 <SPACE> character at the end of tracking ID to make the textbox get trigged and request tracking ID validation to backend.
    createTicketDialog.entrySource.selectValue(recoveryTicket.getEntrySource());
    createTicketDialog.investigatingDept.selectValue(recoveryTicket.getInvestigatingDepartment());
    createTicketDialog.investigatingHub.searchAndSelectValue(recoveryTicket.getInvestigatingHub());
    createTicketDialog.ticketType.selectValue(ticketType);

    switch (ticketType) {
      case TICKET_TYPE_DAMAGED: {
        //Damaged Details
        createTicketDialog.orderOutcome
            .searchAndSelectValue(recoveryTicket.getOrderOutcomeDamaged());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.parcelLocation.selectValue(recoveryTicket.getParcelLocation());
        createTicketDialog.liability.selectValue(recoveryTicket.getLiability());
        createTicketDialog.damageDescription.setValue(recoveryTicket.getDamageDescription());
        break;
      }
      case TICKET_TYPE_MISSING: {
        createTicketDialog.orderOutcome
            .searchAndSelectValue(recoveryTicket.getOrderOutcomeMissing());
        createTicketDialog.parcelDescription.setValue(recoveryTicket.getParcelDescription());
        createTicketDialog.parcelDescription.setValue(recoveryTicket.getParcelDescription());
        break;
      }
      case TICKET_TYPE_PARCEL_EXCEPTION: {
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        createTicketDialog.orderOutcome
            .searchAndSelectValue(recoveryTicket.getOrderOutcomeInaccurateAddress());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.exceptionReason.setValue(recoveryTicket.getExceptionReason());
        break;
      }
      case TICKET_TYPE_SHIPPER_ISSUE: {
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        String outcome = recoveryTicket.getOrderOutcome();
        if (StringUtils.isEmpty(outcome)) {
          outcome = recoveryTicket.getOrderOutcomeDuplicateParcel();
        }
        createTicketDialog.orderOutcome.searchAndSelectValue(outcome);
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.issueDescription.setValue(recoveryTicket.getIssueDescription());
        break;
      }
      case TICKET_TYPE_SELF_COLLECTION: {
        createTicketDialog.orderOutcome
            .searchAndSelectValue(recoveryTicket.getOrderOutcomeDuplicateParcel());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        break;
      }
      case TICKET_TYPE_PARCEL_ON_HOLD: {
        createTicketDialog.ticketSubtype.selectValue(recoveryTicket.getTicketSubType());
        createTicketDialog.orderOutcome
            .searchAndSelectValue(recoveryTicket.getOrderOutcome());
        if (StringUtils.isNotBlank(recoveryTicket.getRtsReason())) {
          createTicketDialog.rtsReason.selectValue(recoveryTicket.getRtsReason());
        }
        createTicketDialog.exceptionReason.setValue(recoveryTicket.getExceptionReason());
        pause3s();
      }
    }

    createTicketDialog.customerZendeskId.setValue(recoveryTicket.getCustZendeskId());
    createTicketDialog.shipperZendeskId.setValue(recoveryTicket.getShipperZendeskId());
    createTicketDialog.ticketNotes.setValue(recoveryTicket.getTicketNotes());

    retryIfRuntimeExceptionOccurred(() ->
    {
      if (createTicketDialog.createTicket.isDisabled()) {
        createTicketDialog.trackingId.setValue(trackingId + " ");
        pause100ms();
        throw new NvTestRuntimeException(
            "Button \"Create Ticket\" still disabled. Trying to key in Tracking ID again.");
      }
    });

    createTicketDialog.createTicket.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast("Ticket created");
  }

  public void editTicketSettings(RecoveryTicket recoveryTicket) {
    editTicketDialog.waitUntilVisible();
    pause2s();
    editTicketDialog.ticketStatus.selectValue(recoveryTicket.getTicketStatus());
    editTicketDialog.orderOutcome.selectValue(recoveryTicket.getOrderOutcome());
    editTicketDialog.assignTo.selectValue(recoveryTicket.getAssignTo());
    editTicketDialog.newInstructions.setValue(recoveryTicket.getEnterNewInstruction());
    editTicketDialog.updateTicket.clickAndWaitUntilDone();
  }

  public void editAdditionalSettings(RecoveryTicket recoveryTicket) {
    editTicketDialog.waitUntilVisible();
    pause2s();
    editTicketDialog.customerZendeskId.scrollIntoView();
    editTicketDialog.customerZendeskId.setValue(recoveryTicket.getCustZendeskId());
    editTicketDialog.shipperZendeskId.setValue(recoveryTicket.getCustZendeskId());
    editTicketDialog.ticketComments.scrollIntoView();
    editTicketDialog.ticketComments.setValue(recoveryTicket.getTicketComments());
    editTicketDialog.updateTicket.clickAndWaitUntilDone();
  }

  public boolean verifyTicketIsExist(String trackingId) {
    searchTableByTrackingId(trackingId);
    pause3s();
    String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
    return trackingId.equals(actualTrackingId);
  }

  public boolean verifyTicketExistsInTheCorrectStatusFilter(String trackingId) {
    String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
    return trackingId.equals(actualTrackingId);
  }

  public void enterTrackingId(String trackingId) {
    trackingIdFilter.setValue(trackingId);
    pause1s();
    loadSelection.clickAndWaitUntilDone();
  }

  public void chooseTicketStatusFilter(String status) {
    ticketStatusFilter.selectFilter(status);
    loadSelection.clickAndWaitUntilDone();
    pause1s();
  }

  public void chooseEntrySourceFilter(String entrySource) {
    clearAllSelections.click();
    pause2s();
    addFilter.selectValue("Entry Source");
    pause1s();
    entrySourceFilter.selectFilter(entrySource);
    loadSelection.clickAndWaitUntilDone();
    pause1s();
  }

  public void addInvestigatingHubFilter(String hub) {
    clearAllSelections.click();
    pause2s();
    addFilter.selectValue("Investigating Hub");
    pause1s();
    investigationHubFilter.selectFilter(hub);
    loadSelection.clickAndWaitUntilDone();
    pause1s();
  }

  public void addInvestigatingDeptFilter(String dept) {
    clearAllSelections.click();
    pause2s();
    addFilter.selectValue("Investigating Dept.");
    pause1s();
    investigationDeptFilter.selectFilter(dept);
    loadSelection.clickAndWaitUntilDone();
    pause1s();
  }

  public void showUnassignedFilter(String show) {
    clearAllSelections.click();
    pause2s();
    if (isElementVisible(XPATH_REMOVE_TRACKINGID_FILTER)) {
      click(XPATH_REMOVE_TRACKINGID_FILTER);
    }
    addFilter.selectValue("Show Unassigned");
    pause1s();
    showUnassignedFilter.selectFilter(StringUtils.equalsIgnoreCase("yes", show));
    loadSelection.clickAndWaitUntilDone();
    pause1s();
  }

  public void resolvedTicketsFilter(String filter) {
    addFilter.selectValue("Resolved Tickets");
    pause1s();
    resolverTicketsFilter.selectFilter(StringUtils.equalsIgnoreCase("show", filter));
    pause1s();
  }

  public void createdAtFilter(String createdAtTo) {
    addFilter.selectValue("Created At");
    pause1s();
    createdAtFilter.simpleSetValue(createdAtTo);
    pause1s();
  }

  public void assignToTicket(String assignTo) {
    editTicketDialog.waitUntilVisible();
    editTicketDialog.assignTo.selectValue(assignTo);
    editTicketDialog.updateTicket.clickAndWaitUntilDone();
    waitUntilInvisibilityOfToast();
  }

  public void chooseAllTicketStatusFilters() {
    ticketStatusFilter.clearAll();
    ticketStatusFilter.selectFilter("IN PROGRESS");
    ticketStatusFilter.selectFilter("PENDING");
    ticketStatusFilter.selectFilter("PENDING SHIPPER");
    ticketStatusFilter.selectFilter("CANCELLED");
    ticketStatusFilter.selectFilter("RESOLVED");

    loadSelection.clickAndWaitUntilDone();
  }

  public void verifyTicketIsMade(String trackingId) {
    pause1s();
    String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
    Assertions.assertThat(actualTrackingId).as("Ticket with this tracking ID is not created")
        .isEqualTo(trackingId);
  }

  public void verifyTicketStatus(String expectedStatus) {
    ticketsTable.clickActionButton(1, ACTION_EDIT);
    pause2s();
    String status = getTextById("ticket-status");
    assertEquals(expectedStatus.toLowerCase(), status.toLowerCase());
  }

  public void searchTableByTrackingId(String trackingId) {
    // Remove default filters.
    clearAllSelections.click();
    pause1s();

    // Fill tracking ID by filling it and press ENTER.
    trackingIdFilter.setValue(trackingId);
    pause1s();

    // Click load selection.
    loadSelection.clickAndWaitUntilDone();
  }

  public void searchTableByTrackingIdWithoutLoads(String trackingId) {
    trackingIdFilter.setValue(trackingId);
    pause1s();
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    waitUntilInvisibilityOfElementLocated(
        "//md-progress-circular/following-sibling::div[text()='Loading data...']");
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }

  public String displayNoResults() {
    pause2s();
    return getText("//table[contains(@class,'noStripe')]//h5");
  }

  /**
   * Accessor for Recovery Tickets table
   */
  public static class TicketsTable extends MdVirtualRepeatTable<RecoveryTicket> {

    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String ACTION_EDIT = "edit";

    public TicketsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_TRACKING_ID, "tracking-id")
          .build()
      );
      setEntityClass(RecoveryTicket.class);
      setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "Edit"));
      setMdVirtualRepeat("ticket in getTableData()");
    }
  }

  public static class CreateTicketDialog extends MdDialog {

    @FindBy(id = "trackingId")
    public TextBox trackingId;

    @FindBy(css = "[id^='entry-source']")
    public MdSelect entrySource;

    @FindBy(css = "[id^='investigating-dept']")
    public MdSelect investigatingDept;

    @FindBy(css = "[id^='investigating-hub']")
    public MdSelect investigatingHub;

    @FindBy(css = "[id^='ticket-type']")
    public MdSelect ticketType;

    @FindBy(css = "[id^='ticket-sub-type']")
    public MdSelect ticketSubtype;

    @FindBy(css = "[id^='order-outcome']")
    public MdSelect orderOutcome;

    @FindBy(css = "[id^='commons.rts-reason']")
    public MdSelect rtsReason;

    @FindBy(id = "parcelLocation")
    public MdSelect parcelLocation;

    @FindBy(id = "liability")
    public MdSelect liability;

    @FindBy(id = "damageDescription")
    public TextBox damageDescription;

    @FindBy(id = "parcelDescription")
    public TextBox parcelDescription;

    @FindBy(id = "exceptionReason")
    public TextBox exceptionReason;

    @FindBy(id = "issueDescription")
    public TextBox issueDescription;

    @FindBy(css = "[id^='customer-zendesk-id']")
    public TextBox customerZendeskId;

    @FindBy(css = "[id^='shipper-zendesk-id']")
    public TextBox shipperZendeskId;

    @FindBy(id = "ticket-notes")
    public TextBox ticketNotes;

    @FindBy(name = "Create Ticket")
    public NvApiTextButton createTicket;

    public CreateTicketDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class EditTicketDialog extends MdDialog {

    @FindBy(css = "[id^='container.recovery-tickets.ticket-status']")
    public MdSelect ticketStatus;

    @FindBy(css = "[id^='container.recovery-tickets.assign-to']")
    public MdSelect assignTo;

    @FindBy(css = "[id^='order-outcome']")
    public MdSelect orderOutcome;

    @FindBy(css = "[id*='rts-reason']")
    public MdSelect rtsReason;

    @FindBy(css = "[id^='container.recovery-tickets.enter-new-instruction']")
    public TextBox newInstructions;

    @FindBy(css = "[id^='container.recovery-tickets.customer-zendesk-id']")
    public TextBox customerZendeskId;

    @FindBy(css = "[id^='container.recovery-tickets.shipper-zendesk-id']")
    public TextBox shipperZendeskId;

    @FindBy(css = "[id^='container.recovery-tickets.ticket-comments']")
    public TextBox ticketComments;

    @FindBy(name = "Update Ticket")
    public NvApiTextButton updateTicket;

    public EditTicketDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
