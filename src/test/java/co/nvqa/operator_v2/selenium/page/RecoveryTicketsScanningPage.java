package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RecoveryTicketsScanning;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class RecoveryTicketsScanningPage extends OperatorV2SimplePage {

  @FindBy(id = "ticketType")
  public MdSelect ticketType;

  @FindBy(id = "entrySource")
  public MdSelect entrySource;

  @FindBy(id = "investigatingGroup")
  public MdSelect investigatingGroup;

  @FindBy(id = "investigatingHub")
  public MdSelect investigatingHub;

  @FindBy(id = "trackingId-input")
  public TextBox trackingId;

  @FindBy(id = "comments")
  public TextBox comments;

  @FindBy(css = "[aria-label='Prompt invalid tracking id']]")
  public MdCheckbox promptInvalidTrackingId;

  public static final String NG_REPEAT = "ticket in ctrl.tickets track by $index";

  public static final String TICKET_TYPE_DAMAGED = "DAMAGED";
  public static final String TICKET_TYPE_MISSING = "MISSING";
  public static final String TICKET_TYPE_SELF_COLLECTION = "SELF COLLECTION";
  public static final String TICKET_TYPE_PARCEL_COLLECTION = "PARCEL EXCEPTION";
  public static final String TICKET_TYPE_SHIPPER_ISSUE = "SHIPPER ISSUE";

  public RecoveryTicketsScanningPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void fillTheField(String trackingId, RecoveryTicketsScanning recoveryTicketsScanning) {
    pause1s();
    String ticketType = recoveryTicketsScanning.getTicketType();

    if (TICKET_TYPE_DAMAGED.equals(ticketType)) {
      fillTheForm(trackingId, recoveryTicketsScanning, false);
    } else if (TICKET_TYPE_MISSING.equals(ticketType)) {
      fillTheForm(trackingId, recoveryTicketsScanning, false);
    } else if (TICKET_TYPE_SELF_COLLECTION.equals(ticketType)) {
      fillTheForm(trackingId, recoveryTicketsScanning, false);
    } else if (TICKET_TYPE_PARCEL_COLLECTION.equals(ticketType)) {
      fillTheForm(trackingId, recoveryTicketsScanning, true);
    } else if (TICKET_TYPE_SHIPPER_ISSUE.equals(ticketType)) {
      fillTheForm(trackingId, recoveryTicketsScanning, true);
    }
    pause100ms();
  }

  public void verifyDetailsTicket(String trackingId) {
    String actualTrackingId = getTextOnTable(1, "trackingId");
    assertEquals("Ticket with this tracking ID is not created", trackingId, actualTrackingId);
  }

  public void clickCreateTicketButton() {
    clickNvApiTextButtonByNameAndWaitUntilDone("Create Ticket");
    waitUntilInvisibilityOfToast("Success create tickets");
  }

  public void verifyDialogueAndCancel() {
    waitUntilVisibilityOfElementLocated("//md-dialog-content[@class='md-dialog-content']");
    clickButtonByAriaLabel("Cancel");
  }

  public void verifyTicketIsNotMade() {
    String actualResult = findElementByXpath(
        "//table/tbody/tr[contains(@ng-if,'ctrl.tickets.length')]/td").getText();
    assertEquals("Ticket is created", "No created ticket", actualResult);
  }

  public void verifyDialogueAndSave() {
    waitUntilVisibilityOfElementLocated("//md-dialog-content[@class='md-dialog-content']");
    clickButtonByAriaLabel("Save");
  }

  public void fillTheForm(String trackingId, RecoveryTicketsScanning recoveryTicketsScanning,
      Boolean hasSubtype) {

    String ticketType = recoveryTicketsScanning.getTicketType();
    String investigatingGroup = recoveryTicketsScanning.getInvestigatingGroup();
    String investigatingHub = recoveryTicketsScanning.getInvestigatingHub();
    String entrySource = recoveryTicketsScanning.getEntrySource();
    String comment = recoveryTicketsScanning.getComment();
    String ticketSubtype = recoveryTicketsScanning.getTicketSubtype();

    this.ticketType.selectValue(ticketType);
    pause2s();
    this.investigatingGroup.searchAndSelectValue(investigatingGroup);
    this.investigatingHub.searchAndSelectValue(investigatingHub);
    this.entrySource.selectValue(entrySource);

    if (hasSubtype) {
      selectFromCombobox("Ticket Subtype", ticketSubtype);
    }

    this.comments.setValue(comment);
    this.trackingId.setValue(trackingId + Keys.ENTER);
  }

  public void selectFromCombobox(String ariaLabel, String selectedValue) {
    clickf("//md-select[contains(@aria-label, '%s')]", ariaLabel);
    pause100ms();
    clickf("//md-option/div[normalize-space(text())='%s']", selectedValue);
    pause50ms();
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
  }
}
