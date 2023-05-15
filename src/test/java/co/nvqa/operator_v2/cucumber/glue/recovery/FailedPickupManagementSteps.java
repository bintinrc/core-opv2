package co.nvqa.operator_v2.cucumber.glue.recovery;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.FailedPickup;
import co.nvqa.operator_v2.selenium.page.recovery.fpm.FailedPickupManagementPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;

import java.util.List;
import java.util.Map;

public class FailedPickupManagementSteps extends AbstractSteps {
  private FailedPickupManagementPage failedPickupManagementPage;

  public FailedPickupManagementSteps() {
  }

  @Override

  public void init() {
    failedPickupManagementPage = new FailedPickupManagementPage(getWebDriver());
  }

  @When("Recovery User - Wait until FPM Page loaded completely")
  public void doWaitUntilPageLoaded() {
    failedPickupManagementPage.inFrame(() -> {
      failedPickupManagementPage.fpmHeader.waitUntilVisible(60);
    });
  }

  @Given("Recovery User - clicks {string} button on Failed Pickup Management page")
  public void operatorClicksButtonOnFdmPage(String buttonName) {
    failedPickupManagementPage.inFrame(page -> {
      switch (buttonName) {
        case "Select All Shown":
          page.fpmTable.bulkSelectDropdown.click();
          page.fpmTable.selectAll.click();
          break;
        case "Deselect All Shown":
          page.fpmTable.bulkSelectDropdown.click();
          page.fpmTable.deselectAll.click();
          break;
        case "Clear Current Selection":
          page.fpmTable.bulkSelectDropdown.click();
          page.fpmTable.selectAll.click();
          page.fpmTable.bulkSelectDropdown.click();
          page.fpmTable.clearCurrentSelection.click();
          break;
        case "Show Only Selected":
          page.fpmTable.bulkSelectDropdown.click();
          page.fpmTable.showOnlySelected.click();
          break;
      }
    });
  }

  @Then("Recovery User - verifies number of selected rows on Failed Pickup Management page")
  public void operatorVerifiesNumberOfSelectedRows() {
    failedPickupManagementPage.inFrame(() ->
            failedPickupManagementPage.verifyBulkSelectResult()
    );
  }

  @Given("Recovery User - selects {int} rows on Failed Pickup Management page")
  public void operatorSelectRowsOnFpmPage(int numberOfRows) {
    failedPickupManagementPage.inFrame(() -> {
      for (int i = 1; i <= numberOfRows; i++) {
        failedPickupManagementPage.fpmTable.clickActionButton(i,
                FailedPickupManagementPage.FailedPickupTable.ACTION_SELECT);
      }
    });
  }

  @Then("Recovery User - verify the number of selected Failed Pickup rows is {value}")
  public void operatorVerifiesNumberOfSelectedRow(String expectedRowCount) {
    failedPickupManagementPage.inFrame(() -> {
      String selectedRows = failedPickupManagementPage.fpmTable.selectedRowCount.getText();
      Assertions.assertThat(selectedRows).as("Number of selected rows are the same")
              .contains(expectedRowCount);
    });
  }

  @Then("Recovery User - verify failed pickup table on FPM page:")
  public void doverifyFpmTable(Map<String, String> dataTable) {
    FailedPickup expected = new FailedPickup(resolveKeyValues(dataTable));

    failedPickupManagementPage.inFrame(page -> {
      page.waitUntilLoaded(3);
      List<String> actual = page.fpmTable.getFilteredValue();

      Assertions.assertThat(actual.get(1)).as("TrackingId is Match")
              .isEqualTo(expected.getTrackingId());
      Assertions.assertThat(actual.get(2)).as("Shipper Name is Match")
              .isEqualTo(expected.getShipperName());
      Assertions.assertThat(actual.get(4)).as("Failure Comments is Match")
              .isEqualTo(expected.getFailureReasonComments());
    });
  }

  @Then("Recovery User - Download CSV file of failed pickup order on Failed Pickup orders list")
  public void operatorDownloadSelectedRowToCsv() {
    failedPickupManagementPage.inFrame(() -> {
      failedPickupManagementPage.applyAction.click();
      failedPickupManagementPage.downloadCsvFileAction.waitUntilVisible();
      failedPickupManagementPage.downloadCsvFileAction.click();
    });
  }

  @Then("Recovery User - verify CSV file of failed pickup order on Failed Pickup orders list downloaded successfully")
  public void verifyCsvFileDownloadedSuccessfully() {
    failedPickupManagementPage.inFrame(page -> {
      List<FailedPickup> expectedFailedOrder = page.fpmTable.readAllEntities();
      final String fileName = page.getLatestDownloadedFilename(
              failedPickupManagementPage.FPM_CSV_FILENAME_PATTERN);
      page.verifyFileDownloadedSuccessfully(fileName);
      final String pathName = StandardTestConstants.TEMP_DIR + fileName;

      List<FailedPickup> actualFailedOrder = DataEntity
              .fromCsvFile(FailedPickup.class, pathName, true);

      Assertions.assertThat(actualFailedOrder).as("Number of records is match")
              .hasSameSizeAs(expectedFailedOrder);

      for (int i = 0; i < actualFailedOrder.size(); i++) {
        expectedFailedOrder.get(i).compareWithActual(actualFailedOrder.get(i));
      }
    });
  }

  @When("Recovery User - reschedule failed pickup order on next day")
  public void doRescheduleFailedDeliveryOrderOnNextDay() {
    failedPickupManagementPage.inFrame((page) -> {
      page.fpmTable.clickActionButton(1, FailedPickupManagementPage.FailedPickupTable.ACTION_RESCHEDULE);
    });
  }

  @Then("Recovery User - Reschedule Selected failed pickup order on Failed Pickup orders list")
  public void doRescheduleSelectedFailedPickupOrder() {
    failedPickupManagementPage.inFrame(() -> {
      failedPickupManagementPage.applyAction.click();
      failedPickupManagementPage.rescheduleSelected.click();
    });
  }

  @When("Recovery User - set reschedule date to {string} on Failed Pickup Management Page")
  public void doSetRescheduleDate(String date) {
    failedPickupManagementPage.inFrame((page) -> {
      page.rescheduleDialog.setRescheduleDate(resolveValue(date));
      page.rescheduleDialog.rescheduleButton.click();
    });
  }

  @Then("Recovery User - verify CSV file downloaded after reschedule failed pickup")
  public void verifyCsvFileDownloadedAfterReschedule() {
    failedPickupManagementPage.inFrame(page -> {
      final String fileName = page.getLatestDownloadedFilename(
              failedPickupManagementPage.RESCHEDULE_CSV_FILENAME_PATTERN);
      page.verifyFileDownloadedSuccessfully(fileName);
    });
  }

  @When("Recovery User - Clear the TID filter on Failed Pickup Management page")
  public void doClearTIDFilter() {
    failedPickupManagementPage.inFrame(page -> {
      page.fpmTable.clearTIDFilter();
    });
  }
}
