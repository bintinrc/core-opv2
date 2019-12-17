package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RecoveryTicketsSteps extends AbstractSteps
{
    private RecoveryTicketsPage recoveryTicketsPage;

    public RecoveryTicketsSteps()
    {
    }

    @Override
    public void init()
    {
        recoveryTicketsPage = new RecoveryTicketsPage(getWebDriver());
    }

    @When("^Operator create new ticket on page Recovery Tickets using data below:$")
    public void createNewTicket(Map<String,String> mapOfData)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        String entrySource = mapOfData.get("entrySource");
        String investigatingDepartment = mapOfData.get("investigatingDepartment");
        String investigatingHub = mapOfData.get("investigatingHub");
        String ticketType = mapOfData.get("ticketType");
        String ticketSubType = mapOfData.get("ticketSubType");
        String parcelLocation = mapOfData.get("parcelLocation");
        String liability = mapOfData.get("liability");
        String damageDescription = mapOfData.get("damageDescription");
        String orderOutcomeDamaged = mapOfData.get("orderOutcomeDamaged");
        String orderOutcomeMissing = mapOfData.get("orderOutcomeMissing");
        String custZendeskId = mapOfData.get("custZendeskId");
        String shipperZendeskId = mapOfData.get("shipperZendeskId");
        String ticketNotes = mapOfData.get("ticketNotes");
        String parcelDescription = mapOfData.get("parcelDescription");
        String exceptionReason = mapOfData.get("exceptionReason");
        String orderOutcomeInaccurateAddress = mapOfData.get("orderOutcomeInaccurateAddress");
        String orderOutcomeDuplicateParcel = mapOfData.get("orderOutcomeDuplicateParcel");
        String issueDescription = mapOfData.get("issueDescription");


        if("GENERATED".equals(damageDescription))
        {
            damageDescription = f("This damage description is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        if("GENERATED".equals(ticketNotes))
        {
            ticketNotes = f("This ticket notes is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        if("GENERATED".equals(parcelDescription))
        {
            parcelDescription = f("This parcel description is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        if("GENERATED".equals(exceptionReason))
        {
            exceptionReason = f("This exception reason is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        if("GENERATED".equals(issueDescription))
        {
            issueDescription = f("This issue description is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        RecoveryTicket recoveryTicket = new RecoveryTicket();
        recoveryTicket.setTrackingId(trackingId);
        recoveryTicket.setEntrySource(entrySource);
        recoveryTicket.setInvestigatingDepartment(investigatingDepartment);
        recoveryTicket.setInvestigatingHub(investigatingHub);
        recoveryTicket.setTicketType(ticketType);
        recoveryTicket.setTicketSubType(ticketSubType);
        recoveryTicket.setParcelLocation(parcelLocation);
        recoveryTicket.setLiability(liability);
        recoveryTicket.setDamageDescription(damageDescription);
        recoveryTicket.setOrderOutcomeDamaged(orderOutcomeDamaged);
        recoveryTicket.setOrderOutcomeMissing(orderOutcomeMissing);
        recoveryTicket.setCustZendeskId(custZendeskId);
        recoveryTicket.setShipperZendeskId(shipperZendeskId);
        recoveryTicket.setTicketNotes(ticketNotes);
        recoveryTicket.setParcelDescription(parcelDescription);
        recoveryTicket.setExceptionReason(exceptionReason);
        recoveryTicket.setOrderOutcomeInaccurateAddress(orderOutcomeInaccurateAddress);
        recoveryTicket.setOrderOutcomeDuplicateParcel(orderOutcomeDuplicateParcel);
        recoveryTicket.setIssueDescription(issueDescription);

        recoveryTicketsPage.createTicket(recoveryTicket);
        put("recoveryTicket", recoveryTicket);
    }

    @Then("^Operator verify ticket is created successfully on page Recovery Tickets$")
    public void verifyTicketIsCreateSuccessfully()
    {
        pause10s();
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        boolean isTicketCreated = recoveryTicketsPage.verifyTicketIsExist(trackingId);
        assertTrue(f("Ticket '%s' does not created.", trackingId), isTicketCreated);
    }

    @Then("Operator searches the created ticket and clicks on Edit button")
    public void searchAndEditTicket() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        recoveryTicketsPage.searchTableByTrackingId(trackingId);
        pause3s();
        recoveryTicketsPage.clickButtonByAriaLabel("Edit");
        pause2s();
    }

    @Then("Operator clicks on Cancel Ticket")
    public void clickCancelTicket() {
        recoveryTicketsPage.clickButtonByAriaLabel("Cancel Ticket");
    }

    @And("Operator clicks on Delete on pop up")
    public void operatorClicksOnDeleteOnPopUp() {
        recoveryTicketsPage.clickButtonByAriaLabel("Delete");
        pause2s();
    }

    @Then("Operator verifies that the status of ticket is {string}")
    public void operatorVerifiesThatTheStatusOfTicketIs(String expectedStatus) {
        recoveryTicketsPage.verifyTicketStatus(expectedStatus);
        recoveryTicketsPage.clickButtonByAriaLabel("Cancel");
        pause2s();
    }

    @And("Operator updates the ticket")
    public void updateTicket() {
        recoveryTicketsPage.clickButtonByAriaLabel("Update Ticket");
        pause5s();
    }

    @Then("Operator edits the ticket settings with below data and verifies it:")
    public void editTicketSettings(Map<String,String> mapOfData) {
        String ticketStatus = mapOfData.get("ticketStatus");
        String orderOutcome = mapOfData.get("orderOutcome");
        String assignTo = mapOfData.get("assignTo");
        String enterNewInstruction = mapOfData.get("enterNewInstruction");

        if("GENERATED".equals(enterNewInstruction))
        {
            enterNewInstruction = f("This instruction is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        RecoveryTicket recoveryTicket = new RecoveryTicket();
        recoveryTicket.setTicketStatus(ticketStatus);
        recoveryTicket.setOrderOutcome(orderOutcome);
        recoveryTicket.setAssignTo(assignTo);
        recoveryTicket.setEnterNewInstruction(enterNewInstruction);

        recoveryTicketsPage.editTicketSettings(recoveryTicket);
        pause5s();
        recoveryTicketsPage.clickButtonByAriaLabel("Edit");
        pause2s();
        assertEquals(recoveryTicket.getTicketStatus().toLowerCase(),recoveryTicketsPage.getTextById("ticket-status").toLowerCase());
        assertEquals(recoveryTicket.getOrderOutcome().toLowerCase(),recoveryTicketsPage.getTextById("order-outcome").toLowerCase());
        assertEquals(recoveryTicket.getAssignTo().toLowerCase(),recoveryTicketsPage.getTextById("assign-to").toLowerCase());
        assertEquals(recoveryTicket.getEnterNewInstruction().toLowerCase(),recoveryTicketsPage.getTextByIdForInputFields("last-instruction").toLowerCase());
        recoveryTicketsPage.clickButtonByAriaLabel("Cancel");
        pause2s();
    }

    @Then("Operator edits the Additional settings with below data and verifies it:")
    public void editAdditionalSettings(Map<String,String> mapOfData) {
        recoveryTicketsPage.clickButtonByAriaLabel("Edit");
        String customerZendeskId = mapOfData.get("customerZendeskId");
        String shipperZendeskId = mapOfData.get("shipperZendeskId");
        String ticketComments = mapOfData.get("ticketComments");

        if("RANDOM".equals(customerZendeskId))
        {
            customerZendeskId = f(String.valueOf(System.currentTimeMillis()/1000));
        }

        if("RANDOM".equals(shipperZendeskId))
        {
            shipperZendeskId = f(String.valueOf(System.currentTimeMillis()/1000));
        }

        if("GENERATED".equals(ticketComments))
        {
            ticketComments = f("This ticket comment is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        RecoveryTicket recoveryTicket = new RecoveryTicket();
        recoveryTicket.setCustZendeskId(customerZendeskId);
        recoveryTicket.setShipperZendeskId(shipperZendeskId);
        recoveryTicket.setTicketComments(ticketComments);

        recoveryTicketsPage.editAdditionalSettings(recoveryTicket);
        pause3s();
        recoveryTicketsPage.clickButtonByAriaLabel("Edit");
        pause3s();
        assertEquals(recoveryTicket.getCustZendeskId().trim(),recoveryTicketsPage.getInnerTextByIdForInputFields("customer-zendesk-id").trim());
        assertEquals(recoveryTicket.getShipperZendeskId().trim(),recoveryTicketsPage.getInnerTextByIdForInputFields("shipper-zendesk-id").trim());
        //Commenting the below assertion because of JIRA TICKETING-173(https://jira.ninjavan.co/browse/TICKETING-173)
        //assertEquals(recoveryTicket.getTicketComments().toLowerCase(),recoveryTicketsPage.getTextByClassInTable("comments").toLowerCase());
        recoveryTicketsPage.clickButtonByAriaLabel("Cancel");
        pause2s();
    }

    @Then("Operator changes the ticket status to {string}")
    public void changeTicketStatus(String status) {
        recoveryTicketsPage.selectTicketStatus(status);
        pause2s();
        recoveryTicketsPage.clickButtonByAriaLabel("Update Ticket");
        recoveryTicketsPage.waitUntilInvisibilityOfMdDialogByTitle("Edit Ticket");
    }

    @Then("Operator chooses the ticket status as {string}")
    public void ticketStatusFilter(String status) {
        recoveryTicketsPage.chooseTicketStatusFilter(status);
        pause2s();

    }

    @And("Operator clicks on Edit Filters button")
    public void clickEditFiltersButton() {
        recoveryTicketsPage.clickNvIconTextButtonByName("Edit Filter");
        pause2s();
    }

    @When("Operator removes all ticket status filters")
    public void removeAllTicketStatusAndTrackingIdFilters() {
        recoveryTicketsPage.waitUntilPageLoaded();
        String xpathExpressionForTrackingIdFilter = "//p[text()='Tracking IDs']/parent::div/following-sibling::div//button[@aria-label='Clear All']";
        recoveryTicketsPage.clickButtonByAriaLabel("Clear All Selections");
        if(recoveryTicketsPage.isElementVisible(xpathExpressionForTrackingIdFilter))
        {
            recoveryTicketsPage.click(xpathExpressionForTrackingIdFilter);

        }
        recoveryTicketsPage.click("//p[text()='Ticket Status']/parent::div/following-sibling::div//button[@aria-label='Clear All']");
    }

    @And("Operator enters the tracking id and verifies that is exists")
    public void operatorEntersTheTrackingIdAndVerifiesThatIsExists() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        recoveryTicketsPage.scrollIntoView("//span[text()='Tracking ID']/..//input");
        recoveryTicketsPage.sendKeys("//span[text()='Tracking ID']/..//input",trackingId);
        pause2s();
        boolean doesTicketExist = recoveryTicketsPage.verifyTicketExistsInTheCorrectStatusFilter(trackingId);
        assertTrue(f("Ticket '%s' exists in correct filer",trackingId), doesTicketExist);
        pause2s();
    }

    @Then("Operator changes the ticket status to Resloved")
    public void changeTicketStatusToResloved() {
        recoveryTicketsPage.selectTicketStatus("RESOLVED");
        pause2s();
        recoveryTicketsPage.clickButtonByAriaLabel("Keep");
        pause2s();
    }

    @Then("Operator chooses all the ticket status filters")
    public void chooseAllTheTicketStatusFilters() {
        recoveryTicketsPage.chooseAllTicketStatusFilters();
    }

    @Then("Operator chooses Entry Source Filter as {string}")
    public void chooseEntrySourceFilter(String entrySource) {
        recoveryTicketsPage.addFilter(entrySource);
    }

    @When("Operator enters the wrong Tracking Id")
    public void entersWrongTrackingId() {
        String trackingId = "NVSGTEST"+f(String.valueOf(System.currentTimeMillis()/1000));
        recoveryTicketsPage.searchTableByTrackingId(trackingId);
    }

    @Then("No Results should be displayed")
    public void noResultsShouldDisplayed() {
        String expectedResult = "No Results Found";
        String actualresult = recoveryTicketsPage.displayNoResults();
        assertEquals(expectedResult.toLowerCase().trim(),actualresult.trim().toLowerCase());
    }
}
