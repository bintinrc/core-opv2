package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.selenium.page.FailedDeliveryManagementPageV2;
import co.nvqa.operator_v2.selenium.page.FailedDeliveryManagementPageV2.FailedDeliveryTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;

public class FailedDeliveryManagementStepsV2 extends AbstractSteps {

  private FailedDeliveryManagementPageV2 failedDeliveryManagementReactPage;

  public FailedDeliveryManagementStepsV2() {
  }

  @Override
  public void init() {
    failedDeliveryManagementReactPage = new FailedDeliveryManagementPageV2(getWebDriver());
  }

  @When("Recovery User - Search failed orders by trackingId = {string}")
  public void doFilterByTrackingId(String trackingId) {
    failedDeliveryManagementReactPage.waitUntilHeaderShown();
    failedDeliveryManagementReactPage.inFrame(
        page -> page.fdmTable.filterTableByTID("trackingId", resolveValue(trackingId)));
  }

  @When("Recovery User - Search failed orders by shipperName = {string}")
  public void doFilterByShipperId(String shipperName) {
    failedDeliveryManagementReactPage.waitUntilHeaderShown();
    failedDeliveryManagementReactPage.inFrame(
        page -> page.fdmTable.filterTableByShipperName("shipperName", resolveValue(shipperName)));
  }

  @Then("Recovery User - verify failed delivery table on FDM page:")
  public void doverifyFdmTable(Map<String, String> dataTable) {
    FailedDelivery expected = new FailedDelivery(resolveKeyValues(dataTable));

    failedDeliveryManagementReactPage.inFrame(page -> {
      page.waitUntilLoaded(1);
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
      page.waitUntilHeaderShown();
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
    failedDeliveryManagementReactPage.waitUntilHeaderShown();
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
  public void operatorVerifyCsvFileOfFailedDeliveryOrderOnFailedDeliveryOrdersListDownloadedSuccessfully() {
    List<FailedDelivery> expected = get(KEY_LIST_OF_FAILED_DELIVERY_ORDER);
    failedDeliveryManagementReactPage.verifyDownloadedCsvFile(expected);

  }
  @Then("Recovery User - Save value of selected failed delivery order")
  public void doSaveValueOfSelectedFailedDeliveryOrder() {
    List<FailedDelivery> failedDeliveries = failedDeliveryManagementReactPage.fdmTable.readAllEntities();
    put(KEY_LIST_OF_FAILED_DELIVERY_ORDER, failedDeliveries);
  }
}
