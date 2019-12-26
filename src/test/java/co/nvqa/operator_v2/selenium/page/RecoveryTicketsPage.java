package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.NvFilterBooleanBox;
import co.nvqa.operator_v2.selenium.elements.NvFilterBox;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
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
    private static final String XPATH_REMOVE_TRACKINGID_FILTER = "//p[text()='Tracking IDs']/../following-sibling::div//button[@aria-label='Clear All']";

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

    @FindBy(xpath = "//nv-autocomplete[@placeholder='filter.select-filter']")
    public NvAutocomplete addFilter;

    public RecoveryTicketsPage(WebDriver webDriver)
    {
        super(webDriver);
        PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
    }

    public void createTicket(RecoveryTicket recoveryTicket)
    {
        waitUntilPageLoaded();
        String trackingId = recoveryTicket.getTrackingId();
        String ticketType = recoveryTicket.getTicketType();

        clickButtonByAriaLabel("Create New Ticket");
        sendKeysById("trackingId", trackingId + " "); // Add 1 <SPACE> character at the end of tracking ID to make the textbox get trigged and request tracking ID validation to backend.
        selectEntrySource(recoveryTicket.getEntrySource());
        selectInvestigatingDepartment(recoveryTicket.getInvestigatingDepartment());
        selectInvestigatingHub(recoveryTicket.getInvestigatingHub());
        selectTicketType(ticketType);

        switch (ticketType)
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

        retryIfRuntimeExceptionOccurred(() ->
        {
            if (isElementExistWait1Second("//button[@aria-label='Create Ticket'][@disabled='disabled']"))
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
        click(f(XPATH_FOR_FILTERS, "Ticket Status"));
        pause2s();
        click(f(XPATH_FOR_FILTER_OPTION, status));
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void addFilter(String entrySource)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        addFilter.selectValue("Entry Source");
        pause1s();
        entrySourceFilter.selectFilter(entrySource);
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void addInvestigatingHubFilter(String hub)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        addFilter.selectValue("Investigating Hub");
        pause1s();
        investigationHubFilter.selectFilter(hub);
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void addInvestigatingDeptFilter(String dept)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        addFilter.selectValue("Investigating Dept.");
        pause1s();
        investigationDeptFilter.selectFilter(dept);
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void showUnassignedFilter(String show)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        if (isElementVisible(XPATH_REMOVE_TRACKINGID_FILTER))
        {
            click(XPATH_REMOVE_TRACKINGID_FILTER);
        }
        addFilter.selectValue("Show Unassigned");
        pause1s();
        showUnassignedFilter.selectFilter(StringUtils.equalsIgnoreCase("yes", show));
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void resolvedTicketsFilter(String filter)
    {
        clickButtonByAriaLabel("Clear All Selections");
        pause2s();
        if (isElementVisible(XPATH_REMOVE_TRACKINGID_FILTER))
        {
            click(XPATH_REMOVE_TRACKINGID_FILTER);
        }
        addFilter.selectValue("Resolved Tickets");
        pause1s();
        resolverTicketsFilter.selectFilter(StringUtils.equalsIgnoreCase("show", filter));
        pause1s();
        altClick(XPATH_LOAD_SELECTION);
        pause1s();
    }

    public void assignToTicket(String assignTo)
    {
        waitUntilPageLoaded();
        selectAssignTo(assignTo);
        clickButtonByAriaLabel("Update Ticket");
        waitUntilInvisibilityOfToast();
    }

    public void chooseAllTicketStatusFilters()
    {
        ticketStatusFilter.selectFilter("IN PROGRESS");
        ticketStatusFilter.selectFilter("PENDING");
        ticketStatusFilter.selectFilter("PENDING SHIPPER");
        ticketStatusFilter.selectFilter("CANCELLED");
        ticketStatusFilter.selectFilter("RESOLVED");

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
        assertEquals(expectedStatus.toLowerCase(), status.toLowerCase());
    }

    public void selectEntrySource(String entrySource)
    {
        selectValueFromMdSelectById("entry-source", entrySource);
    }

    public void selectTicketStatus(String ticketStatus)
    {
        selectValueFromMdSelectByIdContains("ticket-status", ticketStatus);
    }

    public void selectOrderOutcome(String orderOutcome)
    {
        selectValueFromMdSelectByIdContains("order-outcome", orderOutcome);
    }

    public void selectAssignTo(String assignTo)
    {
        selectValueFromMdSelectByIdContains("assign-to", assignTo);
    }

    public void setEnterNewInstruction(String enterNewInstruction)
    {
        sendKeysByAriaLabel("Enter New Instruction", enterNewInstruction);
    }

    public void setTicketComments(String ticketComments)
    {
        sendKeysByAriaLabel("Ticket Comments", ticketComments);
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
        selectValueFromMdSelectById("orderOutcome(InaccurateAddress)", orderOutcomeInaccurateAddress);
    }

    public void selectOrderOutcomeDuplicateParcel(String orderOutcomeDuplicateParcel)
    {
        scrollIntoView("//*[@id='orderOutcome(DuplicateParcel)']");
        selectValueFromMdSelectById("orderOutcome(DuplicateParcel)", orderOutcomeDuplicateParcel);
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
        String xpathExpression = f("//td[@class='%s']", id);
        scrollIntoView(f(xpathExpression, id));
        pause2s();
        String text = getText(xpathExpression).replace("▸", "").trim();
        return text;
    }

}
