package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RecoveryTicketsScanning;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */
public class RecoveryTicketsScanningPage extends OperatorV2SimplePage {
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

        if(TICKET_TYPE_DAMAGED.equals(ticketType)) {
            fillTheForm(trackingId, recoveryTicketsScanning, true);
        }
        else if(TICKET_TYPE_MISSING.equals(ticketType)) {
            fillTheForm(trackingId, recoveryTicketsScanning, false);
        }
        else if(TICKET_TYPE_SELF_COLLECTION.equals(ticketType)) {
            fillTheForm(trackingId, recoveryTicketsScanning, false);
        }
        else if(TICKET_TYPE_PARCEL_COLLECTION.equals(ticketType)) {
            fillTheForm(trackingId, recoveryTicketsScanning, true);
        }
        else if(TICKET_TYPE_SHIPPER_ISSUE.equals(ticketType)) {
            fillTheForm(trackingId, recoveryTicketsScanning, true);
        }
        pause100ms();
    }

    public void verifyDetailsTicket(String trackingId) {
        String actualTrackingId = getTextOnTable(1, "trackingId");
        Assert.assertEquals("Ticket with this tracking ID is not created", trackingId, actualTrackingId);
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
        String actualResult = findElementByXpath("//table/tbody/tr[contains(@ng-if,'ctrl.tickets.length')]/td").getText();
        Assert.assertEquals("Ticket is created", "No created ticket", actualResult);
    }

    public void verifyDialogueAndSave() {
        waitUntilVisibilityOfElementLocated("//md-dialog-content[@class='md-dialog-content']");
        clickButtonByAriaLabel("Save");
    }

    public void fillTheForm(String trackingId, RecoveryTicketsScanning recoveryTicketsScanning, Boolean hasSubtype) {

        String ticketType = recoveryTicketsScanning.getTicketType();
        String investigatingGroup = recoveryTicketsScanning.getInvestigatingGroup();
        String entrySource = recoveryTicketsScanning.getEntrySource();
        String comment = recoveryTicketsScanning.getComment();
        String ticketSubtype = recoveryTicketsScanning.getTicketSubtype();

        selectFromCombobox("Ticket Type", ticketType);
        pause2s();
        selectFromCombobox("Investigating Group", investigatingGroup);
        selectFromCombobox("Entry Source", entrySource);

        if(hasSubtype) {
            selectFromCombobox("Ticket Subtype", ticketSubtype);
        }

        sendKeysByName("comments", comment);
        sendKeysAndEnterById("trackingId-input", trackingId);
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
