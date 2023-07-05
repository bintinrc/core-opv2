package co.nvqa.operator_v2.cucumber.glue.recovery;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.selenium.page.recovery.RecoveryTicketsPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.io.File;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

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

  @When("Operator creat ticket by csv in Recovery Tickets page")
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
//      recoveryTicketsPage.creatByCSVDialog.done.click();
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
      List<String> ticketSubType = Arrays.stream(dataTable.get("subType").split(","))
          .map(String::trim)
          .collect(Collectors.toList());
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
        String csvRow = trackingId + "," +
            ticketType.get(index) + "," +
            ticketSubType.get(index) + "," +
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

      RecoveryTicket recoveryTicket = new RecoveryTicket();
      trackingIds.forEach(trackingId -> {
        int index = trackingIds.indexOf(trackingId);
        recoveryTicket.setTrackingId(trackingId);
        recoveryTicket.setAssignTo(assigneeEmail);
        recoveryTicket.setTicketType(ticketType.get(index));
        recoveryTicket.setTicketSubType(ticketSubType.get(index));
        recoveryTicket.setInvestigatingDepartment(investigationGroup);
        recoveryTicket.setInvestigatingHub(investigationHubId);
        recoveryTicket.setTicketNotes(ticketNotes);
        recoveryTicket.setEntrySource(entrySource);
        put("recoveryTicket", recoveryTicket);
      });
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
      recoveryTicketsPage.findTicketsByCSVDialog.search.click();
    });
  }

  @Then("Operator verifies invalid search result message is shown")
  public void verifySearchResultMessageIsShown(Map<String, String> data) {
    recoveryTicketsPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      String actualTop = recoveryTicketsPage.findTicketsByCSVDialog.errorMessage.getText();
      String value = finalData.get("message");
      if (StringUtils.isNotBlank(value)) {
        Assertions.assertThat(actualTop).as("correct result message").isEqualTo(value);
      }
      value = finalData.get("trackingId");
      if (StringUtils.isNotBlank(value)) {
        String actual = recoveryTicketsPage.findTicketsByCSVDialog.invalidTrackingId.getText();
        Assertions.assertThat(actual).as("correct invalid tracking id").isEqualTo(value);
      }
      recoveryTicketsPage.findTicketsByCSVDialog.loadSelection.click();
    });
  }

  @Then("Operator verifies correct ticket details as following:")
  public void verifyTicketDetails(Map<String, String> data) {
    // add assertions for all the details of the ticket
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
        Assertions.assertThat(actual).as("Order Granular Status").isEqualTo(value);
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
}
