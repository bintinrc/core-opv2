package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.RecoveryTicket;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class RecoveryTicketsPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "ticket in getTableData()";

    public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking-id";

    public static final String TICKET_TYPE_DAMAGED = "DAMAGED";
    public static final String TICKET_TYPE_MISSING = "MISSING";

    public RecoveryTicketsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void createTicket(RecoveryTicket recoveryTicket)
    {
        waitUntilPageLoaded();
        String trackingId = recoveryTicket.getTrackingId();
        String ticketType = recoveryTicket.getTicketType();

        clickButtonByAriaLabel("Create New Ticket");
        sendKeysById("trackingId", trackingId+" "); // Add 1 <SPACE> character at the end of tracking ID to make the textbox get trigged and request tracking ID validation to backend.
        selectEntrySource(recoveryTicket.getEntrySource());
        selectInvestigatingDepartment(recoveryTicket.getInvestigatingDepartment());
        selectInvestigatingHub(recoveryTicket.getInvestigatingHub());
        selectTicketType(ticketType);

        switch(ticketType)
        {
            case TICKET_TYPE_DAMAGED:
            {
                //selectTicketSubType(recoveryTicket.getTicketSubType());

                //Damaged Details
                selectParcelLocation(recoveryTicket.getParcelLocation());
                selectLiability(recoveryTicket.getLiability());
                setDamageDescription(recoveryTicket.getDamageDescription());
                selectOrderOutcomeDamaged(recoveryTicket.getOrderOutcomeDamaged());

                setCustZendeskId(recoveryTicket.getCustZendeskId());
                setShipperZendeskId(recoveryTicket.getShipperZendeskId());
                setTicketNotes(recoveryTicket.getTicketNotes());
                break;
            }
            case TICKET_TYPE_MISSING:
            {
                selectOrderOutcomeMissing(recoveryTicket.getOrderOutcomeMissing());
                setParcelDescription(recoveryTicket.getParcelDescription());
                setCustZendeskId(recoveryTicket.getCustZendeskId());
                setShipperZendeskId(recoveryTicket.getShipperZendeskId());
                setTicketNotes(recoveryTicket.getTicketNotes());
                break;
            }
        }

        retryIfRuntimeExceptionOccurred(()->
        {
            if(isElementExistWait1Second("//button[@aria-label='Create Ticket'][@disabled='disabled']"))
            {
                sendKeys("//input[@aria-label='Tracking ID']", trackingId);
                pause100ms();
                throw new NvTestRuntimeException("Button \"Create Ticket\" still disabled. Trying to key in Tracking ID again.");
            }
        });

        clickCreateTicketOnCreateNewTicketDialog();
        waitUntilInvisibilityOfToast("Ticket created");
    }

    public boolean verifyTicketIsExist(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        pause3s();
        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        return trackingId.equals(actualTrackingId);
    }

    public void removeFilterTicketSubType()
    {
        click("//nv-filter-box[@main-title='Ticket Sub Type']//button[@aria-label='Remove Filter']");
    }

    public void enterTrackingId(String trackingId)
    {
        waitUntilVisibilityOfElementLocated("//nv-api-text-button[@name='commons.load-selection']");
        selectValueFromMdAutocomplete("Select Filter", "Tracking IDs");
        sendKeysAndEnterByAriaLabel("Type in here..", trackingId);
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
        pause1s();
    }

    public void verifyTicketIsMade(String trackingId)
    {
        pause1s();
        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        Assert.assertEquals("Ticket with this tracking ID is not created", trackingId, actualTrackingId);
    }

    public void clickCreateNewTicketButton()
    {
        clickButtonByAriaLabel("Create New Ticket");
    }

    public void selectEntrySource(String entrySource)
    {
        selectValueFromMdSelectById("entry-source", entrySource);
    }

    public void selectInvestigatingDepartment(String investigatingDepartment)
    {
        selectValueFromMdSelectById("investigating-dept", investigatingDepartment);
    }

    public void selectInvestigatingHub(String investigatingHub)
    {
        selectValueFromMdSelectById("investigating-hub", investigatingHub);
    }

    public void selectTicketType(String ticketType)
    {
        selectValueFromMdSelectById("ticket-type", ticketType);
    }

    public void selectTicketSubType(String ticketSubType)
    {
        selectValueFromMdSelectById("ticket-sub-type", ticketSubType);
    }

    public void selectParcelLocation(String parcelLocation)
    {
        selectValueFromMdSelectById("parcelLocation", parcelLocation);
    }

    public void selectLiability(String liability)
    {
        selectValueFromMdSelectById("liability", liability);
    }

    public void setDamageDescription(String damageDescription)
    {
        sendKeysById("damageDescription", damageDescription);
    }

    public void setParcelDescription(String parcelDescription)
    {
        sendKeysById("parcelDescription", parcelDescription);
    }

    public void setTicketNotes(String ticketNotes)
    {
        sendKeysById("ticket-notes", ticketNotes);
    }

    public void setCustZendeskId(String custZendeskId)
    {
        sendKeysById("customer-zendesk-id", custZendeskId);
    }

    public void setShipperZendeskId(String shipperZendeskId)
    {
        sendKeysById("shipper-zendesk-id", shipperZendeskId);
    }

    public void selectOrderOutcomeDamaged(String orderOutcomeDamaged)
    {
        selectValueFromMdSelectById("orderOutcome(Damaged)", orderOutcomeDamaged);
    }

    public void selectOrderOutcomeMissing(String orderOutcomeMissing)
    {
        selectValueFromMdSelectById("orderOutcome(Missing)", orderOutcomeMissing);
    }

    public void setComments(String comments)
    {
        sendKeys("//textarea[@aria-label='Comments']", comments);
    }

    public void clickCreateTicketOnCreateNewTicketDialog()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Create Ticket");
        pause1s();
    }

    public void searchTableByTrackingId(String trackingId)
    {
        // Remove default filters.
        clickButtonByAriaLabel("Clear All Selections");
        pause1s();

        // Fill tracking ID by filling it and press ENTER.
        sendKeys("//div[@class='main-title']//p[text()='Tracking IDs']/../..//input", trackingId);
        altClick("//div[@class='main-title']//p[text()='Tracking IDs']/../..//input");
        pause1s();

        // Click load selection.
        altClick("//button[@aria-label='Load Selection']");
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading data...']");
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }
}
