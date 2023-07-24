package co.nvqa.operator_v2.cucumber.glue.recovery;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.recovery.RecoveryTicketsPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.ArrayList;
import java.time.ZonedDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.junit.Assert;

public class RecoveryTicketsSteps extends AbstractSteps {

  private RecoveryTicketsPage recoveryTicketsPage;

  @Override
  public void init() {
    recoveryTicketsPage = new RecoveryTicketsPage(getWebDriver());
  }

  @Given("Operator goes to new Recovery Tickets page")
  public void goToNewRecoveryTicketsPage() {
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/recovery-tickets-new");
  }

  @When("Operator create ticket by csv in Recovery Tickets page")
  public void createTicketByCsv() {
    recoveryTicketsPage.inFrame(() -> {
      recoveryTicketsPage.waitUntilPageLoaded();
      recoveryTicketsPage.createByCsv.click();
      recoveryTicketsPage.creatByCSVDialog.title.waitUntilVisible(60);
      Assertions.assertThat(recoveryTicketsPage.creatByCSVDialog.title.getText())
          .isEqualTo("Create Tickets Via CSV");
      recoveryTicketsPage.creatByCSVDialog.searchByEntrySource("AIR FREIGHT REJECTION");
      recoveryTicketsPage.creatByCSVDialog.searchByTicketType("MISSING");
      recoveryTicketsPage.creatByCSVDialog.searchByInvestigationDept("Recovery");
    });
  }

  @When("Operator upload a CSV file without header")
  public void uploadCsvWithoutHeader() {
    recoveryTicketsPage.inFrame(() -> {
      recoveryTicketsPage.creatByCSVDialog.generateNoHeadersFile();
      recoveryTicketsPage.creatByCSVDialog.uploadFile.click();
    });
  }

  @Then("Operator verifies error message is displayed")
  @Then("Operator verifies partial success message is displayed")
  public void verifyMessageInDialog(Map<String, String> data) {
    recoveryTicketsPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      String actualTop = recoveryTicketsPage.creatByCSVDialog.message.get(0).getText();
      String value = finalData.get("top");
      if (StringUtils.isNotBlank(value)) {
        Assertions.assertThat(actualTop).as("correct top").isEqualTo(value);
      }
      value = finalData.get("bottom");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.creatByCSVDialog.message.get(1).getText();
        Assertions.assertThat(actual).as("correct bottom").isEqualTo(value);
      }
      Assertions.assertThat(
              recoveryTicketsPage.creatByCSVDialog.displayedUploadedFileName.getText())
          .as("correct file name").contains(finalData.get("fileName"));
    });
  }

  @When("Operator downloads sample csv file on Create Tickets Via CSV modal")
  public void verifyFileDownloaded() {
    recoveryTicketsPage.inFrame((page) -> {
      page.creatByCSVDialog.downloadTemplate.click();
      final String fileName = page.getLatestDownloadedFilename(
          page.creatByCSVDialog.SAMPLE_CSV_FILENAME_PATTERN);
      page.verifyFileDownloadedSuccessfully(fileName);
    });
  }

  @When("Operator Upload a CSV file Create Tickets Via CSV modal with following data:")
  public void uploadCSVFile(Map<String, String> data) {
    recoveryTicketsPage.inFrame(() -> {
      Map<String, String> dataTable = resolveKeyValues(data);
      List<String> ticketType = Arrays.stream(dataTable.get("type").split(","))
          .map(String::trim)
          .collect(Collectors.toList());
      List<String> ticketSubType =
          dataTable.containsKey("subType") ? Arrays.stream(dataTable.get("subType").split(","))
              .map(String::trim)
              .collect(Collectors.toList()) : new ArrayList<>();
      String investigationGroup = dataTable.get("investigationGroup");
      String assigneeEmail = dataTable.get("assigneeEmail");
      String investigationHubId = dataTable.get("investigationHubId");
      String entrySource = dataTable.get("entrySource");
      String ticketNotes = dataTable.get("ticketNotes");
      List<String> trackingIds = Arrays.stream(dataTable.get("trackingIds").split(","))
          .map(String::trim)
          .collect(Collectors.toList());

      StringBuilder content = new StringBuilder(
          "tracking_id,type,sub_type,investigating_group,assignee_email,investigating_hub_id,entry_source,ticket_notes\n");

      trackingIds.forEach(trackingId -> {
        int index = trackingIds.indexOf(trackingId);
        String currentTicketSubType = "";
        if (index < ticketSubType.size()) {
          currentTicketSubType = ticketSubType.get(index);
        }
        String csvRow = trackingId + "," +
            ticketType.get(index) + "," +
            currentTicketSubType + "," +
            investigationGroup + "," +
            assigneeEmail + "," +
            investigationHubId + "," +
            entrySource + "," +
            ticketNotes + "\n";

        content.append(csvRow);
      });
      File file = recoveryTicketsPage.createFile(
          String.format("csv_create_tickets_%s.csv", StandardTestUtils.generateDateUniqueString()),
          content.toString());
      recoveryTicketsPage.creatByCSVDialog.fileUpload.setValue(file);

      for (String trackingId : trackingIds) {
        int index = trackingIds.indexOf(trackingId);
        RecoveryTicket recoveryTicket = new RecoveryTicket();
        recoveryTicket.setTrackingId(trackingId);
        recoveryTicket.setAssignTo(assigneeEmail);
        recoveryTicket.setTicketType(ticketType.get(index));
        if (index < ticketSubType.size()) {
          recoveryTicket.setTicketSubType(ticketSubType.get(index));
        }
        recoveryTicket.setInvestigatingDepartment(investigationGroup);
        recoveryTicket.setInvestigatingHub(investigationHubId);
        recoveryTicket.setTicketNotes(ticketNotes);
        recoveryTicket.setEntrySource(entrySource);
        put("recoveryTicket", recoveryTicket);
      }
      recoveryTicketsPage.creatByCSVDialog.uploadFile.click();
    });
  }

  @When("Operator click Find Tickets By CSV on Recovery Tickets Page")
  public void findTicketByCSV() {
    recoveryTicketsPage.inFrame((page) -> {
      page.findByCsv.click();
      page.findTicketsByCSVDialog.waitUntilVisible(60);
      Assertions.assertThat(page.findTicketsByCSVDialog.title.getText()).as("correct dialog")
          .isEqualTo("Find Tickets by CSV");
    });
  }

  @When("Operator upload a csv on Find Tickets By CSV dialog")
  public void uploadFindTicketsCSV(List<String> listOfTrackingId) {
    recoveryTicketsPage.inFrame(() -> {
      if (CollectionUtils.isEmpty(listOfTrackingId)) {
        throw new IllegalArgumentException(
            "the list of created Tracking IDs shouldn't be null or empty.");
      }
      String csvContents = resolveValues(listOfTrackingId).stream()
          .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
      File csvFile = recoveryTicketsPage.createFile(
          String.format("find-tickets-by-csv_%s.csv", StandardTestUtils.generateDateUniqueString()),
          csvContents);
      recoveryTicketsPage.findTicketsByCSVDialog.uploadComponent.setValue(csvFile);
      Assertions.assertThat(recoveryTicketsPage.findTicketsByCSVDialog.uploadedFileName.getText())
          .contains("find-tickets-by-csv_");
      recoveryTicketsPage.findTicketsByCSVDialog.search.click();
    });
  }

  @Then("Operator verifies invalid search result message is shown on Find Tickets by CSV dialog")
  public void verifySearchResultMessageIsShown(Map<String, String> data) {
    recoveryTicketsPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      String actualTop = recoveryTicketsPage.findTicketsByCSVDialog.errorMessage.getText();
      String value = finalData.get("message");
      if (StringUtils.isNotBlank(value)) {
        Assertions.assertThat(actualTop).as("correct result message").isEqualTo(value);
      }
      List<String> trackingIdsValues = Arrays.stream(finalData.get("trackingIds").split(","))
          .map(String::trim)
          .collect(Collectors.toList());
      List<String> actualTrackingIds = recoveryTicketsPage.findTicketsByCSVDialog.invalidTrackingId.stream()
          .map(PageElement::getText)
          .collect(Collectors.toList());
      if (trackingIdsValues.size() != actualTrackingIds.size()) {
        return;
      }
      Assert.assertEquals("Correct invalid tracking IDs", trackingIdsValues, actualTrackingIds);
    });
  }

  @When("Operator click Load Selection button on Find Tickets by CSV dialog")
  public void clickLoadSelection() {
    recoveryTicketsPage.inFrame(() -> {
      recoveryTicketsPage.findTicketsByCSVDialog.loadSelection.click();
    });
  }

  @Then("Operator verifies correct ticket details as following:")
  public void verifyTicketDetails(Map<String, String> data) {
    recoveryTicketsPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      String actualTop = recoveryTicketsPage.resultsTable.trackingId.getText();
      String value = finalData.get("trackingId");
      if (StringUtils.isNotBlank(value)) {
        Assertions.assertThat(actualTop).as("created ticket for tracking Id").isEqualTo(value);
      }
      value = finalData.get("ticketType/subType");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.ticketType.getText();
        Assertions.assertThat(actual).as("ticket type / sub type").isEqualTo(value);
      }
      value = finalData.get("orderGranularStatus");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.orderGranularStatus.getText();
        Assertions.assertThat(actual).as("order granular status").isEqualTo(value);
      }
      value = finalData.get("ticketCreator");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.ticketCreator.getText();
        Assertions.assertThat(actual).as("ticket creator").isEqualTo(value);
      }
      value = finalData.get("shipper");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.shipper.getText();
        Assertions.assertThat(actual).as("shipper").isEqualTo(value);
      }
      value = finalData.get("redTickets");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.redTickets.getText();
        Assertions.assertThat(actual).as("red tickets").isEqualTo(value);
      }
      value = finalData.get("investigatingHub");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.investigatingHub.getText();
        Assertions.assertThat(actual).as("investigating Hub").isEqualTo(value);
      }
      value = finalData.get("InvestigatingDept");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.InvestigatingDept.getText();
        Assertions.assertThat(actual).as("Investigating Dept").isEqualTo(value);
      }
      value = finalData.get("status");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.status.getText();
        Assertions.assertThat(actual).as("status").isEqualTo(value);
      }
      value = finalData.get("assignee");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.assignee.getText();
        Assertions.assertThat(actual).as("assignee").isEqualTo(value);
      }
      value = finalData.get("daysSince");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.daysSince.getText();
        Assertions.assertThat(actual).as("days since").isEqualTo(value);
      }
      value = finalData.get("created");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.resultsTable.created.getText();
        Assertions.assertThat(actual).as("created").contains(value);
      }
    });
  }

  @When("Operator click {string} on Creat Ticket Via CSV dialog")
  public void clickButtonOnCreateTicketViaCSVDialog(String buttonName) {
    recoveryTicketsPage.inFrame(() -> {
      switch (buttonName) {
        case "Done":
          recoveryTicketsPage.creatByCSVDialog.done.click();
          break;
        case "Proceed With Valid Data":
          recoveryTicketsPage.creatByCSVDialog.proceedWithValidData.click();
          // should pause to wait the new message appears.
          pause5s();
          break;
        case "Download Error Data File":
          recoveryTicketsPage.creatByCSVDialog.downloadErrorData.click();
      }
    });
  }

  @Then("Operator verify error data file downloaded successfully with correct content")
  public void verifyErrorDataFileDownloadedWithCorrectInfo() {
    recoveryTicketsPage.inFrame((page) -> {
      RecoveryTicket recoveryTicket = get("recoveryTicket");
      String trackingId = recoveryTicket.getTrackingId();
      String type = recoveryTicket.getTicketType();
      String subType = recoveryTicket.getTicketSubType();
      String investigationGroup = recoveryTicket.getInvestigatingDepartment();
      String assigneeEmail = recoveryTicket.getAssignTo();
      String investigationHubId = recoveryTicket.getInvestigatingHub();
      String entrySource = recoveryTicket.getEntrySource();
      String ticketNotes = recoveryTicket.getTicketNotes();
      String reason = "Invalid Tracking ID";
      String expectedText = f("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%s",
          trackingId, type, subType,
          investigationGroup, assigneeEmail, investigationHubId, entrySource, ticketNotes, reason);
      final String fileName = page.getLatestDownloadedFilename(
          page.creatByCSVDialog.ERROR_DATA_CSV_FILE_NAME);
      recoveryTicketsPage.verifyFileDownloadedSuccessfully(fileName, expectedText, true);
    });
  }

  @When("Operator downloads search csv sample file on Find Tickets by CSV modal")
  public void downloadAndVerifySearchSampleFile() {
    recoveryTicketsPage.inFrame((page) -> {
      page.findTicketsByCSVDialog.downloadSample.click();
      final String fileName = page.getLatestDownloadedFilename(
          page.findTicketsByCSVDialog.SEARCH_SAMPLE_CSV_FILENAME_PATTERN);
      page.verifyFileDownloadedSuccessfully(fileName);
    });
  }


  @When("Operator create new ticket on new page Recovery Tickets using data below:")
  public void createNewSingleTicket(Map<String, String> map) {
    recoveryTicketsPage.inFrame(() -> {
      Map<String, String> mapOfData = resolveKeyValues(map);
      recoveryTicketsPage.waitUntilPageLoaded();
      pause5s();
      recoveryTicketsPage.createNewTicket.click();
      String trackingId = mapOfData.get("trackingId");
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
      String breachReason = mapOfData.get("breachReason");
      String breachLeg = mapOfData.get("breachLeg");

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
      recoveryTicket.setBreachReason(breachReason);
      recoveryTicket.setBreachLeg(breachLeg);

      recoveryTicketsPage.createTicket(recoveryTicket);
      put("recoveryTicket", recoveryTicket);
    });
  }

  @When("Operator filter search result by field {string} with value {string}")
  public void filterSearchResultByTrackingId(String field, String value) {
    recoveryTicketsPage.inFrame((page) -> {
      final String finalValue = resolveValue(value);
      page.resultsTable.filterByField(field, finalValue);
    });
  }

  @When("Operator clear the filter search")
  public void clearFilterSearch() {
    recoveryTicketsPage.inFrame((page) -> {
      page.resultsTable.clearFilterButton.click();
    });
  }
}
