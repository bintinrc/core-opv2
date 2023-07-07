package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.ZonedDateTime;
import java.util.Map;
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage.TicketsTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage.TicketsTable.COLUMN_TRACKING_ID;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RecoveryTicketsSteps extends AbstractSteps {

  private RecoveryTicketsPage recoveryTicketsPage;

  @Override
  public void init() {
    recoveryTicketsPage = new RecoveryTicketsPage(getWebDriver());
  }

  @When("^Operator create new ticket on page Recovery Tickets using data below:$")
  public void createNewTicket(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String trackingId = mapOfData.computeIfAbsent("trackingId",
        k -> get(KEY_CREATED_ORDER_TRACKING_ID));

    String entrySource = mapOfData.get("entrySource");
    String investigatingDepartment = mapOfData.get("investigatingDepartment");
    String investigatingHub = mapOfData.get("investigatingHub");
    String ticketType = mapOfData.get("ticketType");
    String ticketSubType = mapOfData.get("ticketSubType");
    String parcelLocation = mapOfData.get("parcelLocation");
    String liability = mapOfData.get("liability");
    String damageDescription = mapOfData.get("damageDescription");
    String orderOutcome = mapOfData.get("orderOutcome");
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
    String rtsReason = mapOfData.get("rtsReason");

    if ("GENERATED".equals(damageDescription)) {
      damageDescription = f("This damage description is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    if ("GENERATED".equals(ticketNotes)) {
      ticketNotes = f("This ticket notes is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    if ("GENERATED".equals(parcelDescription)) {
      parcelDescription = f("This parcel description is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    if ("GENERATED".equals(exceptionReason)) {
      exceptionReason = f("This exception reason is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    if ("GENERATED".equals(issueDescription)) {
      issueDescription = f("This issue description is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
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
    recoveryTicket.setOrderOutcome(orderOutcome);
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
    recoveryTicket.setRtsReason(rtsReason);

    recoveryTicketsPage.createTicket(recoveryTicket);
    put("recoveryTicket", recoveryTicket);
  }

  @Then("^Operator verify ticket is created successfully on page Recovery Tickets$")
  public void verifyTicketIsCreateSuccessfully() {
    pause10s();
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    boolean isTicketCreated = recoveryTicketsPage.verifyTicketIsExist(trackingId);
    Assertions.assertThat(isTicketCreated).as(f("Ticket '%s' does not created.", trackingId))
        .isTrue();
  }

  @Then("Operator verify ticket is created successfully on page Recovery Tickets for Tracking Id {value}")
  public void verifyTicketIsCreateSuccessfullyForTrackingId(String trackingId) {
    pause10s();
    boolean isTicketCreated = recoveryTicketsPage.verifyTicketIsExist(trackingId);
    Assertions.assertThat(isTicketCreated).as(f("Ticket '%s' does not created.", trackingId))
        .isTrue();
  }

  @Then("Operator searches the created ticket and clicks on Edit button")
  public void searchAndEditTicket() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    recoveryTicketsPage.searchTableByTrackingId(trackingId);
    pause3s();
    recoveryTicketsPage.ticketsTable.clickActionButton(1, ACTION_EDIT);
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
    recoveryTicketsPage.clickButtonByAriaLabel("Cancel Ticket");
    pause2s();
  }

  @And("Operator updates the ticket")
  public void updateTicket() {
    recoveryTicketsPage.clickButtonByAriaLabel("Update Ticket");
    pause5s();
  }

  @Then("Operator edits the ticket settings with below data and verifies it:")
  public void editTicketSettings(Map<String, String> mapOfData) {
    String ticketStatus = mapOfData.get("ticketStatus");
    String orderOutcome = mapOfData.get("orderOutcome");
    String assignTo = mapOfData.get("assignTo");
    String enterNewInstruction = mapOfData.get("enterNewInstruction");

    if ("GENERATED".equals(enterNewInstruction)) {
      enterNewInstruction = f("This instruction is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    RecoveryTicket recoveryTicket = new RecoveryTicket();
    recoveryTicket.setTicketStatus(ticketStatus);
    recoveryTicket.setOrderOutcome(orderOutcome);
    recoveryTicket.setAssignTo(assignTo);
    recoveryTicket.setEnterNewInstruction(enterNewInstruction);

    recoveryTicketsPage.editTicketSettings(recoveryTicket);
    pause5s();
    recoveryTicketsPage.ticketsTable.clickActionButton(1, ACTION_EDIT);
    pause2s();
    Assertions.assertThat(recoveryTicketsPage.getTextById("ticket-status").toLowerCase())
        .isEqualTo(recoveryTicket.getTicketStatus().toLowerCase());
    Assertions.assertThat(recoveryTicketsPage.getTextById("order-outcome").toLowerCase())
        .isEqualTo(recoveryTicket.getOrderOutcome().toLowerCase());
    Assertions.assertThat(recoveryTicketsPage.getTextById("assign-to").toLowerCase())
        .isEqualTo(recoveryTicket.getAssignTo().toLowerCase());
    Assertions.assertThat(recoveryTicketsPage.lastInstructionText.getText().toLowerCase())
        .isEqualTo(recoveryTicket.getEnterNewInstruction().toLowerCase());
    recoveryTicketsPage.editTicketDialog.forceClose();
    pause2s();
  }

  @Then("Operator updates the ticket settings with the following details:")
  public void updateTicketSettings(Map<String, String> mapOfData) {
    String ticketStatus = mapOfData.get("ticketStatus");
    String orderOutcome = mapOfData.get("orderOutcome");
    String assignTo = mapOfData.get("assignTo");
    String enterNewInstruction = mapOfData.get("enterNewInstruction");

    if ("GENERATED".equals(enterNewInstruction)) {
      enterNewInstruction = f("This instruction is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    RecoveryTicket recoveryTicket = new RecoveryTicket();
    recoveryTicket.setTicketStatus(ticketStatus);
    recoveryTicket.setOrderOutcome(orderOutcome);
    recoveryTicket.setAssignTo(assignTo);
    recoveryTicket.setEnterNewInstruction(enterNewInstruction);
    recoveryTicketsPage.editTicketSettings(recoveryTicket);
    pause5s();
  }

  @Then("Operator edits the Additional settings with below data and verifies it:")
  public void editAdditionalSettings(Map<String, String> mapOfData) {
    recoveryTicketsPage.ticketsTable.clickActionButton(1, ACTION_EDIT);
    String customerZendeskId = mapOfData.get("customerZendeskId");
    String shipperZendeskId = mapOfData.get("shipperZendeskId");
    String ticketComments = mapOfData.get("ticketComments");

    if ("RANDOM".equals(customerZendeskId)) {
      customerZendeskId = f(String.valueOf(System.currentTimeMillis() / 1000));
    }

    if ("RANDOM".equals(shipperZendeskId)) {
      shipperZendeskId = f(String.valueOf(System.currentTimeMillis() / 1000));
    }

    if ("GENERATED".equals(ticketComments)) {
      ticketComments = f("This ticket comment is created by automation at %s.",
          DTF_CREATED_DATE.format(ZonedDateTime.now()));
    }

    RecoveryTicket recoveryTicket = new RecoveryTicket();
    recoveryTicket.setCustZendeskId(customerZendeskId);
    recoveryTicket.setShipperZendeskId(shipperZendeskId);
    recoveryTicket.setTicketComments(ticketComments);

    recoveryTicketsPage.editAdditionalSettings(recoveryTicket);
    pause3s();
    recoveryTicketsPage.ticketsTable.clickActionButton(1, ACTION_EDIT);
    pause3s();
    Assertions.assertThat(
            recoveryTicketsPage.getInnerTextByIdForInputFields("customer-zendesk-id").trim())
        .isEqualTo(recoveryTicket.getCustZendeskId().trim());
    Assertions.assertThat(
            recoveryTicketsPage.getInnerTextByIdForInputFields("shipper-zendesk-id").trim())
        .isEqualTo(recoveryTicket.getShipperZendeskId().trim());
    //Commenting the below assertion because of JIRA TICKETING-173(https://jira.ninjavan.co/browse/TICKETING-173)
    //assertEquals(recoveryTicket.getTicketComments().toLowerCase(),recoveryTicketsPage.getTextByClassInTable("comments").toLowerCase());
    recoveryTicketsPage.editTicketDialog.forceClose();
    pause2s();
  }

  @Then("Operator changes the ticket status to {string}")
  public void changeTicketStatus(String status) {
    recoveryTicketsPage.editTicketDialog.ticketStatus.selectValue(status);
    pause2s();
    recoveryTicketsPage.editTicketDialog.updateTicket.clickAndWaitUntilDone();
    recoveryTicketsPage.editTicketDialog.waitUntilInvisible();
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
    if (recoveryTicketsPage.isElementVisible(xpathExpressionForTrackingIdFilter)) {
      recoveryTicketsPage.click(xpathExpressionForTrackingIdFilter);

    }
    recoveryTicketsPage.ticketStatusFilter.clearAll();
  }

  @And("Operator enters the tracking id and verifies that is exists")
  public void operatorEntersTheTrackingIdAndVerifiesThatIsExists() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    recoveryTicketsPage.ticketsTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
    pause2s();
    recoveryTicketsPage
        .waitUntilInvisibilityOfElementLocated("//*[contains(text(),'Loading more results')]", 60);
    boolean doesTicketExist = recoveryTicketsPage
        .verifyTicketExistsInTheCorrectStatusFilter(trackingId);
    Assertions.assertThat(doesTicketExist).as(f("Ticket '%s' exists in correct filer", trackingId))
        .isTrue();
    pause2s();
  }

  @Then("Operator changes the ticket status to Resloved")
  public void changeTicketStatusToResolved() {
    recoveryTicketsPage.editTicketDialog.ticketStatus.selectValue("RESOLVED");
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
    recoveryTicketsPage.chooseEntrySourceFilter(entrySource);
  }

  @When("Operator enters the wrong Tracking Id")
  public void entersWrongTrackingId() {
    String trackingId = "NVSGTEST" + f(String.valueOf(System.currentTimeMillis() / 1000));
    recoveryTicketsPage.searchTableByTrackingId(trackingId);
  }

  @When("Operator enters the Tracking Id")
  public void entersTrackingId() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    recoveryTicketsPage.searchTableByTrackingIdWithoutLoads(trackingId);
  }

  @Then("No Results should be displayed")
  public void noResultsShouldDisplayed() {
    String expectedResult = "No Results Found";
    String actualResult = recoveryTicketsPage.displayNoResults();
    Assertions.assertThat(actualResult.trim().toLowerCase())
        .isEqualTo(expectedResult.toLowerCase().trim());
  }

  @Then("Operator chooses Investigating Hub filter as {string}")
  public void chooseInvestigatingHubFilter(String hub) {
    recoveryTicketsPage.addInvestigatingHubFilter(hub);
  }

  @Then("Operator chooses Investigating Dept Filter as {string}")
  public void chooseInvestigatingDeptFilter(String dept) {
    recoveryTicketsPage.addInvestigatingDeptFilter(dept);
  }

  @Then("Operator chooses Show Unassigned Filter as {string}")
  public void chooseShowUnassignedFilter(String unassignedFilter) {
    recoveryTicketsPage.showUnassignedFilter(unassignedFilter);
  }

  @And("Operator assigns the ticket to {string}")
  public void operatorAssignsTheTicketTo(String assignTo) {
    recoveryTicketsPage.assignToTicket(assignTo);
  }

  @Then("Operator chooses Resolved Tickets Filter as {string}")
  public void chooseResolvedTicketsFilter(String filter) {
    recoveryTicketsPage.resolvedTicketsFilter(filter);
  }

  @Then("Operator chooses Created At Filter")
  public void chooseCreatedAtTicketsFilter(Map<String, String> mapOfData) {
    String toDate = mapOfData.get("toDate");
    recoveryTicketsPage.createdAtFilter(toDate);
  }

  @When("Operator clears all filters on Recovery Tickets page")
  public void clearAllFilters() {
    recoveryTicketsPage.clearAllSelections.click();
  }
}
