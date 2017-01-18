package com.nv.qa.selenium.page;

import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RecoveryTicketsPage extends SimplePage
{
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
        sendKeys("//input[@aria-label='Ticket Notes']", ticketNotes);
    }

    public void setCustZendeskId(String custZendeskId)
    {
        sendKeys("//input[@aria-label='Cust Zendesk Id']", custZendeskId);
    }

    public void setShipperZendeskId(String shipperZendeskId)
    {
        sendKeys("//input[@aria-label='Shipper Zendesk Id']", shipperZendeskId);
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
        pause50ms();
    }

    public void searchTableByTrackingId(String trackingId)
    {
        searchTableCustom1(COLUMN_CLASS_FILTER_TRACKING_ID, trackingId);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void searchTicket22(String keywords)
    {
        sendKeysAndEnter("//input[@placeholder='Search Ticket Types...']", keywords);
        pause1s();
    }

    public void createTicket(String trackingId, Map<String,String> mapOfParam)
    {
        String entrySource = mapOfParam.get("entrySource");
        String investigatingParty = mapOfParam.get("investigatingParty");
        String ticketType = mapOfParam.get("ticketType");

        click("//button[@aria-label='Create New Ticket']");
        sendKeys("//input[@aria-label='Tracking ID']", trackingId);
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
            String comments = mapOfParam.get("comments");

            selectTicketSubType(ticketSubType);
            selectParcelLocation(parcelLocation);
            selectLiability(liability);
            setDamageDescription(damageDescription);
            setTicketNotes(ticketNotes);
            setCustZendeskId(custZendeskId);
            setShipperZendeskId(shipperZendeskId);
            selectOrderOutcome(orderOutcome);
            setComments(comments);
        }
        else if(TICKET_TYPE_MISSING.equals(ticketType))
        {
            String parcelDescription = mapOfParam.get("parcelDescription");
            String ticketNotes = mapOfParam.get("ticketNotes");
            String custZendeskId = mapOfParam.get("custZendeskId");
            String shipperZendeskId = mapOfParam.get("shipperZendeskId");
            String comments = mapOfParam.get("comments");

            setParcelDescription(parcelDescription);
            setTicketNotes(ticketNotes);
            setCustZendeskId(custZendeskId);
            setShipperZendeskId(shipperZendeskId);
            setComments(comments);
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
