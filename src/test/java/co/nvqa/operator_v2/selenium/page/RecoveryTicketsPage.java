package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.RecoveryTicket;
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

    private static final String TICKET_TYPE_DAMAGED = "DAMAGED";
    private static final String TICKET_TYPE_MISSING = "MISSING";
    private static final String TICKET_TYPE_PARCEL_EXCEPTION = "PARCEL EXCEPTION";
    private static final String TICKET_TYPE_SHIPPER_ISSUE = "SHIPPER ISSUE";
    private static final String XPATH_FOR_FILTERS = "//p[text()='%s']/parent::div/following-sibling::div//input";
    private static final String XPATH_FOR_FILTER_OPTION = "//span[text()='%s']";
    private static final String XPATH_LOAD_SELECTION = "//button[@aria-label='Load Selection']";
    private static final String XPATH_SELECT_FILTER = "//input[@aria-label='Select Filter']";
    private static final String XPATH_ARROW_DROPDOWN = "//label[text()='Add Filter']/..//i[text()='arrow_drop_down']";
    private static final String XPATH_SHOW_UNASSIGNED_RESOLVED_TICKET = "//span[text()='%s']/parent::button";
    private static final String XPATH_REMOVE_TRACKINGID_FILTER = "//p[text()='Tracking IDs']/../following-sibling::div//button[@aria-label='Clear All']";

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
            case TICKET_TYPE_PARCEL_EXCEPTION:
            {
                selectTicketSubType(recoveryTicket.getTicketSubType());
                selectOrderOutcomeInaccurateAddress(recoveryTicket.getOrderOutcomeInaccurateAddress());
                setExceptionReason(recoveryTicket.getExceptionReason());
                setCustZendeskId(recoveryTicket.getCustZendeskId());
                setShipperZendeskId(recoveryTicket.getShipperZendeskId());
                setTicketNotes(recoveryTicket.getTicketNotes());
                break;
            }
            case TICKET_TYPE_SHIPPER_ISSUE:
            {
                selectTicketSubType(recoveryTicket.getTicketSubType());
                selectOrderOutcomeDuplicateParcel(recoveryTicket.getOrderOutcomeDuplicateParcel());
                setIssueDescription(recoveryTicket.getIssueDescription());
                setCustZendeskId(recoveryTicket.getCustZendeskId());
                setShipperZendeskId(recoveryTicket.getShipperZendeskId());
                setTicketNotes(recoveryTicket.getTicketNotes());
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


    public void editTicketSettings(RecoveryTicket recoveryTicket)
    {
        waitUntilPageLoaded();
        pause2s();
        selectTicketStatus(recoveryTicket.getTicketStatus());
        selectOrderOutcome(recoveryTicket.getOrderOutcome());
        selectAssignTo(recoveryTicket.getAssignTo());
        setEnterNewInstruction(recoveryTicket.getEnterNewInstruction());
        clickButtonByAriaLabel("Update Ticket");
    }

    public void editAdditionalSettings(RecoveryTicket recoveryTicket)
    {
        waitUntilPageLoaded();
        pause2s();
        setCustomerZendeskId(recoveryTicket.getCustZendeskId());
        setShipZendeskId(recoveryTicket.getCustZendeskId());
        setTicketComments(recoveryTicket.getTicketComments());
        clickButtonByAriaLabel("Update Ticket");
    }

    public boolean verifyTicketIsExist(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        pause3s();
        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        return trackingId.equals(actualTrackingId);
    }

    public boolean verifyTicketExistsInTheCorrectStatusFilter(String trackingId)
    {
        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        return trackingId.equals(actualTrackingId);
    }

    public void enterTrackingId(String trackingId)
    {
        waitUntilVisibilityOfElementLocated("//nv-api-text-button[@name='commons.load-selection']");
        selectValueFromMdAutocomplete("Select Filter", "Tracking IDs");
        sendKeysAndEnterByAriaLabel("Type in here..", trackingId);
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
        pause1s();
    }

    public void chooseTicketStatusFilter(String status)
    {
        click(f(XPATH_FOR_FILTERS,"Ticket Status"));
        pause2s();
        click(f(XPATH_FOR_FILTER_OPTION,status));
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void addFilter(String entrySource)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        click(XPATH_SELECT_FILTER);
        click(f(XPATH_FOR_FILTER_OPTION,"Entry Source"));
        click(XPATH_ARROW_DROPDOWN);
        pause1s();
        click(f(XPATH_FOR_FILTERS,"Entry Source"));
        click(f(XPATH_FOR_FILTER_OPTION,entrySource));
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void addInvestigatingHubFilter(String hub)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        click(XPATH_SELECT_FILTER);
        click(f(XPATH_FOR_FILTER_OPTION,"Investigating Hub"));
        click(XPATH_ARROW_DROPDOWN);
        pause1s();
        click(f(XPATH_FOR_FILTERS,"Investigating Hub"));
        sendKeys(f(XPATH_FOR_FILTERS,"Investigating Hub"),hub);
        click(f(XPATH_FOR_FILTER_OPTION,hub));
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void addInvestigatingDeptFilter(String dept)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        click(XPATH_SELECT_FILTER);
        click(f(XPATH_FOR_FILTER_OPTION,"Investigating Dept."));
        click(XPATH_ARROW_DROPDOWN);
        pause1s();
        click(f(XPATH_FOR_FILTERS,"Investigating Dept."));
        sendKeysAndEnter(f(XPATH_FOR_FILTERS,"Investigating Dept."),dept);
        pause2s();
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void showUnassignedFilter(String show)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        if(isElementVisible(XPATH_REMOVE_TRACKINGID_FILTER))
        {
            click(XPATH_REMOVE_TRACKINGID_FILTER);
        }
        click(XPATH_SELECT_FILTER);
        click(f(XPATH_FOR_FILTER_OPTION,"Show Unassigned"));
        click(XPATH_ARROW_DROPDOWN);
        pause1s();
        click(f(XPATH_SHOW_UNASSIGNED_RESOLVED_TICKET,show));
        pause1s();
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void resolvedTicketsFilter(String filter)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        if(isElementVisible(XPATH_REMOVE_TRACKINGID_FILTER))
        {
            click(XPATH_REMOVE_TRACKINGID_FILTER);
        }
        click(XPATH_SELECT_FILTER);
        click(f(XPATH_FOR_FILTER_OPTION,"Resolved Tickets"));
        click(XPATH_ARROW_DROPDOWN);
        pause1s();
        click(f(XPATH_SHOW_UNASSIGNED_RESOLVED_TICKET,filter));
        pause1s();
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void assignToTicket(String assignTo)
    {
        waitUntilPageLoaded();
        selectAssignTo(assignTo);
        clickButtonByAriaLabel("Update Ticket");
    }

    public void chooseAllTicketStatusFilters()
    {
        click(f(XPATH_FOR_FILTERS,"Ticket Status"));
        pause2s();
        click(f(XPATH_FOR_FILTER_OPTION,"IN PROGRESS"));
        click(f(XPATH_FOR_FILTER_OPTION,"ON HOLD"));
        click(f(XPATH_FOR_FILTER_OPTION,"PENDING"));
        click(f(XPATH_FOR_FILTER_OPTION,"PENDING SHIPPER"));
        click(f(XPATH_FOR_FILTER_OPTION,"CANCELLED"));
        click(f(XPATH_FOR_FILTER_OPTION,"RESOLVED"));
        altClick(XPATH_LOAD_SELECTION);
    }

    public void verifyTicketIsMade(String trackingId)
    {
        pause1s();
        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        assertEquals("Ticket with this tracking ID is not created", trackingId, actualTrackingId);
    }

    public void verifyTicketStatus(String expectedStatus)
    {
        clickButtonByAriaLabel("Edit");
        pause2s();
        String status = getTextById("ticket-status");
        assertEquals(expectedStatus.toLowerCase(),status.toLowerCase());
    }

    public void selectEntrySource(String entrySource)
    {
        selectValueFromMdSelectById("entry-source", entrySource);
    }

    public void selectTicketStatus(String ticketStatus)
    {
        selectValueFromMdSelectByIdContains("ticket-status" , ticketStatus);
    }

    public void selectOrderOutcome(String orderOutcome)
    {
        selectValueFromMdSelectByIdContains("order-outcome", orderOutcome);
    }

    public void selectAssignTo(String assignTo)
    {
        selectValueFromMdSelectByIdContains("assign-to" , assignTo);
    }

    public void setEnterNewInstruction(String enterNewInstruction) { sendKeysByAriaLabel("Enter New Instruction", enterNewInstruction); }

    public void setTicketComments(String ticketComments) {sendKeysByAriaLabel("Ticket Comments" , ticketComments);}

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

    public void setExceptionReason(String exceptionReason)
    {
        sendKeysById("exceptionReason", exceptionReason);
    }

    public void setIssueDescription(String issueDescription)
    {
        sendKeysById("issueDescription", issueDescription);
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

    public void setCustomerZendeskId(String customerZendeskId)
    {
        sendKeysByAriaLabel("Customer Zendesk ID", customerZendeskId);
    }

    public void setShipZendeskId(String shipperZendeskId)
    {
        sendKeysByAriaLabel("Shipper Zendesk ID", shipperZendeskId);
    }

    public void setShipperZendeskId(String shipperZendeskId)
    {
        sendKeysById("shipper-zendesk-id", shipperZendeskId);
    }

    public void selectOrderOutcomeDamaged(String orderOutcomeDamaged)
    {
        scrollIntoView("//*[@id='orderOutcome(Damaged)']");
        selectValueFromMdSelectById("orderOutcome(Damaged)", orderOutcomeDamaged);
    }

    public void selectOrderOutcomeInaccurateAddress(String orderOutcomeInaccurateAddress)
    {
        scrollIntoView("//*[@id='orderOutcome(InaccurateAddress)']");
        selectValueFromMdSelectById("orderOutcome(InaccurateAddress)",orderOutcomeInaccurateAddress);
    }

    public void selectOrderOutcomeDuplicateParcel(String orderOutcomeDuplicateParcel)
    {
        scrollIntoView("//*[@id='orderOutcome(DuplicateParcel)']");
        selectValueFromMdSelectById("orderOutcome(DuplicateParcel)",orderOutcomeDuplicateParcel);
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
        altClick(XPATH_LOAD_SELECTION);
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

    public String displayNoResults()
    {
        pause2s();
        String actualResult = getText("//table[contains(@class,'noStripe')]//h5");
        return actualResult;
    }

    public String getTextByClassInTable(String id)
    {
        String xpathExpression = f("//td[@class='%s']",id);
        scrollIntoView(f(xpathExpression,id));
        pause2s();
        String text = getText(xpathExpression).replace("▸","").trim();
        return text;
    }

}
