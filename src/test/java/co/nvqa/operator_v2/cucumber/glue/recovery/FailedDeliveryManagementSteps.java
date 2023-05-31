package co.nvqa.operator_v2.cucumber.glue.recovery;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.selenium.page.recovery.fdm.FailedDeliveryManagementPage;
import co.nvqa.operator_v2.selenium.page.recovery.fdm.FailedDeliveryManagementPage.FailedDeliveryTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.assertj.core.api.Assertions;

public class FailedDeliveryManagementSteps extends AbstractSteps {

  private FailedDeliveryManagementPage failedDeliveryManagementReactPage;

  public FailedDeliveryManagementSteps() {
  }

  @Override
  public void init() {
    failedDeliveryManagementReactPage = new FailedDeliveryManagementPage(getWebDriver());
  }

  @When("Recovery User - Wait until FDM Page loaded completely")
  public void doWaitUntilPageLoaded() {
    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.fdmHeader.waitUntilVisible(60);
    });
  }

  @When("Recovery User - Search failed orders by trackingId = {string}")
  public void doFilterByTrackingId(String trackingId) {
    failedDeliveryManagementReactPage.inFrame(
            page -> page.fdmTable.filterTableByTID("trackingId", resolveValue(trackingId)));
  }

  @When("Recovery User - Search failed orders by shipperName = {string}")
  public void doFilterByShipperId(String shipperName) {
    failedDeliveryManagementReactPage.inFrame(
            page -> page.fdmTable.filterTableByShipperName("shipperName", resolveValue(shipperName)));
  }

  @When("Recovery User - Clear the TID filter")
  public void doClearTIDFilter() {
    failedDeliveryManagementReactPage.inFrame(page -> {
      page.fdmTable.clearTIDFilter();
    });
  }

  @Then("Recovery User - verify failed delivery table on FDM page:")
  public void doverifyFdmTable(Map<String, String> dataTable) {
    FailedDelivery expected = new FailedDelivery(resolveKeyValues(dataTable));

    failedDeliveryManagementReactPage.inFrame(page -> {
      page.waitUntilLoaded(3);
      List<String> actual = page.fdmTable.getFilteredValue();

      Assertions.assertThat(actual.get(1)).as("TrackingId is Match")
              .isEqualTo(expected.getTrackingId());
      Assertions.assertThat(actual.get(3)).as("Shipper Name is Match")
              .isEqualTo(expected.getShipperName());
      Assertions.assertThat(actual.get(5)).as("Failure Comments is Match")
              .isEqualTo(expected.getFailureReasonComments());
    });
  }

  @Given("Recovery User - clicks {string} button on Failed Delivery Management page")
  public void operatorClicksButtonOnFdmPage(String buttonName) {
    failedDeliveryManagementReactPage.inFrame(page -> {
      switch (buttonName) {
        case "Select All Shown":
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.selectAll.click();
          break;
        case "Deselect All Shown":
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.deselectAll.click();
          break;
        case "Clear Current Selection":
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.selectAll.click();
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.clearCurrentSelection.click();
          break;
        case "Show Only Selected":
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.showOnlySelected.click();
          break;
        case "CSV Reschedule":
          page.csvReschedule.click();
      }
    });
  }

  @Then("Recovery User - verifies number of selected rows on Failed Delivery Management page")
  public void operatorVerifiesNumberOfSelectedRows() {
    failedDeliveryManagementReactPage.inFrame(() ->
            failedDeliveryManagementReactPage.verifyBulkSelectResult()
    );
  }

  @Then("Recovery User - verify the number of selected Failed Delivery rows is {value}")
  public void operatorVerifiesNumberOfSelectedRow(String expectedRowCount) {
    failedDeliveryManagementReactPage.inFrame(() -> {
      String selectedRows = failedDeliveryManagementReactPage.fdmTable.selectedRowCount.getText();
      Assertions.assertThat(selectedRows).as("Number of selected rows are the same")
              .contains(expectedRowCount);
    });
  }

  @Given("Recovery User - selects {int} rows on Failed Delivery Management page")
  public void operatorSelectRowsOnFdmPage(int numberOfRows) {
    failedDeliveryManagementReactPage.inFrame(() -> {
      for (int i = 1; i <= numberOfRows; i++) {
        failedDeliveryManagementReactPage.fdmTable.clickActionButton(i,
                FailedDeliveryTable.ACTION_SELECT);
      }
    });
  }

  @Then("Recovery User - Download CSV file of failed delivery order on Failed Delivery orders list")
  public void operatorDownloadSelectedRowToCsv() {
    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.applyAction.click();
      failedDeliveryManagementReactPage.downloadCsvFileAction.click();
    });
  }

  @Then("Recovery User - verify CSV file of failed delivery order on Failed Delivery orders list downloaded successfully")
  public void verifyCsvFileDownloadedSuccessfully() {
    failedDeliveryManagementReactPage.inFrame(page -> {
      List<FailedDelivery> expectedFailedOrder = page.fdmTable.readAllEntities();
      final String fileName = page.getLatestDownloadedFilename(
              FailedDeliveryManagementPage.FDM_CSV_FILENAME_PATTERN);
      page.verifyFileDownloadedSuccessfully(fileName);
      final String pathName = StandardTestConstants.TEMP_DIR + fileName;

      List<FailedDelivery> actualFailedOrder = DataEntity
              .fromCsvFile(FailedDelivery.class, pathName, true);

      Assertions.assertThat(actualFailedOrder).as("Number of records is match")
              .hasSameSizeAs(expectedFailedOrder);

      for (int i = 0; i < actualFailedOrder.size(); i++) {
        expectedFailedOrder.get(i).compareWithActual(actualFailedOrder.get(i), "orderTags");
      }
    });
  }

  @Then("Recovery User - verify CSV file downloaded after reschedule")
  public void verifyCsvFileDownloadedAfterReschedule() {
    failedDeliveryManagementReactPage.inFrame(page -> {
      final String fileName = page.getLatestDownloadedFilename(
              FailedDeliveryManagementPage.RESCHEDULE_CSV_FILENAME_PATTERN);
      page.verifyFileDownloadedSuccessfully(fileName);
    });
  }

  @When("Recovery User - reschedule failed delivery order on next day")
  public void doRescheduleFailedDeliveryOrderOnNextDay() {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.fdmTable.clickActionButton(1, FailedDeliveryTable.ACTION_RESCHEDULE);
    });
  }

  @Then("Recovery User - verifies that toast displayed with message below:")
  public void doVerifiesToastDisplayed(Map<String, String> dataTable) {
    dataTable = resolveKeyValues(dataTable);
    String message = dataTable.get("message");
    String description = dataTable.get("description");
    failedDeliveryManagementReactPage.inFrame((page) -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        Assertions.assertThat(page.notifMessage.getText())
                .as(f("Notification Message contains: %s", message)).isEqualTo(message);
        Assertions.assertThat(page.notifDescription.getText())
                .as(f("Notification Description contains %s", description)).isEqualTo(description);
      }, 5);
    });
  }

  @Then("Recovery User - Reschedule Selected failed delivery order on Failed Delivery orders list")
  public void doRescheduleSelectedFailedDeliveryOrder() {
    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.applyAction.click();
      failedDeliveryManagementReactPage.rescheduleSelected.click();
    });
  }

  @When("Recovery User - set reschedule date to {string}")
  public void doSetRescheduleDate(String date) {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.rescheduleDialog.setRescheduleDate(resolveValue(date));
      page.rescheduleDialog.rescheduleButton.click();
    });
  }

  @When("Recovery User - Reschedule failed orders with CSV")
  public void doRescheduleByCSV(Map<String, String> dataTable) {
    dataTable = resolveKeyValues(dataTable);
    String rescheduleDate = dataTable.get("reschedule_date");
    List<String> trackingIds = Arrays.stream(dataTable.get("tracking_ids").split(","))
            .map(String::trim)
            .collect(Collectors.toList());

    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.uploadCSVDialog.generateRescheduleCSV(trackingIds,
              rescheduleDate);
      failedDeliveryManagementReactPage.uploadCSVDialog.upload.click();
    });
  }

  @When("Recovery User - RTS order on next day")
  public void selectRTS() {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.fdmTable.clickActionButton(1, FailedDeliveryTable.ACTION_RTS);
    });
  }

  @Then("Recovery User - verifies Edit RTS Details dialog")
  public void verifyRTSDialog(Map<String, String> dataMap) {
    Map<String, String> dataTable = resolveKeyValues(dataMap);
    failedDeliveryManagementReactPage.inFrame((page) -> {
      Assertions.assertThat(page.rtsDialog.recipientName.getAttribute("value")).isEqualTo(dataTable.get("recipientName"));
      Assertions.assertThat(page.rtsDialog.recipientContact.getAttribute("value")).isEqualTo(dataTable.get("recipientContact"));
      Assertions.assertThat(page.rtsDialog.recipientEmail.getAttribute("value")).isEqualTo(dataTable.get("recipientEmail"));
      Assertions.assertThat(page.rtsDialog.shipperInstructions.getAttribute("value")).isEqualTo(dataTable.get("shipperInstructions"));
      Assertions.assertThat(page.rtsDialog.country.getAttribute("value")).isEqualTo(dataTable.get("country"));
      Assertions.assertThat(page.rtsDialog.city.getAttribute("value")).isEqualTo("-");
      Assertions.assertThat(page.rtsDialog.address1.getAttribute("value")).isEqualTo(dataTable.get("address1"));
      Assertions.assertThat(page.rtsDialog.address2.getAttribute("value")).isEqualTo(dataTable.get("address2"));
      Assertions.assertThat(page.rtsDialog.postalCode.getAttribute("value")).isEqualTo(dataTable.get("postalCode"));

    });
  }
}
