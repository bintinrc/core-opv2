package com.nv.qa.selenium.page;

import org.openqa.selenium.WebDriver;

import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RecoveryTicketsPage extends SimplePage
{
    private static final int SUBMIT_BUTTON_LOADING_TIMEOUT_IN_SECONDS = 30;
    private static final int MAX_RETRY = 10;
    private static final String MD_VIRTUAL_REPEAT = "ticket in getTableData()";

    public static final String COLUMN_CLASS_FILTER_TRACKING_ID = "tracking-id";
    public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking-id";

    public static final String TICKET_TYPE_DAMAGED = "DAMAGED";
    public static final String TICKET_TYPE_MISSING = "MISSING";

    public RecoveryTicketsPage(WebDriver driver)
    {
        super(driver);
    }

    public void clickCreateNewTicketButton()
    {
        click("//button[@aria-label='Create New Ticket']");
    }

    public void selectFromCombobox(String ariaLabel, String selectedValue)
    {
        click(String.format("//md-select[contains(@aria-label, '%s')]", ariaLabel));
        pause100ms();
        click(String.format("//md-option/div[normalize-space(text())='%s']", selectedValue));
        pause50ms();
    }

    public void selectEntrySource(String entrySource)
    {
        selectFromCombobox("Entry Source", entrySource);
    }

    public void selectInvestigatingParty(String investigatingParty)
    {
        selectFromCombobox("Investigating Party", investigatingParty);
    }

    public void selectTicketType(String ticketType)
    {
        selectFromCombobox("Ticket Type", ticketType);
    }

    public void selectTicketSubType(String ticketSubType)
    {
        selectFromCombobox("Ticket Sub Type", ticketSubType);
    }

    public void selectParcelLocation(String parcelLocation)
    {
        selectFromCombobox("Parcel Location", parcelLocation);
    }

    public void selectLiability(String liability)
    {
        selectFromCombobox("Liability", liability);
    }

    public void setDamageDescription(String damageDescription)
    {
        sendKeys("//input[@aria-label='Damage Description']", damageDescription);
    }

    public void setParcelDescription(String parcelDescription)
    {
        sendKeys("//input[@aria-label='Parcel Description']", parcelDescription);
    }

    public void setTicketNotes(String ticketNotes)
    {
        sendKeys("//textarea[@aria-label='Ticket Notes']", ticketNotes);
    }

    public void setCustZendeskId(String custZendeskId)
    {
        sendKeys("//input[@aria-label='Customer Zendesk ID']", custZendeskId);
    }

    public void setShipperZendeskId(String shipperZendeskId)
    {
        sendKeys("//input[@aria-label='Shipper Zendesk ID']", shipperZendeskId);
    }

    public void selectOrderOutcome(String orderOutcome)
    {
        selectFromCombobox("Order Outcome", orderOutcome);
    }

    public void setComments(String comments)
    {
        sendKeys("//textarea[@aria-label='Comments']", comments);
    }

    public void clickCreateTicketOnCreateNewTicketDialog()
    {
        click("//button[@aria-label='Create Ticket']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Create Ticket']//md-progress-circular", SUBMIT_BUTTON_LOADING_TIMEOUT_IN_SECONDS);
        pause50ms();
    }

    public void searchTableByTrackingId(String trackingId)
    {
        altClick("//button[@aria-label='Clear All']");
        pause50ms();
        click("//button[@aria-label='Remove Filter']");
        pause50ms();
        sendKeys("//input[@placeholder='Select Filter']", "Query");
        pause50ms();
        click("//md-virtual-repeat-container[@aria-hidden='false']/div/div[2]/ul/li/md-autocomplete-parent-scope/span/span[contains(text(), 'Query')]");
        pause50ms();
        sendKeys("//input[@aria-label='Query']", trackingId);
        pause50ms();
        altClick("//button[@aria-label='Load Selection']");
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void createTicket(String trackingId, Map<String,String> mapOfParam)
    {
        String entrySource = mapOfParam.get("entrySource");
        String investigatingParty = mapOfParam.get("investigatingParty");
        String ticketType = mapOfParam.get("ticketType");

        click("//button[@aria-label='Create New Ticket']");
        sendKeys("//input[@aria-label='Tracking ID']", trackingId+" "); // Add 1 <SPACE> character at the end of tracking ID to make the textbox get trigged and request tracking ID validation to backend.
        selectEntrySource(entrySource);
        selectInvestigatingParty(investigatingParty);
        selectTicketType(ticketType);

        if(TICKET_TYPE_DAMAGED.equals(ticketType))
        {
            String ticketSubType = mapOfParam.get("ticketSubType");
            String parcelLocation = mapOfParam.get("parcelLocation");
            String liability = mapOfParam.get("liability");
            String damageDescription = mapOfParam.get("damageDescription");
            String ticketNotes = mapOfParam.get("ticketNotes");
            String custZendeskId = mapOfParam.get("custZendeskId");
            String shipperZendeskId = mapOfParam.get("shipperZendeskId");
            String orderOutcome = mapOfParam.get("orderOutcome");

            selectTicketSubType(ticketSubType);
            selectParcelLocation(parcelLocation);
            selectLiability(liability);
            setDamageDescription(damageDescription);
            setTicketNotes(ticketNotes);
            setCustZendeskId(custZendeskId);
            setShipperZendeskId(shipperZendeskId);
            selectOrderOutcome(orderOutcome);
        }
        else if(TICKET_TYPE_MISSING.equals(ticketType))
        {
            String parcelDescription = mapOfParam.get("parcelDescription");
            String ticketNotes = mapOfParam.get("ticketNotes");
            String custZendeskId = mapOfParam.get("custZendeskId");
            String shipperZendeskId = mapOfParam.get("shipperZendeskId");

            setParcelDescription(parcelDescription);
            setTicketNotes(ticketNotes);
            setCustZendeskId(custZendeskId);
            setShipperZendeskId(shipperZendeskId);
        }

        try
        {
            setImplicitTimeout(0);

            /**
             * Sometimes tracking ID textbox does not call the backend to verify the Tracking ID.
             * To fix it, we need key in the tracking ID over and over until the textbox call the backend
             * and enable the "Create Ticket" button.
             */

            int counter = 0;

            while(isElementExist("//button[@aria-label='Create Ticket'][@disabled='disabled']") && counter<=MAX_RETRY)
            {
                System.out.println("[INFO] Button \"Create Ticket\" still disabled. Trying to key in Tracking ID again.");
                sendKeys("//input[@aria-label='Tracking ID']", trackingId);
                pause1s();
                counter++;
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            resetImplicitTimeout();
        }

        clickCreateTicketOnCreateNewTicketDialog();
    }

    public boolean verifyTicketIsExist(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        pause3s();
        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        boolean isExist = trackingId.equals(actualTrackingId);
        return isExist;
    }
}
